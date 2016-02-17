Return-path: <linux-media-owner@vger.kernel.org>
Received: from sg-smtp01.263.net ([54.255.195.220]:37455 "EHLO
	sg-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965658AbcBRAqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 19:46:40 -0500
From: Jung Zhao <jung.zhao@rock-chips.com>
To: tfiga@chromium.org, posciak@chromium.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH v2 1/4] [NOT FOR REVIEW] v4l: Add private compound control type.
Date: Wed, 17 Feb 2016 18:42:10 +0800
Message-Id: <1455705730-25607-1-git-send-email-jung.zhao@rock-chips.com>
In-Reply-To: <1455705673-25484-1-git-send-email-jung.zhao@rock-chips.com>
References: <1455705673-25484-1-git-send-email-jung.zhao@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

V4L2_CTRL_TYPE_PRIVATE is to be used for private driver compound
controls that use the "ptr" member of struct v4l2_ext_control.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Jung Zhao <jung.zhao@rock-chips.com>
---
Changes in v2:
- add [NOT FOR REVIEW] tag for patches from Chromium OS Tree(Tomasz)
- update copyright message
- list all the related signed-off names
- make commit message more readable(Enric)
- fix format error of commit message(Tomasz)

 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++++
 include/uapi/linux/videodev2.h       | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 890520d..527d65c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1525,6 +1525,10 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			return -ERANGE;
 		return 0;
 
+	/* FIXME:just return 0 for now */
+	case V4L2_CTRL_TYPE_PRIVATE:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 29a6b78..53ac896 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1517,6 +1517,8 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+
+	V4L2_CTRL_TYPE_PRIVATE       = 0xffff,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
1.9.1

