Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4332 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3BFP4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 10:56:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 04/17] bttv: fix ENUM_INPUT and S_INPUT
Date: Wed,  6 Feb 2013 16:56:22 +0100
Message-Id: <d139f207fba510f737b64a684cddb4c5fdc8a477.1360165855.git.hans.verkuil@cisco.com>
In-Reply-To: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
References: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
References: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
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

