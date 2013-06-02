Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3520 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3FBK4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/16] v4l2-ctrls: V4L2_CTRL_CLASS_FM_RX controls are also valid radio controls.
Date: Sun,  2 Jun 2013 12:55:59 +0200
Message-Id: <1370170567-7004-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The radio filter function that filters controls that are valid for a radio
device should also accept V4L2_CTRL_CLASS_FM_RX controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ebb8e48..fccd08b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1835,6 +1835,8 @@ bool v4l2_ctrl_radio_filter(const struct v4l2_ctrl *ctrl)
 {
 	if (V4L2_CTRL_ID2CLASS(ctrl->id) == V4L2_CTRL_CLASS_FM_TX)
 		return true;
+	if (V4L2_CTRL_ID2CLASS(ctrl->id) == V4L2_CTRL_CLASS_FM_RX)
+		return true;
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 	case V4L2_CID_AUDIO_VOLUME:
-- 
1.7.10.4

