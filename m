Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:1242 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886AbZCaNXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 09:23:16 -0400
Message-ID: <49D21938.3000907@linuxtv.org>
Date: Tue, 31 Mar 2009 09:23:04 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: stable@kernel.org
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [2.6.29.y PATCH] V4L: v4l2-common: remove incorrect MODULE test
Content-Type: multipart/mixed;
 boundary="------------020403040400090205040704"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020403040400090205040704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------020403040400090205040704
Content-Type: text/x-diff;
 name="0001-V4L-v4l2-common-remove-incorrect-MODULE-test.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-V4L-v4l2-common-remove-incorrect-MODULE-test.patch"

>From ba6b8068cf8f428f296762146cef6aafc4686f81 Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 18 Mar 2009 15:48:01 -0300
Subject: [PATCH] V4L: v4l2-common: remove incorrect MODULE test

v4l2-common doesn't have to be a module for it to call request_module().
Just remove that test.

Without this patch loading ivtv as a module while v4l2-common is compiled
into the kernel will cause a delayed load of the i2c modules that ivtv
needs since request_module is never called directly.

While it is nice to see the delayed load in action, it is not so nice in
that ivtv fails to do a lot of necessary i2c initializations and will oops
later on with a division-by-zero.

Thanks to Mark Lord for reporting this and helping me figure out what was
wrong.

Thanks-to: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Thanks-to: Mark Lord <lkml@rtr.ca>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
(cherry picked from commit d64260d58865004c6354e024da3450fdd607ea07)
---
 drivers/media/video/v4l2-common.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index b8f2be8..907cd02 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -910,10 +910,10 @@ struct v4l2_subdev *v4l2_i2c_new_subdev(struct i2c_adapter *adapter,
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
@@ -958,10 +958,10 @@ struct v4l2_subdev *v4l2_i2c_new_probed_subdev(struct i2c_adapter *adapter,
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
-- 
1.5.4.3


--------------020403040400090205040704--
