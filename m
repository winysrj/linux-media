Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48003 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753955AbeDLPYe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Georgiana Chelu <georgiana.chelu93@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Aishwarya Pant <aishpant@gmail.com>,
        Jeremy Sowden <jeremy@azazel.net>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Philipp Guendisch <philipp.guendisch@fau.de>,
        Paolo Cretaro <melko@frugalware.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Srishti Sharma <srishtishar@gmail.com>,
        Muhammad Falak R Wani <falakreyaz@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, devel@driverdev.osuosl.org
Subject: [PATCH 03/17] media: atomisp: fix __user annotations
Date: Thu, 12 Apr 2018 11:23:55 -0400
Message-Id: <be09bc998cfc0636714829f4347a173091919d03.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of troubles with atomisp __user annotations. Fix them.

drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c:357:49: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c:357:49:    expected void *userptr
drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c:357:49:    got void [noderef] <asn:1>*user_ptr
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:3302:43: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:3302:43:    expected void const [noderef] <asn:1>*from
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:3302:43:    got void const *from
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:4070:58: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:4070:58:    expected void const *from
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:4070:58:    got unsigned short [noderef] <asn:1>*<noident>
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:4082:58: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:4082:58:    expected void const *from
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:4082:58:    got unsigned short [noderef] <asn:1>*<noident>
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:6179:62: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:6179:62:    expected void const [noderef] <asn:1>*from
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:6179:62:    got unsigned short [usertype] *<noident>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_acc.c       |  8 ++++----
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |  9 +++++----
 .../media/atomisp/pci/atomisp2/atomisp_compat.h    |  2 +-
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |  2 +-
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  2 +-
 .../memory_access/memory_access.h                  |  2 +-
 .../pci/atomisp2/css2400/ia_css_frame_public.h     |  2 +-
 .../pci/atomisp2/css2400/ia_css_memory_access.c    |  4 ++--
 .../pci/atomisp2/css2400/runtime/frame/src/frame.c |  2 +-
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |  2 +-
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |  4 ++--
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c | 22 ++++++++++++----------
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h | 11 ++++++-----
 .../media/atomisp/pci/atomisp2/include/hmm/hmm.h   |  2 +-
 .../atomisp/pci/atomisp2/include/hmm/hmm_bo.h      |  2 +-
 15 files changed, 40 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c
index a6638edee360..7ebcebd80b77 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c
@@ -353,10 +353,10 @@ int atomisp_acc_map(struct atomisp_sub_device *asd, struct atomisp_acc_map *map)
 		}
 
 		pgnr = DIV_ROUND_UP(map->length, PAGE_SIZE);
