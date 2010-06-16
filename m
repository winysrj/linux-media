Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53735 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456Ab0FPKML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:11 -0400
Date: Wed, 16 Jun 2010 12:11:59 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/7] s3c-fb: Add v4l2 subdevice to support framebuffer local
 fifo input path
In-reply-to: <1276683123-30224-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, ben-linux@fluff.org,
	kgene.kim@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1276683123-30224-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1276683123-30224-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Selected multimedia devices in Samsung S3C/S5P SoC series are capable of
transferring data directly between each other, bypassing the main system
bus. Such a datapath exists between the camera interface/video
postprocessor and the lcd controller. To control the data flow from the
fimc driver level v4l2-subdevice driver is added to the framebuffer.
Among others it enables to switch the lcd controller from DMA input to
local fifo path.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/plat-samsung/include/plat/fb.h |    6 +
 drivers/video/s3c-fb.c                  |  454 ++++++++++++++++++++++++++++++-
 2 files changed, 452 insertions(+), 8 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/fb.h b/arch/arm/plat-samsung/include/plat/fb.h
index cb3ca3a..7dc6110 100644
--- a/arch/arm/plat-samsung/include/plat/fb.h
+++ b/arch/arm/plat-samsung/include/plat/fb.h
@@ -22,6 +22,10 @@
  */
 #define S3C_FB_MAX_WIN	(5)
 
