Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:48110 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751954AbdKFXhO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 18:37:14 -0500
Subject: [PATCH 3/3] atomisp: hmm gives a bogus warning on unload
From: Alan <alan@linux.intel.com>
To: vincent.hervieux@gmail.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org
Date: Mon, 06 Nov 2017 23:37:09 +0000
Message-ID: <151001141201.77201.10725942741811192730.stgit@alans-desktop>
In-Reply-To: <151001137594.77201.4306351721772580664.stgit@alans-desktop>
References: <151001137594.77201.4306351721772580664.stgit@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The problem is that we allocated a dummy page to ensure that 0 aka NULL
isn't returned as an ISP pointer into the hmm space. The free routine rather
sensibly checks for bogus NULL frees but is tripped by hmm_cleanup freeing
the dummy.

Split the routine so that we can keep the protection check and avoid the
bogus warning on a cleanup

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |   21 +++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index a1c81c12718c..dfb9bf54b5d2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -42,6 +42,8 @@ static ia_css_ptr dummy_ptr;
 static bool hmm_initialized;
 struct _hmm_mem_stat hmm_mem_stat;
 
+static void hmm_do_free(ia_css_ptr virt);
+
 /*
  * p: private
  * s: shared
@@ -211,7 +213,7 @@ void hmm_cleanup(void)
 	sysfs_remove_group(&atomisp_dev->kobj, atomisp_attribute_group);
 
 	/* free dummy memory first */
-	hmm_free(dummy_ptr);
+	hmm_do_free(dummy_ptr);
 	dummy_ptr = 0;
 
 	hmm_bo_device_exit(&bo_device);
@@ -268,13 +270,10 @@ ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
 	return 0;
 }
 
-void hmm_free(ia_css_ptr virt)
+static void hmm_do_free(ia_css_ptr virt)
 {
-	struct hmm_buffer_object *bo;
-
-	WARN_ON(!virt);
-
-	bo = hmm_bo_device_search_start(&bo_device, (unsigned int)virt);
+	struct hmm_buffer_object *bo =
+		hmm_bo_device_search_start(&bo_device, (unsigned int)virt);
 
 	if (!bo) {
 		dev_err(atomisp_dev,
@@ -290,6 +289,14 @@ void hmm_free(ia_css_ptr virt)
 	hmm_bo_unref(bo);
 }
 
+
+void hmm_free(ia_css_ptr virt)
+{
+	WARN_ON(!virt);
+
+	hmm_do_free(virt);
+}
+
 static inline int hmm_check_bo(struct hmm_buffer_object *bo, unsigned int ptr)
 {
 	if (!bo) {
