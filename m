Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4019 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3FCJha (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 11/13] saa7134: drop deprecated current_norm.
Date: Mon,  3 Jun 2013 11:36:48 +0200
Message-Id: <1370252210-4994-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since this driver properly implements g_std, the current_norm field is
actually unused anyway.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c |    1 -
 drivers/media/pci/saa7134/saa7134-video.c   |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 66a7081..826524b 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -488,7 +488,6 @@ static struct video_device saa7134_empress_template = {
 	.ioctl_ops     = &ts_ioctl_ops,
 
 	.tvnorms			= SAA7134_NORMS,
-	.current_norm			= V4L2_STD_PAL,
 };
 
 static void empress_signal_update(struct work_struct *work)
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index cc40938..4dae794 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2443,7 +2443,6 @@ struct video_device saa7134_video_template = {
 	.fops				= &video_fops,
 	.ioctl_ops 			= &video_ioctl_ops,
 	.tvnorms			= SAA7134_NORMS,
-	.current_norm			= V4L2_STD_PAL,
 };
 
 struct video_device saa7134_radio_template = {
-- 
1.7.10.4

