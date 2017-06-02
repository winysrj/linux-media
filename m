Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750966AbdFBUE2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 16:04:28 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] staging: atomisp: Fix endless recursion in hmm_init
Date: Fri,  2 Jun 2017 22:04:23 +0200
Message-Id: <20170602200423.29229-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hmm_init calls hmm_alloc to set dummy_ptr, hmm_alloc calls
hmm_init when dummy_ptr is not yet set, which is the case in
the call from hmm_init, so it calls hmm_init again, this continues
until we have a stack overflow due to the recursion.

This commit fixes this by adding a separate flag for tracking if
hmm_init has been called. Not pretty, but it gets the job done,
eventually we should be able to remove the hmm_init call from
hmm_alloc.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index 5729539..e79ca3c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -43,6 +43,7 @@ struct hmm_bo_device bo_device;
 struct hmm_pool	dynamic_pool;
 struct hmm_pool	reserved_pool;
 static ia_css_ptr dummy_ptr;
+static bool hmm_initialized;
 struct _hmm_mem_stat hmm_mem_stat;
 
 /* p: private
@@ -186,6 +187,8 @@ int hmm_init(void)
 	if (ret)
 		dev_err(atomisp_dev, "hmm_bo_device_init failed.\n");
 
+	hmm_initialized = true;
+
 	/*
 	 * As hmm use NULL to indicate invalid ISP virtual address,
 	 * and ISP_VM_START is defined to 0 too, so we allocate
@@ -217,6 +220,7 @@ void hmm_cleanup(void)
 	dummy_ptr = 0;
 
 	hmm_bo_device_exit(&bo_device);
+	hmm_initialized = false;
 }
 
 ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
@@ -229,7 +233,7 @@ ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
 	/* Check if we are initialized. In the ideal world we wouldn't need
 	   this but we can tackle it once the driver is a lot cleaner */
 
-	if (!dummy_ptr)
+	if (!hmm_initialized)
 		hmm_init();
 	/*Get page number from size*/
 	pgnr = size_to_pgnr_ceil(bytes);
-- 
2.9.4
