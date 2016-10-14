Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59237 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757065AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH 18/57] [media] saa7164: don't break long lines
Date: Fri, 14 Oct 2016 17:20:06 -0300
Message-Id: <4fe5a784c88c5e4c1625147bc0f8fac38f7b6f5c.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/saa7164/saa7164-buffer.c  |  3 +-
 drivers/media/pci/saa7164/saa7164-bus.c     |  3 +-
 drivers/media/pci/saa7164/saa7164-cards.c   |  3 +-
 drivers/media/pci/saa7164/saa7164-cmd.c     | 10 ++----
 drivers/media/pci/saa7164/saa7164-core.c    | 56 ++++++++++-------------------
 drivers/media/pci/saa7164/saa7164-dvb.c     | 27 +++++---------
 drivers/media/pci/saa7164/saa7164-encoder.c | 15 +++-----
 drivers/media/pci/saa7164/saa7164-fw.c      |  9 ++---
 drivers/media/pci/saa7164/saa7164-vbi.c     | 12 +++----
 9 files changed, 45 insertions(+), 93 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-buffer.c b/drivers/media/pci/saa7164/saa7164-buffer.c
index f30758e24f5d..ff04ef322fc1 100644
--- a/drivers/media/pci/saa7164/saa7164-buffer.c
+++ b/drivers/media/pci/saa7164/saa7164-buffer.c
@@ -218,8 +218,7 @@ int saa7164_buffer_activate(struct saa7164_buffer *buf, int i)
 	saa7164_writel(port->bufptr32h + ((sizeof(u32) * 2) * i), buf->pt_dma);
 	saa7164_writel(port->bufptr32l + ((sizeof(u32) * 2) * i), 0);
 
