Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4682 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab1FNHOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 04/10] pvrusb2: fix g/s_tuner support.
Date: Tue, 14 Jun 2011 09:14:36 +0200
Message-Id: <3cc586adf9fd70cb319bc3bcad1e7b20c13faab0.1308035134.git.hans.verkuil@cisco.com>
In-Reply-To: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
References: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

The tuner-core subdev requires that the type field of v4l2_tuner is
filled in correctly. This is done in v4l2-ioctl.c, but pvrusb2 doesn't
use that yet, so we have to do it manually based on whether the current
input is radio or not.

Tested with my pvrusb2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index 9d0dd08..e98d382 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -3046,6 +3046,8 @@ static void pvr2_subdev_update(struct pvr2_hdw *hdw)
 	if (hdw->input_dirty || hdw->audiomode_dirty || hdw->force_dirty) {
 		struct v4l2_tuner vt;
 		memset(&vt, 0, sizeof(vt));
+		vt.type = (hdw->input_val == PVR2_CVAL_INPUT_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		vt.audmode = hdw->audiomode_val;
 		v4l2_device_call_all(&hdw->v4l2_dev, 0, tuner, s_tuner, &vt);
 	}
@@ -5171,6 +5173,8 @@ void pvr2_hdw_status_poll(struct pvr2_hdw *hdw)
 {
 	struct v4l2_tuner *vtp = &hdw->tuner_signal_info;
 	memset(vtp, 0, sizeof(*vtp));
+	vtp->type = (hdw->input_val == PVR2_CVAL_INPUT_RADIO) ?
+		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	hdw->tuner_signal_stale = 0;
 	/* Note: There apparently is no replacement for VIDIOC_CROPCAP
 	   using v4l2-subdev - therefore we can't support that AT ALL right
-- 
1.7.1

