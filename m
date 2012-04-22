Return-path: <linux-media-owner@vger.kernel.org>
Received: from ftp.meprolight.com ([194.90.149.17]:48862 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751676Ab2DVNio (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Apr 2012 09:38:44 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: <g.liakhovetski@gmx.de>, <s.hauer@pengutronix.de>,
	<laurent.pinchart@ideasonboard.com>, <linux-fbdev@vger.kernel.org>,
	<linux-media@vger.kernel.org>,
	Alex Gershgorin <alexg@meprolight.com>
Subject: [PATCH v2] ARM: i.mx: mx3fb: add overlay support
Date: Sun, 22 Apr 2012 16:31:05 +0300
Message-ID: <1335101465-26634-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This work is based on some earlier patch series
"i.MX31: dmaengine and framebuffer drivers" from 2008
by Guennadi Liakhovetski, the patch initializes overlay channel,
adds ioctl for configuring transparency of the overlay and graphics
planes, CONFIG_FB_MX3_OVERLAY is also supported.

In case that CONFIG_FB_MX3_OVERLAY is not defined, mx3fb is completely
backward compatible.

Blend mode, only global alpha blending has been tested.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
Applies to v3.4-rc4

Changes since v1:
  *Some fixes after review
  *Added ioctl for setting overlay windows position
---
 drivers/video/Kconfig |    7 +
 drivers/video/mx3fb.c |  346 ++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/mxcfb.h |   40 ++++++
 3 files changed, 364 insertions(+), 29 deletions(-)
 create mode 100644 include/linux/mxcfb.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index a290be5..acbfccc 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2368,6 +2368,13 @@ config FB_MX3
 	  far only synchronous displays are supported. If you plan to use
 	  an LCD display with your i.MX31 system, say Y here.
 
+config FB_MX3_OVERLAY
+	bool "MX3 Overlay support"
+	default n
+	depends on FB_MX3
+	---help---
+	  Say Y here to enable overlay support
+
 config FB_BROADSHEET
 	tristate "E-Ink Broadsheet/Epson S1D13521 controller support"
 	depends on FB
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index eec0d7b..09d7885 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -26,6 +26,7 @@
 #include <linux/console.h>
 #include <linux/clk.h>
 #include <linux/mutex.h>
+#include <linux/mxcfb.h>
 
 #include <mach/dma.h>
 #include <mach/hardware.h>
@@ -238,6 +239,7 @@ static const struct fb_videomode mx3fb_modedb[] = {
 
 struct mx3fb_data {
 	struct fb_info		*fbi;
+	struct fb_info		*fbi_ovl;
 	int			backlight_level;
 	void __iomem		*reg_base;
 	spinlock_t		lock;
@@ -246,6 +248,9 @@ struct mx3fb_data {
 	uint32_t		h_start_width;
 	uint32_t		v_start_width;
 	enum disp_data_mapping	disp_data_fmt;
+
+	/* IDMAC / dmaengine interface */
+	struct idmac_channel	*idmac_channel[2];	/* We need 2 channels */
 };
 
 struct dma_chan_request {
@@ -268,10 +273,19 @@ struct mx3fb_info {
 	struct dma_async_tx_descriptor	*txd;
 	dma_cookie_t			cookie;
 	struct scatterlist		sg[2];
+	struct list_head		ovl_list; /* overlay buffer list */
 
 	u32				sync;	/* preserve var->sync flags */
 };
 
+/* Allocated overlay buffer */
+struct mx3fb_alloc_list {
+	struct list_head	list;
+	dma_addr_t		phy_addr;
+	void			*cpu_addr;
+	size_t			size;
+};
+
 static void mx3fb_dma_done(void *);
 
 /* Used fb-mode and bpp. Can be set on kernel command line, therefore file-static. */
@@ -303,7 +317,13 @@ static void sdc_fb_init(struct mx3fb_info *fbi)
 	struct mx3fb_data *mx3fb = fbi->mx3fb;
 	uint32_t reg;
 
-	reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+	reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF) & ~SDC_COM_GWSEL;
+
+	/* Also enable foreground for overlay graphic window is foreground */
+	if (mx3fb->fbi_ovl && fbi == mx3fb->fbi_ovl->par) {
+		reg |= SDC_COM_FG_EN | SDC_COM_GWSEL;
+		INIT_LIST_HEAD(&fbi->ovl_list);
+	}
 
 	mx3fb_write_reg(mx3fb, reg | SDC_COM_BG_EN, SDC_COM_CONF);
 }
@@ -312,13 +332,24 @@ static void sdc_fb_init(struct mx3fb_info *fbi)
 static uint32_t sdc_fb_uninit(struct mx3fb_info *fbi)
 {
 	struct mx3fb_data *mx3fb = fbi->mx3fb;
-	uint32_t reg;
+	uint32_t reg, chan_mask;
 
 	reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
 
-	mx3fb_write_reg(mx3fb, reg & ~SDC_COM_BG_EN, SDC_COM_CONF);
+	/*
+	 * Don't we have to automatically disable overlay when disabling
+	 * background? Attention: cannot test mx3fb->fbi_ovl->par, must
+	 * test mx3fb->fbi->par, because at the time this function is
+	 * called for the first time fbi_ovl is not assigned yet.
+	 */
+	if (fbi == mx3fb->fbi->par)
+		chan_mask = SDC_COM_BG_EN;
+	else
+		chan_mask = SDC_COM_FG_EN | SDC_COM_GWSEL;
+
+	mx3fb_write_reg(mx3fb, reg & ~chan_mask, SDC_COM_CONF);
 
-	return reg & SDC_COM_BG_EN;
+	return reg & chan_mask;
 }
 
 static void sdc_enable_channel(struct mx3fb_info *mx3_fbi)
@@ -412,13 +443,33 @@ static void sdc_disable_channel(struct mx3fb_info *mx3_fbi)
 static int sdc_set_window_pos(struct mx3fb_data *mx3fb, enum ipu_channel channel,
 			      int16_t x_pos, int16_t y_pos)
 {
-	if (channel != IDMAC_SDC_0)
-		return -EINVAL;
-
 	x_pos += mx3fb->h_start_width;
 	y_pos += mx3fb->v_start_width;
 
-	mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_BG_POS);
+/*
+   If the overlay is defined, we just need to swap
+   the window position register relative to DMAC channel ID
+*/
+	switch (channel) {
+#ifndef CONFIG_FB_MX3_OVERLAY
+	case IDMAC_SDC_0:
+		mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_BG_POS);
+		break;
+	case IDMAC_SDC_1:
+		mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_FG_POS);
+		break;
+#else
+	case IDMAC_SDC_0:
+		mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_FG_POS);
+		break;
+	case IDMAC_SDC_1:
+		mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_BG_POS);
+		break;
+#endif
+	default:
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -482,14 +533,17 @@ static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
 	mx3fb->h_start_width = h_start_width;
 	mx3fb->v_start_width = v_start_width;
 
