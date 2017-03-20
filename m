Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:33721 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755103AbdCTOiv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:38:51 -0400
Subject: [PATCH 03/24] atomisp: remove the unused debug wrapping from the
 mmgr layer
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:38:42 +0000
Message-ID: <149002071581.17109.4074675188084333051.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need this layer of indirection and the debugging information is not used. With
this removed we can then go on to try and remove the abstraction layer entirely.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../memory_access/memory_access.h                  |   80 +++-----------------
 .../pci/atomisp2/css2400/ia_css_memory_access.c    |   30 ++------
 2 files changed, 20 insertions(+), 90 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h
index e78d462..54ab3d9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h
@@ -1,6 +1,6 @@
 /*
  * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
+ * Copyright (c) 2015-2017, Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -74,7 +74,7 @@
  * within the allocation referencable from the
  * returned pointer/address.
  */
-#define MMGR_ATTRIBUTE_MASK			0x000f
+#define MMGR_ATTRIBUTE_MASK		0x000f
 #define MMGR_ATTRIBUTE_CACHED		0x0001
 #define MMGR_ATTRIBUTE_CONTIGUOUS	0x0002
 #define MMGR_ATTRIBUTE_PAGEALIGN	0x0004
@@ -87,78 +87,43 @@
 extern const hrt_vaddress	mmgr_NULL;
 extern const hrt_vaddress	mmgr_EXCEPTION;
 
-/*! Set the (sub)system virtual memory page table base address
-
- \param	base_addr[in]		The address where page table 0 is located
-
- \Note: The base_addr is an absolute system address, thus it is not
-        relative to the DDR base address
-
- \return none,
- */
-extern void mmgr_set_base_address(
-	const sys_address		base_addr);
-
 /*! Return the address of an allocation in memory
 
- \param	size[in]			Size in bytes of the allocation
+ \param	size[in]		Size in bytes of the allocation
  \param	caller_func[in]		Caller function name
  \param	caller_line[in]		Caller function line number
 
  \return vaddress
  */
-#define mmgr_malloc(__size) mmgr_malloc_ex(__size, __func__, __LINE__)
-extern hrt_vaddress mmgr_malloc_ex(
-	const size_t			size,
-	const char				*caller_func,
-	int						caller_line);
+extern hrt_vaddress mmgr_malloc(const size_t size);
 
 /*! Return the address of a zero initialised allocation in memory
 
  \param	N[in]			Horizontal dimension of array
  \param	size[in]		Vertical dimension of array  Total size is N*size
- \param	caller_func[in]		Caller function name
- \param	caller_line[in]		Caller function line number
 
  \return vaddress
  */
-#define mmgr_calloc(__N, __size) mmgr_calloc_ex(__N, __size, __func__, __LINE__)
-extern hrt_vaddress mmgr_calloc_ex(
-	const size_t			N,
-	const size_t			size,
-	const char				*caller_func,
-	int						caller_line);
+extern hrt_vaddress mmgr_calloc(const size_t N, const size_t size);
 
 /*! Free the memory allocation identified by the address
 
  \param	vaddr[in]		Address of the allocation
- \param	caller_func[in]		Caller function name
- \param	caller_line[in]		Caller function line number
 
  \return vaddress
  */
-#define mmgr_free(__vaddr) mmgr_free_ex(__vaddr, __func__, __LINE__)
-extern void mmgr_free_ex(
-	hrt_vaddress			vaddr,
-	const char				*caller_func,
-	int						caller_line);
+extern void mmgr_free(hrt_vaddress vaddr);
 
 /*! Return the address of an allocation in memory
 
  \param	size[in]		Size in bytes of the allocation
  \param	attribute[in]		Bit vector specifying the properties
 				of the allocation including zero initialisation
- \param	caller_func[in]		Caller function name
- \param	caller_line[in]		Caller function line number
 
  \return vaddress
  */
-#define mmgr_alloc_attr(__size, __attribute) mmgr_alloc_attr_ex(__size, __attribute, __func__, __LINE__)
-extern hrt_vaddress mmgr_alloc_attr_ex(
-	const size_t			size,
-	const uint16_t			attribute,
-	const char				*caller_func,
-	int						caller_line);
+
+extern hrt_vaddress mmgr_alloc_attr(const size_t size, const uint16_t attribute);
 
 /*! Return the address of a mapped existing allocation in memory
 
@@ -187,52 +152,29 @@ extern hrt_vaddress mmgr_mmap(
 
  \param	vaddr[in]		Address of an allocation
  \param	size[in]		Size in bytes of the area to be cleared
- \param	caller_func[in]		Caller function name
- \param	caller_line[in]		Caller function line number
 
  \return none
  */
