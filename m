Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45881 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753584AbdJaQEc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 12:04:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/7] media: atomisp: fix ident for assert/return
Date: Tue, 31 Oct 2017 12:04:14 -0400
Message-Id: <7b2c3c762cad663021b3b3e7aac47b2a8c8d03a9.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On lots of places, assert/return are starting at the first
column, causing indentation issues, as complained by spatch:

drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq_private.h:32 irq_reg_store() warn: inconsistent indenting

Used this small script to fix such occurrences:

for i in $(git grep -l -E "^(assert|return)" drivers/staging/media/); do perl -ne 's/^(assert|return)/\t$1/; print $_' <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../pci/atomisp2/css2400/camera/util/src/util.c    |  2 +-
 .../hive_isp_css_common/host/event_fifo_private.h  |  2 +-
 .../host/fifo_monitor_private.h                    | 28 +++++-----
 .../css2400/hive_isp_css_common/host/gdc.c         |  8 +--
 .../css2400/hive_isp_css_common/host/gp_device.c   |  2 +-
 .../hive_isp_css_common/host/gp_device_private.h   | 16 +++---
 .../hive_isp_css_common/host/gpio_private.h        |  4 +-
 .../hive_isp_css_common/host/hmem_private.h        |  4 +-
 .../host/input_formatter_private.h                 | 16 +++---
 .../hive_isp_css_common/host/input_system.c        | 28 +++++-----
 .../host/input_system_private.h                    | 64 +++++++++++-----------
 .../css2400/hive_isp_css_common/host/irq.c         | 30 +++++-----
 .../css2400/hive_isp_css_common/host/irq_private.h | 12 ++--
 .../css2400/hive_isp_css_common/host/isp.c         |  4 +-
 .../css2400/hive_isp_css_common/host/mmu.c         |  6 +-
 .../css2400/hive_isp_css_common/host/mmu_private.h | 12 ++--
 .../css2400/hive_isp_css_common/host/sp_private.h  | 60 ++++++++++----------
 .../atomisp/pci/atomisp2/css2400/sh_css_hrt.c      |  2 +-
 drivers/staging/media/imx/imx-media-capture.c      |  2 +-
 19 files changed, 151 insertions(+), 151 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/src/util.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/src/util.c
index 08f486e20a65..54193789a809 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/src/util.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/src/util.c
@@ -111,7 +111,7 @@ unsigned int ia_css_util_input_format_bpp(
 		break;
 
 	}
