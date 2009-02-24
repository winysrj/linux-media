Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110812.mail.gq1.yahoo.com ([67.195.13.235]:23798 "HELO
	web110812.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755503AbZBXNqw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 08:46:52 -0500
Date: Tue, 24 Feb 2009 05:46:49 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
Reply-To: urishk@yahoo.com
Subject: [PATCH] Siano 10239 SMSSpiCommon unused bytes bugfix
To: linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho <mchehab@infradead.org>,
	linuxtv-commits@linuxtv.org, linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <962975.6223.qm@web110812.mail.gq1.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1235483353 -7200
# Node ID ba9020b165e75b80e8c7b499e8068741982c44f6
# Parent  3caff6dae0753d2adb581b7ef5e309a1954820b2
Fixed use of freed memory in smsspicommon

From: Uri Shkolnik <uris@siano-ms.com>

Moved the handling of "unused bytes" before the reporting of message found.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 3caff6dae075 -r ba9020b165e7 linux/drivers/media/dvb/siano/smsspicommon.c
--- a/linux/drivers/media/dvb/siano/smsspicommon.c	Sun Feb 08 17:28:37 2009 +0200
+++ b/linux/drivers/media/dvb/siano/smsspicommon.c	Tue Feb 24 15:49:13 2009 +0200
@@ -21,18 +21,53 @@ along with this program.  If not, see <h
 #include "smsspicommon.h"
 #include "smsdbg_prn.h"
 
-static int smsspi_common_find_msg(struct _spi_dev *dev,
+static struct _rx_buffer_st *smsspi_handle_unused_bytes_buf(
+		struct _spi_dev *dev,
 		struct _rx_buffer_st *buf, int offset, int len,
-		int *unused_bytes)
+		int unused_bytes)
 {
-	int i, missing_bytes;
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
+static struct _rx_buffer_st *smsspi_common_find_msg(struct _spi_dev *dev,
+		struct _rx_buffer_st *buf, int offset, int len,
+		int *unused_bytes, int *missing_bytes)
+{
+	int i;
 	int recieved_bytes, padded_msg_len;
 	int align_fix;
 	int msg_offset;
-	unsigned char *ptr = (unsigned char *)buf->ptr + offset;
+	char *ptr = (char *)buf->ptr + offset;
+	if (unused_bytes == NULL || missing_bytes == NULL)
+		return NULL;
+
+	*missing_bytes = 0;
+	*unused_bytes = 0;
 
 	PRN_DBG((TXT("entering with %d bytes.\n"), len));
-	missing_bytes = 0;
 	for (i = 0; i < len; i++, ptr++) {
 		switch (dev->rxState) {
 		case RxsWait_a5:
@@ -104,7 +139,9 @@ static int smsspi_common_find_msg(struct
 			    SPI_PACKET_SIZE_BITS;
 			if (recieved_bytes < padded_msg_len) {
 				*unused_bytes = 0;
-				return padded_msg_len - recieved_bytes;
+				*missing_bytes = padded_msg_len -
+						recieved_bytes;
+				return buf;
 			}
 			dev->rxState = RxsWait_a5;
 			if (dev->cb.msg_found_cb) {
@@ -114,10 +151,11 @@ static int smsspi_common_find_msg(struct
 					align_fix =
 					    (dev->rxPacket.
 					     msg_flags >> 8) & 0x3;
-	/* The FW aligned the message data therefore -
-	* alignment bytes should be thrown away.
-	* Throw the alignment bytes by moving the
-	* header ahead over the alignment bytes. */
+					/* The FW aligned the message data
+					therefore - alignment bytes should be
+					thrown away. Throw the alignment bytes
+					by moving the header ahead over the
+					alignment bytes. */
 					if (align_fix) {
 						int length;
 						ptr =
@@ -150,30 +188,41 @@ static int smsspi_common_find_msg(struct
 				("Msg found and sent to callback func.\n")));
 
 				/* force all messages to start on
-					4-byte boundary */
+				 * 4-byte boundary */
 				msg_offset = dev->rxPacket.msg_offset;
-				if (msg_offset & 0x3)	{
+				if (msg_offset & 0x3) {
 					msg_offset &= (~0x3);
 					memmove((unsigned char *)
-						(dev->rxPacket.msg_buf->ptr) +
-						msg_offset,
+						(dev->rxPacket.msg_buf->ptr)
+						+ msg_offset,
 						(unsigned char *)
-						(dev->rxPacket.msg_buf->ptr) +
-						dev->rxPacket.msg_offset,
+						(dev->rxPacket.msg_buf->ptr)
+						+ dev->rxPacket.msg_offset,
 						dev->rxPacket.msg_len -
 						align_fix);
 				}
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
 				dev->cb.msg_found_cb(dev->context,
 							 dev->rxPacket.msg_buf,
 							 msg_offset,
 							 dev->rxPacket.msg_len -
 							 align_fix);
-				*unused_bytes =
-				    len + offset - dev->rxPacket.msg_offset -
-				    dev->rxPacket.msg_len;
-				if (*unused_bytes == 0)
-					*unused_bytes = -1;
-				return 0;
+				*missing_bytes = 0;
+				return buf;
 			} else {
 				PRN_DBG((TXT
 		 ("Msg found but no callback. therefore - thrown away.\n")));
@@ -185,7 +234,8 @@ static int smsspi_common_find_msg(struct
 
 	if (dev->rxState == RxsWait_a5) {
 		*unused_bytes = 0;
-		return 0;
+		*missing_bytes = 0;
+		return buf;
 	} else {
 		/* Workaround to corner case: if the last byte of the buffer
 		is "a5" (first byte of the preamble), the host thinks it should
@@ -195,22 +245,28 @@ static int smsspi_common_find_msg(struct
 		if ((dev->rxState == RxsWait_5a) && (*(ptr - 2) == 0xa5)) {
 			dev->rxState = RxsWait_a5;
 			*unused_bytes = 0;
-			return 0;
+			*missing_bytes = 0;
+			return buf;
 		}
 
 		if (dev->rxPacket.msg_offset >= (SPI_PACKET_SIZE + 4))
 			/* adding 4 for the preamble. */
 		{		/*The packet will be copied to a new buffer
 				   and rescaned by the state machine */
+			struct _rx_buffer_st *tmp_buf = buf;
 			*unused_bytes = dev->rxState - RxsWait_a5;
+			tmp_buf = smsspi_handle_unused_bytes_buf(dev, buf,
+					offset, len, *unused_bytes);
 			dev->rxState = RxsWait_a5;
 			dev->cb.free_rx_buf(dev->context, buf);
-			return 0;
+			*missing_bytes = 0;
+			return tmp_buf;
 		} else {
 			/* report missing bytes and continue
 			   with message scan. */
 			*unused_bytes = 0;
-			return SPI_PACKET_SIZE;
+			*missing_bytes = SPI_PACKET_SIZE;
+			return buf;
 		}
 	}
 }
@@ -263,14 +319,15 @@ void smsspi_common_transfer_msg(struct _
 			len = min(bytes_to_transfer, RX_PACKET_SIZE);
 			PRN_DBG((TXT("transfering block of %d bytes\n"), len));
 			dev->cb.transfer_data_cb(dev->phy_context,
-				(unsigned char *)txbuf,
-				tx_phy_addr,
-				(unsigned char *)buf->ptr + offset,
-				buf->phy_addr + offset, len);
+					(unsigned char *)txbuf,
+					tx_phy_addr,
+					(unsigned char *)buf->ptr + offset,
+					buf->phy_addr + offset, len);
 		}
-		missing_bytes =
+
+		tmp_buf =
 		    smsspi_common_find_msg(dev, buf, offset, len,
-					   &unused_bytes);
+					   &unused_bytes, &missing_bytes);
 		if (bytes_to_transfer)
 			bytes_to_transfer -= len;
 
@@ -281,28 +338,14 @@ void smsspi_common_transfer_msg(struct _
 			offset += len;
 
 		if (unused_bytes) {
-			tmp_buf =
-			    dev->cb.allocate_rx_buf(dev->context,
-						    RX_PACKET_SIZE);
-			if (!tmp_buf) {
-				PRN_ERR((TXT
-					 ("Failed to allocate RX buffer.\n")));
-				return;
-			}
+			/* In this case tmp_buf is a new buffer allocated
+			 * in smsspi_common_find_msg
+			 * and it already contains the unused bytes */
 			if (unused_bytes > 0) {
-				/* Copy the remaining bytes to the end of
-				   alingment block (256 bytes) so next read
-				   will be alligned. */
 				align_block =
 				    (((unused_bytes + SPI_PACKET_SIZE -
 				       1) >> SPI_PACKET_SIZE_BITS) <<
 				     SPI_PACKET_SIZE_BITS);
-				memset(tmp_buf->ptr, 0,
-				       align_block - unused_bytes);
-				memcpy((char *)tmp_buf->ptr +
-				       (align_block - unused_bytes),
-				       (char *)buf->ptr + offset + len -
-				       unused_bytes, unused_bytes);
 				len = align_block;
 			}
 			offset = 0;



      
