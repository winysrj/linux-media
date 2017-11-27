Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:35454 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdK0L52 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 06:57:28 -0500
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH 1/3] media: staging: atomisp: address member of struct ia_css_host_data is a pointer-to-char, so define default as NULL.
Date: Mon, 27 Nov 2017 11:30:52 +0000
Message-Id: <20171127113054.27657-2-jeremy@azazel.net>
In-Reply-To: <20171127113054.27657-1-jeremy@azazel.net>
References: <20171127113054.27657-1-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .../css2400/runtime/isp_param/interface/ia_css_isp_param_types.h        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
index 8e651b80345a..6fee3f7fd184 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
@@ -95,7 +95,7 @@ union ia_css_all_memory_offsets {
 };
 
 #define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
-		{ { { { 0, 0 } } } }
+		{ { { { NULL, 0 } } } }
 
 #define IA_CSS_DEFAULT_ISP_CSS_PARAMS \
 		{ { { { 0, 0 } } } }
-- 
2.15.0
