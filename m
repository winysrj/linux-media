Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1306 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbaBGMUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 07:20:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: edubezval@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/7] si4713: add the missing RDS functionality.
Date: Fri,  7 Feb 2014 13:19:36 +0100
Message-Id: <1391775580-29907-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
References: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Not all the RDS features of the si4713 were supported. Add
the missing bits to fully support the hardware capabilities.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/media/radio/si4713/si4713.c | 64 ++++++++++++++++++++++++++++++++++++-
 drivers/media/radio/si4713/si4713.h |  9 ++++++
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 07d5153..741db93 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -957,6 +957,41 @@ static int si4713_choose_econtrol_action(struct si4713_device *sdev, u32 id,
 		*bit = 5;
 		*mask = 0x1F << 5;
 		break;
+	case V4L2_CID_RDS_TX_DYNAMIC_PTY:
+		*property = SI4713_TX_RDS_PS_MISC;
+		*bit = 15;
+		*mask = 1 << 15;
+		break;
+	case V4L2_CID_RDS_TX_COMPRESSED:
+		*property = SI4713_TX_RDS_PS_MISC;
+		*bit = 14;
+		*mask = 1 << 14;
+		break;
+	case V4L2_CID_RDS_TX_ARTIFICIAL_HEAD:
+		*property = SI4713_TX_RDS_PS_MISC;
+		*bit = 13;
+		*mask = 1 << 13;
+		break;
+	case V4L2_CID_RDS_TX_MONO_STEREO:
+		*property = SI4713_TX_RDS_PS_MISC;
+		*bit = 12;
+		*mask = 1 << 12;
+		break;
+	case V4L2_CID_RDS_TX_TRAFFIC_PROGRAM:
+		*property = SI4713_TX_RDS_PS_MISC;
+		*bit = 10;
+		*mask = 1 << 10;
+		break;
+	case V4L2_CID_RDS_TX_TRAFFIC_ANNOUNCEMENT:
+		*property = SI4713_TX_RDS_PS_MISC;
+		*bit = 4;
+		*mask = 1 << 4;
+		break;
+	case V4L2_CID_RDS_TX_MUSIC_SPEECH:
+		*property = SI4713_TX_RDS_PS_MISC;
+		*bit = 3;
+		*mask = 1 << 3;
+		break;
 	case V4L2_CID_AUDIO_LIMITER_ENABLED:
 		*property = SI4713_TX_ACOMP_ENABLE;
 		*bit = 1;
@@ -1122,6 +1157,15 @@ static int si4713_s_ctrl(struct v4l2_ctrl *ctrl)
 			}
 			break;
 
+		case V4L2_CID_RDS_TX_ALT_FREQ_ENABLE:
+		case V4L2_CID_RDS_TX_ALT_FREQ:
+			if (sdev->rds_alt_freq_enable->val)
+				val = sdev->rds_alt_freq->val / 100 - 876 + 0xe101;
+			else
+				val = 0xe0e0;
+			ret = si4713_write_property(sdev, SI4713_TX_RDS_PS_AF, val);
+			break;
+
 		default:
 			ret = si4713_choose_econtrol_action(sdev, ctrl->id, &bit,
 					&mask, &property, &mul, &table, &size);
@@ -1410,6 +1454,24 @@ static int si4713_probe(struct i2c_client *client,
 			V4L2_CID_RDS_TX_PI, 0, 0xffff, 1, DEFAULT_RDS_PI);
 	sdev->rds_pty = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
 			V4L2_CID_RDS_TX_PTY, 0, 31, 1, DEFAULT_RDS_PTY);
+	sdev->rds_compressed = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_COMPRESSED, 0, 1, 1, 0);
+	sdev->rds_art_head = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_ARTIFICIAL_HEAD, 0, 1, 1, 0);
+	sdev->rds_stereo = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_MONO_STEREO, 0, 1, 1, 1);
+	sdev->rds_tp = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_TRAFFIC_PROGRAM, 0, 1, 1, 0);
+	sdev->rds_ta = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_TRAFFIC_ANNOUNCEMENT, 0, 1, 1, 0);
+	sdev->rds_ms = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_MUSIC_SPEECH, 0, 1, 1, 1);
+	sdev->rds_dyn_pty = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_DYNAMIC_PTY, 0, 1, 1, 0);
+	sdev->rds_alt_freq_enable = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_ALT_FREQ_ENABLE, 0, 1, 1, 0);
+	sdev->rds_alt_freq = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_ALT_FREQ, 87600, 107900, 100, 87600);
 	sdev->rds_deviation = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
 			V4L2_CID_RDS_TX_DEVIATION, 0, MAX_RDS_DEVIATION,
 			10, DEFAULT_RDS_DEVIATION);
@@ -1476,7 +1538,7 @@ static int si4713_probe(struct i2c_client *client,
 		rval = hdl->error;
 		goto free_ctrls;
 	}
-	v4l2_ctrl_cluster(20, &sdev->mute);
+	v4l2_ctrl_cluster(29, &sdev->mute);
 	sdev->sd.ctrl_handler = hdl;
 
 	if (client->irq) {
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index 4837cf6..3bee6a5 100644
--- a/drivers/media/radio/si4713/si4713.h
+++ b/drivers/media/radio/si4713/si4713.h
@@ -211,6 +211,15 @@ struct si4713_device {
 		struct v4l2_ctrl *rds_pi;
 		struct v4l2_ctrl *rds_deviation;
 		struct v4l2_ctrl *rds_pty;
+		struct v4l2_ctrl *rds_compressed;
+		struct v4l2_ctrl *rds_art_head;
+		struct v4l2_ctrl *rds_stereo;
+		struct v4l2_ctrl *rds_ta;
+		struct v4l2_ctrl *rds_tp;
+		struct v4l2_ctrl *rds_ms;
+		struct v4l2_ctrl *rds_dyn_pty;
+		struct v4l2_ctrl *rds_alt_freq_enable;
+		struct v4l2_ctrl *rds_alt_freq;
 		struct v4l2_ctrl *compression_enabled;
 		struct v4l2_ctrl *compression_threshold;
 		struct v4l2_ctrl *compression_gain;
-- 
1.8.5.2

