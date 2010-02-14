Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweblb06fl.versatel.de ([89.246.255.250]:37332 "EHLO
	mxweblb06fl.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab0BNL5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 06:57:42 -0500
Received: from ens28fl.versatel.de (ens28fl.versatel.de [82.140.32.10])
	by mxweblb06fl.versatel.de (8.13.1/8.13.1) with ESMTP id o1EBveKj028696
	for <linux-media@vger.kernel.org>; Sun, 14 Feb 2010 12:57:40 +0100
Received: from cinnamon-sage.de (i577A4430.versanet.de [87.122.68.48])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id o1EBvf8X003322
	for <linux-media@vger.kernel.org>; Sun, 14 Feb 2010 12:57:41 +0100
Received: from 192.168.23.2:49413 by cinnamon-sage.de for <linux-media@vger.kernel.org> ; 14.02.2010 12:57:40
Message-ID: <4B77E533.60301@cinnamon-sage.de>
Date: Sun, 14 Feb 2010 12:57:39 +0100
From: Lars Hanisch <dvb@cinnamon-sage.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] add missing 'p' at card name 'Hauppauge HD PVR'
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I don't know if there are applications which rely on this name,
but after all it's a spelling mistake.

Signed-off-by: Lars Hanisch <dvb@cinnamon-sage.de>
---
  drivers/media/video/hdpvr/hdpvr-video.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 1c49c07..196f82d 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -573,7 +573,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
  	struct hdpvr_device *dev = video_drvdata(file);

  	strcpy(cap->driver, "hdpvr");
-	strcpy(cap->card, "Haupauge HD PVR");
+	strcpy(cap->card, "Hauppauge HD PVR");
  	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
  	cap->version = HDPVR_VERSION;
  	cap->capabilities =     V4L2_CAP_VIDEO_CAPTURE |
-- 
1.6.3.3
