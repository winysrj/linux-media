Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1686 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3CRMcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 17/19] solo6x10: fix sequence handling.
Date: Mon, 18 Mar 2013 13:32:16 +0100
Message-Id: <1363609938-21735-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10.h |    2 ++
 drivers/staging/media/solo6x10/v4l2-enc.c |    3 ++-
 drivers/staging/media/solo6x10/v4l2.c     |    3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 56789b4..3313257 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -173,6 +173,7 @@ struct solo_enc_dev {
 
 	u32			fmt;
 	enum solo_enc_types	type;
+	u32			sequence;
 	struct vb2_queue	vidq;
 	struct list_head	vidq_active;
 	int			desc_count;
@@ -267,6 +268,7 @@ struct solo_dev {
 	/* Buffer handling */
 	struct vb2_queue	vidq;
 	struct vb2_alloc_ctx	*alloc_ctx;
+	u32			sequence;
 	struct task_struct      *kthread;
 	struct mutex		lock;
 	spinlock_t		slock;
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index ca87fb3..e53c985 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -269,6 +269,7 @@ static int solo_enc_on(struct solo_enc_dev *solo_enc)
 	/* Make sure to do a bandwidth check */
 	if (solo_enc->bw_weight > solo_dev->enc_bw_remain)
 		return -EBUSY;
+	solo_enc->sequence = 0;
 	solo_dev->enc_bw_remain -= solo_enc->bw_weight;
 
 	if (solo_enc->type == SOLO_ENC_TYPE_EXT)
@@ -522,7 +523,7 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 		ret = solo_fill_jpeg(solo_enc, vb, vh);
 
 	if (!ret) {
-		vb->v4l2_buf.sequence++;
+		vb->v4l2_buf.sequence = solo_enc->sequence++;
 		vb->v4l2_buf.timestamp.tv_sec = vh->sec;
 		vb->v4l2_buf.timestamp.tv_usec = vh->usec;
 	}
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index 94db4c2..303d951 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -224,7 +224,7 @@ finish_buf:
 	if (!error) {
 		vb2_set_plane_payload(vb, 0,
 			solo_vlines(solo_dev) * solo_bytesperline(solo_dev));
-		vb->v4l2_buf.sequence++;
+		vb->v4l2_buf.sequence = solo_dev->sequence++;
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 	}
 
@@ -332,6 +332,7 @@ static int solo_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct solo_dev *solo_dev = vb2_get_drv_priv(q);
 
+	solo_dev->sequence = 0;
 	return solo_start_thread(solo_dev);
 }
 
-- 
1.7.10.4

