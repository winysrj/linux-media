Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1106 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3DNP1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 27/30] cx25821: prepare querycap for output support.
Date: Sun, 14 Apr 2013 17:27:23 +0200
Message-Id: <1365953246-8972-28-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index d3cf259..dca3391 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -719,7 +719,7 @@ static int cx25821_vidioc_querycap(struct file *file, void *priv,
 	struct cx25821_dev *dev = chan->dev;
 	const u32 cap_input = V4L2_CAP_VIDEO_CAPTURE |
 			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
-	const u32 cap_output = V4L2_CAP_VIDEO_OUTPUT;
+	const u32 cap_output = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_READWRITE;
 
 	strcpy(cap->driver, "cx25821");
 	strlcpy(cap->card, cx25821_boards[dev->board].name, sizeof(cap->card));
@@ -728,7 +728,7 @@ static int cx25821_vidioc_querycap(struct file *file, void *priv,
 		cap->device_caps = cap_output;
 	else
 		cap->device_caps = cap_input;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	cap->capabilities = cap_input | cap_output | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
1.7.10.4

