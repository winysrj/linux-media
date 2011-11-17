Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52451 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab1KQKow (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:44:52 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id pAHAimNv005793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 04:44:50 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RESEND RFC PATCH v4 12/15] davinci: vpfe: add hardware interface for dm365 aew
Date: Thu, 17 Nov 2011 16:14:38 +0530
Message-ID: <1321526681-22574-13-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
References: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add the hardware functionality for enablling the dm365
auto exposure and white balance unit. The module supports
hardware setup, isr management, and parameter validation.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/dm365_a3_hw.c |  387 ++++++++++++++++++++
 drivers/media/video/davinci/dm365_a3_hw.h |  253 +++++++++++++
 drivers/media/video/davinci/dm365_aew.c   |  544 +++++++++++++++++++++++++++++
 drivers/media/video/davinci/dm365_aew.h   |   55 +++
 include/linux/dm365_aew.h                 |  153 ++++++++
 5 files changed, 1392 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/dm365_a3_hw.c
 create mode 100644 drivers/media/video/davinci/dm365_a3_hw.h
 create mode 100644 drivers/media/video/davinci/dm365_aew.c
 create mode 100644 drivers/media/video/davinci/dm365_aew.h
 create mode 100644 include/linux/dm365_aew.h

diff --git a/drivers/media/video/davinci/dm365_a3_hw.c b/drivers/media/video/davinci/dm365_a3_hw.c
new file mode 100644
index 0000000..b929c22
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_a3_hw.c
@@ -0,0 +1,387 @@
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
+#include "dm365_af.h"
+#include "dm365_aew.h"
+#include "dm365_a3_hw.h"
+
+/* 3A hardware module configuration */
+struct a3_config {
+	/* lock for write protection */
+	struct mutex lock;
+	/* base address */
+	void __iomem *base;
+};
+
+/* H3A module configuration */
+static struct a3_config a3_cfg;
+
+/* register access routines */
+static inline u32 regr(unsigned int offset)
+{
+	return __raw_readl(a3_cfg.base + offset);
+}
+
+static inline u32 regw(u32 val, unsigned int offset)
+{
+	__raw_writel(val, (a3_cfg.base + offset));
+
+	return val;
+}
+
+/* Function to set register */
+int af_register_setup(struct device *dev, struct af_device *af_dev)
+{
+	unsigned int address;
+	unsigned int utemp;
+	int index;
+
+	/* Lock resource since this register is written by
+	 * both the AF and AEW drivers
+	 */
+	mutex_lock(&a3_cfg.lock);
+	/* Configure Hardware Registers */
+	/* Set PCR Register */
+	utemp = regr(AFPCR);	/* Read PCR Register */
+
+	/*Set Accumulator Mode */
+	utemp &= ~FVMODE;
+	if (af_dev->config->mode == ACCUMULATOR_PEAK)
+		utemp |= FVMODE;
+	/* Set A-law */
+	utemp &= ~AF_ALAW_EN;
+	if (af_dev->config->alaw_enable == H3A_AF_ENABLE)
+		utemp |= AF_ALAW_EN;
+
+	/* Set HFV only or HFV and VFV */
+	utemp &= ~AF_VF_EN;
+	if (af_dev->config->fv_sel == AF_HFV_AND_VFV)
+		utemp |= AF_VF_EN;
+	/* Set RGB Position */
+	utemp &= ~RGBPOS;
+	utemp |= (af_dev->config->rgb_pos) << AF_RGBPOS_SHIFT;
+
+	utemp &= ~AF_MED_EN;
+	/*HMF Configurations */
+	if (af_dev->config->hmf_config.enable == H3A_AF_ENABLE) {
+		/* Enable HMF */
+		utemp |= AF_MED_EN;
+		/* Set Median Threshold */
+		utemp &= ~MED_TH;
+		utemp |= (af_dev->config->hmf_config.threshold <<
+				AF_MED_TH_SHIFT) & MED_TH;
+	}
+	/* Set PCR Register */
+	regw(utemp , AFPCR);
+	mutex_unlock(&a3_cfg.lock);
+
+	/* Configure AFPAX1 */
+	/*Paxel parameter configuration */
+	/*Set Width in AFPAX1 Register */
+	utemp = SET_VAL(af_dev->config->paxel_config.width) << AF_PAXW_SHIFT;
+
+	/* Set height in AFPAX1 */
+	utemp &= ~PAXH;
+	utemp |= SET_VAL(af_dev->config->paxel_config.height);
+	regw(utemp , AFPAX1);
+	/* Configure AFPAX2 Register */
+	/* Set Column Increment in AFPAX2 Register */
+	utemp = 0;
+	utemp &= ~AFINCH;
+	utemp |= SET_VAL(af_dev->config->paxel_config.column_incr) <<
+			AF_COLUMN_INCR_SHIFT;
+
+	/* Set Line Increment in AFPAX2 Register */
+	utemp &= ~AFINCV;
+	utemp |= SET_VAL(af_dev->config->paxel_config.line_incr) <<
+			AF_LINE_INCR_SHIFT;
+
+	/* Set Vertical Count */
+	utemp &= ~PAXVC;
+	utemp |= (af_dev->config->paxel_config.vt_cnt - 1) << AF_VT_COUNT_SHIFT;
+	/* Set Horizontal Count */
+	utemp &= ~PAXHC;
+	utemp |= af_dev->config->paxel_config.hz_cnt - 1;
+	regw(utemp, AFPAX2);
+
+	/* Configure PAXSTART Register */
+	/*Configure Horizontal Start */
+	utemp = 0;
+	utemp &= ~PAXSH;
+	utemp |= af_dev->config->paxel_config.hz_start << AF_HZ_START_SHIFT;
+	/* Configure Vertical Start */
+	utemp &= ~PAXSV;
+	utemp |= af_dev->config->paxel_config.vt_start;
+	regw(utemp , AFPAXSTART);
+
+	/*SetIIRSH Register */
+	regw(af_dev->config->iir_config.hz_start_pos, AFIIRSH);
+
+	/* Set IIR Filter0 Coefficients */
+	address = AFCOEF010;
+	for (index = 0; index < AF_NUMBER_OF_HFV_COEF; index += 2) {
+		utemp = af_dev->config->iir_config.coeff_set0[index] &
+			COEF_MASK0;
+		if (index < AF_NUMBER_OF_HFV_COEF - 1) {
+			utemp |= (af_dev->config->iir_config.
+			coeff_set0[index + 1] << AF_COEF_SHIFT) & COEF_MASK1;
+		}
+		regw(utemp, address);
+		dev_dbg(dev, "COEF0 %x\n", regr(address));
+		address = address + AF_OFFSET;
+	}
+
+	/* Set IIR Filter1 Coefficients */
+	address = AFCOEF110;
+	for (index = 0; index < AF_NUMBER_OF_HFV_COEF; index += 2) {
+		utemp = af_dev->config->iir_config.coeff_set1[index] &
+					COEF_MASK0;
+		if (index < AF_NUMBER_OF_HFV_COEF-1) {
+			utemp |= (af_dev->config->iir_config.
+			coeff_set1[index + 1] << AF_COEF_SHIFT) & COEF_MASK1;
+		}
+		regw(utemp, address);
+		dev_dbg(dev, "COEF0 %x\n", regr(address));
+		address = address + AF_OFFSET;
+	}
+
+	/* HFV thresholds for FIR 1 & 2 */
+	utemp = af_dev->config->fir_config.hfv_thr1 & HFV_THR0_MASK;
+	utemp |= (af_dev->config->fir_config.hfv_thr2 << HFV_THR2_SHIFT) &
+			HFV_THR2_MASK;
+	regw(utemp, AF_HFV_THR);
+
+	/* VFV coefficients and thresholds */
+	utemp = af_dev->config->fir_config.coeff_1[0] & VFV_COEF_MASK0;
+	utemp |= (af_dev->config->fir_config.coeff_1[1] << 8) & VFV_COEF_MASK1;
+	utemp |= (af_dev->config->fir_config.coeff_1[2] << 16) & VFV_COEF_MASK2;
+	utemp |= (af_dev->config->fir_config.coeff_1[3] << 24) & VFV_COEF_MASK3;
+	regw(utemp, AF_VFV_CFG1);
+
+	utemp = af_dev->config->fir_config.coeff_1[4] & VFV_COEF_MASK0;
+	utemp |= (af_dev->config->fir_config.vfv_thr1 << VFV_THR_SHIFT) &
+				VFV_THR_MASK;
+	regw(utemp, AF_VFV_CFG2);
+
+	/* VFV coefficients and thresholds */
+	utemp = af_dev->config->fir_config.coeff_2[0] & VFV_COEF_MASK0;
+	utemp |= (af_dev->config->fir_config.coeff_2[1] << 8) & VFV_COEF_MASK1;
+	utemp |= (af_dev->config->fir_config.coeff_2[2] << 16) & VFV_COEF_MASK2;
+	utemp |= (af_dev->config->fir_config.coeff_2[3] << 24) & VFV_COEF_MASK3;
+	regw(utemp, AF_VFV_CFG3);
+
+	utemp = af_dev->config->fir_config.coeff_2[4] & VFV_COEF_MASK0;
+	utemp |= (af_dev->config->fir_config.vfv_thr2 << VFV_THR_SHIFT) &
+			VFV_THR_MASK;
+	regw(utemp, AF_VFV_CFG4);
+	/* Set AFBUFST to Current buffer Physical Address */
+	regw((unsigned int)(virt_to_phys(af_dev->buff_curr)), AFBUFST);
+
+	return 0;
+}
+EXPORT_SYMBOL(af_register_setup);
+
+inline u32 af_get_hw_state(void)
+{
+	return (regr(AFPCR) & AF_BUSYAF) >> AF_BUSYAF_SHIFT;
+}
+EXPORT_SYMBOL(af_get_hw_state);
+
+inline u32 aew_get_hw_state(void)
+{
+	return (regr(AEWPCR) & AEW_BUSYAEWB) >> AEW_BUSYAEW_SHIFT;
+}
+EXPORT_SYMBOL(aew_get_hw_state);
+
+inline u32 af_get_enable(void)
+{
+	return regr(AFPCR) & AF_EN;
+}
+EXPORT_SYMBOL(af_get_enable);
+
+inline u32 aew_get_enable(void)
+{
+	return (regr(AEWPCR) & AEW_EN) >> AEW_EN_SHIFT;
+}
+EXPORT_SYMBOL(aew_get_enable);
+
+/* Function to Enable/Disable AF Engine */
+inline void af_engine_setup(struct device *dev, int enable)
+{
+	unsigned int pcr;
+
+	mutex_lock(&a3_cfg.lock);
+	pcr = regr(AFPCR);
+	dev_dbg(dev, "Engine Setup value before PCR : %x\n", pcr);
+
+	/* Set AF_EN bit in PCR Register */
+	if (enable)
+		pcr |= AF_EN;
+	else
+		pcr &= ~AF_EN;
+
+	regw(pcr, AFPCR);
+	mutex_unlock(&a3_cfg.lock);
+
+	dev_dbg(dev, "Engine Setup value after PCR : %x\n", pcr);
+}
+EXPORT_SYMBOL(af_engine_setup);
+
+/* Function to set address */
+inline void af_set_address(struct device *dev, unsigned long address)
+{
+	regw((address & ~0x3F), AFBUFST);
+}
+EXPORT_SYMBOL(af_set_address);
+
+/* Function to set hardware configuration registers */
+int aew_register_setup(struct device *dev, struct aew_device *aew_dev)
+{
+	unsigned utemp;
+
+	mutex_lock(&a3_cfg.lock);
+	/* Set up the registers */
+	utemp = regr(AEWPCR);
+
+	/* Enable A Law */
+	if (aew_dev->config->alaw_enable == H3A_AEW_ENABLE)
+		utemp |= AEW_ALAW_EN;
+	else
+		utemp &= ~AEW_ALAW_EN;
+
+	utemp &= ~AEW_MED_EN;
+	/*HMF Configurations */
+	if (aew_dev->config->hmf_config.enable == H3A_AEW_ENABLE) {
+		/* Enable HMF */
+		utemp |= AEW_MED_EN;
+		/* Set Median Threshold */
+		utemp &= ~MED_TH;
+		utemp |= (aew_dev->config->hmf_config.threshold <<
+			AF_MED_TH_SHIFT) & MED_TH;
+	}
+
+	/*Configure Saturation limit */
+	utemp &= ~AVE2LMT;
+	utemp |= aew_dev->config->saturation_limit << AEW_AVE2LMT_SHIFT;
+	regw(utemp, AEWPCR);
+	mutex_unlock(&a3_cfg.lock);
+
+	/*Window parameter configuration */
+	/* Configure Window Width in AEWWIN1 register */
+	utemp = SET_VAL(aew_dev->config->window_config.height) <<
+				AEW_WINH_SHIFT;
+
+	/* Configure Window height  in AEWWIN1 register */
+	utemp |= SET_VAL(aew_dev->config->window_config.width) <<
+				AEW_WINW_SHIFT;
+
+	/* Configure Window vertical count  in AEWWIN2 register */
+	utemp |= (aew_dev->config->window_config.vt_cnt - 1) <<
+				AEW_VT_COUNT_SHIFT;
+
+	/* Configure Window horizontal count  in AEWWIN1 register */
+	utemp |= (aew_dev->config->window_config).hz_cnt - 1;
+
+	/* Configure Window vertical start  in AEWWIN1 register */
+	regw(utemp, AEWWIN1);
+
+	/*Window Start parameter configuration */
+	utemp = aew_dev->config->window_config.vt_start << AEW_VT_START_SHIFT;
+
+	/* Configure Window horizontal start  in AEWWIN2 register */
+	utemp &= ~WINSH;
+	utemp |= (aew_dev->config->window_config).hz_start;
+	regw(utemp, AEWINSTART);
+
+	/*Window Line Increment configuration */
+	/*Configure vertical line increment in AEWSUBWIN */
+	utemp = SET_VAL(aew_dev->config->window_config.
+			 vt_line_incr) << AEW_LINE_INCR_SHIFT;
+
+	/* Configuring Horizontal Line increment in AEWSUBWIN */
+	utemp &= ~AEWINCH;
+	utemp |= SET_VAL(aew_dev->config->window_config.hz_line_incr);
+
+	regw(utemp, AEWSUBWIN);
+
+	/* Black Window Configuration */
+	/* Configure vertical start and height in AEWWINBLK */
+	utemp = (aew_dev->config->blackwindow_config).vt_start <<
+			AEW_BLKWIN_VT_START_SHIFT;
+
+	/* Configure height in Black window */
+	utemp &= ~BLKWINH;
+	utemp |= SET_VAL(aew_dev->config->blackwindow_config.height);
+	regw(utemp, AEWINBLK);
+
+	/* AE/AWB engine configuration */
+	utemp = aew_dev->config->sum_shift & AEW_SUMSHFT_MASK;
+	utemp |= (aew_dev->config->out_format << AEFMT_SHFT) & AEFMT_MASK;
+	regw(utemp, AEW_CFG);
+
+	/* Set AFBUFST to Current buffer Physical Address */
+	regw((unsigned int)(virt_to_phys(aew_dev->buff_curr)), AEWBUFST);
+
+	return 0;
+}
+EXPORT_SYMBOL(aew_register_setup);
+
+/* Function to enable/ disable AEW Engine */
+inline void aew_engine_setup(struct device *dev, int value)
+{
+	unsigned int pcr;
+
+	dev_dbg(dev, "AEW_REG(PCR) Before Setting %x\n", regr(AEWPCR));
+	mutex_lock(&a3_cfg.lock);
+	/* Read Pcr Register */
+	pcr = regr(AEWPCR);
+	pcr &= ~AEW_EN;
+	pcr |= value << AEW_EN_SHIFT;
+	/*Set AF_EN bit in PCR Register */
+	regw(pcr, AEWPCR);
+	mutex_unlock(&a3_cfg.lock);
+	dev_dbg(dev, "After Setting %d : PCR VALUE %x\n", value, regr(AEWPCR));
+
+}
+EXPORT_SYMBOL(aew_engine_setup);
+
+/* Function used to set adddress */
+inline void aew_set_address(struct device *dev, unsigned long address)
+{
+	regw((address & ~0x3F), AEWBUFST);
+}
+EXPORT_SYMBOL(aew_set_address);
+
+static int  dm365_afew_hw_init(void)
+{
+	mutex_init(&a3_cfg.lock);
+	a3_cfg.base = ioremap(DM365_A3_HW_ADDR, DM365_A3_HW_ADDR_SIZE);
+	if (!a3_cfg.base) {
+		printk(KERN_ERR "Unable to ioremap 3A registers\n");
+		return -EINVAL;
+	}
+	regw(0, LINE_START);
+
+	return 0;
+}
+
+static void dm365_afew_hw_exit(void)
+{
+	iounmap(a3_cfg.base);
+}
+subsys_initcall(dm365_afew_hw_init);
+module_exit(dm365_afew_hw_exit);
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/davinci/dm365_a3_hw.h b/drivers/media/video/davinci/dm365_a3_hw.h
new file mode 100644
index 0000000..eb5a1d4
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_a3_hw.h
@@ -0,0 +1,253 @@
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
+#ifndef DM365_A3_HW_H
+#define DM365_A3_HW_H
+
+#include <linux/io.h>
+#include <linux/device.h>
+#include <mach/hardware.h>
+#include "dm365_aew.h"
+#include "dm365_af.h"
+
+/* AF/AE/AWB Base address and range */
+#define DM365_A3_HW_ADDR	0x1c71400
+#define DM365_A3_HW_ADDR_SIZE	128
+/* AF Register Offsets */
+
+/* Peripheral Revision and Class Information */
+#define AFPID			0x0
+/* Peripheral Control Register */
+#define AFPCR			0x4
+/* Setup for the Paxel Configuration */
+#define AFPAX1			0x8
+/* Setup for the Paxel Configuration */
+#define AFPAX2			0xc
+/* Start Position for AF Engine Paxels */
+#define AFPAXSTART		0x10
+/* Start Position for IIRSH */
+#define AFIIRSH			0x14
+/* SDRAM/DDRAM Start address */
+#define AFBUFST			0x18
+/* IIR filter coefficient data for SET 0 */
+#define AFCOEF010		0x1c
+/* IIR filter coefficient data for SET 0 */
+#define AFCOEF032		0x20
+/* IIR filter coefficient data for SET 0 */
+#define AFCOEF054		0x24
+/* IIR filter coefficient data for SET 0 */
+#define AFCOEF076		0x28
+/* IIR filter coefficient data for SET 0 */
+#define AFCOEF098		0x2c
+/* IIR filter coefficient data for SET 0 */
+#define AFCOEF0010		0x30
+/* IIR filter coefficient data for SET 1 */
+#define AFCOEF110		0x34
+/* IIR filter coefficient data for SET 1 */
+#define AFCOEF132		0x38
+/* IIR filter coefficient data for SET 1 */
+#define AFCOEF154		0x3c
+/* IIR filter coefficient data for SET 1 */
+#define AFCOEF176		0x40
+/* IIR filter coefficient data for SET 1 */
+#define AFCOEF198		0x44
+/* IIR filter coefficient data for SET 1 */
+#define AFCOEF1010		0x48
+
+/* Vertical Focus vlaue configuration 1 */
+#define AF_VFV_CFG1		0x68
+/* Vertical Focus vlaue configuration 2 */
+#define AF_VFV_CFG2		0x6c
+/* Vertical Focus vlaue configuration 3 */
+#define AF_VFV_CFG3		0x70
+/* Vertical Focus vlaue configuration 4 */
+#define AF_VFV_CFG4		0x74
+/* Horizontal Focus vlaue Threshold */
+#define AF_HFV_THR		0x78
+/* COEFFICIENT BASE ADDRESS */
+
+#define AF_OFFSET	0x00000004
+
+/* AEW Register offsets */
+#define AEWPID			AFPID
+/* Peripheral Control Register */
+#define AEWPCR			AFPCR
+/* Configuration for AE/AWB Windows */
+#define AEWWIN1			0x4c
+/* Start position for AE/AWB Windows */
+#define AEWINSTART		0x50
+/* Start position and height for black linr of AE/AWB Windows */
+#define AEWINBLK		0x54
+/* Configuration for subsampled data in AE/AWB windows */
+#define AEWSUBWIN		0x58
+/* SDRAM/DDRAM Start address for AEW Engine */
+#define AEWBUFST		0x5c
+/* Line start */
+#define LINE_START		0x64
+
+/* AEW Engine configuration */
+#define AEW_CFG			0x60
+
+/* PID fields */
+#define PID_MINOR		(0x3f << 0)
+#define PID_MAJOR		(7 << 8)
+#define PID_RTL			(0x1f << 11)
+#define PID_FUNC		(0xfff << 16)
+#define PID_SCHEME		(3 << 30)
+
+/* PCR FIELDS */
+
+/*Saturation Limit */
+#define AVE2LMT			(0x3ff << 22)
+#define AF_VF_EN		(1 << 20)
+#define AEW_MED_EN		(1 << 19)
+/* Busy bit for AEW */
+#define AEW_BUSYAEWB		(1 << 18)
+/* Alaw Enable/Disable Bit */
+#define AEW_ALAW_EN		(1 << 17)
+/* AEW Engine Enable/Disable bit */
+#define AEW_EN			(1 << 16)
+/* Busy Bit for AF */
+#define AF_BUSYAF		(1 << 15)
+#define FVMODE			(1 << 14)
+#define RGBPOS			(7 << 11)
+#define MED_TH			(0xff << 3)
+#define AF_MED_EN		(1 << 2)
+#define AF_ALAW_EN		(1 << 1)
+#define AF_EN			(1 << 0)
+
+/*
+ * AFPAX1 fields
+ */
+#define PAXW		(0xff << 16)
+#define PAXH		0xff
+
+/*
+ * AFPAX2 fields
+ */
+#define  AFINCH		(0xf << 17)
+#define  AFINCV		(0xf << 13)
+#define  PAXVC		(0x7f << 6)
+#define  PAXHC		0x3f
+
+/*
+ * AFPAXSTART fields
+ */
+#define  PAXSH		(0xfff << 16)
+#define  PAXSV		0xfff
+
+/*
+ * IIR COEFFICIENT MASKS
+ */
+#define COEF_MASK0	0xfff
+#define COEF_MASK1	(0xfff << 16)
+
+/*
+ * VFV_CFGX COEFFICIENT MASKS
+ */
+#define VFV_COEF_MASK0		0xff
+#define VFV_COEF_MASK1		(0xff << 8)
+#define VFV_COEF_MASK2		(0xff << 16)
+#define VFV_COEF_MASK3		(0xff << 24)
+
+/* HFV THR MASKS */
+#define HFV_THR0_MASK		0xffff
+#define HFV_THR2_SHIFT		16
+#define HFV_THR2_MASK		(0xffff << HFV_THR2_SHIFT)
+
+/* VFV THR MASKS */
+#define VFV_THR_SHIFT		16
+#define VFV_THR_MASK		(0xffff << VFV_THR_SHIFT)
+
+/* BIT SHIFTS */
+#define AF_BUSYAF_SHIFT		15
+#define AEW_EN_SHIFT		16
+#define AEW_BUSYAEW_SHIFT	18
+#define AF_RGBPOS_SHIFT		11
+#define AF_MED_TH_SHIFT		3
+#define AF_PAXW_SHIFT		16
+#define AF_LINE_INCR_SHIFT	13
+#define AF_COLUMN_INCR_SHIFT	17
+#define AF_VT_COUNT_SHIFT	6
+#define AF_HZ_START_SHIFT	16
+#define AF_COEF_SHIFT		16
+
+/* AEWWIN1 fields */
+/* Window Height */
+#define WINH			(0x7f << 24)
+/* Window Width */
+#define WINW			(0x7f << 13)
+/* Window vertical Count */
+#define WINVC			(0x7f << 6)
+/* Window Horizontal Count */
+#define WINHC			0x3f
+
+/* AEWWINSTART fields */
+/* Window Vertical Start */
+#define WINSV			(0xfff << 16)
+/* Window Horizontal start */
+#define WINSH			0xfff
+
+/* AEWWINBLK fields
+ * Black Window Vertical Start
+ */
+#define BLKWINSV		(0xfff << 16)
+/* Black Window height */
+#define BLKWINH			0x7f
+
+/* AEWSUBWIN fields
+ * Vertical Lime Increment
+ */
+#define AEWINCV			(0xf << 8)
+/* Horizontal Line Increment */
+#define AEWINCH			0xf
+
+/* BIT POSITIONS */
+#define AEW_AVE2LMT_SHIFT	22
+#define AEW_WINH_SHIFT		24
+#define AEW_WINW_SHIFT		13
+#define AEW_VT_COUNT_SHIFT	6
+#define AEW_VT_START_SHIFT	16
+#define AEW_LINE_INCR_SHIFT	8
+
+#define AEW_EN_SHIFT			16
+#define AEW_BUSYAEWB_SHIFT		18
+#define AEW_BLKWIN_VT_START_SHIFT	16
+
+#define AEFMT_SHFT		8
+#define AEFMT_MASK		(3 << AEFMT_SHFT)
+#define AEW_SUMSHFT_MASK	0xf
+
+#define SET_VAL(x)		(((x) / 2) - 1)
+#define NOT_EVEN		1
+#define CHECK_EVEN(x)		((x) % 2)
+
+/* Function declaration for af */
+int af_register_setup(struct device *, struct af_device *);
+void af_set_address(struct device *, unsigned long);
+void af_engine_setup(struct device *, int);
+u32 af_get_hw_state(void);
+u32 af_get_enable(void);
+
+/* Function Declaration for aew */
+int aew_register_setup(struct device *, struct aew_device *);
+void aew_set_address(struct device *, unsigned long);
+void aew_engine_setup(struct device *, int);
+u32 aew_get_hw_state(void);
+u32 aew_get_enable(void);
+
+#endif				/*end of #ifdef __DAVINCI_A3_HW_H */
diff --git a/drivers/media/video/davinci/dm365_aew.c b/drivers/media/video/davinci/dm365_aew.c
new file mode 100644
index 0000000..8c193c8
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_aew.c
@@ -0,0 +1,544 @@
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
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-device.h>
+#include "dm365_a3_hw.h"
+#include "vpss.h"
+#include "vpfe_aew.h"
+
+#define DRIVERNAME  "DM365AEW"
+
+/* Global structure */
+static struct aew_device *aew_dev_configptr;
+static struct device *aewdev;
+
+int aew_validate_parameters(void)
+{
+
+	/* Check horizontal Count */
+	if (aew_dev_configptr->config->window_config.hz_cnt <
+		AEW_WINDOW_HORIZONTAL_COUNT_MIN ||
+		aew_dev_configptr->config->window_config.hz_cnt >
+			AEW_WINDOW_HORIZONTAL_COUNT_MAX) {
+		dev_err(aewdev, "Horizontal Count is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check Vertical Count */
+	if (aew_dev_configptr->config->window_config.vt_cnt <
+		AEW_WINDOW_VERTICAL_COUNT_MIN ||
+		aew_dev_configptr->config->window_config.vt_cnt >
+		AEW_WINDOW_VERTICAL_COUNT_MAX) {
+		dev_err(aewdev, "Vertical Count is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check line increment */
+	if (NOT_EVEN == CHECK_EVEN(aew_dev_configptr->config->window_config.
+		hz_line_incr) || aew_dev_configptr->config->window_config.
+		hz_line_incr < AEW_HZ_LINEINCR_MIN ||
+		aew_dev_configptr->config->window_config.hz_line_incr >
+		AEW_HZ_LINEINCR_MAX) {
+		dev_err(aewdev, "Invalid Parameters\n");
+		dev_err(aewdev, "Horizontal Line Increment is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check line increment */
+	if (NOT_EVEN == CHECK_EVEN(aew_dev_configptr->config->window_config.
+		vt_line_incr) || aew_dev_configptr->config->window_config.
+		vt_line_incr < AEW_VT_LINEINCR_MIN ||
+		aew_dev_configptr->config->window_config.vt_line_incr >
+		AEW_VT_LINEINCR_MAX) {
+		dev_err(aewdev, "Invalid Parameters\n");
+		dev_err(aewdev, "Vertical Line Increment is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check width */
+	if (NOT_EVEN == CHECK_EVEN(aew_dev_configptr->config->window_config.
+		width) || aew_dev_configptr->config->window_config.width <
+		AEW_WIDTH_MIN ||
+		aew_dev_configptr->config->window_config.width >
+			AEW_WIDTH_MAX) {
+		dev_err(aewdev, "Width is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check Height */
+	if (NOT_EVEN == CHECK_EVEN(aew_dev_configptr->config->window_config.
+		height) || aew_dev_configptr->config->window_config.height <
+		AEW_HEIGHT_MIN ||
+		aew_dev_configptr->config->window_config.height >
+			AEW_HEIGHT_MAX) {
+		dev_err(aewdev, "height incorrect\n");
+		return -EINVAL;
+	}
+	/* Check Horizontal Start */
+	if (aew_dev_configptr->config->window_config.hz_start <
+		AEW_HZSTART_MIN ||
+		aew_dev_configptr->config->window_config.hz_start >
+			AEW_HZSTART_MAX) {
+		dev_err(aewdev, "horizontal start is  incorrect\n");
+		return -EINVAL;
+	}
+	if (aew_dev_configptr->config->window_config.vt_start >
+			AEW_VTSTART_MAX) {
+		dev_err(aewdev, "Vertical start is  incorrect\n");
+		return -EINVAL;
+	}
+	if (aew_dev_configptr->config->alaw_enable > H3A_AEW_ENABLE ||
+		aew_dev_configptr->config->alaw_enable < H3A_AEW_DISABLE) {
+		dev_err(aewdev, "A Law setting is incorrect\n");
+		return -EINVAL;
+	}
+	if (aew_dev_configptr->config->saturation_limit > AEW_AVELMT_MAX) {
+		dev_err(aewdev, "Saturation Limit is incorrect\n");
+		return -EINVAL;
+	}
+	/* Check Black Window Height */
+	if (NOT_EVEN == CHECK_EVEN(aew_dev_configptr->config->
+		blackwindow_config.height) ||
+		aew_dev_configptr->config->blackwindow_config.height <
+		AEW_BLKWINHEIGHT_MIN ||
+		aew_dev_configptr->config->blackwindow_config.height >
+			AEW_BLKWINHEIGHT_MAX) {
+		dev_err(aewdev, "Black Window height incorrect\n");
+		return -EINVAL;
+	}
+	/* Check Black Window Height */
+	if (NOT_EVEN == CHECK_EVEN(aew_dev_configptr->config->
+		blackwindow_config.height) ||
+		aew_dev_configptr->config->blackwindow_config.vt_start <
+		AEW_BLKWINVTSTART_MIN ||
+		aew_dev_configptr->config->blackwindow_config.vt_start >
+			AEW_BLKWINVTSTART_MAX) {
+		dev_err(aewdev, "Black Window vertical Start is incorrect\n");
+		return -EINVAL;
+	}
+
+	if (aew_dev_configptr->config->out_format < AEW_OUT_SUM_OF_SQUARES ||
+	    aew_dev_configptr->config->out_format > AEW_OUT_SUM_ONLY) {
+		dev_err(aewdev, "Invalid out_format\n");
+		return -EINVAL;
+	}
+
+	if (aew_dev_configptr->config->sum_shift > AEW_SUMSHIFT_MAX) {
+		dev_err(aewdev, "sum_shift param is invalid, max = %d\n",
+			AEW_SUMSHIFT_MAX);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* inline function to free reserver pages  */
+inline void aew_free_pages(unsigned long addr, unsigned long bufsize)
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
+/* Function to perform hardware Configuration */
+int aew_hardware_setup(void)
+{
+	unsigned int busyaew;
+	unsigned long size;
+	unsigned long adr;
+	/* Size for buffer in bytes */
+	int buff_size;
+	int result;
+
+	/* Get the value of PCR register */
+	busyaew = aew_get_hw_state();
+
+	/* If H3A Engine is busy then return */
+	if (busyaew == 1) {
+		dev_err(aewdev, "Error : AEW Engine is busy\n");
+		return -EBUSY;
+	}
+
+	result = aew_validate_parameters();
+	dev_dbg(aewdev, "Result =  %d\n", result);
+	if (result < 0) {
+		dev_err(aewdev, "Error : Parameters are incorrect\n");
+		return result;
+	}
+
+	/* Deallocate the previously allocated buffers */
+	if (aew_dev_configptr->buff_old)
+		aew_free_pages((unsigned long)aew_dev_configptr->buff_old,
+			       aew_dev_configptr->size_window);
+
+	if (aew_dev_configptr->buff_curr)
+		aew_free_pages((unsigned long)aew_dev_configptr->
+			       buff_curr, aew_dev_configptr->size_window);
+
+	if (aew_dev_configptr->buff_app)
+		aew_free_pages((unsigned long)aew_dev_configptr->
+			       buff_app, aew_dev_configptr->size_window);
+
+	/*
+	 * Allocat the buffers as per the new buffer size
+	 * Allocate memory for old buffer
+	 */
+	if (aew_dev_configptr->config->out_format == AEW_OUT_SUM_ONLY)
+		buff_size = (aew_dev_configptr->config->window_config.hz_cnt) *
+			    (aew_dev_configptr->config->window_config.vt_cnt) *
+				AEW_WINDOW_SIZE_SUM_ONLY;
+	else
+		buff_size = (aew_dev_configptr->config->window_config.hz_cnt) *
+			    (aew_dev_configptr->config->window_config.vt_cnt) *
+				AEW_WINDOW_SIZE;
+
+	aew_dev_configptr->buff_old = (void *)__get_free_pages(GFP_KERNEL |
+				GFP_DMA, get_order(buff_size));
+
+	if (aew_dev_configptr->buff_old == NULL)
+		return -ENOMEM;
+
+	/* Make pges reserved so that they will be swapped out */
+	adr = (unsigned long)aew_dev_configptr->buff_old;
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
+	aew_dev_configptr->buff_curr = (void *)__get_free_pages(GFP_KERNEL |
+					GFP_DMA, get_order(buff_size));
+
+	if (aew_dev_configptr->buff_curr == NULL) {
+		/*Free all  buffer that are allocated */
+		if (aew_dev_configptr->buff_old)
+			aew_free_pages((unsigned long)aew_dev_configptr->
+				       buff_old, buff_size);
+		return -ENOMEM;
+	}
+
+	/* Make pges reserved so that they will be swapped out */
+	adr = (unsigned long)aew_dev_configptr->buff_curr;
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
+	/* Allocate memory for application buffer */
+	aew_dev_configptr->buff_app = (void *)__get_free_pages(GFP_KERNEL |
+					GFP_DMA, get_order(buff_size));
+
+	if (aew_dev_configptr->buff_app == NULL) {
+		/* Free all  buffer that were allocated previously */
+		if (aew_dev_configptr->buff_old)
+			aew_free_pages((unsigned long)aew_dev_configptr->
+				       buff_old, buff_size);
+		if (aew_dev_configptr->buff_curr)
+			aew_free_pages((unsigned long)aew_dev_configptr->
+				       buff_curr, buff_size);
+		return -ENOMEM;
+	}
+
+	/* Make pages reserved so that they will be swapped out */
+	adr = (unsigned long)aew_dev_configptr->buff_app;
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
+	/* Set the registers */
+	aew_register_setup(aewdev, aew_dev_configptr);
+	aew_dev_configptr->size_window = buff_size;
+	aew_dev_configptr->aew_config = H3A_AEW_CONFIG;
+
+	return 0;
+}
+
+int aew_open(void)
+{
+	/* Return if Device is in use (Single Channel Support is provided) */
+	if (aew_dev_configptr->in_use == AEW_IN_USE)
+		return -EBUSY;
+
+	/* Set the aew_dev_configptr structure */
+	aew_dev_configptr->config = NULL;
+
+	/* Allocate memory for configuration  structure of this channel */
+	aew_dev_configptr->config = (struct aew_configuration *)
+	kmalloc(sizeof(struct aew_configuration), GFP_KERNEL);
+
+	if (aew_dev_configptr->config == NULL) {
+		dev_err(aewdev, "Error : Kmalloc fail\n");
+		return -ENOMEM;
+	}
+
+	/* Device is in use */
+	aew_dev_configptr->in_use = AEW_IN_USE;
+	/* No Hardware Set up done */
+	aew_dev_configptr->aew_config = H3A_AEW_CONFIG_NOT_DONE;
+	/* No statistics are available */
+	aew_dev_configptr->buffer_filled = 0;
+	/* Set Window Size to 0 */
+	aew_dev_configptr->size_window = 0;
+
+	return 0;
+}
+
+int aew_release(void)
+{
+	aew_engine_setup(aewdev, 0);
+	/* The Application has closed device so device is not in use */
+	aew_dev_configptr->in_use = AEW_NOT_IN_USE;
+
+	/* Release memory for configuration structure of this channel */
+	kfree(aew_dev_configptr->config);
+
+	/* Free Old Buffer */
+	if (aew_dev_configptr->buff_old)
+		aew_free_pages((unsigned long)aew_dev_configptr->buff_old,
+			       aew_dev_configptr->size_window);
+
+	/* Free Current Buffer */
+	if (aew_dev_configptr->buff_curr)
+		aew_free_pages((unsigned long)aew_dev_configptr->
+			       buff_curr, aew_dev_configptr->size_window);
+
+	/* Free Application Buffer */
+	if (aew_dev_configptr->buff_app)
+		aew_free_pages((unsigned long)aew_dev_configptr->buff_app,
+			       aew_dev_configptr->size_window);
+
+	aew_dev_configptr->buff_old = NULL;
+	aew_dev_configptr->buff_curr = NULL;
+	aew_dev_configptr->config = NULL;
+	aew_dev_configptr->buff_app = NULL;
+
+	return 0;
+}
+
+/*
+ * This function will process IOCTL commands sent by the application and
+ * control the devices IO operations.
+ */
+int aew_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	/* Stores Previous Configurations */
+	struct aew_configuration aewconfig = *(aew_dev_configptr->config);
+	struct aew_statdata *stat_data = (struct aew_statdata *)arg;
+	void *buffer_temp;
+	int result;
+
+	/* Switch according to IOCTL command */
+	switch (cmd) {
+		/*
+		 * This ioctl is used to perform hardware set up
+		 * and will set all the registers for AF engine
+		 */
+	case AEW_S_PARAM:
+		/* Copy config structure passed by user */
+		memcpy(aew_dev_configptr->config,
+				   (struct aew_configuration *)arg,
+				   sizeof(struct aew_configuration));
+
+		/* Call aew_hardware_setup to perform register configuration */
+		result = aew_hardware_setup();
+		if (!result) {
+			/*
+			 * Hardware Set up is successful
+			 * Return the no of bytes required for buffer
+			 */
+			result = aew_dev_configptr->size_window;
+		} else {
+			/* Change Configuration Structure to original */
+			*(aew_dev_configptr->config) = aewconfig;
+			dev_err(aewdev, "Error : AEW_S_PARAM  failed\n");
+		}
+		break;
+
+		/* This ioctl is used to return parameters in user space */
+	case AEW_G_PARAM:
+		if (aew_dev_configptr->aew_config == H3A_AEW_CONFIG) {
+			memcpy((struct aew_configuration *)arg,
+			     aew_dev_configptr->config,
+			     sizeof(struct aew_configuration));
+			result = aew_dev_configptr->size_window;
+		} else {
+			dev_err(aewdev,
+				"Error : AEW Hardware is not configured.\n");
+			result = -EINVAL;
+		}
+		break;
+	case AEW_GET_STAT:
+		/* Implement the read  functionality */
+		if (aew_dev_configptr->buffer_filled != 1)
+			return -EINVAL;
+
+		if (stat_data->buf_length < aew_dev_configptr->size_window)
+			return -EINVAL;
+
+		/* Disable the interrupts and then swap the buffers */
+		disable_irq(6);
+
+		/* New Statistics are availaible */
+		aew_dev_configptr->buffer_filled = 0;
+
+		/* Swap application buffer and old buffer */
+		buffer_temp = aew_dev_configptr->buff_old;
+		aew_dev_configptr->buff_old = aew_dev_configptr->buff_app;
+		aew_dev_configptr->buff_app = buffer_temp;
+
+		/* Interrupts are enabled */
+		enable_irq(6);
+
+		/*
+		* Copy the entire statistics located in application
+		* buffer to user space
+		*/
+		memcpy(stat_data->buffer, aew_dev_configptr->buff_app,
+				aew_dev_configptr->size_window);
+
+		result = aew_dev_configptr->size_window;
+		break;
+	default:
+		dev_err(aewdev, "Error: It should not come here!!\n");
+		result = -ENOTTY;
+		break;
+	}
+	return result;
+}
+
+/* This function will handle interrupt generated by H3A Engine. */
+static irqreturn_t aew_isr(int irq, void *dev_id)
+{
+	struct v4l2_subdev *sd = dev_id;
+	/* EN AF Bit */
+	unsigned int enaew;
+	/* Temporary Buffer for Swapping */
+	void *buffer_temp;
+
+	/* Get the value of PCR register */
+	enaew = aew_get_enable();
+
+	/* If AEW engine is not enabled, interrupt is not for AEW */
+	if (!enaew || !aew_dev_configptr)
+		return IRQ_RETVAL(IRQ_NONE);
+
+	/*
+	 * Interrupt is generated by AEW, so Service the Interrupt
+	 * Swap current buffer and old buffer
+	 */
+	buffer_temp = aew_dev_configptr->buff_curr;
+	aew_dev_configptr->buff_curr = aew_dev_configptr->buff_old;
+	aew_dev_configptr->buff_old = buffer_temp;
+
+	/* Set the AEWBUFSTAT REgister to current buffer Address */
+	aew_set_address(aewdev,
+		(unsigned long)(virt_to_phys(aew_dev_configptr->buff_curr)));
+	/*
+	  * Set buffer filled flag to indicate statistics are available
+	  */
+	aew_dev_configptr->buffer_filled = 1;
+	/* queue the event with v4l2 */
+	aew_queue_event(sd);
+
+	return IRQ_RETVAL(IRQ_HANDLED);
+}
+
+int aew_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	int result;
+
+	if (!enable) {
+		/* stop capture */
+		free_irq(6, sd);
+		/* Disable AEW Engine */
+		aew_engine_setup(aewdev, 0);
+		return 0;
+	}
+	/* start capture */
+	/* Enable AEW Engine if Hardware set up is done */
+	if (aew_dev_configptr->aew_config == H3A_AEW_CONFIG_NOT_DONE) {
+		dev_err(aewdev, "Error : AEW Hardware is not configured.\n");
+		return -EINVAL;
+	}
+	result = request_irq(6, aew_isr, IRQF_SHARED, "dm365_h3a_aew",
+			(void *)sd);
+	if (result != 0)
+		return result;
+	/* Enable AF Engine */
+	aew_engine_setup(aewdev, 1);
+
+	return 0;
+}
+
+int aew_init(struct platform_device *pdev)
+{
+	aew_dev_configptr =  kmalloc(sizeof(struct aew_device), GFP_KERNEL);
+	if (!aew_dev_configptr) {
+		printk(KERN_ERR "aew_init: Error : kmalloc fail\n");
+		return -ENOMEM;
+	}
+	/* Initialize device structure */
+	memset(aew_dev_configptr, 0, sizeof(struct aew_device));
+	aew_dev_configptr->in_use = AEW_NOT_IN_USE;
+	aew_dev_configptr->buffer_filled = 0;
+	aewdev = &pdev->dev;
+
+	return 0;
+}
+
+void aew_cleanup(void)
+{
+	/* in use */
+	if (aew_dev_configptr->in_use == AEW_IN_USE) {
+		printk(KERN_ERR "aew_cleanup: Error : dm365_aew in use");
+		return;
+	}
+	/* Free device structure */
+	kfree(aew_dev_configptr);
+	aew_dev_configptr = NULL;
+}
diff --git a/drivers/media/video/davinci/dm365_aew.h b/drivers/media/video/davinci/dm365_aew.h
new file mode 100644
index 0000000..47bfda5
--- /dev/null
+++ b/drivers/media/video/davinci/dm365_aew.h
@@ -0,0 +1,55 @@
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
+#ifndef DM365_AEW_DRIVER_H
+#define DM365_AEW_DRIVER_H
+
+#include <linux/ioctl.h>
+#include <linux/wait.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/dm365_aew.h>
+
+/* Contains information about device structure of AEW*/
+struct aew_device {
+	/* Driver usage flag */
+	enum aew_in_use_flag in_use;
+	/* Device configuration */
+	struct aew_configuration *config;
+	/* Contains latest statistics */
+	void *buff_old;
+	/* Buffer in which HW will fill the statistics or HW is already
+	 * filling
+	 */
+	void *buff_curr;
+	/* statistics Buffer which will be passed */
+	void *buff_app;
+	/* to user on read call. Flag indicates statistics are available */
+	int buffer_filled;
+	/* Window size in bytes */
+	unsigned int size_window;
+	/* Wait queue for the driver */
+	wait_queue_head_t aew_wait_queue;
+	/* Mutex for driver */
+	struct mutex read_blocked;
+	/* Flag indicates Engine is configured */
+	enum aew_config_flag aew_config;
+};
+
+int aew_validate_parameters(void);
+int aew_hardware_setup(void);
+
+#endif				/*End of DM365_AEW_H */
diff --git a/include/linux/dm365_aew.h b/include/linux/dm365_aew.h
new file mode 100644
index 0000000..3882d79
--- /dev/null
+++ b/include/linux/dm365_aew.h
@@ -0,0 +1,153 @@
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
+#ifndef _DM365_AEW_INCLUDE_H
+#define _DM365_AEW_INCLUDE_H
+
+/* Driver Range Constants */
+#define AEW_WINDOW_VERTICAL_COUNT_MIN		1
+#define AEW_WINDOW_VERTICAL_COUNT_MAX		128
+#define AEW_WINDOW_HORIZONTAL_COUNT_MIN		2
+#define AEW_WINDOW_HORIZONTAL_COUNT_MAX		36
+
+#define AEW_WIDTH_MIN		8
+#define AEW_WIDTH_MAX		256
+
+#define AEW_AVELMT_MAX		1023
+
+#define AEW_HZ_LINEINCR_MIN	2
+#define AEW_HZ_LINEINCR_MAX	32
+
+#define AEW_VT_LINEINCR_MIN	2
+#define AEW_VT_LINEINCR_MAX	32
+
+#define AEW_HEIGHT_MIN		2
+#define AEW_HEIGHT_MAX		256
+
+#define AEW_HZSTART_MIN		0
+#define AEW_HZSTART_MAX		4095
+
+#define AEW_VTSTART_MIN		0
+#define AEW_VTSTART_MAX		4095
+
+#define AEW_BLKWINHEIGHT_MIN	2
+#define AEW_BLKWINHEIGHT_MAX	256
+#define AEW_BLKWINVTSTART_MIN	0
+#define AEW_BLKWINVTSTART_MAX	4095
+
+#define AEW_SUMSHIFT_MAX	15
+
+/* Statistics data size per window */
+#define AEW_WINDOW_SIZE			32
+#define AEW_WINDOW_SIZE_SUM_ONLY	16
+
+/* List of ioctls */
+#define AEW_MAGIC_NO	'e'
+#define AEW_S_PARAM	_IOWR(AEW_MAGIC_NO, 1, struct aew_configuration)
+#define AEW_G_PARAM	_IOWR(AEW_MAGIC_NO, 2, struct aew_configuration)
+#define AEW_GET_STAT	_IOWR(AEW_MAGIC_NO, 5, struct aew_statdata)
+
+/* Enum for device usage */
+enum aew_in_use_flag {
+	/* Device is not in use */
+	AEW_NOT_IN_USE,
+	/* Device in use */
+	AEW_IN_USE
+};
+
+/* Enum for Enable/Disable specific feature */
+enum aew_enable_flag {
+	H3A_AEW_DISABLE,
+	H3A_AEW_ENABLE
+};
+
+enum aew_config_flag {
+	H3A_AEW_CONFIG_NOT_DONE,
+	H3A_AEW_CONFIG
+};
+
+
+/* Contains the information regarding Window Structure in AEW Engine */
+struct aew_window {
+	/* Width of the window */
+	unsigned int width;
+	/* Height of the window */
+	unsigned int height;
+	/* Horizontal Start of the window */
+	unsigned int hz_start;
+	/* Vertical Start of the window */
+	unsigned int vt_start;
+	/* Horizontal Count */
+	unsigned int hz_cnt;
+	/* Vertical Count */
+	unsigned int vt_cnt;
+	/* Horizontal Line Increment */
+	unsigned int hz_line_incr;
+	/* Vertical Line Increment */
+	unsigned int vt_line_incr;
+};
+
+/* Contains the information regarding the AEW Black Window Structure */
+struct aew_black_window {
+	/* Height of the Black Window */
+	unsigned int height;
+	/* Vertical Start of the black Window */
+	unsigned int vt_start;
+};
+
+/* Contains the information regarding the Horizontal Median Filter */
+struct aew_hmf {
+	/* Status of Horizontal Median Filter */
+	enum aew_enable_flag enable;
+	/* Threshhold Value for Horizontal Median Filter. Make sure
+	 * to keep this same as AF threshold since we have a common
+	 * threshold for both
+	 */
+	unsigned int threshold;
+};
+
+/* AE/AWB output format */
+enum aew_output_format {
+	AEW_OUT_SUM_OF_SQUARES,
+	AEW_OUT_MIN_MAX,
+	AEW_OUT_SUM_ONLY
+};
+
+/* Contains configuration required for setup of AEW engine */
+struct aew_configuration {
+	/* A-law status */
+	enum aew_enable_flag alaw_enable;
+	/* AE/AWB output format */
+	enum aew_output_format out_format;
+	/* AW/AWB right shift value for sum of pixels */
+	char sum_shift;
+	/* Saturation Limit */
+	int saturation_limit;
+	/* HMF configurations */
+	struct aew_hmf hmf_config;
+	/* Window for AEW Engine */
+	struct aew_window window_config;
+	/* Black Window */
+	struct aew_black_window blackwindow_config;
+};
+
+struct aew_statdata {
+	void *buffer;
+	int buf_length;
+};
+
+#endif
-- 
1.6.2.4

