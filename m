Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37081 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753562AbdJaQEe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 12:04:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Paolo Cretaro <melko@frugalware.org>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH 6/7] media: atomisp: get rid of storage_class.h
Date: Tue, 31 Oct 2017 12:04:19 -0400
Message-Id: <9c87c18a45c3ce30bb144d17281002b6bf0ca67c.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't hide function declaration on ugly macros.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../base/circbuf/interface/ia_css_circbuf.h        | 39 +++++++++++-----------
 .../base/circbuf/interface/ia_css_circbuf_desc.h   | 15 ++++-----
 .../css_2401_csi2p_system/host/csi_rx_private.h    | 18 +++++-----
 .../hive_isp_css_common/host/fifo_monitor.c        |  8 ++---
 .../css2400/hive_isp_css_common/host/gdc.c         |  8 ++---
 .../hive_isp_css_common/host/input_system.c        | 20 +++++------
 .../css2400/hive_isp_css_common/host/irq.c         | 12 +++----
 .../css2400/hive_isp_css_include/assert_support.h  |  3 +-
 .../atomisp2/css2400/hive_isp_css_include/bamem.h  |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/csi_rx.h |  5 ---
 .../atomisp2/css2400/hive_isp_css_include/debug.h  |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/dma.h    |  7 ++--
 .../css2400/hive_isp_css_include/event_fifo.h      |  7 ++--
 .../css2400/hive_isp_css_include/fifo_monitor.h    |  7 ++--
 .../css2400/hive_isp_css_include/gdc_device.h      |  7 ++--
 .../css2400/hive_isp_css_include/gp_device.h       |  7 ++--
 .../css2400/hive_isp_css_include/gp_timer.h        |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/gpio.h   |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/hmem.h   |  7 ++--
 .../hive_isp_css_include/host/csi_rx_public.h      | 18 +++++-----
 .../css2400/hive_isp_css_include/host/gdc_public.h |  6 ++--
 .../css2400/hive_isp_css_include/host/isp_op1w.h   |  9 +++--
 .../css2400/hive_isp_css_include/host/isp_op2w.h   |  9 +++--
 .../css2400/hive_isp_css_include/host/mmu_public.h |  8 ++---
 .../hive_isp_css_include/host/ref_vector_func.h    |  9 +++--
 .../css2400/hive_isp_css_include/ibuf_ctrl.h       |  7 ++--
 .../css2400/hive_isp_css_include/input_formatter.h |  7 ++--
 .../css2400/hive_isp_css_include/input_system.h    |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/irq.h    |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/isp.h    |  7 ++--
 .../css2400/hive_isp_css_include/isys_dma.h        |  7 ++--
 .../css2400/hive_isp_css_include/isys_irq.h        |  9 +++--
 .../hive_isp_css_include/isys_stream2mmio.h        |  7 ++--
 .../css2400/hive_isp_css_include/math_support.h    | 25 +++++++-------
 .../css2400/hive_isp_css_include/mmu_device.h      |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/mpmath.h |  9 +++--
 .../atomisp2/css2400/hive_isp_css_include/osys.h   |  7 ++--
 .../css2400/hive_isp_css_include/pixelgen.h        |  7 ++--
 .../hive_isp_css_include/platform_support.h        |  1 -
 .../css2400/hive_isp_css_include/print_support.h   |  3 +-
 .../atomisp2/css2400/hive_isp_css_include/queue.h  |  7 ++--
 .../css2400/hive_isp_css_include/resource.h        |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/socket.h |  7 ++--
 .../pci/atomisp2/css2400/hive_isp_css_include/sp.h |  7 ++--
 .../css2400/hive_isp_css_include/storage_class.h   | 34 -------------------
 .../css2400/hive_isp_css_include/stream_buffer.h   |  7 ++--
 .../css2400/hive_isp_css_include/string_support.h  |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/tag.h    |  7 ++--
 .../css2400/hive_isp_css_include/timed_ctrl.h      |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/vamem.h  |  7 ++--
 .../css2400/hive_isp_css_include/vector_func.h     |  7 ++--
 .../css2400/hive_isp_css_include/vector_ops.h      |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/vmem.h   |  7 ++--
 .../atomisp2/css2400/hive_isp_css_include/xmem.h   |  7 ++--
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c      |  2 +-
 .../pci/atomisp2/css2400/runtime/bufq/src/bufq.c   |  2 +-
 .../css2400/runtime/debug/interface/ia_css_debug.h |  2 +-
 .../css2400/runtime/inputfifo/src/inputfifo.c      | 28 ++++++++--------
 .../css2400/runtime/rmgr/interface/ia_css_rmgr.h   |  7 ++--
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |  4 +--
 60 files changed, 230 insertions(+), 314 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/storage_class.h

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/interface/ia_css_circbuf.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/interface/ia_css_circbuf.h
index 766218ed3649..914aa7f98700 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/interface/ia_css_circbuf.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/interface/ia_css_circbuf.h
@@ -18,7 +18,6 @@
 #include <sp.h>
 #include <type_support.h>
 #include <math_support.h>
-#include <storage_class.h>
 #include <assert_support.h>
 #include <platform_support.h>
 #include "ia_css_circbuf_comm.h"
