Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1309 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab2DWLvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:51:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/8] cx25821: fix compiler warnings.
Date: Mon, 23 Apr 2012 13:51:24 +0200
Message-Id: <99988714e8f04e0d7cbc19a3bc90c93f32d2d2ef.1335181658.git.hans.verkuil@cisco.com>
In-Reply-To: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
References: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
References: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

media_build/v4l/cx25821-core.c: In function 'cx_i2c_read_print':
media_build/v4l/cx25821-core.c:386:6: warning: variable 'value' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-core.c: In function 'cx25821_dev_setup':
media_build/v4l/cx25821-core.c:899:6: warning: variable 'io_size' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-core.c: In function 'cx25821_irq':
media_build/v4l/cx25821-core.c:1321:18: warning: variable 'pci_mask' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-i2c.c: In function 'cx25821_i2c_read':
media_build/v4l/cx25821-i2c.c:365:6: warning: variable 'retval' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-medusa-video.c: In function 'medusa_enable_bluefield_output':
media_build/v4l/cx25821-medusa-video.c:39:6: warning: variable 'ret_val' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-medusa-video.c: In function 'medusa_set_resolution':
media_build/v4l/cx25821-medusa-video.c:435:6: warning: variable 'ret_val' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-medusa-video.c: In function 'medusa_set_decoderduration':
media_build/v4l/cx25821-medusa-video.c:498:6: warning: variable 'ret_val' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-video.c: In function 'cx25821_dump_video_queue':
media_build/v4l/cx25821-video.c:116:25: warning: variable 'buf' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-video.c: In function 'cx25821_buffer_prepare':
media_build/v4l/cx25821-video.c:561:20: warning: variable 'line1_offset' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-video.c: In function 'video_ioctl_set':
media_build/v4l/cx25821-video.c:1834:6: warning: variable 'value' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-video-upstream.c: In function 'cx25821_upstream_irq':
media_build/v4l/cx25821-video-upstream.c:641:6: warning: variable 'msk_stat' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-video-upstream-ch2.c: In function 'cx25821_upstream_irq_ch2':
media_build/v4l/cx25821-video-upstream-ch2.c:591:6: warning: variable 'msk_stat' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx25821-audio-upstream.c: In function 'cx25821_upstream_irq_audio':
media_build/v4l/cx25821-audio-upstream.c:589:6: warning: variable 'msk_stat' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/video/cx25821/cx25821-audio-upstream.c   |    3 +--
 drivers/media/video/cx25821/cx25821-core.c         |   14 ++---------
 drivers/media/video/cx25821/cx25821-i2c.c          |    3 +--
 drivers/media/video/cx25821/cx25821-medusa-video.c |   13 ++++------
 .../video/cx25821/cx25821-video-upstream-ch2.c     |    3 +--
 .../media/video/cx25821/cx25821-video-upstream.c   |    3 +--
 drivers/media/video/cx25821/cx25821-video.c        |   25 ++------------------
 drivers/media/video/cx25821/cx25821-video.h        |    2 --
 8 files changed, 13 insertions(+), 53 deletions(-)

diff --git a/drivers/media/video/cx25821/cx25821-audio-upstream.c b/drivers/media/video/cx25821/cx25821-audio-upstream.c
index 20c7ca3..8b2a999 100644
--- a/drivers/media/video/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/video/cx25821/cx25821-audio-upstream.c
@@ -585,7 +585,7 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 {
 	struct cx25821_dev *dev = dev_id;
-	u32 msk_stat, audio_status;
+	u32 audio_status;
 	int handled = 0;
 	struct sram_channel *sram_ch;
 
@@ -594,7 +594,6 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 
 	sram_ch = dev->channels[dev->_audio_upstream_channel].sram_channels;
 
-	msk_stat = cx_read(sram_ch->int_mstat);
 	audio_status = cx_read(sram_ch->int_stat);
 
 	/* Only deal with our interrupt */
diff --git a/drivers/media/video/cx25821/cx25821-core.c b/drivers/media/video/cx25821/cx25821-core.c
index 7930ca5..83c1aa6 100644
--- a/drivers/media/video/cx25821/cx25821-core.c
+++ b/drivers/media/video/cx25821/cx25821-core.c
@@ -379,14 +379,6 @@ static inline int i2c_slave_did_ack(struct i2c_adapter *i2c_adap)
 	return cx_read(bus->reg_stat) & 0x01;
 }
 
