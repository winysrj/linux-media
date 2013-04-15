Return-path: <linux-media-owner@vger.kernel.org>
Received: from edge2.hbci.com ([192.145.255.3]:54980 "EHLO edge2.hbci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964783Ab3DOVYs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 17:24:48 -0400
Message-ID: <516C6E57.4090600@hbci.com>
Date: Mon, 15 Apr 2013 16:17:11 -0500
From: William Steidtmann <billstei@hbci.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, Sean Young <sean@mess.org>
Subject: Patch mceusb.c -- Kernel 3.9-rc6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix mceusb_cmdsize() which returns incorrect datasize=0 for sub-commands MCE_RSP_GETPORTSTATUS, MCE_RSP_GETWAKESOURCE, MCE_RSP_EQDEVDETAILS, MCE_RSP_EQEMVER, and MCE_RSP_EQIRNUMPORTS.  Change mceusb_cmdsize() name to reflect that it returns data size not cmd size.

Signed-off-by: William Steidtmann <billstei@hbci.com>
Acked-by:

--- a/drivers/media/rc/mceusb.c	2013-04-07 22:49:54.000000000 -0500
+++ b/drivers/media/rc/mceusb.c	2013-04-14 12:18:30.000000000 -0500
@@ -482,7 +482,7 @@ static char SET_RX_SENSOR[]	= {MCE_CMD_P
  				   MCE_RSP_EQIRRXPORTEN, 0x00};
  */
  
-static int mceusb_cmdsize(u8 cmd, u8 subcmd)
+static int mceusb_cmd_datasize(u8 cmd, u8 subcmd)
  {
  	int datasize = 0;
  
@@ -493,6 +493,9 @@ static int mceusb_cmdsize(u8 cmd, u8 sub
  		break;
  	case MCE_CMD_PORT_SYS:
  		switch (subcmd) {
+		case MCE_RSP_GETPORTSTATUS:
+			datasize = 5;
+			break;
  		case MCE_RSP_EQWAKEVERSION:
  			datasize = 4;
  			break;
@@ -500,6 +503,9 @@ static int mceusb_cmdsize(u8 cmd, u8 sub
  			datasize = 2;
  			break;
  		case MCE_RSP_EQWAKESUPPORT:
+		case MCE_RSP_GETWAKESOURCE:
+		case MCE_RSP_EQDEVDETAILS:
+		case MCE_RSP_EQEMVER:
  			datasize = 1;
  			break;
  		}
@@ -509,6 +515,7 @@ static int mceusb_cmdsize(u8 cmd, u8 sub
  		case MCE_RSP_EQIRCFS:
  		case MCE_RSP_EQIRTIMEOUT:
  		case MCE_RSP_EQIRRXCFCNT:
+		case MCE_RSP_EQIRNUMPORTS:
  			datasize = 2;
  			break;
  		case MCE_CMD_SIG_END:
@@ -968,7 +975,7 @@ static void mceusb_process_ir_data(struc
  	for (; i < buf_len; i++) {
  		switch (ir->parser_state) {
  		case SUBCMD:
-			ir->rem = mceusb_cmdsize(ir->cmd, ir->buf_in[i]);
+			ir->rem = mceusb_cmd_datasize(ir->cmd, ir->buf_in[i]);
  			mceusb_dev_printdata(ir, ir->buf_in, i - 1,
  					     ir->rem + 2, false);
  			mceusb_handle_command(ir, i);


