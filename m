Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47650 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758147AbbEaNL4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 09:11:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH 4/9] am437x-vpfe: add support for xfer_func
Date: Sun, 31 May 2015 15:11:34 +0200
Message-Id: <1433077899-18516-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make this part of the format check.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index ea971bb..1fba339 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -288,7 +288,8 @@ cmp_v4l2_format(const struct v4l2_format *lhs, const struct v4l2_format *rhs)
 		lhs->fmt.pix.field == rhs->fmt.pix.field &&
 		lhs->fmt.pix.colorspace == rhs->fmt.pix.colorspace &&
 		lhs->fmt.pix.ycbcr_enc == rhs->fmt.pix.ycbcr_enc &&
-		lhs->fmt.pix.quantization == rhs->fmt.pix.quantization;
+		lhs->fmt.pix.quantization == rhs->fmt.pix.quantization &&
+		lhs->fmt.pix.xfer_func == rhs->fmt.pix.xfer_func;
 }
 
 static inline u32 vpfe_reg_read(struct vpfe_ccdc *ccdc, u32 offset)
-- 
2.1.4

