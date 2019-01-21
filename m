Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5302C2F3A6
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F5032085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbfAUNcg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:32:36 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:60968 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728797AbfAUNcf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 08:32:35 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lZgjgZ95MBDyIlZgogPCJr; Mon, 21 Jan 2019 14:32:34 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 3/8] meye: use u64 for the timestamp internally
Date:   Mon, 21 Jan 2019 14:32:24 +0100
Message-Id: <20190121133229.33893-4-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
References: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfLCc4LSPtCzjj1Jpt5J1F2BsvjVcGofCt5IGbRz4tSP5BF6j9PKsTnJ9i8upeV2fXYDVhVqEtTcr5d91bBVuA4zg3zFKov2OiNIDnoXAuACZ6esTJSfK
 uXaTmhj8jYyNacVbiOiRnsNk5GR3FwGa/N+DI3dmDSRJbTrwX2UDFkr1JF2C+nmpWLevoJoYzU2zTSz9/ub/GRqAVd414SGLH2Aeoh8oYfPo1TIBw2mwcTln
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
 drivers/media/pci/meye/meye.c | 8 ++++----
 drivers/media/pci/meye/meye.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index bd870e60c32b..896d2d856795 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -805,7 +805,7 @@ static irqreturn_t meye_irq(int irq, void *dev_id)
 				      mchip_hsize() * mchip_vsize() * 2);
 		meye.grab_buffer[reqnr].size = mchip_hsize() * mchip_vsize() * 2;
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
-		v4l2_get_timestamp(&meye.grab_buffer[reqnr].timestamp);
+		meye.grab_buffer[reqnr].ts = ktime_get_ns();
 		meye.grab_buffer[reqnr].sequence = sequence++;
 		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
 				sizeof(int), &meye.doneq_lock);
@@ -826,7 +826,7 @@ static irqreturn_t meye_irq(int irq, void *dev_id)
 		       size);
 		meye.grab_buffer[reqnr].size = size;
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
-		v4l2_get_timestamp(&meye.grab_buffer[reqnr].timestamp);
+		meye.grab_buffer[reqnr].ts = ktime_get_ns();
 		meye.grab_buffer[reqnr].sequence = sequence++;
 		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
 				sizeof(int), &meye.doneq_lock);
@@ -1283,7 +1283,7 @@ static int vidioc_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 		buf->flags |= V4L2_BUF_FLAG_DONE;
 
 	buf->field = V4L2_FIELD_NONE;
-	buf->timestamp = meye.grab_buffer[index].timestamp;
+	buf->timestamp = ns_to_timeval(meye.grab_buffer[index].ts);
 	buf->sequence = meye.grab_buffer[index].sequence;
 	buf->memory = V4L2_MEMORY_MMAP;
 	buf->m.offset = index * gbufsize;
@@ -1349,7 +1349,7 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->bytesused = meye.grab_buffer[reqnr].size;
 	buf->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	buf->field = V4L2_FIELD_NONE;
-	buf->timestamp = meye.grab_buffer[reqnr].timestamp;
+	buf->timestamp = ns_to_timeval(meye.grab_buffer[reqnr].ts);
 	buf->sequence = meye.grab_buffer[reqnr].sequence;
 	buf->memory = V4L2_MEMORY_MMAP;
 	buf->m.offset = reqnr * gbufsize;
diff --git a/drivers/media/pci/meye/meye.h b/drivers/media/pci/meye/meye.h
index c4a8a5fe040c..0af868eb6210 100644
--- a/drivers/media/pci/meye/meye.h
+++ b/drivers/media/pci/meye/meye.h
@@ -277,7 +277,7 @@
 struct meye_grab_buffer {
 	int state;			/* state of buffer */
 	unsigned long size;		/* size of jpg frame */
-	struct timeval timestamp;	/* timestamp */
+	u64 ts;				/* timestamp */
 	unsigned long sequence;		/* sequence number */
 };
 
-- 
2.20.1

