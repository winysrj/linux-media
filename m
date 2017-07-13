Return-path: <linux-media-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:42172 "EHLO
        faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751178AbdGMG4I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 02:56:08 -0400
From: Philipp Guendisch <philipp.guendisch@fau.de>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        jeremy.lefaure@lse.epita.fr, fabf@skynet.be, rvarsha016@gmail.com,
        philipp.guendisch@fau.de, chris.baller@gmx.de, robsonde@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCH v2 1/2] staging: atomisp2: hmm: Fixed comment style
Date: Thu, 13 Jul 2017 08:55:42 +0200
Message-Id: <1499928943-9133-1-git-send-email-philipp.guendisch@fau.de>
In-Reply-To: <20170711152758.3azqdhfyeiyagtv7@valkosipuli.retiisi.org.uk>
References: <20170711152758.3azqdhfyeiyagtv7@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixed comment style. Semantic should not be affected.
There are also two warnings left about too long lines, which
reduce readability if changed.

Signed-off-by: Philipp Guendisch <philipp.guendisch@fau.de>
Signed-off-by: Chris Baller <chris.baller@gmx.de>
---
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   | 44 +++++++++++-----------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index de0426b..b345025 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -46,10 +46,12 @@ static ia_css_ptr dummy_ptr;
 static bool hmm_initialized;
 struct _hmm_mem_stat hmm_mem_stat;
 
-/* p: private
-   s: shared
-   u: user
-   i: ion */
+/*
+ * p: private
+ * s: shared
+ * u: user
+ * i: ion
+ */
 static const char hmm_bo_type_string[] = "psui";
 
 static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
@@ -213,9 +215,7 @@ void hmm_cleanup(void)
 {
 	sysfs_remove_group(&atomisp_dev->kobj, atomisp_attribute_group);
 
-	/*
-	 * free dummy memory first
-	 */
+	/* free dummy memory first */
 	hmm_free(dummy_ptr);
 	dummy_ptr = 0;
 
@@ -230,22 +230,24 @@ ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
 	struct hmm_buffer_object *bo;
 	int ret;
 
-	/* Check if we are initialized. In the ideal world we wouldn't need
-	   this but we can tackle it once the driver is a lot cleaner */
+	/*
+	 * Check if we are initialized. In the ideal world we wouldn't need
+	 * this but we can tackle it once the driver is a lot cleaner
+	 */
 
 	if (!hmm_initialized)
 		hmm_init();
-	/*Get page number from size*/
+	/* Get page number from size */
 	pgnr = size_to_pgnr_ceil(bytes);
 
-	/*Buffer object structure init*/
+	/* Buffer object structure init */
 	bo = hmm_bo_alloc(&bo_device, pgnr);
 	if (!bo) {
 		dev_err(atomisp_dev, "hmm_bo_create failed.\n");
 		goto create_bo_err;
 	}
 
-	/*Allocate pages for memory*/
+	/* Allocate pages for memory */
 	ret = hmm_bo_alloc_pages(bo, type, from_highmem, userptr, cached);
 	if (ret) {
 		dev_err(atomisp_dev,
@@ -253,7 +255,7 @@ ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
 		goto alloc_page_err;
 	}
 
-	/*Combind the virtual address and pages togather*/
+	/* Combind the virtual address and pages togather */
 	ret = hmm_bo_bind(bo);
 	if (ret) {
 		dev_err(atomisp_dev, "hmm_bo_bind failed.\n");
@@ -319,7 +321,7 @@ static inline int hmm_check_bo(struct hmm_buffer_object *bo, unsigned int ptr)
 	return 0;
 }
 
-/*Read function in ISP memory management*/
+/* Read function in ISP memory management */
 static int load_and_flush_by_kmap(ia_css_ptr virt, void *data, unsigned int bytes)
 {
 	struct hmm_buffer_object *bo;
@@ -362,7 +364,7 @@ static int load_and_flush_by_kmap(ia_css_ptr virt, void *data, unsigned int byte
 	return 0;
 }
 
-/*Read function in ISP memory management*/
+/* Read function in ISP memory management */
 static int load_and_flush(ia_css_ptr virt, void *data, unsigned int bytes)
 {
 	struct hmm_buffer_object *bo;
@@ -397,7 +399,7 @@ static int load_and_flush(ia_css_ptr virt, void *data, unsigned int bytes)
 	return 0;
 }
 
-/*Read function in ISP memory management*/
+/* Read function in ISP memory management */
 int hmm_load(ia_css_ptr virt, void *data, unsigned int bytes)
 {
 	if (!data) {
@@ -408,13 +410,13 @@ int hmm_load(ia_css_ptr virt, void *data, unsigned int bytes)
 	return load_and_flush(virt, data, bytes);
 }
 
-/*Flush hmm data from the data cache*/
+/* Flush hmm data from the data cache */
 int hmm_flush(ia_css_ptr virt, unsigned int bytes)
 {
 	return load_and_flush(virt, NULL, bytes);
 }
 
-/*Write function in ISP memory management*/
+/* Write function in ISP memory management */
 int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes)
 {
 	struct hmm_buffer_object *bo;
@@ -496,7 +498,7 @@ int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes)
 	return 0;
 }
 
-/*memset function in ISP memory management*/
+/* memset function in ISP memory management */
 int hmm_set(ia_css_ptr virt, int c, unsigned int bytes)
 {
 	struct hmm_buffer_object *bo;
@@ -556,7 +558,7 @@ int hmm_set(ia_css_ptr virt, int c, unsigned int bytes)
 	return 0;
 }
 
-/*Virtual address to physical address convert*/
+/* Virtual address to physical address convert */
 phys_addr_t hmm_virt_to_phys(ia_css_ptr virt)
 {
 	unsigned int idx, offset;
@@ -591,7 +593,7 @@ int hmm_mmap(struct vm_area_struct *vma, ia_css_ptr virt)
 	return hmm_bo_mmap(vma, bo);
 }
 
-/*Map ISP virtual address into IA virtual address*/
+/* Map ISP virtual address into IA virtual address */
 void *hmm_vmap(ia_css_ptr virt, bool cached)
 {
 	struct hmm_buffer_object *bo;
-- 
2.7.4
