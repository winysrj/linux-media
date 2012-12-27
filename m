Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab2L0Xcg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 18:32:36 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBRNWZci020045
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 18:32:35 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] blackfin Kconfig: select is evil; use, instead depends on
Date: Thu, 27 Dec 2012 21:32:09 -0200
Message-Id: <1356651129-19695-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Select is evil as it has issues with dependencies. Better to convert
it to use depends on.

That fixes a breakage with out-of-tree compilation of the media
tree.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/blackfin/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/blackfin/Kconfig b/drivers/media/platform/blackfin/Kconfig
index 519990e..cc23997 100644
--- a/drivers/media/platform/blackfin/Kconfig
+++ b/drivers/media/platform/blackfin/Kconfig
@@ -2,7 +2,6 @@ config VIDEO_BLACKFIN_CAPTURE
 	tristate "Blackfin Video Capture Driver"
 	depends on VIDEO_V4L2 && BLACKFIN && I2C
 	select VIDEOBUF2_DMA_CONTIG
-	select VIDEO_BLACKFIN_PPI
 	help
 	  V4L2 bridge driver for Blackfin video capture device.
 	  Choose PPI or EPPI as its interface.
@@ -12,3 +11,5 @@ config VIDEO_BLACKFIN_CAPTURE
 
 config VIDEO_BLACKFIN_PPI
 	tristate
+	depends on VIDEO_BLACKFIN_CAPTURE
+	default VIDEO_BLACKFIN_CAPTURE
-- 
1.7.11.7

