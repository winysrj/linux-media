Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab0JUOJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 10:09:32 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9LE9WDF012373
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 10:09:32 -0400
Received: from pedra (vpn-225-164.phx2.redhat.com [10.3.225.164])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9LE9S5A022469
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 10:09:30 -0400
Date: Thu, 21 Oct 2010 12:07:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] mceusb: Improve parser to get codes sent
 together with IR RX data
Message-ID: <20101021120747.1aca4517@pedra>
In-Reply-To: <cover.1287669886.git.mchehab@redhat.com>
References: <cover.1287669886.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On cx231xx, sometimes, several control messages are sent together
with data. Improves the parser to also handle those cases.

For example:

[38777.211690] mceusb 7-6:1.0: rx data: 9f 14 01 9f 15 00 00 80  (length=8)
[38777.211696] mceusb 7-6:1.0: Got long-range receive sensor in use
[38777.211700] mceusb 7-6:1.0: Received pulse count is 0
[38777.211703] mceusb 7-6:1.0: IR data len = 0
[38777.211707] mceusb 7-6:1.0: New data. rem: 0x1f, cmd: 0x80

Before this patch, only the first message would be displayed, as the
parser would be stopping at "9f 14 01".

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index a726f63..609bf3d 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -343,99 +343,130 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	else
 		strcpy(inout, "Got\0");
 
