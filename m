Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26249 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab3BLMWe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 07:22:34 -0500
Date: Tue, 12 Feb 2013 15:22:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sean Young <sean@mess.org>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] mceusb: move check earlier to make smatch happy
Message-ID: <20130212122208.GA19045@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch complains that "cmdbuf[cmdcount - length]" might go past the end
of the array.  It's an easy warning to silence by moving the limit
check earlier.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index bdd1ed8..5b5b6e6 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -828,16 +828,16 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 			 (txbuf[i] -= MCE_MAX_PULSE_LENGTH));
 	}
 
-	/* Fix packet length in last header */
-	length = cmdcount % MCE_CODE_LENGTH;
-	cmdbuf[cmdcount - length] -= MCE_CODE_LENGTH - length;
-
 	/* Check if we have room for the empty packet at the end */
 	if (cmdcount >= MCE_CMDBUF_SIZE) {
 		ret = -EINVAL;
 		goto out;
 	}
 
+	/* Fix packet length in last header */
+	length = cmdcount % MCE_CODE_LENGTH;
+	cmdbuf[cmdcount - length] -= MCE_CODE_LENGTH - length;
+
 	/* All mce commands end with an empty packet (0x80) */
 	cmdbuf[cmdcount++] = MCE_IRDATA_TRAILER;
 
