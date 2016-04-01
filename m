Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33100 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbcDAWim (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2016 18:38:42 -0400
Received: by mail-qg0-f41.google.com with SMTP id j35so108278720qge.0
        for <linux-media@vger.kernel.org>; Fri, 01 Apr 2016 15:38:42 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 1/7] tw686x: Specify that the DMA is 32 bits
Date: Fri,  1 Apr 2016 19:38:21 -0300
Message-Id: <1459550307-688-2-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1459550307-688-1-git-send-email-ezequiel@vanguardiasur.com.ar>
References: <1459550307-688-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set vb2_queue.gfp_flags to GFP_DMA32. Otherwise it will start to
create bounce buffers which is something you want to avoid since
those are in limited supply.

Without this patch, DMA scatter-gather may not work because
machines can ran out of buffers easily.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
--
Hans,

Feel free to squash this patch into the previous patch,
or to apply it independently.

Thanks,
Ezequiel
---
 drivers/media/pci/tw686x/tw686x-video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index a3505aa66b77..19a348fe04e3 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -848,6 +848,7 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		vc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		vc->vidq.min_buffers_needed = 2;
 		vc->vidq.lock = &vc->vb_mutex;
+		vc->vidq.gfp_flags = GFP_DMA32;
 
 		err = vb2_queue_init(&vc->vidq);
 		if (err) {
-- 
2.7.0

