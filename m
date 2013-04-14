Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2468 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3DNP1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 07/30] cx25821: make cx25821_sram_channels const.
Date: Sun, 14 Apr 2013 17:27:03 +0200
Message-Id: <1365953246-8972-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

And get rid of the channel0-11 external pointers and two more unused fields
in cx25821.h.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-alsa.c           |    2 +-
 drivers/media/pci/cx25821/cx25821-audio-upstream.c |   22 +++++++--------
 drivers/media/pci/cx25821/cx25821-core.c           |   28 +++++---------------
 .../media/pci/cx25821/cx25821-video-upstream-ch2.c |   20 +++++++-------
 drivers/media/pci/cx25821/cx25821-video-upstream.c |   22 +++++++--------
 drivers/media/pci/cx25821/cx25821-video.c          |   14 +++++-----
 drivers/media/pci/cx25821/cx25821-video.h          |   15 +----------
 drivers/media/pci/cx25821/cx25821.h                |   26 +++++++-----------
 8 files changed, 57 insertions(+), 92 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index 1858a45..b3cac75 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -151,7 +151,7 @@ static int _cx25821_start_audio_dma(struct cx25821_audio_dev *chip)
 {
 	struct cx25821_audio_buffer *buf = chip->buf;
 	struct cx25821_dev *dev = chip->dev;
-	struct sram_channel *audio_ch =
+	const struct sram_channel *audio_ch =
 	    &cx25821_sram_channels[AUDIO_SRAM_CHANNEL];
 	u32 tmp = 0;
 
diff --git a/drivers/media/pci/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
index ea97320..b9be535 100644
--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
@@ -45,7 +45,7 @@ static int _intr_msk = FLD_AUD_SRC_RISCI1 | FLD_AUD_SRC_OF |
 			FLD_AUD_SRC_SYNC | FLD_AUD_SRC_OPC_ERR;
 
 static int cx25821_sram_channel_setup_upstream_audio(struct cx25821_dev *dev,
-					      struct sram_channel *ch,
+					      const struct sram_channel *ch,
 					      unsigned int bpl, u32 risc)
 {
 	unsigned int i, lines;
@@ -106,7 +106,7 @@ static __le32 *cx25821_risc_field_upstream_audio(struct cx25821_dev *dev,
 						 int fifo_enable)
 {
 	unsigned int line;
-	struct sram_channel *sram_ch =
+	const struct sram_channel *sram_ch =
 		dev->channels[dev->_audio_upstream_channel].sram_channels;
 	int offset = 0;
 
@@ -215,7 +215,7 @@ static void cx25821_free_memory_audio(struct cx25821_dev *dev)
 
 void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 {
-	struct sram_channel *sram_ch =
+	const struct sram_channel *sram_ch =
 		dev->channels[AUDIO_UPSTREAM_SRAM_CHANNEL_B].sram_channels;
 	u32 tmp = 0;
 
@@ -257,7 +257,7 @@ void cx25821_free_mem_upstream_audio(struct cx25821_dev *dev)
 }
 
 static int cx25821_get_audio_data(struct cx25821_dev *dev,
-			   struct sram_channel *sram_ch)
+			   const struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int frame_index_temp = dev->_audioframe_index;
@@ -352,7 +352,7 @@ static void cx25821_audioups_handler(struct work_struct *work)
 }
 
 static int cx25821_openfile_audio(struct cx25821_dev *dev,
-			   struct sram_channel *sram_ch)
+			   const struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int i = 0, j = 0;
@@ -433,7 +433,7 @@ static int cx25821_openfile_audio(struct cx25821_dev *dev,
 }
 
 static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
-						 struct sram_channel *sram_ch,
+						 const struct sram_channel *sram_ch,
 						 int bpl)
 {
 	int ret = 0;
@@ -495,7 +495,7 @@ static int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 {
 	int i = 0;
 	u32 int_msk_tmp;
-	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+	const struct sram_channel *channel = dev->channels[chan_num].sram_channels;
 	dma_addr_t risc_phys_jump_addr;
 	__le32 *rp;
 
@@ -587,7 +587,7 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 	struct cx25821_dev *dev = dev_id;
 	u32 audio_status;
 	int handled = 0;
-	struct sram_channel *sram_ch;
+	const struct sram_channel *sram_ch;
 
 	if (!dev)
 		return -1;
@@ -611,7 +611,7 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 }
 
 static void cx25821_wait_fifo_enable(struct cx25821_dev *dev,
-				     struct sram_channel *sram_ch)
+				     const struct sram_channel *sram_ch)
 {
 	int count = 0;
 	u32 tmp;
@@ -635,7 +635,7 @@ static void cx25821_wait_fifo_enable(struct cx25821_dev *dev,
 }
 
 static int cx25821_start_audio_dma_upstream(struct cx25821_dev *dev,
-					    struct sram_channel *sram_ch)
+					    const struct sram_channel *sram_ch)
 {
 	u32 tmp = 0;
 	int err = 0;
@@ -699,7 +699,7 @@ fail_irq:
 
 int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 {
-	struct sram_channel *sram_ch;
+	const struct sram_channel *sram_ch;
 	int err = 0;
 
 	if (dev->_audio_is_running) {
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 2b38a50..48faf6f 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -48,7 +48,7 @@ EXPORT_SYMBOL(cx25821_devlist_mutex);
 LIST_HEAD(cx25821_devlist);
 EXPORT_SYMBOL(cx25821_devlist);
 
-struct sram_channel cx25821_sram_channels[] = {
+const struct sram_channel cx25821_sram_channels[] = {
 	[SRAM_CH00] = {
 		.i = SRAM_CH00,
 		.name = "VID A",
@@ -317,20 +317,6 @@ struct sram_channel cx25821_sram_channels[] = {
 };
 EXPORT_SYMBOL(cx25821_sram_channels);
 
-struct sram_channel *channel0 = &cx25821_sram_channels[SRAM_CH00];
-struct sram_channel *channel1 = &cx25821_sram_channels[SRAM_CH01];
-struct sram_channel *channel2 = &cx25821_sram_channels[SRAM_CH02];
-struct sram_channel *channel3 = &cx25821_sram_channels[SRAM_CH03];
-struct sram_channel *channel4 = &cx25821_sram_channels[SRAM_CH04];
-struct sram_channel *channel5 = &cx25821_sram_channels[SRAM_CH05];
-struct sram_channel *channel6 = &cx25821_sram_channels[SRAM_CH06];
-struct sram_channel *channel7 = &cx25821_sram_channels[SRAM_CH07];
-struct sram_channel *channel9 = &cx25821_sram_channels[SRAM_CH09];
-struct sram_channel *channel10 = &cx25821_sram_channels[SRAM_CH10];
-struct sram_channel *channel11 = &cx25821_sram_channels[SRAM_CH11];
-
-struct cx25821_dmaqueue mpegq;
-
 static int cx25821_risc_decode(u32 risc)
 {
 	static const char * const instr[16] = {
@@ -457,7 +443,7 @@ static void cx25821_registers_init(struct cx25821_dev *dev)
 }
 
 int cx25821_sram_channel_setup(struct cx25821_dev *dev,
-			       struct sram_channel *ch,
+			       const struct sram_channel *ch,
 			       unsigned int bpl, u32 risc)
 {
 	unsigned int i, lines;
@@ -523,10 +509,9 @@ int cx25821_sram_channel_setup(struct cx25821_dev *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL(cx25821_sram_channel_setup);
 
 int cx25821_sram_channel_setup_audio(struct cx25821_dev *dev,
-				     struct sram_channel *ch,
+				     const struct sram_channel *ch,
 				     unsigned int bpl, u32 risc)
 {
 	unsigned int i, lines;
@@ -592,7 +577,7 @@ int cx25821_sram_channel_setup_audio(struct cx25821_dev *dev,
 }
 EXPORT_SYMBOL(cx25821_sram_channel_setup_audio);
 
-void cx25821_sram_channel_dump(struct cx25821_dev *dev, struct sram_channel *ch)
+void cx25821_sram_channel_dump(struct cx25821_dev *dev, const struct sram_channel *ch)
 {
 	static char *name[] = {
 		"init risc lo",
@@ -652,10 +637,9 @@ void cx25821_sram_channel_dump(struct cx25821_dev *dev, struct sram_channel *ch)
 	pr_warn("        :   cnt2_reg: 0x%08x\n",
 		cx_read(ch->cnt2_reg));
 }
-EXPORT_SYMBOL(cx25821_sram_channel_dump);
 
 void cx25821_sram_channel_dump_audio(struct cx25821_dev *dev,
-				     struct sram_channel *ch)
+				     const struct sram_channel *ch)
 {
 	static const char * const name[] = {
 		"init risc lo",
@@ -803,7 +787,7 @@ void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel_select,
 }
 
 static void cx25821_set_vip_mode(struct cx25821_dev *dev,
-				 struct sram_channel *ch)
+				 const struct sram_channel *ch)
 {
 	cx_write(ch->pix_frmt, PIXEL_FRMT_422);
 	cx_write(ch->vip_ctl, PIXEL_ENGINE_VIP1);
diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
index cf2723c..2381bdc 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
@@ -83,7 +83,7 @@ static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
 					       int fifo_enable, int field_type)
 {
 	unsigned int line, i;
-	struct sram_channel *sram_ch =
+	const struct sram_channel *sram_ch =
 		dev->channels[dev->_channel2_upstream_select].sram_channels;
 	int dist_betwn_starts = bpl * 2;
 
@@ -201,7 +201,7 @@ static int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 
 void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
 {
-	struct sram_channel *sram_ch =
+	const struct sram_channel *sram_ch =
 		dev->channels[VID_UPSTREAM_SRAM_CHANNEL_J].sram_channels;
 	u32 tmp = 0;
 
@@ -257,7 +257,7 @@ void cx25821_free_mem_upstream_ch2(struct cx25821_dev *dev)
 }
 
 static int cx25821_get_frame_ch2(struct cx25821_dev *dev,
-				 struct sram_channel *sram_ch)
+				 const struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int frame_index_temp = dev->_frame_index_ch2;
@@ -363,7 +363,7 @@ static void cx25821_vidups_handler_ch2(struct work_struct *work)
 }
 
 static int cx25821_openfile_ch2(struct cx25821_dev *dev,
-				struct sram_channel *sram_ch)
+				const struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int i = 0, j = 0;
@@ -445,7 +445,7 @@ static int cx25821_openfile_ch2(struct cx25821_dev *dev,
 }
 
 static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
-					       struct sram_channel *sram_ch,
+					       const struct sram_channel *sram_ch,
 					       int bpl)
 {
 	int ret = 0;
@@ -515,7 +515,7 @@ static int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev,
 					  u32 status)
 {
 	u32 int_msk_tmp;
-	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+	const struct sram_channel *channel = dev->channels[chan_num].sram_channels;
 	int singlefield_lines = NTSC_FIELD_HEIGHT;
 	int line_size_in_bytes = Y422_LINE_SZ;
 	int odd_risc_prog_size = 0;
@@ -594,7 +594,7 @@ static irqreturn_t cx25821_upstream_irq_ch2(int irq, void *dev_id)
 	u32 vid_status;
 	int handled = 0;
 	int channel_num = 0;
-	struct sram_channel *sram_ch;
+	const struct sram_channel *sram_ch;
 
 	if (!dev)
 		return -1;
@@ -618,7 +618,7 @@ static irqreturn_t cx25821_upstream_irq_ch2(int irq, void *dev_id)
 }
 
 static void cx25821_set_pixelengine_ch2(struct cx25821_dev *dev,
-					struct sram_channel *ch, int pix_format)
+					const struct sram_channel *ch, int pix_format)
 {
 	int width = WIDTH_D1;
 	int height = dev->_lines_count_ch2;
@@ -652,7 +652,7 @@ static void cx25821_set_pixelengine_ch2(struct cx25821_dev *dev,
 }
 
 static int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
-						struct sram_channel *sram_ch)
+						const struct sram_channel *sram_ch)
 {
 	u32 tmp = 0;
 	int err = 0;
@@ -706,7 +706,7 @@ fail_irq:
 int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 				 int pixel_format)
 {
-	struct sram_channel *sram_ch;
+	const struct sram_channel *sram_ch;
 	u32 tmp;
 	int err = 0;
 	int data_frame_size = 0;
diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
index 7fc9711..223aae7 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
@@ -44,7 +44,7 @@ static int _intr_msk = FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC |
 			FLD_VID_SRC_OPC_ERR;
 
 int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
-					struct sram_channel *ch,
+					const struct sram_channel *ch,
 					unsigned int bpl, u32 risc)
 {
 	unsigned int i, lines;
@@ -135,7 +135,7 @@ static __le32 *cx25821_risc_field_upstream(struct cx25821_dev *dev, __le32 * rp,
 					   int fifo_enable, int field_type)
 {
 	unsigned int line, i;
-	struct sram_channel *sram_ch =
+	const struct sram_channel *sram_ch =
 		dev->channels[dev->_channel_upstream_select].sram_channels;
 	int dist_betwn_starts = bpl * 2;
 
@@ -247,7 +247,7 @@ static int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 
 void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
 {
-	struct sram_channel *sram_ch =
+	const struct sram_channel *sram_ch =
 		dev->channels[VID_UPSTREAM_SRAM_CHANNEL_I].sram_channels;
 	u32 tmp = 0;
 
@@ -301,7 +301,7 @@ void cx25821_free_mem_upstream_ch1(struct cx25821_dev *dev)
 }
 
 static int cx25821_get_frame(struct cx25821_dev *dev,
-			     struct sram_channel *sram_ch)
+			     const struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int frame_index_temp = dev->_frame_index;
@@ -407,7 +407,7 @@ static void cx25821_vidups_handler(struct work_struct *work)
 }
 
 static int cx25821_openfile(struct cx25821_dev *dev,
-			    struct sram_channel *sram_ch)
+			    const struct sram_channel *sram_ch)
 {
 	struct file *myfile;
 	int i = 0, j = 0;
@@ -489,7 +489,7 @@ static int cx25821_openfile(struct cx25821_dev *dev,
 }
 
 static int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
-					   struct sram_channel *sram_ch,
+					   const struct sram_channel *sram_ch,
 					   int bpl)
 {
 	int ret = 0;
@@ -555,7 +555,7 @@ static int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 				      u32 status)
 {
 	u32 int_msk_tmp;
-	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+	const struct sram_channel *channel = dev->channels[chan_num].sram_channels;
 	int singlefield_lines = NTSC_FIELD_HEIGHT;
 	int line_size_in_bytes = Y422_LINE_SZ;
 	int odd_risc_prog_size = 0;
@@ -643,7 +643,7 @@ static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)
 	u32 vid_status;
 	int handled = 0;
 	int channel_num = 0;
-	struct sram_channel *sram_ch;
+	const struct sram_channel *sram_ch;
 
 	if (!dev)
 		return -1;
@@ -668,7 +668,7 @@ static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)
 }
 
 static void cx25821_set_pixelengine(struct cx25821_dev *dev,
-				    struct sram_channel *ch,
+				    const struct sram_channel *ch,
 				    int pix_format)
 {
 	int width = WIDTH_D1;
@@ -701,7 +701,7 @@ static void cx25821_set_pixelengine(struct cx25821_dev *dev,
 }
 
 static int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
-					    struct sram_channel *sram_ch)
+					    const struct sram_channel *sram_ch)
 {
 	u32 tmp = 0;
 	int err = 0;
@@ -755,7 +755,7 @@ fail_irq:
 int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 				 int pixel_format)
 {
-	struct sram_channel *sram_ch;
+	const struct sram_channel *sram_ch;
 	u32 tmp;
 	int err = 0;
 	int data_frame_size = 0;
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 7cd8885..c418e0d 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -258,7 +258,7 @@ int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input)
 int cx25821_start_video_dma(struct cx25821_dev *dev,
 			    struct cx25821_dmaqueue *q,
 			    struct cx25821_buffer *buf,
-			    struct sram_channel *channel)
+			    const struct sram_channel *channel)
 {
 	int tmp = 0;
 
@@ -285,7 +285,7 @@ int cx25821_start_video_dma(struct cx25821_dev *dev,
 
 static int cx25821_restart_video_queue(struct cx25821_dev *dev,
 				       struct cx25821_dmaqueue *q,
-				       struct sram_channel *channel)
+				       const struct sram_channel *channel)
 {
 	struct cx25821_buffer *buf, *prev;
 	struct list_head *item;
@@ -338,7 +338,7 @@ static void cx25821_vid_timeout(unsigned long data)
 {
 	struct cx25821_data *timeout_data = (struct cx25821_data *)data;
 	struct cx25821_dev *dev = timeout_data->dev;
-	struct sram_channel *channel = timeout_data->channel;
+	const struct sram_channel *channel = timeout_data->channel;
 	struct cx25821_dmaqueue *q = &dev->channels[channel->i].vidq;
 	struct cx25821_buffer *buf;
 	unsigned long flags;
@@ -365,7 +365,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 	u32 count = 0;
 	int handled = 0;
 	u32 mask;
-	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+	const struct sram_channel *channel = dev->channels[chan_num].sram_channels;
 
 	mask = cx_read(channel->int_msk);
 	if (0 == (status & mask))
@@ -787,9 +787,11 @@ static int video_release(struct file *file)
 {
 	struct cx25821_fh *fh = file->private_data;
 	struct cx25821_dev *dev = fh->dev;
+	const struct sram_channel *sram_ch =
+		dev->channels[0].sram_channels;
 
 	/* stop the risc engine and fifo */
-	cx_write(channel0->dma_ctl, 0); /* FIFO and RISC disable */
+	cx_write(sram_ch->dma_ctl, 0); /* FIFO and RISC disable */
 
 	/* stop video capture */
 	if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
@@ -923,7 +925,7 @@ static int vidioc_log_status(struct file *file, void *priv)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	struct cx25821_fh *fh = priv;
-	struct sram_channel *sram_ch =
+	const struct sram_channel *sram_ch =
 		dev->channels[fh->channel_id].sram_channels;
 	u32 tmp = 0;
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index eb12e35..505b7f0 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -63,19 +63,6 @@ do {									\
 #define MEDUSA_READ		    910
 #define MEDUSA_WRITE		    911
 
-extern struct sram_channel *channel0;
-extern struct sram_channel *channel1;
-extern struct sram_channel *channel2;
-extern struct sram_channel *channel3;
-extern struct sram_channel *channel4;
-extern struct sram_channel *channel5;
-extern struct sram_channel *channel6;
-extern struct sram_channel *channel7;
-extern struct sram_channel *channel9;
-extern struct sram_channel *channel10;
-extern struct sram_channel *channel11;
-/* extern const u32 *ctrl_classes[]; */
-
 extern unsigned int vid_limit;
 
 #define FORMAT_FLAGS_PACKED       0x01
@@ -98,7 +85,7 @@ extern int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input);
 extern int cx25821_start_video_dma(struct cx25821_dev *dev,
 				   struct cx25821_dmaqueue *q,
 				   struct cx25821_buffer *buf,
-				   struct sram_channel *channel);
+				   const struct sram_channel *channel);
 
 extern int cx25821_set_scale(struct cx25821_dev *dev, unsigned int width,
 			     unsigned int height, enum v4l2_field field);
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index fdeecdf..d7e71f4 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -126,20 +126,11 @@ struct cx25821_fh {
 
 	enum v4l2_priority prio;
 
-	/* video overlay */
-	struct v4l2_window win;
-	struct v4l2_clip *clips;
-	unsigned int nclips;
-
 	/* video capture */
 	struct cx25821_fmt *fmt;
 	unsigned int width, height;
 	int channel_id;
 	struct videobuf_queue vidq;
-
-	/* H264 Encoder specifics ONLY */
-	struct videobuf_queue mpegq;
-	atomic_t v4l_reading;
 };
 
 enum cx25821_itype {
@@ -222,7 +213,7 @@ struct cx25821_dmaqueue {
 
 struct cx25821_data {
 	struct cx25821_dev *dev;
-	struct sram_channel *channel;
+	const struct sram_channel *channel;
 };
 
 struct cx25821_channel {
@@ -237,7 +228,7 @@ struct cx25821_channel {
 	struct video_device *video_dev;
 	struct cx25821_dmaqueue vidq;
 
-	struct sram_channel *sram_channels;
+	const struct sram_channel *sram_channels;
 
 	struct mutex lock;
 	int resources;
@@ -470,7 +461,8 @@ struct sram_channel {
 	u32 jumponly;
 	u32 irq_bit;
 };
-extern struct sram_channel cx25821_sram_channels[];
+
+extern const struct sram_channel cx25821_sram_channels[];
 
 #define STATUS_SUCCESS         0
 #define STATUS_UNSUCCESSFUL    -1
@@ -518,7 +510,7 @@ extern int medusa_set_saturation(struct cx25821_dev *dev, int saturation,
 				 int decoder);
 
 extern int cx25821_sram_channel_setup(struct cx25821_dev *dev,
-				      struct sram_channel *ch, unsigned int bpl,
+				      const struct sram_channel *ch, unsigned int bpl,
 				      u32 risc);
 
 extern int cx25821_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
@@ -537,16 +529,16 @@ extern void cx25821_free_buffer(struct videobuf_queue *q,
 extern int cx25821_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
 				u32 reg, u32 mask, u32 value);
 extern void cx25821_sram_channel_dump(struct cx25821_dev *dev,
-				      struct sram_channel *ch);
+				      const struct sram_channel *ch);
 extern void cx25821_sram_channel_dump_audio(struct cx25821_dev *dev,
-					    struct sram_channel *ch);
+					    const struct sram_channel *ch);
 
 extern struct cx25821_dev *cx25821_dev_get(struct pci_dev *pci);
 extern void cx25821_print_irqbits(char *name, char *tag, char **strings,
 				  int len, u32 bits, u32 mask);
 extern void cx25821_dev_unregister(struct cx25821_dev *dev);
 extern int cx25821_sram_channel_setup_audio(struct cx25821_dev *dev,
-					    struct sram_channel *ch,
+					    const struct sram_channel *ch,
 					    unsigned int bpl, u32 risc);
 
 extern int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev,
@@ -570,7 +562,7 @@ extern void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev);
 extern void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev);
 extern void cx25821_stop_upstream_audio(struct cx25821_dev *dev);
 extern int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
-					       struct sram_channel *ch,
+					       const struct sram_channel *ch,
 					       unsigned int bpl, u32 risc);
 extern void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel,
 				     u32 format);
-- 
1.7.10.4

