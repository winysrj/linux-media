Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab2J0UmT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:19 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgJTZ019837
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:19 -0400
Received: from pedra (vpn1-4-98.gru2.redhat.com [10.97.4.98])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q9RKg24Z014004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:18 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/68] [media] cx25821: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:30 -0200
Message-Id: <1351370486-29040-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/cx25821/cx25821-audio-upstream.c:136:5: warning: no previous prototype for 'cx25821_risc_buffer_upstream_audio' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-audio-upstream.c:200:6: warning: no previous prototype for 'cx25821_free_memory_audio' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-audio-upstream.c:259:5: warning: no previous prototype for 'cx25821_get_audio_data' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-audio-upstream.c:354:5: warning: no previous prototype for 'cx25821_openfile_audio' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-audio-upstream.c:47:5: warning: no previous prototype for 'cx25821_sram_channel_setup_upstream_audio' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-audio-upstream.c:493:5: warning: no previous prototype for 'cx25821_audio_upstream_irq' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-audio-upstream.c:637:5: warning: no previous prototype for 'cx25821_start_audio_dma_upstream' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-biffuncs.h:28:11: warning: no previous prototype for 'getBit' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-biffuncs.h:33:12: warning: no previous prototype for 'clearBitAtPos' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-biffuncs.h:38:12: warning: no previous prototype for 'setBitAtPos' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-i2c.c:332:6: warning: no previous prototype for 'cx25821_av_clk' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video.c:294:5: warning: no previous prototype for 'cx25821_restart_video_queue' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video.c:345:6: warning: no previous prototype for 'cx25821_vid_timeout' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream.c:176:5: warning: no previous prototype for 'cx25821_risc_buffer_upstream' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream.c:303:5: warning: no previous prototype for 'cx25821_get_frame' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream.c:408:5: warning: no previous prototype for 'cx25821_openfile' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream.c:489:5: warning: no previous prototype for 'cx25821_upstream_buffer_prepare' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream.c:551:5: warning: no previous prototype for 'cx25821_video_upstream_irq' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream.c:667:6: warning: no previous prototype for 'cx25821_set_pixelengine' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream.c:699:5: warning: no previous prototype for 'cx25821_start_video_dma_upstream' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c:126:5: warning: no previous prototype for 'cx25821_risc_buffer_upstream_ch2' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c:258:5: warning: no previous prototype for 'cx25821_get_frame_ch2' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c:363:5: warning: no previous prototype for 'cx25821_openfile_ch2' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c:510:5: warning: no previous prototype for 'cx25821_video_upstream_irq_ch2' [-Wmissing-prototypes]
drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c:650:5: warning: no previous prototype for 'cx25821_start_video_dma_upstream_ch2' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 16 +++++------
 drivers/media/pci/cx25821/cx25821-biffuncs.h       |  6 ++--
 drivers/media/pci/cx25821/cx25821-i2c.c            |  4 ++-
 .../media/pci/cx25821/cx25821-video-upstream-ch2.c | 24 +++++++++-------
 drivers/media/pci/cx25821/cx25821-video-upstream.c | 32 ++++++++++++----------
 drivers/media/pci/cx25821/cx25821-video.c          |  8 +++---
 6 files changed, 50 insertions(+), 40 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
index 8b2a999..ad84613 100644
--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
@@ -44,7 +44,7 @@ MODULE_LICENSE("GPL");
 static int _intr_msk = FLD_AUD_SRC_RISCI1 | FLD_AUD_SRC_OF |
 			FLD_AUD_SRC_SYNC | FLD_AUD_SRC_OPC_ERR;
 
