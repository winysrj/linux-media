Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42200 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454AbbIMQnB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 12:43:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/6] vivid: add support for the DCI-P3 colorspace
Date: Sun, 13 Sep 2015 18:41:32 +0200
Message-Id: <1442162492-46238-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
References: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support this new colorspace in vivid.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h  | 1 +
 drivers/media/platform/vivid/vivid-ctrls.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index c72349c..72c4cd3 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -123,6 +123,7 @@ enum vivid_colorspace {
 	VIVID_CS_SRGB,
 	VIVID_CS_ADOBERGB,
 	VIVID_CS_2020,
+	VIVID_CS_DCI_P3,
 	VIVID_CS_240M,
 	VIVID_CS_SYS_M,
 	VIVID_CS_SYS_BG,
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 3d8e161..995e303 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -342,6 +342,7 @@ static int vivid_vid_cap_s_ctrl(struct v4l2_ctrl *ctrl)
 		V4L2_COLORSPACE_SRGB,
 		V4L2_COLORSPACE_ADOBERGB,
 		V4L2_COLORSPACE_BT2020,
+		V4L2_COLORSPACE_DCI_P3,
 		V4L2_COLORSPACE_SMPTE240M,
 		V4L2_COLORSPACE_470_SYSTEM_M,
 		V4L2_COLORSPACE_470_SYSTEM_BG,
@@ -701,6 +702,7 @@ static const char * const vivid_ctrl_colorspace_strings[] = {
 	"sRGB",
 	"AdobeRGB",
 	"BT.2020",
+	"DCI-P3",
 	"SMPTE 240M",
 	"470 System M",
 	"470 System BG",
@@ -724,6 +726,7 @@ static const char * const vivid_ctrl_xfer_func_strings[] = {
 	"AdobeRGB",
 	"SMPTE 240M",
 	"None",
+	"DCI-P3",
 	NULL,
 };
 
-- 
2.1.4

