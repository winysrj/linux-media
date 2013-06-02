Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1419 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3FBK4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/16] saa7134: move qos_request from saa7134_fh to saa7134_dev.
Date: Sun,  2 Jun 2013 12:55:55 +0200
Message-Id: <1370170567-7004-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is a global field, not a per-filehandle field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c |    4 ++--
 drivers/media/pci/saa7134/saa7134.h       |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 9c45dd9..2f6ba71 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2205,7 +2205,7 @@ static int saa7134_streamon(struct file *file, void *priv,
 	 * Unfortunately, I lack register-level documentation to check the
 	 * Linux FIFO setup and confirm the perfect value.
 	 */
-	pm_qos_add_request(&fh->qos_request,
+	pm_qos_add_request(&dev->qos_request,
 			   PM_QOS_CPU_DMA_LATENCY,
 			   20);
 
@@ -2220,7 +2220,7 @@ static int saa7134_streamoff(struct file *file, void *priv,
 	struct saa7134_dev *dev = fh->dev;
 	int res = saa7134_resource(file);
 
-	pm_qos_remove_request(&fh->qos_request);
+	pm_qos_remove_request(&dev->qos_request);
 
 	err = videobuf_streamoff(saa7134_queue(file));
 	if (err < 0)
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 8a62ff7..8d1453a 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -472,7 +472,6 @@ struct saa7134_fh {
 	struct v4l2_fh             fh;
 	struct saa7134_dev         *dev;
 	unsigned int               resources;
-	struct pm_qos_request	   qos_request;
 
 	/* video capture */
 	struct videobuf_queue      cap;
@@ -595,6 +594,7 @@ struct saa7134_dev {
 	unsigned int               vbi_fieldcount;
 	struct saa7134_format      *fmt;
 	unsigned int               width, height;
+	struct pm_qos_request	   qos_request;
 
 	/* various v4l controls */
 	struct saa7134_tvnorm      *tvnorm;              /* video */
-- 
1.7.10.4

