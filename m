Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:49219 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbZC2MoA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 08:44:00 -0400
Received: from localhost (unknown [78.52.195.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id 5F54290002
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 14:43:37 +0200 (CEST)
Date: Sun, 29 Mar 2009 14:43:39 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 6 of 6] w9968cf: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329124339.GG637@aniel>
References: <patchbomb.1238329154@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="v4l2_device_usb_interface-6.patch"
In-Reply-To: <patchbomb.1238329154@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238191413 -3600
# Node ID a37ea4c88edbaa73ef7a145986ab8f5c3ea9fa65
# Parent  16016db934ee03d0156754b8e07d4212c933d234
w9968cf: use usb_interface.dev for v4l2_device_register

From: Janne Grunau <j@jannau.net>

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r 16016db934ee -r a37ea4c88edb linux/drivers/media/video/w9968cf.c
--- a/linux/drivers/media/video/w9968cf.c	Fri Mar 27 22:57:05 2009 +0100
+++ b/linux/drivers/media/video/w9968cf.c	Fri Mar 27 23:03:33 2009 +0100
@@ -3454,7 +3454,7 @@
 	if (!cam)
 		return -ENOMEM;
 
-	err = v4l2_device_register(&udev->dev, &cam->v4l2_dev);
+	err = v4l2_device_register(&intf->dev, &cam->v4l2_dev);
 	if (err)
 		goto fail0;
 
