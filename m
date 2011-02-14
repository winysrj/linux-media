Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab1BNMV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 09/10] omap3isp: Statistics
Date: Mon, 14 Feb 2011 13:21:36 +0100
Message-Id: <1297686097-9804-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: David Cohen <dacohen@gmail.com>

The OMAP3 ISP statistics entities compute histogram and H3A statistics
information from capture images.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: David Cohen <dacohen@gmail.com>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Signed-off-by: Antti Koskipaa <akoskipa@gmail.com>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: RaniSuneela <r-m@ti.com>
Signed-off-by: Atanas Filipov <afilipov@mm-sol.com>
Signed-off-by: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Nayden Kanchev <nkanchev@mm-sol.com>
Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Dominic Curran <dcurran@ti.com>
Signed-off-by: Ilkka Myllyperkio <ilkka.myllyperkio@sofica.fi>
Signed-off-by: Pallavi Kulkarni <p-kulkarni@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap3-isp/isph3a.h      |  117 +++
 drivers/media/video/omap3-isp/isph3a_aewb.c |  374 +++++++++
 drivers/media/video/omap3-isp/isph3a_af.c   |  429 +++++++++++
 drivers/media/video/omap3-isp/isphist.c     |  520 +++++++++++++
 drivers/media/video/omap3-isp/isphist.h     |   40 +
 drivers/media/video/omap3-isp/ispstat.c     | 1092 +++++++++++++++++++++++++++
 drivers/media/video/omap3-isp/ispstat.h     |  169 +++++
 7 files changed, 2741 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/omap3-isp/isph3a.h
 create mode 100644 drivers/media/video/omap3-isp/isph3a_aewb.c
 create mode 100644 drivers/media/video/omap3-isp/isph3a_af.c
 create mode 100644 drivers/media/video/omap3-isp/isphist.c
 create mode 100644 drivers/media/video/omap3-isp/isphist.h
 create mode 100644 drivers/media/video/omap3-isp/ispstat.c
 create mode 100644 drivers/media/video/omap3-isp/ispstat.h

