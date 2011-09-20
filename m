Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6219 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751409Ab1ITKSK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:18:10 -0400
Subject: [PATCH  1/17]DVB:Siano drivers - Adding LKM for handling SPI
 connected devices.
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:30:50 +0300
Message-ID: <1316514650.5199.79.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
It took a long time to merge all the changes in kernel.org with Siano
sources which were updated in a different repository for the last couple
of years.
I have made all the changes in small steps seperated to functional
reasons.
First patch is actually adding new kernel object which handles SPI
connection and used the spidrv of the kernel.
module is used mainly in android platforms but is a pure LKM works with
siano modules stack.

Thanks,
Doron Cohen


-------------------------

>From 9115d85edbafc38e48ed1fc5f1218da81b7c5a2e Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Mon, 12 Sep 2011 17:41:29 +0300
Subject: [PATCH 02/21] Add support in generic SPI driver for Siano SPI
connected devices

---
 drivers/media/dvb/siano/Kconfig        |   45 ++++
 drivers/media/dvb/siano/smsspicommon.c |  408
++++++++++++++++++++++++++++
 drivers/media/dvb/siano/smsspicommon.h |   96 +++++++
 drivers/media/dvb/siano/smsspidrv.c    |  455
++++++++++++++++++++++++++++++++
 drivers/media/dvb/siano/smsspiphy.c    |  246 +++++++++++++++++
 drivers/media/dvb/siano/smsspiphy.h    |   36 +++
 6 files changed, 1286 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/siano/smsspicommon.c
 create mode 100644 drivers/media/dvb/siano/smsspicommon.h
 create mode 100644 drivers/media/dvb/siano/smsspidrv.c
 create mode 100644 drivers/media/dvb/siano/smsspiphy.c
 create mode 100644 drivers/media/dvb/siano/smsspiphy.h

diff --git a/drivers/media/dvb/siano/Kconfig
b/drivers/media/dvb/siano/Kconfig
index bc6456e..aeca46f 100644
--- a/drivers/media/dvb/siano/Kconfig
+++ b/drivers/media/dvb/siano/Kconfig
@@ -17,6 +17,37 @@ config SMS_SIANO_MDTV
 if SMS_SIANO_MDTV
 menu "Siano module components"
 
+# Kernel sub systems support
+
+config SMS_DVB3_SUBSYS
+	bool "DVB v.3 Subsystem support"
+	depends on DVB_CORE
+	default y if DVB_CORE
+	---help---
+	Choose if you would like to have DVB v.3 kernel sub-system support.
+
+config SMS_DVB5_S2API_SUBSYS
+	bool "DVB v.5 (S2 API) Subsystem support"
+	default n
+	---help---
+	Choose if you would like to have DVB v.5 (S2 API) kernel sub-system
support.
+
+config SMS_HOSTLIB_SUBSYS
+	bool "Host Library Subsystem support"
+	default n
+	---help---
+	Choose if you would like to have Siano's host library kernel
sub-system support.
+
+if SMS_HOSTLIB_SUBSYS
+
+config SMS_NET_SUBSYS
+	tristate "Siano Network Adapter"
+	depends on NET
+	default n
+	---help---
+	Choose if you would like to have Siano's network adapter support.
+endif # SMS_HOSTLIB_SUBSYS
+
 # Hardware interfaces support
 
 config SMS_USB_DRV
@@ -30,5 +61,19 @@ config SMS_SDIO_DRV
 	depends on DVB_CORE && MMC
 	---help---
 	  Choose if you would like to have Siano's support for SDIO interface
+
+config SMS_SPI_DRV
+	tristate "SPI interface support"
+	depends on SPI
+	default y if SPI
+	---help---
+	Choose if you would like to have Siano's support for PXA 310 SPI
interface
+
+config SMS_I2C_DRV
+	tristate "I2C interface support"
+	depends on DVB_CORE && I2C
+	---help---
+	Choose if you would like to have Siano's support for I2C interface
+
 endmenu
 endif # SMS_SIANO_MDTV