+	reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+
 	switch (panel) {
 	case IPU_PANEL_SHARP_TFT:
 		mx3fb_write_reg(mx3fb, 0x00FD0102L, SDC_SHARP_CONF_1);
 		mx3fb_write_reg(mx3fb, 0x00F500F4L, SDC_SHARP_CONF_2);
-		mx3fb_write_reg(mx3fb, SDC_COM_SHARP | SDC_COM_TFT_COLOR, SDC_COM_CONF);
+		mx3fb_write_reg(mx3fb, reg | SDC_COM_SHARP |
+				SDC_COM_TFT_COLOR, SDC_COM_CONF);
 		break;
 	case IPU_PANEL_TFT:
-		mx3fb_write_reg(mx3fb, SDC_COM_TFT_COLOR, SDC_COM_CONF);
+		mx3fb_write_reg(mx3fb, reg | SDC_COM_TFT_COLOR, SDC_COM_CONF);
 		break;
 	default:
 		return -EINVAL;
@@ -563,13 +617,12 @@ static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
 /**
  * sdc_set_color_key() - set the transparent color key for SDC graphic plane.
  * @mx3fb:	mx3fb context.
- * @channel:	IPU DMAC channel ID.
  * @enable:	boolean to enable or disable color keyl.
  * @color_key:	24-bit RGB color to use as transparent color key.
  * @return:	0 on success or negative error code on failure.
  */
-static int sdc_set_color_key(struct mx3fb_data *mx3fb, enum ipu_channel channel,
-			     bool enable, uint32_t color_key)
+static int sdc_set_color_key(struct mx3fb_data *mx3fb, bool enable,
+				uint32_t color_key)
 {
 	uint32_t reg, sdc_conf;
 	unsigned long lock_flags;
@@ -577,10 +630,6 @@ static int sdc_set_color_key(struct mx3fb_data *mx3fb, enum ipu_channel channel,
 	spin_lock_irqsave(&mx3fb->lock, lock_flags);
 
 	sdc_conf = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
-	if (channel == IDMAC_SDC_0)
-		sdc_conf &= ~SDC_COM_GWSEL;
-	else
-		sdc_conf |= SDC_COM_GWSEL;
 
 	if (enable) {
 		reg = mx3fb_read_reg(mx3fb, SDC_GW_CTRL) & 0xFF000000L;
@@ -668,8 +717,16 @@ static int mx3fb_set_fix(struct fb_info *fbi)
 {
 	struct fb_fix_screeninfo *fix = &fbi->fix;
 	struct fb_var_screeninfo *var = &fbi->var;
+	struct mx3fb_info *mx3_fbi = fbi->par;
 
+#ifndef CONFIG_FB_MX3_OVERLAY
 	strncpy(fix->id, "DISP3 BG", 8);
+#else
+	if (mx3_fbi->ipu_ch == IDMAC_SDC_1)
+		strncpy(fix->id, "DISP3 BG", 8);
+	else
+		strncpy(fix->id, "DISP3 FG", 8);
+#endif
 
 	fix->line_length = var->xres_virtual * var->bits_per_pixel / 8;
 
@@ -689,13 +746,25 @@ static void mx3fb_dma_done(void *arg)
 	struct idmac_channel *ichannel = to_idmac_chan(chan);
 	struct mx3fb_data *mx3fb = ichannel->client;
 	struct mx3fb_info *mx3_fbi = mx3fb->fbi->par;
+	struct mx3fb_info *mx3_fbi_cur;
+	struct mx3fb_info *mx3_fbi_ovl = mx3fb->fbi_ovl ? mx3fb->fbi_ovl->par :
+		NULL;
 
 	dev_dbg(mx3fb->dev, "irq %d callback\n", ichannel->eof_irq);
 
+	if (ichannel == mx3_fbi->idmac_channel) {
+		mx3_fbi_cur = mx3_fbi;
+	} else if (mx3_fbi_ovl && ichannel == mx3_fbi_ovl->idmac_channel) {
+		mx3_fbi_cur = mx3_fbi_ovl;
+	} else {
+		WARN(1, "Cannot identify channel!\n");
+		return;
+	}
+
 	/* We only need one interrupt, it will be re-enabled as needed */
 	disable_irq_nosync(ichannel->eof_irq);
 
-	complete(&mx3_fbi->flip_cmpl);
+	complete(&mx3_fbi_cur->flip_cmpl);
 }
 
 static int __set_par(struct fb_info *fbi, bool lock)
@@ -1151,6 +1220,157 @@ static struct fb_ops mx3fb_ops = {
 	.fb_blank = mx3fb_blank,
 };
 
+#ifdef CONFIG_FB_MX3_OVERLAY
+static int mx3fb_blank_ovl(int blank, struct fb_info *fbi)
+{
+	struct mx3fb_info *mx3_fbi = fbi->par;
+
+	dev_dbg(fbi->device, "ovl blank = %d\n", blank);
+
+	if (mx3_fbi->blank == blank)
+		return 0;
+
+	mutex_lock(&mx3_fbi->mutex);
+	mx3_fbi->blank = blank;
+
+	switch (blank) {
+	case FB_BLANK_POWERDOWN:
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_HSYNC_SUSPEND:
+	case FB_BLANK_NORMAL:
+		sdc_disable_channel(mx3_fbi);
+		break;
+	case FB_BLANK_UNBLANK:
+		sdc_enable_channel(mx3_fbi);
+		break;
+	}
+	mutex_unlock(&mx3_fbi->mutex);
+
+	return 0;
+}
+
+/*
+ * Function to handle custom ioctls for MX3 framebuffer.
+ *
+ *  @inode	inode struct
+ *  @file	file struct
+ *  @cmd	Ioctl command to handle
+ *  @arg	User pointer to command arguments
+ *  @fbi	framebuffer information pointer
+ */
+static int mx3fb_ioctl_ovl(struct fb_info *fbi, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct mx3fb_info *mx3_fbi = fbi->par;
+	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
+	int retval = 0;
+	int __user *argp = (void __user *)arg;
+	struct mx3fb_alloc_list *mem;
+	int size;
+	unsigned long offset;
+	union {
+		struct mxcfb_pos pos;
+		struct mxcfb_gbl_alpha ga;
+		struct mxcfb_color_key key;
+	} s;
+
+	switch (cmd) {
+	case FBIO_ALLOC:
+		if (get_user(size, argp))
+			return -EFAULT;
+
+		mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+		if (mem == NULL)
+			return -ENOMEM;
+
+		mem->size = PAGE_ALIGN(size);
+
+		mem->cpu_addr = dma_alloc_coherent(fbi->device, size,
+						   &mem->phy_addr,
+						   GFP_DMA);
+		if (mem->cpu_addr == NULL) {
+			kfree(mem);
+			return -ENOMEM;
+		}
+
+		mutex_lock(&mx3_fbi->mutex);
+		list_add(&mem->list, &mx3_fbi->ovl_list);
+		mutex_unlock(&mx3_fbi->mutex);
+
+		dev_dbg(fbi->device, "allocated %d bytes  <at>  0x%08X\n",
+			mem->size, mem->phy_addr);
+
+		if (put_user(mem->phy_addr, argp))
+			return -EFAULT;
+
+		break;
+	case FBIO_FREE:
+		if (get_user(offset, argp))
+			return -EFAULT;
+
+		retval = -EINVAL;
+		mutex_lock(&mx3_fbi->mutex);
+		list_for_each_entry(mem, &mx3_fbi->ovl_list, list) {
+			if (mem->phy_addr == offset) {
+				list_del(&mem->list);
+				dma_free_coherent(fbi->device,
+						  mem->size,
+						  mem->cpu_addr,
+						  mem->phy_addr);
+				kfree(mem);
+				retval = 0;
+				break;
+			}
+		}
+		mutex_unlock(&mx3_fbi->mutex);
+
+		break;
+	case MXCFB_SET_GBL_ALPHA:
+		if (copy_from_user(&s.ga, (void *)arg, sizeof(s.ga)))
+			retval = -EFAULT;
+
+		sdc_set_global_alpha(mx3fb, (bool)s.ga.enable, s.ga.alpha);
+		dev_dbg(fbi->device, "Set global alpha to %d\n", s.ga.alpha);
+
+		break;
+	case MXCFB_SET_CLR_KEY:
+		if (copy_from_user(&s.key, (void *)arg, sizeof(s.key)))
+			retval = -EFAULT;
+
+		sdc_set_color_key(mx3fb, (bool)s.key.enable, s.key.color_key);
+		dev_dbg(fbi->device, "Set color key to %d\n", s.key.color_key);
+
+		break;
+	case MXCFB_SET_OVERLAY_POS:
+		if (copy_from_user(&s.pos, (void *)arg, sizeof(s.pos)))
+			retval = -EFAULT;
+
+		sdc_set_window_pos(mx3fb, mx3_fbi->ipu_ch, s.pos.x, s.pos.y);
+		dev_dbg(fbi->device, "Set win position to posx=%d, posy=%d\n",
+			s.pos.x, s.pos.y);
+
+		break;
+	default:
+		retval = -EINVAL;
+	}
+
+	return retval;
+}
+
+static struct fb_ops mx3fb_ovl_ops = {
+	.owner = THIS_MODULE,
+	.fb_set_par = mx3fb_set_par,
+	.fb_check_var = mx3fb_check_var,
+	.fb_setcolreg = mx3fb_setcolreg,
+	.fb_pan_display = mx3fb_pan_display,
+	.fb_ioctl = mx3fb_ioctl_ovl,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_blank = mx3fb_blank_ovl,
+};
+#endif
+
 #ifdef CONFIG_PM
 /*
  * Power management hooks.      Note that we won't be called from IRQ context,
@@ -1164,11 +1384,16 @@ static int mx3fb_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct mx3fb_data *mx3fb = platform_get_drvdata(pdev);
 	struct mx3fb_info *mx3_fbi = mx3fb->fbi->par;
+	struct mx3fb_info *mx3_fbi_ovl = mx3fb->fbi_ovl->par;
 
 	console_lock();
 	fb_set_suspend(mx3fb->fbi, 1);
+	fb_set_suspend(mx3fb->fbi_ovl, 1);
 	console_unlock();
 
+	if (mx3_fbi_ovl->blank == FB_BLANK_UNBLANK)
+		sdc_disable_channel(mx3_fbi_ovl);
+
 	if (mx3_fbi->blank == FB_BLANK_UNBLANK) {
 		sdc_disable_channel(mx3_fbi);
 		sdc_set_brightness(mx3fb, 0);
@@ -1184,14 +1409,19 @@ static int mx3fb_resume(struct platform_device *pdev)
 {
 	struct mx3fb_data *mx3fb = platform_get_drvdata(pdev);
 	struct mx3fb_info *mx3_fbi = mx3fb->fbi->par;
+	struct mx3fb_info *mx3_fbi_ovl = mx3fb->fbi_ovl->par;
 
 	if (mx3_fbi->blank == FB_BLANK_UNBLANK) {
 		sdc_enable_channel(mx3_fbi);
 		sdc_set_brightness(mx3fb, mx3fb->backlight_level);
 	}
 
+	if (mx3_fbi_ovl->blank == FB_BLANK_UNBLANK)
+		sdc_enable_channel(mx3_fbi_ovl);
+
 	console_lock();
 	fb_set_suspend(mx3fb->fbi, 0);
+	fb_set_suspend(mx3fb->fbi_ovl, 0);
 	console_unlock();
 
 	return 0;
@@ -1333,8 +1563,9 @@ static int init_fb_chan(struct mx3fb_data *mx3fb, struct idmac_channel *ichan)
 	ichan->client = mx3fb;
 	irq = ichan->eof_irq;
 
-	if (ichan->dma_chan.chan_id != IDMAC_SDC_0)
-		return -EINVAL;
+	switch (ichan->dma_chan.chan_id) {
+
+	case IDMAC_SDC_0:
 
 	fbi = mx3fb_init_fbinfo(dev, &mx3fb_ops);
 	if (!fbi)
@@ -1375,7 +1606,29 @@ static int init_fb_chan(struct mx3fb_data *mx3fb, struct idmac_channel *ichan)
 
 	sdc_set_brightness(mx3fb, 255);
 	sdc_set_global_alpha(mx3fb, true, 0xFF);
-	sdc_set_color_key(mx3fb, IDMAC_SDC_0, false, 0);
+	sdc_set_color_key(mx3fb, false, 0);
+
+	break;
+#ifdef CONFIG_FB_MX3_OVERLAY
+	case IDMAC_SDC_1:
+
+		/* We know, that background has been allocated already! */
+		fbi = mx3fb_init_fbinfo(dev, &mx3fb_ovl_ops);
+		if (!fbi)
+			return -ENOMEM;
+
+		/* Default Y virtual size is 2x panel size */
+		fbi->var = mx3fb->fbi->var;
+		/* This shouldn't be necessary, it is already set up above */
+		fbi->var.yres_virtual = mx3fb->fbi->var.yres * 2;
+
+		mx3fb->fbi_ovl = fbi;
+
+		break;
+#endif
+	default:
+		return -EINVAL;
+	}
 
 	mx3fbi			= fbi->par;
 	mx3fbi->idmac_channel	= ichan;
@@ -1392,9 +1645,13 @@ static int init_fb_chan(struct mx3fb_data *mx3fb, struct idmac_channel *ichan)
 	if (ret < 0)
 		goto esetpar;
 
-	__blank(FB_BLANK_UNBLANK, fbi);
+	/* Overlay stays blanked by default */
+	if (ichan->dma_chan.chan_id == IDMAC_SDC_0) {
+		mx3fb_blank(FB_BLANK_UNBLANK, fbi);
 
-	dev_info(dev, "registered, using mode %s\n", fb_mode);
+		dev_info(dev, "mx3fb: fb registered, using mode %s [%c]\n",
+		fb_mode, list_empty(&ichan->queue) ? '-' : '+');
+	}
 
 	ret = register_framebuffer(fbi);
 	if (ret < 0)
@@ -1492,14 +1749,42 @@ static int mx3fb_probe(struct platform_device *pdev)
 
 	mx3fb->backlight_level = 255;
 
+	mx3fb->idmac_channel[0] = to_idmac_chan(chan);
+	mx3fb->idmac_channel[0]->client = mx3fb;
+
 	ret = init_fb_chan(mx3fb, to_idmac_chan(chan));
 	if (ret < 0)
 		goto eisdc0;
 
+#ifdef CONFIG_FB_MX3_OVERLAY
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_PRIVATE, mask);
+	rq.id = IDMAC_SDC_1;
+	chan = dma_request_channel(mask, chan_filter, &rq);
+	if (!chan) {
+		ret = -EBUSY;
+		goto ersdc1;
+	}
+
+	mx3fb->idmac_channel[1] = to_idmac_chan(chan);
+	mx3fb->idmac_channel[1]->client = mx3fb;
+
+	ret = init_fb_chan(mx3fb, to_idmac_chan(chan));
+	if (ret < 0)
+		goto eisdc1;
+#endif
+
 	return 0;
 
+#ifdef CONFIG_FB_MX3_OVERLAY
+eisdc1:
+	dma_release_channel(&mx3fb->idmac_channel[1]->dma_chan);
+ersdc1:
+	release_fbi(mx3fb->fbi);
+#endif
 eisdc0:
-	dma_release_channel(chan);
+	dma_release_channel(&mx3fb->idmac_channel[0]->dma_chan);
 ersdc0:
 	dmaengine_put();
 	iounmap(mx3fb->reg_base);
@@ -1513,13 +1798,16 @@ static int mx3fb_remove(struct platform_device *dev)
 {
 	struct mx3fb_data *mx3fb = platform_get_drvdata(dev);
 	struct fb_info *fbi = mx3fb->fbi;
-	struct mx3fb_info *mx3_fbi = fbi->par;
-	struct dma_chan *chan;
 
-	chan = &mx3_fbi->idmac_channel->dma_chan;
-	release_fbi(fbi);
+	if (fbi)
+		release_fbi(fbi);
+
+	fbi = mx3fb->fbi_ovl;
+	if (fbi)
+		release_fbi(fbi);
 
-	dma_release_channel(chan);
+	dma_release_channel(&mx3fb->idmac_channel[1]->dma_chan);
+	dma_release_channel(&mx3fb->idmac_channel[0]->dma_chan);
 	dmaengine_put();
 
 	iounmap(mx3fb->reg_base);
diff --git a/include/linux/mxcfb.h b/include/linux/mxcfb.h
new file mode 100644
index 0000000..b5b681f
--- /dev/null
+++ b/include/linux/mxcfb.h
@@ -0,0 +1,40 @@
+/*
+ * File: include/linux/mxcfb.h
+ * Global header file for the MXC Framebuffer
+ *
+ * Copyright 2004-2012 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * The code contained herein is licensed under the GNU Lesser General
+ * Public License.  You may obtain a copy of the GNU Lesser General
+ * Public License Version 2.1 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/lgpl-license.html
+ * http://www.gnu.org/copyleft/lgpl.html
+ */
+
+#ifndef __LINUX_MXCFB_H__
+#define __LINUX_MXCFB_H__
+
+struct mxcfb_gbl_alpha {
+	int enable;
+	int alpha;
+};
+
+struct mxcfb_color_key {
+	int enable;
+	__u32 color_key;
+};
+
+struct mxcfb_pos {
+	__u16 x;
+	__u16 y;
+};
+
+/* IOCTL commands. */
+
+#define MXCFB_SET_GBL_ALPHA		_IOW('F', 0x21, struct mxcfb_gbl_alpha)
+#define MXCFB_SET_CLR_KEY		_IOW('F', 0x22, struct mxcfb_color_key)
+#define MXCFB_SET_OVERLAY_POS		_IOWR('F', 0x24, struct mxcfb_pos)
+
+#endif
+
-- 
1.7.0.4

