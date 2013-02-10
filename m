Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4948 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3BJMuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 03/19] bttv: fix ENUM_INPUT and S_INPUT
Date: Sun, 10 Feb 2013 13:49:58 +0100
Message-Id: <d50824ee405739ff8c7c7ecfd7a0298f2ea79bac.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- Fix ENUM_INPUT audioset.
- Fix incorrect input check in s_input.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index b36d675..6e61dbd 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1923,7 +1923,7 @@ static int bttv_enum_input(struct file *file, void *priv,
 	}
 
 	i->type     = V4L2_INPUT_TYPE_CAMERA;
-	i->audioset = 1;
+	i->audioset = 0;
 
 	if (btv->tuner_type != TUNER_ABSENT && i->index == 0) {
 		sprintf(i->name, "Television");
@@ -1964,21 +1964,16 @@ static int bttv_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct bttv_fh *fh  = priv;
 	struct bttv *btv = fh->btv;
-
 	int err;
 
 	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (unlikely(err))
-		goto err;
+	if (err)
+		return err;
 
-	if (i > bttv_tvcards[btv->c.type].video_inputs) {
-		err = -EINVAL;
-		goto err;
-	}
+	if (i >= bttv_tvcards[btv->c.type].video_inputs)
+		return -EINVAL;
 
 	set_input(btv, i, btv->tvnorm);
-
-err:
 	return 0;
 }
 
-- 
1.7.10.4

