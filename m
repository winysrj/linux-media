Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4881 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966111Ab3E2OTk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 14/14] cx23885: don't implement querystd if it doesn't do anything.
Date: Wed, 29 May 2013 16:19:07 +0200
Message-Id: <1369837147-8747-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

cx23885 redirects querystd to g_std. That's pointless, just drop querystd
support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c   |    1 -
 drivers/media/pci/cx23885/cx23885-video.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 6dea11a..0a5f81d 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1661,7 +1661,6 @@ static struct v4l2_file_operations mpeg_fops = {
 };
 
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
-	.vidioc_querystd	 = vidioc_g_std,
 	.vidioc_g_std		 = vidioc_g_std,
 	.vidioc_s_std		 = vidioc_s_std,
 	.vidioc_enum_input	 = vidioc_enum_input,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ed08c89..776e553 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1743,7 +1743,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_dqbuf         = vidioc_dqbuf,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_g_std         = vidioc_g_std,
-	.vidioc_querystd      = vidioc_g_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
-- 
1.7.10.4

