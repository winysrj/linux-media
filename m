Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:53659 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754783AbcCULle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 07:41:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Krzysztof Halasa <khalasa@piap.pl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] tw686x-kh: specify that the DMA is 32 bits
Date: Mon, 21 Mar 2016 12:41:20 +0100
Message-Id: <1458560481-16200-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1458560481-16200-1-git-send-email-hverkuil@xs4all.nl>
References: <1458560481-16200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Set vb2_queue.gfp_flags to GFP_DMA32. Otherwise it will start to
create bounce buffers which is something you want to avoid since
those are in limited supply.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/tw686x-kh/tw686x-kh-video.c b/drivers/staging/media/tw686x-kh/tw686x-kh-video.c
index fb7a784..caf045a 100644
--- a/drivers/staging/media/tw686x-kh/tw686x-kh-video.c
+++ b/drivers/staging/media/tw686x-kh/tw686x-kh-video.c
@@ -766,6 +766,7 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		vc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		vc->vidq.min_buffers_needed = 2;
 		vc->vidq.lock = &vc->vb_mutex;
+		vc->vidq.gfp_flags = GFP_DMA32;
 
 		err = vb2_queue_init(&vc->vidq);
 		if (err)
-- 
2.7.0

