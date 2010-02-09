Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:36860 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0BIHsM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 02:48:12 -0500
Received: by ewy28 with SMTP id 28so3478285ewy.28
        for <linux-media@vger.kernel.org>; Mon, 08 Feb 2010 23:48:11 -0800 (PST)
Date: Tue, 9 Feb 2010 16:48:31 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Fix compilation tm6000 module
Message-ID: <20100209164831.61d26b47@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/7Bi0anQT0b.sBu616i8eIos"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/7Bi0anQT0b.sBu616i8eIos
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

Fix compilation tm6000 module.

diff -r 690055993011 linux/drivers/staging/tm6000/tm6000-cards.c
--- a/linux/drivers/staging/tm6000/tm6000-cards.c	Sun Feb 07 22:26:10 2010 -0200
+++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Tue Feb 09 10:44:14 2010 +0900
@@ -45,6 +45,8 @@
 #define TM6000_BOARD_FREECOM_AND_SIMILAR	7
 #define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
 #define TM6010_BOARD_HAUPPAUGE_900H		9
+#define TM6010_BOARD_BEHOLD_WANDER		10
+#define TM6010_BOARD_BEHOLD_VOYAGER		11
 
 #define TM6000_MAXBOARDS        16
 static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/7Bi0anQT0b.sBu616i8eIos
Content-Type: text/x-patch; name=beholdtv_1.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=beholdtv_1.patch

diff -r 690055993011 linux/drivers/staging/tm6000/tm6000-cards.c
--- a/linux/drivers/staging/tm6000/tm6000-cards.c	Sun Feb 07 22:26:10 2010 -0200
+++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Tue Feb 09 10:44:14 2010 +0900
@@ -45,6 +45,8 @@
 #define TM6000_BOARD_FREECOM_AND_SIMILAR	7
 #define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
 #define TM6010_BOARD_HAUPPAUGE_900H		9
+#define TM6010_BOARD_BEHOLD_WANDER		10
+#define TM6010_BOARD_BEHOLD_VOYAGER		11
 
 #define TM6000_MAXBOARDS        16
 static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/7Bi0anQT0b.sBu616i8eIos--
