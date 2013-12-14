Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1482 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3LNL26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 06:28:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 11/15] saa7134: drop log_status for radio.
Date: Sat, 14 Dec 2013 12:28:33 +0100
Message-Id: <1387020517-26242-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
References: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There are no controls for the radio node, so just drop support for this ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 2334bf9..88e6405 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2125,7 +2125,6 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner		= radio_s_tuner,
 	.vidioc_g_frequency	= saa7134_g_frequency,
 	.vidioc_s_frequency	= saa7134_s_frequency,
-	.vidioc_log_status	= v4l2_ctrl_log_status,
 	.vidioc_subscribe_event	= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
-- 
1.8.4.3

