Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52452 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689Ab1KQKow (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:44:52 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id pAHAimLJ005792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 04:44:50 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RESEND RFC PATCH v4 10/15] davinci: vpfe: add DM365 autofoucus(AF) hardware interface
Date: Thu, 17 Nov 2011 16:14:36 +0530
Message-ID: <1321526681-22574-11-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
References: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add support for autofocus unit of dm365 SoC. The autofocus
register seup, isr and parameter calidation functionality is
implemented as part of this module.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/dm365_af.c |  564 ++++++++++++++++++++++++++++++++
 drivers/media/video/davinci/dm365_af.h |   59 ++++
 include/linux/dm365_af.h               |  203 ++++++++++++
 3 files changed, 826 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/dm365_af.c
 create mode 100644 drivers/media/video/davinci/dm365_af.h
 create mode 100644 include/linux/dm365_af.h

diff --git a/drivers/media/video/davinci/dm365_af.c b/drivers/media/video/davinci/dm365_af.c
new file mode 100644
index 0000000..7d0240e
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_af.c
@@ -0,0 +1,564 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-device.h>
+#include "dm365_a3_hw.h"
+#include "vpss.h"
+#include "vpfe_af.h"
+
+#define DRIVERNAME	"DM365AF"
+
+/*Global structure for device */
+static struct af_device *af_dev_configptr;
+static struct device *afdev;
+
+/* inline function to free reserver pages  */
+inline void af_free_pages(unsigned long addr, unsigned long bufsize)
+{
+	unsigned long tempaddr;
+	unsigned long size;
+
+	tempaddr = addr;
+	if (!addr)
+		return;
+
+	size = PAGE_SIZE << (get_order(bufsize));
+	while (size > 0) {
+		ClearPageReserved(virt_to_page(addr));
+		addr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+	free_pages(tempaddr, get_order(bufsize));
+}
+
+/* Function to check paxel parameters */
+static int af_validate_parameters(void)
+{
+	dev_dbg(afdev, "auto focus validate parameters\n");
+
+	/* Check horizontal Count */
+	if (af_dev_configptr->config->paxel_config.hz_cnt <
+			AF_PAXEL_HORIZONTAL_COUNT_MIN ||
+			af_dev_configptr->config->paxel_config.hz_cnt >
+					AF_PAXEL_HORIZONTAL_COUNT_MAX) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev, "Paxel Horizontal Count is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check Vertical Count */
+	if (af_dev_configptr->config->paxel_config.vt_cnt <
+			AF_PAXEL_VERTICAL_COUNT_MIN ||
+			af_dev_configptr->config->paxel_config.vt_cnt >
+			AF_PAXEL_VERTICAL_COUNT_MAX) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev, "Paxel Vertical Count is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check line increment */
+	if (NOT_EVEN ==
+		CHECK_EVEN(af_dev_configptr->config->paxel_config.line_incr) ||
+		af_dev_configptr->config->paxel_config.line_incr <
+		AF_LINE_INCR_MIN ||
+		af_dev_configptr->config->paxel_config.line_incr >
+			AF_LINE_INCR_MAX) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev, "Paxel Line Increment is incorrect\n");
+		return -EINVAL;
+	}
+	if (af_dev_configptr->config->fv_sel == AF_HFV_AND_VFV && (NOT_EVEN ==
+	      CHECK_EVEN(af_dev_configptr->config->paxel_config.column_incr) ||
+		af_dev_configptr->config->paxel_config.column_incr <
+		AF_COLUMN_INCR_MIN ||
+		af_dev_configptr->config->paxel_config.column_incr >
+				AF_COLUMN_INCR_MAX)) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev, "Paxel Column Increment is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check width */
+	if (NOT_EVEN ==
+		CHECK_EVEN(af_dev_configptr->config->paxel_config.width) ||
+		af_dev_configptr->config->paxel_config.width < AF_WIDTH_MIN ||
+		af_dev_configptr->config->paxel_config.width > AF_WIDTH_MAX) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev, "Paxel Width is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check Height */
+	if (NOT_EVEN ==
+		CHECK_EVEN(af_dev_configptr->config->paxel_config.height) ||
+		af_dev_configptr->config->paxel_config.height < AF_HEIGHT_MIN ||
+		af_dev_configptr->config->paxel_config.height > AF_HEIGHT_MAX) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev, "Paxel Height is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check Horizontal Start */
+	if (NOT_EVEN ==
+		CHECK_EVEN(af_dev_configptr->config->paxel_config.hz_start) ||
+		(af_dev_configptr->config->paxel_config.hz_start <
+		(af_dev_configptr->config->iir_config.hz_start_pos + 2)) ||
+		af_dev_configptr->config->paxel_config.hz_start <
+		AF_HZSTART_MIN ||
+		af_dev_configptr->config->paxel_config.hz_start >
+		AF_HZSTART_MAX) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev, "Paxel horizontal start is  incorrect\n");
+		return -EINVAL;
+	}
+	/* Check Vertical Start */
+	if (af_dev_configptr->config->paxel_config.vt_start < AF_VTSTART_MIN ||
+	    af_dev_configptr->config->paxel_config.vt_start > AF_VTSTART_MAX) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev, "Paxel vertical start is  incorrect\n");
+		return -EINVAL;
+	}
+	/* Check Threshold  */
+	if (af_dev_configptr->config->hmf_config.threshold > AF_MEDTH_MAX &&
+		af_dev_configptr->config->hmf_config.enable == H3A_AF_ENABLE) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev,
+			"Horizontal Median Filter Threshold is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check IIRSH start */
+	if (af_dev_configptr->config->iir_config.hz_start_pos > AF_IIRSH_MAX) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev,
+			"IIR FITLER  horizontal start position incorrect\n");
+		return -EINVAL;
+	}
+	/* Verify ALaw */
+	if (af_dev_configptr->config->alaw_enable < H3A_AF_DISABLE ||
+		af_dev_configptr->config->alaw_enable > H3A_AF_ENABLE) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev, "ALaw Setting is incorrect\n");
+		return -EINVAL;
+	}
+	/* Verify Horizontal Median Filter Setting */
+	if (af_dev_configptr->config->hmf_config.enable < H3A_AF_DISABLE ||
+		af_dev_configptr->config->hmf_config.enable > H3A_AF_ENABLE) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev,
+			"Horizontal Median Filter Setting is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check RGB position if HFV used */
+	if (af_dev_configptr->config->fv_sel == AF_HFV_ONLY &&
+			(af_dev_configptr->config->rgb_pos < GR_GB_BAYER ||
+			af_dev_configptr->config->rgb_pos > RB_GG_CUSTOM)) {
+		dev_err(afdev, "Invalid Parameters\n");
+		dev_err(afdev, "RGB Position Setting is incorrect\n");
+		return -EINVAL;
+	}
+	if (af_dev_configptr->config->fv_sel == AF_HFV_AND_VFV) {
+		/* Check for threshold values */
+		if (af_dev_configptr->config->fir_config.hfv_thr1 >
+			AF_HFV_THR_MAX ||
+			af_dev_configptr->config->fir_config.hfv_thr2 >
+			AF_HFV_THR_MAX) {
+			dev_err(afdev, "Invalid Parameters\n");
+			dev_err(afdev, "HFV FIR 1 or FIR 2 Threshold"
+					" incorrect\n");
+			return -EINVAL;
+		}
+		if (af_dev_configptr->config->fir_config.vfv_thr1 >
+			AF_VFV_THR_MAX ||
+			af_dev_configptr->config->fir_config.vfv_thr2 >
+			AF_VFV_THR_MAX) {
+			dev_err(afdev, "Invalid Parameters\n");
+			dev_err(afdev, "VFV FIR 1 or FIR 2 Threshold"
+				" incorrect\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/* Function to perform hardware set up */
+static int af_hardware_setup(void)
+{
+	unsigned long adr, size;
+	unsigned int busyaf;
+	/* Size for buffer in bytes */
+	int buff_size;
+	int result;
+
+	/* Get the value of PCR register */
+	busyaf = af_get_hw_state();
+	/* If busy bit is 1 then busy lock registers caanot be configured */
+	if (busyaf == 1) {
+		/* Hardware cannot be configure while engine is busy */
+		dev_err(afdev, "AF_register_setup_ERROR : Engine Busy");
+		dev_err(afdev, "\n Configuration cannot be done ");
+		return -EBUSY;
+	}
+	/* Check IIR Coefficient and start Values */
+	result = af_validate_parameters();
+	if (result < 0)
+		return result;
+
+	/* Compute buffer size */
+	if (af_dev_configptr->config->fv_sel == AF_HFV_ONLY)
+		buff_size = (af_dev_configptr->config->paxel_config.hz_cnt) *
+			(af_dev_configptr->config->paxel_config.vt_cnt) *
+			AF_PAXEL_SIZE_HF_ONLY;
+	else
+		buff_size = (af_dev_configptr->config->paxel_config.hz_cnt) *
+			(af_dev_configptr->config->paxel_config.vt_cnt) *
+			AF_PAXEL_SIZE_HF_VF;
+
+	/* Deallocate the previosu buffers free old buffers */
+	if (af_dev_configptr->buff_old)
+		af_free_pages((unsigned long)af_dev_configptr->buff_old,
+			      af_dev_configptr->size_paxel);
+
+	/* Free current buffer */
+	if (af_dev_configptr->buff_curr)
+		af_free_pages((unsigned long)af_dev_configptr->buff_curr,
+			      af_dev_configptr->size_paxel);
+
+	/* Free application buffers */
+	if (af_dev_configptr->buff_app)
+		af_free_pages((unsigned long)af_dev_configptr->buff_app,
+			      af_dev_configptr->size_paxel);
+
+	/*
+	 * Reallocate the buffer as per new paxel configurations
+	 * Allocate memory for old buffer
+	 */
+	af_dev_configptr->buff_old = (void *)__get_free_pages(GFP_KERNEL |
+					  GFP_DMA, get_order(buff_size));
+
+	if (af_dev_configptr->buff_old == NULL)
+		return -ENOMEM;
+
+	/* allocate the memory for storing old statistics */
+	adr = (unsigned long)af_dev_configptr->buff_old;
+	size = PAGE_SIZE << (get_order(buff_size));
+	while (size > 0) {
+		/*
+		 * make sure the frame buffers
+		 * are never swapped out of memory
+		 */
+		SetPageReserved(virt_to_page(adr));
+		adr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+
+	/* Allocate memory for current buffer */
+	af_dev_configptr->buff_curr = (void *)__get_free_pages(GFP_KERNEL |
+					GFP_DMA, get_order(buff_size));
+
+	/* Free the previously allocated buffer */
+	if (af_dev_configptr->buff_curr == NULL) {
+		if (af_dev_configptr->buff_old)
+			af_free_pages((unsigned long)af_dev_configptr->
+				      buff_old, buff_size);
+		return -ENOMEM;
+	}
+
+	adr = (unsigned long)af_dev_configptr->buff_curr;
+	size = PAGE_SIZE << (get_order(buff_size));
+	while (size > 0) {
+		/*
+		 * make sure the frame buffers
+		 * are never swapped out of memory
+		 */
+		SetPageReserved(virt_to_page(adr));
+		adr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+
+	/* Allocate memory for old buffer */
+	af_dev_configptr->buff_app = (void *)__get_free_pages(GFP_KERNEL |
+				    GFP_DMA, get_order(buff_size));
+
+	if (af_dev_configptr->buff_app == NULL) {
+		/* Free the previously allocated buffer */
+		if (af_dev_configptr->buff_curr)
+			af_free_pages((unsigned long)af_dev_configptr->
+				      buff_curr, buff_size);
+		/* Free the previously allocated buffer */
+		if (af_dev_configptr->buff_old)
+			af_free_pages((unsigned long)af_dev_configptr->
+				      buff_old, buff_size);
+		return -ENOMEM;
+	}
+
+	adr = (unsigned long)af_dev_configptr->buff_app;
+	size = PAGE_SIZE << (get_order(buff_size));
+	while (size > 0) {
+		/*
+		 * make sure the frame buffers
+		 * are never swapped out of memory
+		 */
+		SetPageReserved(virt_to_page(adr));
+		adr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+
+	result = af_register_setup(afdev, af_dev_configptr);
+	if (result < 0)
+		return result;
+	af_dev_configptr->size_paxel = buff_size;
+	/* Set configuration flag to indicate HW setup done */
+	af_dev_configptr->af_config = H3A_AF_CONFIG;
+
+	return 0;
+}
+
+int af_open(void)
+{
+	/* Return if device is in use */
+	if (af_dev_configptr->in_use == AF_IN_USE)
+		return -EBUSY;
+	af_dev_configptr->config = NULL;
+
+	/* Allocate memory for Device Structure */
+	af_dev_configptr->config = kmalloc(sizeof(struct af_configuration)
+						, GFP_KERNEL);
+	if (af_dev_configptr->config == NULL) {
+		dev_err(afdev, "Error : Kmalloc fail\n");
+		return -ENOMEM;
+	}
+	/* Driver is in use */
+	af_dev_configptr->in_use = AF_IN_USE;
+	/* Hardware is not set up */
+	af_dev_configptr->af_config = H3A_AF_CONFIG_NOT_DONE;
+	/* No statistics are available */
+	af_dev_configptr->buffer_filled = 0;
+
+	return 0;
+}
+
+int af_release(void)
+{
+	af_engine_setup(afdev, 0);
+	/* free current buffer */
+	if (af_dev_configptr->buff_curr)
+		af_free_pages((unsigned long)af_dev_configptr->buff_curr,
+			      af_dev_configptr->size_paxel);
+
+	/* Free old buffer */
+	if (af_dev_configptr->buff_old)
+		af_free_pages((unsigned long)af_dev_configptr->buff_old,
+			      af_dev_configptr->size_paxel);
+
+	/* Free application buffer */
+	if (af_dev_configptr->buff_app)
+		af_free_pages((unsigned long)af_dev_configptr->buff_app,
+			      af_dev_configptr->size_paxel);
+
+	/* Release memory for configuration structure of this channel */
+	af_dev_configptr->buff_curr = NULL;
+	af_dev_configptr->buff_old = NULL;
+	af_dev_configptr->buff_app = NULL;
+	kfree(af_dev_configptr->config);
+	af_dev_configptr->config = NULL;
+	/* Device is not in use */
+	af_dev_configptr->in_use = AF_NOT_IN_USE;
+
+	return 0;
+}
+
+/*
+ * This function will process IOCTL commands sent by the application and
+ * control the device IO operations.
+ */
+int af_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct af_configuration afconfig = *(af_dev_configptr->config);
+	struct af_statdata *stat_data = (struct af_statdata *)arg;
+	void *buff_temp;
+	int result;
+
+	switch (cmd) {
+
+		/*
+		 * This ioctl is used to perform hardware
+		 * set up for AF Engine. It will configure all the registers.
+		 */
+	case AF_S_PARAM:
+		memcpy(af_dev_configptr->config, (struct af_configuration *)arg,
+					sizeof(struct af_configuration));
+
+		/* Call AF_hardware_setup to perform register configuration */
+		result = af_hardware_setup();
+		if (!result) {
+			/*
+			 * Hardware Set up is successful
+			 * Return the no of bytes required for buffer
+			 */
+			result = af_dev_configptr->size_paxel;
+		} else {
+			dev_err(afdev, "Error : AF_S_PARAM failed\n");
+			/* Change Configuration Structure to original */
+			*(af_dev_configptr->config) = afconfig;
+		}
+		break;
+
+		/* This ioctl will get the paramters from application */
+	case AF_G_PARAM:
+		/* Check if Hardware is configured or not */
+		if (af_dev_configptr->af_config == H3A_AF_CONFIG) {
+			memcpy((struct af_configuration *)arg,
+					 af_dev_configptr->config,
+					 sizeof(struct af_configuration));
+			result = af_dev_configptr->size_paxel;
+		} else {
+			dev_dbg(afdev, "Error : AF Hardware not configured.\n");
+			result = -EINVAL;
+		}
+
+		break;
+
+	case AF_GET_STAT:
+		/* Implement the read  functionality */
+		if (af_dev_configptr->buffer_filled != 1)
+			return -EINVAL;
+
+		if (stat_data->buf_length < af_dev_configptr->size_paxel)
+			return -EINVAL;
+
+		disable_irq(3);
+		af_dev_configptr->buffer_filled = 0;
+		/* Swap application buffer and old buffer */
+		buff_temp = af_dev_configptr->buff_old;
+		af_dev_configptr->buff_old = af_dev_configptr->buff_app;
+		af_dev_configptr->buff_app = buff_temp;
+		/* Enable the interrupts  once swapping is done */
+		enable_irq(3);
+		/*
+		* Copy the entire statistics located in application
+		* buffer to user space
+		*/
+		memcpy(stat_data->buffer, af_dev_configptr->buff_app,
+				 af_dev_configptr->size_paxel);
+		result = af_dev_configptr->size_paxel;
+
+		break;
+	default:
+		dev_err(afdev, "Error : Invalid IOCTL!\n");
+		result = -ENOTTY;
+		break;
+	}
+
+	return result;
+}
+
+/* This function will handle the H3A interrupt. */
+static irqreturn_t af_isr(int irq, void *dev_id)
+{
+	struct v4l2_subdev *sd = dev_id;
+	void *buff_temp;
+	int enaf;
+
+	/* Get the value of PCR register */
+	enaf = af_get_enable();
+
+	/* If AF Engine has enabled, interrupt is not for AF */
+	if (!enaf || !af_dev_configptr)
+		return IRQ_RETVAL(IRQ_NONE);
+
+	/*
+	 * Service  the Interrupt.  Set buffer filled flag to indicate
+	 * statistics are available. Swap current buffer and old buffer
+	 */
+	buff_temp = af_dev_configptr->buff_curr;
+	af_dev_configptr->buff_curr = af_dev_configptr->buff_old;
+	af_dev_configptr->buff_old = buff_temp;
+
+	/* Set AF Buf st to current register address */
+	if (af_dev_configptr->buff_curr)
+		af_set_address(afdev,
+		  (unsigned long)virt_to_phys(af_dev_configptr->buff_curr));
+
+	/* Wake up read as new statistics are available */
+	af_dev_configptr->buffer_filled = 1;
+
+	/* queue the event with v4l2 */
+	af_queue_event(sd);
+
+	return IRQ_RETVAL(IRQ_HANDLED);
+
+}
+
+int af_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	int result;
+
+	if (!enable) {
+		/* stop capture */
+		free_irq(3, sd);
+		/* Disable AEW Engine */
+		af_engine_setup(afdev, 0);
+		return 0;
+	}
+	/* start capture */
+	/* Enable AEW Engine if Hardware set up is done */
+	if (af_dev_configptr->af_config == H3A_AF_CONFIG_NOT_DONE) {
+		dev_err(afdev, "Error : AF Hardware is not configured.\n");
+		return -EINVAL;
+	}
+	result = request_irq(3, af_isr, IRQF_SHARED, "dm365_h3a_af",
+						(void *)sd);
+	if (result != 0)
+		return result;
+
+	/* Enable AF Engine */
+	af_engine_setup(afdev, 1);
+
+	return 0;
+}
+
+int af_init(struct platform_device *pdev)
+{
+	/* allocate memory for device structure and initialize it with 0 */
+	af_dev_configptr = kmalloc(sizeof(struct af_device), GFP_KERNEL);
+	if (!af_dev_configptr) {
+		printk(KERN_ERR "af_init: Error : kmalloc fail\n");
+		return -ENOMEM;
+	}
+
+	/* Initialize device structure */
+	memset((unsigned char *)af_dev_configptr, 0, sizeof(struct af_device));
+	af_dev_configptr->in_use = AF_NOT_IN_USE;
+	af_dev_configptr->buffer_filled = 0;
+	afdev = &pdev->dev;
+
+	return 0;
+}
+
+void af_cleanup(void)
+{
+	/* in use */
+	if (af_dev_configptr->in_use == AF_IN_USE) {
+		printk(KERN_ERR "Error : dm365_af in use.");
+		return;
+	}
+	/* Free device structure */
+	kfree(af_dev_configptr);
+	af_dev_configptr = NULL;
+}
diff --git a/drivers/media/video/davinci/dm365_af.h b/drivers/media/video/davinci/dm365_af.h
new file mode 100644
index 0000000..0483a92
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_af.h
@@ -0,0 +1,59 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+#ifndef AF_DM365_DRIVER_H
+#define AF_DM365_DRIVER_H
+
+#include <linux/ioctl.h>
+#include <linux/wait.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/dm365_af.h>
+
+/* Device Constants */
+#define AF_MAJOR_NUMBER			0
+#define AF_NR_DEVS			1
+#define AF_TIMEOUT			((300 * HZ) / 1000)
+
+/* Structure for device of AF Engine */
+struct af_device {
+	/* Driver usage counter */
+	enum af_in_use_flag in_use;
+	/* Device configuration structure */
+	struct af_configuration *config;
+	/* Contains the latest statistics */
+	void *buff_old;
+	/* Buffer in which HW will fill the statistics or HW is already
+	 * filling statistics
+	 */
+	void *buff_curr;
+	/* Buffer which will be passed to */
+	void *buff_app;
+	/* user space on read call Size of image buffer */
+	unsigned int buff_size;
+	/* Flag indicates */
+	int buffer_filled;
+	/* statistics are available Paxel size in bytes */
+	int size_paxel;
+	/* Wait queue for driver */
+	wait_queue_head_t af_wait_queue;
+	/* mutex for driver */
+	struct mutex read_blocked;
+	/* Flag indicates Engine is configured */
+	enum af_config_flag af_config;
+};
+
+#endif				/* AF_DM365_DRIVER_H */
diff --git a/include/linux/dm365_af.h b/include/linux/dm365_af.h
new file mode 100644
index 0000000..43385cf
--- /dev/null
+++ b/include/linux/dm365_af.h
@@ -0,0 +1,203 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+
+#ifndef _DM365_AF_INCLUDE_H
+#define _DM365_AF_INCLUDE_H
+
+/* Range Constants */
+
+#define AF_PAXEL_HORIZONTAL_COUNT_MIN	1
+#define AF_PAXEL_HORIZONTAL_COUNT_MAX	36
+
+#define AF_PAXEL_VERTICAL_COUNT_MIN	1
+#define AF_PAXEL_VERTICAL_COUNT_MAX	128
+
+#define AF_PAXEL_HF_VF_COUNT_MAX	12
+#define AF_PAXEL_HF_VF_COUNT_MIN	1
+
+#define AF_WIDTH_MIN			8
+#define AF_WIDTH_MAX			512
+
+#define AF_LINE_INCR_MIN		2
+#define AF_LINE_INCR_MAX		32
+
+#define AF_COLUMN_INCR_MIN		2
+#define AF_COLUMN_INCR_MAX		32
+
+#define AF_HEIGHT_MIN			2
+#define AF_HEIGHT_MAX			512
+
+#define AF_HZSTART_MIN			2
+#define AF_HZSTART_MAX			4094
+
+#define AF_VTSTART_MIN			0
+#define AF_VTSTART_MAX			4095
+
+#define AF_MEDTH_MAX			255
+
+#define AF_IIRSH_MAX			4094
+
+/* Statistics data size per paxel */
+#define AF_PAXEL_SIZE_HF_ONLY		48
+#define AF_PAXEL_SIZE_HF_VF		64
+
+#define AF_NUMBER_OF_HFV_COEF		11
+#define AF_NUMBER_OF_VFV_COEF		5
+#define AF_HFV_COEF_MASK		0xfff
+#define AF_VFV_COEF_MASK		0xff
+#define AF_HFV_THR_MAX			0xffff
+#define AF_VFV_THR_MAX			0xffff
+
+/* list of ioctls */
+#define  AF_IOC_MAXNR			5
+#define  AF_MAGIC_NO			'a'
+#define  AF_S_PARAM	_IOWR(AF_MAGIC_NO, 1, struct af_configuration)
+#define  AF_G_PARAM	_IOWR(AF_MAGIC_NO, 2, struct af_configuration)
+#define  AF_GET_STAT	_IOWR(AF_MAGIC_NO, 3, struct af_statdata)
+
+/* enum used for status of specific feature */
+enum af_enable_flag {
+	H3A_AF_DISABLE,
+	H3A_AF_ENABLE
+};
+
+enum af_config_flag {
+	H3A_AF_CONFIG_NOT_DONE,
+	H3A_AF_CONFIG
+};
+
+struct af_reg_dump {
+	unsigned int addr;
+	unsigned int val;
+};
+
+/* enum used for keep track of whether hardware is used */
+enum af_in_use_flag {
+	AF_NOT_IN_USE,
+	AF_IN_USE
+};
+
+enum af_mode {
+	ACCUMULATOR_SUMMED,
+	ACCUMULATOR_PEAK
+};
+
+/* Focus value selection */
+enum af_focus_val_sel {
+	/* 4 color Horizontal focus value only */
+	AF_HFV_ONLY,
+	/* 1 color Horizontal focus value & 1 color Vertical focus vlaue */
+	AF_HFV_AND_VFV
+};
+
+
+/* Red, Green, and blue pixel location in the AF windows */
+enum rgbpos {
+	/* GR and GB as Bayer pattern */
+	GR_GB_BAYER,
+	/* RG and GB as Bayer pattern */
+	RG_GB_BAYER,
+	/* GR and BG as Bayer pattern */
+	GR_BG_BAYER,
+	/* RG and BG as Bayer pattern */
+	RG_BG_BAYER,
+	/* GG and RB as custom pattern */
+	GG_RB_CUSTOM,
+	/* RB and GG as custom pattern */
+	RB_GG_CUSTOM
+};
+
+/* Contains the information regarding the Horizontal Median Filter */
+struct af_hmf {
+	/* Status of Horizontal Median Filter */
+	enum af_enable_flag enable;
+	/* Threshhold Value for Horizontal Median Filter */
+	unsigned int threshold;
+};
+
+/* Contains the information regarding the IIR Filters */
+struct af_iir {
+	/* IIR Start Register Value */
+	unsigned int hz_start_pos;
+	/* IIR Filter Coefficient for Set 0 */
+	int coeff_set0[AF_NUMBER_OF_HFV_COEF];
+	/* IIR Filter Coefficient for Set 1 */
+	int coeff_set1[AF_NUMBER_OF_HFV_COEF];
+};
+
+/* Contains the information regarding the VFV FIR filters */
+struct af_fir {
+	/* FIR 1 coefficents */
+	int coeff_1[AF_NUMBER_OF_VFV_COEF];
+	/* FIR 2 coefficents */
+	int coeff_2[AF_NUMBER_OF_VFV_COEF];
+	/* Horizontal FV threshold for FIR 1 */
+	unsigned int hfv_thr1;
+	/* Horizontal FV threshold for FIR 2 */
+	unsigned int hfv_thr2;
+	/* Vertical FV threshold for FIR 1 */
+	unsigned int vfv_thr1;
+	/* Vertical FV threshold for FIR 2 */
+	unsigned int vfv_thr2;
+};
+/* Contains the information regarding the Paxels Structure in AF Engine */
+struct af_paxel {
+	/* Width of the Paxel */
+	unsigned int width;
+	/* Height of the Paxel */
+	unsigned int height;
+	/* Horizontal Start Position */
+	unsigned int hz_start;
+	/* Vertical Start Position */
+	unsigned int vt_start;
+	/* Horizontal Count */
+	unsigned int hz_cnt;
+	/* Vertical Count */
+	unsigned int vt_cnt;
+	/* Line Increment */
+	unsigned int line_incr;
+	/* Column Increment. Only for VFV */
+	unsigned int column_incr;
+};
+
+
+/* Contains the parameters required for hardware set up of AF Engine */
+struct af_configuration {
+	/* ALAW status */
+	enum af_enable_flag alaw_enable;
+	/* Focus value selection */
+	enum af_focus_val_sel fv_sel;
+	/* HMF configurations */
+	struct af_hmf hmf_config;
+	/* RGB Positions. Only applicable with AF_HFV_ONLY selection */
+	enum rgbpos rgb_pos;
+	/* IIR filter configurations */
+	struct af_iir iir_config;
+	/* FIR filter configuration */
+	struct af_fir fir_config;
+	/* Paxel parameters */
+	struct af_paxel paxel_config;
+	/* Accumulator mode */
+	enum af_mode mode;
+};
+
+struct af_statdata {
+	void *buffer;
+	int buf_length;
+};
+
+#endif
-- 
1.6.2.4