-int cx25821_sram_channel_setup_upstream_audio(struct cx25821_dev *dev,
+static int cx25821_sram_channel_setup_upstream_audio(struct cx25821_dev *dev,
 					      struct sram_channel *ch,
 					      unsigned int bpl, u32 risc)
 {
@@ -133,7 +133,7 @@ static __le32 *cx25821_risc_field_upstream_audio(struct cx25821_dev *dev,
 	return rp;
 }
 
-int cx25821_risc_buffer_upstream_audio(struct cx25821_dev *dev,
+static int cx25821_risc_buffer_upstream_audio(struct cx25821_dev *dev,
 				       struct pci_dev *pci,
 				       unsigned int bpl, unsigned int lines)
 {
@@ -197,7 +197,7 @@ int cx25821_risc_buffer_upstream_audio(struct cx25821_dev *dev,
 	return 0;
 }
 
-void cx25821_free_memory_audio(struct cx25821_dev *dev)
+static void cx25821_free_memory_audio(struct cx25821_dev *dev)
 {
 	if (dev->_risc_virt_addr) {
 		pci_free_consistent(dev->pci, dev->_audiorisc_size,
@@ -256,7 +256,7 @@ void cx25821_free_mem_upstream_audio(struct cx25821_dev *dev)
 	cx25821_free_memory_audio(dev);
 }
 
-int cx25821_get_audio_data(struct cx25821_dev *dev,
+static int cx25821_get_audio_data(struct cx25821_dev *dev,
 			   struct sram_channel *sram_ch)
 {
 	struct file *myfile;
@@ -351,7 +351,7 @@ static void cx25821_audioups_handler(struct work_struct *work)
 			sram_channels);
 }
 
-int cx25821_openfile_audio(struct cx25821_dev *dev,
+static int cx25821_openfile_audio(struct cx25821_dev *dev,
 			   struct sram_channel *sram_ch)
 {
 	struct file *myfile;
@@ -490,7 +490,7 @@ error:
 	return ret;
 }
 
-int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
+static int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 			       u32 status)
 {
 	int i = 0;
@@ -634,8 +634,8 @@ static void cx25821_wait_fifo_enable(struct cx25821_dev *dev,
 
 }
 
-int cx25821_start_audio_dma_upstream(struct cx25821_dev *dev,
-				     struct sram_channel *sram_ch)
+static int cx25821_start_audio_dma_upstream(struct cx25821_dev *dev,
+					    struct sram_channel *sram_ch)
 {
 	u32 tmp = 0;
 	int err = 0;
diff --git a/drivers/media/pci/cx25821/cx25821-biffuncs.h b/drivers/media/pci/cx25821/cx25821-biffuncs.h
index 9326a7c..937f5a7 100644
--- a/drivers/media/pci/cx25821/cx25821-biffuncs.h
+++ b/drivers/media/pci/cx25821/cx25821-biffuncs.h
@@ -25,17 +25,17 @@
 
 #define SetBit(Bit)  (1 << Bit)
 
-inline u8 getBit(u32 sample, u8 index)
+static inline u8 getBit(u32 sample, u8 index)
 {
 	return (u8) ((sample >> index) & 1);
 }
 
-inline u32 clearBitAtPos(u32 value, u8 bit)
+static inline u32 clearBitAtPos(u32 value, u8 bit)
 {
 	return value & ~(1 << bit);
 }
 
-inline u32 setBitAtPos(u32 sample, u8 bit)
+static inline u32 setBitAtPos(u32 sample, u8 bit)
 {
 	sample |= (1 << bit);
 	return sample;
diff --git a/drivers/media/pci/cx25821/cx25821-i2c.c b/drivers/media/pci/cx25821/cx25821-i2c.c
index 9844549..a8dc945 100644
--- a/drivers/media/pci/cx25821/cx25821-i2c.c
+++ b/drivers/media/pci/cx25821/cx25821-i2c.c
@@ -329,7 +329,8 @@ int cx25821_i2c_unregister(struct cx25821_i2c *bus)
 	return 0;
 }
 
-void cx25821_av_clk(struct cx25821_dev *dev, int enable)
+#if 0 /* Currently unused */
+static void cx25821_av_clk(struct cx25821_dev *dev, int enable)
 {
 	/* write 0 to bus 2 addr 0x144 via i2x_xfer() */
 	char buffer[3];
@@ -351,6 +352,7 @@ void cx25821_av_clk(struct cx25821_dev *dev, int enable)
 
 	i2c_xfer(&dev->i2c_bus[0].i2c_adap, &msg, 1);
 }
+#endif
 
 int cx25821_i2c_read(struct cx25821_i2c *bus, u16 reg_addr, int *value)
 {
diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
index d33fc1a..f7a6e6b 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
@@ -123,10 +123,11 @@ static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
 	return rp;
 }
 
-int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
-				     struct pci_dev *pci,
-				     unsigned int top_offset, unsigned int bpl,
-				     unsigned int lines)
+static int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
+					    struct pci_dev *pci,
+					    unsigned int top_offset,
+					    unsigned int bpl,
+					    unsigned int lines)
 {
 	__le32 *rp;
 	int fifo_enable = 0;
@@ -255,7 +256,8 @@ void cx25821_free_mem_upstream_ch2(struct cx25821_dev *dev)
 	}
 }
 
-int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
+static int cx25821_get_frame_ch2(struct cx25821_dev *dev,
+				 struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int frame_index_temp = dev->_frame_index_ch2;
@@ -360,7 +362,8 @@ static void cx25821_vidups_handler_ch2(struct work_struct *work)
 			_channel2_upstream_select].sram_channels);
 }
 
-int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
+static int cx25821_openfile_ch2(struct cx25821_dev *dev,
+				struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int i = 0, j = 0;
@@ -507,8 +510,9 @@ error:
 	return ret;
 }
 
-int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
-				   u32 status)
+static int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev,
+					  int chan_num,
+					  u32 status)
 {
 	u32 int_msk_tmp;
 	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
@@ -647,8 +651,8 @@ static void cx25821_set_pixelengine_ch2(struct cx25821_dev *dev,
 	cx_write(ch->vid_cdt_size, VID_CDT_SIZE >> 3);
 }
 
-int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
-					 struct sram_channel *sram_ch)
+static int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
+						struct sram_channel *sram_ch)
 {
 	u32 tmp = 0;
 	int err = 0;
diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
index 6759fff..cca643c 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
@@ -173,10 +173,10 @@ static __le32 *cx25821_risc_field_upstream(struct cx25821_dev *dev, __le32 * rp,
 	return rp;
 }
 
-int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
-				 struct pci_dev *pci,
-				 unsigned int top_offset,
-				 unsigned int bpl, unsigned int lines)
+static int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
+					struct pci_dev *pci,
+					unsigned int top_offset,
+					unsigned int bpl, unsigned int lines)
 {
 	__le32 *rp;
 	int fifo_enable = 0;
@@ -300,7 +300,8 @@ void cx25821_free_mem_upstream_ch1(struct cx25821_dev *dev)
 	}
 }
 
