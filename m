Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbbEMRRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 13:17:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Takashi Iwai <tiwai@suse.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mikhail Domrachev <mihail.domrychev@comexp.ru>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH 2/2] [media] saa7134: fix CodingStyle issues on the lines touched by pr_foo refactor
Date: Wed, 13 May 2015 14:17:25 -0300
Message-Id: <6139ebc65807e6d3bf60128cc42e85bcb7f578ba.1431537416.git.mchehab@osg.samsung.com>
In-Reply-To: <45f38cb3b80311ade3c87000f7d7a8f6ebd60a43.1431537416.git.mchehab@osg.samsung.com>
References: <45f38cb3b80311ade3c87000f7d7a8f6ebd60a43.1431537416.git.mchehab@osg.samsung.com>
In-Reply-To: <45f38cb3b80311ade3c87000f7d7a8f6ebd60a43.1431537416.git.mchehab@osg.samsung.com>
References: <45f38cb3b80311ade3c87000f7d7a8f6ebd60a43.1431537416.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several lines touched by the pr_foo refactoring patches are not
following the Linux Coding style.

While we won't be fixing the style globally at the driver, we should,
at least, fix on the lines we touched.

Basically, this patch add (or remove) whitespaces and blank lines
where needed.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index 4199fbf9bc44..1d2c310ce838 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -161,7 +161,8 @@ static void saa7134_irq_alsa_done(struct saa7134_dev *dev,
 	}
 
 	if (dev->dmasound.read_count >= dev->dmasound.blksize * (dev->dmasound.blocks-2)) {
-		pr_debug("irq: overrun [full=%d/%d] - Blocks in %d\n",dev->dmasound.read_count,
+		pr_debug("irq: overrun [full=%d/%d] - Blocks in %d\n",
+			dev->dmasound.read_count,
 			dev->dmasound.bufsize, dev->dmasound.blocks);
 		spin_unlock(&dev->slock);
 		snd_pcm_stop_xrun(dev->dmasound.substream);
@@ -173,7 +174,8 @@ static void saa7134_irq_alsa_done(struct saa7134_dev *dev,
 	saa_writel(reg,next_blk * dev->dmasound.blksize);
 	pr_debug("irq: ok, %s, next_blk=%d, addr=%x, blocks=%u, size=%u, read=%u\n",
 		(status & 0x10000000) ? "even" : "odd ", next_blk,
-		next_blk * dev->dmasound.blksize, dev->dmasound.blocks, dev->dmasound.blksize, dev->dmasound.read_count);
+		 next_blk * dev->dmasound.blksize, dev->dmasound.blocks,
+		 dev->dmasound.blksize, dev->dmasound.read_count);
 
 	/* update status & wake waiting readers */
 	dev->dmasound.dma_blk = (dev->dmasound.dma_blk + 1) % dev->dmasound.blocks;
@@ -1186,7 +1188,8 @@ static int alsa_card_saa7134_create(struct saa7134_dev *dev, int devnum)
 	sprintf(card->longname, "%s at 0x%lx irq %d",
 		chip->dev->name, chip->iobase, chip->irq);
 
-	pr_info("%s/alsa: %s registered as card %d\n",dev->name,card->longname,index[devnum]);
+	pr_info("%s/alsa: %s registered as card %d\n",
+		dev->name, card->longname, index[devnum]);
 
 	if ((err = snd_card_register(card)) == 0) {
 		snd_saa7134_cards[devnum] = card;
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index abbeeb923114..9fac6a9b7937 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -7516,7 +7516,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 		pr_warn("%s: seems there are two different versions of the MD5044\n"
 			"%s: (with the same ID) out there.  If sound doesn't work for\n"
 			"%s: you try the audio_clock_override=0x200000 insmod option.\n",
-			dev->name,dev->name,dev->name);
+			dev->name, dev->name, dev->name);
 		break;
 	case SAA7134_BOARD_CINERGY400_CARDBUS:
 		/* power-up tuner chip */
@@ -7644,7 +7644,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 		pr_warn("%s: %s: dual saa713x broadcast decoders\n"
 			"%s: Sorry, none of the inputs to this chip are supported yet.\n"
 			"%s: Dual decoder functionality is disabled for now, use the other chip.\n",
-			dev->name,card(dev).name,dev->name,dev->name);
+			dev->name, card(dev).name, dev->name, dev->name);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_M102:
 		/* enable tuner */
@@ -7826,7 +7826,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 				dev->tuner_type = TUNER_PHILIPS_FM1216ME_MK3;
 				break;
 			default:
-				pr_err("%s Can't determine tuner type %x from EEPROM\n", dev->name, tuner_t);
+				pr_err("%s Can't determine tuner type %x from EEPROM\n",
+				       dev->name, tuner_t);
 			}
 		} else if ((data[1] != 0) && (data[1] != 0xff)) {
 			/* new config structure */
@@ -7847,7 +7848,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 				       dev->name);
 				break;
 			default:
