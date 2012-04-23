Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3782 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2DWLvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:51:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 7/8] v4l/dvb: fix compiler warnings.
Date: Mon, 23 Apr 2012 13:51:27 +0200
Message-Id: <e85cfac64c46d88cda3925d7f03bbd3bc9cf670b.1335181658.git.hans.verkuil@cisco.com>
In-Reply-To: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
References: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
References: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

media_build/v4l/drxk_hard.c: In function 'DownloadMicrocode':
media_build/v4l/drxk_hard.c:1388:6: warning: variable 'BlockCRC' set but not used [-Wunused-but-set-variable]
media_build/v4l/drxk_hard.c:1384:6: warning: variable 'Drain' set but not used [-Wunused-but-set-variable]
media_build/v4l/drxk_hard.c:1383:6: warning: variable 'Flags' set but not used [-Wunused-but-set-variable]
media_build/v4l/lmedm04.c: In function 'lme2510_probe':
media_build/v4l/lmedm04.c:1208:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/hopper_cards.c: In function 'hopper_irq_handler':
media_build/v4l/hopper_cards.c:68:26: warning: variable 'lstat' set but not used [-Wunused-but-set-variable]
media_build/v4l/mantis_cards.c: In function 'mantis_irq_handler':
media_build/v4l/mantis_cards.c:76:26: warning: variable 'lstat' set but not used [-Wunused-but-set-variable]
media_build/v4l/mantis_dma.c: In function 'mantis_dma_stop':
media_build/v4l/mantis_dma.c:202:16: warning: variable 'mask' set but not used [-Wunused-but-set-variable]
media_build/v4l/mantis_dma.c:202:6: warning: variable 'stat' set but not used [-Wunused-but-set-variable]
media_build/v4l/mantis_evm.c: In function 'mantis_hifevm_work':
media_build/v4l/mantis_evm.c:44:17: warning: variable 'gpif_mask' set but not used [-Wunused-but-set-variable]
media_build/v4l/stb0899_drv.c: In function 'stb0899_init_calc':
media_build/v4l/stb0899_drv.c:640:5: warning: variable 'agc1cn' set but not used [-Wunused-but-set-variable]
media_build/v4l/stb0899_drv.c: In function 'stb0899_diseqc_init':
media_build/v4l/stb0899_drv.c:830:13: warning: variable 'f22_rx' set but not used [-Wunused-but-set-variable]
media_build/v4l/stb0899_drv.c:826:31: warning: variable 'tx_data' set but not used [-Wunused-but-set-variable]
media_build/v4l/stv0900_sw.c: In function 'stv0900_track_optimization':
media_build/v4l/stv0900_sw.c:838:26: warning: variable 'rolloff' set but not used [-Wunused-but-set-variable]
media_build/v4l/ir-sanyo-decoder.c: In function 'ir_sanyo_decode':
media_build/v4l/ir-sanyo-decoder.c:59:14: warning: variable 'not_address' set but not used [-Wunused-but-set-variable]
media_build/v4l/mceusb.c: In function 'mceusb_dev_printdata':
media_build/v4l/mceusb.c:523:46: warning: variable 'data5' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c       |    3 +--
 drivers/media/dvb/frontends/drxk_hard.c   |    9 +++------
 drivers/media/dvb/frontends/stb0899_drv.c |    8 +-------
 drivers/media/dvb/frontends/stv0900_sw.c  |    2 --
 drivers/media/dvb/mantis/hopper_cards.c   |    3 +--
 drivers/media/dvb/mantis/mantis_cards.c   |    3 +--
 drivers/media/dvb/mantis/mantis_dma.c     |    4 ----
 drivers/media/dvb/mantis/mantis_evm.c     |    3 +--
 drivers/media/rc/ir-sanyo-decoder.c       |    4 ++--
 drivers/media/rc/mceusb.c                 |    4 ++--
 drivers/media/video/videobuf-dvb.c        |    3 +--
 11 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 5dde06d..003fb9b 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -1205,14 +1205,13 @@ static int lme2510_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-	int ret = 0;
 
 	usb_reset_configuration(udev);
 
 	usb_set_interface(udev, intf->cur_altsetting->desc.bInterfaceNumber, 1);
 
 	if (udev->speed != USB_SPEED_HIGH) {
-		ret = usb_reset_device(udev);
+		usb_reset_device(udev);
 		info("DEV Failed to connect in HIGH SPEED mode");
 		return -ENODEV;
 	}
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 36d1175..2270068 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1380,12 +1380,9 @@ static int DownloadMicrocode(struct drxk_state *state,
 			     const u8 pMCImage[], u32 Length)
 {
 	const u8 *pSrc = pMCImage;
-	u16 Flags;
-	u16 Drain;
 	u32 Address;
 	u16 nBlocks;
 	u16 BlockSize;
-	u16 BlockCRC;
 	u32 offset = 0;
 	u32 i;
 	int status = 0;
@@ -1393,7 +1390,7 @@ static int DownloadMicrocode(struct drxk_state *state,
 	dprintk(1, "\n");
 
 	/* down the drain (we don care about MAGIC_WORD) */
-	Drain = (pSrc[0] << 8) | pSrc[1];
+	/* Drain = (pSrc[0] << 8) | pSrc[1]; */
 	pSrc += sizeof(u16);
 	offset += sizeof(u16);
 	nBlocks = (pSrc[0] << 8) | pSrc[1];
@@ -1410,11 +1407,11 @@ static int DownloadMicrocode(struct drxk_state *state,
 		pSrc += sizeof(u16);
 		offset += sizeof(u16);
 
-		Flags = (pSrc[0] << 8) | pSrc[1];
+		/* Flags = (pSrc[0] << 8) | pSrc[1]; */
 		pSrc += sizeof(u16);
 		offset += sizeof(u16);
 
-		BlockCRC = (pSrc[0] << 8) | pSrc[1];
+		/* BlockCRC = (pSrc[0] << 8) | pSrc[1]; */
 		pSrc += sizeof(u16);
 		offset += sizeof(u16);
 
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
index dd08f4a..8b0dc74 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -637,11 +637,9 @@ static void stb0899_init_calc(struct stb0899_state *state)
 	struct stb0899_internal *internal = &state->internal;
 	int master_clk;
 	u8 agc[2];
-	u8 agc1cn;
 	u32 reg;
 
 	/* Read registers (in burst mode)	*/
-	agc1cn = stb0899_read_reg(state, STB0899_AGC1CN);
 	stb0899_read_regs(state, STB0899_AGC1REF, agc, 2); /* AGC1R and AGC2O	*/
 
 	/* Initial calculations	*/
@@ -823,15 +821,12 @@ static int stb0899_send_diseqc_burst(struct dvb_frontend *fe, fe_sec_mini_cmd_t
 
 static int stb0899_diseqc_init(struct stb0899_state *state)
 {
-	struct dvb_diseqc_master_cmd tx_data;
 /*
 	struct dvb_diseqc_slave_reply rx_data;
 */
-	u8 f22_tx, f22_rx, reg;
+	u8 f22_tx, reg;
 
 	u32 mclk, tx_freq = 22000;/* count = 0, i; */
-	tx_data.msg[0] = 0xe2;
-	tx_data.msg_len = 3;
 	reg = stb0899_read_reg(state, STB0899_DISCNTRL2);
 	STB0899_SETFIELD_VAL(ONECHIP_TRX, reg, 0);
 	stb0899_write_reg(state, STB0899_DISCNTRL2, reg);
@@ -849,7 +844,6 @@ static int stb0899_diseqc_init(struct stb0899_state *state)
 	f22_tx = mclk / (tx_freq * 32);
 	stb0899_write_reg(state, STB0899_DISF22, f22_tx); /* DiSEqC Tx freq	*/
 	state->rx_freq = 20000;
-	f22_rx = mclk / (state->rx_freq * 32);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/frontends/stv0900_sw.c b/drivers/media/dvb/frontends/stv0900_sw.c
index ba0709b..4af2078 100644
--- a/drivers/media/dvb/frontends/stv0900_sw.c
+++ b/drivers/media/dvb/frontends/stv0900_sw.c
@@ -835,7 +835,6 @@ static void stv0900_track_optimization(struct dvb_frontend *fe)
 		blind_tun_sw = 0,
 		modulation;
 
-	enum fe_stv0900_rolloff rolloff;
 	enum fe_stv0900_modcode foundModcod;
 
 	dprintk("%s\n", __func__);
@@ -940,7 +939,6 @@ static void stv0900_track_optimization(struct dvb_frontend *fe)
 
 	freq1 = stv0900_read_reg(intp, CFR2);
 	freq0 = stv0900_read_reg(intp, CFR1);
-	rolloff = stv0900_get_bits(intp, ROLLOFF_STATUS);
 	if (intp->srch_algo[demod] == STV0900_BLIND_SEARCH) {
 		stv0900_write_reg(intp, SFRSTEP, 0x00);
 		stv0900_write_bits(intp, SCAN_ENABLE, 0);
diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/dvb/mantis/hopper_cards.c
index 71622f6..cc0251e 100644
--- a/drivers/media/dvb/mantis/hopper_cards.c
+++ b/drivers/media/dvb/mantis/hopper_cards.c
@@ -65,7 +65,7 @@ static int devs;
 
 static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
 {
-	u32 stat = 0, mask = 0, lstat = 0;
+	u32 stat = 0, mask = 0;
 	u32 rst_stat = 0, rst_mask = 0;
 
 	struct mantis_pci *mantis;
@@ -80,7 +80,6 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
 
 	stat = mmread(MANTIS_INT_STAT);
 	mask = mmread(MANTIS_INT_MASK);
-	lstat = stat & ~MANTIS_INT_RISCSTAT;
 	if (!(stat & mask))
 		return IRQ_NONE;
 
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index c2bb90b..095cf3a 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -73,7 +73,7 @@ static char *label[10] = {
 
 static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 {
-	u32 stat = 0, mask = 0, lstat = 0;
+	u32 stat = 0, mask = 0;
 	u32 rst_stat = 0, rst_mask = 0;
 
 	struct mantis_pci *mantis;
@@ -88,7 +88,6 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 
 	stat = mmread(MANTIS_INT_STAT);
 	mask = mmread(MANTIS_INT_MASK);
-	lstat = stat & ~MANTIS_INT_RISCSTAT;
 	if (!(stat & mask))
 		return IRQ_NONE;
 
diff --git a/drivers/media/dvb/mantis/mantis_dma.c b/drivers/media/dvb/mantis/mantis_dma.c
index c61ca7d..566c407 100644
--- a/drivers/media/dvb/mantis/mantis_dma.c
+++ b/drivers/media/dvb/mantis/mantis_dma.c
@@ -199,10 +199,6 @@ void mantis_dma_start(struct mantis_pci *mantis)
 
 void mantis_dma_stop(struct mantis_pci *mantis)
 {
-	u32 stat = 0, mask = 0;
-
-	stat = mmread(MANTIS_INT_STAT);
-	mask = mmread(MANTIS_INT_MASK);
 	dprintk(MANTIS_DEBUG, 1, "Mantis Stop DMA engine");
 
 	mmwrite((mmread(MANTIS_GPIF_ADDR) & (~(MANTIS_GPIF_HIFRDWRN))), MANTIS_GPIF_ADDR);
diff --git a/drivers/media/dvb/mantis/mantis_evm.c b/drivers/media/dvb/mantis/mantis_evm.c
index 36f2256..71ce528 100644
--- a/drivers/media/dvb/mantis/mantis_evm.c
+++ b/drivers/media/dvb/mantis/mantis_evm.c
@@ -41,10 +41,9 @@ static void mantis_hifevm_work(struct work_struct *work)
 	struct mantis_ca *ca = container_of(work, struct mantis_ca, hif_evm_work);
 	struct mantis_pci *mantis = ca->ca_priv;
 
-	u32 gpif_stat, gpif_mask;
+	u32 gpif_stat;
 
 	gpif_stat = mmread(MANTIS_GPIF_STATUS);
-	gpif_mask = mmread(MANTIS_GPIF_IRQCFG);
 
 	if (gpif_stat & MANTIS_GPIF_DETSTAT) {
 		if (gpif_stat & MANTIS_CARD_PLUGIN) {
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index d38fbdd..7e54ec5 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -56,7 +56,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct sanyo_dec *data = &dev->raw->sanyo;
 	u32 scancode;
-	u8 address, not_address, command, not_command;
+	u8 address, command, not_command;
 
 	if (!(dev->raw->enabled_protocols & RC_TYPE_SANYO))
 		return 0;
@@ -154,7 +154,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			break;
 
 		address     = bitrev16((data->bits >> 29) & 0x1fff) >> 3;
-		not_address = bitrev16((data->bits >> 16) & 0x1fff) >> 3;
+		/* not_address = bitrev16((data->bits >> 16) & 0x1fff) >> 3; */
 		command	    = bitrev8((data->bits >>  8) & 0xff);
 		not_command = bitrev8((data->bits >>  0) & 0xff);
 
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index e150a2e..cb187bf 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -520,7 +520,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 {
 	char codes[USB_BUFLEN * 3 + 1];
 	char inout[9];
-	u8 cmd, subcmd, data1, data2, data3, data4, data5;
+	u8 cmd, subcmd, data1, data2, data3, data4;
 	struct device *dev = ir->dev;
 	int i, start, skip = 0;
 	u32 carrier, period;
@@ -553,7 +553,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	data2  = buf[start + 3] & 0xff;
 	data3  = buf[start + 4] & 0xff;
 	data4  = buf[start + 5] & 0xff;
-	data5  = buf[start + 6] & 0xff;
+	/* data5  = buf[start + 6] & 0xff; */
 
 	switch (cmd) {
 	case MCE_CMD_NULL:
diff --git a/drivers/media/video/videobuf-dvb.c b/drivers/media/video/videobuf-dvb.c
index 59cb54a..94d83a4 100644
--- a/drivers/media/video/videobuf-dvb.c
+++ b/drivers/media/video/videobuf-dvb.c
@@ -45,7 +45,6 @@ static int videobuf_dvb_thread(void *data)
 	struct videobuf_dvb *dvb = data;
 	struct videobuf_buffer *buf;
 	unsigned long flags;
-	int err;
 	void *outp;
 
 	dprintk("dvb thread started\n");
@@ -57,7 +56,7 @@ static int videobuf_dvb_thread(void *data)
 		buf = list_entry(dvb->dvbq.stream.next,
 				 struct videobuf_buffer, stream);
 		list_del(&buf->stream);
-		err = videobuf_waiton(&dvb->dvbq, buf, 0, 1);
+		videobuf_waiton(&dvb->dvbq, buf, 0, 1);
 
 		/* no more feeds left or stop_feed() asked us to quit */
 		if (0 == dvb->nfeeds)
-- 
1.7.10

