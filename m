Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43409 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751684AbeCZVK6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:10:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 13/18] media: staging: atomisp: remove an useless check
Date: Mon, 26 Mar 2018 17:10:46 -0400
Message-Id: <252160ddfd11d99ce45ceaa3cd3d08ac693a9353.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a check at ia_css_vf_configure() to verify if
binary is not null. However, this is called too late:
	drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/vf/vf_1.0/ia_css_vf.host.c:133 ia_css_vf_configure() warn: variable dereferenced before check 'binary' (see line 129)

This test is wrong, as this fuction is only called by
ia_css_binary_fill_info(), in a place that already assumes that
binary is not null, and checks with:
	assert(binary != NULL);

So, remove the useless broken extra check.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../atomisp2/css2400/isp/kernels/vf/vf_1.0/ia_css_vf.host.c    | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/vf/vf_1.0/ia_css_vf.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/vf/vf_1.0/ia_css_vf.host.c
index 5610833ed595..c2076e412410 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/vf/vf_1.0/ia_css_vf.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/vf/vf_1.0/ia_css_vf.host.c
@@ -130,11 +130,11 @@ ia_css_vf_configure(
 
 	err = configure_kernel(info, out_info, vf_info, downscale_log2, &config);
 	configure_dma(&config, vf_info);
-	if (binary) {
-		if (vf_info)
-			vf_info->raw_bit_depth = info->dma.vfdec_bits_per_pixel;
-		ia_css_configure_vf (binary, &config);
-	}
+
+	if (vf_info)
+		vf_info->raw_bit_depth = info->dma.vfdec_bits_per_pixel;
+	ia_css_configure_vf (binary, &config);
+
 	return IA_CSS_SUCCESS;
 }
 
-- 
2.14.3
