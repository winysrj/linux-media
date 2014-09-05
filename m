Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40777 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaIEMJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Sep 2014 08:09:42 -0400
Date: Fri, 5 Sep 2014 15:09:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] ttusb-dec: buffer overflow in ioctl
Message-ID: <20140905120928.GA30311@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to add a limit check here so we don't overflow the buffer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
index 5c45c9d..9c29552 100644
--- a/drivers/media/usb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
@@ -156,6 +156,9 @@ static int ttusbdecfe_dvbs_diseqc_send_master_cmd(struct dvb_frontend* fe, struc
 		   0x00, 0x00, 0x00, 0x00,
 		   0x00, 0x00 };
 
+	if (cmd->msg_len > sizeof(b) - 4)
+		return -EINVAL;
+
 	memcpy(&b[4], cmd->msg, cmd->msg_len);
 
 	state->config->send_command(fe, 0x72,
