Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4204 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965093Ab3FTNpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 09:45:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 11/15] saa7134: drop log_status for radio.
Date: Thu, 20 Jun 2013 15:44:27 +0200
Message-Id: <1371735871-2658-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
References: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There are no controls for the radio node, so just drop support for this ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index a3b4fad..485f67d 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2124,7 +2124,6 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner		= radio_s_tuner,
 	.vidioc_g_frequency	= saa7134_g_frequency,
 	.vidioc_s_frequency	= saa7134_s_frequency,
-	.vidioc_log_status	= v4l2_ctrl_log_status,
 	.vidioc_subscribe_event	= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
-- 
1.8.3.1

