Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1KZmyZ-0007ue-72
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 15:28:20 +0200
Received: by fg-out-1718.google.com with SMTP id e21so947103fga.25
	for <linux-dvb@linuxtv.org>; Sun, 31 Aug 2008 06:28:15 -0700 (PDT)
Message-ID: <48BA9C67.7030607@gmail.com>
Date: Sun, 31 Aug 2008 15:28:07 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------080705000206000702090702"
From: e9hack <e9hack@googlemail.com>
Subject: [linux-dvb] [PATCH] dma sync fix for FF-cards
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------080705000206000702090702
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

according to DMA-API.txt, dma synchronisation must be done before a transfer to the device 
starts and after a transfer from the device ends. This is missing for the DEBI dma 
transfer of a FF-card.

-Hartmut


--------------080705000206000702090702
Content-Type: text/x-patch;
 name="av7110-dmasync.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="av7110-dmasync.patch"

Signed-off-by: Hartmut Birr <e9hack@gmail.com>
diff -r 6032ecd6ad7e linux/drivers/media/dvb/ttpci/av7110.c
--- a/linux/drivers/media/dvb/ttpci/av7110.c	Sat Aug 30 11:07:04 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/av7110.c	Sun Aug 31 14:55:29 2008 +0200
@@ -397,6 +397,9 @@ static void debiirq(unsigned long data)
 	switch (type & 0xff) {
 
 	case DATA_TS_RECORD:
+		pci_dma_sync_single_for_cpu(av7110->dev->pci,
+			av7110->debi_bus, 8192, PCI_DMA_FROMDEVICE);
+
 		dvb_dmx_swfilter_packets(&av7110->demux,
 					 (const u8 *) av7110->debi_virt,
 					 av7110->debilen / 188);
@@ -404,6 +407,9 @@ static void debiirq(unsigned long data)
 		break;
 
 	case DATA_PES_RECORD:
+		pci_dma_sync_single_for_cpu(av7110->dev->pci,
+			 av7110->debi_bus, 8192, PCI_DMA_FROMDEVICE);
+
 		if (av7110->demux.recording)
 			av7110_record_cb(&av7110->p2t[handle],
 					 (u8 *) av7110->debi_virt,
@@ -414,6 +420,9 @@ static void debiirq(unsigned long data)
 	case DATA_IPMPE:
 	case DATA_FSECTION:
 	case DATA_PIPING:
+		pci_dma_sync_single_for_cpu(av7110->dev->pci,
+			av7110->debi_bus, 8192, PCI_DMA_FROMDEVICE);
+
 		if (av7110->handle2filter[handle])
 			DvbDmxFilterCallback((u8 *)av7110->debi_virt,
 					     av7110->debilen, NULL, 0,
@@ -425,6 +434,9 @@ static void debiirq(unsigned long data)
 	case DATA_CI_GET:
 	{
 		u8 *data = av7110->debi_virt;
+
+		pci_dma_sync_single_for_cpu(av7110->dev->pci,
+			av7110->debi_bus, 8192, PCI_DMA_FROMDEVICE);
 
 		if ((data[0] < 2) && data[2] == 0xff) {
 			int flags = 0;
@@ -442,6 +454,9 @@ static void debiirq(unsigned long data)
 	}
 
 	case DATA_COMMON_INTERFACE:
+		pci_dma_sync_single_for_cpu(av7110->dev->pci,
+			av7110->debi_bus, 8192, PCI_DMA_FROMDEVICE);
+
 		CI_handle(av7110, (u8 *)av7110->debi_virt, av7110->debilen);
 #if 0 /* keep */
 	{
@@ -462,6 +477,9 @@ static void debiirq(unsigned long data)
 		break;
 
 	case DATA_DEBUG_MESSAGE:
+		pci_dma_sync_single_for_cpu(av7110->dev->pci,
+			av7110->debi_bus, 8192, PCI_DMA_FROMDEVICE);
+
 		((s8*)av7110->debi_virt)[Reserved_SIZE - 1] = 0;
 		printk("%s\n", (s8 *) av7110->debi_virt);
 		xfer = RX_BUFF;
@@ -588,6 +606,9 @@ static void gpioirq(unsigned long data)
 		DVB_RINGBUFFER_SKIP(cibuf, 2);
 
 		dvb_ringbuffer_read(cibuf, av7110->debi_virt, len);
+
+		pci_dma_sync_single_for_device(av7110->dev->pci,
+			av7110->debi_bus, 8192, PCI_DMA_TODEVICE);
 
 		iwdebi(av7110, DEBINOSWAP, TX_LEN, len, 2);
 		iwdebi(av7110, DEBINOSWAP, IRQ_STATE_EXT, len, 2);
@@ -623,6 +644,9 @@ static void gpioirq(unsigned long data)
 			iwdebi(av7110, DEBINOSWAP, TX_BUFF, 0, 2);
 			break;
 		}
+		pci_dma_sync_single_for_device(av7110->dev->pci,
+			av7110->debi_bus, 8192, PCI_DMA_TODEVICE);
+
 		dprintk(8, "GPIO0 PES_PLAY len=%04x\n", len);
 		iwdebi(av7110, DEBINOSWAP, TX_LEN, len, 2);
 		iwdebi(av7110, DEBINOSWAP, IRQ_STATE_EXT, len, 2);
@@ -650,6 +674,8 @@ static void gpioirq(unsigned long data)
 		iwdebi(av7110, DEBINOSWAP, TX_LEN, len, 2);
 		iwdebi(av7110, DEBINOSWAP, IRQ_STATE_EXT, len, 2);
 		memcpy(av7110->debi_virt, av7110->bmpbuf+av7110->bmpp, len);
+		pci_dma_sync_single_for_device(av7110->dev->pci,
+			av7110->debi_bus, 8192, PCI_DMA_TODEVICE);
 		av7110->bmpp += len;
 		av7110->bmplen -= len;
 		dprintk(8, "gpio DATA_BMP_LOAD DMA len %d\n", len);
@@ -2603,7 +2629,7 @@ static int __devinit av7110_attach(struc
 	/* allocate and init buffers */
 	av7110->debi_virt = pci_alloc_consistent(pdev, 8192, &av7110->debi_bus);
 	if (!av7110->debi_virt)
-		goto err_saa71466_vfree_4;
+		goto err_saa7146_vfree_4;
 
 
 	av7110->iobuf = vmalloc(AVOUTLEN+AOUTLEN+BMPLEN+4*IPACKS);
@@ -2688,7 +2714,7 @@ err_iobuf_vfree_6:
 	vfree(av7110->iobuf);
 err_pci_free_5:
 	pci_free_consistent(pdev, 8192, av7110->debi_virt, av7110->debi_bus);
-err_saa71466_vfree_4:
+err_saa7146_vfree_4:
 	if (av7110->grabbing)
 		saa7146_vfree_destroy_pgtable(pdev, av7110->grabbing, &av7110->pt);
 err_i2c_del_3:

--------------080705000206000702090702
Content-Type: text/x-patch;
 name="ts-mod-av7110-dmasync.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ts-mod-av7110-dmasync.patch"

Signed-off-by: Hartmut Birr <e9hack@gmail.com>
diff -r 1760a612cc98 linux/drivers/media/dvb/ttpci/av7110.c
--- a/linux/drivers/media/dvb/ttpci/av7110.c	Sun Aug 03 05:02:35 2008 +0200
+++ b/linux/drivers/media/dvb/ttpci/av7110.c	Sun Aug 31 14:45:44 2008 +0200
@@ -372,10 +372,14 @@ static void processDmaRx(unsigned long d
 	struct av7110 *av7110 = (struct av7110 *) data;
 	int idx;
 
+	/* Ensure streamed PCI data is synced to CPU */
+	pci_dma_sync_single_for_cpu(av7110->dev->pci, av7110->debi_rx_bus,
+				    DMA_RX_BUF_LEN, PCI_DMA_FROMDEVICE);
+
 	while (av7110->rx.debilen[idx = av7110->rx.readIdx]) {
 		int debitype = av7110->rx.debitype[idx];
 		int handle = (debitype >> 8) & 0x1f;
-		u8 *debibuf = av7110->debi_virt + av7110->rx.offset[idx];
+		u8 *debibuf = av7110->debi_rx_virt + av7110->rx.offset[idx];
 		unsigned debilen = av7110->rx.debilen[idx];
 
 		switch (debitype & 0xff) {
@@ -466,7 +470,7 @@ static void fillDmaTx(unsigned long data
 	int len;
 
 	while (! av7110->tx_av.debilen[idx = av7110->tx_av.writeIdx]) {
-		debibuf = av7110->debi_virt + av7110->tx_av.offset[idx];
+		debibuf = av7110->debi_tx_virt + av7110->tx_av.offset[idx];
 		len = av7110_pes_play(debibuf, &av7110->avout, DMA_TX_BUF_SIZE);
 		if (len <= 0)
 			break;
@@ -477,7 +481,7 @@ static void fillDmaTx(unsigned long data
 	}
 
 	while (! av7110->tx_a.debilen[idx = av7110->tx_a.writeIdx]) {
-		debibuf = av7110->debi_virt + av7110->tx_a.offset[idx];
+		debibuf = av7110->debi_tx_virt + av7110->tx_a.offset[idx];
 		len = av7110_pes_play(debibuf, &av7110->aout, DMA_TX_BUF_SIZE);
 		if (len <= 0)
 			break;
@@ -492,7 +496,7 @@ static void fillDmaTx(unsigned long data
 		len = min(av7110->bmplen, DMA_TX_BUF_SIZE);
 		if (len <= 0)
 			break;
-		debibuf = av7110->debi_virt + av7110->tx_bmp.offset[idx];
+		debibuf = av7110->debi_tx_virt + av7110->tx_bmp.offset[idx];
 		memcpy(debibuf, av7110->bmpbuf + av7110->bmpp, len);
 		av7110->bmpp += len;
 		av7110->bmplen -= len;
@@ -501,6 +505,9 @@ static void fillDmaTx(unsigned long data
 			idx = 0;
 		av7110->tx_bmp.writeIdx = idx;
 	}
+	/* Ensure CPU data is synced to the device */
+	pci_dma_sync_single_for_device(av7110->dev->pci, av7110->debi_tx_bus,
+				       DMA_TX_BUF_LEN, PCI_DMA_TODEVICE);
 }
 
 
@@ -801,7 +808,13 @@ static void gpioirq(struct av7110 *av711
 		}
 		DVB_RINGBUFFER_SKIP(cibuf, 2);
 
-		dvb_ringbuffer_read(cibuf, av7110->debi_virt, len);
+		dvb_ringbuffer_read(cibuf, av7110->debi_tx_virt, len);
+
+		/* Ensure CPU data is synced to the device */
+		pci_dma_sync_single_for_device(av7110->dev->pci,
+					       av7110->debi_tx_bus,
+					       DMA_TX_BUF_LEN,
+					       PCI_DMA_TODEVICE);
 
 		iwdebi(av7110, DEBINOSWAP, TX_LEN, len, 2);
 		dprintk(8, "DMA: CI\n");
@@ -2837,19 +2850,26 @@ static int __devinit av7110_attach(struc
 	av7110->arm_thread = NULL;
 
 	/* allocate and init buffers */
-	av7110->debi_virt = pci_alloc_consistent(pdev, DMA_BUF_LEN, &av7110->debi_bus);
-	if (!av7110->debi_virt)
-		goto err_saa71466_vfree_4;
+	av7110->debi_rx_virt = pci_alloc_consistent(pdev, DMA_RX_BUF_LEN,
+						    &av7110->debi_rx_bus);
+	if (!av7110->debi_rx_virt)
+		goto err_saa7146_vfree_4;
+	av7110->debi_tx_virt = pci_alloc_consistent(pdev, DMA_TX_BUF_LEN,
+						    &av7110->debi_tx_bus);
+	if (!av7110->debi_tx_virt)
+		goto err_saa7146_vfree_4a;
 
 	offset = DMA_TX_MISC_BUF_SIZE;
-	for (i = 0; i < DMA_RX_BUFS; i++, offset += DMA_RX_BUF_SIZE)
-		av7110->rx.offset[i] = offset;
 	for (i = 0; i < DMA_TX_AV_BUFS; i++, offset += DMA_TX_BUF_SIZE)
 		av7110->tx_av.offset[i] = offset;
 	for (i = 0; i < DMA_TX_A_BUFS; i++, offset += DMA_TX_BUF_SIZE)
 		av7110->tx_a.offset[i] = offset;
 	for (i = 0; i < DMA_TX_BMP_BUFS; i++, offset += DMA_TX_BUF_SIZE)
 		av7110->tx_bmp.offset[i] = offset;
+
+	offset = 0;
+	for (i = 0; i < DMA_RX_BUFS; i++, offset += DMA_RX_BUF_SIZE)
+		av7110->rx.offset[i] = offset;
 
 	av7110->iobuf = vmalloc(AVOUTLEN+AOUTLEN+BMPLEN+4*IPACKS);
 	if (!av7110->iobuf)
@@ -2932,8 +2952,12 @@ err_iobuf_vfree_6:
 err_iobuf_vfree_6:
 	vfree(av7110->iobuf);
 err_pci_free_5:
-	pci_free_consistent(pdev, DMA_BUF_LEN, av7110->debi_virt, av7110->debi_bus);
-err_saa71466_vfree_4:
+	pci_free_consistent(pdev, DMA_TX_BUF_LEN,
+			    av7110->debi_tx_virt, av7110->debi_tx_bus);
+err_saa7146_vfree_4a:
+	pci_free_consistent(pdev, DMA_RX_BUF_LEN,
+			    av7110->debi_rx_virt, av7110->debi_rx_bus);
+err_saa7146_vfree_4:
 	if (av7110->grabbing)
 		saa7146_vfree_destroy_pgtable(pdev, av7110->grabbing, &av7110->pt);
 err_i2c_del_3:
@@ -2985,8 +3009,10 @@ static int __devexit av7110_detach(struc
 	av7110_av_exit(av7110);
 
 	vfree(av7110->iobuf);
-	pci_free_consistent(saa->pci, DMA_BUF_LEN, av7110->debi_virt,
-			    av7110->debi_bus);
+	pci_free_consistent(saa->pci, DMA_RX_BUF_LEN, av7110->debi_rx_virt,
+			    av7110->debi_rx_bus);
+	pci_free_consistent(saa->pci, DMA_TX_BUF_LEN, av7110->debi_tx_virt,
+			    av7110->debi_tx_bus);
 
 	i2c_del_adapter(&av7110->i2c_adap);
 
diff -r 1760a612cc98 linux/drivers/media/dvb/ttpci/av7110.h
--- a/linux/drivers/media/dvb/ttpci/av7110.h	Sun Aug 03 05:02:35 2008 +0200
+++ b/linux/drivers/media/dvb/ttpci/av7110.h	Sun Aug 31 14:45:44 2008 +0200
@@ -104,11 +104,11 @@ struct infrared {
 #define DMA_TX_BMP_BUFS		3	/* TX bitmap */
 #define DMA_MAX_TX_BUFS		5	/* maximum of the above */
 #define DMA_TX_MISC_BUF_SIZE	0x800	/* TX everything else */
-#define DMA_BUF_LEN		( DMA_TX_MISC_BUF_SIZE			\
-				+ DMA_RX_BUFS * DMA_RX_BUF_SIZE		\
+#define DMA_RX_BUF_LEN		(DMA_RX_BUFS * DMA_RX_BUF_SIZE)
+#define DMA_TX_BUF_LEN		(DMA_TX_MISC_BUF_SIZE			\
 				+ DMA_TX_A_BUFS * DMA_TX_BUF_SIZE	\
 				+ DMA_TX_AV_BUFS * DMA_TX_BUF_SIZE	\
-				+ DMA_TX_BMP_BUFS * DMA_TX_BUF_SIZE )
+				+ DMA_TX_BMP_BUFS * DMA_TX_BUF_SIZE)
 
 struct dma_rx {
 	unsigned	readIdx;
@@ -266,8 +266,10 @@ struct av7110 {
 	u16		    arm_loops;
 
 	/* DMA buffers */
-	void			*debi_virt;
-	dma_addr_t		debi_bus;
+	void			*debi_rx_virt;
+	void			*debi_tx_virt;
+	dma_addr_t		debi_rx_bus;
+	dma_addr_t		debi_tx_bus;
 	struct dma_rx		rx;
 	struct tasklet_struct	rx_tasklet;
 	struct dma_tx		tx_a;
diff -r 1760a612cc98 linux/drivers/media/dvb/ttpci/av7110_hw.c
--- a/linux/drivers/media/dvb/ttpci/av7110_hw.c	Sun Aug 03 05:02:35 2008 +0200
+++ b/linux/drivers/media/dvb/ttpci/av7110_hw.c	Sun Aug 31 14:45:44 2008 +0200
@@ -64,7 +64,7 @@ int av7110_debiwrite(struct av7110 *av71
 	if (count <= 4)		/* immediate transfer */
 		saa7146_write(dev, DEBI_AD, val);
 	else			/* block transfer */
-		saa7146_write(dev, DEBI_AD, av7110->debi_bus + offset);
+		saa7146_write(dev, DEBI_AD, av7110->debi_tx_bus + offset);
 	saa7146_write(dev, DEBI_COMMAND, (count << 17) | (addr & 0xffff));
 	saa7146_write(dev, MC2, (2 << 16) | 2);
 	return 0;
@@ -84,7 +84,7 @@ u32 av7110_debiread(struct av7110 *av711
 		printk("%s: wait_for_debi_done #1 failed\n", __func__);
 		return 0;
 	}
-	saa7146_write(dev, DEBI_AD, av7110->debi_bus + offset);
+	saa7146_write(dev, DEBI_AD, av7110->debi_rx_bus + offset);
 	saa7146_write(dev, DEBI_COMMAND, (count << 17) | 0x10000 | (addr & 0xffff));
 
 	saa7146_write(dev, DEBI_CONFIG, config);
diff -r 1760a612cc98 linux/drivers/media/dvb/ttpci/av7110_hw.h
--- a/linux/drivers/media/dvb/ttpci/av7110_hw.h	Sun Aug 03 05:02:35 2008 +0200
+++ b/linux/drivers/media/dvb/ttpci/av7110_hw.h	Sun Aug 31 14:45:44 2008 +0200
@@ -392,7 +392,9 @@ static inline void iwdebi(struct av7110 
 /* buffer writes */
 static inline void mwdebi(struct av7110 *av7110, u32 config, int addr, u8 *val, int count)
 {
-	memcpy(av7110->debi_virt, val, count);
+	memcpy(av7110->debi_tx_virt, val, count);
+	pci_dma_sync_single_for_device(av7110->dev->pci, av7110->debi_tx_bus,
+				       DMA_TX_BUF_LEN, PCI_DMA_TODEVICE);
 	av7110_debiwrite(av7110, config, 0, addr, 0, count);
 }
 

--------------080705000206000702090702
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080705000206000702090702--
