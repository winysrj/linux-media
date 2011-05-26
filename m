Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767Ab1EZVb6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 17:31:58 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4QLVwf5013015
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 26 May 2011 17:31:58 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] mceusb: support I-O Data GV-MC7/RCKIT
Date: Thu, 26 May 2011 17:31:55 -0400
Message-Id: <1306445515-17941-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There's an SMK-device-id remote kit from I-O Data avaiable primarily in
Japan, which appears to have no tx hardware, but has rx functionality
that works with the mceusb driver by simply adding its device ID.

http://www.iodata.jp/product/av/tidegi/gv-mc7rckit/

Reported-by: Jeremy Kwok <jeremykwok@desu.ca>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 2f1d0b7..3c4fb7d 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -252,6 +252,9 @@ static struct usb_device_id mceusb_dev_table[] = {
 	  .driver_info = MCE_GEN2_TX_INV },
 	/* SMK eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_SMK, 0x0338) },
+	/* SMK/I-O Data GV-MC7/RCKIT Receiver */
+	{ USB_DEVICE(VENDOR_SMK, 0x0353),
+	  .driver_info = MCE_GEN2_NO_TX },
 	/* Tatung eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_TATUNG, 0x9150) },
 	/* Shuttle eHome Infrared Transceiver */
-- 
1.7.1

