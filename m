Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59349 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751314AbZGKGD1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jul 2009 02:03:27 -0400
From: Nils Kassube <kassube@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: Fix for crash in dvb-usb-af9015
Date: Sat, 11 Jul 2009 08:02:41 +0200
Cc: linux-media@vger.kernel.org
References: <200907071232.00459.kassube@gmx.net> <200907071634.00168.kassube@gmx.net> <4A57D371.4070307@iki.fi>
In-Reply-To: <4A57D371.4070307@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907110802.42115.kassube@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari wrote:
> I need your signed off by tag in order to forward this mainline.
> Patch is correct and I tested it also.

OK, here it is again with the requested line. And thanks for taking care
of the issue.

Signed-off-by: Nils Kassube <kassube@gmx.net>
---
--- orig/linux-2.6.31/drivers/media/dvb/dvb-usb/af9015.c	2009-06-30 11:34:45.000000000 +0200
+++ linux-2.6.31/drivers/media/dvb/dvb-usb/af9015.c	2009-07-07 14:58:27.000000000 +0200
@@ -81,7 +81,6 @@
 
 	switch (req->cmd) {
 	case GET_CONFIG:
-	case BOOT:
 	case READ_MEMORY:
 	case RECONNECT_USB:
 	case GET_IR_CODE:
@@ -100,6 +99,7 @@
 	case WRITE_VIRTUAL_MEMORY:
 	case COPY_FIRMWARE:
 	case DOWNLOAD_FIRMWARE:
+	case BOOT:
 		break;
 	default:
 		err("unknown command:%d", req->cmd);

