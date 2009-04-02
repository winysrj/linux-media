Return-path: <linux-media-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:52294 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758486AbZDBHk1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2009 03:40:27 -0400
Message-Id: <200904020643.n326hcTm009426@x200.localdomain>
Subject: patch v4l-v4l2-common-remove-incorrect-module-test.patch queued to 2.6.29.y-stable tree
To: mkrufky@linuxtv.org, chrisw@sous-sol.org, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl, linux-media@vger.kernel.org, lkml@rtr.ca,
	mchehab@redhat.com
Cc: stable@kernel.org, stable-commits@vger.kernel.org
From: chrisw@sous-sol.org
Date: Wed, 01 Apr 2009 23:43:38 -0700
In-Reply-To: <49D21938.3000907@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

     Subject: V4L: v4l2-common: remove incorrect MODULE test

to the 2.6.29.y-stable tree.  Its filename is

     v4l-v4l2-common-remove-incorrect-module-test.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From chrisw@hera.kernel.org  Wed Apr  1 23:18:58 2009
Message-ID: <49D21938.3000907@linuxtv.org>
Date: Tue, 31 Mar 2009 09:23:04 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: stable@kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: V4L: v4l2-common: remove incorrect MODULE test

From: Hans Verkuil <hverkuil@xs4all.nl>

upstream commit: d64260d58865004c6354e024da3450fdd607ea07

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/media/video/v4l2-common.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -910,10 +910,10 @@ struct v4l2_subdev *v4l2_i2c_new_subdev(
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
@@ -958,10 +958,10 @@ struct v4l2_subdev *v4l2_i2c_new_probed_
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


Patches currently in stable-queue which might be from mkrufky@linuxtv.org are

