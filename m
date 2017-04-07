Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33250 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753248AbdDGGAy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 02:00:54 -0400
Date: Fri, 7 Apr 2017 14:56:39 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] staging: atomisp: replace "&isp->asd[i]" with "asd" in
 __get_asd_from_port()
Message-ID: <20170407055639.GA32374@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The address of isp->asd[i] is already assigned to
local "asd" variable. "&isp->asd[i]" would be replaced with
just "asd".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
This series of patches are related to previous patches:
[1] https://lkml.org/lkml/2017/3/27/159
[2] https://lkml.org/lkml/2017/3/30/1068
[3] https://lkml.org/lkml/2017/3/30/1069

 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index c3d0596..4af76b5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -535,9 +535,9 @@ static void clear_irq_reg(struct atomisp_device *isp)
 		struct camera_mipi_info *mipi_info =
 				atomisp_to_sensor_mipi_info(
 					isp->inputs[asd->input_curr].camera);
-		if (isp->asd[i].streaming == ATOMISP_DEVICE_STREAMING_ENABLED &&
+		if (asd->streaming == ATOMISP_DEVICE_STREAMING_ENABLED &&
 		    __get_mipi_port(isp, mipi_info->port) == port) {
-			return &isp->asd[i];
+			return asd;
 		}
 	}
 
-- 
1.9.1