@@ -45,7 +44,7 @@ struct ia_css_circbuf_s {
  * @param elems	An array of elements.
  * @param desc	The descriptor set to the size using ia_css_circbuf_desc_init().
  */
-STORAGE_CLASS_EXTERN void ia_css_circbuf_create(
+extern void ia_css_circbuf_create(
 	ia_css_circbuf_t *cb,
 	ia_css_circbuf_elem_t *elems,
 	ia_css_circbuf_desc_t *desc);
@@ -55,7 +54,7 @@ STORAGE_CLASS_EXTERN void ia_css_circbuf_create(
  *
  * @param cb The pointer to the circular buffer.
  */
-STORAGE_CLASS_EXTERN void ia_css_circbuf_destroy(
+extern void ia_css_circbuf_destroy(
 		ia_css_circbuf_t *cb);
 
 /**
@@ -68,7 +67,7 @@ STORAGE_CLASS_EXTERN void ia_css_circbuf_destroy(
  *
  * @return the pop-out value.
  */
-STORAGE_CLASS_EXTERN uint32_t ia_css_circbuf_pop(
+extern uint32_t ia_css_circbuf_pop(
 		ia_css_circbuf_t *cb);
 
 /**
@@ -82,7 +81,7 @@ STORAGE_CLASS_EXTERN uint32_t ia_css_circbuf_pop(
  *
  * @return the extracted value.
  */
-STORAGE_CLASS_EXTERN uint32_t ia_css_circbuf_extract(
+extern uint32_t ia_css_circbuf_extract(
 	ia_css_circbuf_t *cb,
 	int offset);
 
@@ -97,7 +96,7 @@ STORAGE_CLASS_EXTERN uint32_t ia_css_circbuf_extract(
  * @param elem The pointer to the element.
  * @param val  The value to be set.
  */
-STORAGE_CLASS_INLINE void ia_css_circbuf_elem_set_val(
+static inline void ia_css_circbuf_elem_set_val(
 	ia_css_circbuf_elem_t *elem,
 	uint32_t val)
 {
@@ -111,7 +110,7 @@ STORAGE_CLASS_INLINE void ia_css_circbuf_elem_set_val(
  *
  * @param elem The pointer to the element.
  */
-STORAGE_CLASS_INLINE void ia_css_circbuf_elem_init(
+static inline void ia_css_circbuf_elem_init(
 		ia_css_circbuf_elem_t *elem)
 {
 	OP___assert(elem != NULL);
@@ -124,7 +123,7 @@ STORAGE_CLASS_INLINE void ia_css_circbuf_elem_init(
  * @param src  The element as the copy source.
  * @param dest The element as the copy destination.
  */
-STORAGE_CLASS_INLINE void ia_css_circbuf_elem_cpy(
+static inline void ia_css_circbuf_elem_cpy(
 	ia_css_circbuf_elem_t *src,
 	ia_css_circbuf_elem_t *dest)
 {
@@ -143,7 +142,7 @@ STORAGE_CLASS_INLINE void ia_css_circbuf_elem_cpy(
  *
  * @return the position at offset.
  */
-STORAGE_CLASS_INLINE uint8_t ia_css_circbuf_get_pos_at_offset(
+static inline uint8_t ia_css_circbuf_get_pos_at_offset(
 	ia_css_circbuf_t *cb,
 	uint32_t base,
 	int offset)
@@ -176,7 +175,7 @@ STORAGE_CLASS_INLINE uint8_t ia_css_circbuf_get_pos_at_offset(
  *
  * @return the offset.
  */
-STORAGE_CLASS_INLINE int ia_css_circbuf_get_offset(
+static inline int ia_css_circbuf_get_offset(
 	ia_css_circbuf_t *cb,
 	uint32_t src_pos,
 	uint32_t dest_pos)
@@ -201,7 +200,7 @@ STORAGE_CLASS_INLINE int ia_css_circbuf_get_offset(
  *
  * TODO: Test this API.
  */
-STORAGE_CLASS_INLINE uint32_t ia_css_circbuf_get_size(
+static inline uint32_t ia_css_circbuf_get_size(
 		ia_css_circbuf_t *cb)
 {
 	OP___assert(cb != NULL);
@@ -217,7 +216,7 @@ STORAGE_CLASS_INLINE uint32_t ia_css_circbuf_get_size(
  *
  * @return the number of available elements.
  */
-STORAGE_CLASS_INLINE uint32_t ia_css_circbuf_get_num_elems(
+static inline uint32_t ia_css_circbuf_get_num_elems(
 		ia_css_circbuf_t *cb)
 {
 	int num;
@@ -239,7 +238,7 @@ STORAGE_CLASS_INLINE uint32_t ia_css_circbuf_get_num_elems(
  *	- true when it is empty.
  *	- false when it is not empty.
  */
-STORAGE_CLASS_INLINE bool ia_css_circbuf_is_empty(
+static inline bool ia_css_circbuf_is_empty(
 		ia_css_circbuf_t *cb)
 {
 	OP___assert(cb != NULL);
@@ -257,7 +256,7 @@ STORAGE_CLASS_INLINE bool ia_css_circbuf_is_empty(
  *	- true when it is full.
  *	- false when it is not full.
  */
-STORAGE_CLASS_INLINE bool ia_css_circbuf_is_full(ia_css_circbuf_t *cb)
+static inline bool ia_css_circbuf_is_full(ia_css_circbuf_t *cb)
 {
 	OP___assert(cb != NULL);
 	OP___assert(cb->desc != NULL);
@@ -274,7 +273,7 @@ STORAGE_CLASS_INLINE bool ia_css_circbuf_is_full(ia_css_circbuf_t *cb)
  * @param cb	The pointer to the circular buffer.
  * @param elem	The new element.
  */
-STORAGE_CLASS_INLINE void ia_css_circbuf_write(
+static inline void ia_css_circbuf_write(
 	ia_css_circbuf_t *cb,
 	ia_css_circbuf_elem_t elem)
 {
@@ -298,7 +297,7 @@ STORAGE_CLASS_INLINE void ia_css_circbuf_write(
  * @param cb	The pointer to the circular buffer.
  * @param val	The value to be pushed in.
  */
-STORAGE_CLASS_INLINE void ia_css_circbuf_push(
+static inline void ia_css_circbuf_push(
 	ia_css_circbuf_t *cb,
 	uint32_t val)
 {
@@ -321,7 +320,7 @@ STORAGE_CLASS_INLINE void ia_css_circbuf_push(
  *
  * @return: The number of free elements.
  */
-STORAGE_CLASS_INLINE uint32_t ia_css_circbuf_get_free_elems(
+static inline uint32_t ia_css_circbuf_get_free_elems(
 		ia_css_circbuf_t *cb)
 {
 	OP___assert(cb != NULL);
@@ -338,7 +337,7 @@ STORAGE_CLASS_INLINE uint32_t ia_css_circbuf_get_free_elems(
  *
  * @return the elements value.
  */
-STORAGE_CLASS_EXTERN uint32_t ia_css_circbuf_peek(
+extern uint32_t ia_css_circbuf_peek(
 	ia_css_circbuf_t *cb,
 	int offset);
 
@@ -350,7 +349,7 @@ STORAGE_CLASS_EXTERN uint32_t ia_css_circbuf_peek(
  *
  * @return the elements value.
  */
-STORAGE_CLASS_EXTERN uint32_t ia_css_circbuf_peek_from_start(
+extern uint32_t ia_css_circbuf_peek_from_start(
 	ia_css_circbuf_t *cb,
 	int offset);
 
@@ -369,7 +368,7 @@ STORAGE_CLASS_EXTERN uint32_t ia_css_circbuf_peek_from_start(
  * @return	true on succesfully increasing the size
  * 			false on failure
  */
-STORAGE_CLASS_EXTERN bool ia_css_circbuf_increase_size(
+extern bool ia_css_circbuf_increase_size(
 		ia_css_circbuf_t *cb,
 		unsigned int sz_delta,
 		ia_css_circbuf_elem_t *elems);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/interface/ia_css_circbuf_desc.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/interface/ia_css_circbuf_desc.h
index a8447d409c31..8dd7cd6cd3d8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/interface/ia_css_circbuf_desc.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/interface/ia_css_circbuf_desc.h
@@ -17,7 +17,6 @@
 
 #include <type_support.h>
 #include <math_support.h>
-#include <storage_class.h>
 #include <platform_support.h>
 #include <sp.h>
 #include "ia_css_circbuf_comm.h"
@@ -35,7 +34,7 @@
  *	- true when it is empty.
  *	- false when it is not empty.
  */
-STORAGE_CLASS_INLINE bool ia_css_circbuf_desc_is_empty(
+static inline bool ia_css_circbuf_desc_is_empty(
 		ia_css_circbuf_desc_t *cb_desc)
 {
 	OP___assert(cb_desc != NULL);
@@ -52,7 +51,7 @@ STORAGE_CLASS_INLINE bool ia_css_circbuf_desc_is_empty(
  *	- true when it is full.
  *	- false when it is not full.
  */
-STORAGE_CLASS_INLINE bool ia_css_circbuf_desc_is_full(
+static inline bool ia_css_circbuf_desc_is_full(
 		ia_css_circbuf_desc_t *cb_desc)
 {
 	OP___assert(cb_desc != NULL);
@@ -65,7 +64,7 @@ STORAGE_CLASS_INLINE bool ia_css_circbuf_desc_is_full(
  * @param cb_desc	The pointer circular buffer descriptor
  * @param size		The size of the circular buffer
  */
-STORAGE_CLASS_INLINE void ia_css_circbuf_desc_init(
+static inline void ia_css_circbuf_desc_init(
 	ia_css_circbuf_desc_t *cb_desc,
 	int8_t size)
 {
@@ -82,7 +81,7 @@ STORAGE_CLASS_INLINE void ia_css_circbuf_desc_init(
  *
  * @return the position in the circular buffer descriptor.
  */
-STORAGE_CLASS_INLINE uint8_t ia_css_circbuf_desc_get_pos_at_offset(
+static inline uint8_t ia_css_circbuf_desc_get_pos_at_offset(
 	ia_css_circbuf_desc_t *cb_desc,
 	uint32_t base,
 	int offset)
@@ -114,7 +113,7 @@ STORAGE_CLASS_INLINE uint8_t ia_css_circbuf_desc_get_pos_at_offset(
  *
  * @return the offset.
  */
-STORAGE_CLASS_INLINE int ia_css_circbuf_desc_get_offset(
+static inline int ia_css_circbuf_desc_get_offset(
 	ia_css_circbuf_desc_t *cb_desc,
 	uint32_t src_pos,
 	uint32_t dest_pos)
@@ -135,7 +134,7 @@ STORAGE_CLASS_INLINE int ia_css_circbuf_desc_get_offset(
  *
  * @return The number of available elements.
  */
-STORAGE_CLASS_INLINE uint32_t ia_css_circbuf_desc_get_num_elems(
+static inline uint32_t ia_css_circbuf_desc_get_num_elems(
 		ia_css_circbuf_desc_t *cb_desc)
 {
 	int num;
@@ -155,7 +154,7 @@ STORAGE_CLASS_INLINE uint32_t ia_css_circbuf_desc_get_num_elems(
  *
  * @return: The number of free elements.
  */
-STORAGE_CLASS_INLINE uint32_t ia_css_circbuf_desc_get_free_elems(
+static inline uint32_t ia_css_circbuf_desc_get_free_elems(
 		ia_css_circbuf_desc_t *cb_desc)
 {
 	uint32_t num;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h
index 5819bcff5e55..6720ab55d6f5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h
@@ -34,7 +34,7 @@
  * @brief Get the csi rx fe state.
  * Refer to "csi_rx_public.h" for details.
  */
-STORAGE_CLASS_CSI_RX_C void csi_rx_fe_ctrl_get_state(
+static inline void csi_rx_fe_ctrl_get_state(
 		const csi_rx_frontend_ID_t ID,
 		csi_rx_fe_ctrl_state_t *state)
 {
@@ -73,7 +73,7 @@ STORAGE_CLASS_CSI_RX_C void csi_rx_fe_ctrl_get_state(
  * @brief Get the state of the csi rx fe dlane process.
  * Refer to "csi_rx_public.h" for details.
  */
-STORAGE_CLASS_CSI_RX_C void csi_rx_fe_ctrl_get_dlane_state(
+static inline void csi_rx_fe_ctrl_get_dlane_state(
 		const csi_rx_frontend_ID_t ID,
 		const uint32_t lane,
 		csi_rx_fe_ctrl_lane_t *dlane_state)
@@ -89,7 +89,7 @@ STORAGE_CLASS_CSI_RX_C void csi_rx_fe_ctrl_get_dlane_state(
  * @brief dump the csi rx fe state.
  * Refer to "csi_rx_public.h" for details.
  */
-STORAGE_CLASS_CSI_RX_C void csi_rx_fe_ctrl_dump_state(
+static inline void csi_rx_fe_ctrl_dump_state(
 		const csi_rx_frontend_ID_t ID,
 		csi_rx_fe_ctrl_state_t *state)
 {
@@ -118,7 +118,7 @@ STORAGE_CLASS_CSI_RX_C void csi_rx_fe_ctrl_dump_state(
  * @brief Get the csi rx be state.
  * Refer to "csi_rx_public.h" for details.
  */
-STORAGE_CLASS_CSI_RX_C void csi_rx_be_ctrl_get_state(
+static inline void csi_rx_be_ctrl_get_state(
 		const csi_rx_backend_ID_t ID,
 		csi_rx_be_ctrl_state_t *state)
 {
@@ -181,7 +181,7 @@ STORAGE_CLASS_CSI_RX_C void csi_rx_be_ctrl_get_state(
  * @brief Dump the csi rx be state.
  * Refer to "csi_rx_public.h" for details.
  */
-STORAGE_CLASS_CSI_RX_C void csi_rx_be_ctrl_dump_state(
+static inline void csi_rx_be_ctrl_dump_state(
 		const csi_rx_backend_ID_t ID,
 		csi_rx_be_ctrl_state_t *state)
 {
@@ -225,7 +225,7 @@ STORAGE_CLASS_CSI_RX_C void csi_rx_be_ctrl_dump_state(
  * @brief Load the register value.
  * Refer to "csi_rx_public.h" for details.
  */
-STORAGE_CLASS_CSI_RX_C hrt_data csi_rx_fe_ctrl_reg_load(
+static inline hrt_data csi_rx_fe_ctrl_reg_load(
 	const csi_rx_frontend_ID_t ID,
 	const hrt_address reg)
 {
@@ -239,7 +239,7 @@ STORAGE_CLASS_CSI_RX_C hrt_data csi_rx_fe_ctrl_reg_load(
  * @brief Store a value to the register.
  * Refer to "ibuf_ctrl_public.h" for details.
  */
-STORAGE_CLASS_CSI_RX_C void csi_rx_fe_ctrl_reg_store(
+static inline void csi_rx_fe_ctrl_reg_store(
 	const csi_rx_frontend_ID_t ID,
 	const hrt_address reg,
 	const hrt_data value)
@@ -253,7 +253,7 @@ STORAGE_CLASS_CSI_RX_C void csi_rx_fe_ctrl_reg_store(
  * @brief Load the register value.
  * Refer to "csi_rx_public.h" for details.
  */
-STORAGE_CLASS_CSI_RX_C hrt_data csi_rx_be_ctrl_reg_load(
+static inline hrt_data csi_rx_be_ctrl_reg_load(
 	const csi_rx_backend_ID_t ID,
 	const hrt_address reg)
 {
@@ -267,7 +267,7 @@ STORAGE_CLASS_CSI_RX_C hrt_data csi_rx_be_ctrl_reg_load(
  * @brief Store a value to the register.
  * Refer to "ibuf_ctrl_public.h" for details.
  */
-STORAGE_CLASS_CSI_RX_C void csi_rx_be_ctrl_reg_store(
+static inline void csi_rx_be_ctrl_reg_store(
 	const csi_rx_backend_ID_t ID,
 	const hrt_address reg,
 	const hrt_data value)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/fifo_monitor.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/fifo_monitor.c
index 1087944d637f..1bf292401adc 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/fifo_monitor.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/fifo_monitor.c
@@ -38,12 +38,12 @@ STORAGE_CLASS_FIFO_MONITOR_DATA unsigned int FIFO_SWITCH_ADDR[N_FIFO_SWITCH] = {
 #include "fifo_monitor_private.h"
 #endif /* __INLINE_FIFO_MONITOR__ */
 
-STORAGE_CLASS_INLINE bool fifo_monitor_status_valid (
+static inline bool fifo_monitor_status_valid (
 	const fifo_monitor_ID_t		ID,
 	const unsigned int			reg,
 	const unsigned int			port_id);
 
-STORAGE_CLASS_INLINE bool fifo_monitor_status_accept(
+static inline bool fifo_monitor_status_accept(
 	const fifo_monitor_ID_t		ID,
 	const unsigned int			reg,
 	const unsigned int			port_id);
@@ -546,7 +546,7 @@ void fifo_monitor_get_state(
 	return;
 }
 
-STORAGE_CLASS_INLINE bool fifo_monitor_status_valid (
+static inline bool fifo_monitor_status_valid (
 	const fifo_monitor_ID_t		ID,
 	const unsigned int			reg,
 	const unsigned int			port_id)
@@ -556,7 +556,7 @@ STORAGE_CLASS_INLINE bool fifo_monitor_status_valid (
 	return (data >> (((port_id * 2) + _hive_str_mon_valid_offset))) & 0x1;
 }
 
-STORAGE_CLASS_INLINE bool fifo_monitor_status_accept(
+static inline bool fifo_monitor_status_accept(
 	const fifo_monitor_ID_t		ID,
 	const unsigned int			reg,
 	const unsigned int			port_id)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gdc.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gdc.c
index 4d6308abd036..1966b147f8ab 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gdc.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gdc.c
@@ -22,12 +22,12 @@
 /*
  * Local function declarations
  */
-STORAGE_CLASS_INLINE void gdc_reg_store(
+static inline void gdc_reg_store(
 	const gdc_ID_t		ID,
 	const unsigned int	reg,
 	const hrt_data		value);
 
-STORAGE_CLASS_INLINE hrt_data gdc_reg_load(
+static inline hrt_data gdc_reg_load(
 	const gdc_ID_t		ID,
 	const unsigned int	reg);
 
@@ -110,7 +110,7 @@ int gdc_get_unity(
 /*
  * Local function implementations
  */
-STORAGE_CLASS_INLINE void gdc_reg_store(
+static inline void gdc_reg_store(
 	const gdc_ID_t		ID,
 	const unsigned int	reg,
 	const hrt_data		value)
@@ -119,7 +119,7 @@ STORAGE_CLASS_INLINE void gdc_reg_store(
 	return;
 }
 
-STORAGE_CLASS_INLINE hrt_data gdc_reg_load(
+static inline hrt_data gdc_reg_load(
 	const gdc_ID_t		ID,
 	const unsigned int	reg)
 {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
index cd2096fa75c8..bd6821e436b2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
@@ -81,27 +81,27 @@ static input_system_error_t input_system_multiplexer_cfg(
 
 
 
-STORAGE_CLASS_INLINE void capture_unit_get_state(
+static inline void capture_unit_get_state(
 	const input_system_ID_t			ID,
 	const sub_system_ID_t			sub_id,
 	capture_unit_state_t			*state);
 
-STORAGE_CLASS_INLINE void acquisition_unit_get_state(
+static inline void acquisition_unit_get_state(
 	const input_system_ID_t			ID,
 	const sub_system_ID_t			sub_id,
 	acquisition_unit_state_t		*state);
 
-STORAGE_CLASS_INLINE void ctrl_unit_get_state(
+static inline void ctrl_unit_get_state(
 	const input_system_ID_t			ID,
 	const sub_system_ID_t			sub_id,
 	ctrl_unit_state_t				*state);
 
-STORAGE_CLASS_INLINE void mipi_port_get_state(
+static inline void mipi_port_get_state(
 	const rx_ID_t					ID,
 	const mipi_port_ID_t			port_ID,
 	mipi_port_state_t				*state);
 
-STORAGE_CLASS_INLINE void rx_channel_get_state(
+static inline void rx_channel_get_state(
 	const rx_ID_t					ID,
 	const unsigned int				ch_id,
 	rx_channel_state_t				*state);
@@ -359,7 +359,7 @@ void receiver_irq_clear(
 	return;
 }
 
-STORAGE_CLASS_INLINE void capture_unit_get_state(
+static inline void capture_unit_get_state(
 	const input_system_ID_t			ID,
 	const sub_system_ID_t			sub_id,
 	capture_unit_state_t			*state)
@@ -421,7 +421,7 @@ STORAGE_CLASS_INLINE void capture_unit_get_state(
 	return;
 }
 
-STORAGE_CLASS_INLINE void acquisition_unit_get_state(
+static inline void acquisition_unit_get_state(
 	const input_system_ID_t			ID,
 	const sub_system_ID_t			sub_id,
 	acquisition_unit_state_t		*state)
@@ -471,7 +471,7 @@ STORAGE_CLASS_INLINE void acquisition_unit_get_state(
 	return;
 }
 
-STORAGE_CLASS_INLINE void ctrl_unit_get_state(
+static inline void ctrl_unit_get_state(
 	const input_system_ID_t			ID,
 	const sub_system_ID_t			sub_id,
 	ctrl_unit_state_t			*state)
@@ -554,7 +554,7 @@ STORAGE_CLASS_INLINE void ctrl_unit_get_state(
 	return;
 }
 
-STORAGE_CLASS_INLINE void mipi_port_get_state(
+static inline void mipi_port_get_state(
 	const rx_ID_t				ID,
 	const mipi_port_ID_t			port_ID,
 	mipi_port_state_t			*state)
@@ -590,7 +590,7 @@ STORAGE_CLASS_INLINE void mipi_port_get_state(
 	return;
 }
 
-STORAGE_CLASS_INLINE void rx_channel_get_state(
+static inline void rx_channel_get_state(
 	const rx_ID_t					ID,
 	const unsigned int				ch_id,
 	rx_channel_state_t				*state)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq.c
index a42dad69cb3c..51daf76c2aea 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq.c
@@ -22,13 +22,13 @@
 
 #include "platform_support.h"			/* hrt_sleep() */
 
-STORAGE_CLASS_INLINE void irq_wait_for_write_complete(
+static inline void irq_wait_for_write_complete(
 	const irq_ID_t		ID);
 
-STORAGE_CLASS_INLINE bool any_irq_channel_enabled(
+static inline bool any_irq_channel_enabled(
 	const irq_ID_t				ID);
 
-STORAGE_CLASS_INLINE irq_ID_t virq_get_irq_id(
+static inline irq_ID_t virq_get_irq_id(
 	const virq_id_t		irq_ID,
 	unsigned int		*channel_ID);
 
@@ -406,7 +406,7 @@ enum hrt_isp_css_irq_status virq_get_channel_id(
 	return status;
 }
 
-STORAGE_CLASS_INLINE void irq_wait_for_write_complete(
+static inline void irq_wait_for_write_complete(
 	const irq_ID_t		ID)
 {
 	assert(ID < N_IRQ_ID);
@@ -415,7 +415,7 @@ STORAGE_CLASS_INLINE void irq_wait_for_write_complete(
 		_HRT_IRQ_CONTROLLER_ENABLE_REG_IDX*sizeof(hrt_data));
 }
 
-STORAGE_CLASS_INLINE bool any_irq_channel_enabled(
+static inline bool any_irq_channel_enabled(
 	const irq_ID_t				ID)
 {
 	hrt_data	en_reg;
@@ -428,7 +428,7 @@ STORAGE_CLASS_INLINE bool any_irq_channel_enabled(
 	return (en_reg != 0);
 }
 
-STORAGE_CLASS_INLINE irq_ID_t virq_get_irq_id(
+static inline irq_ID_t virq_get_irq_id(
 	const virq_id_t		irq_ID,
 	unsigned int		*channel_ID)
 {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
index 92fb15d04703..fd0d92e87c36 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/assert_support.h
@@ -15,7 +15,6 @@
 #ifndef __ASSERT_SUPPORT_H_INCLUDED__
 #define __ASSERT_SUPPORT_H_INCLUDED__
 
-#include "storage_class.h"
 
 /**
  * The following macro can help to test the size of a struct at compile
@@ -92,7 +91,7 @@
  * The implemenation for the pipe generation tool is in see support.isp.h */
 #define OP___assert(cnd) assert(cnd)
 
-STORAGE_CLASS_INLINE void compile_time_assert (unsigned cond)
+static inline void compile_time_assert (unsigned cond)
 {
 	/* Call undefined function if cond is false */
 	extern void _compile_time_assert (void);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/bamem.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/bamem.h
index d71e08f27a42..6928965cf513 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/bamem.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/bamem.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "bamem_local.h"
 
 #ifndef __INLINE_BAMEM__
-#define STORAGE_CLASS_BAMEM_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_BAMEM_H extern
 #define STORAGE_CLASS_BAMEM_C
 #include "bamem_public.h"
 #else  /* __INLINE_BAMEM__ */
-#define STORAGE_CLASS_BAMEM_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_BAMEM_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_BAMEM_H static inline
+#define STORAGE_CLASS_BAMEM_C static inline
 #include "bamem_private.h"
 #endif /* __INLINE_BAMEM__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/csi_rx.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/csi_rx.h
index 0398f5802f05..917ee8cdb1d9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/csi_rx.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/csi_rx.h
@@ -30,18 +30,13 @@
  * - local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "csi_rx_local.h"
 
 #ifndef __INLINE_CSI_RX__
-#define STORAGE_CLASS_CSI_RX_H STORAGE_CLASS_EXTERN
-#define STORAGE_CLASS_CSI_RX_C
 #include "csi_rx_public.h"
 #else  /* __INLINE_CSI_RX__ */
-#define STORAGE_CLASS_CSI_RX_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_CSI_RX_C STORAGE_CLASS_INLINE
 #include "csi_rx_private.h"
 #endif /* __INLINE_CSI_RX__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/debug.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/debug.h
index 7d8011735033..0aa22446e27e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/debug.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/debug.h
@@ -30,18 +30,17 @@
  *
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "debug_local.h"
 
 #ifndef __INLINE_DEBUG__
-#define STORAGE_CLASS_DEBUG_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_DEBUG_H extern
 #define STORAGE_CLASS_DEBUG_C 
 #include "debug_public.h"
 #else  /* __INLINE_DEBUG__ */
-#define STORAGE_CLASS_DEBUG_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_DEBUG_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_DEBUG_H static inline
+#define STORAGE_CLASS_DEBUG_C static inline
 #include "debug_private.h"
 #endif /* __INLINE_DEBUG__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/dma.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/dma.h
index b266191f21ef..d9dee691e3f8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/dma.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/dma.h
@@ -30,18 +30,17 @@
  *
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "dma_local.h"
 
 #ifndef __INLINE_DMA__
-#define STORAGE_CLASS_DMA_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_DMA_H extern
 #define STORAGE_CLASS_DMA_C 
 #include "dma_public.h"
 #else  /* __INLINE_DMA__ */
-#define STORAGE_CLASS_DMA_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_DMA_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_DMA_H static inline
+#define STORAGE_CLASS_DMA_C static inline
 #include "dma_private.h"
 #endif /* __INLINE_DMA__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/event_fifo.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/event_fifo.h
index 78827c554cc3..df579e902796 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/event_fifo.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/event_fifo.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "event_fifo_local.h"
 
 #ifndef __INLINE_EVENT__
-#define STORAGE_CLASS_EVENT_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_EVENT_H extern
 #define STORAGE_CLASS_EVENT_C 
 #include "event_fifo_public.h"
 #else  /* __INLINE_EVENT__ */
-#define STORAGE_CLASS_EVENT_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_EVENT_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_EVENT_H static inline
+#define STORAGE_CLASS_EVENT_C static inline
 #include "event_fifo_private.h"
 #endif /* __INLINE_EVENT__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/fifo_monitor.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/fifo_monitor.h
index 3bdd260bcaa5..f10c4fa2e32b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/fifo_monitor.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/fifo_monitor.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "fifo_monitor_local.h"
 
 #ifndef __INLINE_FIFO_MONITOR__
-#define STORAGE_CLASS_FIFO_MONITOR_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_FIFO_MONITOR_H extern
 #define STORAGE_CLASS_FIFO_MONITOR_C 
 #include "fifo_monitor_public.h"
 #else  /* __INLINE_FIFO_MONITOR__ */
-#define STORAGE_CLASS_FIFO_MONITOR_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_FIFO_MONITOR_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_FIFO_MONITOR_H static inline
+#define STORAGE_CLASS_FIFO_MONITOR_C static inline
 #include "fifo_monitor_private.h"
 #endif /* __INLINE_FIFO_MONITOR__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gdc_device.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gdc_device.h
index 016132ba0b7f..75c6854c8e7b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gdc_device.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gdc_device.h
@@ -31,18 +31,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "gdc_local.h"
 
 #ifndef __INLINE_GDC__
-#define STORAGE_CLASS_GDC_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_GDC_H extern
 #define STORAGE_CLASS_GDC_C 
 #include "gdc_public.h"
 #else  /* __INLINE_GDC__ */
-#define STORAGE_CLASS_GDC_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_GDC_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_GDC_H static inline
+#define STORAGE_CLASS_GDC_C static inline
 #include "gdc_private.h"
 #endif /* __INLINE_GDC__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gp_device.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gp_device.h
index 766d2532d8f9..aba94e623043 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gp_device.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gp_device.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "gp_device_local.h"
 
 #ifndef __INLINE_GP_DEVICE__
-#define STORAGE_CLASS_GP_DEVICE_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_GP_DEVICE_H extern
 #define STORAGE_CLASS_GP_DEVICE_C 
 #include "gp_device_public.h"
 #else  /* __INLINE_GP_DEVICE__ */
-#define STORAGE_CLASS_GP_DEVICE_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_GP_DEVICE_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_GP_DEVICE_H static inline
+#define STORAGE_CLASS_GP_DEVICE_C static inline
 #include "gp_device_private.h"
 #endif /* __INLINE_GP_DEVICE__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gp_timer.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gp_timer.h
index ca70f5603bf8..d5d2df24e11a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gp_timer.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gp_timer.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"    /*GP_TIMER_BASE address */
 #include "gp_timer_local.h"  /*GP_TIMER register offsets */
 
 #ifndef __INLINE_GP_TIMER__
-#define STORAGE_CLASS_GP_TIMER_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_GP_TIMER_H extern
 #define STORAGE_CLASS_GP_TIMER_C
 #include "gp_timer_public.h"   /* functions*/
 #else  /* __INLINE_GP_TIMER__ */
-#define STORAGE_CLASS_GP_TIMER_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_GP_TIMER_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_GP_TIMER_H static inline
+#define STORAGE_CLASS_GP_TIMER_C static inline
 #include "gp_timer_private.h"  /* inline functions*/
 #endif /* __INLINE_GP_TIMER__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gpio.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gpio.h
index dec21bcb6f47..d37f7166aa4a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gpio.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/gpio.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "gpio_local.h"
 
 #ifndef __INLINE_GPIO__
-#define STORAGE_CLASS_GPIO_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_GPIO_H extern
 #define STORAGE_CLASS_GPIO_C 
 #include "gpio_public.h"
 #else  /* __INLINE_GPIO__ */
-#define STORAGE_CLASS_GPIO_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_GPIO_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_GPIO_H static inline
+#define STORAGE_CLASS_GPIO_C static inline
 #include "gpio_private.h"
 #endif /* __INLINE_GPIO__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/hmem.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/hmem.h
index 671dd5b5fca6..a82fd3a21e98 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/hmem.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/hmem.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "hmem_local.h"
 
 #ifndef __INLINE_HMEM__
-#define STORAGE_CLASS_HMEM_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_HMEM_H extern
 #define STORAGE_CLASS_HMEM_C 
 #include "hmem_public.h"
 #else  /* __INLINE_HMEM__ */
-#define STORAGE_CLASS_HMEM_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_HMEM_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_HMEM_H static inline
+#define STORAGE_CLASS_HMEM_C static inline
 #include "hmem_private.h"
 #endif /* __INLINE_HMEM__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/csi_rx_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/csi_rx_public.h
index 396240954bed..3b5df85fc510 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/csi_rx_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/csi_rx_public.h
@@ -28,7 +28,7 @@
  * @param[in]	id	The global unique ID of the csi rx fe controller.
  * @param[out]	state	Point to the register-state.
  */
-STORAGE_CLASS_CSI_RX_H void csi_rx_fe_ctrl_get_state(
+extern void csi_rx_fe_ctrl_get_state(
 		const csi_rx_frontend_ID_t ID,
 		csi_rx_fe_ctrl_state_t *state);
 /**
@@ -38,7 +38,7 @@ STORAGE_CLASS_CSI_RX_H void csi_rx_fe_ctrl_get_state(
  * @param[in]	id	The global unique ID of the csi rx fe controller.
  * @param[in]	state	Point to the register-state.
  */
-STORAGE_CLASS_CSI_RX_H void csi_rx_fe_ctrl_dump_state(
+extern void csi_rx_fe_ctrl_dump_state(
 		const csi_rx_frontend_ID_t ID,
 		csi_rx_fe_ctrl_state_t *state);
 /**
@@ -49,7 +49,7 @@ STORAGE_CLASS_CSI_RX_H void csi_rx_fe_ctrl_dump_state(
  * @param[in]	lane		The lane ID.
  * @param[out]	state		Point to the dlane state.
  */
-STORAGE_CLASS_CSI_RX_H void csi_rx_fe_ctrl_get_dlane_state(
+extern void csi_rx_fe_ctrl_get_dlane_state(
 		const csi_rx_frontend_ID_t ID,
 		const uint32_t lane,
 		csi_rx_fe_ctrl_lane_t *dlane_state);
@@ -60,7 +60,7 @@ STORAGE_CLASS_CSI_RX_H void csi_rx_fe_ctrl_get_dlane_state(
  * @param[in]	id	The global unique ID of the csi rx be controller.
  * @param[out]	state	Point to the register-state.
  */
-STORAGE_CLASS_CSI_RX_H void csi_rx_be_ctrl_get_state(
+extern void csi_rx_be_ctrl_get_state(
 		const csi_rx_backend_ID_t ID,
 		csi_rx_be_ctrl_state_t *state);
 /**
@@ -70,7 +70,7 @@ STORAGE_CLASS_CSI_RX_H void csi_rx_be_ctrl_get_state(
  * @param[in]	id	The global unique ID of the csi rx be controller.
  * @param[in]	state	Point to the register-state.
  */
-STORAGE_CLASS_CSI_RX_H void csi_rx_be_ctrl_dump_state(
+extern void csi_rx_be_ctrl_dump_state(
 		const csi_rx_backend_ID_t ID,
 		csi_rx_be_ctrl_state_t *state);
 /** end of NCI */
@@ -89,7 +89,7 @@ STORAGE_CLASS_CSI_RX_H void csi_rx_be_ctrl_dump_state(
  *
  * @return the value of the register.
  */
-STORAGE_CLASS_CSI_RX_H hrt_data csi_rx_fe_ctrl_reg_load(
+extern hrt_data csi_rx_fe_ctrl_reg_load(
 	const csi_rx_frontend_ID_t ID,
 	const hrt_address reg);
 /**
@@ -101,7 +101,7 @@ STORAGE_CLASS_CSI_RX_H hrt_data csi_rx_fe_ctrl_reg_load(
  * @param[in]	value	The value to be stored.
  *
  */
-STORAGE_CLASS_CSI_RX_H void csi_rx_fe_ctrl_reg_store(
+extern void csi_rx_fe_ctrl_reg_store(
 	const csi_rx_frontend_ID_t ID,
 	const hrt_address reg,
 	const hrt_data value);
@@ -114,7 +114,7 @@ STORAGE_CLASS_CSI_RX_H void csi_rx_fe_ctrl_reg_store(
  *
  * @return the value of the register.
  */
-STORAGE_CLASS_CSI_RX_H hrt_data csi_rx_be_ctrl_reg_load(
+extern hrt_data csi_rx_be_ctrl_reg_load(
 	const csi_rx_backend_ID_t ID,
 	const hrt_address reg);
 /**
@@ -126,7 +126,7 @@ STORAGE_CLASS_CSI_RX_H hrt_data csi_rx_be_ctrl_reg_load(
  * @param[in]	value	The value to be stored.
  *
  */
-STORAGE_CLASS_CSI_RX_H void csi_rx_be_ctrl_reg_store(
+extern void csi_rx_be_ctrl_reg_store(
 	const csi_rx_backend_ID_t ID,
 	const hrt_address reg,
 	const hrt_data value);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/gdc_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/gdc_public.h
index d27f87a719db..d09d1e320306 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/gdc_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/gdc_public.h
@@ -33,7 +33,7 @@
 
  \return none, GDC[ID].lut[0...3][0...HRT_GDC_N-1] = data
  */
-STORAGE_CLASS_EXTERN void gdc_lut_store(
+extern void gdc_lut_store(
 	const gdc_ID_t		ID,
 	const int			data[4][HRT_GDC_N]);
 
@@ -43,7 +43,7 @@ STORAGE_CLASS_EXTERN void gdc_lut_store(
  \param in_lut[in]			The data matrix to be converted
  \param out_lut[out]			The data matrix as the output of conversion
  */
-STORAGE_CLASS_EXTERN void gdc_lut_convert_to_isp_format(
+extern void gdc_lut_convert_to_isp_format(
 	const int in_lut[4][HRT_GDC_N],
 	int out_lut[4][HRT_GDC_N]);
 
@@ -53,7 +53,7 @@ STORAGE_CLASS_EXTERN void gdc_lut_convert_to_isp_format(
 
  \return unity
  */
-STORAGE_CLASS_EXTERN int gdc_get_unity(
+extern int gdc_get_unity(
 	const gdc_ID_t		ID);
 
 #endif /* __GDC_PUBLIC_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op1w.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op1w.h
index 2251f372145b..a025ad562bd2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op1w.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op1w.h
@@ -27,14 +27,13 @@
  * Prerequisites:
  *
  */
-#include "storage_class.h"
 
 #ifdef INLINE_ISP_OP1W
-#define STORAGE_CLASS_ISP_OP1W_FUNC_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_ISP_OP1W_DATA_H STORAGE_CLASS_INLINE_DATA
+#define STORAGE_CLASS_ISP_OP1W_FUNC_H static inline
+#define STORAGE_CLASS_ISP_OP1W_DATA_H static inline_DATA
 #else /* INLINE_ISP_OP1W */
-#define STORAGE_CLASS_ISP_OP1W_FUNC_H STORAGE_CLASS_EXTERN
-#define STORAGE_CLASS_ISP_OP1W_DATA_H STORAGE_CLASS_EXTERN_DATA
+#define STORAGE_CLASS_ISP_OP1W_FUNC_H extern
+#define STORAGE_CLASS_ISP_OP1W_DATA_H extern_DATA
 #endif  /* INLINE_ISP_OP1W */
 
 /*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op2w.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op2w.h
index 1cfe6d717283..cf7e7314842d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op2w.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op2w.h
@@ -27,14 +27,13 @@
  * Prerequisites:
  *
  */
-#include "storage_class.h"
 
 #ifdef INLINE_ISP_OP2W
-#define STORAGE_CLASS_ISP_OP2W_FUNC_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_ISP_OP2W_DATA_H STORAGE_CLASS_INLINE_DATA
+#define STORAGE_CLASS_ISP_OP2W_FUNC_H static inline
+#define STORAGE_CLASS_ISP_OP2W_DATA_H static inline_DATA
 #else /* INLINE_ISP_OP2W */
-#define STORAGE_CLASS_ISP_OP2W_FUNC_H STORAGE_CLASS_EXTERN
-#define STORAGE_CLASS_ISP_OP2W_DATA_H STORAGE_CLASS_EXTERN_DATA
+#define STORAGE_CLASS_ISP_OP2W_FUNC_H extern
+#define STORAGE_CLASS_ISP_OP2W_DATA_H extern_DATA
 #endif  /* INLINE_ISP_OP2W */
 
 /*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/mmu_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/mmu_public.h
index 4258fa872087..0a13eda73607 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/mmu_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/mmu_public.h
@@ -24,7 +24,7 @@
 
  \return none, MMU[ID].page_table_base_index = base_index
  */
-STORAGE_CLASS_EXTERN void mmu_set_page_table_base_index(
+extern void mmu_set_page_table_base_index(
 	const mmu_ID_t		ID,
 	const hrt_data		base_index);
 
@@ -35,7 +35,7 @@ STORAGE_CLASS_EXTERN void mmu_set_page_table_base_index(
 
  \return MMU[ID].page_table_base_index
  */
-STORAGE_CLASS_EXTERN hrt_data mmu_get_page_table_base_index(
+extern hrt_data mmu_get_page_table_base_index(
 	const mmu_ID_t		ID);
 
 /*! Invalidate the page table cache of MMU[ID]
@@ -44,7 +44,7 @@ STORAGE_CLASS_EXTERN hrt_data mmu_get_page_table_base_index(
 
  \return none
  */
-STORAGE_CLASS_EXTERN void mmu_invalidate_cache(
+extern void mmu_invalidate_cache(
 	const mmu_ID_t		ID);
 
 
@@ -52,7 +52,7 @@ STORAGE_CLASS_EXTERN void mmu_invalidate_cache(
 
  \return none
  */
-STORAGE_CLASS_EXTERN void mmu_invalidate_cache_all(void);
+extern void mmu_invalidate_cache_all(void);
 
 /*! Write to a control register of MMU[ID]
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/ref_vector_func.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/ref_vector_func.h
index 3e955fca2a94..a202d6dce106 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/ref_vector_func.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/ref_vector_func.h
@@ -15,14 +15,13 @@
 #ifndef _REF_VECTOR_FUNC_H_INCLUDED_
 #define _REF_VECTOR_FUNC_H_INCLUDED_
 
-#include "storage_class.h"
 
 #ifdef INLINE_VECTOR_FUNC
-#define STORAGE_CLASS_REF_VECTOR_FUNC_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_REF_VECTOR_DATA_H STORAGE_CLASS_INLINE_DATA
+#define STORAGE_CLASS_REF_VECTOR_FUNC_H static inline
+#define STORAGE_CLASS_REF_VECTOR_DATA_H static inline_DATA
 #else /* INLINE_VECTOR_FUNC */
-#define STORAGE_CLASS_REF_VECTOR_FUNC_H STORAGE_CLASS_EXTERN
-#define STORAGE_CLASS_REF_VECTOR_DATA_H STORAGE_CLASS_EXTERN_DATA
+#define STORAGE_CLASS_REF_VECTOR_FUNC_H extern
+#define STORAGE_CLASS_REF_VECTOR_DATA_H extern_DATA
 #endif  /* INLINE_VECTOR_FUNC */
 
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/ibuf_ctrl.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/ibuf_ctrl.h
index f5de0df7981e..c7d9095472b1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/ibuf_ctrl.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/ibuf_ctrl.h
@@ -31,18 +31,17 @@
  * - local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "ibuf_ctrl_local.h"
 
 #ifndef __INLINE_IBUF_CTRL__
-#define STORAGE_CLASS_IBUF_CTRL_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_IBUF_CTRL_H extern
 #define STORAGE_CLASS_IBUF_CTRL_C
 #include "ibuf_ctrl_public.h"
 #else  /* __INLINE_IBUF_CTRL__ */
-#define STORAGE_CLASS_IBUF_CTRL_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_IBUF_CTRL_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_IBUF_CTRL_H static inline
+#define STORAGE_CLASS_IBUF_CTRL_C static inline
 #include "ibuf_ctrl_private.h"
 #endif /* __INLINE_IBUF_CTRL__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/input_formatter.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/input_formatter.h
index 041c8b660aa4..eeaaecdd57ba 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/input_formatter.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/input_formatter.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "input_formatter_local.h"
 
 #ifndef __INLINE_INPUT_FORMATTER__
-#define STORAGE_CLASS_INPUT_FORMATTER_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_INPUT_FORMATTER_H extern
 #define STORAGE_CLASS_INPUT_FORMATTER_C 
 #include "input_formatter_public.h"
 #else  /* __INLINE_INPUT_FORMATTER__ */
-#define STORAGE_CLASS_INPUT_FORMATTER_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_INPUT_FORMATTER_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_INPUT_FORMATTER_H static inline
+#define STORAGE_CLASS_INPUT_FORMATTER_C static inline
 #include "input_formatter_private.h"
 #endif /* __INLINE_INPUT_FORMATTER__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/input_system.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/input_system.h
index 182867367b48..3f02d9ec9588 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/input_system.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/input_system.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "input_system_local.h"
 
 #ifndef __INLINE_INPUT_SYSTEM__
-#define STORAGE_CLASS_INPUT_SYSTEM_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_INPUT_SYSTEM_H extern
 #define STORAGE_CLASS_INPUT_SYSTEM_C 
 #include "input_system_public.h"
 #else  /* __INLINE_INPUT_SYSTEM__ */
-#define STORAGE_CLASS_INPUT_SYSTEM_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_INPUT_SYSTEM_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_INPUT_SYSTEM_H static inline
+#define STORAGE_CLASS_INPUT_SYSTEM_C static inline
 #include "input_system_private.h"
 #endif /* __INLINE_INPUT_SYSTEM__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/irq.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/irq.h
index 1dc443892cc5..e1446388dee5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/irq.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/irq.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "irq_local.h"
 
 #ifndef __INLINE_IRQ__
-#define STORAGE_CLASS_IRQ_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_IRQ_H extern
 #define STORAGE_CLASS_IRQ_C 
 #include "irq_public.h"
 #else  /* __INLINE_IRQ__ */
-#define STORAGE_CLASS_IRQ_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_IRQ_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_IRQ_H static inline
+#define STORAGE_CLASS_IRQ_C static inline
 #include "irq_private.h"
 #endif /* __INLINE_IRQ__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isp.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isp.h
index 49190d0abc30..b916953e7f47 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isp.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isp.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "isp_local.h"
 
 #ifndef __INLINE_ISP__
-#define STORAGE_CLASS_ISP_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_ISP_H extern
 #define STORAGE_CLASS_ISP_C 
 #include "isp_public.h"
 #else  /* __INLINE_iSP__ */
-#define STORAGE_CLASS_ISP_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_ISP_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_ISP_H static inline
+#define STORAGE_CLASS_ISP_C static inline
 #include "isp_private.h"
 #endif /* __INLINE_ISP__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_dma.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_dma.h
index 9a608f07adcb..76aba114a5c1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_dma.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_dma.h
@@ -31,18 +31,17 @@
  * - local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "isys_dma_local.h"
 
 #ifndef __INLINE_ISYS2401_DMA__
-#define STORAGE_CLASS_ISYS2401_DMA_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_ISYS2401_DMA_H extern
 #define STORAGE_CLASS_ISYS2401_DMA_C
 #include "isys_dma_public.h"
 #else  /* __INLINE_ISYS2401_DMA__ */
-#define STORAGE_CLASS_ISYS2401_DMA_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_ISYS2401_DMA_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_ISYS2401_DMA_H static inline
+#define STORAGE_CLASS_ISYS2401_DMA_C static inline
 #include "isys_dma_private.h"
 #endif /* __INLINE_ISYS2401_DMA__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_irq.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_irq.h
index cf858bcc8e45..d3f64cfd0b7d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_irq.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_irq.h
@@ -16,21 +16,20 @@
 #define __IA_CSS_ISYS_IRQ_H__
 
 #include <type_support.h>
-#include <storage_class.h>
 #include <system_local.h>
 
 #if defined(USE_INPUT_SYSTEM_VERSION_2401)
 
 #ifndef __INLINE_ISYS2401_IRQ__
 
-#define STORAGE_CLASS_ISYS2401_IRQ_H STORAGE_CLASS_EXTERN
-#define STORAGE_CLASS_ISYS2401_IRQ_C STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_ISYS2401_IRQ_H extern
+#define STORAGE_CLASS_ISYS2401_IRQ_C extern
 #include "isys_irq_public.h"
 
 #else  /* __INLINE_ISYS2401_IRQ__ */
 
-#define STORAGE_CLASS_ISYS2401_IRQ_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_ISYS2401_IRQ_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_ISYS2401_IRQ_H static inline
+#define STORAGE_CLASS_ISYS2401_IRQ_C static inline
 #include "isys_irq_private.h"
 
 #endif /* __INLINE_ISYS2401_IRQ__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_stream2mmio.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_stream2mmio.h
index 3e8cfe555ad5..16fbf9d25eba 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_stream2mmio.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/isys_stream2mmio.h
@@ -31,18 +31,17 @@
  * - local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "isys_stream2mmio_local.h"
 
 #ifndef __INLINE_STREAM2MMIO__
-#define STORAGE_CLASS_STREAM2MMIO_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_STREAM2MMIO_H extern
 #define STORAGE_CLASS_STREAM2MMIO_C
 #include "isys_stream2mmio_public.h"
 #else  /* __INLINE_STREAM2MMIO__ */
-#define STORAGE_CLASS_STREAM2MMIO_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_STREAM2MMIO_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_STREAM2MMIO_H static inline
+#define STORAGE_CLASS_STREAM2MMIO_C static inline
 #include "isys_stream2mmio_private.h"
 #endif /* __INLINE_STREAM2MMIO__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h
index f74b405b0f39..e85e5c889c15 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h
@@ -15,7 +15,6 @@
 #ifndef __MATH_SUPPORT_H
 #define __MATH_SUPPORT_H
 
-#include "storage_class.h" /* for STORAGE_CLASS_INLINE */
 #if defined(__KERNEL__)
 #include <linux/kernel.h> /* Override the definition of max/min from linux kernel*/
 #endif /*__KERNEL__*/
@@ -110,60 +109,60 @@ Leaving out the other math utility functions as they are newly added
 
 #else /* !defined(INLINE_MATH_SUPPORT_UTILS) */
 
-STORAGE_CLASS_INLINE int max(int a, int b)
+static inline int max(int a, int b)
 {
 	return MAX(a, b);
 }
 
-STORAGE_CLASS_INLINE int min(int a, int b)
+static inline int min(int a, int b)
 {
 	return MIN(a, b);
 }
 
-STORAGE_CLASS_INLINE unsigned int ceil_div(unsigned int a, unsigned int b)
+static inline unsigned int ceil_div(unsigned int a, unsigned int b)
 {
 	return CEIL_DIV(a, b);
 }
 #endif /* !defined(INLINE_MATH_SUPPORT_UTILS) */
 
-STORAGE_CLASS_INLINE unsigned int umax(unsigned int a, unsigned int b)
+static inline unsigned int umax(unsigned int a, unsigned int b)
 {
 	return MAX(a, b);
 }
 
-STORAGE_CLASS_INLINE unsigned int umin(unsigned int a, unsigned int b)
+static inline unsigned int umin(unsigned int a, unsigned int b)
 {
 	return MIN(a, b);
 }
 
 
-STORAGE_CLASS_INLINE unsigned int ceil_mul(unsigned int a, unsigned int b)
+static inline unsigned int ceil_mul(unsigned int a, unsigned int b)
 {
 	return CEIL_MUL(a, b);
 }
 
-STORAGE_CLASS_INLINE unsigned int ceil_mul2(unsigned int a, unsigned int b)
+static inline unsigned int ceil_mul2(unsigned int a, unsigned int b)
 {
 	return CEIL_MUL2(a, b);
 }
 
-STORAGE_CLASS_INLINE unsigned int ceil_shift(unsigned int a, unsigned int b)
+static inline unsigned int ceil_shift(unsigned int a, unsigned int b)
 {
 	return CEIL_SHIFT(a, b);
 }
 
-STORAGE_CLASS_INLINE unsigned int ceil_shift_mul(unsigned int a, unsigned int b)
+static inline unsigned int ceil_shift_mul(unsigned int a, unsigned int b)
 {
 	return CEIL_SHIFT_MUL(a, b);
 }
 
 #ifdef ISP2401
-STORAGE_CLASS_INLINE unsigned int round_half_down_div(unsigned int a, unsigned int b)
+static inline unsigned int round_half_down_div(unsigned int a, unsigned int b)
 {
 	return ROUND_HALF_DOWN_DIV(a, b);
 }
 
-STORAGE_CLASS_INLINE unsigned int round_half_down_mul(unsigned int a, unsigned int b)
+static inline unsigned int round_half_down_mul(unsigned int a, unsigned int b)
 {
 	return ROUND_HALF_DOWN_MUL(a, b);
 }
@@ -187,7 +186,7 @@ STORAGE_CLASS_INLINE unsigned int round_half_down_mul(unsigned int a, unsigned i
  *
  */
 
-STORAGE_CLASS_INLINE unsigned int ceil_pow2(unsigned int a)
+static inline unsigned int ceil_pow2(unsigned int a)
 {
 	if (a == 0) {
 		return 1;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mmu_device.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mmu_device.h
index 1b2017b029f2..519e850ec390 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mmu_device.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mmu_device.h
@@ -31,18 +31,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "mmu_local.h"
 
 #ifndef __INLINE_MMU__
-#define STORAGE_CLASS_MMU_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_MMU_H extern
 #define STORAGE_CLASS_MMU_C 
 #include "mmu_public.h"
 #else  /* __INLINE_MMU__ */
-#define STORAGE_CLASS_MMU_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_MMU_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_MMU_H static inline
+#define STORAGE_CLASS_MMU_C static inline
 #include "mmu_private.h"
 #endif /* __INLINE_MMU__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mpmath.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mpmath.h
index 565983aafa4d..cd938375e02e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mpmath.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mpmath.h
@@ -15,14 +15,13 @@
 #ifndef __MPMATH_H_INCLUDED__
 #define __MPMATH_H_INCLUDED__
 
-#include "storage_class.h"
 
 #ifdef INLINE_MPMATH
-#define STORAGE_CLASS_MPMATH_FUNC_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_MPMATH_DATA_H STORAGE_CLASS_INLINE_DATA
+#define STORAGE_CLASS_MPMATH_FUNC_H static inline
+#define STORAGE_CLASS_MPMATH_DATA_H static inline_DATA
 #else /* INLINE_MPMATH */
-#define STORAGE_CLASS_MPMATH_FUNC_H STORAGE_CLASS_EXTERN
-#define STORAGE_CLASS_MPMATH_DATA_H STORAGE_CLASS_EXTERN_DATA
+#define STORAGE_CLASS_MPMATH_FUNC_H extern
+#define STORAGE_CLASS_MPMATH_DATA_H extern_DATA
 #endif  /* INLINE_MPMATH */
 
 #include <type_support.h>
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/osys.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/osys.h
index 6e48ea9afc29..a607242c5f1a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/osys.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/osys.h
@@ -30,18 +30,17 @@
  *
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "osys_local.h"
 
 #ifndef __INLINE_OSYS__
-#define STORAGE_CLASS_OSYS_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_OSYS_H extern
 #define STORAGE_CLASS_OSYS_C
 #include "osys_public.h"
 #else  /* __INLINE_OSYS__ */
-#define STORAGE_CLASS_OSYS_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_OSYS_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_OSYS_H static inline
+#define STORAGE_CLASS_OSYS_C static inline
 #include "osys_private.h"
 #endif /* __INLINE_OSYS__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/pixelgen.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/pixelgen.h
index 67f7f3a14231..418d02382d76 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/pixelgen.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/pixelgen.h
@@ -31,18 +31,17 @@
  * - local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "pixelgen_local.h"
 
 #ifndef __INLINE_PIXELGEN__
-#define STORAGE_CLASS_PIXELGEN_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_PIXELGEN_H extern
 #define STORAGE_CLASS_PIXELGEN_C
 #include "pixelgen_public.h"
 #else  /* __INLINE_PIXELGEN__ */
-#define STORAGE_CLASS_PIXELGEN_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_PIXELGEN_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_PIXELGEN_H static inline
+#define STORAGE_CLASS_PIXELGEN_C static inline
 #include "pixelgen_private.h"
 #endif /* __INLINE_PIXELGEN__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/platform_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/platform_support.h
index 02f9eee67ff3..39a125ba563d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/platform_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/platform_support.h
@@ -20,7 +20,6 @@
 * Platform specific includes and functionality.
 */
 
-#include "storage_class.h"
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/print_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/print_support.h
index cfbc222ea0c1..ca0fbbb57788 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/print_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/print_support.h
@@ -15,7 +15,6 @@
 #ifndef __PRINT_SUPPORT_H_INCLUDED__
 #define __PRINT_SUPPORT_H_INCLUDED__
 
-#include "storage_class.h"
 
 #include <stdarg.h>
 #if !defined(__KERNEL__)
@@ -24,7 +23,7 @@
 
 extern int (*sh_css_printf) (const char *fmt, va_list args);
 /* depends on host supplied print function in ia_css_init() */
-STORAGE_CLASS_INLINE void ia_css_print(const char *fmt, ...)
+static inline void ia_css_print(const char *fmt, ...)
 {
 	va_list ap;
 	if (sh_css_printf) {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/queue.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/queue.h
index a3d874b9516a..aa5fadf5aadb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/queue.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/queue.h
@@ -29,18 +29,17 @@
  *
  */
 
-#include <storage_class.h>
 
 #include "queue_local.h"
 
 #ifndef __INLINE_QUEUE__
-#define STORAGE_CLASS_QUEUE_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_QUEUE_H extern
 #define STORAGE_CLASS_QUEUE_C 
 /* #include "queue_public.h" */
 #include "ia_css_queue.h"
 #else  /* __INLINE_QUEUE__ */
-#define STORAGE_CLASS_QUEUE_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_QUEUE_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_QUEUE_H static inline
+#define STORAGE_CLASS_QUEUE_C static inline
 #include "queue_private.h"
 #endif /* __INLINE_QUEUE__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/resource.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/resource.h
index 82c55acd0380..bd9f53e6b680 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/resource.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/resource.h
@@ -30,18 +30,17 @@
  *
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "resource_local.h"
 
 #ifndef __INLINE_RESOURCE__
-#define STORAGE_CLASS_RESOURCE_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_RESOURCE_H extern
 #define STORAGE_CLASS_RESOURCE_C 
 #include "resource_public.h"
 #else  /* __INLINE_RESOURCE__ */
-#define STORAGE_CLASS_RESOURCE_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_RESOURCE_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_RESOURCE_H static inline
+#define STORAGE_CLASS_RESOURCE_C static inline
 #include "resource_private.h"
 #endif /* __INLINE_RESOURCE__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/socket.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/socket.h
index c34c2e75c51f..43cfb0cb4aa8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/socket.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/socket.h
@@ -30,18 +30,17 @@
  *
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "socket_local.h"
 
 #ifndef __INLINE_SOCKET__
-#define STORAGE_CLASS_SOCKET_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_SOCKET_H extern
 #define STORAGE_CLASS_SOCKET_C
 #include "socket_public.h"
 #else  /* __INLINE_SOCKET__ */
-#define STORAGE_CLASS_SOCKET_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_SOCKET_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_SOCKET_H static inline
+#define STORAGE_CLASS_SOCKET_C static inline
 #include "socket_private.h"
 #endif /* __INLINE_SOCKET__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/sp.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/sp.h
index 150fc2f6129b..8f57f2060791 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/sp.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/sp.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "sp_local.h"
 
 #ifndef __INLINE_SP__
-#define STORAGE_CLASS_SP_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_SP_H extern
 #define STORAGE_CLASS_SP_C 
 #include "sp_public.h"
 #else  /* __INLINE_SP__ */
-#define STORAGE_CLASS_SP_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_SP_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_SP_H static inline
+#define STORAGE_CLASS_SP_C static inline
 #include "sp_private.h"
 #endif /* __INLINE_SP__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/storage_class.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/storage_class.h
deleted file mode 100644
index 3908e668dacd..000000000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/storage_class.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef __STORAGE_CLASS_H_INCLUDED__
-#define __STORAGE_CLASS_H_INCLUDED__
-
-/**
-* @file
-* Platform specific includes and functionality.
-*/
-
-#define STORAGE_CLASS_EXTERN extern
-
-#if defined(_MSC_VER)
-#define STORAGE_CLASS_INLINE static __inline
-#else
-#define STORAGE_CLASS_INLINE static inline
-#endif
-
-#define STORAGE_CLASS_EXTERN_DATA extern const
-#define STORAGE_CLASS_INLINE_DATA static const
-
-#endif /* __STORAGE_CLASS_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/stream_buffer.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/stream_buffer.h
index 8e41f60b5d39..53d535e4f2ae 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/stream_buffer.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/stream_buffer.h
@@ -30,18 +30,17 @@
  *
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "stream_buffer_local.h"
 
 #ifndef __INLINE_STREAM_BUFFER__
-#define STORAGE_CLASS_STREAM_BUFFER_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_STREAM_BUFFER_H extern
 #define STORAGE_CLASS_STREAM_BUFFER_C
 #include "stream_buffer_public.h"
 #else  /* __INLINE_STREAM_BUFFER__ */
-#define STORAGE_CLASS_STREAM_BUFFER_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_STREAM_BUFFER_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_STREAM_BUFFER_H static inline
+#define STORAGE_CLASS_STREAM_BUFFER_C static inline
 #include "stream_buffer_private.h"
 #endif /* __INLINE_STREAM_BUFFER__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h
index c53241a7a281..d80437c58bde 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h
@@ -16,7 +16,6 @@
 #define __STRING_SUPPORT_H_INCLUDED__
 #include <platform_support.h>
 #include <type_support.h>
-#include <storage_class.h>
 
 #if !defined(_MSC_VER)
 /*
@@ -34,7 +33,7 @@
  * @return     EINVAL on Invalid arguments
  * @return     ERANGE on Destination size too small
  */
-STORAGE_CLASS_INLINE int memcpy_s(
+static inline int memcpy_s(
 	void* dest_buf,
 	size_t dest_size,
 	const void* src_buf,
@@ -89,7 +88,7 @@ static size_t strnlen_s(
  * @return     Returns EINVAL on invalid arguments
  * @return     Returns ERANGE on destination size too small
  */
-STORAGE_CLASS_INLINE int strncpy_s(
+static inline int strncpy_s(
 	char* dest_str,
 	size_t dest_size,
 	const char* src_str,
@@ -130,7 +129,7 @@ STORAGE_CLASS_INLINE int strncpy_s(
  * @return     Returns EINVAL on invalid arguments
  * @return     Returns ERANGE on destination size too small
  */
-STORAGE_CLASS_INLINE int strcpy_s(
+static inline int strcpy_s(
 	char* dest_str,
 	size_t dest_size,
 	const char* src_str)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/tag.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/tag.h
index 7385fd11c95f..ace695643369 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/tag.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/tag.h
@@ -29,17 +29,16 @@
  *
  */
 
-#include "storage_class.h"
 
 #include "tag_local.h"
 
 #ifndef __INLINE_TAG__
-#define STORAGE_CLASS_TAG_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_TAG_H extern
 #define STORAGE_CLASS_TAG_C 
 #include "tag_public.h"
 #else  /* __INLINE_TAG__ */
-#define STORAGE_CLASS_TAG_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_TAG_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_TAG_H static inline
+#define STORAGE_CLASS_TAG_C static inline
 #include "tag_private.h"
 #endif /* __INLINE_TAG__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/timed_ctrl.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/timed_ctrl.h
index ed13451c9261..f6bc1c47553f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/timed_ctrl.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/timed_ctrl.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "timed_ctrl_local.h"
 
 #ifndef __INLINE_TIMED_CTRL__
-#define STORAGE_CLASS_TIMED_CTRL_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_TIMED_CTRL_H extern
 #define STORAGE_CLASS_TIMED_CTRL_C 
 #include "timed_ctrl_public.h"
 #else  /* __INLINE_TIMED_CTRL__ */
-#define STORAGE_CLASS_TIMED_CTRL_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_TIMED_CTRL_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_TIMED_CTRL_H static inline
+#define STORAGE_CLASS_TIMED_CTRL_C static inline
 #include "timed_ctrl_private.h"
 #endif /* __INLINE_TIMED_CTRL__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vamem.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vamem.h
index acf932e1f563..82d447bf9704 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vamem.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vamem.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "vamem_local.h"
 
 #ifndef __INLINE_VAMEM__
-#define STORAGE_CLASS_VAMEM_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_VAMEM_H extern
 #define STORAGE_CLASS_VAMEM_C 
 #include "vamem_public.h"
 #else  /* __INLINE_VAMEM__ */
-#define STORAGE_CLASS_VAMEM_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_VAMEM_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_VAMEM_H static inline
+#define STORAGE_CLASS_VAMEM_C static inline
 #include "vamem_private.h"
 #endif /* __INLINE_VAMEM__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_func.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_func.h
index 5d3be31759e4..5368b9062897 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_func.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_func.h
@@ -15,7 +15,6 @@
 #ifndef __VECTOR_FUNC_H_INCLUDED__
 #define __VECTOR_FUNC_H_INCLUDED__
 
-#include "storage_class.h"
 
 /* TODO: Later filters will be moved to types directory,
  * and we should only include matrix_MxN types */
@@ -27,12 +26,12 @@
 #include "vector_func_local.h"
 
 #ifndef __INLINE_VECTOR_FUNC__
-#define STORAGE_CLASS_VECTOR_FUNC_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_VECTOR_FUNC_H extern
 #define STORAGE_CLASS_VECTOR_FUNC_C 
 #include "vector_func_public.h"
 #else  /* __INLINE_VECTOR_FUNC__ */
-#define STORAGE_CLASS_VECTOR_FUNC_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_VECTOR_FUNC_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_VECTOR_FUNC_H static inline
+#define STORAGE_CLASS_VECTOR_FUNC_C static inline
 #include "vector_func_private.h"
 #endif /* __INLINE_VECTOR_FUNC__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_ops.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_ops.h
index 261f87378ce5..4923f2d5518b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_ops.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_ops.h
@@ -15,17 +15,16 @@
 #ifndef __VECTOR_OPS_H_INCLUDED__
 #define __VECTOR_OPS_H_INCLUDED__
 
-#include "storage_class.h"
 
 #include "vector_ops_local.h"
 
 #ifndef __INLINE_VECTOR_OPS__
-#define STORAGE_CLASS_VECTOR_OPS_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_VECTOR_OPS_H extern
 #define STORAGE_CLASS_VECTOR_OPS_C
 #include "vector_ops_public.h"
 #else  /* __INLINE_VECTOR_OPS__ */
-#define STORAGE_CLASS_VECTOR_OPS_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_VECTOR_OPS_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_VECTOR_OPS_H static inline
+#define STORAGE_CLASS_VECTOR_OPS_C static inline
 #include "vector_ops_private.h"
 #endif /* __INLINE_VECTOR_OPS__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vmem.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vmem.h
index 79a36755bfd9..d3375729c441 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vmem.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vmem.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "vmem_local.h"
 
 #ifndef __INLINE_VMEM__
-#define STORAGE_CLASS_VMEM_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_VMEM_H extern
 #define STORAGE_CLASS_VMEM_C 
 #include "vmem_public.h"
 #else  /* __INLINE_VMEM__ */
-#define STORAGE_CLASS_VMEM_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_VMEM_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_VMEM_H static inline
+#define STORAGE_CLASS_VMEM_C static inline
 #include "vmem_private.h"
 #endif /* __INLINE_VMEM__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/xmem.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/xmem.h
index 9169e04f9b4b..13083fe55141 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/xmem.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/xmem.h
@@ -29,18 +29,17 @@
  *	- local:   system and cell specific constants and identifiers
  */
 
-#include "storage_class.h"
 
 #include "system_local.h"
 #include "xmem_local.h"
 
 #ifndef __INLINE_XMEM__
-#define STORAGE_CLASS_XMEM_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_XMEM_H extern
 #define STORAGE_CLASS_XMEM_C 
 #include "xmem_public.h"
 #else  /* __INLINE_XMEM__ */
-#define STORAGE_CLASS_XMEM_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_XMEM_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_XMEM_H static inline
+#define STORAGE_CLASS_XMEM_C static inline
 #include "xmem_private.h"
 #endif /* __INLINE_XMEM__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c
index 8ef6c54ee813..aa733674f42b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c
@@ -321,7 +321,7 @@ ia_css_s3a_dmem_decode(
 }
 
 /* MW: this is an ISP function */
-STORAGE_CLASS_INLINE int
+static inline int
 merge_hi_lo_14(unsigned short hi, unsigned short lo)
 {
 	int val = (int) ((((unsigned int) hi << 14) & 0xfffc000) |
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
index 5d40afd482f5..42d9a8508858 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
@@ -280,7 +280,7 @@ static ia_css_queue_t *bufq_get_qhandle(
 /* Local function to initialize a buffer queue. This reduces
  * the chances of copy-paste errors or typos.
  */
-STORAGE_CLASS_INLINE void
+static inline void
 init_bufq(unsigned int desc_offset,
 	  unsigned int elems_offset,
 	  ia_css_queue_t *handle)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/interface/ia_css_debug.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/interface/ia_css_debug.h
index 91c105cc6204..3c8dcfd4bbc6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/interface/ia_css_debug.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/interface/ia_css_debug.h
@@ -130,7 +130,7 @@ enum ia_css_debug_enable_param_dump {
  * @param[in]	fmt		printf like format string
  * @param[in]	args		arguments for the format string
  */
-STORAGE_CLASS_INLINE void
+static inline void
 ia_css_debug_vdtrace(unsigned int level, const char *fmt, va_list args)
 {
 	if (ia_css_debug_trace_level >= level)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/src/inputfifo.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/src/inputfifo.c
index cf02970d4f59..d9a5f3e9283a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/src/inputfifo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/src/inputfifo.c
@@ -105,7 +105,7 @@ static struct inputfifo_instance
 
 /* Streaming to MIPI */
 static unsigned inputfifo_wrap_marker(
-/* STORAGE_CLASS_INLINE unsigned inputfifo_wrap_marker( */
+/* static inline unsigned inputfifo_wrap_marker( */
 	unsigned marker)
 {
 	return marker |
@@ -113,7 +113,7 @@ static unsigned inputfifo_wrap_marker(
 	(inputfifo_curr_fmt_type << _HIVE_STR_TO_MIPI_FMT_TYPE_LSB);
 }
 
-STORAGE_CLASS_INLINE void
+static inline void
 _sh_css_fifo_snd(unsigned token)
 {
 	while (!can_event_send_token(STR2MIPI_EVENT_ID))
@@ -123,7 +123,7 @@ _sh_css_fifo_snd(unsigned token)
 }
 
 static void inputfifo_send_data_a(
-/* STORAGE_CLASS_INLINE void inputfifo_send_data_a( */
+/* static inline void inputfifo_send_data_a( */
 unsigned int data)
 {
 	unsigned int token = (1 << HIVE_STR_TO_MIPI_VALID_A_BIT) |
@@ -135,7 +135,7 @@ unsigned int data)
 
 
 static void inputfifo_send_data_b(
-/* STORAGE_CLASS_INLINE void inputfifo_send_data_b( */
+/* static inline void inputfifo_send_data_b( */
 	unsigned int data)
 {
 	unsigned int token = (1 << HIVE_STR_TO_MIPI_VALID_B_BIT) |
@@ -147,7 +147,7 @@ static void inputfifo_send_data_b(
 
 
 static void inputfifo_send_data(
-/* STORAGE_CLASS_INLINE void inputfifo_send_data( */
+/* static inline void inputfifo_send_data( */
 	unsigned int a,
 	unsigned int b)
 {
@@ -162,7 +162,7 @@ static void inputfifo_send_data(
 
 
 static void inputfifo_send_sol(void)
-/* STORAGE_CLASS_INLINE void inputfifo_send_sol(void) */
+/* static inline void inputfifo_send_sol(void) */
 {
 	hrt_data	token = inputfifo_wrap_marker(
 		1 << HIVE_STR_TO_MIPI_SOL_BIT);
@@ -174,7 +174,7 @@ static void inputfifo_send_sol(void)
 
 
 static void inputfifo_send_eol(void)
-/* STORAGE_CLASS_INLINE void inputfifo_send_eol(void) */
+/* static inline void inputfifo_send_eol(void) */
 {
 	hrt_data	token = inputfifo_wrap_marker(
 		1 << HIVE_STR_TO_MIPI_EOL_BIT);
@@ -185,7 +185,7 @@ static void inputfifo_send_eol(void)
 
 
 static void inputfifo_send_sof(void)
-/* STORAGE_CLASS_INLINE void inputfifo_send_sof(void) */
+/* static inline void inputfifo_send_sof(void) */
 {
 	hrt_data	token = inputfifo_wrap_marker(
 		1 << HIVE_STR_TO_MIPI_SOF_BIT);
@@ -197,7 +197,7 @@ static void inputfifo_send_sof(void)
 
 
 static void inputfifo_send_eof(void)
-/* STORAGE_CLASS_INLINE void inputfifo_send_eof(void) */
+/* static inline void inputfifo_send_eof(void) */
 {
 	hrt_data	token = inputfifo_wrap_marker(
 		1 << HIVE_STR_TO_MIPI_EOF_BIT);
@@ -209,7 +209,7 @@ static void inputfifo_send_eof(void)
 
 #ifdef __ON__
 static void inputfifo_send_ch_id(
-/* STORAGE_CLASS_INLINE void inputfifo_send_ch_id( */
+/* static inline void inputfifo_send_ch_id( */
 	unsigned int ch_id)
 {
 	hrt_data	token;
@@ -223,7 +223,7 @@ static void inputfifo_send_ch_id(
 }
 
 static void inputfifo_send_fmt_type(
-/* STORAGE_CLASS_INLINE void inputfifo_send_fmt_type( */
+/* static inline void inputfifo_send_fmt_type( */
 	unsigned int fmt_type)
 {
 	hrt_data	token;
@@ -240,7 +240,7 @@ static void inputfifo_send_fmt_type(
 
 
 static void inputfifo_send_ch_id_and_fmt_type(
-/* STORAGE_CLASS_INLINE
+/* static inline
 void inputfifo_send_ch_id_and_fmt_type( */
 	unsigned int ch_id,
 	unsigned int fmt_type)
@@ -259,7 +259,7 @@ void inputfifo_send_ch_id_and_fmt_type( */
 
 
 static void inputfifo_send_empty_token(void)
-/* STORAGE_CLASS_INLINE void inputfifo_send_empty_token(void) */
+/* static inline void inputfifo_send_empty_token(void) */
 {
 	hrt_data	token = inputfifo_wrap_marker(0);
 	_sh_css_fifo_snd(token);
@@ -269,7 +269,7 @@ static void inputfifo_send_empty_token(void)
 
 
 static void inputfifo_start_frame(
-/* STORAGE_CLASS_INLINE void inputfifo_start_frame( */
+/* static inline void inputfifo_start_frame( */
 	unsigned int ch_id,
 	unsigned int fmt_type)
 {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/interface/ia_css_rmgr.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/interface/ia_css_rmgr.h
index a0bb9f663ce6..9f78e709b3d0 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/interface/ia_css_rmgr.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/interface/ia_css_rmgr.h
@@ -31,15 +31,14 @@ more details.
 #ifndef _IA_CSS_RMGR_H
 #define _IA_CSS_RMGR_H
 
-#include "storage_class.h"
 #include <ia_css_err.h>
 
 #ifndef __INLINE_RMGR__
-#define STORAGE_CLASS_RMGR_H STORAGE_CLASS_EXTERN
+#define STORAGE_CLASS_RMGR_H extern
 #define STORAGE_CLASS_RMGR_C
 #else				/* __INLINE_RMGR__ */
-#define STORAGE_CLASS_RMGR_H STORAGE_CLASS_INLINE
-#define STORAGE_CLASS_RMGR_C STORAGE_CLASS_INLINE
+#define STORAGE_CLASS_RMGR_H static inline
+#define STORAGE_CLASS_RMGR_C static inline
 #endif				/* __INLINE_RMGR__ */
 
 /**
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
index 5b2b78f96dc5..0910021286a4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h
@@ -961,7 +961,7 @@ struct host_sp_queues {
 
 extern int (*sh_css_printf)(const char *fmt, va_list args);
 
-STORAGE_CLASS_INLINE void
+static inline void
 sh_css_print(const char *fmt, ...)
 {
 	va_list ap;
@@ -973,7 +973,7 @@ sh_css_print(const char *fmt, ...)
 	}
 }
 
-STORAGE_CLASS_INLINE void
+static inline void
 sh_css_vprint(const char *fmt, va_list args)
 {
 	if (sh_css_printf)
-- 
2.13.6