diff --git a/drivers/media/dvb/siano/smsspicommon.c
b/drivers/media/dvb/siano/smsspicommon.c
new file mode 100644
index 0000000..d4ef3f8
--- /dev/null
+++ b/drivers/media/dvb/siano/smsspicommon.c
@@ -0,0 +1,408 @@
+/****************************************************************
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2008, Uri Shkolnik
+
+This program is free software: you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation, either version 2 of the License, or
+(at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+****************************************************************/
+#include "smsspicommon.h"
+#include "smsdbg_prn.h"
+
+static struct _rx_buffer_st *smsspi_handle_unused_bytes_buf(
+		struct _spi_dev *dev,
+		struct _rx_buffer_st *buf, int offset, int len,
+		int unused_bytes)
+{
+	struct _rx_buffer_st *tmp_buf;
+	tmp_buf = dev->cb.allocate_rx_buf(dev->context,
+		RX_PACKET_SIZE);
+	if (!tmp_buf) {
+		PRN_ERR((TXT
+			("Failed to allocate RX buffer.\n")));
+		return NULL;
+	}
+	if (unused_bytes > 0) {
+		/* Copy the remaining bytes to the end of
+		alignment block (256 bytes) so next read
+		will be aligned. */
+		int align_block =
+			(((unused_bytes + SPI_PACKET_SIZE -
+			1) >> SPI_PACKET_SIZE_BITS) <<
+			SPI_PACKET_SIZE_BITS);
+		memset(tmp_buf->ptr, 0,
+			align_block - unused_bytes);
+		memcpy((char *)tmp_buf->ptr +
+			(align_block - unused_bytes),
+			(char *)buf->ptr + offset + len -
+			unused_bytes, unused_bytes);
+	}
+	return tmp_buf;
+}
+
+static struct _rx_buffer_st *smsspi_common_find_msg(struct _spi_dev
*dev,
+		struct _rx_buffer_st *buf, int offset, int len,
+		int *unused_bytes, int *missing_bytes)
+{
+	int i;
+	int recieved_bytes, padded_msg_len;
+	int align_fix;
+	int msg_offset;
+	unsigned char *ptr = (unsigned char *)buf->ptr + offset;
+	if (unused_bytes == NULL || missing_bytes == NULL)
+		return NULL;
+
+	*missing_bytes = 0;
+	*unused_bytes = 0;
+
+	PRN_DBG((TXT("entering with %d bytes.\n"), len));
+	for (i = 0; i < len; i++, ptr++) {
+		switch (dev->rxState) {
+		case RxsWait_a5:
+			dev->rxState =
+			    ((*ptr & 0xff) == 0xa5) ? RxsWait_5a : RxsWait_a5;
+			dev->rxPacket.msg_offset =
+			    (unsigned long)ptr - (unsigned long)buf->ptr + 4;
+			break;
+		case RxsWait_5a:
+			if ((*ptr & 0xff) == 0x5a) {
+				dev->rxState = RxsWait_e7;
+			}
+			else {
+				dev->rxState = RxsWait_a5;
+				i--;
+				ptr--;	// re-scan current byte
+			}
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsWait_e7:
+			if ((*ptr & 0xff) == 0xe7) {
+				dev->rxState = RxsWait_7e;
+			}
+			else {
+				dev->rxState = RxsWait_a5;
+				i--;
+				ptr--;	// re-scan current byte
+			}
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsWait_7e:
+			if ((*ptr & 0xff) == 0x7e) {
+				dev->rxState = RxsTypeH;
+			}
+			else {
+				dev->rxState = RxsWait_a5;
+				i--;
+				ptr--;	// re-scan current byte
+			}
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsTypeH:
+			dev->rxPacket.msg_buf = buf;
+			dev->rxPacket.msg_offset =
+			    (unsigned long)ptr - (unsigned long)buf->ptr;
+			dev->rxState = RxsTypeL;
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsTypeL:
+			dev->rxState = RxsGetSrcId;
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsGetSrcId:
+			dev->rxState = RxsGetDstId;
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsGetDstId:
+			dev->rxState = RxsGetLenL;
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsGetLenL:
+			dev->rxState = RxsGetLenH;
+			dev->rxPacket.msg_len = (*ptr & 0xff);
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsGetLenH:
+			dev->rxState = RxsFlagsL;
+			dev->rxPacket.msg_len += (*ptr & 0xff) << 8;
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsFlagsL:
+			dev->rxState = RxsFlagsH;
+			dev->rxPacket.msg_flags = (*ptr & 0xff);
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsFlagsH:
+			dev->rxState = RxsData;
+			dev->rxPacket.msg_flags += (*ptr & 0xff) << 8;
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		case RxsData:
+			recieved_bytes =
+			    len + offset - dev->rxPacket.msg_offset;
+			padded_msg_len =
+			    ((dev->rxPacket.msg_len + 4 + SPI_PACKET_SIZE -
+			      1) >> SPI_PACKET_SIZE_BITS) <<
+			    SPI_PACKET_SIZE_BITS;
+			if (recieved_bytes < padded_msg_len) {
+				*unused_bytes = 0;
+				*missing_bytes = padded_msg_len -
+						recieved_bytes;
+				return buf;
+			}
+			dev->rxState = RxsWait_a5;
+			if (dev->cb.msg_found_cb) {
+				align_fix = 0;
+				if (dev->rxPacket.
+				    msg_flags & MSG_HDR_FLAG_SPLIT_MSG_HDR) {
+					align_fix =
+					    (dev->rxPacket.
+					     msg_flags >> 8) & 0x3;
+					/* The FW aligned the message data
+					therefore - alignment bytes should be
+					thrown away. Throw the alignment bytes
+					by moving the header ahead over the
+					alignment bytes. */
+					if (align_fix) {
+						int length;
+						ptr =
+						    (unsigned char *)dev->rxPacket.
+						    msg_buf->ptr +
+						    dev->rxPacket.msg_offset;
+
+						/* Restore header to original
+						state before alignment changes
+						*/
+						length =
+						    (ptr[5] << 8) | ptr[4];
+						length -= align_fix;
+						ptr[5] = length >> 8;
+						ptr[4] = length & 0xff;
+						/* Zero alignment flags */
+						ptr[7] &= 0xfc;
+
+						for (i = MSG_HDR_LEN - 1;
+						     i >= 0; i--) {
+							ptr[i + align_fix] =
+							    ptr[i];
+						}
+						dev->rxPacket.msg_offset +=
+						    align_fix;
+					}
+				}
+
+				PRN_DBG((TXT
+				("Msg found and sent to callback func.\n")));
+
+				/* force all messages to start on
+				 * 4-byte boundary */
+				msg_offset = dev->rxPacket.msg_offset;
+				if (msg_offset & 0x3) {
+					msg_offset &= (~0x3);
+					memmove((unsigned char *)
+						(dev->rxPacket.msg_buf->ptr)
+						+ msg_offset,
+						(unsigned char *)
+						(dev->rxPacket.msg_buf->ptr)
+						+ dev->rxPacket.msg_offset,
+						dev->rxPacket.msg_len -
+						align_fix);
+				}
+
+				*unused_bytes =
+				    len + offset - dev->rxPacket.msg_offset -
+				    dev->rxPacket.msg_len;
+
+				/* In any case we got here - unused_bytes
+				 * should not be 0 Because we want to force
+				 * reading at least 256 after the end
+				 * of any found message */
+				if (*unused_bytes == 0)
+					*unused_bytes = -1;
+
+				buf = smsspi_handle_unused_bytes_buf(dev, buf,
+						offset, len, *unused_bytes);
+
+				dev->cb.msg_found_cb(dev->context,
+							 dev->rxPacket.msg_buf,
+							 msg_offset,
+							 dev->rxPacket.msg_len -
+							 align_fix);
+				*missing_bytes = 0;
+				return buf;
+			} else {
+				PRN_DBG((TXT
+		 ("Msg found but no callback. therefore - thrown away.\n")));
+			}
+			PRN_DBG((TXT("state %d.\n"), dev->rxState));
+			break;
+		}
+	}
+
+	if (dev->rxState == RxsWait_a5) {
+		*unused_bytes = 0;
+		*missing_bytes = 0;
+		return buf;
+	} else {
+		/* Workaround to corner case: if the last byte of the buffer
+		is "a5" (first byte of the preamble), the host thinks it should
+		send another 256 bytes.  In case the a5 is the firmware
+		underflow byte, this will cause an infinite loop, so we check
+		for this case explicitly. */
+		if (dev->rxState == RxsWait_5a) {
+			if ((*(ptr - 2) == 0xa5) || (*((unsigned int*)(void*)(ptr-4)) ==
*((unsigned int*)(void*)(ptr-8)))) {
+				dev->rxState = RxsWait_a5;
+				*unused_bytes = 0;
+				*missing_bytes = 0;
+
+				return buf;
+			}
+		}
+
+		if (dev->rxPacket.msg_offset >= (SPI_PACKET_SIZE + 4))
+			/* adding 4 for the preamble. */
+		{		/*The packet will be copied to a new buffer
+				   and rescaned by the state machine */
+			struct _rx_buffer_st *tmp_buf = buf;
+			*unused_bytes = dev->rxState - RxsWait_a5;
+			tmp_buf = smsspi_handle_unused_bytes_buf(dev, buf,
+					offset, len, *unused_bytes);
+			dev->rxState = RxsWait_a5;
+			dev->cb.free_rx_buf(dev->context, buf);
+			*missing_bytes = 0;
+			return tmp_buf;
+		} else {
+			/* report missing bytes and continue
+			   with message scan. */
+			*unused_bytes = 0;
+			*missing_bytes = SPI_PACKET_SIZE;
+			return buf;
+		}
+	}
+}
+
+void smsspi_common_transfer_msg(struct _spi_dev *dev, struct _spi_msg
*txmsg,
+				int padding_allowed)
+{
+	int len, bytes_to_transfer;
+	unsigned long tx_phy_addr;
+	int missing_bytes, tx_bytes;
+	int offset, unused_bytes;
+	int align_block;
+	char *txbuf;
+	struct _rx_buffer_st *buf, *tmp_buf;
+
+	len = 0;
+	if (!dev->cb.transfer_data_cb) {
+		PRN_ERR((TXT
+		("function called while module is not initialized.\n")));
+		return;
+	}
+	if (txmsg == 0) {
+		bytes_to_transfer = SPI_PACKET_SIZE;
+		txbuf = 0;
+		tx_phy_addr = 0;
+		tx_bytes = 0;
+	} else {
+		tx_bytes = txmsg->len;
+		if (padding_allowed)
+			bytes_to_transfer =
+			    (((tx_bytes + SPI_PACKET_SIZE -
+			       1) >> SPI_PACKET_SIZE_BITS) <<
+			     SPI_PACKET_SIZE_BITS);
+		else
+			bytes_to_transfer = (((tx_bytes + 3) >> 2) << 2);
+		txbuf = txmsg->buf;
+		tx_phy_addr = txmsg->buf_phy_addr;
+	}
+	offset = 0;
+	unused_bytes = 0;
+	buf =
+	    dev->cb.allocate_rx_buf(dev->context,
+				    RX_PACKET_SIZE + SPI_PACKET_SIZE*2 );
+	if (!buf) {
+		PRN_ERR((TXT("Failed to allocate RX buffer.\n")));
+		return;
+	}
+	while (bytes_to_transfer || unused_bytes) {
+		if ((unused_bytes <= 0) && (bytes_to_transfer > 0)) {
+			len = min(bytes_to_transfer, RX_PACKET_SIZE);
+			PRN_DBG((TXT("transfering block of %d bytes\n"), len));
+			dev->cb.transfer_data_cb(dev->phy_context,
+					(unsigned char *)txbuf,
+					tx_phy_addr,
+					(unsigned char *)buf->ptr + offset,
+					buf->phy_addr + offset, len);
+		}
+
+		tmp_buf =
+		    smsspi_common_find_msg(dev, buf, offset, len,
+					   &unused_bytes, &missing_bytes);
+		if (bytes_to_transfer)
+			bytes_to_transfer -= len;
+
+		if (tx_bytes)
+			tx_bytes -= len;
+
+		if (missing_bytes)
+			offset += len;
+
+		if (unused_bytes) {
+			/* In this case tmp_buf is a new buffer allocated
+			 * in smsspi_common_find_msg
+			 * and it already contains the unused bytes */
+			if (unused_bytes > 0) {
+				align_block =
+				    (((unused_bytes + SPI_PACKET_SIZE -
+				       1) >> SPI_PACKET_SIZE_BITS) <<
+				     SPI_PACKET_SIZE_BITS);
+				len = align_block;
+			}
+			offset = 0;
+			buf = tmp_buf;
+		}
+		if (tx_bytes <= 0) {
+			txbuf = 0;
+			tx_bytes = 0;
+		}
+		if (bytes_to_transfer < missing_bytes) {
+			bytes_to_transfer =
+			    (((missing_bytes + SPI_PACKET_SIZE -
+			       1) >> SPI_PACKET_SIZE_BITS) <<
+			     SPI_PACKET_SIZE_BITS);
+			PRN_DBG((TXT
+	("a message was found, adding bytes to transfer, txmsg %d, total %d
\n")
+			, tx_bytes, bytes_to_transfer));
+		}
+	}
+	dev->cb.free_rx_buf(dev->context, buf);
+}
+
+int smsspicommon_init(struct _spi_dev *dev, void *context, void
*phy_context,
+		      struct _spi_dev_cb_st *cb)
+{
+	PRN_DBG((TXT("entering.\n")));
+	if (cb->transfer_data_cb == 0 ||
+	    cb->msg_found_cb == 0 ||
+	    cb->allocate_rx_buf == 0 || cb->free_rx_buf == 0) {
+		PRN_ERR((TXT("Invalid input parameters of init routine.\n")));
+		return -1;
+	}
+	dev->context = context;
+	dev->phy_context = phy_context;
+	memcpy(&dev->cb, cb, sizeof(struct _spi_dev_cb_st));
+	dev->rxState = RxsWait_a5;
+	PRN_DBG((TXT("exiting.\n")));
+	return 0;
+}
diff --git a/drivers/media/dvb/siano/smsspicommon.h
b/drivers/media/dvb/siano/smsspicommon.h
new file mode 100644
index 0000000..cfcc6b1
--- /dev/null
+++ b/drivers/media/dvb/siano/smsspicommon.h
@@ -0,0 +1,96 @@
+/****************************************************************
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2008, Uri Shkolnik
+
+This program is free software: you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation, either version 2 of the License, or
+(at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+****************************************************************/
+#ifndef _SMS_SPI_COMMON_H_
+#define _SMS_SPI_COMMON_H_
+
+#define RX_PACKET_SIZE  		0x1000
+#define SPI_PACKET_SIZE_BITS		8
+#define SPI_PACKET_SIZE 		(1<<SPI_PACKET_SIZE_BITS)
+#define SPI_MAX_CTRL_MSG_SIZE		0x100
+
+#define MSG_HDR_FLAG_SPLIT_MSG_HDR	0x0004
+#define MSG_HDR_LEN			8
+
+enum _spi_rx_state {
+	RxsWait_a5 = 0,
+	RxsWait_5a,
+	RxsWait_e7,
+	RxsWait_7e,
+	RxsTypeH,
+	RxsTypeL,
+	RxsGetSrcId,
+	RxsGetDstId,
+	RxsGetLenL,
+	RxsGetLenH,
+	RxsFlagsL,
+	RxsFlagsH,
+	RxsData
+};
+
+struct _rx_buffer_st {
+	void *ptr;
+	unsigned long phy_addr;
+};
+
+struct _rx_packet_request {
+	struct _rx_buffer_st *msg_buf;
+	int msg_offset;
+	int msg_len;
+	int msg_flags;
+};
+
+struct _spi_dev_cb_st{
+	void (*transfer_data_cb) (void *context, unsigned char *, unsigned
long,
+				  unsigned char *, unsigned long, int);
+	void (*msg_found_cb) (void *, void *, int, int);
+	struct _rx_buffer_st *(*allocate_rx_buf) (void *, int);
+	void (*free_rx_buf) (void *, struct _rx_buffer_st *);
+};
+
+struct _spi_dev {
+	void *context;
+	void *phy_context;
+	struct _spi_dev_cb_st cb;
+	char *rxbuf;
+	enum _spi_rx_state rxState;
+	struct _rx_packet_request rxPacket;
+	char *internal_tx_buf;
+};
+
+struct _spi_msg {
+	char *buf;
+	unsigned long buf_phy_addr;
+	int len;
+};
+
+void smsspi_common_transfer_msg(struct _spi_dev *dev, struct _spi_msg
*txmsg,
+				int padding_allowed);
+int smsspicommon_init(struct _spi_dev *dev, void *contex, void
*phy_context,
+		      struct _spi_dev_cb_st *cb);
+
+#if defined HEXDUMP_DEBUG && defined SPIBUS_DEBUG
+/*! dump a human readable print of a binary buffer */
+void smsspi_khexdump(char *buf, int len);
+#else
+#define smsspi_khexdump(buf, len)
+#endif
+
+#endif /*_SMS_SPI_COMMON_H_*/
diff --git a/drivers/media/dvb/siano/smsspidrv.c
b/drivers/media/dvb/siano/smsspidrv.c
new file mode 100644
index 0000000..35cce42
--- /dev/null
+++ b/drivers/media/dvb/siano/smsspidrv.c
@@ -0,0 +1,455 @@
+/****************************************************************
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+ Copyright (C) 2006-2010, Erez Cohen
+
+This program is free software: you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation, either version 2 of the License, or
+(at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+****************************************************************/
+/*!
+	\file	spibusdrv.c
+
+	\brief	spi bus driver module
+
+	This file contains implementation of the spi bus driver.
+*/
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+
+#include "smscoreapi.h"
+#include "smsspicommon.h"
+#include "smsspiphy.h"
+
+#define SMS_INTR_PIN			19  /* 0 for nova sip, 26 for vega */
+#define TX_BUFFER_SIZE			0x200
+#define RX_BUFFER_SIZE			(0x1000 + SPI_PACKET_SIZE + 0x100)
+#define NUM_RX_BUFFERS			72
+
+struct _spi_device_st {
+	struct _spi_dev dev;
+	void *phy_dev;
+
+	struct completion write_operation;
+	struct list_head tx_queue;
+	int allocatedPackets;
+	int padding_allowed;
+	char *rxbuf;
+
+	struct smscore_device_t *coredev;
+	struct list_head txqueue;
+	char *txbuf;
+	dma_addr_t txbuf_phy_addr;
+};
+
+struct _smsspi_txmsg {
+	struct list_head node;	/*! internal management */
+	void *buffer;
+	size_t size;
+	int alignment;
+	int add_preamble;
+	struct completion completion;
+	void (*prewrite) (void *);
+	void (*postwrite) (void *);
+};
+
+struct _Msg {
+	struct SmsMsgHdr_ST hdr;
+	u32 data[3];
+};
+
+struct _spi_device_st *spi_dev;
+
+static void spi_worker_thread(void *arg);
+static DECLARE_WORK(spi_work_queue, (void *)spi_worker_thread);
+static u8 smsspi_preamble[] = { 0xa5, 0x5a, 0xe7, 0x7e };
+static u8 smsspi_startup[] = { 0, 0, 0xde, 0xc1, 0xa5, 0x51, 0xf1,
0xed };
+static u32 default_type = SMS_NOVA_B0;
+static u32 intr_pin = SMS_INTR_PIN;
+
+module_param(default_type, int, 0644);
+MODULE_PARM_DESC(default_type, "default board type.");
+
+module_param(intr_pin, int, 0644);
+MODULE_PARM_DESC(intr_pin, "interrupt pin number.");
+
+/******************************************/
+static void spi_worker_thread(void *arg)
+{
+	struct _spi_device_st *spi_device = spi_dev;
+	struct _smsspi_txmsg *msg = NULL;
+	struct _spi_msg txmsg;
+
+	sms_info("worker start\n");
+	do {
+		/* do we have a msg to write ? */
+		if (!msg && !list_empty(&spi_device->txqueue))
+			msg = (struct _smsspi_txmsg *)
+					list_entry(spi_device->txqueue.
+					next, struct _smsspi_txmsg, node);
+
+		if (msg) {
+			if (msg->add_preamble)
+			{
+				txmsg.len =
+				    min(msg->size + sizeof(smsspi_preamble),
+					(size_t) TX_BUFFER_SIZE);
+				txmsg.buf = spi_device->txbuf;
+				txmsg.buf_phy_addr = spi_device->txbuf_phy_addr;
+				memcpy(txmsg.buf, smsspi_preamble,
+				       sizeof(smsspi_preamble));
+				memcpy(&txmsg.buf[sizeof(smsspi_preamble)],
+				       msg->buffer,
+				       txmsg.len - sizeof(smsspi_preamble));
+				msg->add_preamble = 0;
+				msg->buffer +=
+				    txmsg.len - sizeof(smsspi_preamble);
+				msg->size -=
+				    txmsg.len - sizeof(smsspi_preamble);
+				/* zero out the rest of aligned buffer */
+				memset(&txmsg.buf[txmsg.len], 0,
+				       TX_BUFFER_SIZE - txmsg.len);
+				smsspi_common_transfer_msg(&spi_device->dev,
+							   &txmsg, 1);
+			} else {
+				txmsg.len =
+				    min(msg->size, (size_t) TX_BUFFER_SIZE);
+				txmsg.buf = spi_device->txbuf;
+				txmsg.buf_phy_addr = spi_device->txbuf_phy_addr;
+				memcpy(txmsg.buf, msg->buffer, txmsg.len);
+
+				msg->buffer += txmsg.len;
+				msg->size -= txmsg.len;
+				/* zero out the rest of aligned buffer */
+				memset(&txmsg.buf[txmsg.len], 0,
+				       TX_BUFFER_SIZE - txmsg.len);
+				smsspi_common_transfer_msg(&spi_device->dev,
+							   &txmsg, 0);
+			}
+
+		} else {
+			smsspi_common_transfer_msg(&spi_device->dev, NULL, 1);
+		}
+
+		/* if there was write, have we finished ? */
+		if (msg && !msg->size) {
+			/* call postwrite call back */
+			if (msg->postwrite)
+				msg->postwrite(spi_device);
+
+			list_del(&msg->node);
+			complete(&msg->completion);
+			msg = NULL;
+		}
+		/* if there was read, did we read anything ? */
+
+	} while (!list_empty(&spi_device->txqueue) || msg);
+
+	sms_info("worker end\n");
+
+}
+
+static void msg_found(void *context, void *buf, int offset, int len)
+{
+	struct _spi_device_st *spi_device = (struct _spi_device_st *) context;
+	struct smscore_buffer_t *cb =
+	    (struct smscore_buffer_t
+	     *)(container_of(buf, struct smscore_buffer_t, p));
+
+	sms_info("entering\n");
+	cb->offset = offset;
+	cb->size = len;
+	/* sms_err ("buffer %p is sent back to core databuf=%p,
+		offset=%d.\n", cb, cb->p, cb->offset); */
+	smscore_onresponse(spi_device->coredev, cb);
+
+	sms_info("exiting\n");
+
+}
+
+static void smsspi_int_handler(void *context)
+{
+	sms_info("interrupt\n");
+	PREPARE_WORK(&spi_work_queue, (void *)spi_worker_thread);
+	schedule_work(&spi_work_queue);
+}
+
+static int smsspi_queue_message_and_wait(struct _spi_device_st
*spi_device,
+					 struct _smsspi_txmsg *msg)
+{
+	init_completion(&msg->completion);
+	list_add_tail(&msg->node, &spi_device->txqueue);
+	schedule_work(&spi_work_queue);
+	wait_for_completion(&msg->completion);
+
+	return 0;
+}
+
+static int smsspi_preload(void *context)
+{
+	struct _smsspi_txmsg msg;
+	struct _spi_device_st *spi_device = (struct _spi_device_st *) context;
+	struct _Msg Msg = {
+		{
+		MSG_SMS_SPI_INT_LINE_SET_REQ, 0, HIF_TASK,
+			sizeof(struct _Msg), 0}, {
+		0, intr_pin, 0}
+	};
+	int rc;
+
+	sms_err("preparing for download\n");
+	prepareForFWDnl(spi_device->phy_dev);
+	sms_err("Sending SPI init sequence\n");
+	msg.buffer = smsspi_startup;
+	msg.size = sizeof(smsspi_startup);
+	msg.alignment = 4;
+	msg.add_preamble = 0;
+	msg.prewrite = NULL;	/* smsspiphy_reduce_clock; */
+	msg.postwrite = NULL;   /* smsspiphy_restore_clock; */
+
+	rc = smsspi_queue_message_and_wait(context, &msg);
+	if (rc < 0) {
+		sms_err("smsspi_queue_message_and_wait error, rc = %d\n", rc);
+		return rc;
+	}
+
+	sms_debug("sending MSG_SMS_SPI_INT_LINE_SET_REQ");
+	sms_info("Sending SPI Set Interrupt command sequence\n");
+	msg.buffer = &Msg;
+	msg.size = sizeof(Msg);
+	msg.alignment = SPI_PACKET_SIZE;
+	msg.add_preamble = 1;
+
+	rc = smsspi_queue_message_and_wait(context, &msg);
+	if (rc < 0) {
+		sms_err("set interrupt line failed, rc = %d\n", rc);
+		return rc;
+	}
+
+	return rc;
+}
+
+static int smsspi_postload(void *context)
+{
+	struct _spi_device_st *spi_device = (struct _spi_device_st *) context;
+	int mode = smscore_registry_getmode(spi_device->coredev->devpath);
+	if ( (mode != DEVICE_MODE_ISDBT) &&
+	     (mode != DEVICE_MODE_ISDBT_BDA) ) {
+		fwDnlComplete(spi_device->phy_dev, 0);
+		
+	}
+	
+	return 0;
+}
+
+static int smsspi_write(void *context, void *txbuf, size_t len)
+{
+	struct _smsspi_txmsg msg;
+	msg.buffer = txbuf;
+	msg.size = len;
+	msg.prewrite = NULL;
+	msg.postwrite = NULL;
+	if (len > 0x1000) {
+		/* The FW is the only long message. Do not add preamble,
+		and do not padd it */
+		msg.alignment = 4;
+		msg.add_preamble = 0;
+		msg.prewrite = smschipreset;
+	} else {
+		msg.alignment = SPI_PACKET_SIZE;
+		msg.add_preamble = 1;
+	}
+	sms_info("Writing message to  SPI.\n");
+	sms_info("msg hdr: 0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x.\n",
+	       ((u8 *) txbuf)[0], ((u8 *) txbuf)[1], ((u8 *) txbuf)[2],
+	       ((u8 *) txbuf)[3], ((u8 *) txbuf)[4], ((u8 *) txbuf)[5],
+	       ((u8 *) txbuf)[6], ((u8 *) txbuf)[7]);
+	return smsspi_queue_message_and_wait(context, &msg);
+}
+
+struct _rx_buffer_st *allocate_rx_buf(void *context, int size)
+{
+	struct smscore_buffer_t *buf;
+	struct _spi_device_st *spi_device = (struct _spi_device_st *) context;
+	if (size > RX_BUFFER_SIZE) {
+		sms_err("Requested size is bigger than max buffer size.\n");
+		return NULL;
+	}
+	buf = smscore_getbuffer(spi_device->coredev);
+	sms_info("Recieved Rx buf %p physical 0x%x (contained in %p)\n",
buf->p,
+	       buf->phys, buf);
+
+	/* note: this is not mistake! the rx_buffer_st is identical to part of
+	   smscore_buffer_t and we return the address of the start of the
+	   identical part */
+	return (struct _rx_buffer_st *) &buf->p;
+}
+
+static void free_rx_buf(void *context, struct _rx_buffer_st *buf)
+{
+	struct _spi_device_st *spi_device = (struct _spi_device_st *) context;
+	struct smscore_buffer_t *cb =
+	    (struct smscore_buffer_t
+	     *)(container_of(((void *)buf), struct smscore_buffer_t, p));
+	sms_info("buffer %p is released.\n", cb);
+	smscore_putbuffer(spi_device->coredev, cb);
+}
+
+/*! Release device STUB
+
+\param[in]	dev:		device control block
+\return		void
+*/
+static void smsspi_release(struct device *dev)
+{
+	sms_info("nothing to do\n");
+	/* Nothing to release */
+}
+
+static struct platform_device smsspi_device = {
+	.name = "smsspi",
+	.id = 1,
+	.dev = {
+		.release = smsspi_release,
+		},
+};
+
+int smsspi_register(void)
+{
+	struct smsdevice_params_t params;
+	int ret;
+	struct _spi_device_st *spi_device;
+	struct _spi_dev_cb_st common_cb;
+
+	sms_info("entering \n");
+
+	spi_device =
+	    kmalloc(sizeof(struct _spi_device_st), GFP_KERNEL);
+	spi_dev = spi_device;
+
+	INIT_LIST_HEAD(&spi_device->txqueue);
+
+	ret = platform_device_register(&smsspi_device);
+	if (ret < 0) {
+		sms_err("platform_device_register failed\n");
+		return ret;
+	}
+
+	spi_device->txbuf =
+	    dma_alloc_coherent(NULL, TX_BUFFER_SIZE,
+			       &spi_device->txbuf_phy_addr,
+			       GFP_KERNEL | GFP_DMA);
+	if (!spi_device->txbuf) {
+		printk(KERN_INFO "%s dma_alloc_coherent(...) failed\n",
+		       __func__);
+		ret = -ENOMEM;
+		goto txbuf_error;
+	}
+
+	spi_device->phy_dev =
+	    smsspiphy_init(NULL, smsspi_int_handler, spi_device);
+	if (spi_device->phy_dev == 0) {
+		printk(KERN_INFO "%s smsspiphy_init(...) failed\n", __func__);
+		goto phy_error;
+	}
+
+	common_cb.allocate_rx_buf = allocate_rx_buf;
+	common_cb.free_rx_buf = free_rx_buf;
+	common_cb.msg_found_cb = msg_found;
+	common_cb.transfer_data_cb = smsspibus_xfer;
+
+	ret =
+	    smsspicommon_init(&spi_device->dev, spi_device,
spi_device->phy_dev,
+			      &common_cb);
+	if (ret) {
+		printk(KERN_INFO "%s smsspiphy_init(...) failed\n", __func__);
+		goto common_error;
+	}
+
+	/* register in smscore */
+	memset(&params, 0, sizeof(params));
+	params.context = spi_device;
+	params.device = &smsspi_device.dev;
+	params.buffer_size = RX_BUFFER_SIZE;
+	params.num_buffers = NUM_RX_BUFFERS;
+	params.flags = SMS_DEVICE_NOT_READY;
+	params.sendrequest_handler = smsspi_write;
+	strcpy(params.devpath, "spi");
+	params.device_type = default_type;
+
+	params.flags =
+	    SMS_DEVICE_FAMILY2 | SMS_DEVICE_NOT_READY;
+	params.preload_handler = smsspi_preload;
+	params.postload_handler = smsspi_postload;
+	sms_info ("registering spi device type %d",params.device_type); 
+	ret = smscore_register_device(&params, &spi_device->coredev);
+	if (ret < 0) {
+		printk(KERN_INFO "%s smscore_register_device(...) failed\n",
+		       __func__);
+		goto reg_device_error;
+	}
+
+	ret = smscore_start_device(spi_device->coredev);
+	if (ret < 0) {
+		printk(KERN_INFO "%s smscore_start_device(...) failed\n",
+		       __func__);
+		goto start_device_error;
+	}
+
+	sms_info("exiting\n");
+	return 0;
+
+start_device_error:
+	smscore_unregister_device(spi_device->coredev);
+
+reg_device_error:
+
+common_error:
+	smsspiphy_deinit(spi_device->phy_dev);
+
+phy_error:
+	dma_free_coherent(NULL, TX_BUFFER_SIZE, spi_device->txbuf,
+			  spi_device->txbuf_phy_addr);
+
+txbuf_error:
+	platform_device_unregister(&smsspi_device);
+
+	sms_info("exiting error %d\n", ret);
+
+	return ret;
+}
+
+void smsspi_unregister(void)
+{
+	struct _spi_device_st *spi_device = spi_dev;
+	sms_info("entering\n");
+
+	/* stop interrupts */
+	smsspiphy_deinit(spi_device->phy_dev);
+	smscore_unregister_device(spi_device->coredev);
+
+	dma_free_coherent(NULL, TX_BUFFER_SIZE, spi_device->txbuf,
+			  spi_device->txbuf_phy_addr);
+
+	platform_device_unregister(&smsspi_device);
+	sms_info("exiting\n");
+}
diff --git a/drivers/media/dvb/siano/smsspiphy.c
b/drivers/media/dvb/siano/smsspiphy.c
new file mode 100644
index 0000000..9b8cb14
--- /dev/null
+++ b/drivers/media/dvb/siano/smsspiphy.c
@@ -0,0 +1,246 @@
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/spi/spi.h>
+#include <linux/dma-mapping.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+//#include <linux/timer.h>
+#include "smscoreapi.h"
+
+//#include <../arch/arm/mach-omap2/mux.h>
+#include <linux/gpio.h>
+
+#define MAX_SPEED_DURING_DOWNLOAD	6000000
+#define MAX_SPEED_DURING_WORK		6000000	
+#define SPI_PACKET_SIZE 		256	
+
+int spi_max_speed = MAX_SPEED_DURING_WORK;
+
+struct sms_spi {
+	struct spi_device	*spi_dev;
+	char			*zero_txbuf;
+	dma_addr_t 		zero_txbuf_phy_addr;
+	int 			bus_speed;
+	void (*interruptHandler) (void *);
+	void			*intr_context;
+//	struct timer_list 	timer;
+//	int			timer_interval;
+};
+
+/*!
+invert the endianness of a single 32it integer
+
+\param[in]		u: word to invert
+
+\return		the inverted word
+*/
+static inline u32 invert_bo(u32 u)
+{
+	return ((u & 0xff) << 24) | ((u & 0xff00) << 8) | ((u & 0xff0000) >>
8)
+		| ((u & 0xff000000) >> 24);
+}
+
+/*!
+invert the endianness of a data buffer
+
+\param[in]		buf: buffer to invert
+\param[in]		len: buffer length
+
+\return		the inverted word
+*/
+
+
+static int invert_endianness(char *buf, int len)
+{
+	int i;
+	u32 *ptr = (u32 *) buf;
+
+	len = (len + 3) / 4;
+	for (i = 0; i < len; i++, ptr++)
+	{
+		*ptr = invert_bo(*ptr);
+	}
+	
+	return 4 * ((len + 3) & (~3));
+}
+
+static irqreturn_t spibus_interrupt(int irq, void *context)
+{
+	struct sms_spi *sms_spi = (struct sms_spi *)context;
+	if (sms_spi->interruptHandler)
+		sms_spi->interruptHandler(sms_spi->intr_context);
+	return IRQ_HANDLED;
+
+}
+
+//void timer_function(unsigned long context)
+//{
+//	struct sms_spi *sms_spi = (struct sms_spi *)context;
+//	spibus_interrupt(0, sms_spi);
+//	  
+//	mod_timer(&sms_spi->timer, jiffies + sms_spi->timer_interval);
+//}
+
+void prepareForFWDnl(void *context)
+{
+	/*Reduce clock rate for FW download*/
+	struct sms_spi *sms_spi = (struct sms_spi *)context;
+	sms_spi->bus_speed = MAX_SPEED_DURING_DOWNLOAD;
+	sms_err ("Start FW download.");
+	msleep(100);
+	sms_err ("done sleeping.");
+}
+
+void fwDnlComplete(void *context, int App)
+{
+	/*Set clock rate for working mode*/
+	struct sms_spi *sms_spi = (struct sms_spi *)context;
+	sms_spi->bus_speed = spi_max_speed;
+	sms_err ("FW download complete.");
+	msleep(100);
+}
+
+
+void smsspibus_xfer(void *context, unsigned char *txbuf,
+		    unsigned long txbuf_phy_addr, unsigned char *rxbuf,
+		    unsigned long rxbuf_phy_addr, int len)
+{
+	struct sms_spi *sms_spi = (struct sms_spi *)context;
+	struct spi_message msg;
+	struct spi_transfer xfer = {
+		.tx_buf = txbuf,
+		.rx_buf = rxbuf,
+		.len = len,
+		.tx_dma = txbuf_phy_addr,
+		.rx_dma = rxbuf_phy_addr,
+		.cs_change = 0,
+		.speed_hz = sms_spi->bus_speed,
+		.bits_per_word = 0,
+	};
+
+	if (txbuf)
+	{
+		invert_endianness(txbuf, len);
+	}
+
+
+	if (!txbuf)
+	{
+		xfer.tx_buf = sms_spi->zero_txbuf;
+		xfer.tx_dma = sms_spi->zero_txbuf_phy_addr;
+		
+	}
+
+	spi_message_init(&msg);
+	msg.is_dma_mapped = 1;
+	spi_message_add_tail(&xfer, &msg);
+	spi_sync (sms_spi->spi_dev, &msg);
+	invert_endianness(rxbuf, len);
+
+}
+
+
+
+
+
+
+void *smsspiphy_init(void *context, void (*smsspi_interruptHandler)
(void *),
+		     void *intr_context)
+{
+	int ret;
+	struct sms_spi *sms_spi; 
+	struct spi_device *sms_device;
+
+	struct spi_master *master = spi_busnum_to_master(3);
+	struct spi_board_info sms_chip = {
+		.modalias = "SmsSPI",
+		.platform_data 	= NULL,
+		.controller_data = NULL,
+		.irq		= 0, /*OMAP_GPIO_IRQ(4)*/
+		.max_speed_hz	= spi_max_speed,
+		.bus_num	= 3,
+		.chip_select 	= 1,
+		.mode		= SPI_MODE_0,
+	};
+
+
+	printk(KERN_INFO "sms_debug = %d\n", sms_debug);
+
+
+	sms_device = spi_new_device(master, &sms_chip);	
+	if (!sms_device)
+	{
+		sms_err("Failed on allocating new SPI device for SMS");
+		return NULL;
+	}
+	sms_device->bits_per_word = 32;
+	if (spi_setup(sms_device))
+	{
+		sms_err("SMS device setup failed");
+		return NULL;
+	}
+
+	sms_spi = kzalloc(sizeof(struct sms_spi), GFP_KERNEL);
+
+	sms_spi->zero_txbuf =  dma_alloc_coherent(NULL, SPI_PACKET_SIZE,
+			       &sms_spi->zero_txbuf_phy_addr,
+			       GFP_KERNEL | GFP_DMA);
+	if (!sms_spi->zero_txbuf) {
+		sms_err ("dma_alloc_coherent(...) failed\n");
+		kfree (sms_spi);
+		return NULL;
+	}
+	memset (sms_spi->zero_txbuf, 0, SPI_PACKET_SIZE);
+//	setup_timer(&sms_spi->timer, timer_function, (unsigned
long)sms_spi);
+	sms_spi->interruptHandler = smsspi_interruptHandler;
+	sms_spi->intr_context = intr_context;
+
+
+
+
+
+
+
+	if ((gpio_request(135, "SMSSPI") == 0) &&
+	    (gpio_direction_input(135) == 0)) {
+		gpio_export(135, 0);
+	}
+
+
+	set_irq_type(gpio_to_irq(135), IRQ_TYPE_EDGE_FALLING);
+	ret = request_irq(gpio_to_irq(135), spibus_interrupt,
IRQF_TRIGGER_FALLING, "SMSSPI", sms_spi);
+	if (ret) {
+		sms_err("Could not get interrupt for SMS device. status =%d\n", ret);
+		return NULL;
+	}
+
+
+
+
+
+
+
+//	sms_spi->timer_interval = 1000;
+	sms_spi->spi_dev = sms_device;
+	sms_spi->bus_speed = spi_max_speed;
+	sms_err ("after init sms_spi=0x%x, spi_dev = 0x%x", (int)sms_spi,
(int)sms_spi->spi_dev);
+
+	return sms_spi;
+}
+
+void smsspiphy_deinit(void *context)
+{
+	struct sms_spi *sms_spi = (struct sms_spi *)context;
+	printk(KERN_INFO "smsspiphy_deinit\n");
+//	del_timer(&sms_spi->timer);
+	kfree (sms_spi);
+
+}
+
+void smschipreset(void *context)
+{
+	sms_err ("sms chip reset");
+}
+
+
+
diff --git a/drivers/media/dvb/siano/smsspiphy.h
b/drivers/media/dvb/siano/smsspiphy.h
new file mode 100644
index 0000000..7ee2a40
--- /dev/null
+++ b/drivers/media/dvb/siano/smsspiphy.h
@@ -0,0 +1,36 @@
+/****************************************************************
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2008, Uri Shkolnik
+
+This program is free software: you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation, either version 2 of the License, or
+(at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+****************************************************************/
+
+#ifndef __SMS_SPI_PHY_H__
+#define __SMS_SPI_PHY_H__
+
+void smsspibus_xfer(void *context, unsigned char *txbuf,
+		    unsigned long txbuf_phy_addr, unsigned char *rxbuf,
+		    unsigned long rxbuf_phy_addr, int len);
+void *smsspiphy_init(void *context, void (*smsspi_interruptHandler)
(void *),
+		     void *intr_context);
+void smsspiphy_deinit(void *context);
+void smschipreset(void *context);
+void WriteFWtoStellar(void *pSpiPhy, unsigned char *pFW, unsigned long
Len);
+void prepareForFWDnl(void *pSpiPhy);
+void fwDnlComplete(void *context, int App);
+
+#endif /* __SMS_SPI_PHY_H__ */
-- 
1.7.4.1


