Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2584 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3DNP1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 09/30] cx25821: s_input didn't check for invalid input.
Date: Sun, 14 Apr 2013 17:27:05 +0200
Message-Id: <1365953246-8972-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The s_input implementation allowed input 1 even if that didn't exist.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index a9aa096..9ddc7ac 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -1163,10 +1163,8 @@ int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 			return err;
 	}
 
-	if (i >= CX25821_NR_INPUT) {
-		dprintk(1, "%s(): -EINVAL\n", __func__);
+	if (i >= CX25821_NR_INPUT || INPUT(i)->type == 0)
 		return -EINVAL;
-	}
 
 	mutex_lock(&dev->lock);
 	cx25821_video_mux(dev, i);
-- 
1.7.10.4