-return rval;
+	return rval;
 }
 
 enum ia_css_err ia_css_util_check_vf_info(
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/event_fifo_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/event_fifo_private.h
index 9d3a29696094..bcfb734c2ed3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/event_fifo_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/event_fifo_private.h
@@ -28,7 +28,7 @@ STORAGE_CLASS_EVENT_C void event_wait_for(const event_ID_t ID)
 	assert(ID < N_EVENT_ID);
 	assert(event_source_addr[ID] != ((hrt_address)-1));
 	(void)ia_css_device_load_uint32(event_source_addr[ID]);
-return;
+	return;
 }
 
 STORAGE_CLASS_EVENT_C void cnd_event_wait_for(const event_ID_t ID,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/fifo_monitor_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/fifo_monitor_private.h
index 618b2f7e9c75..d58cd7d1828d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/fifo_monitor_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/fifo_monitor_private.h
@@ -33,26 +33,26 @@ STORAGE_CLASS_FIFO_MONITOR_C void fifo_switch_set(
 	const fifo_switch_t			switch_id,
 	const hrt_data				sel)
 {
-assert(ID == FIFO_MONITOR0_ID);
-assert(FIFO_MONITOR_BASE[ID] != (hrt_address)-1);
-assert(switch_id < N_FIFO_SWITCH);
+	assert(ID == FIFO_MONITOR0_ID);
+	assert(FIFO_MONITOR_BASE[ID] != (hrt_address)-1);
+	assert(switch_id < N_FIFO_SWITCH);
 	(void)ID;
 
 	gp_device_reg_store(GP_DEVICE0_ID, FIFO_SWITCH_ADDR[switch_id], sel);
 
-return;
+	return;
 }
 
 STORAGE_CLASS_FIFO_MONITOR_C hrt_data fifo_switch_get(
 	const fifo_monitor_ID_t		ID,
 	const fifo_switch_t			switch_id)
 {
-assert(ID == FIFO_MONITOR0_ID);
-assert(FIFO_MONITOR_BASE[ID] != (hrt_address)-1);
-assert(switch_id < N_FIFO_SWITCH);
+	assert(ID == FIFO_MONITOR0_ID);
+	assert(FIFO_MONITOR_BASE[ID] != (hrt_address)-1);
+	assert(switch_id < N_FIFO_SWITCH);
 	(void)ID;
 
-return gp_device_reg_load(GP_DEVICE0_ID, FIFO_SWITCH_ADDR[switch_id]);
+	return gp_device_reg_load(GP_DEVICE0_ID, FIFO_SWITCH_ADDR[switch_id]);
 }
 
 
@@ -61,19 +61,19 @@ STORAGE_CLASS_FIFO_MONITOR_C void fifo_monitor_reg_store(
 	const unsigned int			reg,
 	const hrt_data				value)
 {
-assert(ID < N_FIFO_MONITOR_ID);
-assert(FIFO_MONITOR_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_FIFO_MONITOR_ID);
+	assert(FIFO_MONITOR_BASE[ID] != (hrt_address)-1);
 	ia_css_device_store_uint32(FIFO_MONITOR_BASE[ID] + reg*sizeof(hrt_data), value);
-return;
+	return;
 }
 
 STORAGE_CLASS_FIFO_MONITOR_C hrt_data fifo_monitor_reg_load(
 	const fifo_monitor_ID_t		ID,
 	const unsigned int			reg)
 {
-assert(ID < N_FIFO_MONITOR_ID);
-assert(FIFO_MONITOR_BASE[ID] != (hrt_address)-1);
-return ia_css_device_load_uint32(FIFO_MONITOR_BASE[ID] + reg*sizeof(hrt_data));
+	assert(ID < N_FIFO_MONITOR_ID);
+	assert(FIFO_MONITOR_BASE[ID] != (hrt_address)-1);
+	return ia_css_device_load_uint32(FIFO_MONITOR_BASE[ID] + reg*sizeof(hrt_data));
 }
 
 #endif /* __FIFO_MONITOR_PRIVATE_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gdc.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gdc.c
index 69fa616889b1..4d6308abd036 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gdc.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gdc.c
@@ -62,7 +62,7 @@ void gdc_lut_store(
 		gdc_reg_store(ID, lut_offset++, word_0);
 		gdc_reg_store(ID, lut_offset++, word_1);
 	}
-return;
+	return;
 }
 
 /*
@@ -103,7 +103,7 @@ int gdc_get_unity(
 {
 	assert(ID < N_GDC_ID);
 	(void)ID;
-return (int)(1UL << HRT_GDC_FRAC_BITS);
+	return (int)(1UL << HRT_GDC_FRAC_BITS);
 }
 
 
@@ -116,12 +116,12 @@ STORAGE_CLASS_INLINE void gdc_reg_store(
 	const hrt_data		value)
 {
 	ia_css_device_store_uint32(GDC_BASE[ID] + reg*sizeof(hrt_data), value);
-return;
+	return;
 }
 
 STORAGE_CLASS_INLINE hrt_data gdc_reg_load(
 	const gdc_ID_t		ID,
 	const unsigned int	reg)
 {
-return ia_css_device_load_uint32(GDC_BASE[ID] + reg*sizeof(hrt_data));
+	return ia_css_device_load_uint32(GDC_BASE[ID] + reg*sizeof(hrt_data));
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_device.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_device.c
index 9a34ac052adf..da88aa3af664 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_device.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_device.c
@@ -104,5 +104,5 @@ void gp_device_get_state(
 		_REG_GP_SYNCGEN_FRAME_CNT_ADDR);
 	state->soft_reset = gp_device_reg_load(ID,
 		_REG_GP_SOFT_RESET_ADDR);
-return;
+	return;
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_device_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_device_private.h
index bce1fdf79114..7c0362c29411 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_device_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gp_device_private.h
@@ -26,21 +26,21 @@ STORAGE_CLASS_GP_DEVICE_C void gp_device_reg_store(
 	const unsigned int		reg_addr,
 	const hrt_data			value)
 {
-assert(ID < N_GP_DEVICE_ID);
-assert(GP_DEVICE_BASE[ID] != (hrt_address)-1);
-assert((reg_addr % sizeof(hrt_data)) == 0);
+	assert(ID < N_GP_DEVICE_ID);
+	assert(GP_DEVICE_BASE[ID] != (hrt_address)-1);
+	assert((reg_addr % sizeof(hrt_data)) == 0);
 	ia_css_device_store_uint32(GP_DEVICE_BASE[ID] + reg_addr, value);
-return;
+	return;
 }
 
 STORAGE_CLASS_GP_DEVICE_C hrt_data gp_device_reg_load(
 	const gp_device_ID_t	ID,
 	const hrt_address	reg_addr)
 {
-assert(ID < N_GP_DEVICE_ID);
-assert(GP_DEVICE_BASE[ID] != (hrt_address)-1);
-assert((reg_addr % sizeof(hrt_data)) == 0);
-return ia_css_device_load_uint32(GP_DEVICE_BASE[ID] + reg_addr);
+	assert(ID < N_GP_DEVICE_ID);
+	assert(GP_DEVICE_BASE[ID] != (hrt_address)-1);
+	assert((reg_addr % sizeof(hrt_data)) == 0);
+	return ia_css_device_load_uint32(GP_DEVICE_BASE[ID] + reg_addr);
 }
 
 #endif /* __GP_DEVICE_PRIVATE_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gpio_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gpio_private.h
index 6ace2184b522..b6ebf34eaa9d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gpio_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/gpio_private.h
@@ -29,7 +29,7 @@ STORAGE_CLASS_GPIO_C void gpio_reg_store(
 OP___assert(ID < N_GPIO_ID);
 OP___assert(GPIO_BASE[ID] != (hrt_address)-1);
 	ia_css_device_store_uint32(GPIO_BASE[ID] + reg*sizeof(hrt_data), value);
-return;
+	return;
 }
 
 STORAGE_CLASS_GPIO_C hrt_data gpio_reg_load(
@@ -38,7 +38,7 @@ STORAGE_CLASS_GPIO_C hrt_data gpio_reg_load(
 {
 OP___assert(ID < N_GPIO_ID);
 OP___assert(GPIO_BASE[ID] != (hrt_address)-1);
-return ia_css_device_load_uint32(GPIO_BASE[ID] + reg*sizeof(hrt_data));
+	return ia_css_device_load_uint32(GPIO_BASE[ID] + reg*sizeof(hrt_data));
 }
 
 #endif /* __GPIO_PRIVATE_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hmem_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hmem_private.h
index 2b636e0e6482..32a780380e11 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hmem_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hmem_private.h
@@ -22,9 +22,9 @@
 STORAGE_CLASS_HMEM_C size_t sizeof_hmem(
 	const hmem_ID_t		ID)
 {
-assert(ID < N_HMEM_ID);
+	assert(ID < N_HMEM_ID);
 	(void)ID;
-return HMEM_SIZE*sizeof(hmem_data_t);
+	return HMEM_SIZE*sizeof(hmem_data_t);
 }
 
 #endif /* __HMEM_PRIVATE_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_formatter_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_formatter_private.h
index d34933e44aa9..2f42a9c2771c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_formatter_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_formatter_private.h
@@ -26,21 +26,21 @@ STORAGE_CLASS_INPUT_FORMATTER_C void input_formatter_reg_store(
 	const hrt_address			reg_addr,
 	const hrt_data				value)
 {
-assert(ID < N_INPUT_FORMATTER_ID);
-assert(INPUT_FORMATTER_BASE[ID] != (hrt_address)-1);
-assert((reg_addr % sizeof(hrt_data)) == 0);
+	assert(ID < N_INPUT_FORMATTER_ID);
+	assert(INPUT_FORMATTER_BASE[ID] != (hrt_address)-1);
+	assert((reg_addr % sizeof(hrt_data)) == 0);
 	ia_css_device_store_uint32(INPUT_FORMATTER_BASE[ID] + reg_addr, value);
-return;
+	return;
 }
 
 STORAGE_CLASS_INPUT_FORMATTER_C hrt_data input_formatter_reg_load(
 	const input_formatter_ID_t	ID,
 	const unsigned int			reg_addr)
 {
-assert(ID < N_INPUT_FORMATTER_ID);
-assert(INPUT_FORMATTER_BASE[ID] != (hrt_address)-1);
-assert((reg_addr % sizeof(hrt_data)) == 0);
-return ia_css_device_load_uint32(INPUT_FORMATTER_BASE[ID] + reg_addr);
+	assert(ID < N_INPUT_FORMATTER_ID);
+	assert(INPUT_FORMATTER_BASE[ID] != (hrt_address)-1);
+	assert((reg_addr % sizeof(hrt_data)) == 0);
+	return ia_css_device_load_uint32(INPUT_FORMATTER_BASE[ID] + reg_addr);
 }
 
 #endif /* __INPUT_FORMATTER_PRIVATE_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
index f35e18987b67..c9af2bfc1f88 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
@@ -173,7 +173,7 @@ void input_system_get_state(
 			&(state->ctrl_unit_state[sub_id - CTRL_UNIT0_ID]));
 	}
 
-return;
+	return;
 }
 
 void receiver_get_state(
@@ -245,7 +245,7 @@ void receiver_get_state(
 	state->be_irq_clear = receiver_reg_load(ID,
 		_HRT_CSS_RECEIVER_BE_IRQ_CLEAR_REG_IDX);
 
-return;
+	return;
 }
 
 bool is_mipi_format_yuv420(
@@ -258,7 +258,7 @@ bool is_mipi_format_yuv420(
 		(mipi_format == MIPI_FORMAT_YUV420_10_SHIFT));
 /* MIPI_FORMAT_YUV420_8_LEGACY is not YUV420 */
 
