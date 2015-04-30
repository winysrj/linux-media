Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbbD3OI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mikhail Domrachev <mihail.domrychev@comexp.ru>
Subject: [PATCH 19/22] saa7134: change the debug macros for video and vbi
Date: Thu, 30 Apr 2015 11:08:39 -0300
Message-Id: <868b316c5747a62658592eb5db4a61268f7f858d.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rename the macro to vbi_dbg()/video_dbg() and use pr_fmt(),
to be coherent with the other debug macro changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 109c2ffeab93..face07bf420d 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -38,8 +38,8 @@ static unsigned int vbibufs = 4;
 module_param(vbibufs, int, 0444);
 MODULE_PARM_DESC(vbibufs,"number of vbi buffers, range 2-32");
 
-#define dprintk(fmt, arg...)	if (vbi_debug) \
-	printk(KERN_DEBUG "%s/vbi: " fmt, dev->name , ## arg)
+#define vbi_dbg(fmt, arg...)	if (vbi_debug) \
+	printk(KERN_DEBUG pr_fmt("vbi: " fmt), ## arg)
 
 /* ------------------------------------------------------------------ */
 
@@ -84,7 +84,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2_queue->drv_priv;
 	unsigned long control, base;
 
-	dprintk("buffer_activate [%p]\n", buf);
+	vbi_dbg("buffer_activate [%p]\n", buf);
 	buf->top_seen = 0;
 
 	task_init(dev, buf, TASK_A);
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index f7dcdccfc307..525ae6837fb3 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -52,8 +52,8 @@ module_param_string(secam, secam, sizeof(secam), 0644);
 MODULE_PARM_DESC(secam, "force SECAM variant, either DK,L or Lc");
 
 
-#define dprintk(fmt, arg...)	if (video_debug&0x04) \
-	printk(KERN_DEBUG "%s/video: " fmt, dev->name , ## arg)
+#define video_dbg(fmt, arg...)	if (video_debug & 0x04) \
+	printk(KERN_DEBUG pr_fmt("video: " fmt), ## arg)
 
 /* ------------------------------------------------------------------ */
 /* Defines for Video Output Port Register at address 0x191            */
@@ -385,7 +385,7 @@ static struct saa7134_format* format_by_fourcc(unsigned int fourcc)
 
 static void set_tvnorm(struct saa7134_dev *dev, struct saa7134_tvnorm *norm)
 {
-	dprintk("set tv norm = %s\n",norm->name);
+	video_dbg("set tv norm = %s\n",norm->name);
 	dev->tvnorm = norm;
 
 	/* setup cropping */
@@ -407,7 +407,7 @@ static void set_tvnorm(struct saa7134_dev *dev, struct saa7134_tvnorm *norm)
 
 static void video_mux(struct saa7134_dev *dev, int input)
 {
-	dprintk("video input = %d [%s]\n", input, card_in(dev, input).name);
+	video_dbg("video input = %d [%s]\n", input, card_in(dev, input).name);
 	dev->ctl_input = input;
 	set_tvnorm(dev, dev->tvnorm);
 	saa7134_tvaudio_setinput(dev, &card_in(dev, input));
@@ -531,14 +531,14 @@ static void set_v_scale(struct saa7134_dev *dev, int task, int yscale)
 	mirror = (dev->ctl_mirror) ? 0x02 : 0x00;
 	if (yscale < 2048) {
 		/* LPI */
-		dprintk("yscale LPI yscale=%d\n",yscale);
+		video_dbg("yscale LPI yscale=%d\n",yscale);
 		saa_writeb(SAA7134_V_FILTER(task), 0x00 | mirror);
 		saa_writeb(SAA7134_LUMA_CONTRAST(task), 0x40);
 		saa_writeb(SAA7134_CHROMA_SATURATION(task), 0x40);
 	} else {
 		/* ACM */
 		val = 0x40 * 1024 / yscale;
-		dprintk("yscale ACM yscale=%d val=0x%x\n",yscale,val);
+		video_dbg("yscale ACM yscale=%d val=0x%x\n",yscale,val);
 		saa_writeb(SAA7134_V_FILTER(task), 0x01 | mirror);
 		saa_writeb(SAA7134_LUMA_CONTRAST(task), val);
 		saa_writeb(SAA7134_CHROMA_SATURATION(task), val);
@@ -573,7 +573,7 @@ static void set_size(struct saa7134_dev *dev, int task,
 		prescale = 1;
 	xscale = 1024 * dev->crop_current.width / prescale / width;
 	yscale = 512 * div * dev->crop_current.height / height;
-	dprintk("prescale=%d xscale=%d yscale=%d\n",prescale,xscale,yscale);
+	video_dbg("prescale=%d xscale=%d yscale=%d\n",prescale,xscale,yscale);
 	set_h_prescale(dev,task,prescale);
 	saa_writeb(SAA7134_H_SCALE_INC1(task),      xscale &  0xff);
 	saa_writeb(SAA7134_H_SCALE_INC2(task),      xscale >> 8);
@@ -615,7 +615,7 @@ static void set_cliplist(struct saa7134_dev *dev, int reg,
 		saa_writeb(reg + 0, winbits);
 		saa_writeb(reg + 2, cl[i].position & 0xff);
 		saa_writeb(reg + 3, cl[i].position >> 8);
-		dprintk("clip: %s winbits=%02x pos=%d\n",
+		video_dbg("clip: %s winbits=%02x pos=%d\n",
 			name,winbits,cl[i].position);
 		reg += 8;
 	}
@@ -730,7 +730,7 @@ static int start_preview(struct saa7134_dev *dev)
 		return err;
 
 	dev->ovfield = dev->win.field;
-	dprintk("start_preview %dx%d+%d+%d %s field=%s\n",
+	video_dbg("start_preview %dx%d+%d+%d %s field=%s\n",
 		dev->win.w.width, dev->win.w.height,
 		dev->win.w.left, dev->win.w.top,
 		dev->ovfmt->name, v4l2_field_names[dev->ovfield]);
@@ -792,7 +792,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 	unsigned long base,control,bpl;
 	unsigned long bpl_uv,lines_uv,base2,base3,tmp; /* planar */
 
-	dprintk("buffer_activate buf=%p\n",buf);
+	video_dbg("buffer_activate buf=%p\n",buf);
 	buf->top_seen = 0;
 
 	set_size(dev, TASK_A, dev->width, dev->height,
@@ -837,7 +837,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 		base3    = base2 + bpl_uv * lines_uv;
 		if (dev->fmt->uvswap)
 			tmp = base2, base2 = base3, base3 = tmp;
-		dprintk("uv: bpl=%ld lines=%ld base2/3=%ld/%ld\n",
+		video_dbg("uv: bpl=%ld lines=%ld base2/3=%ld/%ld\n",
 			bpl_uv,lines_uv,base2,base3);
 		if (V4L2_FIELD_HAS_BOTH(dev->field)) {
 			/* interlaced */
@@ -1795,7 +1795,7 @@ static int saa7134_overlay(struct file *file, void *priv, unsigned int on)
 
 	if (on) {
 		if (saa7134_no_overlay > 0) {
-			dprintk("no_overlay\n");
+			video_dbg("no_overlay\n");
 			return -EINVAL;
 		}
 
@@ -2184,7 +2184,7 @@ void saa7134_irq_video_signalchange(struct saa7134_dev *dev)
 
 	st1 = saa_readb(SAA7134_STATUS_VIDEO1);
 	st2 = saa_readb(SAA7134_STATUS_VIDEO2);
-	dprintk("DCSDT: pll: %s, sync: %s, norm: %s\n",
+	video_dbg("DCSDT: pll: %s, sync: %s, norm: %s\n",
 		(st1 & 0x40) ? "not locked" : "locked",
 		(st2 & 0x40) ? "no"         : "yes",
 		st[st1 & 0x03]);
-- 
2.1.0

