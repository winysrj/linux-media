Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A7AC2F3A0
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01E442085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfAUNci (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:32:38 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:59993 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728801AbfAUNcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 08:32:36 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lZgjgZ95MBDyIlZgogPCJx; Mon, 21 Jan 2019 14:32:34 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 4/8] cpia2: use u64 for the timestamp internally
Date:   Mon, 21 Jan 2019 14:32:25 +0100
Message-Id: <20190121133229.33893-5-hverkuil-cisco@xs4all.nl>
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
 drivers/media/usb/cpia2/cpia2.h     |  2 +-
 drivers/media/usb/cpia2/cpia2_usb.c |  2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c | 11 +++--------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2.h b/drivers/media/usb/cpia2/cpia2.h
index ab238ac8bfc0..d0a464882510 100644
--- a/drivers/media/usb/cpia2/cpia2.h
+++ b/drivers/media/usb/cpia2/cpia2.h
@@ -350,7 +350,7 @@ struct cpia2_sbuf {
 };
 
 struct framebuf {
-	struct timeval timestamp;
+	u64 ts;
 	unsigned long seq;
 	int num;
 	int length;
diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index a771e0a52610..e5d8dee38fe4 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -324,7 +324,7 @@ static void cpia2_usb_complete(struct urb *urb)
 				continue;
 			}
 			DBG("Start of frame pattern found\n");
-			v4l2_get_timestamp(&cam->workbuff->timestamp);
+			cam->workbuff->ts = ktime_get_ns();
 			cam->workbuff->seq = cam->frame_count++;
 			cam->workbuff->data[0] = 0xFF;
 			cam->workbuff->data[1] = 0xD8;
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 748739c2b8b2..95c0bd4a19dc 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -833,7 +833,7 @@ static int cpia2_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 		break;
 	case FRAME_READY:
 		buf->bytesused = cam->buffers[buf->index].length;
-		buf->timestamp = cam->buffers[buf->index].timestamp;
+		buf->timestamp = ns_to_timeval(cam->buffers[buf->index].ts);
 		buf->sequence = cam->buffers[buf->index].seq;
 		buf->flags = V4L2_BUF_FLAG_DONE;
 		break;
@@ -889,12 +889,7 @@ static int find_earliest_filled_buffer(struct camera_data *cam)
 				found = i;
 			} else {
 				/* find which buffer is earlier */
-				struct timeval *tv1, *tv2;
-				tv1 = &cam->buffers[i].timestamp;
-				tv2 = &cam->buffers[found].timestamp;
-				if(tv1->tv_sec < tv2->tv_sec ||
-				   (tv1->tv_sec == tv2->tv_sec &&
-				    tv1->tv_usec < tv2->tv_usec))
+				if (cam->buffers[i].ts < cam->buffers[found].ts)
 					found = i;
 			}
 		}
@@ -945,7 +940,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_DONE
 		| V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	buf->field = V4L2_FIELD_NONE;
-	buf->timestamp = cam->buffers[buf->index].timestamp;
+	buf->timestamp = ns_to_timeval(cam->buffers[buf->index].ts);
 	buf->sequence = cam->buffers[buf->index].seq;
 	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
 	buf->length = cam->frame_size;
-- 
2.20.1

