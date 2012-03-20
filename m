Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62043 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab2CTKjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 06:39:12 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M1600JPLIWRE4@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:38:51 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M1600LVJIX8WC@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:08 +0000 (GMT)
Date: Tue, 20 Mar 2012 11:39:01 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/6] s5p-fimc: Reinitialize the pipeline properly after
 VIDIOC_STREAMOFF
In-reply-to: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1332239945-32711-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch prevents blocking on DQBUF at a video capture node in some
conditions, after STREAOMOFF/STREAMON sequence. The ST_CAPT_SUSPEND
flag should not be set during normal stream off, otherwise the
capture engine is not properly enabled at stream on.

Reported-by: Bernard Debbasch <b.debbasch@ssi.samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index b06efd2..a080f0c 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -83,7 +83,9 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 
 	fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_SHUT |
 			 1 << ST_CAPT_STREAM | 1 << ST_CAPT_ISP_STREAM);
-	if (!suspend)
+	if (suspend)
+		fimc->state |= (1 << ST_CAPT_SUSPENDED);
+	else
 		fimc->state &= ~(1 << ST_CAPT_PEND | 1 << ST_CAPT_SUSPENDED);
 
 	/* Release unused buffers */
@@ -99,7 +101,6 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 		else
 			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
-	set_bit(ST_CAPT_SUSPENDED, &fimc->state);
 
 	fimc_hw_reset(fimc);
 	cap->buf_index = 0;
-- 
1.7.9.2

