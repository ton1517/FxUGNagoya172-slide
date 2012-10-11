FxUG 第172回 勉強会＠名古屋
===========================

ActionScript Compiler 2.0 について
==================================

[@ton1517](https://twitter.com/ton1517)

こんにちは
=========
tonです。
![ton1517 logo](images/profile_icon.png)
[Twitter: @ton1517](https://twitter.com/ton1517)

ActionScript Compiler 2.0って？
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
をダウンロードしましょう。誰でもインストールできます。

FB4.7にはASC2.0が同梱されておりデフォルトのコンパイラとなっている

注意
----
* バグがまだ多い
* mxmlの実装はApache側のためまだまだ未実装
* AS3の挙動が一部異なる

