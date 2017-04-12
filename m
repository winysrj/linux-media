Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:45787 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754659AbdDLSUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:20:41 -0400
Subject: [PATCH 04/14] staging: atomisp: replace "&isp->asd[i]" with "asd"
 in __get_asd_from_port()
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:20:36 +0100
Message-ID: <149202123050.16615.10422203645444637150.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daeseok Youn <daeseok.youn@gmail.com>

The address of isp->asd[i] is already assigned to
local "asd" variable. "&isp->asd[i]" would be replaced with
just "asd".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 08606cb..d98a6ea 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -536,9 +536,9 @@ __get_asd_from_port(struct atomisp_device *isp, mipi_port_ID_t port)
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
 