-return is_yuv420;
+	return is_yuv420;
 }
 
 void receiver_set_compression(
@@ -300,7 +300,7 @@ void receiver_set_compression(
 	reg = ((field_id < 6)?(val << (field_id * 5)):(val << ((field_id - 6) * 5)));
 	receiver_reg_store(ID, addr, reg);
 
-return;
+	return;
 }
 
 void receiver_port_enable(
@@ -319,7 +319,7 @@ void receiver_port_enable(
 
 	receiver_port_reg_store(ID, port_ID,
 		_HRT_CSS_RECEIVER_DEVICE_READY_REG_IDX, reg);
-return;
+	return;
 }
 
 bool is_receiver_port_enabled(
@@ -328,7 +328,7 @@ bool is_receiver_port_enabled(
 {
 	hrt_data	reg = receiver_port_reg_load(ID, port_ID,
 		_HRT_CSS_RECEIVER_DEVICE_READY_REG_IDX);
-return ((reg & 0x01) != 0);
+	return ((reg & 0x01) != 0);
 }
 
 void receiver_irq_enable(
@@ -338,14 +338,14 @@ void receiver_irq_enable(
 {
 	receiver_port_reg_store(ID,
 		port_ID, _HRT_CSS_RECEIVER_IRQ_ENABLE_REG_IDX, irq_info);
-return;
+	return;
 }
 
 rx_irq_info_t receiver_get_irq_info(
 	const rx_ID_t			ID,
 	const mipi_port_ID_t		port_ID)
 {
-return receiver_port_reg_load(ID,
+	return receiver_port_reg_load(ID,
 	port_ID, _HRT_CSS_RECEIVER_IRQ_STATUS_REG_IDX);
 }
 
@@ -356,7 +356,7 @@ void receiver_irq_clear(
 {
 	receiver_port_reg_store(ID,
 		port_ID, _HRT_CSS_RECEIVER_IRQ_STATUS_REG_IDX, irq_info);
-return;
+	return;
 }
 
 STORAGE_CLASS_INLINE void capture_unit_get_state(
@@ -418,7 +418,7 @@ STORAGE_CLASS_INLINE void capture_unit_get_state(
 		sub_id,
 		CAPT_FSM_STATE_INFO_REG_ID);
 
-return;
+	return;
 }
 
 STORAGE_CLASS_INLINE void acquisition_unit_get_state(
@@ -468,7 +468,7 @@ STORAGE_CLASS_INLINE void acquisition_unit_get_state(
 		sub_id,
 		ACQ_INT_CNTR_INFO_REG_ID);
 
-return;
+	return;
 }
 
 STORAGE_CLASS_INLINE void ctrl_unit_get_state(
@@ -551,7 +551,7 @@ STORAGE_CLASS_INLINE void ctrl_unit_get_state(
 		sub_id,
 		ISYS_CTRL_CAPT_RESERVE_ONE_MEM_REGION_REG_ID);
 
-return;
+	return;
 }
 
 STORAGE_CLASS_INLINE void mipi_port_get_state(
@@ -587,7 +587,7 @@ STORAGE_CLASS_INLINE void mipi_port_get_state(
 		state->lane_rx_count[i] = (uint8_t)((state->rx_count)>>(i*8));
 	}
 
-return;
+	return;
 }
 
 STORAGE_CLASS_INLINE void rx_channel_get_state(
@@ -640,7 +640,7 @@ STORAGE_CLASS_INLINE void rx_channel_get_state(
 		state->pred[i] = (mipi_predictor_t)((val & 0x18) >> 3);
 	}
 
-return;
+	return;
 }
 
 // MW: "2400" in the name is not good, but this is to avoid a naming conflict
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_private.h
index ed1b947b00f9..118185eb86e9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system_private.h
@@ -26,19 +26,19 @@ STORAGE_CLASS_INPUT_SYSTEM_C void input_system_reg_store(
 	const hrt_address			reg,
 	const hrt_data				value)
 {
-assert(ID < N_INPUT_SYSTEM_ID);
-assert(INPUT_SYSTEM_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_INPUT_SYSTEM_ID);
+	assert(INPUT_SYSTEM_BASE[ID] != (hrt_address)-1);
 	ia_css_device_store_uint32(INPUT_SYSTEM_BASE[ID] + reg*sizeof(hrt_data), value);
-return;
+	return;
 }
 
 STORAGE_CLASS_INPUT_SYSTEM_C hrt_data input_system_reg_load(
 	const input_system_ID_t			ID,
 	const hrt_address			reg)
 {
-assert(ID < N_INPUT_SYSTEM_ID);
-assert(INPUT_SYSTEM_BASE[ID] != (hrt_address)-1);
-return ia_css_device_load_uint32(INPUT_SYSTEM_BASE[ID] + reg*sizeof(hrt_data));
+	assert(ID < N_INPUT_SYSTEM_ID);
+	assert(INPUT_SYSTEM_BASE[ID] != (hrt_address)-1);
+	return ia_css_device_load_uint32(INPUT_SYSTEM_BASE[ID] + reg*sizeof(hrt_data));
 }
 
 STORAGE_CLASS_INPUT_SYSTEM_C void receiver_reg_store(
@@ -46,19 +46,19 @@ STORAGE_CLASS_INPUT_SYSTEM_C void receiver_reg_store(
 	const hrt_address			reg,
 	const hrt_data				value)
 {
-assert(ID < N_RX_ID);
-assert(RX_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_RX_ID);
+	assert(RX_BASE[ID] != (hrt_address)-1);
 	ia_css_device_store_uint32(RX_BASE[ID] + reg*sizeof(hrt_data), value);
-return;
+	return;
 }
 
 STORAGE_CLASS_INPUT_SYSTEM_C hrt_data receiver_reg_load(
 	const rx_ID_t				ID,
 	const hrt_address			reg)
 {
-assert(ID < N_RX_ID);
-assert(RX_BASE[ID] != (hrt_address)-1);
-return ia_css_device_load_uint32(RX_BASE[ID] + reg*sizeof(hrt_data));
+	assert(ID < N_RX_ID);
+	assert(RX_BASE[ID] != (hrt_address)-1);
+	return ia_css_device_load_uint32(RX_BASE[ID] + reg*sizeof(hrt_data));
 }
 
 STORAGE_CLASS_INPUT_SYSTEM_C void receiver_port_reg_store(
@@ -67,12 +67,12 @@ STORAGE_CLASS_INPUT_SYSTEM_C void receiver_port_reg_store(
 	const hrt_address			reg,
 	const hrt_data				value)
 {
-assert(ID < N_RX_ID);
-assert(port_ID < N_MIPI_PORT_ID);
-assert(RX_BASE[ID] != (hrt_address)-1);
-assert(MIPI_PORT_OFFSET[port_ID] != (hrt_address)-1);
+	assert(ID < N_RX_ID);
+	assert(port_ID < N_MIPI_PORT_ID);
+	assert(RX_BASE[ID] != (hrt_address)-1);
+	assert(MIPI_PORT_OFFSET[port_ID] != (hrt_address)-1);
 	ia_css_device_store_uint32(RX_BASE[ID] + MIPI_PORT_OFFSET[port_ID] + reg*sizeof(hrt_data), value);
-return;
+	return;
 }
 
 STORAGE_CLASS_INPUT_SYSTEM_C hrt_data receiver_port_reg_load(
@@ -80,11 +80,11 @@ STORAGE_CLASS_INPUT_SYSTEM_C hrt_data receiver_port_reg_load(
 	const mipi_port_ID_t			port_ID,
 	const hrt_address			reg)
 {
-assert(ID < N_RX_ID);
-assert(port_ID < N_MIPI_PORT_ID);
-assert(RX_BASE[ID] != (hrt_address)-1);
-assert(MIPI_PORT_OFFSET[port_ID] != (hrt_address)-1);
-return ia_css_device_load_uint32(RX_BASE[ID] + MIPI_PORT_OFFSET[port_ID] + reg*sizeof(hrt_data));
+	assert(ID < N_RX_ID);
+	assert(port_ID < N_MIPI_PORT_ID);
+	assert(RX_BASE[ID] != (hrt_address)-1);
+	assert(MIPI_PORT_OFFSET[port_ID] != (hrt_address)-1);
+	return ia_css_device_load_uint32(RX_BASE[ID] + MIPI_PORT_OFFSET[port_ID] + reg*sizeof(hrt_data));
 }
 
 STORAGE_CLASS_INPUT_SYSTEM_C void input_system_sub_system_reg_store(
@@ -93,12 +93,12 @@ STORAGE_CLASS_INPUT_SYSTEM_C void input_system_sub_system_reg_store(
 	const hrt_address			reg,
 	const hrt_data				value)
 {
-assert(ID < N_INPUT_SYSTEM_ID);
-assert(sub_ID < N_SUB_SYSTEM_ID);
-assert(INPUT_SYSTEM_BASE[ID] != (hrt_address)-1);
-assert(SUB_SYSTEM_OFFSET[sub_ID] != (hrt_address)-1);
+	assert(ID < N_INPUT_SYSTEM_ID);
+	assert(sub_ID < N_SUB_SYSTEM_ID);
+	assert(INPUT_SYSTEM_BASE[ID] != (hrt_address)-1);
+	assert(SUB_SYSTEM_OFFSET[sub_ID] != (hrt_address)-1);
 	ia_css_device_store_uint32(INPUT_SYSTEM_BASE[ID] + SUB_SYSTEM_OFFSET[sub_ID] + reg*sizeof(hrt_data), value);
-return;
+	return;
 }
 
 STORAGE_CLASS_INPUT_SYSTEM_C hrt_data input_system_sub_system_reg_load(
@@ -106,11 +106,11 @@ STORAGE_CLASS_INPUT_SYSTEM_C hrt_data input_system_sub_system_reg_load(
 	const sub_system_ID_t			sub_ID,
 	const hrt_address			reg)
 {
-assert(ID < N_INPUT_SYSTEM_ID);
-assert(sub_ID < N_SUB_SYSTEM_ID);
-assert(INPUT_SYSTEM_BASE[ID] != (hrt_address)-1);
-assert(SUB_SYSTEM_OFFSET[sub_ID] != (hrt_address)-1);
-return ia_css_device_load_uint32(INPUT_SYSTEM_BASE[ID] + SUB_SYSTEM_OFFSET[sub_ID] + reg*sizeof(hrt_data));
+	assert(ID < N_INPUT_SYSTEM_ID);
+	assert(sub_ID < N_SUB_SYSTEM_ID);
+	assert(INPUT_SYSTEM_BASE[ID] != (hrt_address)-1);
+	assert(SUB_SYSTEM_OFFSET[sub_ID] != (hrt_address)-1);
+	return ia_css_device_load_uint32(INPUT_SYSTEM_BASE[ID] + SUB_SYSTEM_OFFSET[sub_ID] + reg*sizeof(hrt_data));
 }
 
 #endif /* __INPUT_SYSTEM_PRIVATE_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq.c
index 6b58bc13dc1b..a42dad69cb3c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq.c
@@ -69,7 +69,7 @@ void irq_clear_all(
 
 	irq_reg_store(ID,
 		_HRT_IRQ_CONTROLLER_CLEAR_REG_IDX, mask);
-return;
+	return;
 }
 
 /*
@@ -114,7 +114,7 @@ void irq_enable_channel(
 
 	irq_wait_for_write_complete(ID);
 
-return;
+	return;
 }
 
 void irq_enable_pulse(
@@ -129,7 +129,7 @@ void irq_enable_pulse(
 	/* output is given as edge, not pulse */
 	irq_reg_store(ID,
 		_HRT_IRQ_CONTROLLER_EDGE_NOT_PULSE_REG_IDX, edge_out);
-return;
+	return;
 }
 
 void irq_disable_channel(
@@ -160,7 +160,7 @@ void irq_disable_channel(
 
 	irq_wait_for_write_complete(ID);
 
-return;
+	return;
 }
 
 enum hrt_isp_css_irq_status irq_get_channel_id(
@@ -195,7 +195,7 @@ enum hrt_isp_css_irq_status irq_get_channel_id(
 	if (irq_id != NULL)
 		*irq_id = (unsigned int)idx;
 
-return status;
+	return status;
 }
 
 static const hrt_address IRQ_REQUEST_ADDR[N_IRQ_SW_CHANNEL_ID] = {
@@ -220,7 +220,7 @@ void irq_raise(
 		(unsigned int)addr, 1);
 	gp_device_reg_store(GP_DEVICE0_ID,
 		(unsigned int)addr, 0);
-return;
+	return;
 }
 
 void irq_controller_get_state(
@@ -240,7 +240,7 @@ void irq_controller_get_state(
 		_HRT_IRQ_CONTROLLER_ENABLE_REG_IDX);
 	state->irq_level_not_pulse = irq_reg_load(ID,
 		_HRT_IRQ_CONTROLLER_EDGE_NOT_PULSE_REG_IDX);
-return;
+	return;
 }
 
 bool any_virq_signal(void)
@@ -248,7 +248,7 @@ bool any_virq_signal(void)
 	unsigned int irq_status = irq_reg_load(IRQ0_ID,
 		_HRT_IRQ_CONTROLLER_STATUS_REG_IDX);
 
-return (irq_status != 0);
+	return (irq_status != 0);
 }
 
 void cnd_virq_enable_channel(
@@ -279,7 +279,7 @@ void cnd_virq_enable_channel(
 			irq_disable_channel(IRQ0_ID, IRQ_NESTING_ID[ID]);
 		}
 	}
-return;
+	return;
 }
 
 
@@ -290,7 +290,7 @@ void virq_clear_all(void)
 	for (irq_id = (irq_ID_t)0; irq_id < N_IRQ_ID; irq_id++) {
 		irq_clear_all(irq_id);
 	}
-return;
+	return;
 }
 
 enum hrt_isp_css_irq_status virq_get_channel_signals(
@@ -320,7 +320,7 @@ enum hrt_isp_css_irq_status virq_get_channel_signals(
 		}
 	}
 
-return irq_status;
+	return irq_status;
 }
 
 void virq_clear_info(
@@ -333,7 +333,7 @@ void virq_clear_info(
 	for (ID = (irq_ID_t)0 ; ID < N_IRQ_ID; ID++) {
 			irq_info->irq_status_reg[ID] = 0;
 	}
-return;
+	return;
 }
 
 enum hrt_isp_css_irq_status virq_get_channel_id(
@@ -403,7 +403,7 @@ enum hrt_isp_css_irq_status virq_get_channel_id(
 	if (irq_id != NULL)
 		*irq_id = (virq_id_t)idx;
 
-return status;
+	return status;
 }
 
 STORAGE_CLASS_INLINE void irq_wait_for_write_complete(
@@ -425,7 +425,7 @@ STORAGE_CLASS_INLINE bool any_irq_channel_enabled(
 	en_reg = irq_reg_load(ID,
 		_HRT_IRQ_CONTROLLER_ENABLE_REG_IDX);
 
-return (en_reg != 0);
+	return (en_reg != 0);
 }
 
 STORAGE_CLASS_INLINE irq_ID_t virq_get_irq_id(
@@ -444,5 +444,5 @@ STORAGE_CLASS_INLINE irq_ID_t virq_get_irq_id(
 
 	*channel_ID = (unsigned int)irq_ID - IRQ_N_ID_OFFSET[ID];
 
-return ID;
+	return ID;
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq_private.h
index eb325e870e88..23a13ac696c2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq_private.h
@@ -26,19 +26,19 @@ STORAGE_CLASS_IRQ_C void irq_reg_store(
 	const unsigned int	reg,
 	const hrt_data		value)
 {
-assert(ID < N_IRQ_ID);
-assert(IRQ_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_IRQ_ID);
+	assert(IRQ_BASE[ID] != (hrt_address)-1);
 	ia_css_device_store_uint32(IRQ_BASE[ID] + reg*sizeof(hrt_data), value);
-return;
+	return;
 }
 
 STORAGE_CLASS_IRQ_C hrt_data irq_reg_load(
 	const irq_ID_t		ID,
 	const unsigned int	reg)
 {
-assert(ID < N_IRQ_ID);
-assert(IRQ_BASE[ID] != (hrt_address)-1);
-return ia_css_device_load_uint32(IRQ_BASE[ID] + reg*sizeof(hrt_data));
+	assert(ID < N_IRQ_ID);
+	assert(IRQ_BASE[ID] != (hrt_address)-1);
+	return ia_css_device_load_uint32(IRQ_BASE[ID] + reg*sizeof(hrt_data));
 }
 
 #endif /* __IRQ_PRIVATE_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp.c
index 47c21e486c25..531c932a48f5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/isp.c
@@ -34,7 +34,7 @@ void cnd_isp_irq_enable(
 		isp_ctrl_clearbit(ID, ISP_IRQ_READY_REG,
 			ISP_IRQ_READY_BIT);
 	}
-return;
+	return;
 }
 
 void isp_get_state(
@@ -94,7 +94,7 @@ void isp_get_state(
 		!isp_ctrl_getbit(ID, ISP_ICACHE_MT_SINK_REG,
 			ISP_ICACHE_MT_SINK_BIT);
  */
-return;
+	return;
 }
 
 /* ISP functions to control the ISP state from the host, even in crun. */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu.c
index b75d0f85d524..a28b67eb66ea 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu.c
@@ -24,20 +24,20 @@ void mmu_set_page_table_base_index(
 	const hrt_data		base_index)
 {
 	mmu_reg_store(ID, _HRT_MMU_PAGE_TABLE_BASE_ADDRESS_REG_IDX, base_index);
-return;
+	return;
 }
 
 hrt_data mmu_get_page_table_base_index(
 	const mmu_ID_t		ID)
 {
-return mmu_reg_load(ID, _HRT_MMU_PAGE_TABLE_BASE_ADDRESS_REG_IDX);
+	return mmu_reg_load(ID, _HRT_MMU_PAGE_TABLE_BASE_ADDRESS_REG_IDX);
 }
 
 void mmu_invalidate_cache(
 	const mmu_ID_t		ID)
 {
 	mmu_reg_store(ID, _HRT_MMU_INVALIDATE_TLB_REG_IDX, 1);
-return;
+	return;
 }
 
 void mmu_invalidate_cache_all(void)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h
index 392b6cc24e8f..7377666f6eb7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h
@@ -26,19 +26,19 @@ STORAGE_CLASS_MMU_H void mmu_reg_store(
 	const unsigned int	reg,
 	const hrt_data		value)
 {
-assert(ID < N_MMU_ID);
-assert(MMU_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_MMU_ID);
+	assert(MMU_BASE[ID] != (hrt_address)-1);
 	ia_css_device_store_uint32(MMU_BASE[ID] + reg*sizeof(hrt_data), value);
-return;
+	return;
 }
 
 STORAGE_CLASS_MMU_H hrt_data mmu_reg_load(
 	const mmu_ID_t		ID,
 	const unsigned int	reg)
 {
-assert(ID < N_MMU_ID);
-assert(MMU_BASE[ID] != (hrt_address)-1);
-return ia_css_device_load_uint32(MMU_BASE[ID] + reg*sizeof(hrt_data));
+	assert(ID < N_MMU_ID);
+	assert(MMU_BASE[ID] != (hrt_address)-1);
+	return ia_css_device_load_uint32(MMU_BASE[ID] + reg*sizeof(hrt_data));
 }
 
 #endif /* __MMU_PRIVATE_H_INCLUDED__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_private.h
index e6283bf67ad3..5ea81c0e82d1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/sp_private.h
@@ -26,19 +26,19 @@ STORAGE_CLASS_SP_C void sp_ctrl_store(
 	const hrt_address	reg,
 	const hrt_data		value)
 {
-assert(ID < N_SP_ID);
-assert(SP_CTRL_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_SP_ID);
+	assert(SP_CTRL_BASE[ID] != (hrt_address)-1);
 	ia_css_device_store_uint32(SP_CTRL_BASE[ID] + reg*sizeof(hrt_data), value);
-return;
+	return;
 }
 
 STORAGE_CLASS_SP_C hrt_data sp_ctrl_load(
 	const sp_ID_t		ID,
 	const hrt_address	reg)
 {
-assert(ID < N_SP_ID);
-assert(SP_CTRL_BASE[ID] != (hrt_address)-1);
-return ia_css_device_load_uint32(SP_CTRL_BASE[ID] + reg*sizeof(hrt_data));
+	assert(ID < N_SP_ID);
+	assert(SP_CTRL_BASE[ID] != (hrt_address)-1);
+	return ia_css_device_load_uint32(SP_CTRL_BASE[ID] + reg*sizeof(hrt_data));
 }
 
 STORAGE_CLASS_SP_C bool sp_ctrl_getbit(
@@ -47,7 +47,7 @@ STORAGE_CLASS_SP_C bool sp_ctrl_getbit(
 	const unsigned int	bit)
 {
 	hrt_data val = sp_ctrl_load(ID, reg);
-return (val & (1UL << bit)) != 0;
+	return (val & (1UL << bit)) != 0;
 }
 
 STORAGE_CLASS_SP_C void sp_ctrl_setbit(
@@ -57,7 +57,7 @@ STORAGE_CLASS_SP_C void sp_ctrl_setbit(
 {
 	hrt_data	data = sp_ctrl_load(ID, reg);
 	sp_ctrl_store(ID, reg, (data | (1UL << bit)));
-return;
+	return;
 }
 
 STORAGE_CLASS_SP_C void sp_ctrl_clearbit(
@@ -67,7 +67,7 @@ STORAGE_CLASS_SP_C void sp_ctrl_clearbit(
 {
 	hrt_data	data = sp_ctrl_load(ID, reg);
 	sp_ctrl_store(ID, reg, (data & ~(1UL << bit)));
-return;
+	return;
 }
 
 STORAGE_CLASS_SP_C void sp_dmem_store(
@@ -76,10 +76,10 @@ STORAGE_CLASS_SP_C void sp_dmem_store(
 	const void			*data,
 	const size_t		size)
 {
-assert(ID < N_SP_ID);
-assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_SP_ID);
+	assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	ia_css_device_store(SP_DMEM_BASE[ID] + addr, data, size);
-return;
+	return;
 }
 
 STORAGE_CLASS_SP_C void sp_dmem_load(
@@ -88,10 +88,10 @@ STORAGE_CLASS_SP_C void sp_dmem_load(
 	void				*data,
 	const size_t		size)
 {
-assert(ID < N_SP_ID);
-assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_SP_ID);
+	assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	ia_css_device_load(SP_DMEM_BASE[ID] + addr, data, size);
-return;
+	return;
 }
 
 STORAGE_CLASS_SP_C void sp_dmem_store_uint8(
@@ -99,11 +99,11 @@ STORAGE_CLASS_SP_C void sp_dmem_store_uint8(
 	hrt_address		addr,
 	const uint8_t		data)
 {
-assert(ID < N_SP_ID);
-assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_SP_ID);
+	assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
 	ia_css_device_store_uint8(SP_DMEM_BASE[SP0_ID] + addr, data);
-return;
+	return;
 }
 
 STORAGE_CLASS_SP_C void sp_dmem_store_uint16(
@@ -111,11 +111,11 @@ STORAGE_CLASS_SP_C void sp_dmem_store_uint16(
 	hrt_address		addr,
 	const uint16_t		data)
 {
-assert(ID < N_SP_ID);
-assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_SP_ID);
+	assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
 	ia_css_device_store_uint16(SP_DMEM_BASE[SP0_ID] + addr, data);
-return;
+	return;
 }
 
 STORAGE_CLASS_SP_C void sp_dmem_store_uint32(
@@ -123,19 +123,19 @@ STORAGE_CLASS_SP_C void sp_dmem_store_uint32(
 	hrt_address		addr,
 	const uint32_t		data)
 {
-assert(ID < N_SP_ID);
-assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_SP_ID);
+	assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
 	ia_css_device_store_uint32(SP_DMEM_BASE[SP0_ID] + addr, data);
-return;
+	return;
 }
 
 STORAGE_CLASS_SP_C uint8_t sp_dmem_load_uint8(
 	const sp_ID_t		ID,
 	const hrt_address	addr)
 {
-assert(ID < N_SP_ID);
-assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_SP_ID);
+	assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
 	return ia_css_device_load_uint8(SP_DMEM_BASE[SP0_ID] + addr);
 }
@@ -144,8 +144,8 @@ STORAGE_CLASS_SP_C uint16_t sp_dmem_load_uint16(
 	const sp_ID_t		ID,
 	const hrt_address	addr)
 {
-assert(ID < N_SP_ID);
-assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_SP_ID);
+	assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
 	return ia_css_device_load_uint16(SP_DMEM_BASE[SP0_ID] + addr);
 }
@@ -154,8 +154,8 @@ STORAGE_CLASS_SP_C uint32_t sp_dmem_load_uint32(
 	const sp_ID_t		ID,
 	const hrt_address	addr)
 {
-assert(ID < N_SP_ID);
-assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
+	assert(ID < N_SP_ID);
+	assert(SP_DMEM_BASE[ID] != (hrt_address)-1);
 	(void)ID;
 	return ia_css_device_load_uint32(SP_DMEM_BASE[SP0_ID] + addr);
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_hrt.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_hrt.c
index 0bfebced63af..716d808d56db 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_hrt.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_hrt.c
@@ -80,5 +80,5 @@ enum ia_css_err sh_css_hrt_sp_wait(void)
 		hrt_sleep();
 	}
 
-return IA_CSS_SUCCESS;
+	return IA_CSS_SUCCESS;
 }
diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index ea145bafb880..149f0e1753a1 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -463,7 +463,7 @@ static int capture_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	return 0;
 
-return_bufs:
+	return_bufs:
 	spin_lock_irqsave(&priv->q_lock, flags);
 	list_for_each_entry_safe(buf, tmp, &priv->ready_q, list) {
 		list_del(&buf->list);
-- 
2.13.6
