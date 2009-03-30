Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2352 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZC3QgG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 12:36:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mike Krufky <mkrufky@linuxtv.org>
Subject: Patch for 2.6.29 stable series: remove #ifdef MODULE nonsense
Date: Mon, 30 Mar 2009 18:35:54 +0200
Cc: Mark Lord <lkml@rtr.ca>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rTP0JXzdujXXbw/"
Message-Id: <200903301835.55023.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_rTP0JXzdujXXbw/
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Mike,

The attached patch should be queued for 2.6.29.X. It corresponds to 
changeset 11098 (v4l2-common: remove incorrect MODULE test) in our v4l-dvb 
tree and is part of the initial set of git patches going into 2.6.30.

Without this patch loading ivtv as a module while v4l2-common is compiled 
into the kernel will cause a delayed load of the i2c modules that ivtv 
needs since request_module is never called directly.

While it is nice to see the delayed load in action, it is not so nice in 
that ivtv fails to do a lot of necessary i2c initializations and will oops 
later on with a division-by-zero.

Thanks to Mark Lord for reporting this and helping me figure out what was 
wrong.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--Boundary-00=_rTP0JXzdujXXbw/
Content-Type: text/x-diff;
  charset="utf-8";
  name="v4l2-common.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="v4l2-common.c.diff"

--- drivers/media/video/v4l2-common.c.orig	2009-03-30 18:25:24.000000000 +0200
+++ drivers/media/video/v4l2-common.c	2009-03-30 18:27:04.000000000 +0200
@@ -910,10 +910,10 @@
 	struct i2c_board_info info;
 
 	BUG_ON(!dev);
-#ifdef MODULE
+
 	if (module_name)
 		request_module(module_name);
-#endif
+
 	/* Setup the i2c board info with the device type and
 	   the device address. */
 	memset(&info, 0, sizeof(info));
@@ -958,10 +958,10 @@
 	struct i2c_board_info info;
 
 	BUG_ON(!dev);
-#ifdef MODULE
+
 	if (module_name)
 		request_module(module_name);
-#endif
+
 	/* Setup the i2c board info with the device type and
 	   the device address. */
 	memset(&info, 0, sizeof(info));

--Boundary-00=_rTP0JXzdujXXbw/--
