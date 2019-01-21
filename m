Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7E9C2F3BE
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2473120870
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfAUNci (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:32:38 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:46464 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728696AbfAUNcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 08:32:36 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lZgjgZ95MBDyIlZgpgPCKK; Mon, 21 Jan 2019 14:32:35 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 7/8] zoran: use u64 for the timestamp internally
Date:   Mon, 21 Jan 2019 14:32:28 +0100
Message-Id: <20190121133229.33893-8-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
References: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHJdqdM1aTPcvwsYFeS1YIfWDZyUwcw8+6+3C10VZjMgiB1NYCQaaZdB3EM5Vks01ujzzVO1btt2s3w23lmHEvZiXmmR4ur0yUk1nVo0blSobiou3XUK
 4X86fdHlekNmBTfVQF/VZBqrKNguy8PocBz33ChDpjj9ULDfE6Kh0WSbK+LUFV+JnmoN0mqYOAajJQvsr13D6zS8BxF+nbUVUQWfps7v8JFqCl1rYGZGIEzL
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Just like vb2 does, use u64 internally to store the timestamps
of the buffers. Only convert to timeval when interfacing with
userspace.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/staging/media/zoran/zoran.h        | 2 +-
 drivers/staging/media/zoran/zoran_device.c | 4 ++--
 drivers/staging/media/zoran/zoran_driver.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/zoran/zoran.h b/drivers/staging/media/zoran/zoran.h
index 9bb3c21aa275..e84fb604a689 100644
--- a/drivers/staging/media/zoran/zoran.h
+++ b/drivers/staging/media/zoran/zoran.h
@@ -35,7 +35,7 @@ struct zoran_sync {
 	unsigned long frame;	/* number of buffer that has been free'd */
 	unsigned long length;	/* number of code bytes in buffer (capture only) */
 	unsigned long seq;	/* frame sequence number */
-	struct timeval timestamp;	/* timestamp */
+	u64 ts;			/* timestamp */
 };
 
 
diff --git a/drivers/staging/media/zoran/zoran_device.c b/drivers/staging/media/zoran/zoran_device.c
index 40adceebca7e..d393e7b8aeda 100644
--- a/drivers/staging/media/zoran/zoran_device.c
+++ b/drivers/staging/media/zoran/zoran_device.c
@@ -1151,7 +1151,7 @@ zoran_reap_stat_com (struct zoran *zr)
 		}
 		frame = zr->jpg_pend[zr->jpg_dma_tail & BUZ_MASK_FRAME];
 		buffer = &zr->jpg_buffers.buffer[frame];
-		v4l2_get_timestamp(&buffer->bs.timestamp);
+		buffer->bs.ts = ktime_get_ns();
 
 		if (zr->codec_mode == BUZ_MODE_MOTION_COMPRESS) {
 			buffer->bs.length = (stat_com & 0x7fffff) >> 1;
@@ -1389,7 +1389,7 @@ zoran_irq (int             irq,
 
 						zr->v4l_buffers.buffer[zr->v4l_grab_frame].state = BUZ_STATE_DONE;
 						zr->v4l_buffers.buffer[zr->v4l_grab_frame].bs.seq = zr->v4l_grab_seq;
-						v4l2_get_timestamp(&zr->v4l_buffers.buffer[zr->v4l_grab_frame].bs.timestamp);
+						zr->v4l_buffers.buffer[zr->v4l_grab_frame].bs.ts = ktime_get_ns();
 						zr->v4l_grab_frame = NO_GRAB_ACTIVE;
 						zr->v4l_pend_tail++;
 					}
diff --git a/drivers/staging/media/zoran/zoran_driver.c b/drivers/staging/media/zoran/zoran_driver.c
index 27c76e2eeb41..04f88f9d6bb4 100644
--- a/drivers/staging/media/zoran/zoran_driver.c
+++ b/drivers/staging/media/zoran/zoran_driver.c
@@ -1354,7 +1354,7 @@ static int zoran_v4l2_buffer_status(struct zoran_fh *fh,
 		    fh->buffers.buffer[num].state == BUZ_STATE_USER) {
 			buf->sequence = fh->buffers.buffer[num].bs.seq;
 			buf->flags |= V4L2_BUF_FLAG_DONE;
-			buf->timestamp = fh->buffers.buffer[num].bs.timestamp;
+			buf->timestamp = ns_to_timeval(fh->buffers.buffer[num].bs.ts);
 		} else {
 			buf->flags |= V4L2_BUF_FLAG_QUEUED;
 		}
@@ -1388,7 +1388,7 @@ static int zoran_v4l2_buffer_status(struct zoran_fh *fh,
 		if (fh->buffers.buffer[num].state == BUZ_STATE_DONE ||
 		    fh->buffers.buffer[num].state == BUZ_STATE_USER) {
 			buf->sequence = fh->buffers.buffer[num].bs.seq;
-			buf->timestamp = fh->buffers.buffer[num].bs.timestamp;
+			buf->timestamp = ns_to_timeval(fh->buffers.buffer[num].bs.ts);
 			buf->bytesused = fh->buffers.buffer[num].bs.length;
 			buf->flags |= V4L2_BUF_FLAG_DONE;
 		} else {
-- 
2.20.1