-int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
+static int cx25821_get_frame(struct cx25821_dev *dev,
+			     struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int frame_index_temp = dev->_frame_index;
@@ -405,7 +406,8 @@ static void cx25821_vidups_handler(struct work_struct *work)
 			sram_channels);
 }
 
-int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
+static int cx25821_openfile(struct cx25821_dev *dev,
+			    struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int i = 0, j = 0;
@@ -486,8 +488,9 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 	return 0;
 }
 
-int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
-				    struct sram_channel *sram_ch, int bpl)
+static int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
+					   struct sram_channel *sram_ch,
+					   int bpl)
 {
 	int ret = 0;
 	dma_addr_t dma_addr;
@@ -548,8 +551,8 @@ error:
 	return ret;
 }
 
-int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
-			       u32 status)
+static int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
+				      u32 status)
 {
 	u32 int_msk_tmp;
 	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
@@ -664,8 +667,9 @@ static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-void cx25821_set_pixelengine(struct cx25821_dev *dev, struct sram_channel *ch,
-			     int pix_format)
+static void cx25821_set_pixelengine(struct cx25821_dev *dev,
+				    struct sram_channel *ch,
+				    int pix_format)
 {
 	int width = WIDTH_D1;
 	int height = dev->_lines_count;
@@ -696,8 +700,8 @@ void cx25821_set_pixelengine(struct cx25821_dev *dev, struct sram_channel *ch,
 	cx_write(ch->vid_cdt_size, VID_CDT_SIZE >> 3);
 }
 
-int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
-				     struct sram_channel *sram_ch)
+static int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
+					    struct sram_channel *sram_ch)
 {
 	u32 tmp = 0;
 	int err = 0;
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 0a80245..53b16dd 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -291,9 +291,9 @@ int cx25821_start_video_dma(struct cx25821_dev *dev,
 	return 0;
 }
 
-int cx25821_restart_video_queue(struct cx25821_dev *dev,
-				struct cx25821_dmaqueue *q,
-				struct sram_channel *channel)
+static int cx25821_restart_video_queue(struct cx25821_dev *dev,
+				       struct cx25821_dmaqueue *q,
+				       struct sram_channel *channel)
 {
 	struct cx25821_buffer *buf, *prev;
 	struct list_head *item;
@@ -342,7 +342,7 @@ int cx25821_restart_video_queue(struct cx25821_dev *dev,
 	}
 }
 
-void cx25821_vid_timeout(unsigned long data)
+static void cx25821_vid_timeout(unsigned long data)
 {
 	struct cx25821_data *timeout_data = (struct cx25821_data *)data;
 	struct cx25821_dev *dev = timeout_data->dev;
-- 
1.7.11.7

