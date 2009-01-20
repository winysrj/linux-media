Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:52073 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbZATWJP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 17:09:15 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 51C32CDC2F5
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:43:46 +0100 (CET)
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 8811894009A
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:42:34 +0100 (CET)
Received: from [192.168.1.151] (unknown [78.226.152.136])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 88A0A940078
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:42:32 +0100 (CET)
Message-ID: <49764549.7050105@free.fr>
Date: Tue, 20 Jan 2009 22:42:33 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] s2255drv: use usb_make_path to report bus info
References: <49764412.8030305@free.fr>
In-Reply-To: <49764412.8030305@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_make_path reports canonical bus info. Use it when reporting bus info
in VIDIOC_QUERYCAP.

Signed-off-by: Thierry MERLE <thierry.merle@free.fr>

diff -r 43bb285afc52 -r 6adb3130678d linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Tue Jan 20 22:13:45 2009 +0100
+++ b/linux/drivers/media/video/s2255drv.c	Tue Jan 20 22:19:25 2009 +0100
@@ -842,8 +842,7 @@
 	struct s2255_dev *dev = fh->dev;
 	strlcpy(cap->driver, "s2255", sizeof(cap->driver));
 	strlcpy(cap->card, "s2255", sizeof(cap->card));
-	strlcpy(cap->bus_info, dev_name(&dev->udev->dev),
-		sizeof(cap->bus_info));
+	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->version = S2255_VERSION;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	return 0;
