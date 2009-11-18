Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52685 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbZKRAix (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: hdpvr: Replace video_is_unregistered with video_is_registered
Date: Wed, 18 Nov 2009 01:38:46 +0100
Message-Id: <1258504731-8430-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the hdpvr driver to use the video_is_registered function instead of
video_is_unregistered.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc-uvc/linux/drivers/media/video/hdpvr/hdpvr-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/hdpvr/hdpvr-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/hdpvr/hdpvr-video.c
@@ -519,7 +519,7 @@ static unsigned int hdpvr_poll(struct fi
 
 	mutex_lock(&dev->io_mutex);
 
-	if (video_is_unregistered(dev->video_dev)) {
+	if (!video_is_registered(dev->video_dev)) {
 		mutex_unlock(&dev->io_mutex);
 		return -EIO;
 	}
