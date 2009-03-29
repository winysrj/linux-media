Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:33363 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757303AbZC2PAK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 11:00:10 -0400
Received: from localhost (unknown [78.52.195.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id 3C58D90002
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 16:59:48 +0200 (CEST)
Date: Sun, 29 Mar 2009 16:59:50 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 8 of 8] w9968cf: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329145950.GI17855@aniel>
References: <patchbomb.1238338474@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="w9968cf_usb_intf_v4l2_dev.diff"
In-Reply-To: <patchbomb.1238338474@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238338428 -7200
# Node ID fcd789d767ee307c25a006528bcd1b021d56b732
# Parent  9de2e49de0b75360d86b8fc444de057a485003c1
w9968cf: use usb_interface.dev for v4l2_device_register

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r 9de2e49de0b7 -r fcd789d767ee linux/drivers/media/video/w9968cf.c
--- a/linux/drivers/media/video/w9968cf.c	Sun Mar 29 16:53:48 2009 +0200
+++ b/linux/drivers/media/video/w9968cf.c	Sun Mar 29 16:53:48 2009 +0200
@@ -3454,7 +3454,7 @@
 	if (!cam)
 		return -ENOMEM;
 
-	err = v4l2_device_register(&udev->dev, &cam->v4l2_dev);
+	err = v4l2_device_register(&intf->dev, &cam->v4l2_dev);
 	if (err)
 		goto fail0;
 
