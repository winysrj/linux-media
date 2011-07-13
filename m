Return-path: <mchehab@localhost>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2015 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965210Ab1GMJjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 05:39:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/6] ivtv: only start streaming in poll() if polling for input.
Date: Wed, 13 Jul 2011 11:39:00 +0200
Message-Id: <02e4da34abb92931fd33ddf885476e14d230275c.1310549521.git.hans.verkuil@cisco.com>
In-Reply-To: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
References: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <bec0b6db54a6b435d219e5ad2d9f010848dd8c2b.1310549521.git.hans.verkuil@cisco.com>
References: <bec0b6db54a6b435d219e5ad2d9f010848dd8c2b.1310549521.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-fileops.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 38f0522..a931ecf 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -744,8 +744,9 @@ unsigned int ivtv_v4l2_dec_poll(struct file *filp, poll_table *wait)
 	return res;
 }
 
-unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
+unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct ivtv_open_id *id = fh2id(filp->private_data);
 	struct ivtv *itv = id->itv;
 	struct ivtv_stream *s = &itv->streams[id->type];
@@ -753,7 +754,8 @@ unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
 	unsigned res = 0;
 
 	/* Start a capture if there is none */
-	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags)) {
+	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags) &&
+			(req_events & (POLLIN | POLLRDNORM))) {
 		int rc;
 
 		mutex_lock(&itv->serialize_lock);
-- 
1.7.1