+#define S3C_FB_MAX_WIN_SOURCES	(2)
+
+struct s3c_fifo_link;
+
 /**
  * struct s3c_fb_pd_win - per window setup data
  * @win_mode: The display parameters to initialise (not for window 0)
@@ -35,6 +39,8 @@ struct s3c_fb_pd_win {
 	unsigned short		max_bpp;
 	unsigned short		virtual_x;
 	unsigned short		virtual_y;
+
+	struct s3c_fifo_link	*fifo_sources[S3C_FB_MAX_WIN_SOURCES];
 };
 
 /**
diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index f098bd1..d36ca88 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -24,9 +24,14 @@
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
 #include <mach/map.h>
 #include <plat/regs-fb-v4.h>
 #include <plat/fb.h>
+#include <plat/fifo.h>
 
 /* This driver will export a number of framebuffer interfaces depending
  * on the configuration passed in via the platform data. Each fb instance
@@ -56,6 +61,18 @@
 #define VSYNC_TIMEOUT_MSEC 50
 
 struct s3c_fb;
+struct s3c_fb_win;
+
+struct s3c_fb_win_sd {
+	struct v4l2_subdev	sd;
+	unsigned int		index;
+	struct s3c_fb_win	*win;
+	struct s3c_fifo_link	*link;
+	struct v4l2_format	fmt;
+	int			streaming;
+	struct v4l2_crop	default_rect;
+	struct v4l2_crop	osd_rect;
+};
 
 #define VALID_BPP(x) (1 << ((x) - 1))
 
@@ -157,6 +174,9 @@ struct s3c_fb_palette {
  * @pseudo_palette: For use in TRUECOLOUR modes for entries 0..15/
  * @index: The window number of this window.
  * @palette: The bitfields for changing r/g/b into a hardware palette entry.
+ * @sources:
+ * @local_path: flag indicating the lcd controller input mode:
+ *		0 - local path from other SoC subsystem, 1 - DMA
  */
 struct s3c_fb_win {
 	struct s3c_fb_pd_win	*windata;
@@ -168,6 +188,8 @@ struct s3c_fb_win {
 	u32			*palette_buffer;
 	u32			 pseudo_palette[16];
 	unsigned int		 index;
+	struct s3c_fb_win_sd	*sources[S3C_FB_MAX_WIN_SOURCES];
+	unsigned int		local_path;
 };
 
 /**
@@ -361,13 +383,10 @@ static int s3c_fb_calc_pixclk(struct s3c_fb *sfb, unsigned int pixclk)
  */
 static int s3c_fb_align_word(unsigned int bpp, unsigned int pix)
 {
-	int pix_per_word;
-
 	if (bpp > 16)
 		return pix;
 
-	pix_per_word = (8 * 32) / bpp;
-	return ALIGN(pix, pix_per_word);
+	return  round_down(pix, (bpp > 8) ? 2 : 4);
 }
 
 /**
@@ -419,6 +438,9 @@ static int s3c_fb_set_par(struct fb_info *info)
 	u32 pagewidth;
 	int clkdiv;
 
+	if (win->local_path)
+		return -EBUSY;
+
 	dev_dbg(sfb->dev, "setting framebuffer parameters\n");
 
 	switch (var->bits_per_pixel) {
@@ -486,7 +508,7 @@ static int s3c_fb_set_par(struct fb_info *info)
 
 		data = VIDTCON2_LINEVAL(var->yres - 1) |
 		       VIDTCON2_HOZVAL(var->xres - 1);
-		writel(data, regs +sfb->variant.vidtcon + 8 );
+		writel(data, regs + sfb->variant.vidtcon + 8);
 	}
 
 	/* write the buffer address */
@@ -711,6 +733,9 @@ static int s3c_fb_setcolreg(unsigned regno,
 	dev_dbg(sfb->dev, "%s: win %d: %d => rgb=%d/%d/%d\n",
 		__func__, win->index, regno, red, green, blue);
 
+	if (win->local_path)
+		return -EBUSY;
+
 	switch (info->fix.visual) {
 	case FB_VISUAL_TRUECOLOR:
 		/* true-colour, use pseudo-palette */
@@ -786,6 +811,9 @@ static int s3c_fb_blank(int blank_mode, struct fb_info *info)
 
 	dev_dbg(sfb->dev, "blank mode %d\n", blank_mode);
 
+	if (win->local_path)
+		return -EBUSY;
+
 	wincon = readl(sfb->regs + sfb->variant.wincon + (index * 4));
 
 	switch (blank_mode) {
@@ -896,6 +924,168 @@ static int s3c_fb_pan_display(struct fb_var_screeninfo *var,
 }
 
 /**
+ * s3c_fb_set_osd() - set position and size of the framebuffer window
+ *
+ * @win: framebuffer window to get data for
+ * @cr: pixel cropping reactangle
+ *
+ * Set framebuffer window position and size. cr rectangle will be modified
+ * if it does not meet the hardware alignment requirements.
+ */
+int s3c_fb_set_osd(struct s3c_fb_win *win, struct v4l2_rect *cr, int bpp)
+{
+	u32 data, width;
+	struct s3c_fb *sfb = win->parent;
+	void __iomem *regs = sfb->regs;
+
+	if (win->index >= S3C_FB_MAX_WIN)
+		return -EINVAL;
+
+	shadow_protect(win);
+
+	cr->left = s3c_fb_align_word(bpp, cr->left);
+	data = VIDOSDxA_TOPLEFT_X(cr->left) | VIDOSDxA_TOPLEFT_Y(cr->top);
+	writel(data, regs + VIDOSD_A(win->index, sfb->variant));
+
+	width = s3c_fb_align_word(bpp, cr->width - 1);
+
+	data = VIDOSDxB_BOTRIGHT_X(cr->left + width)
+	     | VIDOSDxB_BOTRIGHT_Y(cr->top + cr->height - 1);
+
+	writel(data, regs + VIDOSD_B(win->index, sfb->variant));
+
+	data = (width + 1) * cr->height;
+	vidosd_set_size(win, data);
+
+	shadow_noprotect(win);
+
+	dev_dbg(sfb->dev, "%s(): l:%d t:%d w:%d h:%d", __func__,
+		cr->left, cr->top, cr->width, cr->height);
+
+	return 0;
+}
+
+/**
+ * s3c_fb_get_osd() - get position and size of the frame buffer window
+ *
+ * @win: framebuffer window to get data for
+ * @cr: current cropping rectangle
+ */
+int s3c_fb_get_osd(struct s3c_fb_win *win, struct v4l2_rect *cr)
+{
+	u32 reg, ltx, lty;
+	struct s3c_fb *sfb = win->parent;
+	void __iomem *regs = sfb->regs;
+
+	if (!cr || win->index >= S3C_FB_MAX_WIN)
+		return -EINVAL;
+
+	reg = readl(regs + VIDOSD_A(win->index, sfb->variant));
+
+	ltx = (reg >> VIDOSDxA_TOPLEFT_X_SHIFT) & VIDOSDxA_TOPLEFT_X_LIMIT;
+	lty = (reg >> VIDOSDxA_TOPLEFT_Y_SHIFT) & VIDOSDxA_TOPLEFT_Y_LIMIT;
+
+	reg = readl(regs + VIDOSD_B(win->index, sfb->variant));
+
+	cr->width = ((reg >> VIDOSDxB_BOTRIGHT_X_SHIFT)
+		  & VIDOSDxB_BOTRIGHT_X_LIMIT) - ltx + 1;
+
+	cr->height = ((reg >> VIDOSDxB_BOTRIGHT_Y_SHIFT)
+			& VIDOSDxB_BOTRIGHT_Y_LIMIT) - lty + 1;
+	cr->left = ltx;
+	cr->top = lty;
+
+	dev_dbg(sfb->dev, "%s(): l:%d t:%d w:%d h:%d", __func__,
+		cr->left, cr->top, cr->width, cr->height);
+
+	return 0;
+}
+
+/**
+ * s3c_fb_enable_local() - switch window between input DMA and fifo modes
+ *
+ * @en: nonzero - switch from input DMA to fifo mode and apply
+ *		  window size and position set by the window's subdevice
+ *      0 - restore from fifo to DMA mode
+ * @fb_sd: window subdevice for fifo input
+ */
+static int s3c_fb_enable_local_in(struct s3c_fb_win_sd *fb_sd, int en)
+{
+	struct s3c_fb_win *win = fb_sd->win;
+	struct s3c_fb *sfb = win->parent;
+	static u32 wincon;
+	u32 reg;
+	int ret = 0, bpp = 32;
+
+	/* disable video output and the window logic before altering
+	   window setup */
+	reg = readl(sfb->regs + WINCON(win->index));
+	reg &= ~WINCONx_ENWIN;
+	writel(reg, sfb->regs + WINCON(win->index));
+
+	shadow_protect(win);
+
+	reg = readl(sfb->regs + WINCON(win->index));
+
+	if (en) {
+		if (fb_sd->streaming)
+			return 0;
+
+		wincon = reg;
+
+		switch (fb_sd->fmt.fmt.pix.pixelformat) {
+		case V4L2_PIX_FMT_YUYV: /* YCbCr 4:4:4 */
+			reg |= WINCONx_YCbCr | WINCONx_ENLOCAL;
+			bpp = 16;
+			break;
+
+		case V4L2_PIX_FMT_RGB24:
+		default:
+			reg &= ~(WINCONx_YCbCr | WINCONx_WSWP | WINCONx_HAWSWP |
+				 WINCONx_BYTSWP | WINCONx_BITSWP |
+				 WINCON0_BPPMODE_MASK | WINCONx_BURSTLEN_MASK);
+
+			reg |=	WINCON0_BPPMODE_24BPP_888 |
+				WINCONx_BURSTLEN_4WORD |
+				WINCONx_ENLOCAL;
+			bpp = 24;
+			break;
+		}
+		ret = s3c_fb_set_osd(fb_sd->win, &fb_sd->osd_rect.c, bpp);
+		if (!ret) {
+			fb_sd->streaming = 1;
+			writel(reg, sfb->regs + WINCON(win->index));
+		}
+	} else {
+		/* here we need to be aligned with VSYNC interrupt */
+		if (!fb_sd->streaming)
+			return 0;
+
+		reg = wincon & ~WINCONx_ENLOCAL;
+		fb_sd->streaming = 0;
+		/* restore OSD values from before we enabled local mode */
+		bpp = win->fbinfo->var.bits_per_pixel;
+		s3c_fb_set_osd(fb_sd->win, &fb_sd->default_rect.c, bpp);
+		writel(reg, sfb->regs + WINCON(win->index));
+	}
+
+	shadow_noprotect(win);
+
+	reg = readl(sfb->regs + WINCON(win->index));
+	reg |= WINCONx_ENWIN;
+	writel(reg, sfb->regs + WINCON(win->index));
+
+	return ret;
+}
+
+/* Returns current horizontal line number. It will be 0 during VSYNC. */
+inline u32 s3c_fb_get_line_count(struct s3c_fb *sfb)
+{
+	u32 reg = readl(sfb->regs + VIDCON1);
+	return VIDCON1_LINECNT_GET(reg);
+}
+
+/**
  * s3c_fb_enable_irq() - enable framebuffer interrupts
  * @sfb: main hardware state
  */
@@ -912,7 +1102,7 @@ static void s3c_fb_enable_irq(struct s3c_fb *sfb)
 		irq_ctrl_reg |= VIDINTCON0_INT_FRAME;
 
 		irq_ctrl_reg &= ~VIDINTCON0_FRAMESEL0_MASK;
-		irq_ctrl_reg |= VIDINTCON0_FRAMESEL0_VSYNC;
+		irq_ctrl_reg |= VIDINTCON0_FRAMESEL0_FRONTPORCH;
 		irq_ctrl_reg &= ~VIDINTCON0_FRAMESEL1_MASK;
 		irq_ctrl_reg |= VIDINTCON0_FRAMESEL1_NONE;
 
@@ -1089,6 +1279,247 @@ static void s3c_fb_free_memory(struct s3c_fb *sfb, struct s3c_fb_win *win)
 			      fbi->screen_base, fbi->fix.smem_start);
 }
 
+/* V4L2 frambuffer subdevice  */
+
+static struct s3c_fb_win_sd *to_fb_win_sd(struct v4l2_subdev *s)
+{
+	return container_of(s, struct s3c_fb_win_sd, sd);
+}
+
+/**
+ * v4l2_sd_fb_s_stream() - switch between DMA on local path mode
+ *
+ * @win: window to change operation mode for.
+ * @sd:
+ * @en: if nonzero - apply cropping rectangle and switch to local path,
+ *	otherwise - restore cropping rectangle and switch to input DMA mode.
+ */
+static int v4l2_sd_fb_s_stream(struct v4l2_subdev *sd, int en)
+{
+	unsigned long flags;
+	struct s3c_fb_win_sd *w_sd = to_fb_win_sd(sd);
+	struct s3c_fb_win *win = w_sd->win;
+	struct s3c_fb *sfb = win->parent;
+	int retr = 100;
+	int ret = 0;
+
+	if (win->index > 2)
+		return -EINVAL;
+
+	mutex_lock(&win->fbinfo->lock);
+
+	if (en) {
+		ret = s3c_fb_enable_local_in(w_sd, en);
+		win->local_path = 1;
+	} else {
+		/* fimc-frambuffer fifo need to be stopped shortly after VSYNC,
+		   for this reason horizontal line count is additionally
+		   examined after waking up by an interrupt. If it is 0 we are
+		   still at VSYNC and therefore are save to disable fifo.
+		   Waiting for VSYNC is repeated unless it is the right time
+		   to proceed. */
+		while (retr--) {
+			ret = s3c_fb_wait_for_vsync(sfb, 0);
+			if (ret)
+				continue;
+			local_irq_save(flags);
+			if (s3c_fb_get_line_count(sfb) == 0) {
+
+				s3c_fb_enable_local_in(w_sd, 0);
+				/* Notify FIMC driver */
+				v4l2_subdev_notify(&w_sd->sd, 0, NULL);
+				local_irq_restore(flags);
+				break;
+			}
+			local_irq_restore(flags);
+		}
+		if (!retr)
+			ret = -ETIMEDOUT;
+		win->local_path = 0;
+	}
+	mutex_unlock(&win->fbinfo->lock);
+
+	return ret;
+}
+
+/**
+ * v4l2_sd_fb_s_fmt() - set format for local input path mode
+ *
+ * @sd: pointer to v4l2 subdevice
+ * @fmt: pixel format to set
+ */
+static int v4l2_sd_fb_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *fmt)
+{
+	struct s3c_fb_win_sd *fb_sd = to_fb_win_sd(sd);
+	int fourcc = fmt->fmt.pix.pixelformat;
+
+	if (!fmt || (fourcc != V4L2_PIX_FMT_YUYV
+		&& fourcc != V4L2_PIX_FMT_RGB24))
+		return -EINVAL;
+	fb_sd->fmt.fmt.pix.pixelformat = fmt->fmt.pix.pixelformat;
+	return 0;
+}
+
+/**
+ * v4l2_sd_fb_cropcap() - get cropping capabilities for local fifo input mode
+ *
+ * @sd: pointer to v4l2 subdevice
+ * @cc:
+ */
+static int v4l2_sd_fb_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *cc)
+{
+	struct s3c_fb_win *win = to_fb_win_sd(sd)->win;
+	struct s3c_fb_pd_win *windata = win->windata;
+
+	if (!windata)
+		return -ENODEV;
+
+	mutex_lock(&win->fbinfo->lock);
+
+	cc->defrect.width = windata->win_mode.xres;
+	cc->defrect.height = windata->win_mode.yres;
+	cc->defrect.left = 0;
+	cc->defrect.top = 0;
+	cc->bounds = cc->defrect;
+
+	mutex_unlock(&win->fbinfo->lock);
+
+	return 0;
+}
+
+/**
+ * v4l2_sd_fb_s_crop() - set window position and size
+ *
+ * @sd: pointer to v4l2 subdevice
+ * @cr: cropping rectangle to set for local path mode
+ */
+static int v4l2_sd_fb_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *cr)
+{
+	struct s3c_fb_win_sd *fb_sd = to_fb_win_sd(sd);
+	u32 fourcc = fb_sd->fmt.fmt.pix.pixelformat;
+	struct v4l2_rect *r;
+
+	fb_sd->osd_rect = *cr;
+
+	if (fourcc == V4L2_PIX_FMT_YUYV) {
+		r = &cr->c;
+		r->left = round_down(r->left, 8);
+		r->top = round_down(r->top, 8);
+		r->width = round_down(r->width, 8);
+		r->height = round_down(r->height, 8);
+	}
+
+	return 0;
+}
+
+/**
+ * v4l2_sd_fb_g_crop() - set window position and size
+ *
+ * @sd: pointer to v4l2 subdevice
+ * @cr: rectangle to return current cropping parameters to
+ *
+ * Implements g_crop operation for camera interface driver.
+ */
+static int v4l2_sd_fb_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *cr)
+{
+	struct s3c_fb_win_sd *fb_sd = to_fb_win_sd(sd);
+
+	*cr = fb_sd->osd_rect;
+
+	return 0;
+}
+
+
+static struct v4l2_subdev_core_ops v4l2_sd_core_fb_ops = { NULL };
+
+static struct v4l2_subdev_video_ops v4l2_sd_video_fb_ops = {
+	.s_stream = v4l2_sd_fb_s_stream,
+	.s_fmt = v4l2_sd_fb_s_fmt,
+	.cropcap = v4l2_sd_fb_cropcap,
+	.s_crop = v4l2_sd_fb_s_crop,
+	.g_crop = v4l2_sd_fb_g_crop,
+};
+
+static struct v4l2_subdev_ops v4l2_sd_fb_ops = {
+	.core = &v4l2_sd_core_fb_ops,
+	.video = &v4l2_sd_video_fb_ops,
+};
+
+static int s3c_fb_unregister_subdevices(struct s3c_fb_win *win)
+{
+	int i;
+	struct s3c_fb *sfb = win->parent;
+
+	if (win->index >= S3C_FB_MAX_WIN)
+		return -ENODEV;
+
+	for (i = 0; i < S3C_FB_MAX_WIN_SOURCES; i++) {
+		if (win->sources[i]) {
+			/* remove sub_dev pointer from link */
+			win->sources[i]->link->sub_dev = NULL;
+			kfree(win->sources[i]);
+			dev_dbg(sfb->dev,
+				"s3c-fb subdevice %d removed from window %d\n",
+				i, win->index);
+		}
+	}
+
+	return 0;
+}
+
+/* Create the subdevice per each data source of the framebuffer window.
+   Locking: The caller holds win->parent->dev->mutex. */
+static int s3c_fb_register_subdevices(struct s3c_fb_win *win)
+{
+	int i;
+	struct s3c_fb *sfb = win->parent;
+	struct s3c_fb_pd_win *windata = win->windata;
+	struct s3c_fb_win_sd *win_sd;
+	struct v4l2_rect *r;
+
+
+	if (win->index >= S3C_FB_MAX_WIN)
+		return -ENODEV;
+
+	for (i = 0; i < S3C_FB_MAX_WIN_SOURCES; i++) {
+		if (!windata->fifo_sources[i])
+			continue;
+		win_sd = kzalloc(sizeof(struct s3c_fb_win_sd), GFP_KERNEL);
+		if (win_sd == NULL)
+			return -ENOMEM;
+		win_sd->index = i;
+		win_sd->win = win;
+		win_sd->link = windata->fifo_sources[i];
+		win_sd->streaming = 0;
+		v4l2_subdev_init(&win_sd->sd, &v4l2_sd_fb_ops);
+		snprintf(win_sd->sd.name, sizeof(win_sd->sd.name),
+			 "s3cfb-local");
+
+		/* hook up pointer to slave device */
+		win_sd->link->sub_dev = &win_sd->sd;
+		win->sources[i] = win_sd;
+
+		/* set default rectangle to current window */
+		s3c_fb_get_osd(win, &win_sd->default_rect.c);
+
+		/* set fimc fifo output rectangle to current window */
+		r = &win_sd->osd_rect.c;
+		r->width = windata->win_mode.xres;
+		r->height = windata->win_mode.yres;
+		r->left = 0;
+		r->top = 0;
+
+		win_sd->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24;
+
+		dev_dbg(sfb->dev, "%s(): l:%d t:%d w:%d h:%d",
+			__func__, r->left, r->top, r->width, r->height);
+
+		dev_dbg(sfb->dev, "subdevice %d registered at window %d\n",
+			i, win->index);
+	}
+	return 0;
+}
+
 /**
  * s3c_fb_release_win() - release resources for a framebuffer window.
  * @win: The window to cleanup the resources for.
@@ -1099,6 +1530,7 @@ static void s3c_fb_free_memory(struct s3c_fb *sfb, struct s3c_fb_win *win)
 static void s3c_fb_release_win(struct s3c_fb *sfb, struct s3c_fb_win *win)
 {
 	if (win->fbinfo) {
+		s3c_fb_unregister_subdevices(win);
 		unregister_framebuffer(win->fbinfo);
 		if (&win->fbinfo->cmap)
 			fb_dealloc_cmap(&win->fbinfo->cmap);
@@ -1157,6 +1589,7 @@ static int __devinit s3c_fb_probe_win(struct s3c_fb *sfb, unsigned int win_no,
 	win->windata = windata;
 	win->index = win_no;
 	win->palette_buffer = (u32 *)(win + 1);
+	win->local_path = 0;
 
 	ret = s3c_fb_alloc_memory(sfb, win);
 	if (ret) {
@@ -1212,11 +1645,16 @@ static int __devinit s3c_fb_probe_win(struct s3c_fb *sfb, unsigned int win_no,
 	else
 		dev_err(sfb->dev, "failed to allocate fb cmap\n");
 
+	/* run the check_var and set_par on our configuration. */
 	s3c_fb_set_par(fbinfo);
 
-	dev_dbg(sfb->dev, "about to register framebuffer\n");
+	ret =  s3c_fb_register_subdevices(win);
+	if (ret < 0) {
+		dev_err(sfb->dev, "failed to register s3c-fb subdevices\n");
+		return ret;
+	}
 
-	/* run the check_var and set_par on our configuration. */
+	dev_dbg(sfb->dev, "about to register framebuffer\n");
 
 	ret = register_framebuffer(fbinfo);
 	if (ret < 0) {
-- 
1.7.0.4

