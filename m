Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:43789 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754659AbdDLSUy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:20:54 -0400
Subject: [PATCH 05/14] staging: atomisp: move mipi_info assignment to next
 line in __get_asd_from_port()
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:20:49 +0100
Message-ID: <149202124311.16615.12039964731095677270.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daeseok Youn <daeseok.youn@gmail.com>

The line which is initializing mipi_info variable is too long
to read. It would be placed in next line.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index d98a6ea..a8614a9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -533,9 +533,11 @@ __get_asd_from_port(struct atomisp_device *isp, mipi_port_ID_t port)
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