-		cssptr = hrt_isp_css_mm_alloc_user_ptr(
-				map->length, map->user_ptr,
-				pgnr, HRT_USR_PTR,
-				(map->flags & ATOMISP_MAP_FLAG_CACHED));
+		cssptr = hrt_isp_css_mm_alloc_user_ptr(map->length,
+						       map->user_ptr,
+						       pgnr, HRT_USR_PTR,
+						       (map->flags & ATOMISP_MAP_FLAG_CACHED));
 	} else {
 		/* Allocate private buffer. */
 		if (map->flags & ATOMISP_MAP_FLAG_CACHED)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index fa6ea506f8b1..874165654850 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -3299,7 +3299,7 @@ static unsigned int long copy_from_compatible(void *to, const void *from,
 					      unsigned long n, bool from_user)
 {
 	if (from_user)
-		return copy_from_user(to, from, n);
+		return copy_from_user(to, (void __user *)from, n);
 	else
 		memcpy(to, from, n);
 	return 0;
@@ -4067,7 +4067,7 @@ int atomisp_cp_morph_table(struct atomisp_sub_device *asd,
 
 	for (i = 0; i < CSS_MORPH_TABLE_NUM_PLANES; i++) {
 		if (copy_from_compatible(morph_table->coordinates_x[i],
-			source_morph_table->coordinates_x[i],
+			(__force void *)source_morph_table->coordinates_x[i],
 #ifndef ISP2401
 			source_morph_table->height * source_morph_table->width *
 			sizeof(*source_morph_table->coordinates_x[i]),
@@ -4079,7 +4079,7 @@ int atomisp_cp_morph_table(struct atomisp_sub_device *asd,
 			goto error;
 
 		if (copy_from_compatible(morph_table->coordinates_y[i],
-			source_morph_table->coordinates_y[i],
+			(__force void *)source_morph_table->coordinates_y[i],
 #ifndef ISP2401
 			source_morph_table->height * source_morph_table->width *
 			sizeof(*source_morph_table->coordinates_y[i]),
@@ -6176,7 +6176,8 @@ int atomisp_set_shading_table(struct atomisp_sub_device *asd,
 		    ATOMISP_SC_TYPE_SIZE;
 	for (i = 0; i < ATOMISP_NUM_SC_COLORS; i++) {
 		ret = copy_from_user(shading_table->data[i],
-				     user_shading_table->data[i], len_table);
+				     (void __user *)user_shading_table->data[i],
+				     len_table);
 		if (ret) {
 			free_table = shading_table;
 			ret = -EFAULT;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
index 6c829d0a1e4c..aac0eccee798 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
@@ -353,7 +353,7 @@ void atomisp_css_frame_free(struct atomisp_css_frame *frame);
 
 int atomisp_css_frame_map(struct atomisp_css_frame **frame,
 				const struct atomisp_css_frame_info *info,
-				const void *data, uint16_t attribute,
+				const void __user *data, uint16_t attribute,
 				void *context);
 
 int atomisp_css_set_black_frame(struct atomisp_sub_device *asd,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index f668c68dc33a..df88d9df2027 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -2189,7 +2189,7 @@ void atomisp_css_frame_free(struct atomisp_css_frame *frame)
 
 int atomisp_css_frame_map(struct atomisp_css_frame **frame,
 				const struct atomisp_css_frame_info *info,
-				const void *data, uint16_t attribute,
+				const void __user *data, uint16_t attribute,
 				void *context)
 {
 	if (ia_css_frame_map(frame, info, data, attribute, context)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 61bd550dafb9..6e7231243891 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -1253,7 +1253,7 @@ static int atomisp_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 		attributes.type = HRT_USR_PTR;
 #endif
 		ret = atomisp_css_frame_map(&handle, &frame_info,
-				       (void *)buf->m.userptr,
+				       (void __user *)buf->m.userptr,
 				       0, &attributes);
 		if (ret) {
 			dev_err(isp->dev, "Failed to map user buffer\n");
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h
index 195c4a5bceeb..d2387812f3a6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h
@@ -137,7 +137,7 @@ extern hrt_vaddress mmgr_alloc_attr(const size_t size, const uint16_t attribute)
  \return vaddress
  */
 extern hrt_vaddress mmgr_mmap(
-	const void *ptr,
+	const void __user *ptr,
 	const size_t size,
 	uint16_t attribute,
 	void *context);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
index 0beb7347a4f3..89943e8bf180 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_frame_public.h
@@ -333,7 +333,7 @@ ia_css_frame_set_data(struct ia_css_frame *frame,
 enum ia_css_err
 ia_css_frame_map(struct ia_css_frame **frame,
 		 const struct ia_css_frame_info *info,
-		 const void *data,
+		 const void __user *data,
 		 uint16_t attribute,
 		 void *context);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
index 282075942ba6..8222dd0a41f2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
@@ -72,12 +72,12 @@ mmgr_store(const hrt_vaddress vaddr, const void *data, const size_t size)
 }
 
 hrt_vaddress
-mmgr_mmap(const void *ptr, const size_t size,
+mmgr_mmap(const void __user *ptr, const size_t size,
 	  uint16_t attribute, void *context)
 {
 	struct hrt_userbuffer_attr *userbuffer_attr = context;
 	return hrt_isp_css_mm_alloc_user_ptr(
-			size, (void *)ptr, userbuffer_attr->pgnr,
+			size, ptr, userbuffer_attr->pgnr,
 			userbuffer_attr->type,
 			attribute & HRT_BUF_FLAG_CACHED);
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
index 7562beadabef..fd8e6fda5db4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
@@ -175,7 +175,7 @@ enum ia_css_err ia_css_frame_allocate(struct ia_css_frame **frame,
 
 enum ia_css_err ia_css_frame_map(struct ia_css_frame **frame,
 	const struct ia_css_frame_info *info,
-	const void *data,
+	const void __user *data,
 	uint16_t attribute,
 	void *context)
 {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index 4338b8a1309f..15bc10b5e9b1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -219,7 +219,7 @@ void hmm_cleanup(void)
 }
 
 ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
-		     int from_highmem, void *userptr, bool cached)
+		     int from_highmem, const void __user *userptr, bool cached)
 {
 	unsigned int pgnr;
 	struct hmm_buffer_object *bo;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index 79bd540d7882..c888f9c809f9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -977,7 +977,7 @@ static int get_pfnmap_pages(struct task_struct *tsk, struct mm_struct *mm,
  * Convert user space virtual address into pages list
  */
 static int alloc_user_pages(struct hmm_buffer_object *bo,
-			      void *userptr, bool cached)
+			    const void __user *userptr, bool cached)
 {
 	int page_nr;
 	int i;
@@ -1081,7 +1081,7 @@ static void free_user_pages(struct hmm_buffer_object *bo)
  */
 int hmm_bo_alloc_pages(struct hmm_buffer_object *bo,
 		       enum hmm_bo_type type, int from_highmem,
-		       void *userptr, bool cached)
+		       const void __user *userptr, bool cached)
 {
 	int ret = -EINVAL;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
index a94958bde718..9b186517f20a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
@@ -24,11 +24,11 @@
 
 #define __page_align(size)	(((size) + (PAGE_SIZE-1)) & (~(PAGE_SIZE-1)))
 
-static void *my_userptr;
+static void __user *my_userptr;
 static unsigned my_num_pages;
 static enum hrt_userptr_type my_usr_type;
 
-void hrt_isp_css_mm_set_user_ptr(void *userptr,
+void hrt_isp_css_mm_set_user_ptr(void __user *userptr,
 				 unsigned int num_pages,
 				 enum hrt_userptr_type type)
 {
@@ -37,10 +37,11 @@ void hrt_isp_css_mm_set_user_ptr(void *userptr,
 	my_usr_type = type;
 }
 
-static ia_css_ptr __hrt_isp_css_mm_alloc(size_t bytes, void *userptr,
-				    unsigned int num_pages,
-				    enum hrt_userptr_type type,
-				    bool cached)
+static ia_css_ptr __hrt_isp_css_mm_alloc(size_t bytes,
+					 const void __user *userptr,
+					 unsigned int num_pages,
+					 enum hrt_userptr_type type,
+					 bool cached)
 {
 #ifdef CONFIG_ION
 	if (type == HRT_USR_ION)
@@ -78,10 +79,11 @@ ia_css_ptr hrt_isp_css_mm_alloc(size_t bytes)
 				      my_num_pages, my_usr_type, false);
 }
 
-ia_css_ptr hrt_isp_css_mm_alloc_user_ptr(size_t bytes, void *userptr,
-				    unsigned int num_pages,
-				    enum hrt_userptr_type type,
-				    bool cached)
+ia_css_ptr hrt_isp_css_mm_alloc_user_ptr(size_t bytes,
+					 const void __user *userptr,
+					 unsigned int num_pages,
+					 enum hrt_userptr_type type,
+					 bool cached)
 {
 	return __hrt_isp_css_mm_alloc(bytes, userptr, num_pages,
 				      type, cached);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
index 15c2dfb6794e..93762e71b4ca 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
@@ -37,15 +37,16 @@ struct hrt_userbuffer_attr {
 	unsigned int		pgnr;
 };
 
-void hrt_isp_css_mm_set_user_ptr(void *userptr,
+void hrt_isp_css_mm_set_user_ptr(void __user *userptr,
 				unsigned int num_pages, enum hrt_userptr_type);
 
 /* Allocate memory, returns a virtual address */
 ia_css_ptr hrt_isp_css_mm_alloc(size_t bytes);
-ia_css_ptr hrt_isp_css_mm_alloc_user_ptr(size_t bytes, void *userptr,
-				    unsigned int num_pages,
-				    enum hrt_userptr_type,
-				    bool cached);
+ia_css_ptr hrt_isp_css_mm_alloc_user_ptr(size_t bytes,
+					 const void __user *userptr,
+					 unsigned int num_pages,
+					 enum hrt_userptr_type,
+					 bool cached);
 ia_css_ptr hrt_isp_css_mm_alloc_cached(size_t bytes);
 
 /* allocate memory and initialize with zeros,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm.h b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm.h
index 1e135c7c6d9b..7dcc73c9f49d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm.h
@@ -38,7 +38,7 @@ int hmm_init(void);
 void hmm_cleanup(void);
 
 ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
-		int from_highmem, void *userptr, bool cached);
+		int from_highmem, const void __user *userptr, bool cached);
 void hmm_free(ia_css_ptr ptr);
 int hmm_load(ia_css_ptr virt, void *data, unsigned int bytes);
 int hmm_store(ia_css_ptr virt, const void *data, unsigned int bytes);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h
index bd44ebbc427c..508d6fd68f93 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h
@@ -244,7 +244,7 @@ int hmm_bo_allocated(struct hmm_buffer_object *bo);
  */
 int hmm_bo_alloc_pages(struct hmm_buffer_object *bo,
 		enum hmm_bo_type type, int from_highmem,
-		void *userptr, bool cached);
+		const void __user *userptr, bool cached);
 void hmm_bo_free_pages(struct hmm_buffer_object *bo);
 int hmm_bo_page_allocated(struct hmm_buffer_object *bo);
 
-- 
2.14.3
