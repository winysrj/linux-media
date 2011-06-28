Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:48701 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab1F1OX0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 10:23:26 -0400
Received: from mail1.matrix-vision.com (localhost [127.0.0.1])
	by mail1.matrix-vision.com (Postfix) with ESMTP id B0C98722B2
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 16:23:24 +0200 (CEST)
Received: from erinome (g2.matrix-vision.com [80.152.136.245])
	by mail1.matrix-vision.com (Postfix) with ESMTPA id 8355072232
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 16:23:24 +0200 (CEST)
Received: from erinome (localhost [127.0.0.1])
	by erinome (Postfix) with ESMTP id DD64C6F8A
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 16:23:23 +0200 (CEST)
Received: from ap437-joe.intern.matrix-vision.de (host65-46.intern.matrix-vision.de [192.168.65.46])
	by erinome (Postfix) with ESMTPA id C278B6F8A
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 16:23:23 +0200 (CEST)
From: Michael Jones <michael.jones@matrix-vision.de>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH] capture-example: allow V4L2_PIX_FMT_GREY with USERPTR
Date: Tue, 28 Jun 2011 16:23:18 +0200
Message-Id: <1309270998-5070-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There is an assumption that the format coming from the device
needs 2 bytes per pixel, which is not the case when the device
delivers e.g. V4L2_PIX_FMT_GREY. This doesn't manifest itself with
IO_METHOD_MMAP because init_mmap() (the default) doesn't take
sizeimage as an argument.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---

This same issue would apply to other formats which have 1 byte per pixel,
this patch only fixes it for GREY.  Is this OK for now, or does somebody
have a better suggestion for supporting other formats as well?

 contrib/test/capture-example.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/contrib/test/capture-example.c b/contrib/test/capture-example.c
index 3852c58..0eb5235 100644
--- a/contrib/test/capture-example.c
+++ b/contrib/test/capture-example.c
@@ -416,6 +416,7 @@ static void init_device(void)
 	struct v4l2_crop crop;
 	struct v4l2_format fmt;
 	unsigned int min;
+	unsigned int bytes_per_pixel;
 
 	if (-1 == xioctl(fd, VIDIOC_QUERYCAP, &cap)) {
 		if (EINVAL == errno) {
@@ -519,7 +520,8 @@ static void init_device(void)
 	}
 
 	/* Buggy driver paranoia. */
-	min = fmt.fmt.pix.width * 2;
+	bytes_per_pixel = fmt.fmt.pix.pixelformat == V4L2_PIX_FMT_GREY ? 1 : 2;
+	min = fmt.fmt.pix.width * bytes_per_pixel;
 	if (fmt.fmt.pix.bytesperline < min)
 		fmt.fmt.pix.bytesperline = min;
 	min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
-- 
1.7.5.4


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