-				pr_err("%s Can't determine tuner type %x from EEPROM\n", dev->name, tuner_t);
+				pr_err("%s Can't determine tuner type %x from EEPROM\n",
+				       dev->name, tuner_t);
 			}
 		} else {
 			pr_err("%s unexpected config structure\n", dev->name);
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 02a08770507d..72d7f992375e 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -134,7 +134,8 @@ void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
 	index = 1 << bit_no;
 	switch (value) {
 	case 0: /* static value */
-	case 1:	core_dbg("setting GPIO%d to static %d\n", bit_no, value);
+	case 1:
+		core_dbg("setting GPIO%d to static %d\n", bit_no, value);
 		/* turn sync mode off if necessary */
 		if (index & 0x00c00000)
 			saa_andorb(SAA7134_VIDEO_PORT_CTRL6, 0x0f, 0x00);
@@ -503,11 +504,11 @@ static void print_irqstatus(struct saa7134_dev *dev, int loop,
 	unsigned int i;
 
 	irq_dbg(1, "[%d,%ld]: r=0x%lx s=0x%02lx",
-	       loop, jiffies, report,status);
+		loop, jiffies, report, status);
 	for (i = 0; i < IRQBITS; i++) {
 		if (!(report & (1 << i)))
 			continue;
-		pr_cont(" %s",irqbits[i]);
+		pr_cont(" %s", irqbits[i]);
 	}
 	if (report & SAA7134_IRQ_REPORT_DONE_RA0) {
 		pr_cont(" | RA0=%s,%s,%s,%ld",
@@ -543,7 +544,7 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 		}
 
 		if (0 == report) {
-			irq_dbg(2,"no (more) work\n");
+			irq_dbg(2, "no (more) work\n");
 			goto out;
 		}
 
@@ -909,7 +910,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		if (pci_pci_problems & PCIPCI_VIAETBF)
 			pr_info("%s: quirk: PCIPCI_VIAETBF\n", dev->name);
 		if (pci_pci_problems & PCIPCI_VSFX)
-			pr_info("%s: quirk: PCIPCI_VSFX\n",dev->name);
+			pr_info("%s: quirk: PCIPCI_VSFX\n", dev->name);
 #ifdef PCIPCI_ALIMAGIK
 		if (pci_pci_problems & PCIPCI_ALIMAGIK) {
 			pr_info("%s: quirk: PCIPCI_ALIMAGIK -- latency fixup\n",
@@ -1209,7 +1210,7 @@ static int saa7134_buffer_requeue(struct saa7134_dev *dev,
 	if (!buf)
 		return 0;
 
-	core_dbg("buffer_requeue : resending active buffers \n");
+	core_dbg("buffer_requeue : resending active buffer\n");
 
 	if (!list_empty(&q->queue))
 		next = list_entry(q->queue.next, struct saa7134_buf,
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 7edb49729489..d47fb22e12f2 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -558,11 +558,14 @@ static int philips_tda827x_tuner_init(struct dvb_frontend *fe)
 	struct tda1004x_state *state = fe->demodulator_priv;
 
 	switch (state->config->antenna_switch) {
-	case 0: break;
-	case 1:	pr_debug("setting GPIO21 to 0 (TV antenna?)\n");
+	case 0:
+		break;
+	case 1:
+		pr_debug("setting GPIO21 to 0 (TV antenna?)\n");
 		saa7134_set_gpio(dev, 21, 0);
 		break;
-	case 2: pr_debug("setting GPIO21 to 1 (Radio antenna?)\n");
+	case 2:
+		pr_debug("setting GPIO21 to 1 (Radio antenna?)\n");
 		saa7134_set_gpio(dev, 21, 1);
 		break;
 	}
@@ -575,11 +578,14 @@ static int philips_tda827x_tuner_sleep(struct dvb_frontend *fe)
 	struct tda1004x_state *state = fe->demodulator_priv;
 
 	switch (state->config->antenna_switch) {
-	case 0: break;
-	case 1: pr_debug("setting GPIO21 to 1 (Radio antenna?)\n");
+	case 0:
+		break;
+	case 1:
+		pr_debug("setting GPIO21 to 1 (Radio antenna?)\n");
 		saa7134_set_gpio(dev, 21, 1);
 		break;
-	case 2:	pr_debug("setting GPIO21 to 0 (TV antenna?)\n");
+	case 2:
+		pr_debug("setting GPIO21 to 0 (TV antenna?)\n");
 		saa7134_set_gpio(dev, 21, 0);
 		break;
 	}
@@ -1029,7 +1035,8 @@ static int md8800_set_voltage2(struct dvb_frontend *fe, fe_sec_voltage_t voltage
 
 static int md8800_set_high_voltage2(struct dvb_frontend *fe, long arg)
 {
-	pr_warn("%s: sorry can't set high LNB supply voltage from here\n", __func__);
+	pr_warn("%s: sorry can't set high LNB supply voltage from here\n",
+		__func__);
 	return -EIO;
 }
 
@@ -1388,13 +1395,15 @@ static int dvb_init(struct saa7134_dev *dev)
 			if (fe0->dvb.frontend) {
 				if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x63,
 									&dev->i2c_adap, 0) == NULL) {
-					pr_warn("%s: Lifeview Trio, No tda826x found!\n", __func__);
+					pr_warn("%s: Lifeview Trio, No tda826x found!\n",
+						__func__);
 					goto detach_frontend;
 				}
 				if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
 					       &dev->i2c_adap,
 					       0x08, 0, 0, false) == NULL) {
-					pr_warn("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
+					pr_warn("%s: Lifeview Trio, No ISL6421 found!\n",
+						__func__);
 					goto detach_frontend;
 				}
 			}
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 86ab17bbc444..56b932c97196 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -256,7 +256,7 @@ static int empress_init(struct saa7134_dev *dev)
 	struct vb2_queue *q;
 	int err;
 
-	pr_debug("%s: %s\n",dev->name,__func__);
+	pr_debug("%s: %s\n", dev->name, __func__);
 	dev->empress_dev = video_device_alloc();
 	if (NULL == dev->empress_dev)
 		return -ENOMEM;
@@ -318,7 +318,7 @@ static int empress_init(struct saa7134_dev *dev)
 
 static int empress_fini(struct saa7134_dev *dev)
 {
-	pr_debug("%s: %s\n",dev->name,__func__);
+	pr_debug("%s: %s\n", dev->name, __func__);
 
 	if (NULL == dev->empress_dev)
 		return 0;
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index b90434b41efe..8ef6399d794f 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -267,7 +267,7 @@ static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
 				 * needed to talk to the mt352 demux
 				 * thanks to pinnacle for the hint */
 				int quirk = 0xfe;
-				i2c_cont(1, " [%02x quirk]",quirk);
+				i2c_cont(1, " [%02x quirk]", quirk);
 				i2c_send_byte(dev,START,quirk);
 				i2c_recv_byte(dev);
 			}
@@ -374,8 +374,9 @@ saa7134_i2c_eeprom(struct saa7134_dev *dev, unsigned char *eedata, int len)
 		return -1;
 	}
 
-	for (i = 0; i < len; i+= 16) {
+	for (i = 0; i < len; i += 16) {
 		int size = (len - i) > 16 ? 16 : len - i;
+
 		pr_info("i2c eeprom %02x: %*ph\n", i, size, &eedata[i]);
 	}
 
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 07ca32f1b6d9..4b202fa5fbc4 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -46,7 +46,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *next)
 {
 
-	ts_dbg("buffer_activate [%p]",buf);
+	ts_dbg("buffer_activate [%p]", buf);
 	buf->top_seen = 0;
 
 	if (!dev->ts_started)
@@ -55,12 +55,12 @@ static int buffer_activate(struct saa7134_dev *dev,
 	if (NULL == next)
 		next = buf;
 	if (V4L2_FIELD_TOP == dev->ts_field) {
-		ts_dbg("- [top]     buf=%p next=%p\n",buf,next);
+		ts_dbg("- [top]     buf=%p next=%p\n", buf, next);
 		saa_writel(SAA7134_RS_BA1(5),saa7134_buffer_base(buf));
 		saa_writel(SAA7134_RS_BA2(5),saa7134_buffer_base(next));
 		dev->ts_field = V4L2_FIELD_BOTTOM;
 	} else {
-		ts_dbg("- [bottom]  buf=%p next=%p\n",buf,next);
+		ts_dbg("- [bottom]  buf=%p next=%p\n", buf, next);
 		saa_writel(SAA7134_RS_BA1(5),saa7134_buffer_base(next));
 		saa_writel(SAA7134_RS_BA2(5),saa7134_buffer_base(buf));
 		dev->ts_field = V4L2_FIELD_TOP;
diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index 1a960a1b07b5..21a579309575 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -347,9 +347,9 @@ static int tvaudio_checkcarrier(struct saa7134_dev *dev, struct mainscan *scan)
 				return -1;
 			value = saa_readl(SAA7134_LEVEL_READOUT1 >> 2);
 			if (0 == i)
-				pr_cont("  #  %6d  # ",value >> 16);
+				pr_cont("  #  %6d  # ", value >> 16);
 			else
-				pr_cont(" %6d",value >> 16);
+				pr_cont(" %6d", value >> 16);
 		}
 		pr_cont("\n");
 	}
@@ -404,7 +404,8 @@ static int tvaudio_getstereo(struct saa7134_dev *dev, struct saa7134_tvaudio *au
 		audio_dbg(1, "getstereo: nicam=0x%x\n", nicam);
 		if (nicam & 0x1) {
 			nicam_status = saa_readb(SAA7134_NICAM_STATUS);
-			audio_dbg(1, "getstereo: nicam_status=0x%x\n", nicam_status);
+			audio_dbg(1, "getstereo: nicam_status=0x%x\n",
+				  nicam_status);
 
 			switch (nicam_status & 0x03) {
 			    case 0x01:
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index f874b0c9fe4a..035039cfae6d 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -387,7 +387,7 @@ static struct saa7134_format* format_by_fourcc(unsigned int fourcc)
 
 static void set_tvnorm(struct saa7134_dev *dev, struct saa7134_tvnorm *norm)
 {
-	video_dbg("set tv norm = %s\n",norm->name);
+	video_dbg("set tv norm = %s\n", norm->name);
 	dev->tvnorm = norm;
 
 	/* setup cropping */
@@ -533,14 +533,14 @@ static void set_v_scale(struct saa7134_dev *dev, int task, int yscale)
 	mirror = (dev->ctl_mirror) ? 0x02 : 0x00;
 	if (yscale < 2048) {
 		/* LPI */
-		video_dbg("yscale LPI yscale=%d\n",yscale);
+		video_dbg("yscale LPI yscale=%d\n", yscale);
 		saa_writeb(SAA7134_V_FILTER(task), 0x00 | mirror);
 		saa_writeb(SAA7134_LUMA_CONTRAST(task), 0x40);
 		saa_writeb(SAA7134_CHROMA_SATURATION(task), 0x40);
 	} else {
 		/* ACM */
 		val = 0x40 * 1024 / yscale;
-		video_dbg("yscale ACM yscale=%d val=0x%x\n",yscale,val);
+		video_dbg("yscale ACM yscale=%d val=0x%x\n", yscale, val);
 		saa_writeb(SAA7134_V_FILTER(task), 0x01 | mirror);
 		saa_writeb(SAA7134_LUMA_CONTRAST(task), val);
 		saa_writeb(SAA7134_CHROMA_SATURATION(task), val);
@@ -575,7 +575,8 @@ static void set_size(struct saa7134_dev *dev, int task,
 		prescale = 1;
 	xscale = 1024 * dev->crop_current.width / prescale / width;
 	yscale = 512 * div * dev->crop_current.height / height;
-	video_dbg("prescale=%d xscale=%d yscale=%d\n",prescale,xscale,yscale);
+	video_dbg("prescale=%d xscale=%d yscale=%d\n",
+		  prescale, xscale, yscale);
 	set_h_prescale(dev,task,prescale);
 	saa_writeb(SAA7134_H_SCALE_INC1(task),      xscale &  0xff);
 	saa_writeb(SAA7134_H_SCALE_INC2(task),      xscale >> 8);
@@ -794,7 +795,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 	unsigned long base,control,bpl;
 	unsigned long bpl_uv,lines_uv,base2,base3,tmp; /* planar */
 
-	video_dbg("buffer_activate buf=%p\n",buf);
+	video_dbg("buffer_activate buf=%p\n", buf);
 	buf->top_seen = 0;
 
 	set_size(dev, TASK_A, dev->width, dev->height,
-- 
2.1.0

