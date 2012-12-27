Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab2L0QxK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 11:53:10 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBRGrAO3006444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 11:53:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] omap: Fix Kconfig dependencies on OMAP2
Date: Thu, 27 Dec 2012 14:52:42 -0200
Message-Id: <1356627162-27815-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1356627162-27815-1-git-send-email-mchehab@redhat.com>
References: <1356627162-27815-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Resolves the following warning that appears with allmodconfig on -arm:
	warning: (VIDEO_OMAP2_VOUT && DRM_OMAP) selects OMAP2_DSS which has unmet direct dependencies (HAS_IOMEM && ARCH_OMAP2PLUS)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/omap/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index 390ab09..37ad446 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -6,7 +6,7 @@ config VIDEO_OMAP2_VOUT
 	depends on ARCH_OMAP2 || ARCH_OMAP3
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
-	select OMAP2_DSS
+	select OMAP2_DSS if HAS_IOMEM && ARCH_OMAP2PLUS
 	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
 	select VIDEO_OMAP2_VOUT_VRFB if VIDEO_OMAP2_VOUT && OMAP2_VRFB
 	default n
-- 
1.7.11.7

