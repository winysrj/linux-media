Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:35566 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752607Ab1CFVTp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 16:19:45 -0500
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] v4l-utils: change keymap to better reflect key names on imon_mce remote
Date: Sun, 6 Mar 2011 22:19:41 +0100
Cc: mchehab@infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103062219.41753.hfvogt@gmx.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

v4l-utils: the key definitions in the imon_mce keymap do not currently reflect
well the names printed on the remote:
key on remote is named "back", but keymap uses "exit",
key on remote is named "Teletext", but keymap uses "subtitle"
In addition, I think that "menu" is rather representative to the key
named "DVD menu" than just "DVD"
Please change the keymap as proposed in my patch. It applies on top of
my patch 1/2 as of today which removes doublicates in the imon_mce keymap.

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 imon_mce |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/utils/keytable/rc_keymaps/imon_mce	2011-03-06 21:47:10.527674607 
+0100
+++ b/utils/keytable/rc_keymaps/imon_mce	2011-03-06 19:26:06.263297972 +0100
@@ -18,7 +18,7 @@
 0x800ff40b KEY_ENTER
 0x02000028 KEY_OK
 0x800ff422 KEY_OK
-0x0200002a KEY_EXIT
+0x0200002a KEY_BACK
 0x800ff423 KEY_EXIT
 0x02000029 KEY_DELETE
 0x800ff40a KEY_DELETE
@@ -56,7 +56,7 @@
 0x800ff448 KEY_PVR
 0x800ff449 KEY_CAMERA
 0x800ff44a KEY_VIDEO
-0x800ff424 KEY_DVD
+0x800ff424 KEY_MENU
 0x800ff425 KEY_TUNER
 0x800ff450 KEY_RADIO
 0x800ff44c KEY_LANGUAGE
@@ -70,7 +70,7 @@
 0x800ff41d KEY_BLUE
 0x800ff40f KEY_INFO
 0x800ff426 KEY_EPG
-0x800ff45a KEY_SUBTITLE
+0x800ff45a KEY_TEXT
 0x800ff44d KEY_TITLE
 0x800ff40c KEY_POWER
 0x800ff40d KEY_LEFTMETA

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
