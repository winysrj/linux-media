Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53894 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbbCIPpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:45:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/29] vivid: use TPG_MAX_PLANES instead of hardcoding plane-arrays
Date: Mon,  9 Mar 2015 16:44:26 +0100
Message-Id: <1425915891-1017-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Two arrays of size 'max number of planes' have a hardcoded size instead
of using TPG_MAX_PLANES. Fix that, since TPG_MAX_PLANES will be increased
later on.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 4b497df..191d9b5 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -84,7 +84,7 @@ struct vivid_fmt {
 	bool	can_do_overlay;
 	u32	alpha_mask;
 	u8	planes;
-	u32	data_offset[2];
+	u32	data_offset[TPG_MAX_PLANES];
 };
 
 extern struct vivid_fmt vivid_formats[];
@@ -332,7 +332,7 @@ struct vivid_dev {
 	u32				ycbcr_enc_out;
 	u32				quantization_out;
 	u32				service_set_out;
-	u32				bytesperline_out[2];
+	u32				bytesperline_out[TPG_MAX_PLANES];
 	unsigned			tv_field_out;
 	unsigned			tv_audio_output;
 	bool				vbi_out_have_wss;
-- 
2.1.4

