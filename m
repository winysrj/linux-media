Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36642 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933449AbdCJNfX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 08:35:23 -0500
Date: Fri, 10 Mar 2017 19:05:05 +0530
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH v1] staging: media: Remove unused function
 atomisp_set_stop_timeout()
Message-ID: <20170310133504.GA18916@singhal-Inspiron-5558>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function atomisp_set_stop_timeout on being called, simply returns
back. The function hasn't been mentioned in the TODO and doesn't have
FIXME code around. Hence, atomisp_set_stop_timeout and its calls have been
removed.

This was done using Coccinelle.

@@
identifier f;
@@

void f(...) {

-return;

}

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 v1:
   -Change Subject to include name of function
   -change commit message to include the coccinelle script
   
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c          | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h       | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c | 5 -----
 3 files changed, 7 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index d9a5c24..9720756 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -1692,7 +1692,6 @@ void atomisp_wdt_work(struct work_struct *work)
 		}
 	}
 #endif
-	atomisp_set_stop_timeout(ATOMISP_CSS_STOP_TIMEOUT_US);
 	dev_err(isp->dev, "timeout recovery handling done\n");
 	atomic_set(&isp->wdt_work_queued, 0);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
index e6b0cce..fb8b8fa 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
@@ -660,7 +660,6 @@ int atomisp_css_set_acc_parameters(struct atomisp_acc_fw *acc_fw);
 int atomisp_css_isr_thread(struct atomisp_device *isp,
 			   bool *frame_done_found,
 			   bool *css_pipe_done);
-void atomisp_set_stop_timeout(unsigned int timeout);
 
 bool atomisp_css_valid_sof(struct atomisp_device *isp);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index 6697d72..cfa0ad4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -4699,11 +4699,6 @@ int atomisp_css_isr_thread(struct atomisp_device *isp,
 	return 0;
 }
 
-void atomisp_set_stop_timeout(unsigned int timeout)
-{
-	return;
-}
-
 bool atomisp_css_valid_sof(struct atomisp_device *isp)
 {
 	unsigned int i, j;
-- 
2.7.4
