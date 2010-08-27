Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0H0VgF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 17:36:05 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7RLa4p1030472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 27 Aug 2010 17:36:04 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o7RLa41C023210
	for <linux-media@vger.kernel.org>; Fri, 27 Aug 2010 17:36:04 -0400
Date: Fri, 27 Aug 2010 17:19:50 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR/mceusb: add an ASUS device ID
Message-ID: <20100827211950.GL22542@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Reported in lirc sf.net tracker

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index ac6bb2c..f0b7e42 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -120,6 +120,8 @@ static struct usb_device_id mceusb_dev_table[] = {
 	{ USB_DEVICE(VENDOR_PHILIPS, 0x0613) },
 	/* Philips eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_PHILIPS, 0x0815) },
+	/* Philips/Spinel plus IR transceiver for ASUS */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x2088) },
 	/* Realtek MCE IR Receiver */
 	{ USB_DEVICE(VENDOR_REALTEK, 0x0161) },
 	/* SMK/Toshiba G83C0004D410 */
-- 
1.7.2.2

-- 
Jarod Wilson
jarod@redhat.com

