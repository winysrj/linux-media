Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36312 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdCOF7P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 01:59:15 -0400
Date: Wed, 15 Mar 2017 14:55:06 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] staging: atomisp: fix unsigned int comparison with less
 than zero
Message-ID: <20170315055506.GA8565@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix warnings from the smatch tool

atomisp_cmd.c:2649
  atomisp_set_array_res() warn:
  unsigned 'config->width' is never less than zero.

atomisp_cmd.c:2650
  atomisp_set_array_res() warn:
  unsigned 'config->height' is never less than zero.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 1ee99d0..9c3ba11 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -2646,8 +2646,7 @@ int atomisp_set_array_res(struct atomisp_sub_device *asd,
 			 struct atomisp_resolution  *config)
 {
 	dev_dbg(asd->isp->dev, ">%s start\n", __func__);
-	if (config == NULL || config->width < 0
-		|| config->height < 0) {
+	if (!config) {
 		dev_err(asd->isp->dev, "Set sensor array size is not valid\n");
 		return -EINVAL;
 	}
-- 
1.9.1
