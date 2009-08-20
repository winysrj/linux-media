Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:53188 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688AbZHTBiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 21:38:51 -0400
Received: from mail-in-01-z2.arcor-online.net (mail-in-01-z2.arcor-online.net [151.189.8.13])
	by mx.arcor.de (Postfix) with ESMTP id BF65128AD4D
	for <linux-media@vger.kernel.org>; Thu, 20 Aug 2009 03:38:51 +0200 (CEST)
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net [151.189.21.51])
	by mail-in-01-z2.arcor-online.net (Postfix) with ESMTP id B70502BF6A5
	for <linux-media@vger.kernel.org>; Thu, 20 Aug 2009 03:38:51 +0200 (CEST)
Received: from [192.168.178.24] (pD9E105E3.dip0.t-ipconnect.de [217.225.5.227])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-11.arcor-online.net (Postfix) with ESMTPSA id 8F810E396A
	for <linux-media@vger.kernel.org>; Thu, 20 Aug 2009 03:38:51 +0200 (CEST)
Subject: [PATCH] saa7134-input: don't probe for the Pinnacle remotes anymore
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-+HJcyzpmwvU2uFnGuZCN"
Date: Thu, 20 Aug 2009 03:30:58 +0200
Message-Id: <1250731858.3251.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-+HJcyzpmwvU2uFnGuZCN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


With the recent improvements we don't need to probe anymore, if we know
the i2c address of the receiver.

The address of the receiver for the remote with the gray buttons is not
confirmed anywhere, but it is very unlikely to see it on something else.

We want to have that information anyway.

BTW, those remaining still probing, please join.

Signed-off-by: hermann pitton <hermann-pitton@arcor.de>

diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Aug 20 00:56:31 2009 +0200
@@ -782,6 +782,7 @@
 #else
 			init_data.get_key = get_key_pinnacle_color;
 			init_data.ir_codes = ir_codes_pinnacle_color;
+			info.addr = 0x47;
 #endif
 		} else {
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
@@ -790,6 +791,7 @@
 #else
 			init_data.get_key = get_key_pinnacle_grey;
 			init_data.ir_codes = ir_codes_pinnacle_grey;
+			info.addr = 0x47;
 #endif
 		}
 		break;

--=-+HJcyzpmwvU2uFnGuZCN
Content-Disposition: inline; filename=saa7134-input_do-not-probe-for-the-pinnacle-remotes.patch
Content-Type: text/x-patch; name=saa7134-input_do-not-probe-for-the-pinnacle-remotes.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Aug 16 21:53:17 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Aug 20 00:56:31 2009 +0200
@@ -782,6 +782,7 @@
 #else
 			init_data.get_key = get_key_pinnacle_color;
 			init_data.ir_codes = ir_codes_pinnacle_color;
+			info.addr = 0x47;
 #endif
 		} else {
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
@@ -790,6 +791,7 @@
 #else
 			init_data.get_key = get_key_pinnacle_grey;
 			init_data.ir_codes = ir_codes_pinnacle_grey;
+			info.addr = 0x47;
 #endif
 		}
 		break;

--=-+HJcyzpmwvU2uFnGuZCN--

