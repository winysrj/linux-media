Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52883 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdFBJMT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 05:12:19 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][media] atomisp: make repool_pgnr and punit_ddr_dvfs_enable static
Date: Fri,  2 Jun 2017 10:12:13 +0100
Message-Id: <20170602091213.30250-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

integer repool_pgnr and function punit_ddr_dvfs_enable can be made
static as they do not need to be in global scope.

Cleans up sparse warnings:
 "symbol 'repool_pgnr' was not declared. Should it be static?"
 "symbol 'punit_ddr_dvfs_enable' was not declared. Should it be static?"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index a0478077a012..a543def739fc 100644
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
2.11.0
