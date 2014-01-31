Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4221 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaAaJ5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 04:57:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 13/32] v4l2-ctrls: use 'new' to access pointer controls
Date: Fri, 31 Jan 2014 10:56:11 +0100
Message-Id: <1391162190-8620-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
References: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Require that 'new' string and pointer values are accessed through the 'new'
field instead of through the union. This reduces the union to just val and
val64.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/radio/si4713/si4713.c                | 4 ++--
 drivers/media/v4l2-core/v4l2-ctrls.c               | 4 ++--
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 2 +-
 include/media/v4l2-ctrls.h                         | 2 --
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 07d5153..718e10d 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -1098,11 +1098,11 @@ static int si4713_s_ctrl(struct v4l2_ctrl *ctrl)
 
 		switch (ctrl->id) {
 		case V4L2_CID_RDS_TX_PS_NAME:
-			ret = si4713_set_rds_ps_name(sdev, ctrl->string);
+			ret = si4713_set_rds_ps_name(sdev, ctrl->new.p_char);
 			break;
 
 		case V4L2_CID_RDS_TX_RADIO_TEXT:
-			ret = si4713_set_rds_radio_text(sdev, ctrl->string);
+			ret = si4713_set_rds_radio_text(sdev, ctrl->new.p_char);
 			break;
 
 		case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 9f8af88..86a27af 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1829,8 +1829,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	data = &ctrl->stores[1];
 
 	if (ctrl->is_ptr) {
-		ctrl->p = ctrl->new.p = data;
-		ctrl->stores[0].p = data + elem_size;
+		for (s = -1; s <= 0; s++)
+			ctrl->stores[s].p = data + (s + 1) * elem_size;
 	} else {
 		ctrl->new.p = &ctrl->val;
 		ctrl->stores[0].p = data;
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index ce9e5aa..d19743b 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -1127,7 +1127,7 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 		solo_motion_toggle(solo_enc, ctrl->val);
 		return 0;
 	case V4L2_CID_OSD_TEXT:
-		strcpy(solo_enc->osd_text, ctrl->string);
+		strcpy(solo_enc->osd_text, ctrl->new.p_char);
 		err = solo_osd_print(solo_enc);
 		return err;
 	default:
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 4f66393..1b06930 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -195,8 +195,6 @@ struct v4l2_ctrl {
 	union {
 		s32 val;
 		s64 val64;
-		char *string;
-		void *p;
 	};
 	union v4l2_ctrl_ptr *stores;
 	union v4l2_ctrl_ptr new;
-- 
1.8.5.2

