Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:34657 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1GRKBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 06:01:22 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] capture-example: don't use bytesperline when allocating buffers
Date: Mon, 18 Jul 2011 12:00:10 +0200
Message-Id: <1310983210-30769-1-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <4E1ECB5F.8030308@redhat.com>
References: <4E1ECB5F.8030308@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This removes "buggy driver paranoia", which set sizeimage equal to
at least width * height * 2. This was a false assumption when the
pixel format only required 1 byte per pixel. Originally, the
paranoia was in place to handle drivers which incorrectly set
sizeimage=0, but these seem to have been fixed.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 contrib/test/capture-example.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/contrib/test/capture-example.c b/contrib/test/capture-example.c
index 2f77cbf..417615a 100644
--- a/contrib/test/capture-example.c
+++ b/contrib/test/capture-example.c
@@ -498,14 +498,6 @@ static void init_device(void)
 			errno_exit("VIDIOC_G_FMT");
 	}
 
-	/* Buggy driver paranoia. */
-	min = fmt.fmt.pix.width * 2;
-	if (fmt.fmt.pix.bytesperline < min)
-		fmt.fmt.pix.bytesperline = min;
-	min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
-	if (fmt.fmt.pix.sizeimage < min)
-		fmt.fmt.pix.sizeimage = min;
-
 	switch (io) {
 	case IO_METHOD_READ:
 		init_read(fmt.fmt.pix.sizeimage);
-- 
1.7.5.4


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
