Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:40329 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932366AbcHDJaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 05:30:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] vivid: don't mention the obsolete sYCC Y'CbCr encoding
Date: Thu,  4 Aug 2016 11:28:16 +0200
Message-Id: <1470302901-29281-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
References: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This encoding is identical to the 601 encoding. The old duplicate
SYCC define is about to be removed for use in the kernel, so remove
its use in vivid first.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-ctrls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index b98089c..aceb38d 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -761,7 +761,7 @@ static const char * const vivid_ctrl_ycbcr_enc_strings[] = {
 	"Rec. 709",
 	"xvYCC 601",
 	"xvYCC 709",
-	"sYCC",
+	"",
 	"BT.2020",
 	"BT.2020 Constant Luminance",
 	"SMPTE 240M",
@@ -773,6 +773,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_ycbcr_enc = {
 	.id = VIVID_CID_YCBCR_ENC,
 	.name = "Y'CbCr Encoding",
 	.type = V4L2_CTRL_TYPE_MENU,
+	.menu_skip_mask = 1 << 5,
 	.max = ARRAY_SIZE(vivid_ctrl_ycbcr_enc_strings) - 2,
 	.qmenu = vivid_ctrl_ycbcr_enc_strings,
 };
-- 
2.8.1

