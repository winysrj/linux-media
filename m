Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3809 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab0KPV4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:56:35 -0500
Message-Id: <31cd863a682c3173d87d781bb877332a74e40454.1289944160.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289944159.git.hverkuil@xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 16 Nov 2010 22:56:31 +0100
Subject: [RFCv2 PATCH 09/15] sn9c102: convert to unlocked_ioctl.
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Trivial conversion, this driver used a mutex already.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/sn9c102/sn9c102_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index 28e19da..f49fbfb 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -3238,7 +3238,7 @@ static const struct v4l2_file_operations sn9c102_fops = {
 	.owner = THIS_MODULE,
 	.open = sn9c102_open,
 	.release = sn9c102_release,
-	.ioctl = sn9c102_ioctl,
+	.unlocked_ioctl = sn9c102_ioctl,
 	.read = sn9c102_read,
 	.poll = sn9c102_poll,
 	.mmap = sn9c102_mmap,
-- 
1.7.0.4

