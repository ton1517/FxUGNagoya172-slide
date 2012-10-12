FxUG 第172回 勉強会＠名古屋
===========================

ActionScriptCompiler2.0 について
==================================

[@ton1517](https://twitter.com/ton1517)

こんにちは
==========
tonです
![ton1517 icon](images/profile_icon.png)
[Twitter: @ton1517](https://twitter.com/ton1517)


ActionScriptCompiler2.0挙動と新機能について話します
=============================================================
このスライドはActionScriptCompiler2.0 Preview3

時点の情報を元にしています


ActionScriptCompiler2.0って？
==============================
長いからASC2.0って言うね

ASC2.0とは
----------
* 元々Falconと呼ばれていた新しいActionScriptコンパイラを元にAdobeが開発したもの

Falconコンパイラは現在Apacheに寄贈されオープンソースとして公開されています

#### *-check-* 
[GitHub Mirror of Apache Flex Falcon](https://github.com/apache/flex-falcon)

今までのと何がちがうの？
------------------------
* コードのチェックをより厳格に
* コンパイルをより速く
* 少ないメモリでも安定動作
* より最適化されたswfを生成

#### *-check-* 
[Adobe ActionScript Compiler 2.0 Release Notes](http://labsdownload.adobe.com/pub/labs/flashplatformruntimes/air3-4/air3-4_p3_sdk_asc2_releasenotes.pdf)

ASC2.0を使うには？
------------------------------
[FlashBuilder4.7 Beta](http://www.adobe.com/cfusion/entitlement/index.cfm?e=labs_flashbuilder4-7)
をダウンロードしましょう。Betaなので誰でも無料で使えます。

FB4.7にはASC2.0が同梱されておりデフォルトのコンパイラとなっている

注意
----
* バグがまだ多い
* mxmlの実装はApache側のためまだまだ未実装
* AS3の挙動が一部異なる


ASC2.0でのAS3の挙動の変更点
===========================
コードの厳格化や最適化のために一部挙動が変更された

変更点
-------------
* public,protected,private,default,internal,gotoがキーワードとして扱われる
* 変数名の重複に対して厳格に
* 定数の最適化、厳格化
* その他多数...

いくつかピックアップしてみていきましょう

#### *-check-* 
[ActionScript Compiler 2.0 Backward Compatibility](http://helpx.adobe.com/flash-builder/actionscript-compiler-backward-compatibility.html)

[ActionScript の新しいコンパイラ ASC 2.0 の変更点一覧](http://cuaoar.jp/2012/08/actionscript-asc-20.html)

新たなキーワード
--------------------------------------
public,protected,private,default,internal,goto

* 旧 : これらは変数名としても使用出来る
* 新 : 変数名として使用できない

#### *-example-*
    var mc:MovieClip = new MovieClip();
    mc.public = "publicだよ";
    mc.protected = "protectedだよ";
    mc.private = "privateだよ";
    mc.default = "defaultだよ";
    var internal:String = "internal";
    var goto:String = "goto";

変数の重複 1
------------
関数の引数とローカル変数の重複を警告

* 旧 : 警告なし
* 新 : 警告される

#### *-example-*
    function duplicate1 (foo:String):void {
        var foo:String = "hugahuga";
        trace(foo); 
    }

変数の重複 2
------------
関数の引数とローカル定数の重複を禁止

* 旧 : コンパイルされる
* 新 : コンパイルエラー

#### *-example-*
    function duplicate2 (foo:String):void {
        const foo:String = "hugahuga";
        trace(foo);
    }

変数の重複 3
------------
forループ内での変数と定数の重複

* 旧 : コンパイルされる
* 新 : コンパイルエラー

#### *-example-*
    for(var i:int = 0; i < 3; i++){
        const i:int = 100;
        trace(i); 
    }

変数の重複
----------
ASC2.0では

* 全ての重複した定義を警告
    * 旧 : 2つ目以降から警告
* constとvarの重複の禁止
    * 旧 :エラーにならない。varはconstで上書きされる

名前空間
--------
異なる名前空間で同名の名前をつけられるように

* 旧 : コンパイルエラー
* 新 : コンパイルされる

#### *-example-*
    public function namespaceTest():void {
        trace("public namespace");
    }
    private function namespaceTest():void {
        trace("private namespace");
    }

Vector
------
Vectorの型指定は1つのみ

複数指定した場合は

* 旧 : 2つ目以降無視してコンパイルされる
* 新 : 文法エラー

#### *-example-*
    var vec:Vector.<int, String, ASC2Test>;
    vec = new Vector.<int, String, ASC2Test>();

定数のインクリメント
-------------------
定数のインクリメントとデクリメントの禁止

* 旧 : 定数でもインクリメントできる
* 新 : コンパイルエラー

#### *-example-*
    const i:int = 1;
    i++;


ローカル定数の初期化
--------------------
ローカル定数の初期化タイミングが変更

* 旧 : 宣言された行が実行されるタイミングで初期化
* 新 : 宣言されたスコープに入ったタイミングで初期化

#### *-example-*
    var hoge:int = foo;
    const foo:int = 10;
    hoge += foo;
    trace(hoge); 

定数の評価
----------
多くの定数がコンパイル時に評価されるように

* 旧 : 多くが実行時に評価
* 新 : 多くがコンパイル時に評価

#### *-example-*
    public static const NUM:int = 10 + 20;

static constの初期化
--------------------
static constの初期化順序が変更

* 旧 : static constを持つクラスが呼ばれた時に初期化
* 新 : ドキュメントクラスが呼び出される前に初期化

複合代入演算子
--------------
複合代入演算子の左辺の評価は1度のみ

* 旧 : 左辺が2度評価される場合がある
* 新 : 左辺は1度のみ評価される

#### *-example-*
    var obj:Object = new Object();
    obj.a = 0;
    function getObj():Object {
        obj.a++;
        return obj;
    }
    getObj().a += 10;

条件式での代入
--------------
条件式での代入に対して警告

* 旧 : 警告なし
* 新 : 警告あり

#### *-example-*
    var x:int = 0;
    if(x = 3){
        trace(x);
    }

このくらいでいいよね・・・
-------------------------

次は、**インライン展開**
====================

インライン展開って？
===================

インライン展開とは
------------------
関数の中身をそこに直接書いちゃえっていう機能

こんな関数があるとき

    function hoge():void{ this.a = 10; }

普通に呼び出すと

    function test():void{ hoge(); }

インライン展開すると...

    function test():void{ this.a = 10; }

関数の中身がその場に展開される！

インライン展開される条件
-----------------------
インライン展開させるにはいろいろな条件を満たさなければいけません

#### *-check-*

[Introducing ASC 2.0](http://www.bytearraysorg/?p=4789)

[ASC2.0 のインライン化機能](http://cuaoar.jp/2012/08/asc20-actionscript.html)

1. -inline コンパイラ引数
-------------------------
-inline という文字列をコンパイラ引数に追加してください

これがないと絶対にインライン展開してくれません

2. [Inline] メタタグ
--------------------
関数宣言の直前に [Inline] メタタグをつける

getter/setterは[Inline]タグがなくてもインライン展開可能

　
------
#### *-example-*
    final public function get hoge():Number{
        trace("この関数はインライン展開できます");
        return _hoge;
    }
    final public function cannotInline():void{
        trace("この関数はインライン展開されません");
    }
    [Inline]
    final public function canInline():void{
        trace("この関数はインライン展開できます");
    }

3. final/static修飾子
---------------------
インライン展開させたい関数/アクセサには必ずfinal修飾子かstatic修飾子をつける

　
------
#### *-example-*
    public function get hoge():Number{
        trace("この関数はインライン展開されません");
        return _hoge;
    }
    [Inline]
    public function cannotInline():void{
        trace("この関数はインライン展開されません");
    }
    [Inline]
    static public function canInline():void{
        trace("この関数はインライン展開できます");
    }


ex. final class の場合
-----------------------
クラスがfinalになっている場合、メソッドやアクセサにfinal/static修飾子をつけなくても
インライン展開される

ただしメソッドに[Inline]メタタグは必要


4. ネストされた関数を持ってはいけない
------------------------------------
* 他のアクティベーションオブジェクトを持ってはいけない
* 関数クロージャを持ってはいけない

ということらしい

要するにネストされた関数はダメってこと(多分)

　
------
#### *-example-*
    //インライン展開できません
    [Inline]
    final public function cannotInline():void{
        var aa:Number = 10;
         
        var f:Function = function():void{
            trace(aa);
        }
         
        f();
    }

　
------
#### *-example-*
    //これもダメです
    [Inline]
    final public function cannotInline2():void{
        function buta():void{
            trace("インライン展開できないよ");
        }
         
        buta();
    }

　
------
#### *-example-*
    private function methodHoge():void{
        trace("ただのメソッドです");
    }
     
    //他のメソッドを呼ぶだけならインライン展開可能
    [Inline]
    final public function canInline():void{
        trace("インライン展開できます");
        methodHoge();
    }

5. try-catch文を含めない
------------------------
関数の中にtry-catch文があるとインライン展開されません

#### *-example-*
    [Inline]
    final public function tryTest():void{
        try{
            throw new Error("インライン展開できません");
        }catch(e:Error){
            trace(e.getStackTrace());
        }
    }

6. with文を含めない
-------------------
with文を持つ関数はインライン展開できません
#### *-example-*
    [Inline]
    final public function tryWith():void{
        with(graphics){
            beginFill(0x0077ff);
            drawCircle(10, 10, 50);
            endFill();
        }
    }

7. 関数の中身のABCの行数が50以下であること
------------------------------------------
コンパイルした際のActionScriptByteCode(ABC)の行数が50以上になると
インライン展開されなくなります

*************************
### ASC2.0 Preview 3 から
[Inline]タグをつけた場合この制限は無視され、どんな大きい関数でもインライン展開される

8. サブクラスまたはインターフェース経由で呼び出さない
-----------------------------------------------
サブクラスまたはインターフェース経由で呼び出した場合はインライン展開されません

#### *-example-*
    //これはインライン展開されます
    var test2:ExInline = new ExInline();
    test2.hoge();
     
    //これはインターフェース経由で呼び出しているのでインライン展開されません
    var test:IInline = new ExInline();
    test.hoge();

とりあえず気をつけとくこと
--------------------------

* -inline コンパイラオプションを忘れずに
* final修飾子と[Inline]タグをつける

このくらい

速度比較
--------
デモ。時間あれば


ASC2.0楽しいよ！
===============
Monocleまだー？


GitHub
------
このスライドはGitHubで公開しています。

[https://github.com/ton1517/FxUGNagoya172-slide](https://github.com/ton1517/FxUGNagoya172-slide)

[http://ton1517.github.com/FxUGNagoya172-slide/](http://ton1517.github.com/FxUGNagoya172-slide/)
