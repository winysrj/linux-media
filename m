Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40651 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	mjpeg-users@lists.sourceforge.net
Subject: [PATCH 15/19] zr36016: remove some unused tables
Date: Fri, 24 Jun 2016 12:31:56 -0300
Message-Id: <40bcfdac9651e23b92a888c983bf0f0a28d7bfbb.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gcc 6.1 warns about some unused tables:

drivers/media/pci/zoran/zr36016.c:251:18: warning: 'zr016_yoff' defined but not used [-Wunused-const-variable=]
 static const int zr016_yoff[] = { 8, 9, 7 };
                  ^~~~~~~~~~
drivers/media/pci/zoran/zr36016.c:250:18: warning: 'zr016_xoff' defined but not used [-Wunused-const-variable=]
 static const int zr016_xoff[] = { 20, 20, 20 };
                  ^~~~~~~~~~

Those tables aren't used anywere. So, remove them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/zoran/zr36016.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/pci/zoran/zr36016.c b/drivers/media/pci/zoran/zr36016.c
index b87ddba8608f..c12ca9f96bac 100644
--- a/drivers/media/pci/zoran/zr36016.c
+++ b/drivers/media/pci/zoran/zr36016.c
@@ -246,10 +246,6 @@ static int zr36016_pushit (struct zr36016 *ptr,
    //TODO//
    ========================================================================= */
 
-// needed offset values          PAL NTSC SECAM
-static const int zr016_xoff[] = { 20, 20, 20 };
-static const int zr016_yoff[] = { 8, 9, 7 };
-
 static void
 zr36016_init (struct zr36016 *ptr)
 {
-- 
2.7.4


