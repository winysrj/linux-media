Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:48833 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZATVzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 16:55:00 -0500
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 39B41CB47C7
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:40:23 +0100 (CET)
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id A481DD48194
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:39:39 +0100 (CET)
Received: from [192.168.1.151] (unknown [78.226.152.136])
	by smtp5-g21.free.fr (Postfix) with ESMTP id A5228D48114
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:39:36 +0100 (CET)
Message-ID: <49764499.20401@free.fr>
Date: Tue, 20 Jan 2009 22:39:37 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] em28xx: use usb_make_path to report bus info
References: <49764412.8030305@free.fr>
In-Reply-To: <49764412.8030305@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


usb_make_path reports canonical bus info. Use it when reporting bus info
in VIDIOC_QUERYCAP.

Signed-off-by: Thierry MERLE <thierry.merle@free.fr>

diff -r 306881b74bb9 -r 6ac9dc705aea linux/drivers/media/video/em28xx/em28xx-video.c
--- a/linux/drivers/media/video/em28xx/em28xx-video.c	Tue Jan 20 21:40:44 2009 +0100
+++ b/linux/drivers/media/video/em28xx/em28xx-video.c	Tue Jan 20 22:01:33 2009 +0100
@@ -1355,7 +1355,7 @@
 
 	strlcpy(cap->driver, "em28xx", sizeof(cap->driver));
 	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
-	strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));
+	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
 	cap->version = EM28XX_VERSION_CODE;
 
@@ -1543,7 +1543,7 @@
 
 	strlcpy(cap->driver, "em28xx", sizeof(cap->driver));
 	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
-	strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));
+	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
 	cap->version = EM28XX_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_TUNER;
