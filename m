Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:42082 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZATWAn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 17:00:43 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 4055CCDC299
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:42:41 +0100 (CET)
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 1E64E8180DC
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:41:34 +0100 (CET)
Received: from [192.168.1.151] (unknown [78.226.152.136])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 19B13818076
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:41:32 +0100 (CET)
Message-ID: <4976450C.2040601@free.fr>
Date: Tue, 20 Jan 2009 22:41:32 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] uvcvideo: use usb_make_path to report bus info
References: <49764412.8030305@free.fr>
In-Reply-To: <49764412.8030305@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_make_path reports canonical bus info. Use it when reporting bus info
in VIDIOC_QUERYCAP.

Signed-off-by: Thierry MERLE <thierry.merle@free.fr>

diff -r 72ba48adaacd -r 43bb285afc52 linux/drivers/media/video/uvc/uvc_v4l2.c
--- a/linux/drivers/media/video/uvc/uvc_v4l2.c	Tue Jan 20 22:06:58 2009 +0100
+++ b/linux/drivers/media/video/uvc/uvc_v4l2.c	Tue Jan 20 22:13:45 2009 +0100
@@ -494,8 +494,7 @@
 		memset(cap, 0, sizeof *cap);
 		strncpy(cap->driver, "uvcvideo", sizeof cap->driver);
 		strncpy(cap->card, vdev->name, 32);
-		strncpy(cap->bus_info, video->dev->udev->bus->bus_name,
-			sizeof cap->bus_info);
+		usb_make_path(video->dev->udev, cap->bus_info, sizeof(cap->bus_info));
 		cap->version = DRIVER_VERSION_NUMBER;
 		if (video->streaming->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 			cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
