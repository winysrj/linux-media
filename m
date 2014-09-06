Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:58517 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaIFP1q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Sep 2014 11:27:46 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 5/5] media: davinci: vpif_capture: fix the check on suspend/resume callbacks
Date: Sat,  6 Sep 2014 16:26:51 +0100
Message-Id: <1410017211-15438-6-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1410017211-15438-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1410017211-15438-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is possible to call STREAMON without having any buffers queued.
So vb2_is_streaming() can return true without start_streaming()
having been called. Only after at least one buffer has been
queued will start_streaming be called.

The check vb2_is_streaming() is incorrect as this would start
the DMA without having proper DMA pointers set up. this patch
uses vb2_start_streaming_called() instead to check is streaming
was called.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 881efcd..3ccb26f 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1596,7 +1596,7 @@ static int vpif_suspend(struct device *dev)
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
 
-		if (!vb2_is_streaming(&common->buffer_queue))
+		if (!vb2_start_streaming_called(&common->buffer_queue))
 			continue;
 
 		mutex_lock(&common->lock);
@@ -1630,7 +1630,7 @@ static int vpif_resume(struct device *dev)
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
 
-		if (!vb2_is_streaming(&common->buffer_queue))
+		if (!vb2_start_streaming_called(&common->buffer_queue))
 			continue;
 
 		mutex_lock(&common->lock);
-- 
1.9.1