-	dprintk(DBGLVL_BUF, "   buf[%d] offset 0x%llx (0x%x) "
-		"buf 0x%llx/%llx (0x%x/%x) nr=%d\n",
+	dprintk(DBGLVL_BUF, "   buf[%d] offset 0x%llx (0x%x) buf 0x%llx/%llx (0x%x/%x) nr=%d\n",
 		buf->idx,
 		(u64)port->bufoffset + (i * sizeof(u32)),
 		saa7164_readl(port->bufoffset + (sizeof(u32) * i)),
diff --git a/drivers/media/pci/saa7164/saa7164-bus.c b/drivers/media/pci/saa7164/saa7164-bus.c
index a18fe5d47238..00c2aae059a0 100644
--- a/drivers/media/pci/saa7164/saa7164-bus.c
+++ b/drivers/media/pci/saa7164/saa7164-bus.c
@@ -427,8 +427,7 @@ int saa7164_bus_get(struct saa7164_dev *dev, struct tmComResInfo* msg,
 		write_distance = curr_gwp + bus->m_dwSizeGetRing - curr_grp;
 
 	if (bytes_to_read > write_distance) {
-		printk(KERN_ERR "%s() Invalid bus state, missing msg "
-			"or mangled ring, faulty H/W / bad code?\n", __func__);
+		printk(KERN_ERR "%s() Invalid bus state, missing msg or mangled ring, faulty H/W / bad code?\n", __func__);
 		ret = SAA_ERR_INVALID_COMMAND;
 		goto out;
 	}
diff --git a/drivers/media/pci/saa7164/saa7164-cards.c b/drivers/media/pci/saa7164/saa7164-cards.c
index c2b738227f58..bfe0af2c00f4 100644
--- a/drivers/media/pci/saa7164/saa7164-cards.c
+++ b/drivers/media/pci/saa7164/saa7164-cards.c
@@ -726,8 +726,7 @@ void saa7164_card_list(struct saa7164_dev *dev)
 			dev->name, dev->name, dev->name, dev->name);
 	}
 
-	printk(KERN_ERR "%s: Here are valid choices for the card=<n> insmod "
-		"option:\n", dev->name);
+	printk(KERN_ERR "%s: Here are valid choices for the card=<n> insmod option:\n", dev->name);
 
 	for (i = 0; i < saa7164_bcount; i++)
 		printk(KERN_ERR "%s:    card=%d -> %s\n",
diff --git a/drivers/media/pci/saa7164/saa7164-cmd.c b/drivers/media/pci/saa7164/saa7164-cmd.c
index 3285c37b4583..1a6fc8e589b6 100644
--- a/drivers/media/pci/saa7164/saa7164-cmd.c
+++ b/drivers/media/pci/saa7164/saa7164-cmd.c
@@ -301,8 +301,7 @@ static int saa7164_cmd_wait(struct saa7164_dev *dev, u8 seqno)
 			else
 				saa7164_cmd_timeout_seqno(dev, seqno);
 
-			dprintk(DBGLVL_CMD, "%s(seqno=%d) Waiting res = %d "
-				"(signalled=%d)\n", __func__, seqno, r,
+			dprintk(DBGLVL_CMD, "%s(seqno=%d) Waiting res = %d (signalled=%d)\n", __func__, seqno, r,
 				dev->cmds[seqno].signalled);
 		} else
 			ret = SAA_OK;
@@ -353,8 +352,7 @@ int saa7164_cmd_send(struct saa7164_dev *dev, u8 id, enum tmComResCmd command,
 	int ret;
 	int safety = 0;
 
-	dprintk(DBGLVL_CMD, "%s(unitid = %s (%d) , command = 0x%x, "
-		"sel = 0x%x)\n", __func__, saa7164_unitid_name(dev, id), id,
+	dprintk(DBGLVL_CMD, "%s(unitid = %s (%d) , command = 0x%x, sel = 0x%x)\n", __func__, saa7164_unitid_name(dev, id), id,
 		command, controlselector);
 
 	if ((size == 0) || (buf == NULL)) {
@@ -452,9 +450,7 @@ int saa7164_cmd_send(struct saa7164_dev *dev, u8 id, enum tmComResCmd command,
 		if (presponse_t->seqno != pcommand_t->seqno) {
 
 			dprintk(DBGLVL_CMD,
-				"wrong event: seqno = %d, "
-				"expected seqno = %d, "
-				"will dequeue regardless\n",
+				"wrong event: seqno = %d, expected seqno = %d, will dequeue regardless\n",
 				presponse_t->seqno, pcommand_t->seqno);
 
 			ret = saa7164_cmd_dequeue(dev);
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 8bbd092fbe1d..ba07b033e289 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -710,9 +710,7 @@ static irqreturn_t saa7164_irq(int irq, void *dev_id)
 				} else {
 					/* Find the function */
 					dprintk(DBGLVL_IRQ,
-						"%s() unhandled interrupt "
-						"reg 0x%x bit 0x%x "
-						"intid = 0x%x\n",
+						"%s() unhandled interrupt reg 0x%x bit 0x%x intid = 0x%x\n",
 						__func__, i, bit, intid);
 				}
 			}
@@ -767,13 +765,10 @@ void saa7164_dumpregs(struct saa7164_dev *dev, u32 addr)
 {
 	int i;
 
-	dprintk(1, "--------------------> "
-		"00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f\n");
+	dprintk(1, "--------------------> 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f\n");
 
 	for (i = 0; i < 0x100; i += 16)
-		dprintk(1, "region0[0x%08x] = "
-			"%02x %02x %02x %02x %02x %02x %02x %02x"
-			" %02x %02x %02x %02x %02x %02x %02x %02x\n", i,
+		dprintk(1, "region0[0x%08x] = %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n", i,
 			(u8)saa7164_readb(addr + i + 0),
 			(u8)saa7164_readb(addr + i + 1),
 			(u8)saa7164_readb(addr + i + 2),
@@ -825,8 +820,7 @@ static void saa7164_dump_hwdesc(struct saa7164_dev *dev)
 
 static void saa7164_dump_intfdesc(struct saa7164_dev *dev)
 {
-	dprintk(1, "@0x%p intfdesc "
-		"sizeof(struct tmComResInterfaceDescr) = %d bytes\n",
+	dprintk(1, "@0x%p intfdesc sizeof(struct tmComResInterfaceDescr) = %d bytes\n",
 		&dev->intfdesc, (u32)sizeof(struct tmComResInterfaceDescr));
 
 	dprintk(1, " .bLength = 0x%x\n", dev->intfdesc.bLength);
@@ -1011,8 +1005,7 @@ static int saa7164_dev_setup(struct saa7164_dev *dev)
 	saa7164_port_init(dev, SAA7164_PORT_VBI2);
 
 	if (get_resources(dev) < 0) {
-		printk(KERN_ERR "CORE %s No more PCIe resources for "
-		       "subsystem: %04x:%04x\n",
+		printk(KERN_ERR "CORE %s No more PCIe resources for subsystem: %04x:%04x\n",
 		       dev->name, dev->pci->subsystem_vendor,
 		       dev->pci->subsystem_device);
 
@@ -1204,8 +1197,7 @@ static bool saa7164_enable_msi(struct pci_dev *pci_dev, struct saa7164_dev *dev)
 	err = pci_enable_msi(pci_dev);
 
 	if (err) {
-		printk(KERN_ERR "%s() Failed to enable MSI interrupt."
-			" Falling back to a shared IRQ\n", __func__);
+		printk(KERN_ERR "%s() Failed to enable MSI interrupt. Falling back to a shared IRQ\n", __func__);
 		return false;
 	}
 
@@ -1215,8 +1207,7 @@ static bool saa7164_enable_msi(struct pci_dev *pci_dev, struct saa7164_dev *dev)
 
 	if (err) {
 		/* fall back to legacy interrupt */
-		printk(KERN_ERR "%s() Failed to get an MSI interrupt."
-		       " Falling back to a shared IRQ\n", __func__);
+		printk(KERN_ERR "%s() Failed to get an MSI interrupt. Falling back to a shared IRQ\n", __func__);
 		pci_disable_msi(pci_dev);
 		return false;
 	}
@@ -1256,8 +1247,7 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 	/* print pci info */
 	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
-	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, "
-	       "latency: %d, mmio: 0x%llx\n", dev->name,
+	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n", dev->name,
 	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 	       dev->pci_lat,
 		(unsigned long long)pci_resource_start(pci_dev, 0));
@@ -1307,8 +1297,7 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 		err = saa7164_downloadfirmware(dev);
 		if (err < 0) {
 			printk(KERN_ERR
-				"Failed to boot firmware, no features "
-				"registered\n");
+				"Failed to boot firmware, no features registered\n");
 			goto fail_fw;
 		}
 
@@ -1327,8 +1316,7 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 		 */
 		version = 0;
 		if (saa7164_api_get_fw_version(dev, &version) == SAA_OK)
-			dprintk(1, "Bus is operating correctly using "
-				"version %d.%d.%d.%d (0x%x)\n",
+			dprintk(1, "Bus is operating correctly using version %d.%d.%d.%d (0x%x)\n",
 				(version & 0x0000fc00) >> 10,
 				(version & 0x000003e0) >> 5,
 				(version & 0x0000001f),
@@ -1356,45 +1344,39 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 		/* Begin to create the video sub-systems and register funcs */
 		if (saa7164_boards[dev->board].porta == SAA7164_MPEG_DVB) {
 			if (saa7164_dvb_register(&dev->ports[SAA7164_PORT_TS1]) < 0) {
-				printk(KERN_ERR "%s() Failed to register "
-					"dvb adapters on porta\n",
+				printk(KERN_ERR "%s() Failed to register dvb adapters on porta\n",
 					__func__);
 			}
 		}
 
 		if (saa7164_boards[dev->board].portb == SAA7164_MPEG_DVB) {
 			if (saa7164_dvb_register(&dev->ports[SAA7164_PORT_TS2]) < 0) {
-				printk(KERN_ERR"%s() Failed to register "
-					"dvb adapters on portb\n",
+				printk(KERN_ERR"%s() Failed to register dvb adapters on portb\n",
 					__func__);
 			}
 		}
 
 		if (saa7164_boards[dev->board].portc == SAA7164_MPEG_ENCODER) {
 			if (saa7164_encoder_register(&dev->ports[SAA7164_PORT_ENC1]) < 0) {
-				printk(KERN_ERR"%s() Failed to register "
-					"mpeg encoder\n", __func__);
+				printk(KERN_ERR"%s() Failed to register mpeg encoder\n", __func__);
 			}
 		}
 
 		if (saa7164_boards[dev->board].portd == SAA7164_MPEG_ENCODER) {
 			if (saa7164_encoder_register(&dev->ports[SAA7164_PORT_ENC2]) < 0) {
-				printk(KERN_ERR"%s() Failed to register "
-					"mpeg encoder\n", __func__);
+				printk(KERN_ERR"%s() Failed to register mpeg encoder\n", __func__);
 			}
 		}
 
 		if (saa7164_boards[dev->board].porte == SAA7164_MPEG_VBI) {
 			if (saa7164_vbi_register(&dev->ports[SAA7164_PORT_VBI1]) < 0) {
-				printk(KERN_ERR"%s() Failed to register "
-					"vbi device\n", __func__);
+				printk(KERN_ERR"%s() Failed to register vbi device\n", __func__);
 			}
 		}
 
 		if (saa7164_boards[dev->board].portf == SAA7164_MPEG_VBI) {
 			if (saa7164_vbi_register(&dev->ports[SAA7164_PORT_VBI2]) < 0) {
-				printk(KERN_ERR"%s() Failed to register "
-					"vbi device\n", __func__);
+				printk(KERN_ERR"%s() Failed to register vbi device\n", __func__);
 			}
 		}
 		saa7164_api_set_debug(dev, fw_debug);
@@ -1404,15 +1386,13 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 				"saa7164 debug");
 			if (IS_ERR(dev->kthread)) {
 				dev->kthread = NULL;
-				printk(KERN_ERR "%s() Failed to create "
-					"debug kernel thread\n", __func__);
+				printk(KERN_ERR "%s() Failed to create debug kernel thread\n", __func__);
 			}
 		}
 
 	} /* != BOARD_UNKNOWN */
 	else
-		printk(KERN_ERR "%s() Unsupported board detected, "
-			"registering without firmware\n", __func__);
+		printk(KERN_ERR "%s() Unsupported board detected, registering without firmware\n", __func__);
 
 	dprintk(1, "%s() parameter debug = %d\n", __func__, saa_debug);
 	dprintk(1, "%s() parameter waitsecs = %d\n", __func__, waitsecs);
diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
index e9a783b71b45..6c21399c948e 100644
--- a/drivers/media/pci/saa7164/saa7164-dvb.c
+++ b/drivers/media/pci/saa7164/saa7164-dvb.c
@@ -244,8 +244,7 @@ static int saa7164_dvb_start_port(struct saa7164_port *port)
 		/* Stop the hardware, regardless */
 		result = saa7164_api_transition_port(port, SAA_DMASTATE_STOP);
 		if ((result != SAA_OK) && (result != SAA_ERR_ALREADY_STOPPED)) {
-			printk(KERN_ERR "%s() acquire/forced stop transition "
-				"failed, res = 0x%x\n", __func__, result);
+			printk(KERN_ERR "%s() acquire/forced stop transition failed, res = 0x%x\n", __func__, result);
 		}
 		ret = -EIO;
 		goto out;
@@ -261,8 +260,7 @@ static int saa7164_dvb_start_port(struct saa7164_port *port)
 		/* Stop the hardware, regardless */
 		result = saa7164_api_transition_port(port, SAA_DMASTATE_STOP);
 		if ((result != SAA_OK) && (result != SAA_ERR_ALREADY_STOPPED)) {
-			printk(KERN_ERR "%s() pause/forced stop transition "
-				"failed, res = 0x%x\n", __func__, result);
+			printk(KERN_ERR "%s() pause/forced stop transition failed, res = 0x%x\n", __func__, result);
 		}
 
 		ret = -EIO;
@@ -279,8 +277,7 @@ static int saa7164_dvb_start_port(struct saa7164_port *port)
 		/* Stop the hardware, regardless */
 		result = saa7164_api_transition_port(port, SAA_DMASTATE_STOP);
 		if ((result != SAA_OK) && (result != SAA_ERR_ALREADY_STOPPED)) {
-			printk(KERN_ERR "%s() run/forced stop transition "
-				"failed, res = 0x%x\n", __func__, result);
+			printk(KERN_ERR "%s() run/forced stop transition failed, res = 0x%x\n", __func__, result);
 		}
 
 		ret = -EIO;
@@ -357,8 +354,7 @@ static int dvb_register(struct saa7164_port *port)
 	/* Sanity check that the PCI configuration space is active */
 	if (port->hwcfg.BARLocation == 0) {
 		result = -ENOMEM;
-		printk(KERN_ERR "%s: dvb_register_adapter failed "
-		       "(errno = %d), NO PCI configuration\n",
+		printk(KERN_ERR "%s: dvb_register_adapter failed (errno = %d), NO PCI configuration\n",
 			DRIVER_NAME, result);
 		goto fail_adapter;
 	}
@@ -386,8 +382,7 @@ static int dvb_register(struct saa7164_port *port)
 
 		if (!buf) {
 			result = -ENOMEM;
-			printk(KERN_ERR "%s: dvb_register_adapter failed "
-			       "(errno = %d), unable to allocate buffers\n",
+			printk(KERN_ERR "%s: dvb_register_adapter failed (errno = %d), unable to allocate buffers\n",
 				DRIVER_NAME, result);
 			goto fail_adapter;
 		}
@@ -401,8 +396,7 @@ static int dvb_register(struct saa7164_port *port)
 	result = dvb_register_adapter(&dvb->adapter, DRIVER_NAME, THIS_MODULE,
 			&dev->pci->dev, adapter_nr);
 	if (result < 0) {
-		printk(KERN_ERR "%s: dvb_register_adapter failed "
-		       "(errno = %d)\n", DRIVER_NAME, result);
+		printk(KERN_ERR "%s: dvb_register_adapter failed (errno = %d)\n", DRIVER_NAME, result);
 		goto fail_adapter;
 	}
 	dvb->adapter.priv = port;
@@ -410,8 +404,7 @@ static int dvb_register(struct saa7164_port *port)
 	/* register frontend */
 	result = dvb_register_frontend(&dvb->adapter, dvb->frontend);
 	if (result < 0) {
-		printk(KERN_ERR "%s: dvb_register_frontend failed "
-		       "(errno = %d)\n", DRIVER_NAME, result);
+		printk(KERN_ERR "%s: dvb_register_frontend failed (errno = %d)\n", DRIVER_NAME, result);
 		goto fail_frontend;
 	}
 
@@ -444,16 +437,14 @@ static int dvb_register(struct saa7164_port *port)
 	dvb->fe_hw.source = DMX_FRONTEND_0;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		printk(KERN_ERR "%s: add_frontend failed "
-		       "(DMX_FRONTEND_0, errno = %d)\n", DRIVER_NAME, result);
+		printk(KERN_ERR "%s: add_frontend failed (DMX_FRONTEND_0, errno = %d)\n", DRIVER_NAME, result);
 		goto fail_fe_hw;
 	}
 
 	dvb->fe_mem.source = DMX_MEMORY_FE;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	if (result < 0) {
-		printk(KERN_ERR "%s: add_frontend failed "
-		       "(DMX_MEMORY_FE, errno = %d)\n", DRIVER_NAME, result);
+		printk(KERN_ERR "%s: add_frontend failed (DMX_MEMORY_FE, errno = %d)\n", DRIVER_NAME, result);
 		goto fail_fe_mem;
 	}
 
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 32a353d162e7..3aa4f50556e9 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -157,8 +157,7 @@ static int saa7164_encoder_buffers_alloc(struct saa7164_port *port)
 			params->pitch);
 
 		if (!buf) {
-			printk(KERN_ERR "%s() failed "
-			       "(errno = %d), unable to allocate buffer\n",
+			printk(KERN_ERR "%s() failed (errno = %d), unable to allocate buffer\n",
 				__func__, result);
 			result = -ENOMEM;
 			goto failed;
@@ -681,8 +680,7 @@ static int saa7164_encoder_start_streaming(struct saa7164_port *port)
 		/* Stop the hardware, regardless */
 		result = saa7164_api_transition_port(port, SAA_DMASTATE_STOP);
 		if ((result != SAA_OK) && (result != SAA_ERR_ALREADY_STOPPED)) {
-			printk(KERN_ERR "%s() acquire/forced stop transition "
-				"failed, res = 0x%x\n", __func__, result);
+			printk(KERN_ERR "%s() acquire/forced stop transition failed, res = 0x%x\n", __func__, result);
 		}
 		ret = -EIO;
 		goto out;
@@ -698,8 +696,7 @@ static int saa7164_encoder_start_streaming(struct saa7164_port *port)
 		/* Stop the hardware, regardless */
 		result = saa7164_api_transition_port(port, SAA_DMASTATE_STOP);
 		if ((result != SAA_OK) && (result != SAA_ERR_ALREADY_STOPPED)) {
-			printk(KERN_ERR "%s() pause/forced stop transition "
-				"failed, res = 0x%x\n", __func__, result);
+			printk(KERN_ERR "%s() pause/forced stop transition failed, res = 0x%x\n", __func__, result);
 		}
 
 		ret = -EIO;
@@ -716,8 +713,7 @@ static int saa7164_encoder_start_streaming(struct saa7164_port *port)
 		/* Stop the hardware, regardless */
 		result = saa7164_api_transition_port(port, SAA_DMASTATE_STOP);
 		if ((result != SAA_OK) && (result != SAA_ERR_ALREADY_STOPPED)) {
-			printk(KERN_ERR "%s() run/forced stop transition "
-				"failed, res = 0x%x\n", __func__, result);
+			printk(KERN_ERR "%s() run/forced stop transition failed, res = 0x%x\n", __func__, result);
 		}
 
 		ret = -EIO;
@@ -1026,8 +1022,7 @@ int saa7164_encoder_register(struct saa7164_port *port)
 
 	/* Sanity check that the PCI configuration space is active */
 	if (port->hwcfg.BARLocation == 0) {
-		printk(KERN_ERR "%s() failed "
-		       "(errno = %d), NO PCI configuration\n",
+		printk(KERN_ERR "%s() failed (errno = %d), NO PCI configuration\n",
 			__func__, result);
 		result = -ENOMEM;
 		goto failed;
diff --git a/drivers/media/pci/saa7164/saa7164-fw.c b/drivers/media/pci/saa7164/saa7164-fw.c
index 269e0782c7b6..60e141bf863b 100644
--- a/drivers/media/pci/saa7164/saa7164-fw.c
+++ b/drivers/media/pci/saa7164/saa7164-fw.c
@@ -421,8 +421,7 @@ int saa7164_downloadfirmware(struct saa7164_dev *dev)
 
 		ret = request_firmware(&fw, fwname, &dev->pci->dev);
 		if (ret) {
-			printk(KERN_ERR "%s() Upload failed. "
-				"(file not found?)\n", __func__);
+			printk(KERN_ERR "%s() Upload failed. (file not found?)\n", __func__);
 			return -ENOMEM;
 		}
 
@@ -478,15 +477,13 @@ int saa7164_downloadfirmware(struct saa7164_dev *dev)
 				0x03) && (saa7164_readl(SAA_DATAREADY_FLAG_ACK)
 				== 0x00) && (version == 0x00)) {
 
-				dprintk(DBGLVL_FW, "BootLoader version in  "
-					"rom %d.%d.%d.%d\n",
+				dprintk(DBGLVL_FW, "BootLoader version in  rom %d.%d.%d.%d\n",
 					(bootloaderversion & 0x0000fc00) >> 10,
 					(bootloaderversion & 0x000003e0) >> 5,
 					(bootloaderversion & 0x0000001f),
 					(bootloaderversion & 0xffff0000) >> 16
 					);
-				dprintk(DBGLVL_FW, "BootLoader version "
-					"in file %d.%d.%d.%d\n",
+				dprintk(DBGLVL_FW, "BootLoader version in file %d.%d.%d.%d\n",
 					(boothdr->version & 0x0000fc00) >> 10,
 					(boothdr->version & 0x000003e0) >> 5,
 					(boothdr->version & 0x0000001f),
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index ee54491459a6..2a04c685d307 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -110,8 +110,7 @@ static int saa7164_vbi_buffers_alloc(struct saa7164_port *port)
 			params->pitch);
 
 		if (!buf) {
-			printk(KERN_ERR "%s() failed "
-			       "(errno = %d), unable to allocate buffer\n",
+			printk(KERN_ERR "%s() failed (errno = %d), unable to allocate buffer\n",
 				__func__, result);
 			result = -ENOMEM;
 			goto failed;
@@ -384,8 +383,7 @@ static int saa7164_vbi_start_streaming(struct saa7164_port *port)
 		/* Stop the hardware, regardless */
 		result = saa7164_vbi_stop_port(port);
 		if (result != SAA_OK) {
-			printk(KERN_ERR "%s() pause/forced stop transition "
-				"failed, res = 0x%x\n", __func__, result);
+			printk(KERN_ERR "%s() pause/forced stop transition failed, res = 0x%x\n", __func__, result);
 		}
 
 		ret = -EIO;
@@ -403,8 +401,7 @@ static int saa7164_vbi_start_streaming(struct saa7164_port *port)
 		result = saa7164_vbi_acquire_port(port);
 		result = saa7164_vbi_stop_port(port);
 		if (result != SAA_OK) {
-			printk(KERN_ERR "%s() run/forced stop transition "
-				"failed, res = 0x%x\n", __func__, result);
+			printk(KERN_ERR "%s() run/forced stop transition failed, res = 0x%x\n", __func__, result);
 		}
 
 		ret = -EIO;
@@ -728,8 +725,7 @@ int saa7164_vbi_register(struct saa7164_port *port)
 
 	/* Sanity check that the PCI configuration space is active */
 	if (port->hwcfg.BARLocation == 0) {
-		printk(KERN_ERR "%s() failed "
-		       "(errno = %d), NO PCI configuration\n",
+		printk(KERN_ERR "%s() failed (errno = %d), NO PCI configuration\n",
 			__func__, result);
 		result = -ENOMEM;
 		goto failed;
-- 
2.7.4


