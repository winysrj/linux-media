Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47481 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbaKGOkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 09:40:10 -0500
Message-ID: <545CD9B2.804@xs4all.nl>
Date: Fri, 07 Nov 2014 15:39:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Steven Toth <stoth@kernellabs.com>
Subject: [PATCH] saa7164: fix sparse warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix many sparse warnings:

drivers/media/pci/saa7164/saa7164-core.c:97:18: warning: cast removes address space of expression
drivers/media/pci/saa7164/saa7164-core.c:122:31: warning: cast removes address space of expression
drivers/media/pci/saa7164/saa7164-core.c:122:31: warning: incorrect type in initializer (different address spaces)
drivers/media/pci/saa7164/saa7164-core.c:122:31:    expected unsigned char [noderef] [usertype] <asn:2>*bufcpu
drivers/media/pci/saa7164/saa7164-core.c:122:31:    got unsigned char [usertype] *<noident>
drivers/media/pci/saa7164/saa7164-core.c:282:44: warning: cast removes address space of expression
drivers/media/pci/saa7164/saa7164-core.c:286:38: warning: cast removes address space of expression
drivers/media/pci/saa7164/saa7164-core.c:286:35: warning: incorrect type in assignment (different address spaces)
drivers/media/pci/saa7164/saa7164-core.c:286:35:    expected unsigned char [noderef] [usertype] <asn:2>*p
drivers/media/pci/saa7164/saa7164-core.c:286:35:    got unsigned char [usertype] *<noident>
drivers/media/pci/saa7164/saa7164-core.c:352:44: warning: cast removes address space of expression
drivers/media/pci/saa7164/saa7164-core.c:527:53: warning: cast removes address space of expression
drivers/media/pci/saa7164/saa7164-core.c:129:30: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:133:38: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:133:72: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:134:35: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:287:61: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:288:65: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:289:65: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:290:65: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:291:65: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:292:65: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:293:65: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-core.c:294:65: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-fw.c:548:52: warning: incorrect type in argument 5 (different address spaces)
drivers/media/pci/saa7164/saa7164-fw.c:548:52:    expected unsigned char [usertype] *dst
drivers/media/pci/saa7164/saa7164-fw.c:548:52:    got unsigned char [noderef] [usertype] <asn:2>*
drivers/media/pci/saa7164/saa7164-fw.c:579:44: warning: incorrect type in argument 5 (different address spaces)
drivers/media/pci/saa7164/saa7164-fw.c:579:44:    expected unsigned char [usertype] *dst
drivers/media/pci/saa7164/saa7164-fw.c:579:44:    got unsigned char [noderef] [usertype] <asn:2>*
drivers/media/pci/saa7164/saa7164-fw.c:597:44: warning: incorrect type in argument 5 (different address spaces)
drivers/media/pci/saa7164/saa7164-fw.c:597:44:    expected unsigned char [usertype] *dst
drivers/media/pci/saa7164/saa7164-fw.c:597:44:    got unsigned char [noderef] [usertype] <asn:2>*
drivers/media/pci/saa7164/saa7164-bus.c:36:36: warning: cast removes address space of expression
drivers/media/pci/saa7164/saa7164-bus.c:41:36: warning: cast removes address space of expression
drivers/media/pci/saa7164/saa7164-bus.c:151:19: warning: incorrect type in assignment (different base types)
drivers/media/pci/saa7164/saa7164-bus.c:151:19:    expected unsigned short [unsigned] [usertype] size
drivers/media/pci/saa7164/saa7164-bus.c:151:19:    got restricted __le16 [usertype] <noident>
drivers/media/pci/saa7164/saa7164-bus.c:152:22: warning: incorrect type in assignment (different base types)
drivers/media/pci/saa7164/saa7164-bus.c:152:22:    expected unsigned int [unsigned] [usertype] command
drivers/media/pci/saa7164/saa7164-bus.c:152:22:    got restricted __le32 [usertype] <noident>
drivers/media/pci/saa7164/saa7164-bus.c:153:30: warning: incorrect type in assignment (different base types)
drivers/media/pci/saa7164/saa7164-bus.c:153:30:    expected unsigned short [unsigned] [usertype] controlselector
drivers/media/pci/saa7164/saa7164-bus.c:153:30:    got restricted __le16 [usertype] <noident>
drivers/media/pci/saa7164/saa7164-bus.c:172:20: warning: cast to restricted __le32
drivers/media/pci/saa7164/saa7164-bus.c:173:20: warning: cast to restricted __le32
drivers/media/pci/saa7164/saa7164-bus.c:206:28: warning: cast to restricted __le32
drivers/media/pci/saa7164/saa7164-bus.c:287:9: warning: incorrect type in argument 1 (different base types)
drivers/media/pci/saa7164/saa7164-bus.c:287:9:    expected unsigned int [unsigned] val
drivers/media/pci/saa7164/saa7164-bus.c:287:9:    got restricted __le32 [usertype] <noident>
drivers/media/pci/saa7164/saa7164-bus.c:339:20: warning: cast to restricted __le32
drivers/media/pci/saa7164/saa7164-bus.c:340:20: warning: cast to restricted __le32
drivers/media/pci/saa7164/saa7164-bus.c:463:9: warning: incorrect type in argument 1 (different base types)
drivers/media/pci/saa7164/saa7164-bus.c:463:9:    expected unsigned int [unsigned] val
drivers/media/pci/saa7164/saa7164-bus.c:463:9:    got restricted __le32 [usertype] <noident>
drivers/media/pci/saa7164/saa7164-bus.c:466:21: warning: cast to restricted __le16
drivers/media/pci/saa7164/saa7164-bus.c:467:24: warning: cast to restricted __le32
drivers/media/pci/saa7164/saa7164-bus.c:468:32: warning: cast to restricted __le16
drivers/media/pci/saa7164/saa7164-buffer.c:122:18: warning: incorrect type in assignment (different address spaces)
drivers/media/pci/saa7164/saa7164-buffer.c:122:18:    expected unsigned long long [noderef] [usertype] <asn:2>*cpu
drivers/media/pci/saa7164/saa7164-buffer.c:122:18:    got void *
drivers/media/pci/saa7164/saa7164-buffer.c:127:21: warning: incorrect type in assignment (different address spaces)
drivers/media/pci/saa7164/saa7164-buffer.c:127:21:    expected unsigned long long [noderef] [usertype] <asn:2>*pt_cpu
drivers/media/pci/saa7164/saa7164-buffer.c:127:21:    got void *
drivers/media/pci/saa7164/saa7164-buffer.c:134:20: warning: cast removes address space of expression
drivers/media/pci/saa7164/saa7164-buffer.c:156:63: warning: incorrect type in argument 3 (different address spaces)
drivers/media/pci/saa7164/saa7164-buffer.c:156:63:    expected void *vaddr
drivers/media/pci/saa7164/saa7164-buffer.c:156:63:    got unsigned long long [noderef] [usertype] <asn:2>*cpu
drivers/media/pci/saa7164/saa7164-buffer.c:179:57: warning: incorrect type in argument 3 (different address spaces)
drivers/media/pci/saa7164/saa7164-buffer.c:179:57:    expected void *vaddr
drivers/media/pci/saa7164/saa7164-buffer.c:179:57:    got unsigned long long [noderef] [usertype] <asn:2>*cpu
drivers/media/pci/saa7164/saa7164-buffer.c:180:56: warning: incorrect type in argument 3 (different address spaces)
drivers/media/pci/saa7164/saa7164-buffer.c:180:56:    expected void *vaddr
drivers/media/pci/saa7164/saa7164-buffer.c:180:56:    got unsigned long long [noderef] [usertype] <asn:2>*pt_cpu
drivers/media/pci/saa7164/saa7164-buffer.c:84:17: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-buffer.c:147:31: warning: dereference of noderef expression
drivers/media/pci/saa7164/saa7164-buffer.c:148:17: warning: dereference of noderef expression

