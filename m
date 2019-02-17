Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0EDC43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83EA9218AC
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="SsPcV9nU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbfBQCtG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 21:49:06 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45166 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfBQCtF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 21:49:05 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id AD2251232;
        Sun, 17 Feb 2019 03:49:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550371741;
        bh=nWW71y0mrgdLfmDZXM1H53hadYDw2j10UFMyD5Fj6j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsPcV9nUqLyVU8wHp9DtYFUAEfNlixM54iJTjYBs8/faKUzWdjiyNs+3vywJ7JMfD
         ncnrPe8pJua1BhWoBypjAf3Ob3HjhOAl17cj8rjIJlo8hqgPnyJrlVjB1x/P0HgbBS
         n9pmTHScJPoX//uZdECh5RT0OhekXsd2XNEJOO1Q=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v4 5/7] media: vsp1: Refactor vsp1_video_complete_buffer() for later reuse
Date:   Sun, 17 Feb 2019 04:48:50 +0200
Message-Id: <20190217024852.23328-6-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The vsp1_video_complete_buffer() function completes the current buffer
and returns a pointer to the next buffer. Split the code that completes
the buffer to a separate function for later reuse, and rename
vsp1_video_complete_buffer() to vsp1_video_complete_next_buffer().

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 35 ++++++++++++++----------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 328d686189be..cfbab16c4820 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -300,8 +300,22 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
  * Pipeline Management
  */
 
+static void vsp1_video_complete_buffer(struct vsp1_video *video,
+				       struct vsp1_vb2_buffer *buffer)
+{
+	struct vsp1_pipeline *pipe = video->rwpf->entity.pipe;
+	unsigned int i;
+
+	buffer->buf.sequence = pipe->sequence;
+	buffer->buf.vb2_buf.timestamp = ktime_get_ns();
+	for (i = 0; i < buffer->buf.vb2_buf.num_planes; ++i)
+		vb2_set_plane_payload(&buffer->buf.vb2_buf, i,
+				      vb2_plane_size(&buffer->buf.vb2_buf, i));
+	vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_DONE);
+}
+
 /*
- * vsp1_video_complete_buffer - Complete the current buffer
+ * vsp1_video_complete_next_buffer - Complete the current buffer
  * @video: the video node
  *
  * This function completes the current buffer by filling its sequence number,
@@ -310,13 +324,11 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
  * Return the next queued buffer or NULL if the queue is empty.
  */
 static struct vsp1_vb2_buffer *
-vsp1_video_complete_buffer(struct vsp1_video *video)
+vsp1_video_complete_next_buffer(struct vsp1_video *video)
 {
-	struct vsp1_pipeline *pipe = video->rwpf->entity.pipe;
-	struct vsp1_vb2_buffer *next = NULL;
+	struct vsp1_vb2_buffer *next;
 	struct vsp1_vb2_buffer *done;
 	unsigned long flags;
-	unsigned int i;
 
 	spin_lock_irqsave(&video->irqlock, flags);
 
@@ -327,21 +339,14 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 
 	done = list_first_entry(&video->irqqueue,
 				struct vsp1_vb2_buffer, queue);
-
 	list_del(&done->queue);
 
-	if (!list_empty(&video->irqqueue))
-		next = list_first_entry(&video->irqqueue,
+	next = list_first_entry_or_null(&video->irqqueue,
 					struct vsp1_vb2_buffer, queue);
 
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	done->buf.sequence = pipe->sequence;
-	done->buf.vb2_buf.timestamp = ktime_get_ns();
-	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
-		vb2_set_plane_payload(&done->buf.vb2_buf, i,
-				      vb2_plane_size(&done->buf.vb2_buf, i));
-	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
+	vsp1_video_complete_buffer(video, done);
 
 	return next;
 }
@@ -352,7 +357,7 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 	struct vsp1_video *video = rwpf->video;
 	struct vsp1_vb2_buffer *buf;
 
-	buf = vsp1_video_complete_buffer(video);
+	buf = vsp1_video_complete_next_buffer(video);
 	if (buf == NULL)
 		return;
 
-- 
Regards,

Laurent Pinchart

