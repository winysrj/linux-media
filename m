Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33824 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753248AbdDGGBi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 02:01:38 -0400
Date: Fri, 7 Apr 2017 14:57:23 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] staging: atomisp: move mipi_info assignment to next line
 in __get_asd_from_port()
Message-ID: <20170407055702.GA32406@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The line which is initializing mipi_info variable is too long
to read. It would be placed in next line.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
This series of patches are related to previous patches:
[1] https://lkml.org/lkml/2017/3/27/159
[2] https://lkml.org/lkml/2017/3/30/1068
[3] https://lkml.org/lkml/2017/3/30/1069

 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 4af76b5..2208477 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -532,9 +532,11 @@ static void clear_irq_reg(struct atomisp_device *isp)
 	/* Check which isp subdev to send eof */
 	for (i = 0; i < isp->num_of_streams; i++) {
 		struct atomisp_sub_device *asd = &isp->asd[i];
-		struct camera_mipi_info *mipi_info =
-				atomisp_to_sensor_mipi_info(
-					isp->inputs[asd->input_curr].camera);
+		struct camera_mipi_info *mipi_info;
+
+		mipi_info = atomisp_to_sensor_mipi_info(
+				isp->inputs[asd->input_curr].camera);
+
 		if (asd->streaming == ATOMISP_DEVICE_STREAMING_ENABLED &&
 		    __get_mipi_port(isp, mipi_info->port) == port) {
 			return asd;
-- 
1.9.1
