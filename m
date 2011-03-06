Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:56502 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754435Ab1CFVHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 16:07:16 -0500
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] v4l-utils: remove conflicting definitions in keymap for imon_mce
Date: Sun, 6 Mar 2011 22:07:07 +0100
Cc: mchehab@infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103062207.07520.hfvogt@gmx.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

v4l-utils: Trivial patch that removes doublicate and conflicting definitions of 
keys. The patch is checked against a git pull of today.

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 imon_mce |    2 --
 1 file changed, 2 deletions(-)

--- a/utils/keytable/rc_keymaps/imon_mce	2011-02-19 19:04:44.974793906 
+0100
+++ b/utils/keytable/rc_keymaps/imon_mce	2011-03-06 21:47:10.527674607 +0100
@@ -16,7 +16,6 @@
 0x800ff420 KEY_LEFT
 0x800ff421 KEY_RIGHT
 0x800ff40b KEY_ENTER
-0x02000028 KEY_ENTER
 0x02000028 KEY_OK
 0x800ff422 KEY_OK
 0x0200002a KEY_EXIT
@@ -67,7 +66,6 @@
 0x800ff45d KEY_YELLOW
 0x800ff45e KEY_BLUE
 0x800ff466 KEY_RED
-0x800ff425 KEY_GREEN
 0x800ff468 KEY_YELLOW
 0x800ff41d KEY_BLUE
 0x800ff40f KEY_INFO


Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
