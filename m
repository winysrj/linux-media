Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:41208 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933AbcDVND7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 09:03:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 6/6] rcar-vin: failed start_streaming didn't call s_stream(0)
Date: Fri, 22 Apr 2016 15:03:42 +0200
Message-Id: <1461330222-34096-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
References: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This can leave adv7180 in an inconsistent state

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 644ec9b..087c30c 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1058,8 +1058,10 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 	ret = rvin_capture_start(vin);
 out:
 	/* Return all buffers if something went wrong */
-	if (ret)
+	if (ret) {
 		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
+		v4l2_subdev_call(sd, video, s_stream, 0);
+	}
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
 
-- 
2.8.0.rc3

