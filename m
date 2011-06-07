Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1868 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab1FGPFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 17/18] ivtv: add control event support.
Date: Tue,  7 Jun 2011 17:05:22 +0200
Message-Id: <de27935dd3ce5593532d84ee6fd764c508c569f2.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
References: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-fileops.c |   34 +++++++++++++-----------------
 drivers/media/video/ivtv/ivtv-ioctl.c   |    2 +
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index a7f54b0..75c0354 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -750,31 +750,27 @@ unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
 	struct ivtv *itv = id->itv;
 	struct ivtv_stream *s = &itv->streams[id->type];
 	int eof = test_bit(IVTV_F_S_STREAMOFF, &s->s_flags);
+	unsigned res = 0;
 
-	/* Start a capture if there is none */
-	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags)) {
-		int rc;
+	IVTV_DEBUG_HI_FILE("Encoder poll\n");
 
-		mutex_lock(&itv->serialize_lock);
-		rc = ivtv_start_capture(id);
-		mutex_unlock(&itv->serialize_lock);
-		if (rc) {
-			IVTV_DEBUG_INFO("Could not start capture for %s (%d)\n",
-					s->name, rc);
-			return POLLERR;
-		}
-		IVTV_DEBUG_FILE("Encoder poll started capture\n");
-	}
+	/* Start a capture if there is none */
+	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags))
+		res = POLLIN | POLLRDNORM;
 
-	/* add stream's waitq to the poll list */
-	IVTV_DEBUG_HI_FILE("Encoder poll\n");
-	poll_wait(filp, &s->waitq, wait);
+	if (v4l2_event_pending(&id->fh))
+		res |= POLLPRI;
+	else
+		poll_wait(filp, &id->fh.events->wait, wait);
 
 	if (s->q_full.length || s->q_io.length)
-		return POLLIN | POLLRDNORM;
+		return res | POLLIN | POLLRDNORM;
 	if (eof)
-		return POLLHUP;
-	return 0;
+		return res | POLLHUP;
+
+	/* add stream's waitq to the poll list */
+	poll_wait(filp, &s->waitq, wait);
+	return res;
 }
 
 void ivtv_stop_capture(struct ivtv_open_id *id, int gop_end)
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index 1689783..a81b4be 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1445,6 +1445,8 @@ static int ivtv_subscribe_event(struct v4l2_fh *fh, struct v4l2_event_subscripti
 	case V4L2_EVENT_VSYNC:
 	case V4L2_EVENT_EOS:
 		break;
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subscribe_fh(fh, sub, 0);
 	default:
 		return -EINVAL;
 	}
-- 
1.7.1

