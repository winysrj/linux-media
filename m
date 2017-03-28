Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36810 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753973AbdC1QIq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 12:08:46 -0400
Date: Tue, 28 Mar 2017 21:38:15 +0530
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: mchehab@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: [PATCH v2] staging: media: atomisp: compress return logic
Message-ID: <20170328160815.GA8320@arushi-HP-Pavilion-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify function returns by merging assignment and return.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
changes in v2
 *correct the error.

 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c      |  8 ++------
 .../media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c | 10 ++++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index b1f685a841ba..a04cd3ba7e68 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -519,9 +519,7 @@ int atomisp_runtime_suspend(struct device *dev)
 	if (ret)
 		return ret;
 	pm_qos_update_request(&isp->pm_qos, PM_QOS_DEFAULT_VALUE);
-	ret = atomisp_mrfld_power_down(isp);
-
-	return ret;
+	return atomisp_mrfld_power_down(isp);
 }
 
 int atomisp_runtime_resume(struct device *dev)
@@ -587,9 +585,7 @@ static int atomisp_suspend(struct device *dev)
 		return ret;
 	}
 	pm_qos_update_request(&isp->pm_qos, PM_QOS_DEFAULT_VALUE);
-	ret = atomisp_mrfld_power_down(isp);
-
-	return ret;
+	return atomisp_mrfld_power_down(isp);
 }
 
 static int atomisp_resume(struct device *dev)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
index 737ad66da900..ed33d4c4c84a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
@@ -440,7 +440,7 @@ enum ia_css_err ia_css_bufq_enqueue_psys_event(
 enum  ia_css_err ia_css_bufq_dequeue_psys_event(
 	uint8_t item[BUFQ_EVENT_SIZE])
 {
-	enum ia_css_err return_err;
+	enum ia_css_err;
 	int error = 0;
 	ia_css_queue_t *q;
 
@@ -457,8 +457,7 @@ enum  ia_css_err ia_css_bufq_dequeue_psys_event(
 	}
 	error = ia_css_eventq_recv(q, item);
 
-	return_err = ia_css_convert_errno(error);
-	return return_err;
+	return ia_css_convert_errno(error);
 
 }
 
@@ -466,7 +465,7 @@ enum  ia_css_err ia_css_bufq_dequeue_isys_event(
 	uint8_t item[BUFQ_EVENT_SIZE])
 {
 #if !defined(HAS_NO_INPUT_SYSTEM)
-	enum ia_css_err return_err;
+	enum ia_css_err;
 	int error = 0;
 	ia_css_queue_t *q;
 
@@ -482,8 +481,7 @@ enum  ia_css_err ia_css_bufq_dequeue_isys_event(
 		return IA_CSS_ERR_RESOURCE_NOT_AVAILABLE;
 	}
 	error = ia_css_eventq_recv(q, item);
-	return_err = ia_css_convert_errno(error);
-	return return_err;
+	return ia_css_convert_errno(error);
 #else
 	(void)item;
 	return IA_CSS_ERR_RESOURCE_NOT_AVAILABLE;
-- 
2.11.0