-void cx_i2c_read_print(struct cx25821_dev *dev, u32 reg, const char *reg_string)
-{
-	int tmp = 0;
-	u32 value = 0;
-
-	value = cx25821_i2c_read(&dev->i2c_bus[0], reg, &tmp);
-}
-
 static void cx25821_registers_init(struct cx25821_dev *dev)
 {
 	u32 tmp;
@@ -895,7 +887,7 @@ static void cx25821_iounmap(struct cx25821_dev *dev)
 
 static int cx25821_dev_setup(struct cx25821_dev *dev)
 {
-	int io_size = 0, i;
+	int i;
 
 	pr_info("\n***********************************\n");
 	pr_info("cx25821 set up\n");
@@ -960,7 +952,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	/* PCIe stuff */
 	dev->base_io_addr = pci_resource_start(dev->pci, 0);
-	io_size = pci_resource_len(dev->pci, 0);
 
 	if (!dev->base_io_addr) {
 		CX25821_ERR("No PCI Memory resources, exiting!\n");
@@ -1317,13 +1308,12 @@ void cx25821_free_buffer(struct videobuf_queue *q, struct cx25821_buffer *buf)
 static irqreturn_t cx25821_irq(int irq, void *dev_id)
 {
 	struct cx25821_dev *dev = dev_id;
-	u32 pci_status, pci_mask;
+	u32 pci_status;
 	u32 vid_status;
 	int i, handled = 0;
 	u32 mask[8] = { 1, 2, 4, 8, 16, 32, 64, 128 };
 
 	pci_status = cx_read(PCI_INT_STAT);
-	pci_mask = cx_read(PCI_INT_MSK);
 
 	if (pci_status == 0)
 		goto out;
diff --git a/drivers/media/video/cx25821/cx25821-i2c.c b/drivers/media/video/cx25821/cx25821-i2c.c
index 12d7300..6311180 100644
--- a/drivers/media/video/cx25821/cx25821-i2c.c
+++ b/drivers/media/video/cx25821/cx25821-i2c.c
@@ -361,7 +361,6 @@ void cx25821_av_clk(struct cx25821_dev *dev, int enable)
 int cx25821_i2c_read(struct cx25821_i2c *bus, u16 reg_addr, int *value)
 {
 	struct i2c_client *client = &bus->i2c_client;
-	int retval = 0;
 	int v = 0;
 	u8 addr[2] = { 0, 0 };
 	u8 buf[4] = { 0, 0, 0, 0 };
@@ -385,7 +384,7 @@ int cx25821_i2c_read(struct cx25821_i2c *bus, u16 reg_addr, int *value)
 	msgs[0].addr = 0x44;
 	msgs[1].addr = 0x44;
 
-	retval = i2c_xfer(client->adapter, msgs, 2);
+	i2c_xfer(client->adapter, msgs, 2);
 
 	v = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
 	*value = v;
diff --git a/drivers/media/video/cx25821/cx25821-medusa-video.c b/drivers/media/video/cx25821/cx25821-medusa-video.c
index 298a68d..313fb20 100644
--- a/drivers/media/video/cx25821/cx25821-medusa-video.c
+++ b/drivers/media/video/cx25821/cx25821-medusa-video.c
@@ -35,7 +35,6 @@
 static void medusa_enable_bluefield_output(struct cx25821_dev *dev, int channel,
 					   int enable)
 {
-	int ret_val = 1;
 	u32 value = 0;
 	u32 tmp = 0;
 	int out_ctrl = OUT_CTRL1;
@@ -79,13 +78,13 @@ static void medusa_enable_bluefield_output(struct cx25821_dev *dev, int channel,
 	value &= 0xFFFFFF7F;	/* clear BLUE_FIELD_EN */
 	if (enable)
 		value |= 0x00000080;	/* set BLUE_FIELD_EN */
-	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], out_ctrl, value);
+	cx25821_i2c_write(&dev->i2c_bus[0], out_ctrl, value);
 
 	value = cx25821_i2c_read(&dev->i2c_bus[0], out_ctrl_ns, &tmp);
 	value &= 0xFFFFFF7F;
 	if (enable)
 		value |= 0x00000080;	/* set BLUE_FIELD_EN */
-	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], out_ctrl_ns, value);
+	cx25821_i2c_write(&dev->i2c_bus[0], out_ctrl_ns, value);
 }
 
 static int medusa_initialize_ntsc(struct cx25821_dev *dev)
@@ -431,7 +430,6 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 {
 	int decoder = 0;
 	int decoder_count = 0;
-	int ret_val = 0;
 	u32 hscale = 0x0;
 	u32 vscale = 0x0;
 	const int MAX_WIDTH = 720;
@@ -482,9 +480,9 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 
 	for (; decoder < decoder_count; decoder++) {
 		/* write scaling values for each decoder */
-		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+		cx25821_i2c_write(&dev->i2c_bus[0],
 				HSCALE_CTRL + (0x200 * decoder), hscale);
-		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+		cx25821_i2c_write(&dev->i2c_bus[0],
 				VSCALE_CTRL + (0x200 * decoder), vscale);
 	}
 
@@ -494,7 +492,6 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 				       int duration)
 {
-	int ret_val = 0;
 	u32 fld_cnt = 0;
 	u32 tmp = 0;
 	u32 disp_cnt_reg = DISP_AB_CNT;
@@ -537,7 +534,7 @@ static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 		fld_cnt |= ((u32) duration) << 16;
 	}
 
-	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], disp_cnt_reg, fld_cnt);
+	cx25821_i2c_write(&dev->i2c_bus[0], disp_cnt_reg, fld_cnt);
 
 	mutex_unlock(&dev->lock);
 }
