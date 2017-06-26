Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:20092 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFZRyY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 13:54:24 -0400
From: "H. Nikolaus Schaller" <hns@goldelico.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, s-anna@ti.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH] media: omap3isp: handle NULL return of omap3isp_video_format_info() in ccdc_is_shiftable().
Date: Mon, 26 Jun 2017 19:54:19 +0200
Message-Id: <a601fdb6d224f2e4f1a3c1249ebf8438f4b8b5ce.1498499658.git.hns@goldelico.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a camera module driver specifies a format that is not
supported by omap3isp this ends in a NULL pointer
dereference instead of a simple fail.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 2fb755f20a6b..dcf16ee7c612 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2397,6 +2397,9 @@ static bool ccdc_is_shiftable(u32 in, u32 out, unsigned int additional_shift)
 	in_info = omap3isp_video_format_info(in);
 	out_info = omap3isp_video_format_info(out);
 
+	if (!in_info || !out_info)
+		return false;
+
 	if ((in_info->flavor == 0) || (out_info->flavor == 0))
 		return false;
 
-- 
2.12.2
