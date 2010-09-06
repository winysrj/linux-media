Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25805 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab0IFGx4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 02:53:56 -0400
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L8B00297CHS60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:52 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8B00A2VCHS5P@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:52 +0100 (BST)
Date: Mon, 06 Sep 2010 08:53:46 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 4/8] v4l: videobuf: Fail streamon on an output device when no
 buffers queued
In-reply-to: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com
Message-id: <1283756030-28634-5-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Pawel Osciak <p.osciak@samsung.com>

Streamon should return -EINVAL if called on an output device and no
buffers are queued.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf-core.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index ce1595b..2cdf8ed 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -725,6 +725,17 @@ int videobuf_streamon(struct videobuf_queue *q)
 	int retval;
 
 	mutex_lock(&q->vb_lock);
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT
+			|| q->type == V4L2_BUF_TYPE_VBI_OUTPUT
+			|| q->type == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
+		if (list_empty(&q->stream)) {
+			dprintk(1, "streamon: no output buffers queued\n");
+			retval = -EINVAL;
+			goto done;
+		}
+	}
+
 	retval = -EBUSY;
 	if (q->reading)
 		goto done;
-- 
1.7.2.2

