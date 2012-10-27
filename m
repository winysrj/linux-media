Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2J0Ulx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:41:53 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKfr3Q019756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:41:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 17/68] [media] saa7164: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:35 -0200
Message-Id: <1351370486-29040-18-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/saa7164/saa7164-api.c:1489:5: warning: no previous prototype for 'saa7164_api_modify_gpio' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-api.c:168:5: warning: no previous prototype for 'saa7164_api_set_gop_size' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-api.c:622:5: warning: no previous prototype for 'saa7164_api_set_dif' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-api.c:825:5: warning: no previous prototype for 'saa7164_api_configure_port_vbi' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-api.c:861:5: warning: no previous prototype for 'saa7164_api_configure_port_mpeg2ts' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-api.c:895:5: warning: no previous prototype for 'saa7164_api_configure_port_mpeg2ps' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-api.c:928:5: warning: no previous prototype for 'saa7164_api_dump_subdevs' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-bus.c:109:6: warning: no previous prototype for 'saa7164_bus_dumpmsg' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-bus.c:84:6: warning: no previous prototype for 'saa7164_bus_verify' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-cmd.c:135:5: warning: no previous prototype for 'saa7164_cmd_dequeue' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-cmd.c:189:5: warning: no previous prototype for 'saa7164_cmd_set' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-cmd.c:262:5: warning: no previous prototype for 'saa7164_cmd_wait' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-cmd.c:26:5: warning: no previous prototype for 'saa7164_cmd_alloc_seqno' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-cmd.c:45:6: warning: no previous prototype for 'saa7164_cmd_free_seqno' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-cmd.c:57:6: warning: no previous prototype for 'saa7164_cmd_timeout_seqno' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-cmd.c:67:5: warning: no previous prototype for 'saa7164_cmd_timeout_get' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-encoder.c:1104:29: warning: no previous prototype for 'saa7164_enc_next_buf' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-encoder.c:1290:5: warning: no previous prototype for 'saa7164_g_chip_ident' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-encoder.c:1300:5: warning: no previous prototype for 'saa7164_g_register' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-encoder.c:1313:5: warning: no previous prototype for 'saa7164_s_register' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-fw.c:40:5: warning: no previous prototype for 'saa7164_dl_wait_ack' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-fw.c:56:5: warning: no previous prototype for 'saa7164_dl_wait_clr' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-fw.c:74:5: warning: no previous prototype for 'saa7164_downloadimage' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-vbi.c:1050:29: warning: no previous prototype for 'saa7164_vbi_next_buf' [-Wmissing-prototypes]
drivers/media/pci/saa7164/saa7164-vbi.c:987:5: warning: no previous prototype for 'saa7164_vbi_fmt' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/saa7164/saa7164-api.c     | 26 ++++++++++++++------------
 drivers/media/pci/saa7164/saa7164-bus.c     |  6 +++---
 drivers/media/pci/saa7164/saa7164-cmd.c     | 16 ++++++++--------
 drivers/media/pci/saa7164/saa7164-encoder.c | 15 ++++++++-------
 drivers/media/pci/saa7164/saa7164-fw.c      |  8 ++++----
 drivers/media/pci/saa7164/saa7164-vbi.c     |  6 ++++--
 6 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-api.c b/drivers/media/pci/saa7164/saa7164-api.c
index eff7135..e042963 100644
--- a/drivers/media/pci/saa7164/saa7164-api.c
+++ b/drivers/media/pci/saa7164/saa7164-api.c
@@ -165,7 +165,7 @@ int saa7164_api_set_vbi_format(struct saa7164_port *port)
 	return ret;
 }
 
-int saa7164_api_set_gop_size(struct saa7164_port *port)
+static int saa7164_api_set_gop_size(struct saa7164_port *port)
 {
 	struct saa7164_dev *dev = port->dev;
 	struct tmComResEncVideoGopStructure gs;
@@ -619,7 +619,7 @@ int saa7164_api_get_videomux(struct saa7164_port *port)
 	return ret;
 }
 
-int saa7164_api_set_dif(struct saa7164_port *port, u8 reg, u8 val)
+static int saa7164_api_set_dif(struct saa7164_port *port, u8 reg, u8 val)
 {
 	struct saa7164_dev *dev = port->dev;
 
@@ -822,8 +822,8 @@ int saa7164_api_read_eeprom(struct saa7164_dev *dev, u8 *buf, int buflen)
 		&reg[0], 128, buf);
 }
 