diff --git a/drivers/media/video/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/video/cx25821/cx25821-video-upstream-ch2.c
index 5a157cf..c8c94fb 100644
--- a/drivers/media/video/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/media/video/cx25821/cx25821-video-upstream-ch2.c
@@ -587,7 +587,7 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
 static irqreturn_t cx25821_upstream_irq_ch2(int irq, void *dev_id)
 {
 	struct cx25821_dev *dev = dev_id;
-	u32 msk_stat, vid_status;
+	u32 vid_status;
 	int handled = 0;
 	int channel_num = 0;
 	struct sram_channel *sram_ch;
@@ -598,7 +598,6 @@ static irqreturn_t cx25821_upstream_irq_ch2(int irq, void *dev_id)
 	channel_num = VID_UPSTREAM_SRAM_CHANNEL_J;
 	sram_ch = dev->channels[channel_num].sram_channels;
 
-	msk_stat = cx_read(sram_ch->int_mstat);
 	vid_status = cx_read(sram_ch->int_stat);
 
 	/* Only deal with our interrupt */
diff --git a/drivers/media/video/cx25821/cx25821-video-upstream.c b/drivers/media/video/cx25821/cx25821-video-upstream.c
index 21e7d65..52c13e0 100644
--- a/drivers/media/video/cx25821/cx25821-video-upstream.c
+++ b/drivers/media/video/cx25821/cx25821-video-upstream.c
@@ -637,7 +637,7 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)
 {
 	struct cx25821_dev *dev = dev_id;
-	u32 msk_stat, vid_status;
+	u32 vid_status;
 	int handled = 0;
 	int channel_num = 0;
 	struct sram_channel *sram_ch;
@@ -649,7 +649,6 @@ static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)
 
 	sram_ch = dev->channels[channel_num].sram_channels;
 
-	msk_stat = cx_read(sram_ch->int_mstat);
 	vid_status = cx_read(sram_ch->int_stat);
 
 	/* Only deal with our interrupt */
diff --git a/drivers/media/video/cx25821/cx25821-video.c b/drivers/media/video/cx25821/cx25821-video.c
index ffd8bc7..b38d437 100644
--- a/drivers/media/video/cx25821/cx25821-video.c
+++ b/drivers/media/video/cx25821/cx25821-video.c
@@ -109,25 +109,6 @@ struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc)
 	return NULL;
 }
 
-void cx25821_dump_video_queue(struct cx25821_dev *dev,
-			      struct cx25821_dmaqueue *q)
-{
-	struct cx25821_buffer *buf;
-	struct list_head *item;
-	dprintk(1, "%s()\n", __func__);
-
-	if (!list_empty(&q->active)) {
-		list_for_each(item, &q->active)
-			buf = list_entry(item, struct cx25821_buffer, vb.queue);
-	}
-
-	if (!list_empty(&q->queued)) {
-		list_for_each(item, &q->queued)
-			buf = list_entry(item, struct cx25821_buffer, vb.queue);
-	}
-
-}
-
 void cx25821_video_wakeup(struct cx25821_dev *dev, struct cx25821_dmaqueue *q,
 			  u32 count)
 {
@@ -557,7 +538,7 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	struct cx25821_buffer *buf =
 		container_of(vb, struct cx25821_buffer, vb);
 	int rc, init_buffer = 0;
-	u32 line0_offset, line1_offset;
+	u32 line0_offset;
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
 	int bpl_local = LINE_SIZE_D1;
 	int channel_opened = fh->channel_id;
@@ -639,7 +620,6 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		case V4L2_FIELD_INTERLACED:
 			/* All other formats are top field first */
 			line0_offset = 0;
-			line1_offset = buf->bpl;
 			dprintk(1, "top field first\n");
 
 			cx25821_risc_buffer(dev->pci, &buf->risc,
@@ -1830,7 +1810,6 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 	int i = 0;
 	int cif_enable = 0;
 	int cif_width = 0;
-	u32 value = 0;
 
 	data_from_user = (struct downstream_user_struct *)arg;
 
@@ -1914,7 +1893,7 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 		cx_write(data_from_user->reg_address, data_from_user->reg_data);
 		break;
 	case MEDUSA_READ:
-		value = cx25821_i2c_read(&dev->i2c_bus[0],
+		cx25821_i2c_read(&dev->i2c_bus[0],
 					 (u16) data_from_user->reg_address,
 					 &data_from_user->reg_data);
 		break;
diff --git a/drivers/media/video/cx25821/cx25821-video.h b/drivers/media/video/cx25821/cx25821-video.h
index d0d9538..9652a5e 100644
--- a/drivers/media/video/cx25821/cx25821-video.h
+++ b/drivers/media/video/cx25821/cx25821-video.h
@@ -86,8 +86,6 @@ extern struct cx25821_fmt formats[];
 extern struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc);
 extern struct cx25821_data timeout_data[MAX_VID_CHANNEL_NUM];
 
-extern void cx25821_dump_video_queue(struct cx25821_dev *dev,
-				     struct cx25821_dmaqueue *q);
 extern void cx25821_video_wakeup(struct cx25821_dev *dev,
 				 struct cx25821_dmaqueue *q, u32 count);
 
-- 
1.7.10

