Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33551 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751684AbeCZVLA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Paolo Cretaro <melko@frugalware.org>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org
Subject: [PATCH 04/18] media: staging atomisp: declare static vars as such
Date: Mon, 26 Mar 2018 17:10:37 -0400
Message-Id: <b1fcd5bc29282b88ca8dd8c44347c45a4e6ccaf0.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a bunch of warnings:
	drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c:93:23: warning: symbol 'css_queues' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:27:32: warning: symbol 'handle_table' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:32:30: warning: symbol 'refpool' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:43:30: warning: symbol 'writepool' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:54:30: warning: symbol 'hmmbufferpool' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_formatter.c:48:12: warning: symbol 'HIVE_IF_BIN_COPY' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_timer.c:33:1: warning: symbol 'gp_timer_reg_load' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:74:33: warning: symbol 'sh_css_sp_output' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/debug.c:32:25: warning: symbol 'debug_data' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c:32:21: warning: symbol 'IB_BUFFER_NULL' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c:647:24: warning: symbol 'config' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:2894:10: warning: symbol 'g_param_buffer_dequeue_count' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:2895:10: warning: symbol 'g_param_buffer_enqueue_count' was not declared. Should it be static?

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/debug.c | 2 +-
 .../pci/atomisp2/css2400/hive_isp_css_common/host/gp_timer.c      | 2 +-
 .../pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c  | 4 ++--
 .../media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c    | 7 +++----
 .../atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c     | 8 ++++----
 .../staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c    | 6 +++---
 6 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/debug.c
index c412810887b3..dcb9a3127cfe 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/debug.c
@@ -29,7 +29,7 @@
 hrt_address	debug_buffer_address = (hrt_address)-1;
 hrt_vaddress	debug_buffer_ddr_address = (hrt_vaddress)-1;
 /* The local copy */
-debug_data_t		debug_data;
+static debug_data_t		debug_data;
 debug_data_t		*debug_data_ptr = &debug_data;
 
 void debug_buffer_init(const hrt_address addr)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_timer.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_timer.c
index bcfd443f5202..b6b1344786b1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_timer.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_timer.c
@@ -29,7 +29,7 @@ gp_timer_reg_load(uint32_t reg);
 static void
 gp_timer_reg_store(uint32_t reg, uint32_t value);
 
-uint32_t
+static uint32_t
 gp_timer_reg_load(uint32_t reg)
 {
 	return ia_css_device_load_uint32(
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
index bd6821e436b2..c9cb8e0621e5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
@@ -29,7 +29,7 @@
 #define ZERO (0x0)
 #define ONE  (1U)
 
-const ib_buffer_t   IB_BUFFER_NULL = {0 ,0, 0 };
+static const ib_buffer_t   IB_BUFFER_NULL = {0 ,0, 0 };
 
 static input_system_error_t input_system_configure_channel(
 	const channel_cfg_t		channel);
@@ -644,7 +644,7 @@ static inline void rx_channel_get_state(
 }
 
 // MW: "2400" in the name is not good, but this is to avoid a naming conflict
-input_system_cfg2400_t config;
+static input_system_cfg2400_t config;
 
 static void receiver_rst(
 	const rx_ID_t				ID)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
index 01d20b62a630..ffbcdd80d934 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
@@ -90,12 +90,11 @@ struct sh_css_queues {
 
 #endif
 
-struct sh_css_queues  css_queues;
-
-
 /*******************************************************
 *** Static variables
 ********************************************************/
+static struct sh_css_queues css_queues;
+
 static int buffer_type_to_queue_id_map[SH_CSS_MAX_SP_THREADS][IA_CSS_NUM_DYNAMIC_BUFFER_TYPE];
 static bool queue_availability[SH_CSS_MAX_SP_THREADS][SH_CSS_MAX_NUM_QUEUES];
 
@@ -266,7 +265,7 @@ static ia_css_queue_t *bufq_get_qhandle(
 	case sh_css_sp2host_isys_event_queue:
 		q = &css_queues.sp2host_isys_event_queue_handle;
 		break;
-#endif		
+#endif
 	case sh_css_host2sp_tag_cmd_queue:
 		q = &css_queues.host2sp_tag_cmd_queue_handle;
 		break;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
index 54239ac9d7c9..a4d8a48f95ba 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
@@ -24,12 +24,12 @@
  * @brief VBUF resource handles
  */
 #define NUM_HANDLES 1000
-struct ia_css_rmgr_vbuf_handle handle_table[NUM_HANDLES];
+static struct ia_css_rmgr_vbuf_handle handle_table[NUM_HANDLES];
 
 /*
  * @brief VBUF resource pool - refpool
  */
-struct ia_css_rmgr_vbuf_pool refpool = {
+static struct ia_css_rmgr_vbuf_pool refpool = {
 	false,			/* copy_on_write */
 	false,			/* recycle */
 	0,			/* size */
@@ -40,7 +40,7 @@ struct ia_css_rmgr_vbuf_pool refpool = {
 /*
  * @brief VBUF resource pool - writepool
  */
-struct ia_css_rmgr_vbuf_pool writepool = {
+static struct ia_css_rmgr_vbuf_pool writepool = {
 	true,			/* copy_on_write */
 	false,			/* recycle */
 	0,			/* size */
@@ -51,7 +51,7 @@ struct ia_css_rmgr_vbuf_pool writepool = {
 /*
  * @brief VBUF resource pool - hmmbufferpool
  */
-struct ia_css_rmgr_vbuf_pool hmmbufferpool = {
+static struct ia_css_rmgr_vbuf_pool hmmbufferpool = {
 	true,			/* copy_on_write */
 	true,			/* recycle */
 	32,			/* size */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index fbb36112fe3c..3c0e8f66f59a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -110,7 +110,7 @@
 #define FPNTBL_BYTES(binary) \
 	(sizeof(char) * (binary)->in_frame_info.res.height * \
 	 (binary)->in_frame_info.padded_width)
-	 
+
 #ifndef ISP2401
 
 #define SCTBL_BYTES(binary) \
@@ -2891,8 +2891,8 @@ ia_css_metadata_free_multiple(unsigned int num_bufs, struct ia_css_metadata **bu
 	}
 }
 
-unsigned g_param_buffer_dequeue_count = 0;
-unsigned g_param_buffer_enqueue_count = 0;
+static unsigned g_param_buffer_dequeue_count = 0;
+static unsigned g_param_buffer_enqueue_count = 0;
 
 enum ia_css_err
 ia_css_stream_isp_parameters_init(struct ia_css_stream *stream)
-- 
2.14.3