-int saa7164_api_configure_port_vbi(struct saa7164_dev *dev,
-	struct saa7164_port *port)
+static int saa7164_api_configure_port_vbi(struct saa7164_dev *dev,
+					  struct saa7164_port *port)
 {
 	struct tmComResVBIFormatDescrHeader *fmt = &port->vbi_fmt_ntsc;
 
@@ -858,9 +858,10 @@ int saa7164_api_configure_port_vbi(struct saa7164_dev *dev,
 	return 0;
 }
 
-int saa7164_api_configure_port_mpeg2ts(struct saa7164_dev *dev,
-	struct saa7164_port *port,
-	struct tmComResTSFormatDescrHeader *tsfmt)
+static int
+saa7164_api_configure_port_mpeg2ts(struct saa7164_dev *dev,
+				   struct saa7164_port *port,
+				   struct tmComResTSFormatDescrHeader *tsfmt)
 {
 	dprintk(DBGLVL_API, "    bFormatIndex = 0x%x\n", tsfmt->bFormatIndex);
 	dprintk(DBGLVL_API, "    bDataOffset  = 0x%x\n", tsfmt->bDataOffset);
@@ -892,9 +893,10 @@ int saa7164_api_configure_port_mpeg2ts(struct saa7164_dev *dev,
 	return 0;
 }
 
-int saa7164_api_configure_port_mpeg2ps(struct saa7164_dev *dev,
-	struct saa7164_port *port,
-	struct tmComResPSFormatDescrHeader *fmt)
+static int
+saa7164_api_configure_port_mpeg2ps(struct saa7164_dev *dev,
+				   struct saa7164_port *port,
+				   struct tmComResPSFormatDescrHeader *fmt)
 {
 	dprintk(DBGLVL_API, "    bFormatIndex = 0x%x\n", fmt->bFormatIndex);
 	dprintk(DBGLVL_API, "    wPacketLength= 0x%x\n", fmt->wPacketLength);
@@ -925,7 +927,7 @@ int saa7164_api_configure_port_mpeg2ps(struct saa7164_dev *dev,
 	return 0;
 }
 
-int saa7164_api_dump_subdevs(struct saa7164_dev *dev, u8 *buf, int len)
+static int saa7164_api_dump_subdevs(struct saa7164_dev *dev, u8 *buf, int len)
 {
 	struct saa7164_port *tsport = NULL;
 	struct saa7164_port *encport = NULL;
@@ -1486,7 +1488,7 @@ int saa7164_api_i2c_write(struct saa7164_i2c *bus, u8 addr, u32 datalen,
 	return ret == SAA_OK ? 0 : -EIO;
 }
 
-int saa7164_api_modify_gpio(struct saa7164_dev *dev, u8 unitid,
+static int saa7164_api_modify_gpio(struct saa7164_dev *dev, u8 unitid,
 	u8 pin, u8 state)
 {
 	int ret;
diff --git a/drivers/media/pci/saa7164/saa7164-bus.c b/drivers/media/pci/saa7164/saa7164-bus.c
index a7f58a9..5f6f309 100644
--- a/drivers/media/pci/saa7164/saa7164-bus.c
+++ b/drivers/media/pci/saa7164/saa7164-bus.c
@@ -81,7 +81,7 @@ void saa7164_bus_dump(struct saa7164_dev *dev)
 }
 
 /* Intensionally throw a BUG() if the state of the message bus looks corrupt */
-void saa7164_bus_verify(struct saa7164_dev *dev)
+static void saa7164_bus_verify(struct saa7164_dev *dev)
 {
 	struct tmComResBusInfo *b = &dev->bus;
 	int bug = 0;
@@ -106,8 +106,8 @@ void saa7164_bus_verify(struct saa7164_dev *dev)
 	}
 }
 
-void saa7164_bus_dumpmsg(struct saa7164_dev *dev, struct tmComResInfo* m,
-	void *buf)
+static void saa7164_bus_dumpmsg(struct saa7164_dev *dev, struct tmComResInfo *m,
+				void *buf)
 {
 	dprintk(DBGLVL_BUS, "Dumping msg structure:\n");
 	dprintk(DBGLVL_BUS, " .id               = %d\n",   m->id);
diff --git a/drivers/media/pci/saa7164/saa7164-cmd.c b/drivers/media/pci/saa7164/saa7164-cmd.c
index 62fac7f..cfabcba 100644
--- a/drivers/media/pci/saa7164/saa7164-cmd.c
+++ b/drivers/media/pci/saa7164/saa7164-cmd.c
@@ -23,7 +23,7 @@
 
 #include "saa7164.h"
 
-int saa7164_cmd_alloc_seqno(struct saa7164_dev *dev)
+static int saa7164_cmd_alloc_seqno(struct saa7164_dev *dev)
 {
 	int i, ret = -1;
 
@@ -42,7 +42,7 @@ int saa7164_cmd_alloc_seqno(struct saa7164_dev *dev)
 	return ret;
 }
 
-void saa7164_cmd_free_seqno(struct saa7164_dev *dev, u8 seqno)
+static void saa7164_cmd_free_seqno(struct saa7164_dev *dev, u8 seqno)
 {
 	mutex_lock(&dev->lock);
 	if ((dev->cmds[seqno].inuse == 1) &&
@@ -54,7 +54,7 @@ void saa7164_cmd_free_seqno(struct saa7164_dev *dev, u8 seqno)
 	mutex_unlock(&dev->lock);
 }
 
-void saa7164_cmd_timeout_seqno(struct saa7164_dev *dev, u8 seqno)
+static void saa7164_cmd_timeout_seqno(struct saa7164_dev *dev, u8 seqno)
 {
 	mutex_lock(&dev->lock);
 	if ((dev->cmds[seqno].inuse == 1) &&
@@ -64,7 +64,7 @@ void saa7164_cmd_timeout_seqno(struct saa7164_dev *dev, u8 seqno)
 	mutex_unlock(&dev->lock);
 }
 
-u32 saa7164_cmd_timeout_get(struct saa7164_dev *dev, u8 seqno)
+static u32 saa7164_cmd_timeout_get(struct saa7164_dev *dev, u8 seqno)
 {
 	int ret = 0;
 
@@ -132,7 +132,7 @@ int saa7164_irq_dequeue(struct saa7164_dev *dev)
 
 /* Commands to the f/w get marshelled to/from this code then onto the PCI
  * -bus/c running buffer. */
-int saa7164_cmd_dequeue(struct saa7164_dev *dev)
+static int saa7164_cmd_dequeue(struct saa7164_dev *dev)
 {
 	int loop = 1;
 	int ret;
@@ -186,8 +186,8 @@ int saa7164_cmd_dequeue(struct saa7164_dev *dev)
 	return SAA_OK;
 }
 
-int saa7164_cmd_set(struct saa7164_dev *dev, struct tmComResInfo *msg,
-	void *buf)
+static int saa7164_cmd_set(struct saa7164_dev *dev, struct tmComResInfo *msg,
+			   void *buf)
 {
 	struct tmComResBusInfo *bus = &dev->bus;
 	u8 cmd_sent;
@@ -259,7 +259,7 @@ out:
 /* Wait for a signal event, without holding a mutex. Either return TIMEOUT if
  * the event never occurred, or SAA_OK if it was signaled during the wait.
  */
-int saa7164_cmd_wait(struct saa7164_dev *dev, u8 seqno)
+static int saa7164_cmd_wait(struct saa7164_dev *dev, u8 seqno)
 {
 	wait_queue_head_t *q = NULL;
 	int ret = SAA_BUS_TIMEOUT;
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index a9ed686..994018e 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -1101,7 +1101,8 @@ static int fops_release(struct file *file)
 	return 0;
 }
 
-struct saa7164_user_buffer *saa7164_enc_next_buf(struct saa7164_port *port)
+static struct
+saa7164_user_buffer *saa7164_enc_next_buf(struct saa7164_port *port)
 {
 	struct saa7164_user_buffer *ubuf = NULL;
 	struct saa7164_dev *dev = port->dev;
@@ -1287,8 +1288,8 @@ static const struct v4l2_file_operations mpeg_fops = {
 	.unlocked_ioctl	= video_ioctl2,
 };
 
-int saa7164_g_chip_ident(struct file *file, void *fh,
-	struct v4l2_dbg_chip_ident *chip)
+static int saa7164_g_chip_ident(struct file *file, void *fh,
+				struct v4l2_dbg_chip_ident *chip)
 {
 	struct saa7164_port *port = ((struct saa7164_encoder_fh *)fh)->port;
 	struct saa7164_dev *dev = port->dev;
@@ -1297,8 +1298,8 @@ int saa7164_g_chip_ident(struct file *file, void *fh,
 	return 0;
 }
 
-int saa7164_g_register(struct file *file, void *fh,
-	struct v4l2_dbg_register *reg)
+static int saa7164_g_register(struct file *file, void *fh,
+			      struct v4l2_dbg_register *reg)
 {
 	struct saa7164_port *port = ((struct saa7164_encoder_fh *)fh)->port;
 	struct saa7164_dev *dev = port->dev;
@@ -1310,8 +1311,8 @@ int saa7164_g_register(struct file *file, void *fh,
 	return 0;
 }
 
-int saa7164_s_register(struct file *file, void *fh,
-	struct v4l2_dbg_register *reg)
+static int saa7164_s_register(struct file *file, void *fh,
+			      struct v4l2_dbg_register *reg)
 {
 	struct saa7164_port *port = ((struct saa7164_encoder_fh *)fh)->port;
 	struct saa7164_dev *dev = port->dev;
diff --git a/drivers/media/pci/saa7164/saa7164-fw.c b/drivers/media/pci/saa7164/saa7164-fw.c
index a266bf0..8676320 100644
--- a/drivers/media/pci/saa7164/saa7164-fw.c
+++ b/drivers/media/pci/saa7164/saa7164-fw.c
@@ -37,7 +37,7 @@ struct fw_header {
 	u32	version;
 };
 
-int saa7164_dl_wait_ack(struct saa7164_dev *dev, u32 reg)
+static int saa7164_dl_wait_ack(struct saa7164_dev *dev, u32 reg)
 {
 	u32 timeout = SAA_DEVICE_TIMEOUT;
 	while ((saa7164_readl(reg) & 0x01) == 0) {
@@ -53,7 +53,7 @@ int saa7164_dl_wait_ack(struct saa7164_dev *dev, u32 reg)
 	return 0;
 }
 
-int saa7164_dl_wait_clr(struct saa7164_dev *dev, u32 reg)
+static int saa7164_dl_wait_clr(struct saa7164_dev *dev, u32 reg)
 {
 	u32 timeout = SAA_DEVICE_TIMEOUT;
 	while (saa7164_readl(reg) & 0x01) {
@@ -71,8 +71,8 @@ int saa7164_dl_wait_clr(struct saa7164_dev *dev, u32 reg)
 
 /* TODO: move dlflags into dev-> and change to write/readl/b */
 /* TODO: Excessive levels of debug */
-int saa7164_downloadimage(struct saa7164_dev *dev, u8 *src, u32 srcsize,
-	u32 dlflags, u8 *dst, u32 dstsize)
+static int saa7164_downloadimage(struct saa7164_dev *dev, u8 *src, u32 srcsize,
+				 u32 dlflags, u8 *dst, u32 dstsize)
 {
 	u32 reg, timeout, offset;
 	u8 *srcbuf = NULL;
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index d8e6c8f..b453229 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -984,7 +984,8 @@ out:
 	return ret;
 }
 
-int saa7164_vbi_fmt(struct file *file, void *priv, struct v4l2_format *f)
+static int saa7164_vbi_fmt(struct file *file, void *priv,
+			   struct v4l2_format *f)
 {
 	/* ntsc */
 	f->fmt.vbi.samples_per_line = 1600;
@@ -1047,7 +1048,8 @@ static int fops_release(struct file *file)
 	return 0;
 }
 
-struct saa7164_user_buffer *saa7164_vbi_next_buf(struct saa7164_port *port)
+static struct
+saa7164_user_buffer *saa7164_vbi_next_buf(struct saa7164_port *port)
 {
 	struct saa7164_user_buffer *ubuf = NULL;
 	struct saa7164_dev *dev = port->dev;
-- 
1.7.11.7