>From 81a55103537fb6df2b487819aa9a5af28a5c4bd2 Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Wed, 14 Sep 2011 13:33:20 +0300
Subject: [PATCH 03/21] Add smsspi driver to support Siano SPI connected
device using SPI generic driver

	modified:   drivers/media/dvb/siano/Makefile
	modified:   drivers/media/dvb/siano/smscoreapi.c
	new file:   drivers/media/dvb/siano/smsdbg_prn.h
	modified:   drivers/media/dvb/siano/smsspidrv.c
	modified:   drivers/media/dvb/siano/smsspiphy.c
---
 drivers/media/dvb/siano/Makefile     |    2 +
 drivers/media/dvb/siano/smscoreapi.c |    2 +-
 drivers/media/dvb/siano/smsdbg_prn.h |   56
++++++++++++++++++++++++++++++++++
 drivers/media/dvb/siano/smsspidrv.c  |   33 +++++++++++++++-----
 drivers/media/dvb/siano/smsspiphy.c  |   40 ++++++++----------------
 5 files changed, 97 insertions(+), 36 deletions(-)
 create mode 100644 drivers/media/dvb/siano/smsdbg_prn.h

diff --git a/drivers/media/dvb/siano/Makefile
b/drivers/media/dvb/siano/Makefile
index c54140b..affaf01 100644
--- a/drivers/media/dvb/siano/Makefile
+++ b/drivers/media/dvb/siano/Makefile
@@ -1,9 +1,11 @@
 
 smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o smsir.o
