Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3785 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3CBXpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/20] solo6x10: fix scheduling while atomic error.
Date: Sun,  3 Mar 2013 00:45:22 +0100
Message-Id: <de9751909ed96d9eb5caea4e4990bd8965e50860.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/v4l2-enc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 71d9656f..6b5b8c0 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -188,27 +188,26 @@ static void solo_enc_off(struct solo_enc_fh *fh)
 		fh->kthread = NULL;
 	}
 
+	spin_lock(&solo_enc->lock);
 	solo_dev->enc_bw_remain += solo_enc->bw_weight;
 	fh->enc_on = 0;
 
 	if (atomic_dec_return(&solo_enc->readers) > 0)
-		return;
+		goto unlock;
 
 	solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(solo_enc->ch), 0);
 	solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(solo_enc->ch), 0);
+unlock:
+	spin_unlock(&solo_enc->lock);
 }
 
 static int solo_start_fh_thread(struct solo_enc_fh *fh)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
-
 	fh->kthread = kthread_run(solo_enc_thread, fh, SOLO6X10_NAME "_enc");
 
 	/* Oops, we had a problem */
 	if (IS_ERR(fh->kthread)) {
-		spin_lock(&solo_enc->lock);
 		solo_enc_off(fh);
-		spin_unlock(&solo_enc->lock);
 
 		return PTR_ERR(fh->kthread);
 	}
@@ -1003,14 +1002,11 @@ static ssize_t solo_enc_read(struct file *file, char __user *data,
 static int solo_enc_release(struct file *file)
 {
 	struct solo_enc_fh *fh = file->private_data;
-	struct solo_enc_dev *solo_enc = fh->enc;
 
 	videobuf_stop(&fh->vidq);
 	videobuf_mmap_free(&fh->vidq);
 
-	spin_lock(&solo_enc->lock);
 	solo_enc_off(fh);
-	spin_unlock(&solo_enc->lock);
 
 	kfree(fh);
 
-- 
1.7.10.4