Most are caused by pointers marked as __iomem when they aren't or not marked as
__iomem when they should.

Also note that readl/writel already do endian conversion, so there is no need to
do it again.

saa7164_bus_set/get were a bit tricky: you have to make sure the msg endian
conversion is done at the right time, and that the code isn't using fields that
are still little endian instead of cpu-endianness.

The approach chosen is to convert just before writing to the ring buffer
and to convert it back right after reading from the ring buffer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Steven Toth <stoth@kernellabs.com>
---
 drivers/media/pci/saa7164/saa7164-buffer.c |   4 +-
 drivers/media/pci/saa7164/saa7164-bus.c    | 101 +++++++++++++++++------------
 drivers/media/pci/saa7164/saa7164-core.c   |  13 ++--
 drivers/media/pci/saa7164/saa7164-fw.c     |   6 +-
 drivers/media/pci/saa7164/saa7164-types.h  |   4 +-
 drivers/media/pci/saa7164/saa7164.h        |   4 +-
 6 files changed, 74 insertions(+), 58 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-buffer.c b/drivers/media/pci/saa7164/saa7164-buffer.c
index 66696fa..9bd1f73 100644
--- a/drivers/media/pci/saa7164/saa7164-buffer.c
+++ b/drivers/media/pci/saa7164/saa7164-buffer.c
@@ -130,9 +130,9 @@ struct saa7164_buffer *saa7164_buffer_alloc(struct saa7164_port *port,
 		goto fail2;
 
 	/* init the buffers to a known pattern, easier during debugging */
-	memset_io(buf->cpu, 0xff, buf->pci_size);
+	memset(buf->cpu, 0xff, buf->pci_size);
 	buf->crc = crc32(0, buf->cpu, buf->actual_size);
-	memset_io(buf->pt_cpu, 0xff, buf->pt_size);
+	memset(buf->pt_cpu, 0xff, buf->pt_size);
 
 	dprintk(DBGLVL_BUF, "%s()   allocated buffer @ 0x%p (%d pageptrs)\n",
 		__func__, buf, params->numpagetables);
diff --git a/drivers/media/pci/saa7164/saa7164-bus.c b/drivers/media/pci/saa7164/saa7164-bus.c
index 5f6f309..6c73f5b 100644
--- a/drivers/media/pci/saa7164/saa7164-bus.c
+++ b/drivers/media/pci/saa7164/saa7164-bus.c
@@ -33,12 +33,12 @@ int saa7164_bus_setup(struct saa7164_dev *dev)
 	b->Type			= TYPE_BUS_PCIe;
 	b->m_wMaxReqSize	= SAA_DEVICE_MAXREQUESTSIZE;
 
-	b->m_pdwSetRing		= (u8 *)(dev->bmmio +
+	b->m_pdwSetRing		= (u8 __iomem *)(dev->bmmio +
 		((u32)dev->busdesc.CommandRing));
 
 	b->m_dwSizeSetRing	= SAA_DEVICE_BUFFERBLOCKSIZE;
 
-	b->m_pdwGetRing		= (u8 *)(dev->bmmio +
+	b->m_pdwGetRing		= (u8 __iomem *)(dev->bmmio +
 		((u32)dev->busdesc.ResponseRing));
 
 	b->m_dwSizeGetRing	= SAA_DEVICE_BUFFERBLOCKSIZE;
@@ -138,6 +138,7 @@ int saa7164_bus_set(struct saa7164_dev *dev, struct tmComResInfo* msg,
 	u32 bytes_to_write, free_write_space, timeout, curr_srp, curr_swp;
 	u32 new_swp, space_rem;
 	int ret = SAA_ERR_BAD_PARAMETER;
+	u16 size;
 
 	if (!msg) {
 		printk(KERN_ERR "%s() !msg\n", __func__);
@@ -148,10 +149,6 @@ int saa7164_bus_set(struct saa7164_dev *dev, struct tmComResInfo* msg,
 
 	saa7164_bus_verify(dev);
 
-	msg->size = cpu_to_le16(msg->size);
-	msg->command = cpu_to_le32(msg->command);
-	msg->controlselector = cpu_to_le16(msg->controlselector);
-
 	if (msg->size > dev->bus.m_wMaxReqSize) {
 		printk(KERN_ERR "%s() Exceeded dev->bus.m_wMaxReqSize\n",
 			__func__);
@@ -169,8 +166,8 @@ int saa7164_bus_set(struct saa7164_dev *dev, struct tmComResInfo* msg,
 	bytes_to_write = sizeof(*msg) + msg->size;
 	free_write_space = 0;
 	timeout = SAA_BUS_TIMEOUT;
-	curr_srp = le32_to_cpu(saa7164_readl(bus->m_dwSetReadPos));
-	curr_swp = le32_to_cpu(saa7164_readl(bus->m_dwSetWritePos));
+	curr_srp = saa7164_readl(bus->m_dwSetReadPos);
+	curr_swp = saa7164_readl(bus->m_dwSetWritePos);
 
 	/* Deal with ring wrapping issues */
 	if (curr_srp > curr_swp)
@@ -203,7 +200,7 @@ int saa7164_bus_set(struct saa7164_dev *dev, struct tmComResInfo* msg,
 		mdelay(1);
 
 		/* Check the space usage again */
-		curr_srp = le32_to_cpu(saa7164_readl(bus->m_dwSetReadPos));
+		curr_srp = saa7164_readl(bus->m_dwSetReadPos);
 
 		/* Deal with ring wrapping issues */
 		if (curr_srp > curr_swp)
@@ -223,6 +220,16 @@ int saa7164_bus_set(struct saa7164_dev *dev, struct tmComResInfo* msg,
 	dprintk(DBGLVL_BUS, "%s() bus->m_dwSizeSetRing = %x\n", __func__,
 		bus->m_dwSizeSetRing);
 
+	/*
+	 * Make a copy of msg->size before it is converted to le16 since it is
+	 * used in the code below.
+	 */
+	size = msg->size;
+	/* Convert to le16/le32 */
+	msg->size = (__force u16)cpu_to_le16(msg->size);
+	msg->command = (__force u32)cpu_to_le32(msg->command);
+	msg->controlselector = (__force u16)cpu_to_le16(msg->controlselector);
+
 	/* Mental Note: line 462 tmmhComResBusPCIe.cpp */
 
 	/* Check if we're going to wrap again */
@@ -243,28 +250,28 @@ int saa7164_bus_set(struct saa7164_dev *dev, struct tmComResInfo* msg,
 			dprintk(DBGLVL_BUS, "%s() tr4\n", __func__);
 
 			/* Split the msg into pieces as the ring wraps */
-			memcpy(bus->m_pdwSetRing + curr_swp, msg, space_rem);
-			memcpy(bus->m_pdwSetRing, (u8 *)msg + space_rem,
+			memcpy_toio(bus->m_pdwSetRing + curr_swp, msg, space_rem);
+			memcpy_toio(bus->m_pdwSetRing, (u8 *)msg + space_rem,
 				sizeof(*msg) - space_rem);
 
-			memcpy(bus->m_pdwSetRing + sizeof(*msg) - space_rem,
-				buf, msg->size);
+			memcpy_toio(bus->m_pdwSetRing + sizeof(*msg) - space_rem,
+				buf, size);
 
 		} else if (space_rem == sizeof(*msg)) {
 			dprintk(DBGLVL_BUS, "%s() tr5\n", __func__);
 
 			/* Additional data at the beginning of the ring */
-			memcpy(bus->m_pdwSetRing + curr_swp, msg, sizeof(*msg));
-			memcpy(bus->m_pdwSetRing, buf, msg->size);
+			memcpy_toio(bus->m_pdwSetRing + curr_swp, msg, sizeof(*msg));
+			memcpy_toio(bus->m_pdwSetRing, buf, size);
 
 		} else {
 			/* Additional data wraps around the ring */
-			memcpy(bus->m_pdwSetRing + curr_swp, msg, sizeof(*msg));
-			if (msg->size > 0) {
-				memcpy(bus->m_pdwSetRing + curr_swp +
+			memcpy_toio(bus->m_pdwSetRing + curr_swp, msg, sizeof(*msg));
+			if (size > 0) {
+				memcpy_toio(bus->m_pdwSetRing + curr_swp +
 					sizeof(*msg), buf, space_rem -
 					sizeof(*msg));
-				memcpy(bus->m_pdwSetRing, (u8 *)buf +
+				memcpy_toio(bus->m_pdwSetRing, (u8 *)buf +
 					space_rem - sizeof(*msg),
 					bytes_to_write - space_rem);
 			}
@@ -276,15 +283,20 @@ int saa7164_bus_set(struct saa7164_dev *dev, struct tmComResInfo* msg,
 		dprintk(DBGLVL_BUS, "%s() tr6\n", __func__);
 
 		/* The ring buffer doesn't wrap, two simple copies */
-		memcpy(bus->m_pdwSetRing + curr_swp, msg, sizeof(*msg));
-		memcpy(bus->m_pdwSetRing + curr_swp + sizeof(*msg), buf,
-			msg->size);
+		memcpy_toio(bus->m_pdwSetRing + curr_swp, msg, sizeof(*msg));
+		memcpy_toio(bus->m_pdwSetRing + curr_swp + sizeof(*msg), buf,
+			size);
 	}
 
 	dprintk(DBGLVL_BUS, "%s() new_swp = %x\n", __func__, new_swp);
 
 	/* Update the bus write position */
-	saa7164_writel(bus->m_dwSetWritePos, cpu_to_le32(new_swp));
+	saa7164_writel(bus->m_dwSetWritePos, new_swp);
+
+	/* Convert back to cpu after writing the msg to the ringbuffer. */
+	msg->size = le16_to_cpu((__force __le16)msg->size);
+	msg->command = le32_to_cpu((__force __le32)msg->command);
+	msg->controlselector = le16_to_cpu((__force __le16)msg->controlselector);
 	ret = SAA_OK;
 
 out:
@@ -336,8 +348,8 @@ int saa7164_bus_get(struct saa7164_dev *dev, struct tmComResInfo* msg,
 	/* Peek the bus to see if a msg exists, if it's not what we're expecting
 	 * then return cleanly else read the message from the bus.
 	 */
-	curr_gwp = le32_to_cpu(saa7164_readl(bus->m_dwGetWritePos));
-	curr_grp = le32_to_cpu(saa7164_readl(bus->m_dwGetReadPos));
+	curr_gwp = saa7164_readl(bus->m_dwGetWritePos);
+	curr_grp = saa7164_readl(bus->m_dwGetReadPos);
 
 	if (curr_gwp == curr_grp) {
 		ret = SAA_ERR_EMPTY;
@@ -369,14 +381,18 @@ int saa7164_bus_get(struct saa7164_dev *dev, struct tmComResInfo* msg,
 		new_grp -= bus->m_dwSizeGetRing;
 		space_rem = bus->m_dwSizeGetRing - curr_grp;
 
-		memcpy(&msg_tmp, bus->m_pdwGetRing + curr_grp, space_rem);
-		memcpy((u8 *)&msg_tmp + space_rem, bus->m_pdwGetRing,
+		memcpy_fromio(&msg_tmp, bus->m_pdwGetRing + curr_grp, space_rem);
+		memcpy_fromio((u8 *)&msg_tmp + space_rem, bus->m_pdwGetRing,
 			bytes_to_read - space_rem);
 
 	} else {
 		/* No wrapping */
-		memcpy(&msg_tmp, bus->m_pdwGetRing + curr_grp, bytes_to_read);
+		memcpy_fromio(&msg_tmp, bus->m_pdwGetRing + curr_grp, bytes_to_read);
 	}
+	/* Convert from little endian to CPU */
+	msg_tmp.size = le16_to_cpu((__force __le16)msg_tmp.size);
+	msg_tmp.command = le32_to_cpu((__force __le32)msg_tmp.command);
+	msg_tmp.controlselector = le16_to_cpu((__force __le16)msg_tmp.controlselector);
 
 	/* No need to update the read positions, because this was a peek */
 	/* If the caller specifically want to peek, return */
@@ -427,24 +443,24 @@ int saa7164_bus_get(struct saa7164_dev *dev, struct tmComResInfo* msg,
 
 		if (space_rem < sizeof(*msg)) {
 			/* msg wraps around the ring */
-			memcpy(msg, bus->m_pdwGetRing + curr_grp, space_rem);
-			memcpy((u8 *)msg + space_rem, bus->m_pdwGetRing,
+			memcpy_fromio(msg, bus->m_pdwGetRing + curr_grp, space_rem);
+			memcpy_fromio((u8 *)msg + space_rem, bus->m_pdwGetRing,
 				sizeof(*msg) - space_rem);
 			if (buf)
-				memcpy(buf, bus->m_pdwGetRing + sizeof(*msg) -
+				memcpy_fromio(buf, bus->m_pdwGetRing + sizeof(*msg) -
 					space_rem, buf_size);
 
 		} else if (space_rem == sizeof(*msg)) {
-			memcpy(msg, bus->m_pdwGetRing + curr_grp, sizeof(*msg));
+			memcpy_fromio(msg, bus->m_pdwGetRing + curr_grp, sizeof(*msg));
 			if (buf)
-				memcpy(buf, bus->m_pdwGetRing, buf_size);
+				memcpy_fromio(buf, bus->m_pdwGetRing, buf_size);
 		} else {
 			/* Additional data wraps around the ring */
-			memcpy(msg, bus->m_pdwGetRing + curr_grp, sizeof(*msg));
+			memcpy_fromio(msg, bus->m_pdwGetRing + curr_grp, sizeof(*msg));
 			if (buf) {
-				memcpy(buf, bus->m_pdwGetRing + curr_grp +
+				memcpy_fromio(buf, bus->m_pdwGetRing + curr_grp +
 					sizeof(*msg), space_rem - sizeof(*msg));
-				memcpy(buf + space_rem - sizeof(*msg),
+				memcpy_fromio(buf + space_rem - sizeof(*msg),
 					bus->m_pdwGetRing, bytes_to_read -
 					space_rem);
 			}
@@ -453,19 +469,20 @@ int saa7164_bus_get(struct saa7164_dev *dev, struct tmComResInfo* msg,
 
 	} else {
 		/* No wrapping */
-		memcpy(msg, bus->m_pdwGetRing + curr_grp, sizeof(*msg));
+		memcpy_fromio(msg, bus->m_pdwGetRing + curr_grp, sizeof(*msg));
 		if (buf)
-			memcpy(buf, bus->m_pdwGetRing + curr_grp + sizeof(*msg),
+			memcpy_fromio(buf, bus->m_pdwGetRing + curr_grp + sizeof(*msg),
 				buf_size);
 	}
+	/* Convert from little endian to CPU */
+	msg->size = le16_to_cpu((__force __le16)msg->size);
+	msg->command = le32_to_cpu((__force __le32)msg->command);
+	msg->controlselector = le16_to_cpu((__force __le16)msg->controlselector);
 
 	/* Update the read positions, adjusting the ring */
-	saa7164_writel(bus->m_dwGetReadPos, cpu_to_le32(new_grp));
+	saa7164_writel(bus->m_dwGetReadPos, new_grp);
 
 peekout:
-	msg->size = le16_to_cpu(msg->size);
-	msg->command = le32_to_cpu(msg->command);
-	msg->controlselector = le16_to_cpu(msg->controlselector);
 	ret = SAA_OK;
 out:
 	mutex_unlock(&bus->lock);
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index cc1be8a..4b0bec3 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -119,7 +119,7 @@ static void saa7164_ts_verifier(struct saa7164_buffer *buf)
 	u32 i;
 	u8 cc, a;
 	u16 pid;
-	u8 __iomem *bufcpu = (u8 *)buf->cpu;
+	u8 *bufcpu = (u8 *)buf->cpu;
 
 	port->sync_errors = 0;
 	port->v_cc_errors = 0;
@@ -260,7 +260,7 @@ static void saa7164_work_enchandler_helper(struct saa7164_port *port, int bufnr)
 	struct saa7164_user_buffer *ubuf = NULL;
 	struct list_head *c, *n;
 	int i = 0;
-	u8 __iomem *p;
+	u8 *p;
 
 	mutex_lock(&port->dmaqueue_lock);
 	list_for_each_safe(c, n, &port->dmaqueue.list) {
@@ -318,8 +318,7 @@ static void saa7164_work_enchandler_helper(struct saa7164_port *port, int bufnr)
 
 				if (buf->actual_size <= ubuf->actual_size) {
 
-					memcpy_fromio(ubuf->data, buf->cpu,
-						ubuf->actual_size);
+					memcpy(ubuf->data, buf->cpu, ubuf->actual_size);
 
 					if (crc_checking) {
 						/* Throw a new checksum on the read buffer */
@@ -346,7 +345,7 @@ static void saa7164_work_enchandler_helper(struct saa7164_port *port, int bufnr)
 			 * with known bad data. We check for this data at a later point
 			 * in time. */
 			saa7164_buffer_zero_offsets(port, bufnr);
-			memset_io(buf->cpu, 0xff, buf->pci_size);
+			memset(buf->cpu, 0xff, buf->pci_size);
 			if (crc_checking) {
 				/* Throw yet aanother new checksum on the dma buffer */
 				buf->crc = crc32(0, buf->cpu, buf->actual_size);
@@ -1096,7 +1095,7 @@ static int saa7164_proc_show(struct seq_file *m, void *v)
 			if (c == 0)
 				seq_printf(m, " %04x:", i);
 
-			seq_printf(m, " %02x", *(b->m_pdwSetRing + i));
+			seq_printf(m, " %02x", readb(b->m_pdwSetRing + i));
 
 			if (++c == 16) {
 				seq_printf(m, "\n");
@@ -1111,7 +1110,7 @@ static int saa7164_proc_show(struct seq_file *m, void *v)
 			if (c == 0)
 				seq_printf(m, " %04x:", i);
 
-			seq_printf(m, " %02x", *(b->m_pdwGetRing + i));
+			seq_printf(m, " %02x", readb(b->m_pdwGetRing + i));
 
 			if (++c == 16) {
 				seq_printf(m, "\n");
diff --git a/drivers/media/pci/saa7164/saa7164-fw.c b/drivers/media/pci/saa7164/saa7164-fw.c
index 8676320..add06ab 100644
--- a/drivers/media/pci/saa7164/saa7164-fw.c
+++ b/drivers/media/pci/saa7164/saa7164-fw.c
@@ -72,7 +72,7 @@ static int saa7164_dl_wait_clr(struct saa7164_dev *dev, u32 reg)
 /* TODO: move dlflags into dev-> and change to write/readl/b */
 /* TODO: Excessive levels of debug */
 static int saa7164_downloadimage(struct saa7164_dev *dev, u8 *src, u32 srcsize,
-				 u32 dlflags, u8 *dst, u32 dstsize)
+				 u32 dlflags, u8 __iomem *dst, u32 dstsize)
 {
 	u32 reg, timeout, offset;
 	u8 *srcbuf = NULL;
@@ -136,7 +136,7 @@ static int saa7164_downloadimage(struct saa7164_dev *dev, u8 *src, u32 srcsize,
 		srcsize -= dstsize, offset += dstsize) {
 
 		dprintk(DBGLVL_FW, "%s() memcpy %d\n", __func__, dstsize);
-		memcpy(dst, srcbuf + offset, dstsize);
+		memcpy_toio(dst, srcbuf + offset, dstsize);
 
 		/* Flag the data as ready */
 		saa7164_writel(drflag, 1);
@@ -154,7 +154,7 @@ static int saa7164_downloadimage(struct saa7164_dev *dev, u8 *src, u32 srcsize,
 
 	dprintk(DBGLVL_FW, "%s() memcpy(l) %d\n", __func__, dstsize);
 	/* Write last block to the device */
-	memcpy(dst, srcbuf+offset, srcsize);
+	memcpy_toio(dst, srcbuf+offset, srcsize);
 
 	/* Flag the data as ready */
 	saa7164_writel(drflag, 1);
diff --git a/drivers/media/pci/saa7164/saa7164-types.h b/drivers/media/pci/saa7164/saa7164-types.h
index 1d2140a..f48ba97 100644
--- a/drivers/media/pci/saa7164/saa7164-types.h
+++ b/drivers/media/pci/saa7164/saa7164-types.h
@@ -78,9 +78,9 @@ enum tmBusType {
 struct tmComResBusInfo {
 	enum tmBusType Type;
 	u16	m_wMaxReqSize;
-	u8	*m_pdwSetRing;
+	u8 __iomem *m_pdwSetRing;
 	u32	m_dwSizeSetRing;
-	u8	*m_pdwGetRing;
+	u8 __iomem *m_pdwGetRing;
 	u32	m_dwSizeGetRing;
 	u32	m_dwSetWritePos;
 	u32	m_dwSetReadPos;
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index 8b29e89..cd1a07c 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -313,13 +313,13 @@ struct saa7164_buffer {
 
 	/* A block of page align PCI memory */
 	u32 pci_size;	/* PCI allocation size in bytes */
-	u64 __iomem *cpu;	/* Virtual address */
+	u64 *cpu;	/* Virtual address */
 	dma_addr_t dma;	/* Physical address */
 	u32 crc;	/* Checksum for the entire buffer data */
 
 	/* A page table that splits the block into a number of entries */
 	u32 pt_size;		/* PCI allocation size in bytes */
-	u64 __iomem *pt_cpu;		/* Virtual address */
+	u64 *pt_cpu;		/* Virtual address */
 	dma_addr_t pt_dma;	/* Physical address */
 
 	/* Encoder fops */
-- 
2.1.1

