Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED09C2F3BD
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23D502085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfAUNch (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:32:37 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38167 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728570AbfAUNcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 08:32:36 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lZgjgZ95MBDyIlZgpgPCKG; Mon, 21 Jan 2019 14:32:35 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6/8] usbvision: use u64 for the timestamp internally
Date:   Mon, 21 Jan 2019 14:32:27 +0100
Message-Id: <20190121133229.33893-7-hverkuil-cisco@xs4all.nl>
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
 drivers/media/usb/usbvision/usbvision-core.c  | 2 +-
 drivers/media/usb/usbvision/usbvision-video.c | 4 ++--
 drivers/media/usb/usbvision/usbvision.h       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 31e0e98d6daf..2b843a7b27a4 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -1160,7 +1160,7 @@ static void usbvision_parse_data(struct usb_usbvision *usbvision)
 
 	if (newstate == parse_state_next_frame) {
 		frame->grabstate = frame_state_done;
-		v4l2_get_timestamp(&(frame->timestamp));
+		frame->ts = ktime_get_ns();
 		frame->sequence = usbvision->frame_num;
 
 		spin_lock_irqsave(&usbvision->queue_lock, lock_flags);
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index dd2ff8ed6c6a..e611052ebf59 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -706,7 +706,7 @@ static int vidioc_querybuf(struct file *file,
 	vb->length = usbvision->curwidth *
 		usbvision->curheight *
 		usbvision->palette.bytes_per_pixel;
-	vb->timestamp = usbvision->frame[vb->index].timestamp;
+	vb->timestamp = ns_to_timeval(usbvision->frame[vb->index].ts);
 	vb->sequence = usbvision->frame[vb->index].sequence;
 	return 0;
 }
@@ -775,7 +775,7 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *vb)
 		V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	vb->index = f->index;
 	vb->sequence = f->sequence;
-	vb->timestamp = f->timestamp;
+	vb->timestamp = ns_to_timeval(f->ts);
 	vb->field = V4L2_FIELD_NONE;
 	vb->bytesused = f->scanlength;
 
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index 017e7baf5747..d55088b4fd63 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -316,7 +316,7 @@ struct usbvision_frame {
 	long bytes_read;				/* amount of scanlength that has been read from data */
 	struct usbvision_v4l2_format_st v4l2_format;	/* format the user needs*/
 	int v4l2_linesize;				/* bytes for one videoline*/
-	struct timeval timestamp;
+	u64 ts;
 	int sequence;					/* How many video frames we send to user */
 };
 
-- 
2.20.1