-#define mmgr_clear(__vaddr, __size) mmgr_clear_ex(__vaddr, __size, __func__, __LINE__)
-extern void mmgr_clear_ex(
-	hrt_vaddress			vaddr,
-	const size_t			size,
-	const char			*caller_func,
-	int				caller_line);
+extern void mmgr_clear(hrt_vaddress vaddr, const size_t	size);
 
 /*! Read an array of bytes from a virtual memory address
 
  \param	vaddr[in]		Address of an allocation
  \param	data[out]		pointer to the destination array
  \param	size[in]		number of bytes to read
- \param	caller_func[in]		Caller function name
- \param	caller_line[in]		Caller function line number
 
  \return none
  */
-#define mmgr_load(__vaddr, __data, __size) mmgr_load_ex(__vaddr, __data, __size, __func__, __LINE__)
-extern void mmgr_load_ex(
-	const hrt_vaddress		vaddr,
-	void				*data,
-	const size_t			size,
-	const char			*caller_func,
-	int				caller_line);
+extern void mmgr_load(const hrt_vaddress vaddr, void *data, const size_t size);
 
 /*! Write an array of bytes to device registers or memory in the device
 
  \param	vaddr[in]		Address of an allocation
  \param	data[in]		pointer to the source array
  \param	size[in]		number of bytes to write
- \param	caller_func[in]		Caller function name
- \param	caller_line[in]		Caller function line number
 
  \return none
  */
-#define mmgr_store(__vaddr, __data, __size) mmgr_store_ex(__vaddr, __data, __size, __func__, __LINE__)
-extern void mmgr_store_ex(
-	const hrt_vaddress		vaddr,
-	const void				*data,
-	const size_t			size,
-	const char				*caller_func,
-	int						caller_line);
+extern void mmgr_store(const hrt_vaddress vaddr, const void *data, const size_t size);
 
 #endif /* __MEMORY_ACCESS_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
index 8dfb670..a140cec 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_memory_access.c
@@ -1,6 +1,6 @@
 /*
  * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
+ * Copyright (c) 2015-2017, Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -33,12 +33,12 @@ ia_css_memory_access_init(const struct ia_css_css_mem_env *env)
 }
 
 hrt_vaddress
-mmgr_malloc_ex(const size_t size, const char *caller_func, int caller_line)
+mmgr_malloc(const size_t size)
 {
-	return mmgr_alloc_attr_ex(size, 0, caller_func, caller_line);
+	return mmgr_alloc_attr(size, 0);
 }
 
-hrt_vaddress mmgr_alloc_attr_ex(const size_t size, const uint16_t attrs, const char *caller_func, int caller_line)
+hrt_vaddress mmgr_alloc_attr(const size_t size, const uint16_t attrs)
 {
 	uint32_t my_attrs = 0;
 	uint16_t masked_attrs = attrs & MMGR_ATTRIBUTE_MASK;
@@ -53,49 +53,37 @@ hrt_vaddress mmgr_alloc_attr_ex(const size_t size, const uint16_t attrs, const c
 	if (masked_attrs & MMGR_ATTRIBUTE_PAGEALIGN)
 		my_attrs |= IA_CSS_MEM_ATTR_PAGEALIGN;
 
-	(void)caller_func;
-	(void)caller_line;
 	ptr = my_env.alloc(size, my_attrs);
 	return ptr;
 }
 
 hrt_vaddress
-mmgr_calloc_ex(const size_t N, const size_t size, const char *caller_func, int caller_line)
+mmgr_calloc(const size_t N, const size_t size)
 {
-	(void)caller_func;
-	(void)caller_line;
 	return mmgr_alloc_attr(size * N, MMGR_ATTRIBUTE_CLEARED);
 }
 
 void
-mmgr_free_ex(hrt_vaddress vaddr, const char *caller_func, int caller_line)
+mmgr_free(hrt_vaddress vaddr)
 {
-	(void)caller_func;
-	(void)caller_line;
 	my_env.free(vaddr);
 }
 
 void
-mmgr_clear_ex(hrt_vaddress vaddr, const size_t size, const char *caller_func, int caller_line)
+mmgr_clear(hrt_vaddress vaddr, const size_t size)
 {
-	(void)caller_func;
-	(void)caller_line;
 	my_env.set(vaddr, 0, size);
 }
 
 void
-mmgr_load_ex(const hrt_vaddress vaddr, void *data, const size_t size, const char *caller_func, int caller_line)
+mmgr_load(const hrt_vaddress vaddr, void *data, const size_t size)
 {
-	(void)caller_func;
-	(void)caller_line;
 	my_env.load(vaddr, data, size);
 }
 
 void
-mmgr_store_ex(const hrt_vaddress vaddr, const void *data, const size_t size, const char *caller_func, int caller_line)
+mmgr_store(const hrt_vaddress vaddr, const void *data, const size_t size)
 {
-	(void)caller_func;
-	(void)caller_line;
 	my_env.store(vaddr, data, size);
 }
 
