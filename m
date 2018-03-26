Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55190 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbeCZVK5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:10:57 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 03/18] media: staging: atomisp: ia_css_output.host: don't use var before check
Date: Mon, 26 Mar 2018 17:10:36 -0400
Message-Id: <7f77eb7af8d91e2bfbda0b84786c93e4aa28835e.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this warning:
	drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/output/output_1.0/ia_css_output.host.c:64 ia_css_output_config() warn: variable dereferenced before check 'from->info' (see line 63)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../atomisp2/css2400/isp/kernels/output/output_1.0/ia_css_output.host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/output/output_1.0/ia_css_output.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/output/output_1.0/ia_css_output.host.c
index 8fdf47c9310c..9efe5e5e4e06 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/output/output_1.0/ia_css_output.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/output/output_1.0/ia_css_output.host.c
@@ -60,7 +60,7 @@ ia_css_output_config(
 	(void)size;
 	ia_css_dma_configure_from_info(&to->port_b, from->info);
 	to->width_a_over_b = elems_a / to->port_b.elems;
-	to->height = from->info->res.height;
+	to->height = from->info ? from->info->res.height : 0;
 	to->enable = from->info != NULL;
 	ia_css_frame_info_to_frame_sp_info(&to->info, from->info);
 
-- 
2.14.3
