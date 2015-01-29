Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48270 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757798AbbA2LWp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 06:22:45 -0500
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 213B32A009D
	for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 12:22:11 +0100 (CET)
Message-ID: <54CA17FD.5090503@xs4all.nl>
Date: Thu, 29 Jan 2015 12:22:37 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] vivid: use consistent colorspace/Y'CbCr Encoding strings
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Keep the colorspace and encoding names consistent with what is
used elsewhere (primarily the utilities in v4l-utils.git).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-ctrls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 857e786..32a798f 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -689,7 +689,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_max_edid_blocks = {
 
 static const char * const vivid_ctrl_colorspace_strings[] = {
 	"SMPTE 170M",
-	"REC 709",
+	"Rec. 709",
 	"sRGB",
 	"AdobeRGB",
 	"BT.2020",
@@ -716,7 +716,7 @@ static const char * const vivid_ctrl_ycbcr_enc_strings[] = {
 	"xvYCC 601",
 	"xvYCC 709",
 	"sYCC",
-	"BT.2020 Non-Constant Luminance",
+	"BT.2020",
 	"BT.2020 Constant Luminance",
 	"SMPTE 240M",
 	NULL,
-- 
2.1.3

