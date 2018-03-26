Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58331 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752048AbeCZVLG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Georgiana Chelu <georgiana.chelu93@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        Jeremy Sowden <jeremy@azazel.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Aishwarya Pant <aishpant@gmail.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org
Subject: [PATCH 16/18] media: staging: atomisp: stop mixing enum types
Date: Mon, 26 Mar 2018 17:10:49 -0400
Message-Id: <7337590492ba8023c117de1e98a6b35bdfe6f78a.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver abuses on enum types:

    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:1027:37: warning: mixing different enum types
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:1027:37:     int enum ia_css_csi2_port  versus
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:1027:37:     int enum mipi_port_ID_t
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:1037:39: warning: mixing different enum types
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:1037:39:     int enum ia_css_csi2_port  versus
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:1037:39:     int enum mipi_port_ID_t
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:2147:62: warning: mixing different enum types
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:2147:62:     int enum mipi_port_ID_t  versus
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:2147:62:     int enum ia_css_csi2_port

Doing some "implicit" typecast. Fix it by using just one enum
everywhere, and stopping using typedef to refer to it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 10 +++---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.h       |  2 +-
 .../media/atomisp/pci/atomisp2/atomisp_compat.h    |  6 ++--
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |  6 ++--
 .../css2400/css_2401_csi2p_system/system_global.h  |  4 +--
 .../hive_isp_css_common/host/input_system.c        | 20 ++++++------
 .../hive_isp_css_common/host/input_system_local.h  |  2 +-
 .../host/input_system_private.h                    |  4 +--
 .../css2400/hive_isp_css_common/system_global.h    |  4 +--
 .../host/input_system_public.h                     | 14 ++++-----
 .../pci/atomisp2/css2400/ia_css_input_port.h       | 20 +++++-------
 .../atomisp/pci/atomisp2/css2400/ia_css_irq.h      |  4 +--
 .../atomisp/pci/atomisp2/css2400/ia_css_mipi.h     |  2 +-
 .../pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c |  4 +--
 .../css2400/runtime/isys/interface/ia_css_isys.h   | 16 +++++-----
 .../css2400/runtime/isys/src/csi_rx_rmgr.c         |  4 +--
 .../pci/atomisp2/css2400/runtime/isys/src/rx.c     | 36 +++++++++++-----------
 .../css2400/runtime/pipeline/src/pipeline.c        |  4 +--
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 30 +++++++++---------
 .../atomisp/pci/atomisp2/css2400/sh_css_mipi.c     |  2 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c |  2 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.h |  2 +-
 22 files changed, 96 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index b1efbd4d2828..fa6ea506f8b1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -437,7 +437,7 @@ static void atomisp_reset_event(struct atomisp_sub_device *asd)
 }
 
 
