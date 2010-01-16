Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:58849 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0APIMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 03:12:36 -0500
Message-ID: <4B51749B.30902@freemail.hu>
Date: Sat, 16 Jan 2010 09:11:07 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: mjpeg-users@lists.sourceforge.net,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] zoran: cleanup pointer condition
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Remove the following sparse warning (see "make C=1"):
 * warning: Using plain integer as NULL pointer

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 5bcdcc072b6d linux/drivers/media/video/zoran/zoran_driver.c
--- a/linux/drivers/media/video/zoran/zoran_driver.c	Sat Jan 16 07:25:43 2010 +0100
+++ b/linux/drivers/media/video/zoran/zoran_driver.c	Sat Jan 16 09:03:31 2010 +0100
@@ -325,7 +325,7 @@
 		/* Allocate fragment table for this buffer */

 		mem = (void *)get_zeroed_page(GFP_KERNEL);
-		if (mem == 0) {
+		if (!mem) {
 			dprintk(1,
 				KERN_ERR
 				"%s: %s - get_zeroed_page (frag_tab) failed for buffer %d\n",