diff --git a/drivers/media/video/omap3-isp/isph3a.h b/drivers/media/video/omap3-isp/isph3a.h
new file mode 100644
index 0000000..fb09fd4
--- /dev/null
+++ b/drivers/media/video/omap3-isp/isph3a.h
@@ -0,0 +1,117 @@
+/*
+ * isph3a.h
+ *
+ * TI OMAP3 ISP - H3A AF module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: David Cohen <dacohen@gmail.com>
+ *	     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_H3A_H
+#define OMAP3_ISP_H3A_H
+
+#include <linux/omap3isp.h>
+
+/*
+ * ----------
+ * -H3A AEWB-
+ * ----------
+ */
+
+#define AEWB_PACKET_SIZE	16
+#define AEWB_SATURATION_LIMIT	0x3ff
+
+/* Flags for changed registers */
+#define PCR_CHNG		(1 << 0)
+#define AEWWIN1_CHNG		(1 << 1)
+#define AEWINSTART_CHNG		(1 << 2)
+#define AEWINBLK_CHNG		(1 << 3)
+#define AEWSUBWIN_CHNG		(1 << 4)
+#define PRV_WBDGAIN_CHNG	(1 << 5)
+#define PRV_WBGAIN_CHNG		(1 << 6)
+
+/* ISPH3A REGISTERS bits */
+#define ISPH3A_PCR_AF_EN	(1 << 0)
+#define ISPH3A_PCR_AF_ALAW_EN	(1 << 1)
+#define ISPH3A_PCR_AF_MED_EN	(1 << 2)
+#define ISPH3A_PCR_AF_BUSY	(1 << 15)
+#define ISPH3A_PCR_AEW_EN	(1 << 16)
+#define ISPH3A_PCR_AEW_ALAW_EN	(1 << 17)
+#define ISPH3A_PCR_AEW_BUSY	(1 << 18)
+#define ISPH3A_PCR_AEW_MASK	(ISPH3A_PCR_AEW_ALAW_EN | \
+				 ISPH3A_PCR_AEW_AVE2LMT_MASK)
+
+/*
+ * --------
+ * -H3A AF-
+ * --------
+ */
+
+/* Peripheral Revision */
+#define AFPID				0x0
+
+#define AFCOEF_OFFSET			0x00000004	/* COEF base address */
+
+/* PCR fields */
+#define AF_BUSYAF			(1 << 15)
+#define AF_FVMODE			(1 << 14)
+#define AF_RGBPOS			(0x7 << 11)
+#define AF_MED_TH			(0xFF << 3)
+#define AF_MED_EN			(1 << 2)
+#define AF_ALAW_EN			(1 << 1)
+#define AF_EN				(1 << 0)
+#define AF_PCR_MASK			(AF_FVMODE | AF_RGBPOS | AF_MED_TH | \
+					 AF_MED_EN | AF_ALAW_EN)
+
+/* AFPAX1 fields */
+#define AF_PAXW				(0x7F << 16)
+#define AF_PAXH				0x7F
+
+/* AFPAX2 fields */
+#define AF_AFINCV			(0xF << 13)
+#define AF_PAXVC			(0x7F << 6)
+#define AF_PAXHC			0x3F
+
+/* AFPAXSTART fields */
+#define AF_PAXSH			(0xFFF<<16)
+#define AF_PAXSV			0xFFF
+
+/* COEFFICIENT MASK */
+#define AF_COEF_MASK0			0xFFF
+#define AF_COEF_MASK1			(0xFFF<<16)
+
+/* BIT SHIFTS */
+#define AF_RGBPOS_SHIFT			11
+#define AF_MED_TH_SHIFT			3
+#define AF_PAXW_SHIFT			16
+#define AF_LINE_INCR_SHIFT		13
+#define AF_VT_COUNT_SHIFT		6
+#define AF_HZ_START_SHIFT		16
+#define AF_COEF_SHIFT			16
+
+/* Init and cleanup functions */
+int omap3isp_h3a_aewb_init(struct isp_device *isp);
+int omap3isp_h3a_af_init(struct isp_device *isp);
+
+void omap3isp_h3a_aewb_cleanup(struct isp_device *isp);
+void omap3isp_h3a_af_cleanup(struct isp_device *isp);
+
+#endif /* OMAP3_ISP_H3A_H */
diff --git a/drivers/media/video/omap3-isp/isph3a_aewb.c b/drivers/media/video/omap3-isp/isph3a_aewb.c
new file mode 100644
index 0000000..8068cef
--- /dev/null
+++ b/drivers/media/video/omap3-isp/isph3a_aewb.c
@@ -0,0 +1,374 @@
+/*
+ * isph3a.c
+ *
+ * TI OMAP3 ISP - H3A module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: David Cohen <dacohen@gmail.com>
+ *	     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "isp.h"
+#include "isph3a.h"
+#include "ispstat.h"
+
+/*
+ * h3a_aewb_update_regs - Helper function to update h3a registers.
+ */
+static void h3a_aewb_setup_regs(struct ispstat *aewb, void *priv)
+{
+	struct omap3isp_h3a_aewb_config *conf = priv;
+	u32 pcr;
+	u32 win1;
+	u32 start;
+	u32 blk;
+	u32 subwin;
+
+	if (aewb->state == ISPSTAT_DISABLED)
+		return;
+
+	isp_reg_writel(aewb->isp, aewb->active_buf->iommu_addr,
+		       OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWBUFST);
+
+	if (!aewb->update)
+		return;
+
+	/* Converting config metadata into reg values */
+	pcr = conf->saturation_limit << ISPH3A_PCR_AEW_AVE2LMT_SHIFT;
+	pcr |= !!conf->alaw_enable << ISPH3A_PCR_AEW_ALAW_EN_SHIFT;
+
+	win1 = ((conf->win_height >> 1) - 1) << ISPH3A_AEWWIN1_WINH_SHIFT;
+	win1 |= ((conf->win_width >> 1) - 1) << ISPH3A_AEWWIN1_WINW_SHIFT;
+	win1 |= (conf->ver_win_count - 1) << ISPH3A_AEWWIN1_WINVC_SHIFT;
+	win1 |= (conf->hor_win_count - 1) << ISPH3A_AEWWIN1_WINHC_SHIFT;
+
+	start = conf->hor_win_start << ISPH3A_AEWINSTART_WINSH_SHIFT;
+	start |= conf->ver_win_start << ISPH3A_AEWINSTART_WINSV_SHIFT;
+
+	blk = conf->blk_ver_win_start << ISPH3A_AEWINBLK_WINSV_SHIFT;
+	blk |= ((conf->blk_win_height >> 1) - 1) << ISPH3A_AEWINBLK_WINH_SHIFT;
+
+	subwin = ((conf->subsample_ver_inc >> 1) - 1) <<
+		 ISPH3A_AEWSUBWIN_AEWINCV_SHIFT;
+	subwin |= ((conf->subsample_hor_inc >> 1) - 1) <<
+		  ISPH3A_AEWSUBWIN_AEWINCH_SHIFT;
+
+	isp_reg_writel(aewb->isp, win1, OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWWIN1);
+	isp_reg_writel(aewb->isp, start, OMAP3_ISP_IOMEM_H3A,
+		       ISPH3A_AEWINSTART);
+	isp_reg_writel(aewb->isp, blk, OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWINBLK);
+	isp_reg_writel(aewb->isp, subwin, OMAP3_ISP_IOMEM_H3A,
+		       ISPH3A_AEWSUBWIN);
+	isp_reg_clr_set(aewb->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR,
+			ISPH3A_PCR_AEW_MASK, pcr);
+
+	aewb->update = 0;
+	aewb->config_counter += aewb->inc_config;
+	aewb->inc_config = 0;
+	aewb->buf_size = conf->buf_size;
+}
+
+static void h3a_aewb_enable(struct ispstat *aewb, int enable)
+{
+	if (enable) {
+		isp_reg_set(aewb->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR,
+			    ISPH3A_PCR_AEW_EN);
+		/* This bit is already set if AF is enabled */
+		if (aewb->isp->isp_af.state != ISPSTAT_ENABLED)
+			isp_reg_set(aewb->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
+				    ISPCTRL_H3A_CLK_EN);
+	} else {
+		isp_reg_clr(aewb->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR,
+			    ISPH3A_PCR_AEW_EN);
+		/* This bit can't be cleared if AF is enabled */
+		if (aewb->isp->isp_af.state != ISPSTAT_ENABLED)
+			isp_reg_clr(aewb->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
+				    ISPCTRL_H3A_CLK_EN);
+	}
+}
+
+static int h3a_aewb_busy(struct ispstat *aewb)
+{
+	return isp_reg_readl(aewb->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR)
+						& ISPH3A_PCR_BUSYAEAWB;
+}
+
+static u32 h3a_aewb_get_buf_size(struct omap3isp_h3a_aewb_config *conf)
+{
+	/* Number of configured windows + extra row for black data */
+	u32 win_count = (conf->ver_win_count + 1) * conf->hor_win_count;
+
+	/*
+	 * Unsaturated block counts for each 8 windows.
+	 * 1 extra for the last (win_count % 8) windows if win_count is not
+	 * divisible by 8.
+	 */
+	win_count += (win_count + 7) / 8;
+
+	return win_count * AEWB_PACKET_SIZE;
+}
+
+static int h3a_aewb_validate_params(struct ispstat *aewb, void *new_conf)
+{
+	struct omap3isp_h3a_aewb_config *user_cfg = new_conf;
+	u32 buf_size;
+
+	if (unlikely(user_cfg->saturation_limit >
+		     OMAP3ISP_AEWB_MAX_SATURATION_LIM))
+		return -EINVAL;
+
+	if (unlikely(user_cfg->win_height < OMAP3ISP_AEWB_MIN_WIN_H ||
+		     user_cfg->win_height > OMAP3ISP_AEWB_MAX_WIN_H ||
+		     user_cfg->win_height & 0x01))
+		return -EINVAL;
+
+	if (unlikely(user_cfg->win_width < OMAP3ISP_AEWB_MIN_WIN_W ||
+		     user_cfg->win_width > OMAP3ISP_AEWB_MAX_WIN_W ||
+		     user_cfg->win_width & 0x01))
+		return -EINVAL;
+
+	if (unlikely(user_cfg->ver_win_count < OMAP3ISP_AEWB_MIN_WINVC ||
+		     user_cfg->ver_win_count > OMAP3ISP_AEWB_MAX_WINVC))
+		return -EINVAL;
+
+	if (unlikely(user_cfg->hor_win_count < OMAP3ISP_AEWB_MIN_WINHC ||
+		     user_cfg->hor_win_count > OMAP3ISP_AEWB_MAX_WINHC))
+		return -EINVAL;
+
+	if (unlikely(user_cfg->ver_win_start > OMAP3ISP_AEWB_MAX_WINSTART))
+		return -EINVAL;
+
+	if (unlikely(user_cfg->hor_win_start > OMAP3ISP_AEWB_MAX_WINSTART))
+		return -EINVAL;
+
+	if (unlikely(user_cfg->blk_ver_win_start > OMAP3ISP_AEWB_MAX_WINSTART))
+		return -EINVAL;
+
+	if (unlikely(user_cfg->blk_win_height < OMAP3ISP_AEWB_MIN_WIN_H ||
+		     user_cfg->blk_win_height > OMAP3ISP_AEWB_MAX_WIN_H ||
+		     user_cfg->blk_win_height & 0x01))
+		return -EINVAL;
+
+	if (unlikely(user_cfg->subsample_ver_inc < OMAP3ISP_AEWB_MIN_SUB_INC ||
+		     user_cfg->subsample_ver_inc > OMAP3ISP_AEWB_MAX_SUB_INC ||
+		     user_cfg->subsample_ver_inc & 0x01))
+		return -EINVAL;
+
+	if (unlikely(user_cfg->subsample_hor_inc < OMAP3ISP_AEWB_MIN_SUB_INC ||
+		     user_cfg->subsample_hor_inc > OMAP3ISP_AEWB_MAX_SUB_INC ||
+		     user_cfg->subsample_hor_inc & 0x01))
+		return -EINVAL;
+
+	buf_size = h3a_aewb_get_buf_size(user_cfg);
+	if (buf_size > user_cfg->buf_size)
+		user_cfg->buf_size = buf_size;
+	else if (user_cfg->buf_size > OMAP3ISP_AEWB_MAX_BUF_SIZE)
+		user_cfg->buf_size = OMAP3ISP_AEWB_MAX_BUF_SIZE;
+
+	return 0;
+}
+
+/*
+ * h3a_aewb_set_params - Helper function to check & store user given params.
+ * @new_conf: Pointer to AE and AWB parameters struct.
+ *
+ * As most of them are busy-lock registers, need to wait until AEW_BUSY = 0 to
+ * program them during ISR.
+ */
+static void h3a_aewb_set_params(struct ispstat *aewb, void *new_conf)
+{
+	struct omap3isp_h3a_aewb_config *user_cfg = new_conf;
+	struct omap3isp_h3a_aewb_config *cur_cfg = aewb->priv;
+	int update = 0;
+
+	if (cur_cfg->saturation_limit != user_cfg->saturation_limit) {
+		cur_cfg->saturation_limit = user_cfg->saturation_limit;
+		update = 1;
+	}
+	if (cur_cfg->alaw_enable != user_cfg->alaw_enable) {
+		cur_cfg->alaw_enable = user_cfg->alaw_enable;
+		update = 1;
+	}
+	if (cur_cfg->win_height != user_cfg->win_height) {
+		cur_cfg->win_height = user_cfg->win_height;
+		update = 1;
+	}
+	if (cur_cfg->win_width != user_cfg->win_width) {
+		cur_cfg->win_width = user_cfg->win_width;
+		update = 1;
+	}
+	if (cur_cfg->ver_win_count != user_cfg->ver_win_count) {
+		cur_cfg->ver_win_count = user_cfg->ver_win_count;
+		update = 1;
+	}
+	if (cur_cfg->hor_win_count != user_cfg->hor_win_count) {
+		cur_cfg->hor_win_count = user_cfg->hor_win_count;
+		update = 1;
+	}
+	if (cur_cfg->ver_win_start != user_cfg->ver_win_start) {
+		cur_cfg->ver_win_start = user_cfg->ver_win_start;
+		update = 1;
+	}
+	if (cur_cfg->hor_win_start != user_cfg->hor_win_start) {
+		cur_cfg->hor_win_start = user_cfg->hor_win_start;
+		update = 1;
+	}
+	if (cur_cfg->blk_ver_win_start != user_cfg->blk_ver_win_start) {
+		cur_cfg->blk_ver_win_start = user_cfg->blk_ver_win_start;
+		update = 1;
+	}
+	if (cur_cfg->blk_win_height != user_cfg->blk_win_height) {
+		cur_cfg->blk_win_height = user_cfg->blk_win_height;
+		update = 1;
+	}
+	if (cur_cfg->subsample_ver_inc != user_cfg->subsample_ver_inc) {
+		cur_cfg->subsample_ver_inc = user_cfg->subsample_ver_inc;
+		update = 1;
+	}
+	if (cur_cfg->subsample_hor_inc != user_cfg->subsample_hor_inc) {
+		cur_cfg->subsample_hor_inc = user_cfg->subsample_hor_inc;
+		update = 1;
+	}
+
+	if (update || !aewb->configured) {
+		aewb->inc_config++;
+		aewb->update = 1;
+		cur_cfg->buf_size = h3a_aewb_get_buf_size(cur_cfg);
+	}
+}
+
+static long h3a_aewb_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct ispstat *stat = v4l2_get_subdevdata(sd);
+
+	switch (cmd) {
+	case VIDIOC_OMAP3ISP_AEWB_CFG:
+		return omap3isp_stat_config(stat, arg);
+	case VIDIOC_OMAP3ISP_STAT_REQ:
+		return omap3isp_stat_request_statistics(stat, arg);
+	case VIDIOC_OMAP3ISP_STAT_EN: {
+		unsigned long *en = arg;
+		return omap3isp_stat_enable(stat, !!*en);
+	}
+	}
+
+	return -ENOIOCTLCMD;
+}
+
+static const struct ispstat_ops h3a_aewb_ops = {
+	.validate_params	= h3a_aewb_validate_params,
+	.set_params		= h3a_aewb_set_params,
+	.setup_regs		= h3a_aewb_setup_regs,
+	.enable			= h3a_aewb_enable,
+	.busy			= h3a_aewb_busy,
+};
+
+static const struct v4l2_subdev_core_ops h3a_aewb_subdev_core_ops = {
+	.ioctl = h3a_aewb_ioctl,
+	.subscribe_event = omap3isp_stat_subscribe_event,
+	.unsubscribe_event = omap3isp_stat_unsubscribe_event,
+};
+
+static const struct v4l2_subdev_video_ops h3a_aewb_subdev_video_ops = {
+	.s_stream = omap3isp_stat_s_stream,
+};
+
+static const struct v4l2_subdev_ops h3a_aewb_subdev_ops = {
+	.core = &h3a_aewb_subdev_core_ops,
+	.video = &h3a_aewb_subdev_video_ops,
+};
+
+/*
+ * omap3isp_h3a_aewb_init - Module Initialisation.
+ */
+int omap3isp_h3a_aewb_init(struct isp_device *isp)
+{
+	struct ispstat *aewb = &isp->isp_aewb;
+	struct omap3isp_h3a_aewb_config *aewb_cfg;
+	struct omap3isp_h3a_aewb_config *aewb_recover_cfg;
+	int ret;
+
+	aewb_cfg = kzalloc(sizeof(*aewb_cfg), GFP_KERNEL);
+	if (!aewb_cfg)
+		return -ENOMEM;
+
+	memset(aewb, 0, sizeof(*aewb));
+	aewb->ops = &h3a_aewb_ops;
+	aewb->priv = aewb_cfg;
+	aewb->dma_ch = -1;
+	aewb->event_type = V4L2_EVENT_OMAP3ISP_AEWB;
+	aewb->isp = isp;
+
+	/* Set recover state configuration */
+	aewb_recover_cfg = kzalloc(sizeof(*aewb_recover_cfg), GFP_KERNEL);
+	if (!aewb_recover_cfg) {
+		dev_err(aewb->isp->dev, "AEWB: cannot allocate memory for "
+					"recover configuration.\n");
+		ret = -ENOMEM;
+		goto err_recover_alloc;
+	}
+
+	aewb_recover_cfg->saturation_limit = OMAP3ISP_AEWB_MAX_SATURATION_LIM;
+	aewb_recover_cfg->win_height = OMAP3ISP_AEWB_MIN_WIN_H;
+	aewb_recover_cfg->win_width = OMAP3ISP_AEWB_MIN_WIN_W;
+	aewb_recover_cfg->ver_win_count = OMAP3ISP_AEWB_MIN_WINVC;
+	aewb_recover_cfg->hor_win_count = OMAP3ISP_AEWB_MIN_WINHC;
+	aewb_recover_cfg->blk_ver_win_start = aewb_recover_cfg->ver_win_start +
+		aewb_recover_cfg->win_height * aewb_recover_cfg->ver_win_count;
+	aewb_recover_cfg->blk_win_height = OMAP3ISP_AEWB_MIN_WIN_H;
+	aewb_recover_cfg->subsample_ver_inc = OMAP3ISP_AEWB_MIN_SUB_INC;
+	aewb_recover_cfg->subsample_hor_inc = OMAP3ISP_AEWB_MIN_SUB_INC;
+
+	if (h3a_aewb_validate_params(aewb, aewb_recover_cfg)) {
+		dev_err(aewb->isp->dev, "AEWB: recover configuration is "
+					"invalid.\n");
+		ret = -EINVAL;
+		goto err_conf;
+	}
+
+	aewb_recover_cfg->buf_size = h3a_aewb_get_buf_size(aewb_recover_cfg);
+	aewb->recover_priv = aewb_recover_cfg;
+
+	ret = omap3isp_stat_init(aewb, "AEWB", &h3a_aewb_subdev_ops);
+	if (ret)
+		goto err_conf;
+
+	return 0;
+
+err_conf:
+	kfree(aewb_recover_cfg);
+err_recover_alloc:
+	kfree(aewb_cfg);
+
+	return ret;
+}
+
+/*
+ * omap3isp_h3a_aewb_cleanup - Module exit.
+ */
+void omap3isp_h3a_aewb_cleanup(struct isp_device *isp)
+{
+	kfree(isp->isp_aewb.priv);
+	kfree(isp->isp_aewb.recover_priv);
+	omap3isp_stat_free(&isp->isp_aewb);
+}
diff --git a/drivers/media/video/omap3-isp/isph3a_af.c b/drivers/media/video/omap3-isp/isph3a_af.c
new file mode 100644
index 0000000..ba54d0a
--- /dev/null
+++ b/drivers/media/video/omap3-isp/isph3a_af.c
@@ -0,0 +1,429 @@
+/*
+ * isph3a_af.c
+ *
+ * TI OMAP3 ISP - H3A AF module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: David Cohen <dacohen@gmail.com>
+ *	     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+/* Linux specific include files */
+#include <linux/device.h>
+#include <linux/slab.h>
+
+#include "isp.h"
+#include "isph3a.h"
+#include "ispstat.h"
+
+#define IS_OUT_OF_BOUNDS(value, min, max)		\
+	(((value) < (min)) || ((value) > (max)))
+
+static void h3a_af_setup_regs(struct ispstat *af, void *priv)
+{
+	struct omap3isp_h3a_af_config *conf = priv;
+	u32 pcr;
+	u32 pax1;
+	u32 pax2;
+	u32 paxstart;
+	u32 coef;
+	u32 base_coef_set0;
+	u32 base_coef_set1;
+	int index;
+
+	if (af->state == ISPSTAT_DISABLED)
+		return;
+
+	isp_reg_writel(af->isp, af->active_buf->iommu_addr, OMAP3_ISP_IOMEM_H3A,
+		       ISPH3A_AFBUFST);
+
+	if (!af->update)
+		return;
+
+	/* Configure Hardware Registers */
+	pax1 = ((conf->paxel.width >> 1) - 1) << AF_PAXW_SHIFT;
+	/* Set height in AFPAX1 */
+	pax1 |= (conf->paxel.height >> 1) - 1;
+	isp_reg_writel(af->isp, pax1, OMAP3_ISP_IOMEM_H3A, ISPH3A_AFPAX1);
+
+	/* Configure AFPAX2 Register */
+	/* Set Line Increment in AFPAX2 Register */
+	pax2 = ((conf->paxel.line_inc >> 1) - 1) << AF_LINE_INCR_SHIFT;
+	/* Set Vertical Count */
+	pax2 |= (conf->paxel.v_cnt - 1) << AF_VT_COUNT_SHIFT;
+	/* Set Horizontal Count */
+	pax2 |= (conf->paxel.h_cnt - 1);
+	isp_reg_writel(af->isp, pax2, OMAP3_ISP_IOMEM_H3A, ISPH3A_AFPAX2);
+
+	/* Configure PAXSTART Register */
+	/*Configure Horizontal Start */
+	paxstart = conf->paxel.h_start << AF_HZ_START_SHIFT;
+	/* Configure Vertical Start */
+	paxstart |= conf->paxel.v_start;
+	isp_reg_writel(af->isp, paxstart, OMAP3_ISP_IOMEM_H3A,
+		       ISPH3A_AFPAXSTART);
+
+	/*SetIIRSH Register */
+	isp_reg_writel(af->isp, conf->iir.h_start,
+		       OMAP3_ISP_IOMEM_H3A, ISPH3A_AFIIRSH);
+
+	base_coef_set0 = ISPH3A_AFCOEF010;
+	base_coef_set1 = ISPH3A_AFCOEF110;
+	for (index = 0; index <= 8; index += 2) {
+		/*Set IIR Filter0 Coefficients */
+		coef = 0;
+		coef |= conf->iir.coeff_set0[index];
+		coef |= conf->iir.coeff_set0[index + 1] <<
+			AF_COEF_SHIFT;
+		isp_reg_writel(af->isp, coef, OMAP3_ISP_IOMEM_H3A,
+			       base_coef_set0);
+		base_coef_set0 += AFCOEF_OFFSET;
+
+		/*Set IIR Filter1 Coefficients */
+		coef = 0;
+		coef |= conf->iir.coeff_set1[index];
+		coef |= conf->iir.coeff_set1[index + 1] <<
+			AF_COEF_SHIFT;
+		isp_reg_writel(af->isp, coef, OMAP3_ISP_IOMEM_H3A,
+			       base_coef_set1);
+		base_coef_set1 += AFCOEF_OFFSET;
+	}
+	/* set AFCOEF0010 Register */
+	isp_reg_writel(af->isp, conf->iir.coeff_set0[10],
+		       OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF0010);
+	/* set AFCOEF1010 Register */
+	isp_reg_writel(af->isp, conf->iir.coeff_set1[10],
+		       OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF1010);
+
+	/* PCR Register */
+	/* Set RGB Position */
+	pcr = conf->rgb_pos << AF_RGBPOS_SHIFT;
+	/* Set Accumulator Mode */
+	if (conf->fvmode == OMAP3ISP_AF_MODE_PEAK)
+		pcr |= AF_FVMODE;
+	/* Set A-law */
+	if (conf->alaw_enable)
+		pcr |= AF_ALAW_EN;
+	/* HMF Configurations */
+	if (conf->hmf.enable) {
+		/* Enable HMF */
+		pcr |= AF_MED_EN;
+		/* Set Median Threshold */
+		pcr |= conf->hmf.threshold << AF_MED_TH_SHIFT;
+	}
+	/* Set PCR Register */
+	isp_reg_clr_set(af->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR,
+			AF_PCR_MASK, pcr);
+
+	af->update = 0;
+	af->config_counter += af->inc_config;
+	af->inc_config = 0;
+	af->buf_size = conf->buf_size;
+}
+
+static void h3a_af_enable(struct ispstat *af, int enable)
+{
+	if (enable) {
+		isp_reg_set(af->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR,
+			    ISPH3A_PCR_AF_EN);
+		/* This bit is already set if AEWB is enabled */
+		if (af->isp->isp_aewb.state != ISPSTAT_ENABLED)
+			isp_reg_set(af->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
+				    ISPCTRL_H3A_CLK_EN);
+	} else {
+		isp_reg_clr(af->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR,
+			    ISPH3A_PCR_AF_EN);
+		/* This bit can't be cleared if AEWB is enabled */
+		if (af->isp->isp_aewb.state != ISPSTAT_ENABLED)
+			isp_reg_clr(af->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
+				    ISPCTRL_H3A_CLK_EN);
+	}
+}
+
+static int h3a_af_busy(struct ispstat *af)
+{
+	return isp_reg_readl(af->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR)
+						& ISPH3A_PCR_BUSYAF;
+}
+
+static u32 h3a_af_get_buf_size(struct omap3isp_h3a_af_config *conf)
+{
+	return conf->paxel.h_cnt * conf->paxel.v_cnt * OMAP3ISP_AF_PAXEL_SIZE;
+}
+
+/* Function to check paxel parameters */
+static int h3a_af_validate_params(struct ispstat *af, void *new_conf)
+{
+	struct omap3isp_h3a_af_config *user_cfg = new_conf;
+	struct omap3isp_h3a_af_paxel *paxel_cfg = &user_cfg->paxel;
+	struct omap3isp_h3a_af_iir *iir_cfg = &user_cfg->iir;
+	int index;
+	u32 buf_size;
+
+	/* Check horizontal Count */
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->h_cnt,
+			     OMAP3ISP_AF_PAXEL_HORIZONTAL_COUNT_MIN,
+			     OMAP3ISP_AF_PAXEL_HORIZONTAL_COUNT_MAX))
+		return -EINVAL;
+
+	/* Check Vertical Count */
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->v_cnt,
+			     OMAP3ISP_AF_PAXEL_VERTICAL_COUNT_MIN,
+			     OMAP3ISP_AF_PAXEL_VERTICAL_COUNT_MAX))
+		return -EINVAL;
+
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->height, OMAP3ISP_AF_PAXEL_HEIGHT_MIN,
+			     OMAP3ISP_AF_PAXEL_HEIGHT_MAX) ||
+	    paxel_cfg->height % 2)
+		return -EINVAL;
+
+	/* Check width */
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->width, OMAP3ISP_AF_PAXEL_WIDTH_MIN,
+			     OMAP3ISP_AF_PAXEL_WIDTH_MAX) ||
+	    paxel_cfg->width % 2)
+		return -EINVAL;
+
+	/* Check Line Increment */
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->line_inc,
+			     OMAP3ISP_AF_PAXEL_INCREMENT_MIN,
+			     OMAP3ISP_AF_PAXEL_INCREMENT_MAX) ||
+	    paxel_cfg->line_inc % 2)
+		return -EINVAL;
+
+	/* Check Horizontal Start */
+	if ((paxel_cfg->h_start < iir_cfg->h_start) ||
+	    IS_OUT_OF_BOUNDS(paxel_cfg->h_start,
+			     OMAP3ISP_AF_PAXEL_HZSTART_MIN,
+			     OMAP3ISP_AF_PAXEL_HZSTART_MAX))
+		return -EINVAL;
+
+	/* Check IIR */
+	for (index = 0; index < OMAP3ISP_AF_NUM_COEF; index++) {
+		if ((iir_cfg->coeff_set0[index]) > OMAP3ISP_AF_COEF_MAX)
+			return -EINVAL;
+
+		if ((iir_cfg->coeff_set1[index]) > OMAP3ISP_AF_COEF_MAX)
+			return -EINVAL;
+	}
+
+	if (IS_OUT_OF_BOUNDS(iir_cfg->h_start, OMAP3ISP_AF_IIRSH_MIN,
+			     OMAP3ISP_AF_IIRSH_MAX))
+		return -EINVAL;
+
+	/* Hack: If paxel size is 12, the 10th AF window may be corrupted */
+	if ((paxel_cfg->h_cnt * paxel_cfg->v_cnt > 9) &&
+	    (paxel_cfg->width * paxel_cfg->height == 12))
+		return -EINVAL;
+
+	buf_size = h3a_af_get_buf_size(user_cfg);
+	if (buf_size > user_cfg->buf_size)
+		/* User buf_size request wasn't enough */
+		user_cfg->buf_size = buf_size;
+	else if (user_cfg->buf_size > OMAP3ISP_AF_MAX_BUF_SIZE)
+		user_cfg->buf_size = OMAP3ISP_AF_MAX_BUF_SIZE;
+
+	return 0;
+}
+
+/* Update local parameters */
+static void h3a_af_set_params(struct ispstat *af, void *new_conf)
+{
+	struct omap3isp_h3a_af_config *user_cfg = new_conf;
+	struct omap3isp_h3a_af_config *cur_cfg = af->priv;
+	int update = 0;
+	int index;
+
+	/* alaw */
+	if (cur_cfg->alaw_enable != user_cfg->alaw_enable) {
+		update = 1;
+		goto out;
+	}
+
+	/* hmf */
+	if (cur_cfg->hmf.enable != user_cfg->hmf.enable) {
+		update = 1;
+		goto out;
+	}
+	if (cur_cfg->hmf.threshold != user_cfg->hmf.threshold) {
+		update = 1;
+		goto out;
+	}
+
+	/* rgbpos */
+	if (cur_cfg->rgb_pos != user_cfg->rgb_pos) {
+		update = 1;
+		goto out;
+	}
+
+	/* iir */
+	if (cur_cfg->iir.h_start != user_cfg->iir.h_start) {
+		update = 1;
+		goto out;
+	}
+	for (index = 0; index < OMAP3ISP_AF_NUM_COEF; index++) {
+		if (cur_cfg->iir.coeff_set0[index] !=
+				user_cfg->iir.coeff_set0[index]) {
+			update = 1;
+			goto out;
+		}
+		if (cur_cfg->iir.coeff_set1[index] !=
+				user_cfg->iir.coeff_set1[index]) {
+			update = 1;
+			goto out;
+		}
+	}
+
+	/* paxel */
+	if ((cur_cfg->paxel.width != user_cfg->paxel.width) ||
+	    (cur_cfg->paxel.height != user_cfg->paxel.height) ||
+	    (cur_cfg->paxel.h_start != user_cfg->paxel.h_start) ||
+	    (cur_cfg->paxel.v_start != user_cfg->paxel.v_start) ||
+	    (cur_cfg->paxel.h_cnt != user_cfg->paxel.h_cnt) ||
+	    (cur_cfg->paxel.v_cnt != user_cfg->paxel.v_cnt) ||
+	    (cur_cfg->paxel.line_inc != user_cfg->paxel.line_inc)) {
+		update = 1;
+		goto out;
+	}
+
+	/* af_mode */
+	if (cur_cfg->fvmode != user_cfg->fvmode)
+		update = 1;
+
+out:
+	if (update || !af->configured) {
+		memcpy(cur_cfg, user_cfg, sizeof(*cur_cfg));
+		af->inc_config++;
+		af->update = 1;
+		/*
+		 * User might be asked for a bigger buffer than necessary for
+		 * this configuration. In order to return the right amount of
+		 * data during buffer request, let's calculate the size here
+		 * instead of stick with user_cfg->buf_size.
+		 */
+		cur_cfg->buf_size = h3a_af_get_buf_size(cur_cfg);
+	}
+}
+
+static long h3a_af_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct ispstat *stat = v4l2_get_subdevdata(sd);
+
+	switch (cmd) {
+	case VIDIOC_OMAP3ISP_AF_CFG:
+		return omap3isp_stat_config(stat, arg);
+	case VIDIOC_OMAP3ISP_STAT_REQ:
+		return omap3isp_stat_request_statistics(stat, arg);
+	case VIDIOC_OMAP3ISP_STAT_EN: {
+		int *en = arg;
+		return omap3isp_stat_enable(stat, !!*en);
+	}
+	}
+
+	return -ENOIOCTLCMD;
+
+}
+
+static const struct ispstat_ops h3a_af_ops = {
+	.validate_params	= h3a_af_validate_params,
+	.set_params		= h3a_af_set_params,
+	.setup_regs		= h3a_af_setup_regs,
+	.enable			= h3a_af_enable,
+	.busy			= h3a_af_busy,
+};
+
+static const struct v4l2_subdev_core_ops h3a_af_subdev_core_ops = {
+	.ioctl = h3a_af_ioctl,
+	.subscribe_event = omap3isp_stat_subscribe_event,
+	.unsubscribe_event = omap3isp_stat_unsubscribe_event,
+};
+
+static const struct v4l2_subdev_video_ops h3a_af_subdev_video_ops = {
+	.s_stream = omap3isp_stat_s_stream,
+};
+
+static const struct v4l2_subdev_ops h3a_af_subdev_ops = {
+	.core = &h3a_af_subdev_core_ops,
+	.video = &h3a_af_subdev_video_ops,
+};
+
+/* Function to register the AF character device driver. */
+int omap3isp_h3a_af_init(struct isp_device *isp)
+{
+	struct ispstat *af = &isp->isp_af;
+	struct omap3isp_h3a_af_config *af_cfg;
+	struct omap3isp_h3a_af_config *af_recover_cfg;
+	int ret;
+
+	af_cfg = kzalloc(sizeof(*af_cfg), GFP_KERNEL);
+	if (af_cfg == NULL)
+		return -ENOMEM;
+
+	memset(af, 0, sizeof(*af));
+	af->ops = &h3a_af_ops;
+	af->priv = af_cfg;
+	af->dma_ch = -1;
+	af->event_type = V4L2_EVENT_OMAP3ISP_AF;
+	af->isp = isp;
+
+	/* Set recover state configuration */
+	af_recover_cfg = kzalloc(sizeof(*af_recover_cfg), GFP_KERNEL);
+	if (!af_recover_cfg) {
+		dev_err(af->isp->dev, "AF: cannot allocate memory for recover "
+				      "configuration.\n");
+		ret = -ENOMEM;
+		goto err_recover_alloc;
+	}
+
+	af_recover_cfg->paxel.h_start = OMAP3ISP_AF_PAXEL_HZSTART_MIN;
+	af_recover_cfg->paxel.width = OMAP3ISP_AF_PAXEL_WIDTH_MIN;
+	af_recover_cfg->paxel.height = OMAP3ISP_AF_PAXEL_HEIGHT_MIN;
+	af_recover_cfg->paxel.h_cnt = OMAP3ISP_AF_PAXEL_HORIZONTAL_COUNT_MIN;
+	af_recover_cfg->paxel.v_cnt = OMAP3ISP_AF_PAXEL_VERTICAL_COUNT_MIN;
+	af_recover_cfg->paxel.line_inc = OMAP3ISP_AF_PAXEL_INCREMENT_MIN;
+	if (h3a_af_validate_params(af, af_recover_cfg)) {
+		dev_err(af->isp->dev, "AF: recover configuration is "
+				      "invalid.\n");
+		ret = -EINVAL;
+		goto err_conf;
+	}
+
+	af_recover_cfg->buf_size = h3a_af_get_buf_size(af_recover_cfg);
+	af->recover_priv = af_recover_cfg;
+
+	ret = omap3isp_stat_init(af, "AF", &h3a_af_subdev_ops);
+	if (ret)
+		goto err_conf;
+
+	return 0;
+
+err_conf:
+	kfree(af_recover_cfg);
+err_recover_alloc:
+	kfree(af_cfg);
+
+	return ret;
+}
+
+void omap3isp_h3a_af_cleanup(struct isp_device *isp)
+{
+	kfree(isp->isp_af.priv);
+	kfree(isp->isp_af.recover_priv);
+	omap3isp_stat_free(&isp->isp_af);
+}
diff --git a/drivers/media/video/omap3-isp/isphist.c b/drivers/media/video/omap3-isp/isphist.c
new file mode 100644
index 0000000..1743856
--- /dev/null
+++ b/drivers/media/video/omap3-isp/isphist.c
@@ -0,0 +1,520 @@
+/*
+ * isphist.c
+ *
+ * TI OMAP3 ISP - Histogram module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: David Cohen <dacohen@gmail.com>
+ *	     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/device.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "isphist.h"
+
+#define HIST_CONFIG_DMA	1
+
+#define HIST_USING_DMA(hist) ((hist)->dma_ch >= 0)
+
+/*
+ * hist_reset_mem - clear Histogram memory before start stats engine.
+ */
+static void hist_reset_mem(struct ispstat *hist)
+{
+	struct isp_device *isp = hist->isp;
+	struct omap3isp_hist_config *conf = hist->priv;
+	unsigned int i;
+
+	isp_reg_writel(isp, 0, OMAP3_ISP_IOMEM_HIST, ISPHIST_ADDR);
+
+	/*
+	 * By setting it, the histogram internal buffer is being cleared at the
+	 * same time it's being read. This bit must be cleared afterwards.
+	 */
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT, ISPHIST_CNT_CLEAR);
+
+	/*
+	 * We'll clear 4 words at each iteration for optimization. It avoids
+	 * 3/4 of the jumps. We also know HIST_MEM_SIZE is divisible by 4.
+	 */
+	for (i = OMAP3ISP_HIST_MEM_SIZE / 4; i > 0; i--) {
+		isp_reg_readl(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_DATA);
+		isp_reg_readl(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_DATA);
+		isp_reg_readl(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_DATA);
+		isp_reg_readl(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_DATA);
+	}
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT, ISPHIST_CNT_CLEAR);
+
+	hist->wait_acc_frames = conf->num_acc_frames;
+}
+
+static void hist_dma_config(struct ispstat *hist)
+{
+	hist->dma_config.data_type = OMAP_DMA_DATA_TYPE_S32;
+	hist->dma_config.sync_mode = OMAP_DMA_SYNC_ELEMENT;
+	hist->dma_config.frame_count = 1;
+	hist->dma_config.src_amode = OMAP_DMA_AMODE_CONSTANT;
+	hist->dma_config.src_start = OMAP3ISP_HIST_REG_BASE + ISPHIST_DATA;
+	hist->dma_config.dst_amode = OMAP_DMA_AMODE_POST_INC;
+	hist->dma_config.src_or_dst_synch = OMAP_DMA_SRC_SYNC;
+}
+
+/*
+ * hist_setup_regs - Helper function to update Histogram registers.
+ */
+static void hist_setup_regs(struct ispstat *hist, void *priv)
+{
+	struct isp_device *isp = hist->isp;
+	struct omap3isp_hist_config *conf = priv;
+	int c;
+	u32 cnt;
+	u32 wb_gain;
+	u32 reg_hor[OMAP3ISP_HIST_MAX_REGIONS];
+	u32 reg_ver[OMAP3ISP_HIST_MAX_REGIONS];
+
+	if (!hist->update || hist->state == ISPSTAT_DISABLED ||
+	    hist->state == ISPSTAT_DISABLING)
+		return;
+
+	cnt = conf->cfa << ISPHIST_CNT_CFA_SHIFT;
+
+	wb_gain = conf->wg[0] << ISPHIST_WB_GAIN_WG00_SHIFT;
+	wb_gain |= conf->wg[1] << ISPHIST_WB_GAIN_WG01_SHIFT;
+	wb_gain |= conf->wg[2] << ISPHIST_WB_GAIN_WG02_SHIFT;
+	if (conf->cfa == OMAP3ISP_HIST_CFA_BAYER)
+		wb_gain |= conf->wg[3] << ISPHIST_WB_GAIN_WG03_SHIFT;
+
+	/* Regions size and position */
+	for (c = 0; c < OMAP3ISP_HIST_MAX_REGIONS; c++) {
+		if (c < conf->num_regions) {
+			reg_hor[c] = conf->region[c].h_start <<
+				     ISPHIST_REG_START_SHIFT;
+			reg_hor[c] = conf->region[c].h_end <<
+				     ISPHIST_REG_END_SHIFT;
+			reg_ver[c] = conf->region[c].v_start <<
+				     ISPHIST_REG_START_SHIFT;
+			reg_ver[c] = conf->region[c].v_end <<
+				     ISPHIST_REG_END_SHIFT;
+		} else {
+			reg_hor[c] = 0;
+			reg_ver[c] = 0;
+		}
+	}
+
+	cnt |= conf->hist_bins << ISPHIST_CNT_BINS_SHIFT;
+	switch (conf->hist_bins) {
+	case OMAP3ISP_HIST_BINS_256:
+		cnt |= (ISPHIST_IN_BIT_WIDTH_CCDC - 8) <<
+			ISPHIST_CNT_SHIFT_SHIFT;
+		break;
+	case OMAP3ISP_HIST_BINS_128:
+		cnt |= (ISPHIST_IN_BIT_WIDTH_CCDC - 7) <<
+			ISPHIST_CNT_SHIFT_SHIFT;
+		break;
+	case OMAP3ISP_HIST_BINS_64:
+		cnt |= (ISPHIST_IN_BIT_WIDTH_CCDC - 6) <<
+			ISPHIST_CNT_SHIFT_SHIFT;
+		break;
+	default: /* OMAP3ISP_HIST_BINS_32 */
+		cnt |= (ISPHIST_IN_BIT_WIDTH_CCDC - 5) <<
+			ISPHIST_CNT_SHIFT_SHIFT;
+		break;
+	}
+
+	hist_reset_mem(hist);
+
+	isp_reg_writel(isp, cnt, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT);
+	isp_reg_writel(isp, wb_gain,  OMAP3_ISP_IOMEM_HIST, ISPHIST_WB_GAIN);
+	isp_reg_writel(isp, reg_hor[0], OMAP3_ISP_IOMEM_HIST, ISPHIST_R0_HORZ);
+	isp_reg_writel(isp, reg_ver[0], OMAP3_ISP_IOMEM_HIST, ISPHIST_R0_VERT);
+	isp_reg_writel(isp, reg_hor[1], OMAP3_ISP_IOMEM_HIST, ISPHIST_R1_HORZ);
+	isp_reg_writel(isp, reg_ver[1], OMAP3_ISP_IOMEM_HIST, ISPHIST_R1_VERT);
+	isp_reg_writel(isp, reg_hor[2], OMAP3_ISP_IOMEM_HIST, ISPHIST_R2_HORZ);
+	isp_reg_writel(isp, reg_ver[2], OMAP3_ISP_IOMEM_HIST, ISPHIST_R2_VERT);
+	isp_reg_writel(isp, reg_hor[3], OMAP3_ISP_IOMEM_HIST, ISPHIST_R3_HORZ);
+	isp_reg_writel(isp, reg_ver[3], OMAP3_ISP_IOMEM_HIST, ISPHIST_R3_VERT);
+
+	hist->update = 0;
+	hist->config_counter += hist->inc_config;
+	hist->inc_config = 0;
+	hist->buf_size = conf->buf_size;
+}
+
+static void hist_enable(struct ispstat *hist, int enable)
+{
+	if (enable) {
+		isp_reg_set(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_PCR,
+			    ISPHIST_PCR_ENABLE);
+		isp_reg_set(hist->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
+			    ISPCTRL_HIST_CLK_EN);
+	} else {
+		isp_reg_clr(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_PCR,
+			    ISPHIST_PCR_ENABLE);
+		isp_reg_clr(hist->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
+			    ISPCTRL_HIST_CLK_EN);
+	}
+}
+
+static int hist_busy(struct ispstat *hist)
+{
+	return isp_reg_readl(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_PCR)
+						& ISPHIST_PCR_BUSY;
+}
+
+static void hist_dma_cb(int lch, u16 ch_status, void *data)
+{
+	struct ispstat *hist = data;
+
+	if (ch_status & ~OMAP_DMA_BLOCK_IRQ) {
+		dev_dbg(hist->isp->dev, "hist: DMA error. status = 0x%04x\n",
+			ch_status);
+		omap_stop_dma(lch);
+		hist_reset_mem(hist);
+		atomic_set(&hist->buf_err, 1);
+	}
+	isp_reg_clr(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT,
+		    ISPHIST_CNT_CLEAR);
+
+	omap3isp_stat_dma_isr(hist);
+	if (hist->state != ISPSTAT_DISABLED)
+		omap3isp_hist_dma_done(hist->isp);
+}
+
+static int hist_buf_dma(struct ispstat *hist)
+{
+	dma_addr_t dma_addr = hist->active_buf->dma_addr;
+
+	if (unlikely(!dma_addr)) {
+		dev_dbg(hist->isp->dev, "hist: invalid DMA buffer address\n");
+		hist_reset_mem(hist);
+		return STAT_NO_BUF;
+	}
+
+	isp_reg_writel(hist->isp, 0, OMAP3_ISP_IOMEM_HIST, ISPHIST_ADDR);
+	isp_reg_set(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT,
+		    ISPHIST_CNT_CLEAR);
+	omap3isp_flush(hist->isp);
+	hist->dma_config.dst_start = dma_addr;
+	hist->dma_config.elem_count = hist->buf_size / sizeof(u32);
+	omap_set_dma_params(hist->dma_ch, &hist->dma_config);
+
+	omap_start_dma(hist->dma_ch);
+
+	return STAT_BUF_WAITING_DMA;
+}
+
+static int hist_buf_pio(struct ispstat *hist)
+{
+	struct isp_device *isp = hist->isp;
+	u32 *buf = hist->active_buf->virt_addr;
+	unsigned int i;
+
+	if (!buf) {
+		dev_dbg(isp->dev, "hist: invalid PIO buffer address\n");
+		hist_reset_mem(hist);
+		return STAT_NO_BUF;
+	}
+
+	isp_reg_writel(isp, 0, OMAP3_ISP_IOMEM_HIST, ISPHIST_ADDR);
+
+	/*
+	 * By setting it, the histogram internal buffer is being cleared at the
+	 * same time it's being read. This bit must be cleared just after all
+	 * data is acquired.
+	 */
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT, ISPHIST_CNT_CLEAR);
+
+	/*
+	 * We'll read 4 times a 4-bytes-word at each iteration for
+	 * optimization. It avoids 3/4 of the jumps. We also know buf_size is
+	 * divisible by 16.
+	 */
+	for (i = hist->buf_size / 16; i > 0; i--) {
+		*buf++ = isp_reg_readl(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_DATA);
+		*buf++ = isp_reg_readl(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_DATA);
+		*buf++ = isp_reg_readl(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_DATA);
+		*buf++ = isp_reg_readl(isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_DATA);
+	}
+	isp_reg_clr(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT,
+		    ISPHIST_CNT_CLEAR);
+
+	return STAT_BUF_DONE;
+}
+
+/*
+ * hist_buf_process - Callback from ISP driver for HIST interrupt.
+ */
+static int hist_buf_process(struct ispstat *hist)
+{
+	struct omap3isp_hist_config *user_cfg = hist->priv;
+	int ret;
+
+	if (atomic_read(&hist->buf_err) || hist->state != ISPSTAT_ENABLED) {
+		hist_reset_mem(hist);
+		return STAT_NO_BUF;
+	}
+
+	if (--(hist->wait_acc_frames))
+		return STAT_NO_BUF;
+
+	if (HIST_USING_DMA(hist))
+		ret = hist_buf_dma(hist);
+	else
+		ret = hist_buf_pio(hist);
+
+	hist->wait_acc_frames = user_cfg->num_acc_frames;
+
+	return ret;
+}
+
+static u32 hist_get_buf_size(struct omap3isp_hist_config *conf)
+{
+	return OMAP3ISP_HIST_MEM_SIZE_BINS(conf->hist_bins) * conf->num_regions;
+}
+
+/*
+ * hist_validate_params - Helper function to check user given params.
+ * @user_cfg: Pointer to user configuration structure.
+ *
+ * Returns 0 on success configuration.
+ */
+static int hist_validate_params(struct ispstat *hist, void *new_conf)
+{
+	struct omap3isp_hist_config *user_cfg = new_conf;
+	int c;
+	u32 buf_size;
+
+	if (user_cfg->cfa > OMAP3ISP_HIST_CFA_FOVEONX3)
+		return -EINVAL;
+
+	/* Regions size and position */
+
+	if ((user_cfg->num_regions < OMAP3ISP_HIST_MIN_REGIONS) ||
+	    (user_cfg->num_regions > OMAP3ISP_HIST_MAX_REGIONS))
+		return -EINVAL;
+
+	/* Regions */
+	for (c = 0; c < user_cfg->num_regions; c++) {
+		if (user_cfg->region[c].h_start & ~ISPHIST_REG_START_END_MASK)
+			return -EINVAL;
+		if (user_cfg->region[c].h_end & ~ISPHIST_REG_START_END_MASK)
+			return -EINVAL;
+		if (user_cfg->region[c].v_start & ~ISPHIST_REG_START_END_MASK)
+			return -EINVAL;
+		if (user_cfg->region[c].v_end & ~ISPHIST_REG_START_END_MASK)
+			return -EINVAL;
+		if (user_cfg->region[c].h_start > user_cfg->region[c].h_end)
+			return -EINVAL;
+		if (user_cfg->region[c].v_start > user_cfg->region[c].v_end)
+			return -EINVAL;
+	}
+
+	switch (user_cfg->num_regions) {
+	case 1:
+		if (user_cfg->hist_bins > OMAP3ISP_HIST_BINS_256)
+			return -EINVAL;
+		break;
+	case 2:
+		if (user_cfg->hist_bins > OMAP3ISP_HIST_BINS_128)
+			return -EINVAL;
+		break;
+	default: /* 3 or 4 */
+		if (user_cfg->hist_bins > OMAP3ISP_HIST_BINS_64)
+			return -EINVAL;
+		break;
+	}
+
+	buf_size = hist_get_buf_size(user_cfg);
+	if (buf_size > user_cfg->buf_size)
+		/* User's buf_size request wasn't enoght */
+		user_cfg->buf_size = buf_size;
+	else if (user_cfg->buf_size > OMAP3ISP_HIST_MAX_BUF_SIZE)
+		user_cfg->buf_size = OMAP3ISP_HIST_MAX_BUF_SIZE;
+
+	return 0;
+}
+
+static int hist_comp_params(struct ispstat *hist,
+			    struct omap3isp_hist_config *user_cfg)
+{
+	struct omap3isp_hist_config *cur_cfg = hist->priv;
+	int c;
+
+	if (cur_cfg->cfa != user_cfg->cfa)
+		return 1;
+
+	if (cur_cfg->num_acc_frames != user_cfg->num_acc_frames)
+		return 1;
+
+	if (cur_cfg->hist_bins != user_cfg->hist_bins)
+		return 1;
+
+	for (c = 0; c < OMAP3ISP_HIST_MAX_WG; c++) {
+		if (c == 3 && user_cfg->cfa == OMAP3ISP_HIST_CFA_FOVEONX3)
+			break;
+		else if (cur_cfg->wg[c] != user_cfg->wg[c])
+			return 1;
+	}
+
+	if (cur_cfg->num_regions != user_cfg->num_regions)
+		return 1;
+
+	/* Regions */
+	for (c = 0; c < user_cfg->num_regions; c++) {
+		if (cur_cfg->region[c].h_start != user_cfg->region[c].h_start)
+			return 1;
+		if (cur_cfg->region[c].h_end != user_cfg->region[c].h_end)
+			return 1;
+		if (cur_cfg->region[c].v_start != user_cfg->region[c].v_start)
+			return 1;
+		if (cur_cfg->region[c].v_end != user_cfg->region[c].v_end)
+			return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * hist_update_params - Helper function to check and store user given params.
+ * @new_conf: Pointer to user configuration structure.
+ */
+static void hist_set_params(struct ispstat *hist, void *new_conf)
+{
+	struct omap3isp_hist_config *user_cfg = new_conf;
+	struct omap3isp_hist_config *cur_cfg = hist->priv;
+
+	if (!hist->configured || hist_comp_params(hist, user_cfg)) {
+		memcpy(cur_cfg, user_cfg, sizeof(*user_cfg));
+		if (user_cfg->num_acc_frames == 0)
+			user_cfg->num_acc_frames = 1;
+		hist->inc_config++;
+		hist->update = 1;
+		/*
+		 * User might be asked for a bigger buffer than necessary for
+		 * this configuration. In order to return the right amount of
+		 * data during buffer request, let's calculate the size here
+		 * instead of stick with user_cfg->buf_size.
+		 */
+		cur_cfg->buf_size = hist_get_buf_size(cur_cfg);
+
+	}
+}
+
+static long hist_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct ispstat *stat = v4l2_get_subdevdata(sd);
+
+	switch (cmd) {
+	case VIDIOC_OMAP3ISP_HIST_CFG:
+		return omap3isp_stat_config(stat, arg);
+	case VIDIOC_OMAP3ISP_STAT_REQ:
+		return omap3isp_stat_request_statistics(stat, arg);
+	case VIDIOC_OMAP3ISP_STAT_EN: {
+		int *en = arg;
+		return omap3isp_stat_enable(stat, !!*en);
+	}
+	}
+
+	return -ENOIOCTLCMD;
+
+}
+
+static const struct ispstat_ops hist_ops = {
+	.validate_params	= hist_validate_params,
+	.set_params		= hist_set_params,
+	.setup_regs		= hist_setup_regs,
+	.enable			= hist_enable,
+	.busy			= hist_busy,
+	.buf_process		= hist_buf_process,
+};
+
+static const struct v4l2_subdev_core_ops hist_subdev_core_ops = {
+	.ioctl = hist_ioctl,
+	.subscribe_event = omap3isp_stat_subscribe_event,
+	.unsubscribe_event = omap3isp_stat_unsubscribe_event,
+};
+
+static const struct v4l2_subdev_video_ops hist_subdev_video_ops = {
+	.s_stream = omap3isp_stat_s_stream,
+};
+
+static const struct v4l2_subdev_ops hist_subdev_ops = {
+	.core = &hist_subdev_core_ops,
+	.video = &hist_subdev_video_ops,
+};
+
+/*
+ * omap3isp_hist_init - Module Initialization.
+ */
+int omap3isp_hist_init(struct isp_device *isp)
+{
+	struct ispstat *hist = &isp->isp_hist;
+	struct omap3isp_hist_config *hist_cfg;
+	int ret = -1;
+
+	hist_cfg = kzalloc(sizeof(*hist_cfg), GFP_KERNEL);
+	if (hist_cfg == NULL)
+		return -ENOMEM;
+
+	memset(hist, 0, sizeof(*hist));
+	if (HIST_CONFIG_DMA)
+		ret = omap_request_dma(OMAP24XX_DMA_NO_DEVICE, "DMA_ISP_HIST",
+				       hist_dma_cb, hist, &hist->dma_ch);
+	if (ret) {
+		if (HIST_CONFIG_DMA)
+			dev_warn(isp->dev, "hist: DMA request channel failed. "
+					   "Using PIO only.\n");
+		hist->dma_ch = -1;
+	} else {
+		dev_dbg(isp->dev, "hist: DMA channel = %d\n", hist->dma_ch);
+		hist_dma_config(hist);
+		omap_enable_dma_irq(hist->dma_ch, OMAP_DMA_BLOCK_IRQ);
+	}
+
+	hist->ops = &hist_ops;
+	hist->priv = hist_cfg;
+	hist->event_type = V4L2_EVENT_OMAP3ISP_HIST;
+	hist->isp = isp;
+
+	ret = omap3isp_stat_init(hist, "histogram", &hist_subdev_ops);
+	if (ret) {
+		kfree(hist_cfg);
+		if (HIST_USING_DMA(hist))
+			omap_free_dma(hist->dma_ch);
+	}
+
+	return ret;
+}
+
+/*
+ * omap3isp_hist_cleanup - Module cleanup.
+ */
+void omap3isp_hist_cleanup(struct isp_device *isp)
+{
+	if (HIST_USING_DMA(&isp->isp_hist))
+		omap_free_dma(isp->isp_hist.dma_ch);
+	kfree(isp->isp_hist.priv);
+	omap3isp_stat_free(&isp->isp_hist);
+}
diff --git a/drivers/media/video/omap3-isp/isphist.h b/drivers/media/video/omap3-isp/isphist.h
new file mode 100644
index 0000000..0b2a38e
--- /dev/null
+++ b/drivers/media/video/omap3-isp/isphist.h
@@ -0,0 +1,40 @@
+/*
+ * isphist.h
+ *
+ * TI OMAP3 ISP - Histogram module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: David Cohen <dacohen@gmail.com>
+ *	     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_HIST_H
+#define OMAP3_ISP_HIST_H
+
+#include <linux/omap3isp.h>
+
+#define ISPHIST_IN_BIT_WIDTH_CCDC	10
+
+struct isp_device;
+
+int omap3isp_hist_init(struct isp_device *isp);
+void omap3isp_hist_cleanup(struct isp_device *isp);
+
+#endif /* OMAP3_ISP_HIST */
diff --git a/drivers/media/video/omap3-isp/ispstat.c b/drivers/media/video/omap3-isp/ispstat.c
new file mode 100644
index 0000000..b44cb68
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispstat.c
@@ -0,0 +1,1092 @@
+/*
+ * ispstat.c
+ *
+ * TI OMAP3 ISP - Statistics core
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc
+ *
+ * Contacts: David Cohen <dacohen@gmail.com>
+ *	     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "isp.h"
+
+#define IS_COHERENT_BUF(stat)	((stat)->dma_ch >= 0)
+
+/*
+ * MAGIC_SIZE must always be the greatest common divisor of
+ * AEWB_PACKET_SIZE and AF_PAXEL_SIZE.
+ */
+#define MAGIC_SIZE		16
+#define MAGIC_NUM		0x55
+
+/* HACK: AF module seems to be writing one more paxel data than it should. */
+#define AF_EXTRA_DATA		OMAP3ISP_AF_PAXEL_SIZE
+
+/*
+ * HACK: H3A modules go to an invalid state after have a SBL overflow. It makes
+ * the next buffer to start to be written in the same point where the overflow
+ * occurred instead of the configured address. The only known way to make it to
+ * go back to a valid state is having a valid buffer processing. Of course it
+ * requires at least a doubled buffer size to avoid an access to invalid memory
+ * region. But it does not fix everything. It may happen more than one
+ * consecutive SBL overflows. In that case, it might be unpredictable how many
+ * buffers the allocated memory should fit. For that case, a recover
+ * configuration was created. It produces the minimum buffer size for each H3A
+ * module and decrease the change for more SBL overflows. This recover state
+ * will be enabled every time a SBL overflow occur. As the output buffer size
+ * isn't big, it's possible to have an extra size able to fit many recover
+ * buffers making it extreamily unlikely to have an access to invalid memory
+ * region.
+ */
+#define NUM_H3A_RECOVER_BUFS	10
+
+/*
+ * HACK: Because of HW issues the generic layer sometimes need to have
+ * different behaviour for different statistic modules.
+ */
+#define IS_H3A_AF(stat)		((stat) == &(stat)->isp->isp_af)
+#define IS_H3A_AEWB(stat)	((stat) == &(stat)->isp->isp_aewb)
+#define IS_H3A(stat)		(IS_H3A_AF(stat) || IS_H3A_AEWB(stat))
+
+static void __isp_stat_buf_sync_magic(struct ispstat *stat,
+				      struct ispstat_buffer *buf,
+				      u32 buf_size, enum dma_data_direction dir,
+				      void (*dma_sync)(struct device *,
+					dma_addr_t, unsigned long, size_t,
+					enum dma_data_direction))
+{
+	struct device *dev = stat->isp->dev;
+	struct page *pg;
+	dma_addr_t dma_addr;
+	u32 offset;
+
+	/* Initial magic words */
+	pg = vmalloc_to_page(buf->virt_addr);
+	dma_addr = pfn_to_dma(dev, page_to_pfn(pg));
+	dma_sync(dev, dma_addr, 0, MAGIC_SIZE, dir);
+
+	/* Final magic words */
+	pg = vmalloc_to_page(buf->virt_addr + buf_size);
+	dma_addr = pfn_to_dma(dev, page_to_pfn(pg));
+	offset = ((u32)buf->virt_addr + buf_size) & ~PAGE_MASK;
+	dma_sync(dev, dma_addr, offset, MAGIC_SIZE, dir);
+}
+
+static void isp_stat_buf_sync_magic_for_device(struct ispstat *stat,
+					       struct ispstat_buffer *buf,
+					       u32 buf_size,
+					       enum dma_data_direction dir)
+{
+	if (IS_COHERENT_BUF(stat))
+		return;
+
+	__isp_stat_buf_sync_magic(stat, buf, buf_size, dir,
+				  dma_sync_single_range_for_device);
+}
+
+static void isp_stat_buf_sync_magic_for_cpu(struct ispstat *stat,
+					    struct ispstat_buffer *buf,
+					    u32 buf_size,
+					    enum dma_data_direction dir)
+{
+	if (IS_COHERENT_BUF(stat))
+		return;
+
+	__isp_stat_buf_sync_magic(stat, buf, buf_size, dir,
+				  dma_sync_single_range_for_cpu);
+}
+
+static int isp_stat_buf_check_magic(struct ispstat *stat,
+				    struct ispstat_buffer *buf)
+{
+	const u32 buf_size = IS_H3A_AF(stat) ?
+			     buf->buf_size + AF_EXTRA_DATA : buf->buf_size;
+	u8 *w;
+	u8 *end;
+	int ret = -EINVAL;
+
+	isp_stat_buf_sync_magic_for_cpu(stat, buf, buf_size, DMA_FROM_DEVICE);
+
+	/* Checking initial magic numbers. They shouldn't be here anymore. */
+	for (w = buf->virt_addr, end = w + MAGIC_SIZE; w < end; w++)
+		if (likely(*w != MAGIC_NUM))
+			ret = 0;
+
+	if (ret) {
+		dev_dbg(stat->isp->dev, "%s: beginning magic check does not "
+					"match.\n", stat->subdev.name);
+		return ret;
+	}
+
+	/* Checking magic numbers at the end. They must be still here. */
+	for (w = buf->virt_addr + buf_size, end = w + MAGIC_SIZE;
+	     w < end; w++) {
+		if (unlikely(*w != MAGIC_NUM)) {
+			dev_dbg(stat->isp->dev, "%s: endding magic check does "
+				"not match.\n", stat->subdev.name);
+			return -EINVAL;
+		}
+	}
+
+	isp_stat_buf_sync_magic_for_device(stat, buf, buf_size,
+					   DMA_FROM_DEVICE);
+
+	return 0;
+}
+
+static void isp_stat_buf_insert_magic(struct ispstat *stat,
+				      struct ispstat_buffer *buf)
+{
+	const u32 buf_size = IS_H3A_AF(stat) ?
+			     stat->buf_size + AF_EXTRA_DATA : stat->buf_size;
+
+	isp_stat_buf_sync_magic_for_cpu(stat, buf, buf_size, DMA_FROM_DEVICE);
+
+	/*
+	 * Inserting MAGIC_NUM at the beginning and end of the buffer.
+	 * buf->buf_size is set only after the buffer is queued. For now the
+	 * right buf_size for the current configuration is pointed by
+	 * stat->buf_size.
+	 */
+	memset(buf->virt_addr, MAGIC_NUM, MAGIC_SIZE);
+	memset(buf->virt_addr + buf_size, MAGIC_NUM, MAGIC_SIZE);
+
+	isp_stat_buf_sync_magic_for_device(stat, buf, buf_size,
+					   DMA_BIDIRECTIONAL);
+}
+
+static void isp_stat_buf_sync_for_device(struct ispstat *stat,
+					 struct ispstat_buffer *buf)
+{
+	if (IS_COHERENT_BUF(stat))
+		return;
+
+	dma_sync_sg_for_device(stat->isp->dev, buf->iovm->sgt->sgl,
+			       buf->iovm->sgt->nents, DMA_FROM_DEVICE);
+}
+
+static void isp_stat_buf_sync_for_cpu(struct ispstat *stat,
+				      struct ispstat_buffer *buf)
+{
+	if (IS_COHERENT_BUF(stat))
+		return;
+
+	dma_sync_sg_for_cpu(stat->isp->dev, buf->iovm->sgt->sgl,
+			    buf->iovm->sgt->nents, DMA_FROM_DEVICE);
+}
+
+static void isp_stat_buf_clear(struct ispstat *stat)
+{
+	int i;
+
+	for (i = 0; i < STAT_MAX_BUFS; i++)
+		stat->buf[i].empty = 1;
+}
+
+static struct ispstat_buffer *
+__isp_stat_buf_find(struct ispstat *stat, int look_empty)
+{
+	struct ispstat_buffer *found = NULL;
+	int i;
+
+	for (i = 0; i < STAT_MAX_BUFS; i++) {
+		struct ispstat_buffer *curr = &stat->buf[i];
+
+		/*
+		 * Don't select the buffer which is being copied to
+		 * userspace or used by the module.
+		 */
+		if (curr == stat->locked_buf || curr == stat->active_buf)
+			continue;
+
+		/* Don't select uninitialised buffers if it's not required */
+		if (!look_empty && curr->empty)
+			continue;
+
+		/* Pick uninitialised buffer over anything else if look_empty */
+		if (curr->empty) {
+			found = curr;
+			break;
+		}
+
+		/* Choose the oldest buffer */
+		if (!found ||
+		    (s32)curr->frame_number - (s32)found->frame_number < 0)
+			found = curr;
+	}
+
+	return found;
+}
+
+static inline struct ispstat_buffer *
+isp_stat_buf_find_oldest(struct ispstat *stat)
+{
+	return __isp_stat_buf_find(stat, 0);
+}
+
+static inline struct ispstat_buffer *
+isp_stat_buf_find_oldest_or_empty(struct ispstat *stat)
+{
+	return __isp_stat_buf_find(stat, 1);
+}
+
+static int isp_stat_buf_queue(struct ispstat *stat)
+{
+	if (!stat->active_buf)
+		return STAT_NO_BUF;
+
+	do_gettimeofday(&stat->active_buf->ts);
+
+	stat->active_buf->buf_size = stat->buf_size;
+	if (isp_stat_buf_check_magic(stat, stat->active_buf)) {
+		dev_dbg(stat->isp->dev, "%s: data wasn't properly written.\n",
+			stat->subdev.name);
+		return STAT_NO_BUF;
+	}
+	stat->active_buf->config_counter = stat->config_counter;
+	stat->active_buf->frame_number = stat->frame_number;
+	stat->active_buf->empty = 0;
+	stat->active_buf = NULL;
+
+	return STAT_BUF_DONE;
+}
+
+/* Get next free buffer to write the statistics to and mark it active. */
+static void isp_stat_buf_next(struct ispstat *stat)
+{
+	if (unlikely(stat->active_buf))
+		/* Overwriting unused active buffer */
+		dev_dbg(stat->isp->dev, "%s: new buffer requested without "
+					"queuing active one.\n",
+					stat->subdev.name);
+	else
+		stat->active_buf = isp_stat_buf_find_oldest_or_empty(stat);
+}
+
+static void isp_stat_buf_release(struct ispstat *stat)
+{
+	unsigned long flags;
+
+	isp_stat_buf_sync_for_device(stat, stat->locked_buf);
+	spin_lock_irqsave(&stat->isp->stat_lock, flags);
+	stat->locked_buf = NULL;
+	spin_unlock_irqrestore(&stat->isp->stat_lock, flags);
+}
+
+/* Get buffer to userspace. */
+static struct ispstat_buffer *isp_stat_buf_get(struct ispstat *stat,
+					       struct omap3isp_stat_data *data)
+{
+	int rval = 0;
+	unsigned long flags;
+	struct ispstat_buffer *buf;
+
+	spin_lock_irqsave(&stat->isp->stat_lock, flags);
+
+	while (1) {
+		buf = isp_stat_buf_find_oldest(stat);
+		if (!buf) {
+			spin_unlock_irqrestore(&stat->isp->stat_lock, flags);
+			dev_dbg(stat->isp->dev, "%s: cannot find a buffer.\n",
+				stat->subdev.name);
+			return ERR_PTR(-EBUSY);
+		}
+		if (isp_stat_buf_check_magic(stat, buf)) {
+			dev_dbg(stat->isp->dev, "%s: current buffer has "
+				"corrupted data\n.", stat->subdev.name);
+			/* Mark empty because it doesn't have valid data. */
+			buf->empty = 1;
+		} else {
+			/* Buffer isn't corrupted. */
+			break;
+		}
+	}
+
+	stat->locked_buf = buf;
+
+	spin_unlock_irqrestore(&stat->isp->stat_lock, flags);
+
+	if (buf->buf_size > data->buf_size) {
+		dev_warn(stat->isp->dev, "%s: userspace's buffer size is "
+					 "not enough.\n", stat->subdev.name);
+		isp_stat_buf_release(stat);
+		return ERR_PTR(-EINVAL);
+	}
+
+	isp_stat_buf_sync_for_cpu(stat, buf);
+
+	rval = copy_to_user(data->buf,
+			    buf->virt_addr,
+			    buf->buf_size);
+
+	if (rval) {
+		dev_info(stat->isp->dev,
+			 "%s: failed copying %d bytes of stat data\n",
+			 stat->subdev.name, rval);
+		buf = ERR_PTR(-EFAULT);
+		isp_stat_buf_release(stat);
+	}
+
+	return buf;
+}
+
+static void isp_stat_bufs_free(struct ispstat *stat)
+{
+	struct isp_device *isp = stat->isp;
+	int i;
+
+	for (i = 0; i < STAT_MAX_BUFS; i++) {
+		struct ispstat_buffer *buf = &stat->buf[i];
+
+		if (!IS_COHERENT_BUF(stat)) {
+			if (IS_ERR_OR_NULL((void *)buf->iommu_addr))
+				continue;
+			if (buf->iovm)
+				dma_unmap_sg(isp->dev, buf->iovm->sgt->sgl,
+					     buf->iovm->sgt->nents,
+					     DMA_FROM_DEVICE);
+			iommu_vfree(isp->iommu, buf->iommu_addr);
+		} else {
+			if (!buf->virt_addr)
+				continue;
+			dma_free_coherent(stat->isp->dev, stat->buf_alloc_size,
+					  buf->virt_addr, buf->dma_addr);
+		}
+		buf->iommu_addr = 0;
+		buf->iovm = NULL;
+		buf->dma_addr = 0;
+		buf->virt_addr = NULL;
+		buf->empty = 1;
+	}
+
+	dev_dbg(stat->isp->dev, "%s: all buffers were freed.\n",
+		stat->subdev.name);
+
+	stat->buf_alloc_size = 0;
+	stat->active_buf = NULL;
+}
+
+static int isp_stat_bufs_alloc_iommu(struct ispstat *stat, unsigned int size)
+{
+	struct isp_device *isp = stat->isp;
+	int i;
+
+	stat->buf_alloc_size = size;
+
+	for (i = 0; i < STAT_MAX_BUFS; i++) {
+		struct ispstat_buffer *buf = &stat->buf[i];
+		struct iovm_struct *iovm;
+
+		WARN_ON(buf->dma_addr);
+		buf->iommu_addr = iommu_vmalloc(isp->iommu, 0, size,
+						IOMMU_FLAG);
+		if (IS_ERR((void *)buf->iommu_addr)) {
+			dev_err(stat->isp->dev,
+				 "%s: Can't acquire memory for "
+				 "buffer %d\n", stat->subdev.name, i);
+			isp_stat_bufs_free(stat);
+			return -ENOMEM;
+		}
+
+		iovm = find_iovm_area(isp->iommu, buf->iommu_addr);
+		if (!iovm ||
+		    !dma_map_sg(isp->dev, iovm->sgt->sgl, iovm->sgt->nents,
+				DMA_FROM_DEVICE)) {
+			isp_stat_bufs_free(stat);
+			return -ENOMEM;
+		}
+		buf->iovm = iovm;
+
+		buf->virt_addr = da_to_va(stat->isp->iommu,
+					  (u32)buf->iommu_addr);
+		buf->empty = 1;
+		dev_dbg(stat->isp->dev, "%s: buffer[%d] allocated."
+			"iommu_addr=0x%08lx virt_addr=0x%08lx",
+			stat->subdev.name, i, buf->iommu_addr,
+			(unsigned long)buf->virt_addr);
+	}
+
+	return 0;
+}
+
+static int isp_stat_bufs_alloc_dma(struct ispstat *stat, unsigned int size)
+{
+	int i;
+
+	stat->buf_alloc_size = size;
+
+	for (i = 0; i < STAT_MAX_BUFS; i++) {
+		struct ispstat_buffer *buf = &stat->buf[i];
+
+		WARN_ON(buf->iommu_addr);
+		buf->virt_addr = dma_alloc_coherent(stat->isp->dev, size,
+					&buf->dma_addr, GFP_KERNEL | GFP_DMA);
+
+		if (!buf->virt_addr || !buf->dma_addr) {
+			dev_info(stat->isp->dev,
+				 "%s: Can't acquire memory for "
+				 "DMA buffer %d\n", stat->subdev.name, i);
+			isp_stat_bufs_free(stat);
+			return -ENOMEM;
+		}
+		buf->empty = 1;
+
+		dev_dbg(stat->isp->dev, "%s: buffer[%d] allocated."
+			"dma_addr=0x%08lx virt_addr=0x%08lx\n",
+			stat->subdev.name, i, (unsigned long)buf->dma_addr,
+			(unsigned long)buf->virt_addr);
+	}
+
+	return 0;
+}
+
+static int isp_stat_bufs_alloc(struct ispstat *stat, u32 size)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&stat->isp->stat_lock, flags);
+
+	BUG_ON(stat->locked_buf != NULL);
+
+	/* Are the old buffers big enough? */
+	if (stat->buf_alloc_size >= size) {
+		spin_unlock_irqrestore(&stat->isp->stat_lock, flags);
+		return 0;
+	}
+
+	if (stat->state != ISPSTAT_DISABLED || stat->buf_processing) {
+		dev_info(stat->isp->dev,
+			 "%s: trying to allocate memory when busy\n",
+			 stat->subdev.name);
+		spin_unlock_irqrestore(&stat->isp->stat_lock, flags);
+		return -EBUSY;
+	}
+
+	spin_unlock_irqrestore(&stat->isp->stat_lock, flags);
+
+	isp_stat_bufs_free(stat);
+
+	if (IS_COHERENT_BUF(stat))
+		return isp_stat_bufs_alloc_dma(stat, size);
+	else
+		return isp_stat_bufs_alloc_iommu(stat, size);
+}
+
+static void isp_stat_queue_event(struct ispstat *stat, int err)
+{
+	struct video_device *vdev = &stat->subdev.devnode;
+	struct v4l2_event event;
+	struct omap3isp_stat_event_status *status = (void *)event.u.data;
+
+	memset(&event, 0, sizeof(event));
+	if (!err) {
+		status->frame_number = stat->frame_number;
+		status->config_counter = stat->config_counter;
+	} else {
+		status->buf_err = 1;
+	}
+	event.type = stat->event_type;
+	v4l2_event_queue(vdev, &event);
+}
+
+
+/*
+ * omap3isp_stat_request_statistics - Request statistics.
+ * @data: Pointer to return statistics data.
+ *
+ * Returns 0 if successful.
+ */
+int omap3isp_stat_request_statistics(struct ispstat *stat,
+				     struct omap3isp_stat_data *data)
+{
+	struct ispstat_buffer *buf;
+
+	if (stat->state != ISPSTAT_ENABLED) {
+		dev_dbg(stat->isp->dev, "%s: engine not enabled.\n",
+			stat->subdev.name);
+		return -EINVAL;
+	}
+
+	mutex_lock(&stat->ioctl_lock);
+	buf = isp_stat_buf_get(stat, data);
+	if (IS_ERR(buf)) {
+		mutex_unlock(&stat->ioctl_lock);
+		return PTR_ERR(buf);
+	}
+
+	data->ts = buf->ts;
+	data->config_counter = buf->config_counter;
+	data->frame_number = buf->frame_number;
+	data->buf_size = buf->buf_size;
+
+	buf->empty = 1;
+	isp_stat_buf_release(stat);
+	mutex_unlock(&stat->ioctl_lock);
+
+	return 0;
+}
+
+/*
+ * omap3isp_stat_config - Receives new statistic engine configuration.
+ * @new_conf: Pointer to config structure.
+ *
+ * Returns 0 if successful, -EINVAL if new_conf pointer is NULL, -ENOMEM if
+ * was unable to allocate memory for the buffer, or other errors if parameters
+ * are invalid.
+ */
+int omap3isp_stat_config(struct ispstat *stat, void *new_conf)
+{
+	int ret;
+	unsigned long irqflags;
+	struct ispstat_generic_config *user_cfg = new_conf;
+	u32 buf_size = user_cfg->buf_size;
+
+	if (!new_conf) {
+		dev_dbg(stat->isp->dev, "%s: configuration is NULL\n",
+			stat->subdev.name);
+		return -EINVAL;
+	}
+
+	mutex_lock(&stat->ioctl_lock);
+
+	dev_dbg(stat->isp->dev, "%s: configuring module with buffer "
+		"size=0x%08lx\n", stat->subdev.name, (unsigned long)buf_size);
+
+	ret = stat->ops->validate_params(stat, new_conf);
+	if (ret) {
+		mutex_unlock(&stat->ioctl_lock);
+		dev_dbg(stat->isp->dev, "%s: configuration values are "
+					"invalid.\n", stat->subdev.name);
+		return ret;
+	}
+
+	if (buf_size != user_cfg->buf_size)
+		dev_dbg(stat->isp->dev, "%s: driver has corrected buffer size "
+			"request to 0x%08lx\n", stat->subdev.name,
+			(unsigned long)user_cfg->buf_size);
+
+	/*
+	 * Hack: H3A modules may need a doubled buffer size to avoid access
+	 * to a invalid memory address after a SBL overflow.
+	 * The buffer size is always PAGE_ALIGNED.
+	 * Hack 2: MAGIC_SIZE is added to buf_size so a magic word can be
+	 * inserted at the end to data integrity check purpose.
+	 * Hack 3: AF module writes one paxel data more than it should, so
+	 * the buffer allocation must consider it to avoid invalid memory
+	 * access.
+	 * Hack 4: H3A need to allocate extra space for the recover state.
+	 */
+	if (IS_H3A(stat)) {
+		buf_size = user_cfg->buf_size * 2 + MAGIC_SIZE;
+		if (IS_H3A_AF(stat))
+			/*
+			 * Adding one extra paxel data size for each recover
+			 * buffer + 2 regular ones.
+			 */
+			buf_size += AF_EXTRA_DATA * (NUM_H3A_RECOVER_BUFS + 2);
+		if (stat->recover_priv) {
+			struct ispstat_generic_config *recover_cfg =
+				stat->recover_priv;
+			buf_size += recover_cfg->buf_size *
+				    NUM_H3A_RECOVER_BUFS;
+		}
+		buf_size = PAGE_ALIGN(buf_size);
+	} else { /* Histogram */
+		buf_size = PAGE_ALIGN(user_cfg->buf_size + MAGIC_SIZE);
+	}
+
+	ret = isp_stat_bufs_alloc(stat, buf_size);
+	if (ret) {
+		mutex_unlock(&stat->ioctl_lock);
+		return ret;
+	}
+
+	spin_lock_irqsave(&stat->isp->stat_lock, irqflags);
+	stat->ops->set_params(stat, new_conf);
+	spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+
+	/*
+	 * Returning the right future config_counter for this setup, so
+	 * userspace can *know* when it has been applied.
+	 */
+	user_cfg->config_counter = stat->config_counter + stat->inc_config;
+
+	/* Module has a valid configuration. */
+	stat->configured = 1;
+	dev_dbg(stat->isp->dev, "%s: module has been successfully "
+		"configured.\n", stat->subdev.name);
+
+	mutex_unlock(&stat->ioctl_lock);
+
+	return 0;
+}
+
+/*
+ * isp_stat_buf_process - Process statistic buffers.
+ * @buf_state: points out if buffer is ready to be processed. It's necessary
+ *	       because histogram needs to copy the data from internal memory
+ *	       before be able to process the buffer.
+ */
+static int isp_stat_buf_process(struct ispstat *stat, int buf_state)
+{
+	int ret = STAT_NO_BUF;
+
+	if (!atomic_add_unless(&stat->buf_err, -1, 0) &&
+	    buf_state == STAT_BUF_DONE && stat->state == ISPSTAT_ENABLED) {
+		ret = isp_stat_buf_queue(stat);
+		isp_stat_buf_next(stat);
+	}
+
+	return ret;
+}
+
+int omap3isp_stat_pcr_busy(struct ispstat *stat)
+{
+	return stat->ops->busy(stat);
+}
+
+int omap3isp_stat_busy(struct ispstat *stat)
+{
+	return omap3isp_stat_pcr_busy(stat) | stat->buf_processing |
+		(stat->state != ISPSTAT_DISABLED);
+}
+
+/*
+ * isp_stat_pcr_enable - Disables/Enables statistic engines.
+ * @pcr_enable: 0/1 - Disables/Enables the engine.
+ *
+ * Must be called from ISP driver when the module is idle and synchronized
+ * with CCDC.
+ */
+static void isp_stat_pcr_enable(struct ispstat *stat, u8 pcr_enable)
+{
+	if ((stat->state != ISPSTAT_ENABLING &&
+	     stat->state != ISPSTAT_ENABLED) && pcr_enable)
+		/* Userspace has disabled the module. Aborting. */
+		return;
+
+	stat->ops->enable(stat, pcr_enable);
+	if (stat->state == ISPSTAT_DISABLING && !pcr_enable)
+		stat->state = ISPSTAT_DISABLED;
+	else if (stat->state == ISPSTAT_ENABLING && pcr_enable)
+		stat->state = ISPSTAT_ENABLED;
+}
+
+void omap3isp_stat_suspend(struct ispstat *stat)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&stat->isp->stat_lock, flags);
+
+	if (stat->state != ISPSTAT_DISABLED)
+		stat->ops->enable(stat, 0);
+	if (stat->state == ISPSTAT_ENABLED)
+		stat->state = ISPSTAT_SUSPENDED;
+
+	spin_unlock_irqrestore(&stat->isp->stat_lock, flags);
+}
+
+void omap3isp_stat_resume(struct ispstat *stat)
+{
+	/* Module will be re-enabled with its pipeline */
+	if (stat->state == ISPSTAT_SUSPENDED)
+		stat->state = ISPSTAT_ENABLING;
+}
+
+static void isp_stat_try_enable(struct ispstat *stat)
+{
+	unsigned long irqflags;
+
+	if (stat->priv == NULL)
+		/* driver wasn't initialised */
+		return;
+
+	spin_lock_irqsave(&stat->isp->stat_lock, irqflags);
+	if (stat->state == ISPSTAT_ENABLING && !stat->buf_processing &&
+	    stat->buf_alloc_size) {
+		/*
+		 * Userspace's requested to enable the engine but it wasn't yet.
+		 * Let's do that now.
+		 */
+		stat->update = 1;
+		isp_stat_buf_next(stat);
+		stat->ops->setup_regs(stat, stat->priv);
+		isp_stat_buf_insert_magic(stat, stat->active_buf);
+
+		/*
+		 * H3A module has some hw issues which forces the driver to
+		 * ignore next buffers even if it was disabled in the meantime.
+		 * On the other hand, Histogram shouldn't ignore buffers anymore
+		 * if it's being enabled.
+		 */
+		if (!IS_H3A(stat))
+			atomic_set(&stat->buf_err, 0);
+
+		isp_stat_pcr_enable(stat, 1);
+		spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+		dev_dbg(stat->isp->dev, "%s: module is enabled.\n",
+			stat->subdev.name);
+	} else {
+		spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+	}
+}
+
+void omap3isp_stat_isr_frame_sync(struct ispstat *stat)
+{
+	isp_stat_try_enable(stat);
+}
+
+void omap3isp_stat_sbl_overflow(struct ispstat *stat)
+{
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&stat->isp->stat_lock, irqflags);
+	/*
+	 * Due to a H3A hw issue which prevents the next buffer to start from
+	 * the correct memory address, 2 buffers must be ignored.
+	 */
+	atomic_set(&stat->buf_err, 2);
+
+	/*
+	 * If more than one SBL overflow happen in a row, H3A module may access
+	 * invalid memory region.
+	 * stat->sbl_ovl_recover is set to tell to the driver to temporarily use
+	 * a soft configuration which helps to avoid consecutive overflows.
+	 */
+	if (stat->recover_priv)
+		stat->sbl_ovl_recover = 1;
+	spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+}
+
+/*
+ * omap3isp_stat_enable - Disable/Enable statistic engine as soon as possible
+ * @enable: 0/1 - Disables/Enables the engine.
+ *
+ * Client should configure all the module registers before this.
+ * This function can be called from a userspace request.
+ */
+int omap3isp_stat_enable(struct ispstat *stat, u8 enable)
+{
+	unsigned long irqflags;
+
+	dev_dbg(stat->isp->dev, "%s: user wants to %s module.\n",
+		stat->subdev.name, enable ? "enable" : "disable");
+
+	/* Prevent enabling while configuring */
+	mutex_lock(&stat->ioctl_lock);
+
+	spin_lock_irqsave(&stat->isp->stat_lock, irqflags);
+
+	if (!stat->configured && enable) {
+		spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+		mutex_unlock(&stat->ioctl_lock);
+		dev_dbg(stat->isp->dev, "%s: cannot enable module as it's "
+			"never been successfully configured so far.\n",
+			stat->subdev.name);
+		return -EINVAL;
+	}
+
+	if (enable) {
+		if (stat->state == ISPSTAT_DISABLING)
+			/* Previous disabling request wasn't done yet */
+			stat->state = ISPSTAT_ENABLED;
+		else if (stat->state == ISPSTAT_DISABLED)
+			/* Module is now being enabled */
+			stat->state = ISPSTAT_ENABLING;
+	} else {
+		if (stat->state == ISPSTAT_ENABLING) {
+			/* Previous enabling request wasn't done yet */
+			stat->state = ISPSTAT_DISABLED;
+		} else if (stat->state == ISPSTAT_ENABLED) {
+			/* Module is now being disabled */
+			stat->state = ISPSTAT_DISABLING;
+			isp_stat_buf_clear(stat);
+		}
+	}
+
+	spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+	mutex_unlock(&stat->ioctl_lock);
+
+	return 0;
+}
+
+int omap3isp_stat_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct ispstat *stat = v4l2_get_subdevdata(subdev);
+
+	if (enable) {
+		/*
+		 * Only set enable PCR bit if the module was previously
+		 * enabled through ioct.
+		 */
+		isp_stat_try_enable(stat);
+	} else {
+		unsigned long flags;
+		/* Disable PCR bit and config enable field */
+		omap3isp_stat_enable(stat, 0);
+		spin_lock_irqsave(&stat->isp->stat_lock, flags);
+		stat->ops->enable(stat, 0);
+		spin_unlock_irqrestore(&stat->isp->stat_lock, flags);
+
+		/*
+		 * If module isn't busy, a new interrupt may come or not to
+		 * set the state to DISABLED. As Histogram needs to read its
+		 * internal memory to clear it, let interrupt handler
+		 * responsible of changing state to DISABLED. If the last
+		 * interrupt is coming, it's still safe as the handler will
+		 * ignore the second time when state is already set to DISABLED.
+		 * It's necessary to synchronize Histogram with streamoff, once
+		 * the module may be considered idle before last SDMA transfer
+		 * starts if we return here.
+		 */
+		if (!omap3isp_stat_pcr_busy(stat))
+			omap3isp_stat_isr(stat);
+
+		dev_dbg(stat->isp->dev, "%s: module is being disabled\n",
+			stat->subdev.name);
+	}
+
+	return 0;
+}
+
+/*
+ * __stat_isr - Interrupt handler for statistic drivers
+ */
+static void __stat_isr(struct ispstat *stat, int from_dma)
+{
+	int ret = STAT_BUF_DONE;
+	int buf_processing;
+	unsigned long irqflags;
+	struct isp_pipeline *pipe;
+
+	/*
+	 * stat->buf_processing must be set before disable module. It's
+	 * necessary to not inform too early the buffers aren't busy in case
+	 * of SDMA is going to be used.
+	 */
+	spin_lock_irqsave(&stat->isp->stat_lock, irqflags);
+	if (stat->state == ISPSTAT_DISABLED) {
+		spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+		return;
+	}
+	buf_processing = stat->buf_processing;
+	stat->buf_processing = 1;
+	stat->ops->enable(stat, 0);
+
+	if (buf_processing && !from_dma) {
+		if (stat->state == ISPSTAT_ENABLED) {
+			spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+			dev_err(stat->isp->dev,
+				"%s: interrupt occurred when module was still "
+				"processing a buffer.\n", stat->subdev.name);
+			ret = STAT_NO_BUF;
+			goto out;
+		} else {
+			/*
+			 * Interrupt handler was called from streamoff when
+			 * the module wasn't busy anymore to ensure it is being
+			 * disabled after process last buffer. If such buffer
+			 * processing has already started, no need to do
+			 * anything else.
+			 */
+			spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+			return;
+		}
+	}
+	spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+
+	/* If it's busy we can't process this buffer anymore */
+	if (!omap3isp_stat_pcr_busy(stat)) {
+		if (!from_dma && stat->ops->buf_process)
+			/* Module still need to copy data to buffer. */
+			ret = stat->ops->buf_process(stat);
+		if (ret == STAT_BUF_WAITING_DMA)
+			/* Buffer is not ready yet */
+			return;
+
+		spin_lock_irqsave(&stat->isp->stat_lock, irqflags);
+
+		/*
+		 * Histogram needs to read its internal memory to clear it
+		 * before be disabled. For that reason, common statistic layer
+		 * can return only after call stat's buf_process() operator.
+		 */
+		if (stat->state == ISPSTAT_DISABLING) {
+			stat->state = ISPSTAT_DISABLED;
+			spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+			stat->buf_processing = 0;
+			return;
+		}
+		pipe = to_isp_pipeline(&stat->subdev.entity);
+		stat->frame_number = atomic_read(&pipe->frame_number);
+
+		/*
+		 * Before this point, 'ret' stores the buffer's status if it's
+		 * ready to be processed. Afterwards, it holds the status if
+		 * it was processed successfully.
+		 */
+		ret = isp_stat_buf_process(stat, ret);
+
+		if (likely(!stat->sbl_ovl_recover)) {
+			stat->ops->setup_regs(stat, stat->priv);
+		} else {
+			/*
+			 * Using recover config to increase the chance to have
+			 * a good buffer processing and make the H3A module to
+			 * go back to a valid state.
+			 */
+			stat->update = 1;
+			stat->ops->setup_regs(stat, stat->recover_priv);
+			stat->sbl_ovl_recover = 0;
+
+			/*
+			 * Set 'update' in case of the module needs to use
+			 * regular configuration after next buffer.
+			 */
+			stat->update = 1;
+		}
+
+		isp_stat_buf_insert_magic(stat, stat->active_buf);
+
+		/*
+		 * Hack: H3A modules may access invalid memory address or send
+		 * corrupted data to userspace if more than 1 SBL overflow
+		 * happens in a row without re-writing its buffer's start memory
+		 * address in the meantime. Such situation is avoided if the
+		 * module is not immediately re-enabled when the ISR misses the
+		 * timing to process the buffer and to setup the registers.
+		 * Because of that, pcr_enable(1) was moved to inside this 'if'
+		 * block. But the next interruption will still happen as during
+		 * pcr_enable(0) the module was busy.
+		 */
+		isp_stat_pcr_enable(stat, 1);
+		spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
+	} else {
+		/*
+		 * If a SBL overflow occurs and the H3A driver misses the timing
+		 * to process the buffer, stat->buf_err is set and won't be
+		 * cleared now. So the next buffer will be correctly ignored.
+		 * It's necessary due to a hw issue which makes the next H3A
+		 * buffer to start from the memory address where the previous
+		 * one stopped, instead of start where it was configured to.
+		 * Do not "stat->buf_err = 0" here.
+		 */
+
+		if (stat->ops->buf_process)
+			/*
+			 * Driver may need to erase current data prior to
+			 * process a new buffer. If it misses the timing, the
+			 * next buffer might be wrong. So should be ignored.
+			 * It happens only for Histogram.
+			 */
+			atomic_set(&stat->buf_err, 1);
+
+		ret = STAT_NO_BUF;
+		dev_dbg(stat->isp->dev, "%s: cannot process buffer, "
+					"device is busy.\n", stat->subdev.name);
+	}
+
+out:
+	stat->buf_processing = 0;
+	isp_stat_queue_event(stat, ret != STAT_BUF_DONE);
+}
+
+void omap3isp_stat_isr(struct ispstat *stat)
+{
+	__stat_isr(stat, 0);
+}
+
+void omap3isp_stat_dma_isr(struct ispstat *stat)
+{
+	__stat_isr(stat, 1);
+}
+
+static int isp_stat_init_entities(struct ispstat *stat, const char *name,
+				  const struct v4l2_subdev_ops *sd_ops)
+{
+	struct v4l2_subdev *subdev = &stat->subdev;
+	struct media_entity *me = &subdev->entity;
+
+	v4l2_subdev_init(subdev, sd_ops);
+	snprintf(subdev->name, V4L2_SUBDEV_NAME_SIZE, "OMAP3 ISP %s", name);
+	subdev->grp_id = 1 << 16;	/* group ID for isp subdevs */
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
+	subdev->nevents = STAT_NEVENTS;
+	v4l2_set_subdevdata(subdev, stat);
+
+	stat->pad.flags = MEDIA_PAD_FL_SINK;
+	me->ops = NULL;
+
+	return media_entity_init(me, 1, &stat->pad, 0);
+}
+
+int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
+				  struct v4l2_fh *fh,
+				  struct v4l2_event_subscription *sub)
+{
+	struct ispstat *stat = v4l2_get_subdevdata(subdev);
+
+	if (sub->type != stat->event_type)
+		return -EINVAL;
+
+	return v4l2_event_subscribe(fh, sub);
+}
+
+int omap3isp_stat_unsubscribe_event(struct v4l2_subdev *subdev,
+				    struct v4l2_fh *fh,
+				    struct v4l2_event_subscription *sub)
+{
+	return v4l2_event_unsubscribe(fh, sub);
+}
+
+void omap3isp_stat_unregister_entities(struct ispstat *stat)
+{
+	media_entity_cleanup(&stat->subdev.entity);
+	v4l2_device_unregister_subdev(&stat->subdev);
+}
+
+int omap3isp_stat_register_entities(struct ispstat *stat,
+				    struct v4l2_device *vdev)
+{
+	return v4l2_device_register_subdev(vdev, &stat->subdev);
+}
+
+int omap3isp_stat_init(struct ispstat *stat, const char *name,
+		       const struct v4l2_subdev_ops *sd_ops)
+{
+	stat->buf = kcalloc(STAT_MAX_BUFS, sizeof(*stat->buf), GFP_KERNEL);
+	if (!stat->buf)
+		return -ENOMEM;
+	isp_stat_buf_clear(stat);
+	mutex_init(&stat->ioctl_lock);
+	atomic_set(&stat->buf_err, 0);
+
+	return isp_stat_init_entities(stat, name, sd_ops);
+}
+
+void omap3isp_stat_free(struct ispstat *stat)
+{
+	isp_stat_bufs_free(stat);
+	kfree(stat->buf);
+}
diff --git a/drivers/media/video/omap3-isp/ispstat.h b/drivers/media/video/omap3-isp/ispstat.h
new file mode 100644
index 0000000..820950c
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispstat.h
@@ -0,0 +1,169 @@
+/*
+ * ispstat.h
+ *
+ * TI OMAP3 ISP - Statistics core
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc
+ *
+ * Contacts: David Cohen <dacohen@gmail.com>
+ *	     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_STAT_H
+#define OMAP3_ISP_STAT_H
+
+#include <linux/types.h>
+#include <linux/omap3isp.h>
+#include <plat/dma.h>
+#include <media/v4l2-event.h>
+
+#include "isp.h"
+#include "ispvideo.h"
+
+#define STAT_MAX_BUFS		5
+#define STAT_NEVENTS		8
+
+#define STAT_BUF_DONE		0	/* Buffer is ready */
+#define STAT_NO_BUF		1	/* An error has occurred */
+#define STAT_BUF_WAITING_DMA	2	/* Histogram only: DMA is running */
+
+struct ispstat;
+
+struct ispstat_buffer {
+	unsigned long iommu_addr;
+	struct iovm_struct *iovm;
+	void *virt_addr;
+	dma_addr_t dma_addr;
+	struct timeval ts;
+	u32 buf_size;
+	u32 frame_number;
+	u16 config_counter;
+	u8 empty;
+};
+
+struct ispstat_ops {
+	/*
+	 * Validate new params configuration.
+	 * new_conf->buf_size value must be changed to the exact buffer size
+	 * necessary for the new configuration if it's smaller.
+	 */
+	int (*validate_params)(struct ispstat *stat, void *new_conf);
+
+	/*
+	 * Save new params configuration.
+	 * stat->priv->buf_size value must be set to the exact buffer size for
+	 * the new configuration.
+	 * stat->update is set to 1 if new configuration is different than
+	 * current one.
+	 */
+	void (*set_params)(struct ispstat *stat, void *new_conf);
+
+	/* Apply stored configuration. */
+	void (*setup_regs)(struct ispstat *stat, void *priv);
+
+	/* Enable/Disable module. */
+	void (*enable)(struct ispstat *stat, int enable);
+
+	/* Verify is module is busy. */
+	int (*busy)(struct ispstat *stat);
+
+	/* Used for specific operations during generic buf process task. */
+	int (*buf_process)(struct ispstat *stat);
+};
+
+enum ispstat_state_t {
+	ISPSTAT_DISABLED = 0,
+	ISPSTAT_DISABLING,
+	ISPSTAT_ENABLED,
+	ISPSTAT_ENABLING,
+	ISPSTAT_SUSPENDED,
+};
+
+struct ispstat {
+	struct v4l2_subdev subdev;
+	struct media_pad pad;	/* sink pad */
+
+	/* Control */
+	unsigned configured:1;
+	unsigned update:1;
+	unsigned buf_processing:1;
+	unsigned sbl_ovl_recover:1;
+	u8 inc_config;
+	atomic_t buf_err;
+	enum ispstat_state_t state;	/* enabling/disabling state */
+	struct omap_dma_channel_params dma_config;
+	struct isp_device *isp;
+	void *priv;		/* pointer to priv config struct */
+	void *recover_priv;	/* pointer to recover priv configuration */
+	struct mutex ioctl_lock; /* serialize private ioctl */
+
+	const struct ispstat_ops *ops;
+
+	/* Buffer */
+	u8 wait_acc_frames;
+	u16 config_counter;
+	u32 frame_number;
+	u32 buf_size;
+	u32 buf_alloc_size;
+	int dma_ch;
+	unsigned long event_type;
+	struct ispstat_buffer *buf;
+	struct ispstat_buffer *active_buf;
+	struct ispstat_buffer *locked_buf;
+};
+
+struct ispstat_generic_config {
+	/*
+	 * Fields must be in the same order as in:
+	 *  - isph3a_aewb_config
+	 *  - isph3a_af_config
+	 *  - isphist_config
+	 */
+	u32 buf_size;
+	u16 config_counter;
+};
+
+int omap3isp_stat_config(struct ispstat *stat, void *new_conf);
+int omap3isp_stat_request_statistics(struct ispstat *stat,
+				     struct omap3isp_stat_data *data);
+int omap3isp_stat_init(struct ispstat *stat, const char *name,
+		       const struct v4l2_subdev_ops *sd_ops);
+void omap3isp_stat_free(struct ispstat *stat);
+int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
+				  struct v4l2_fh *fh,
+				  struct v4l2_event_subscription *sub);
+int omap3isp_stat_unsubscribe_event(struct v4l2_subdev *subdev,
+				    struct v4l2_fh *fh,
+				    struct v4l2_event_subscription *sub);
+int omap3isp_stat_s_stream(struct v4l2_subdev *subdev, int enable);
+
+int omap3isp_stat_busy(struct ispstat *stat);
+int omap3isp_stat_pcr_busy(struct ispstat *stat);
+void omap3isp_stat_suspend(struct ispstat *stat);
+void omap3isp_stat_resume(struct ispstat *stat);
+int omap3isp_stat_enable(struct ispstat *stat, u8 enable);
+void omap3isp_stat_sbl_overflow(struct ispstat *stat);
+void omap3isp_stat_isr(struct ispstat *stat);
+void omap3isp_stat_isr_frame_sync(struct ispstat *stat);
+void omap3isp_stat_dma_isr(struct ispstat *stat);
+int omap3isp_stat_register_entities(struct ispstat *stat,
+				    struct v4l2_device *vdev);
+void omap3isp_stat_unregister_entities(struct ispstat *stat);
+
+#endif /* OMAP3_ISP_STAT_H */
-- 
1.7.3.4