-static void print_csi_rx_errors(enum ia_css_csi2_port port,
+static void print_csi_rx_errors(enum mipi_port_id port,
 				struct atomisp_device *isp)
 {
 	u32 infos = 0;
@@ -481,7 +481,7 @@ static void clear_irq_reg(struct atomisp_device *isp)
 }
 
 static struct atomisp_sub_device *
-__get_asd_from_port(struct atomisp_device *isp, mipi_port_ID_t port)
+__get_asd_from_port(struct atomisp_device *isp, enum mipi_port_id port)
 {
 	int i;
 
@@ -570,9 +570,9 @@ irqreturn_t atomisp_isr(int irq, void *dev)
 	    (irq_infos & CSS_IRQ_INFO_IF_ERROR)) {
 		/* handle mipi receiver error */
 		u32 rx_infos;
-		enum ia_css_csi2_port port;
+		enum mipi_port_id port;
 
-		for (port = IA_CSS_CSI2_PORT0; port <= IA_CSS_CSI2_PORT2;
+		for (port = MIPI_PORT0_ID; port <= MIPI_PORT2_ID;
 		     port++) {
 			print_csi_rx_errors(port, isp);
 			atomisp_css_rx_get_irq_info(port, &rx_infos);
@@ -5028,7 +5028,7 @@ atomisp_try_fmt_file(struct atomisp_device *isp, struct v4l2_format *f)
 	return 0;
 }
 
-mipi_port_ID_t __get_mipi_port(struct atomisp_device *isp,
+enum mipi_port_id __get_mipi_port(struct atomisp_device *isp,
 				enum atomisp_camera_port port)
 {
 	switch (port) {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
index bdc73862fb79..79d493dba403 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
@@ -389,7 +389,7 @@ int atomisp_source_pad_to_stream_id(struct atomisp_sub_device *asd,
  */
 void atomisp_eof_event(struct atomisp_sub_device *asd, uint8_t exp_id);
 
-mipi_port_ID_t __get_mipi_port(struct atomisp_device *isp,
+enum mipi_port_id __get_mipi_port(struct atomisp_device *isp,
 				enum atomisp_camera_port port);
 
 bool atomisp_is_vf_pipe(struct atomisp_video_pipe *pipe);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
index 398ee02229f8..1567572e5b49 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
@@ -148,10 +148,10 @@ void atomisp_css_init_struct(struct atomisp_sub_device *asd);
 int atomisp_css_irq_translate(struct atomisp_device *isp,
 			      unsigned int *infos);
 
-void atomisp_css_rx_get_irq_info(enum ia_css_csi2_port port,
+void atomisp_css_rx_get_irq_info(enum mipi_port_id port,
 					unsigned int *infos);
 
-void atomisp_css_rx_clear_irq_info(enum ia_css_csi2_port port,
+void atomisp_css_rx_clear_irq_info(enum mipi_port_id port,
 					unsigned int infos);
 
 int atomisp_css_irq_enable(struct atomisp_device *isp,
@@ -332,7 +332,7 @@ void atomisp_css_enable_cvf(struct atomisp_sub_device *asd,
 							bool enable);
 
 int atomisp_css_input_configure_port(struct atomisp_sub_device *asd,
-				mipi_port_ID_t port,
+				enum mipi_port_id port,
 				unsigned int num_lanes,
 				unsigned int timeout,
 				unsigned int mipi_freq,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index 388b8a8a7009..d9c8c202fd81 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -1020,7 +1020,7 @@ int atomisp_css_irq_translate(struct atomisp_device *isp,
 	return 0;
 }
 
-void atomisp_css_rx_get_irq_info(enum ia_css_csi2_port port,
+void atomisp_css_rx_get_irq_info(enum mipi_port_id port,
 					unsigned int *infos)
 {
 #ifndef ISP2401_NEW_INPUT_SYSTEM
@@ -1030,7 +1030,7 @@ void atomisp_css_rx_get_irq_info(enum ia_css_csi2_port port,
 #endif
 }
 
-void atomisp_css_rx_clear_irq_info(enum ia_css_csi2_port port,
+void atomisp_css_rx_clear_irq_info(enum mipi_port_id port,
 					unsigned int infos)
 {
 #ifndef ISP2401_NEW_INPUT_SYSTEM
@@ -2118,7 +2118,7 @@ void atomisp_css_enable_cvf(struct atomisp_sub_device *asd,
 
 int atomisp_css_input_configure_port(
 		struct atomisp_sub_device *asd,
-		mipi_port_ID_t port,
+		enum mipi_port_id port,
 		unsigned int num_lanes,
 		unsigned int timeout,
 		unsigned int mipi_freq,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/system_global.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/system_global.h
index d2e3a2deea2e..7907f0ff6d6c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/system_global.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/system_global.h
@@ -284,12 +284,12 @@ typedef enum {
 	N_RX_ID
 } rx_ID_t;
 
-typedef enum {
+enum mipi_port_id {
 	MIPI_PORT0_ID = 0,
 	MIPI_PORT1_ID,
 	MIPI_PORT2_ID,
 	N_MIPI_PORT_ID
-} mipi_port_ID_t;
+};
 
 #define	N_RX_CHANNEL_ID		4
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
index c9cb8e0621e5..2515e162828f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
@@ -98,7 +98,7 @@ static inline void ctrl_unit_get_state(
 
 static inline void mipi_port_get_state(
 	const rx_ID_t					ID,
-	const mipi_port_ID_t			port_ID,
+	const enum mipi_port_id			port_ID,
 	mipi_port_state_t				*state);
 
 static inline void rx_channel_get_state(
@@ -180,7 +180,7 @@ void receiver_get_state(
 	const rx_ID_t				ID,
 	receiver_state_t			*state)
 {
-	mipi_port_ID_t	port_id;
+	enum mipi_port_id	port_id;
 	unsigned int	ch_id;
 
 	assert(ID < N_RX_ID);
@@ -209,7 +209,7 @@ void receiver_get_state(
 	state->raw16 = (uint16_t)receiver_reg_load(ID,
 		_HRT_CSS_RECEIVER_RAW16_REG_IDX);
 
-	for (port_id = (mipi_port_ID_t)0; port_id < N_MIPI_PORT_ID; port_id++) {
+	for (port_id = (enum mipi_port_id)0; port_id < N_MIPI_PORT_ID; port_id++) {
 		mipi_port_get_state(ID, port_id,
 			&(state->mipi_port_state[port_id]));
 	}
@@ -305,7 +305,7 @@ void receiver_set_compression(
 
 void receiver_port_enable(
 	const rx_ID_t			ID,
-	const mipi_port_ID_t		port_ID,
+	const enum mipi_port_id		port_ID,
 	const bool			cnd)
 {
 	hrt_data	reg = receiver_port_reg_load(ID, port_ID,
@@ -324,7 +324,7 @@ void receiver_port_enable(
 
 bool is_receiver_port_enabled(
 	const rx_ID_t			ID,
-	const mipi_port_ID_t		port_ID)
+	const enum mipi_port_id		port_ID)
 {
 	hrt_data	reg = receiver_port_reg_load(ID, port_ID,
 		_HRT_CSS_RECEIVER_DEVICE_READY_REG_IDX);
@@ -333,7 +333,7 @@ bool is_receiver_port_enabled(
 
 void receiver_irq_enable(
 	const rx_ID_t			ID,
-	const mipi_port_ID_t		port_ID,
+	const enum mipi_port_id		port_ID,
 	const rx_irq_info_t		irq_info)
 {
 	receiver_port_reg_store(ID,
@@ -343,7 +343,7 @@ void receiver_irq_enable(
 
 rx_irq_info_t receiver_get_irq_info(
 	const rx_ID_t			ID,
-	const mipi_port_ID_t		port_ID)
+	const enum mipi_port_id		port_ID)
 {
 	return receiver_port_reg_load(ID,
 	port_ID, _HRT_CSS_RECEIVER_IRQ_STATUS_REG_IDX);
@@ -351,7 +351,7 @@ rx_irq_info_t receiver_get_irq_info(
 
 void receiver_irq_clear(
 	const rx_ID_t			ID,
-	const mipi_port_ID_t		port_ID,
+	const enum mipi_port_id		port_ID,
 	const rx_irq_info_t		irq_info)
 {
 	receiver_port_reg_store(ID,
@@ -556,7 +556,7 @@ static inline void ctrl_unit_get_state(
 
 static inline void mipi_port_get_state(
 	const rx_ID_t				ID,
-	const mipi_port_ID_t			port_ID,
+	const enum mipi_port_id			port_ID,
 	mipi_port_state_t			*state)
 {
 	int	i;
@@ -649,7 +649,7 @@ static input_system_cfg2400_t config;
 static void receiver_rst(
 	const rx_ID_t				ID)
 {
-	mipi_port_ID_t		port_id;
+	enum mipi_port_id		port_id;
 
 	assert(ID < N_RX_ID);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_local.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_local.h
index 3e8bd00082dc..bf9230fd08f2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_local.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_local.h
@@ -353,7 +353,7 @@ typedef struct rx_cfg_s		rx_cfg_t;
  */
 struct rx_cfg_s {
 	rx_mode_t			mode;	/* The HW config */
-	mipi_port_ID_t		port;	/* The port ID to apply the control on */
+	enum mipi_port_id		port;	/* The port ID to apply the control on */
 	unsigned int		timeout;
 	unsigned int		initcount;
 	unsigned int		synccount;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_private.h
index 118185eb86e9..48876bb08b70 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_private.h
@@ -63,7 +63,7 @@ STORAGE_CLASS_INPUT_SYSTEM_C hrt_data receiver_reg_load(
 
 STORAGE_CLASS_INPUT_SYSTEM_C void receiver_port_reg_store(
 	const rx_ID_t				ID,
-	const mipi_port_ID_t			port_ID,
+	const enum mipi_port_id			port_ID,
 	const hrt_address			reg,
 	const hrt_data				value)
 {
@@ -77,7 +77,7 @@ STORAGE_CLASS_INPUT_SYSTEM_C void receiver_port_reg_store(
 
 STORAGE_CLASS_INPUT_SYSTEM_C hrt_data receiver_port_reg_load(
 	const rx_ID_t				ID,
-	const mipi_port_ID_t			port_ID,
+	const enum mipi_port_id			port_ID,
 	const hrt_address			reg)
 {
 	assert(ID < N_RX_ID);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/system_global.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/system_global.h
index d803efd7400a..6f63962a54e8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/system_global.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/system_global.h
@@ -266,12 +266,12 @@ typedef enum {
 	N_RX_ID
 } rx_ID_t;
 
-typedef enum {
+enum mipi_port_id {
 	MIPI_PORT0_ID = 0,
 	MIPI_PORT1_ID,
 	MIPI_PORT2_ID,
 	N_MIPI_PORT_ID
-} mipi_port_ID_t;
+};
 
 #define	N_RX_CHANNEL_ID		4
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/input_system_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/input_system_public.h
index 1596757fe9ef..6e37ff0fe0f9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/input_system_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/input_system_public.h
@@ -83,7 +83,7 @@ extern void receiver_set_compression(
  */
 extern void receiver_port_enable(
 	const rx_ID_t				ID,
-	const mipi_port_ID_t		port_ID,
+	const enum mipi_port_id		port_ID,
 	const bool					cnd);
 
 /*! Flag if PORT[port_ID] of RECEIVER[ID] is enabled
@@ -95,7 +95,7 @@ extern void receiver_port_enable(
  */
 extern bool is_receiver_port_enabled(
 	const rx_ID_t				ID,
-	const mipi_port_ID_t		port_ID);
+	const enum mipi_port_id		port_ID);
 
 /*! Enable the IRQ channels of PORT[port_ID] of RECEIVER[ID]
 
@@ -107,7 +107,7 @@ extern bool is_receiver_port_enabled(
  */
 extern void receiver_irq_enable(
 	const rx_ID_t				ID,
-	const mipi_port_ID_t		port_ID,
+	const enum mipi_port_id		port_ID,
 	const rx_irq_info_t			irq_info);
 
 /*! Return the IRQ status of PORT[port_ID] of RECEIVER[ID]
@@ -119,7 +119,7 @@ extern void receiver_irq_enable(
  */
 extern rx_irq_info_t receiver_get_irq_info(
 	const rx_ID_t				ID,
-	const mipi_port_ID_t		port_ID);
+	const enum mipi_port_id		port_ID);
 
 /*! Clear the IRQ status of PORT[port_ID] of RECEIVER[ID]
 
@@ -131,7 +131,7 @@ extern rx_irq_info_t receiver_get_irq_info(
  */
 extern void receiver_irq_clear(
 	const rx_ID_t				ID,
-	const mipi_port_ID_t			port_ID,
+	const enum mipi_port_id			port_ID,
 	const rx_irq_info_t			irq_info);
 
 /*! Write to a control register of INPUT_SYSTEM[ID]
@@ -195,7 +195,7 @@ STORAGE_CLASS_INPUT_SYSTEM_H hrt_data receiver_reg_load(
  */
 STORAGE_CLASS_INPUT_SYSTEM_H void receiver_port_reg_store(
 	const rx_ID_t				ID,
-	const mipi_port_ID_t			port_ID,
+	const enum mipi_port_id			port_ID,
 	const hrt_address			reg,
 	const hrt_data				value);
 
@@ -210,7 +210,7 @@ STORAGE_CLASS_INPUT_SYSTEM_H void receiver_port_reg_store(
  */
 STORAGE_CLASS_INPUT_SYSTEM_H hrt_data receiver_port_reg_load(
 	const rx_ID_t				ID,
-	const mipi_port_ID_t		port_ID,
+	const enum mipi_port_id		port_ID,
 	const hrt_address			reg);
 
 /*! Write to a control register of SUB_SYSTEM[sub_ID] of INPUT_SYSTEM[ID]
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_input_port.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_input_port.h
index f415570a3da9..ad9ca5449369 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_input_port.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_input_port.h
@@ -12,6 +12,9 @@
  * more details.
  */
 
+/* For MIPI_PORT0_ID to MIPI_PORT2_ID */
+#include "system_global.h"
+
 #ifndef __IA_CSS_INPUT_PORT_H
 #define __IA_CSS_INPUT_PORT_H
 
@@ -19,21 +22,12 @@
  * This file contains information about the possible input ports for CSS
  */
 
-/* Enumeration of the physical input ports on the CSS hardware.
- *  There are 3 MIPI CSI-2 ports.
- */
-enum ia_css_csi2_port {
-	IA_CSS_CSI2_PORT0, /* Implicitly map to MIPI_PORT0_ID */
-	IA_CSS_CSI2_PORT1, /* Implicitly map to MIPI_PORT1_ID */
-	IA_CSS_CSI2_PORT2  /* Implicitly map to MIPI_PORT2_ID */
-};
-
 /* Backward compatible for CSS API 2.0 only
  *  TO BE REMOVED when all drivers move to CSS	API 2.1
  */
-#define	IA_CSS_CSI2_PORT_4LANE IA_CSS_CSI2_PORT0
-#define	IA_CSS_CSI2_PORT_1LANE IA_CSS_CSI2_PORT1
-#define	IA_CSS_CSI2_PORT_2LANE IA_CSS_CSI2_PORT2
+#define	IA_CSS_CSI2_PORT_4LANE MIPI_PORT0_ID
+#define	IA_CSS_CSI2_PORT_1LANE MIPI_PORT1_ID
+#define	IA_CSS_CSI2_PORT_2LANE MIPI_PORT2_ID
 
 /* The CSI2 interface supports 2 types of compression or can
  *  be run without compression.
@@ -56,7 +50,7 @@ struct ia_css_csi2_compression {
 /* Input port structure.
  */
 struct ia_css_input_port {
-	enum ia_css_csi2_port port; /** Physical CSI-2 port */
+	enum mipi_port_id port; /** Physical CSI-2 port */
 	unsigned int num_lanes; /** Number of lanes used (4-lane port only) */
 	unsigned int timeout;   /** Timeout value */
 	unsigned int rxcount;   /** Register value, should include all lanes */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_irq.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_irq.h
index 10ef61178bb2..c8840138899a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_irq.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_irq.h
@@ -186,7 +186,7 @@ ia_css_rx_get_irq_info(unsigned int *irq_bits);
  * that occurred.
  */
 void
-ia_css_rx_port_get_irq_info(enum ia_css_csi2_port port, unsigned int *irq_bits);
+ia_css_rx_port_get_irq_info(enum mipi_port_id port, unsigned int *irq_bits);
 
 /* @brief Clear CSI receiver error info.
  *
@@ -218,7 +218,7 @@ ia_css_rx_clear_irq_info(unsigned int irq_bits);
  * error bits get overwritten.
  */
 void
-ia_css_rx_port_clear_irq_info(enum ia_css_csi2_port port, unsigned int irq_bits);
+ia_css_rx_port_clear_irq_info(enum mipi_port_id port, unsigned int irq_bits);
 
 /* @brief Enable or disable specific interrupts.
  *
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mipi.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mipi.h
index f9c9cd76be97..05170c4487eb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mipi.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mipi.h
@@ -55,7 +55,7 @@ ia_css_mipi_frame_specify(const unsigned int	size_mem_words,
  *
  */
 enum ia_css_err
-ia_css_mipi_frame_enable_check_on_size(const enum ia_css_csi2_port port,
+ia_css_mipi_frame_enable_check_on_size(const enum mipi_port_id port,
 				const unsigned int	size_mem_words);
 #endif
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c
index adefa57820a4..c031c70aee9b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c
@@ -118,7 +118,7 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 
 	/* Determine which input formatter config set is targeted. */
 	/* Index is equal to the CSI-2 port used. */
-	enum ia_css_csi2_port port;
+	enum mipi_port_id port;
 
 	if (binary) {
 		cropped_height = binary->in_frame_info.res.height;
@@ -141,7 +141,7 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 	if (config->mode == IA_CSS_INPUT_MODE_SENSOR
 	    || config->mode == IA_CSS_INPUT_MODE_BUFFERED_SENSOR) {
 		port = config->source.port.port;
-		if_config_index = (uint8_t) (port - IA_CSS_CSI2_PORT0);
+		if_config_index = (uint8_t) (port - MIPI_PORT0_ID);
 	} else if (config->mode == IA_CSS_INPUT_MODE_MEMORY) {
 		if_config_index = SH_CSS_IF_CONFIG_NOT_NEEDED;
 	} else {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/interface/ia_css_isys.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/interface/ia_css_isys.h
index 4cf2defe9ef0..5f5ee28a157f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/interface/ia_css_isys.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/interface/ia_css_isys.h
@@ -50,8 +50,8 @@ typedef input_system_cfg_t	ia_css_isys_descr_t;
 #if defined(USE_INPUT_SYSTEM_VERSION_2) || defined(USE_INPUT_SYSTEM_VERSION_2401)
 input_system_error_t ia_css_isys_init(void);
 void ia_css_isys_uninit(void);
-mipi_port_ID_t ia_css_isys_port_to_mipi_port(
-	enum ia_css_csi2_port api_port);
+enum mipi_port_id ia_css_isys_port_to_mipi_port(
+	enum mipi_port_id api_port);
 #endif
 
 #if defined(USE_INPUT_SYSTEM_VERSION_2401)
@@ -68,7 +68,7 @@ mipi_port_ID_t ia_css_isys_port_to_mipi_port(
  *				there is already a stream registered with the same handle
  */
 enum ia_css_err ia_css_isys_csi_rx_register_stream(
-	enum ia_css_csi2_port port,
+	enum mipi_port_id port,
 	uint32_t isys_stream_id);
 
 /**
@@ -83,7 +83,7 @@ enum ia_css_err ia_css_isys_csi_rx_register_stream(
  *				there is no stream registered with that handle
  */
 enum ia_css_err ia_css_isys_csi_rx_unregister_stream(
-	enum ia_css_csi2_port port,
+	enum mipi_port_id port,
 	uint32_t isys_stream_id);
 
 enum ia_css_err ia_css_isys_convert_compressed_format(
@@ -101,12 +101,12 @@ void ia_css_isys_rx_configure(
 
 void ia_css_isys_rx_disable(void);
 
-void ia_css_isys_rx_enable_all_interrupts(mipi_port_ID_t port);
+void ia_css_isys_rx_enable_all_interrupts(enum mipi_port_id port);
 
-unsigned int ia_css_isys_rx_get_interrupt_reg(mipi_port_ID_t port);
-void ia_css_isys_rx_get_irq_info(mipi_port_ID_t port,
+unsigned int ia_css_isys_rx_get_interrupt_reg(enum mipi_port_id port);
+void ia_css_isys_rx_get_irq_info(enum mipi_port_id port,
 				 unsigned int *irq_infos);
-void ia_css_isys_rx_clear_irq_info(mipi_port_ID_t port,
+void ia_css_isys_rx_clear_irq_info(enum mipi_port_id port,
 				   unsigned int irq_infos);
 unsigned int ia_css_isys_rx_translate_irq_infos(unsigned int bits);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/csi_rx_rmgr.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/csi_rx_rmgr.c
index 3b04dc51335a..a914ce5532ec 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/csi_rx_rmgr.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/csi_rx_rmgr.c
@@ -141,7 +141,7 @@ void ia_css_isys_csi_rx_lut_rmgr_release(
 }
 
 enum ia_css_err ia_css_isys_csi_rx_register_stream(
-	enum ia_css_csi2_port port,
+	enum mipi_port_id port,
 	uint32_t isys_stream_id)
 {
 	enum ia_css_err retval = IA_CSS_ERR_INTERNAL_ERROR;
@@ -160,7 +160,7 @@ enum ia_css_err ia_css_isys_csi_rx_register_stream(
 }
 
 enum ia_css_err ia_css_isys_csi_rx_unregister_stream(
-	enum ia_css_csi2_port port,
+	enum mipi_port_id port,
 	uint32_t isys_stream_id)
 {
 	enum ia_css_err retval = IA_CSS_ERR_INTERNAL_ERROR;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/rx.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/rx.c
index 70f6cb5e5918..65ddff137291 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/rx.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/rx.c
@@ -36,7 +36,7 @@ more details.
 #include "sh_css_internal.h"
 
 #if !defined(USE_INPUT_SYSTEM_VERSION_2401)
-void ia_css_isys_rx_enable_all_interrupts(mipi_port_ID_t port)
+void ia_css_isys_rx_enable_all_interrupts(enum mipi_port_id port)
 {
 	hrt_data bits = receiver_port_reg_load(RX0_ID,
 				port,
@@ -80,22 +80,22 @@ void ia_css_isys_rx_enable_all_interrupts(mipi_port_ID_t port)
  * initializers in Windows. Without that there is no easy way to guarantee
  * that the array values would be in the correct order.
  * */
-mipi_port_ID_t ia_css_isys_port_to_mipi_port(enum ia_css_csi2_port api_port)
+enum mipi_port_id ia_css_isys_port_to_mipi_port(enum mipi_port_id api_port)
 {
 	/* In this module the validity of the inptu variable should
 	 * have been checked already, so we do not check for erroneous
 	 * values. */
-	mipi_port_ID_t port = MIPI_PORT0_ID;
+	enum mipi_port_id port = MIPI_PORT0_ID;
 
-	if (api_port == IA_CSS_CSI2_PORT1)
+	if (api_port == MIPI_PORT1_ID)
 		port = MIPI_PORT1_ID;
-	else if (api_port == IA_CSS_CSI2_PORT2)
+	else if (api_port == MIPI_PORT2_ID)
 		port = MIPI_PORT2_ID;
 
 	return port;
 }
 
-unsigned int ia_css_isys_rx_get_interrupt_reg(mipi_port_ID_t port)
+unsigned int ia_css_isys_rx_get_interrupt_reg(enum mipi_port_id port)
 {
 	return receiver_port_reg_load(RX0_ID,
 				      port,
@@ -104,17 +104,17 @@ unsigned int ia_css_isys_rx_get_interrupt_reg(mipi_port_ID_t port)
 
 void ia_css_rx_get_irq_info(unsigned int *irq_infos)
 {
-	ia_css_rx_port_get_irq_info(IA_CSS_CSI2_PORT1, irq_infos);
+	ia_css_rx_port_get_irq_info(MIPI_PORT1_ID, irq_infos);
 }
 
-void ia_css_rx_port_get_irq_info(enum ia_css_csi2_port api_port,
+void ia_css_rx_port_get_irq_info(enum mipi_port_id api_port,
 				 unsigned int *irq_infos)
 {
-	mipi_port_ID_t port = ia_css_isys_port_to_mipi_port(api_port);
+	enum mipi_port_id port = ia_css_isys_port_to_mipi_port(api_port);
 	ia_css_isys_rx_get_irq_info(port, irq_infos);
 }
 
-void ia_css_isys_rx_get_irq_info(mipi_port_ID_t port,
+void ia_css_isys_rx_get_irq_info(enum mipi_port_id port,
 				 unsigned int *irq_infos)
 {
 	unsigned int bits;
@@ -169,16 +169,16 @@ unsigned int ia_css_isys_rx_translate_irq_infos(unsigned int bits)
 
 void ia_css_rx_clear_irq_info(unsigned int irq_infos)
 {
-	ia_css_rx_port_clear_irq_info(IA_CSS_CSI2_PORT1, irq_infos);
+	ia_css_rx_port_clear_irq_info(MIPI_PORT1_ID, irq_infos);
 }
 
-void ia_css_rx_port_clear_irq_info(enum ia_css_csi2_port api_port, unsigned int irq_infos)
+void ia_css_rx_port_clear_irq_info(enum mipi_port_id api_port, unsigned int irq_infos)
 {
-	mipi_port_ID_t port = ia_css_isys_port_to_mipi_port(api_port);
+	enum mipi_port_id port = ia_css_isys_port_to_mipi_port(api_port);
 	ia_css_isys_rx_clear_irq_info(port, irq_infos);
 }
 
-void ia_css_isys_rx_clear_irq_info(mipi_port_ID_t port, unsigned int irq_infos)
+void ia_css_isys_rx_clear_irq_info(enum mipi_port_id port, unsigned int irq_infos)
 {
 	hrt_data bits = receiver_port_reg_load(RX0_ID,
 				port,
@@ -492,7 +492,7 @@ void ia_css_isys_rx_configure(const rx_cfg_t *config,
 #if defined(HAS_RX_VERSION_2)
 	bool port_enabled[N_MIPI_PORT_ID];
 	bool any_port_enabled = false;
-	mipi_port_ID_t port;
+	enum mipi_port_id port;
 
 	if ((config == NULL)
 		|| (config->mode >= N_RX_MODE)
@@ -500,7 +500,7 @@ void ia_css_isys_rx_configure(const rx_cfg_t *config,
 		assert(0);
 		return;
 	}
-	for (port = (mipi_port_ID_t) 0; port < N_MIPI_PORT_ID; port++) {
+	for (port = (enum mipi_port_id) 0; port < N_MIPI_PORT_ID; port++) {
 		if (is_receiver_port_enabled(RX0_ID, port))
 			any_port_enabled = true;
 	}
@@ -595,8 +595,8 @@ void ia_css_isys_rx_configure(const rx_cfg_t *config,
 
 void ia_css_isys_rx_disable(void)
 {
-	mipi_port_ID_t port;
-	for (port = (mipi_port_ID_t) 0; port < N_MIPI_PORT_ID; port++) {
+	enum mipi_port_id port;
+	for (port = (enum mipi_port_id) 0; port < N_MIPI_PORT_ID; port++) {
 		receiver_port_reg_store(RX0_ID, port,
 					_HRT_CSS_RECEIVER_DEVICE_READY_REG_IDX,
 					false);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
index 269829770082..4746620ca212 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
@@ -161,9 +161,9 @@ void ia_css_pipeline_start(enum ia_css_pipe_id pipe_id,
 #endif
 #if !defined(HAS_NO_INPUT_SYSTEM)
 #ifndef ISP2401
-				, (mipi_port_ID_t) 0
+				, (enum mipi_port_id) 0
 #else
-				(mipi_port_ID_t) 0,
+				(enum mipi_port_id) 0,
 #endif
 #endif
 #ifndef ISP2401
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 9958b275bd50..33024b92911f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -742,11 +742,11 @@ static bool sh_css_translate_stream_cfg_to_input_system_input_port_id(
 		break;
 	case IA_CSS_INPUT_MODE_BUFFERED_SENSOR:
 
-		if (stream_cfg->source.port.port == IA_CSS_CSI2_PORT0) {
+		if (stream_cfg->source.port.port == MIPI_PORT0_ID) {
 			isys_stream_descr->input_port_id = INPUT_SYSTEM_CSI_PORT0_ID;
-		} else if (stream_cfg->source.port.port == IA_CSS_CSI2_PORT1) {
+		} else if (stream_cfg->source.port.port == MIPI_PORT1_ID) {
 			isys_stream_descr->input_port_id = INPUT_SYSTEM_CSI_PORT1_ID;
-		} else if (stream_cfg->source.port.port == IA_CSS_CSI2_PORT2) {
+		} else if (stream_cfg->source.port.port == MIPI_PORT2_ID) {
 			isys_stream_descr->input_port_id = INPUT_SYSTEM_CSI_PORT2_ID;
 		}
 
@@ -1195,7 +1195,7 @@ static inline struct ia_css_pipe *stream_get_target_pipe(
 
 static enum ia_css_err stream_csi_rx_helper(
 	struct ia_css_stream *stream,
-	enum ia_css_err (*func)(enum ia_css_csi2_port, uint32_t))
+	enum ia_css_err (*func)(enum mipi_port_id, uint32_t))
 {
 	enum ia_css_err retval = IA_CSS_ERR_INTERNAL_ERROR;
 	uint32_t sp_thread_id, stream_id;
@@ -1454,7 +1454,7 @@ static void start_pipe(
 				&me->stream->info.metadata_info
 #if !defined(HAS_NO_INPUT_SYSTEM)
 				,(input_mode==IA_CSS_INPUT_MODE_MEMORY) ?
-					(mipi_port_ID_t)0 :
+					(enum mipi_port_id)0 :
 					me->stream->config.source.port.port
 #endif
 #ifdef ISP2401
@@ -1497,7 +1497,7 @@ static void
 enable_interrupts(enum ia_css_irq_type irq_type)
 {
 #ifdef USE_INPUT_SYSTEM_VERSION_2
-	mipi_port_ID_t port;
+	enum mipi_port_id port;
 #endif
 	bool enable_pulse = irq_type != IA_CSS_IRQ_TYPE_EDGE;
 	IA_CSS_ENTER_PRIVATE("");
@@ -4074,9 +4074,9 @@ preview_start(struct ia_css_pipe *pipe)
 #endif
 #if !defined(HAS_NO_INPUT_SYSTEM)
 #ifndef ISP2401
-			, (mipi_port_ID_t)0
+			, (enum mipi_port_id)0
 #else
-			(mipi_port_ID_t)0,
+			(enum mipi_port_id)0,
 #endif
 #endif
 #ifndef ISP2401
@@ -4106,9 +4106,9 @@ preview_start(struct ia_css_pipe *pipe)
 #endif
 #if !defined(HAS_NO_INPUT_SYSTEM)
 #ifndef ISP2401
-			, (mipi_port_ID_t) 0
+			, (enum mipi_port_id) 0
 #else
-			(mipi_port_ID_t) 0,
+			(enum mipi_port_id) 0,
 #endif
 #endif
 #ifndef ISP2401
@@ -4673,7 +4673,7 @@ ia_css_dequeue_psys_event(struct ia_css_event *event)
 	event->type = convert_event_sp_to_host_domain[payload[0]];
 	/* Some sane default values since not all events use all fields. */
 	event->pipe = NULL;
-	event->port = IA_CSS_CSI2_PORT0;
+	event->port = MIPI_PORT0_ID;
 	event->exp_id = 0;
 	event->fw_warning = IA_CSS_FW_WARNING_NONE;
 	event->fw_handle = 0;
@@ -4719,7 +4719,7 @@ ia_css_dequeue_psys_event(struct ia_css_event *event)
 		}
 	}
 	if (event->type == IA_CSS_EVENT_TYPE_PORT_EOF) {
-		event->port = (enum ia_css_csi2_port)payload[1];
+		event->port = (enum mipi_port_id)payload[1];
 		event->exp_id = payload[3];
 	} else if (event->type == IA_CSS_EVENT_TYPE_FW_WARNING) {
 		event->fw_warning = (enum ia_css_fw_warning)payload[1];
@@ -5949,9 +5949,9 @@ static enum ia_css_err video_start(struct ia_css_pipe *pipe)
 #endif
 #if !defined(HAS_NO_INPUT_SYSTEM)
 #ifndef ISP2401
-			, (mipi_port_ID_t)0
+			, (enum mipi_port_id)0
 #else
-			(mipi_port_ID_t)0,
+			(enum mipi_port_id)0,
 #endif
 #endif
 #ifndef ISP2401
@@ -9173,7 +9173,7 @@ ia_css_stream_configure_rx(struct ia_css_stream *stream)
 	else if (config->num_lanes != 0)
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
 
-	if (config->port > IA_CSS_CSI2_PORT2)
+	if (config->port > MIPI_PORT2_ID)
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
 	stream->csi_rx_config.port =
 		ia_css_isys_port_to_mipi_port(config->port);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c
index 883474e90c81..0c2e5e3a007a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c
@@ -239,7 +239,7 @@ ia_css_mipi_frame_calculate_size(const unsigned int width,
 
 #if !defined(HAS_NO_INPUT_SYSTEM) && defined(USE_INPUT_SYSTEM_VERSION_2)
 enum ia_css_err
-ia_css_mipi_frame_enable_check_on_size(const enum ia_css_csi2_port port,
+ia_css_mipi_frame_enable_check_on_size(const enum mipi_port_id port,
 				const unsigned int	size_mem_words)
 {
 	uint32_t idx;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
index bb297184ba3a..93f7c50511d8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
@@ -1196,7 +1196,7 @@ sh_css_sp_init_pipeline(struct ia_css_pipeline *me,
 			const struct ia_css_metadata_config *md_config,
 			const struct ia_css_metadata_info *md_info,
 #if !defined(HAS_NO_INPUT_SYSTEM)
-			const mipi_port_ID_t port_id
+			const enum mipi_port_id port_id
 #endif
 #ifdef ISP2401
 			,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.h
index 98444a3cc3e4..3c41e997de79 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.h
@@ -64,7 +64,7 @@ sh_css_sp_init_pipeline(struct ia_css_pipeline *me,
 			const struct ia_css_metadata_config *md_config,
 			const struct ia_css_metadata_info *md_info,
 #if !defined(HAS_NO_INPUT_SYSTEM)
-			const mipi_port_ID_t port_id
+			const enum mipi_port_id port_id
 #endif
 #ifdef ISP2401
 			,
-- 
2.14.3