-	cmd    = buf[idx] & 0xff;
-	subcmd = buf[idx + 1] & 0xff;
-	data1  = buf[idx + 2] & 0xff;
-	data2  = buf[idx + 3] & 0xff;
+	while (idx < len) {
+		cmd    = buf[idx] & 0xff;
+		subcmd = buf[idx + 1] & 0xff;
+		data1  = buf[idx + 2] & 0xff;
+		data2  = buf[idx + 3] & 0xff;
 
-	switch (cmd) {
-	case 0x00:
-		if (subcmd == 0xff && data1 == 0xaa)
-			dev_info(dev, "Device reset requested\n");
-		else
-			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
-				 cmd, subcmd);
-		break;
-	case 0xff:
-		switch (subcmd) {
-		case 0x0b:
-			if (len == 2)
-				dev_info(dev, "Get hw/sw rev?\n");
-			else
-				dev_info(dev, "hw/sw rev 0x%02x 0x%02x "
-					 "0x%02x 0x%02x\n", data1, data2,
-					 buf[idx + 4], buf[idx + 5]);
-			break;
-		case 0xaa:
-			dev_info(dev, "Device reset requested\n");
-			break;
-		case 0xfe:
-			dev_info(dev, "Previous command not supported\n");
-			break;
-		case 0x18:
-		case 0x1b:
-		default:
-			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
-				 cmd, subcmd);
-			break;
-		}
-		break;
-	case 0x9f:
-		switch (subcmd) {
-		case 0x03:
-			dev_info(dev, "Ping\n");
-			break;
-		case 0x04:
-			dev_info(dev, "Resp to 9f 05 of 0x%02x 0x%02x\n",
-				 data1, data2);
-			break;
-		case 0x06:
-			dev_info(dev, "%s carrier mode and freq of "
-				 "0x%02x 0x%02x\n", inout, data1, data2);
-			break;
-		case 0x07:
-			dev_info(dev, "Get carrier mode and freq\n");
-			break;
-		case 0x08:
-			dev_info(dev, "%s transmit blaster mask of 0x%02x\n",
-				 inout, data1);
-			break;
-		case 0x0c:
-			/* value is in units of 50us, so x*50/100 or x/2 ms */
-			dev_info(dev, "%s receive timeout of %d ms\n",
-				 inout, ((data1 << 8) | data2) / 2);
-			break;
-		case 0x0d:
-			dev_info(dev, "Get receive timeout\n");
-			break;
-		case 0x13:
-			dev_info(dev, "Get transmit blaster mask\n");
-			break;
-		case 0x14:
-			dev_info(dev, "%s %s-range receive sensor in use\n",
-				 inout, data1 == 0x02 ? "short" : "long");
-			break;
-		case 0x15:
-			if (len == 2)
-				dev_info(dev, "Get receive sensor\n");
+		/*
+		 * skip command/subcommand
+		 * The size of each package at the protocol depends
+		 * on the given command/subcommand
+		 */
+		idx += 2;
+
+		switch (cmd) {
+		case 0x00:
+			if (subcmd == 0xff && data1 == 0xaa)
+				dev_info(dev, "Device reset requested\n");
 			else
-				dev_info(dev, "Received pulse count is %d\n",
-					 ((data1 << 8) | data2));
+				dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
+					 cmd, subcmd);
+			idx = len;
+			break;
+		case 0xff:
+			switch (subcmd) {
+			case 0x0b:
+				if (len == 2)
+					dev_info(dev, "Get hw/sw rev?\n");
+				else
+					dev_info(dev, "hw/sw rev 0x%02x 0x%02x "
+						 "0x%02x 0x%02x\n", data1, data2,
+						 buf[idx + 4], buf[idx + 5]);
+				idx = len;
+				break;
+			case 0xaa:
+				dev_info(dev, "Device reset requested\n");
+				break;
+			case 0xfe:
+				dev_info(dev, "Previous command not supported\n");
+				break;
+			case 0x18:
+			case 0x1b:
+			default:
+				dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
+					 cmd, subcmd);
+				break;
+			}
+			idx = len;
+			break;
+		case 0x9f:
+			switch (subcmd) {
+			case 0x03:
+				dev_info(dev, "Ping\n");
+				break;
+			case 0x04:
+				dev_info(dev, "Resp to 9f 05 of 0x%02x 0x%02x\n",
+					 data1, data2);
+				idx += 2;
+				break;
+			case 0x06:
+				dev_info(dev, "%s carrier mode and freq of "
+					 "0x%02x 0x%02x\n", inout, data1, data2);
+				idx += 2;
+				break;
+			case 0x07:
+				dev_info(dev, "Get carrier mode and freq\n");
+				break;
+			case 0x08:
+				dev_info(dev, "%s transmit blaster mask of 0x%02x\n",
+					 inout, data1);
+				idx += 1;
+				break;
+			case 0x0c:
+				/* value is in units of 50us, so x*50/100 or x/2 ms */
+				dev_info(dev, "%s receive timeout of %d ms\n",
+					 inout, ((data1 << 8) | data2) / 2);
+				idx += 2;
+				break;
+			case 0x0d:
+				dev_info(dev, "Get receive timeout\n");
+				break;
+			case 0x13:
+				dev_info(dev, "Get transmit blaster mask\n");
+				break;
+			case 0x14:
+				dev_info(dev, "%s %s-range receive sensor in use\n",
+					 inout, data1 == 0x02 ? "short" : "long");
+				idx += 1;
+				break;
+			case 0x15:
+				if (!(len - idx))
+					dev_info(dev, "Get receive sensor\n");
+				else {
+					dev_info(dev, "Received pulse count is %d\n",
+						 ((data1 << 8) | data2));
+					idx += 2;
+				}
+				break;
+			case 0xfe:
+				dev_info(dev, "Error! Hardware is likely wedged...\n");
+				break;
+			case 0x05:
+			case 0x09:
+			case 0x0f:
+			default:
+				dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
+					 cmd, subcmd);
+				break;
+			}
 			break;
-		case 0xfe:
-			dev_info(dev, "Error! Hardware is likely wedged...\n");
-			break;
-		case 0x05:
-		case 0x09:
-		case 0x0f:
 		default:
-			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
-				 cmd, subcmd);
+			if (((cmd & 0xe0) >> 5) == 4) {
+				/* IR data */
+				int datalen = cmd & 0x1f;
+
+				if (len == 0x1f) {
+					dev_info(dev, "IR cmd = %d\n", subcmd);
+					idx = len;	/* FIXME */
+				} else {
+					dev_info(dev, "IR data len = %d", datalen);
+					idx += datalen - 1; /* No subcmd */
+				}
+			}
 			break;
 		}
-		break;
-	default:
-		break;
 	}
 }
 
@@ -724,9 +755,9 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 		if (ir->buf_in[i] == 0x80 || ir->buf_in[i] == 0x9f)
 			ir->rem = 0;
 
-		dev_dbg(ir->dev, "calling ir_raw_event_handle\n");
-		ir_raw_event_handle(ir->idev);
 	}
+	dev_dbg(ir->dev, "calling ir_raw_event_handle\n");
+	ir_raw_event_handle(ir->idev);
 }
 
 static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
-- 
1.7.1