+smsspi-objs := smsspicommon.o smsspidrv.o smsspiphy.o
 
 obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
 obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
 obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o
+obj-$(CONFIG_SMS_SPI_DRV) += smsspi.o
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 
diff --git a/drivers/media/dvb/siano/smscoreapi.c
b/drivers/media/dvb/siano/smscoreapi.c
index 78765ed..239f453 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -39,7 +39,7 @@
 #include "smsir.h"
 #include "smsendian.h"
 
-static int sms_dbg;
+int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
diff --git a/drivers/media/dvb/siano/smsdbg_prn.h
b/drivers/media/dvb/siano/smsdbg_prn.h
new file mode 100644
index 0000000..ea157da
--- /dev/null
+++ b/drivers/media/dvb/siano/smsdbg_prn.h
@@ -0,0 +1,56 @@
+/****************************************************************
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2008, Uri Shkolnik
+
+This program is free software: you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation, either version 2 of the License, or
+(at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+****************************************************************/
+
+#ifndef _SMS_DBG_H_
+#define _SMS_DBG_H_
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+/************************************************************************/
+/* Debug Zones definitions.
*/
+/************************************************************************/
+#undef PERROR
+#  define PERROR(fmt, args...) \
+	printk(KERN_ERR "spibus error: line %d- %s(): " fmt, __LINE__,\
+	  __func__, ## args)
+#undef PWARNING
+#  define PWARNING(fmt, args...) \
+	printk(KERN_WARNING "spibus warning: line %d- %s(): " fmt, __LINE__,
\
+	__func__, ## args)
+
+/* the debug macro - conditional compilation from the makefile */
+#undef PDEBUG			/* undef it, just in case */
+#ifdef SPIBUS_DEBUG
+#  define PDEBUG(fmt, args...) \
+	printk(KERN_DEBUG "spibus: line %d- %s(): " fmt, __LINE__, \
+	 __func__, ## args)
+#else
+#  define PDEBUG(fmt, args...)	/* not debugging: nothing */
+#endif
+
+/* The following defines are used for printing and
+are mandatory for compilation. */
+#define TXT(str) str
+#define PRN_DBG(str) PDEBUG str
+#define PRN_ERR(str) PERROR str
+
+#endif /*_SMS_DBG_H_*/
diff --git a/drivers/media/dvb/siano/smsspidrv.c
b/drivers/media/dvb/siano/smsspidrv.c
index 35cce42..fa80c1a 100644
--- a/drivers/media/dvb/siano/smsspidrv.c
+++ b/drivers/media/dvb/siano/smsspidrv.c
@@ -79,18 +79,27 @@ struct _Msg {
 
 struct _spi_device_st *spi_dev;
 
+int sms_dbg;
 static void spi_worker_thread(void *arg);
 static DECLARE_WORK(spi_work_queue, (void *)spi_worker_thread);
 static u8 smsspi_preamble[] = { 0xa5, 0x5a, 0xe7, 0x7e };
 static u8 smsspi_startup[] = { 0, 0, 0xde, 0xc1, 0xa5, 0x51, 0xf1,
0xed };
+static u32 sms_intr_pin = SMS_INTR_PIN;
+extern u32 host_intr_pin;
+
 static u32 default_type = SMS_NOVA_B0;
-static u32 intr_pin = SMS_INTR_PIN;
 
-module_param(default_type, int, 0644);
-MODULE_PARM_DESC(default_type, "default board type.");
+module_param_named(debug, sms_dbg, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
+
+module_param(default_type, int, S_IRUGO);
+MODULE_PARM_DESC(default_type, "default SMS device type.");
+
+module_param(sms_intr_pin, int, S_IRUGO);
+MODULE_PARM_DESC(sms_intr_pin, "interrupt pin number used by SMS chip
for interrupting host.");
 
-module_param(intr_pin, int, 0644);
-MODULE_PARM_DESC(intr_pin, "interrupt pin number.");
+module_param(host_intr_pin, int, S_IRUGO);
+MODULE_PARM_DESC(host_intr_pin, "interrupt pin number used by Host to
be interrupted by SMS.");
 
 /******************************************/
 static void spi_worker_thread(void *arg)
@@ -212,7 +221,7 @@ static int smsspi_preload(void *context)
 		{
 		MSG_SMS_SPI_INT_LINE_SET_REQ, 0, HIF_TASK,
 			sizeof(struct _Msg), 0}, {
-		0, intr_pin, 0}
+		0, sms_intr_pin, 0}
 	};
 	int rc;
 
@@ -333,7 +342,7 @@ static struct platform_device smsspi_device = {
 		},
 };
 
-int smsspi_register(void)
+static int __init smsspi_module_init(void)
 {
 	struct smsdevice_params_t params;
 	int ret;
@@ -438,7 +447,7 @@ txbuf_error:
 	return ret;
 }
 
-void smsspi_unregister(void)
+static void __exit smsspi_module_exit(void)
 {
 	struct _spi_device_st *spi_device = spi_dev;
 	sms_info("entering\n");
@@ -453,3 +462,11 @@ void smsspi_unregister(void)
 	platform_device_unregister(&smsspi_device);
 	sms_info("exiting\n");
 }
+
+
+module_init(smsspi_module_init);
+module_exit(smsspi_module_exit);
+
+MODULE_DESCRIPTION("Siano MDTV SPI device driver");
+MODULE_AUTHOR("Siano Mobile Silicon, Inc. (doronc@siano-ms.com)");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/siano/smsspiphy.c
b/drivers/media/dvb/siano/smsspiphy.c
index 9b8cb14..708ee06 100644
--- a/drivers/media/dvb/siano/smsspiphy.c
+++ b/drivers/media/dvb/siano/smsspiphy.c
@@ -4,6 +4,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+
 //#include <linux/timer.h>
 #include "smscoreapi.h"
 
@@ -13,6 +14,12 @@
 #define MAX_SPEED_DURING_DOWNLOAD	6000000
 #define MAX_SPEED_DURING_WORK		6000000	
 #define SPI_PACKET_SIZE 		256	
+extern int sms_dbg;
+
+int sms_spi_interrupt = 135;
+module_param_named(debug, sms_spi_interrupt, int, 0644);
+MODULE_PARM_DESC(debug, "set interrupt gpio pin for spi device.");
+
 
 int spi_max_speed = MAX_SPEED_DURING_WORK;
 
@@ -23,8 +30,6 @@ struct sms_spi {
 	int 			bus_speed;
 	void (*interruptHandler) (void *);
 	void			*intr_context;
-//	struct timer_list 	timer;
-//	int			timer_interval;
 };
 
 /*!
@@ -141,9 +146,6 @@ void smsspibus_xfer(void *context, unsigned char
*txbuf,
 
 
 
-
-
-
 void *smsspiphy_init(void *context, void (*smsspi_interruptHandler)
(void *),
 		     void *intr_context)
 {
@@ -163,9 +165,7 @@ void *smsspiphy_init(void *context, void
(*smsspi_interruptHandler) (void *),
 		.mode		= SPI_MODE_0,
 	};
 
-
-	printk(KERN_INFO "sms_debug = %d\n", sms_debug);
-
+	sms_err("sms_debug = %d\n", sms_dbg);
 
 	sms_device = spi_new_device(master, &sms_chip);	
 	if (!sms_device)
@@ -191,36 +191,22 @@ void *smsspiphy_init(void *context, void
(*smsspi_interruptHandler) (void *),
 		return NULL;
 	}
 	memset (sms_spi->zero_txbuf, 0, SPI_PACKET_SIZE);
-//	setup_timer(&sms_spi->timer, timer_function, (unsigned
long)sms_spi);
 	sms_spi->interruptHandler = smsspi_interruptHandler;
 	sms_spi->intr_context = intr_context;
 
 
-
-
-
-
-
-	if ((gpio_request(135, "SMSSPI") == 0) &&
-	    (gpio_direction_input(135) == 0)) {
-		gpio_export(135, 0);
+	if ((gpio_request(sms_spi_interrupt, "SMSSPI") == 0) &&
+	    (gpio_direction_input(sms_spi_interrupt) == 0)) {
+		gpio_export(sms_spi_interrupt, 0);
 	}
 
-
-	set_irq_type(gpio_to_irq(135), IRQ_TYPE_EDGE_FALLING);
-	ret = request_irq(gpio_to_irq(135), spibus_interrupt,
IRQF_TRIGGER_FALLING, "SMSSPI", sms_spi);
+	irq_set_irq_type(gpio_to_irq(sms_spi_interrupt),
IRQ_TYPE_EDGE_FALLING);
+	ret = request_irq(gpio_to_irq(sms_spi_interrupt), spibus_interrupt,
IRQF_TRIGGER_FALLING, "SMSSPI", sms_spi);
 	if (ret) {
 		sms_err("Could not get interrupt for SMS device. status =%d\n", ret);
 		return NULL;
 	}
 
-
-
-
-
-
-
-//	sms_spi->timer_interval = 1000;
 	sms_spi->spi_dev = sms_device;
 	sms_spi->bus_speed = spi_max_speed;
 	sms_err ("after init sms_spi=0x%x, spi_dev = 0x%x", (int)sms_spi,
(int)sms_spi->spi_dev);
-- 
1.7.4.1

