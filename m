Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36318 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965002AbdEXA2X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:28:23 -0400
From: Juan Antonio Pedreira Martos <juanpm1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Juan Antonio Pedreira Martos <juanpm1@gmail.com>
Subject: [PATCH] staging: media: atomisp: fix non static symbol warnings
Date: Wed, 24 May 2017 02:27:11 +0200
Message-Id: <20170524002711.4481-1-juanpm1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a couple of sparse warnings:
drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c:59:14: warning: symbol 'repool_pgnr' was not declared. Should it be static?
drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c:387:6: warning: symbol 'punit_ddr_dvfs_enable' was not declared. Should it be static?

Mark these symbols as static, so they are no longer incorrectly exported.

Signed-off-by: Juan Antonio Pedreira Martos <juanpm1@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index e3fdbdba0b34..14d32174c869 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -56,7 +56,7 @@ module_param(skip_fwload, uint, 0644);
 MODULE_PARM_DESC(skip_fwload, "Skip atomisp firmware load");
 
 /* set reserved memory pool size in page */
-unsigned int repool_pgnr;
+static unsigned int repool_pgnr;
 module_param(repool_pgnr, uint, 0644);
 MODULE_PARM_DESC(repool_pgnr,
 		"Set the reserved memory pool size in page (default:0)");
@@ -384,7 +384,7 @@ static int atomisp_mrfld_pre_power_down(struct atomisp_device *isp)
  * WA for DDR DVFS enable/disable
  * By default, ISP will force DDR DVFS 1600MHz before disable DVFS
  */
-void punit_ddr_dvfs_enable(bool enable)
+static void punit_ddr_dvfs_enable(bool enable)
 {
 	int reg = intel_mid_msgbus_read32(PUNIT_PORT, MRFLD_ISPSSDVFS);
 	int door_bell = 1 << 8;
-- 
2.13.0
