Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2CLR1L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 13:27:11 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q2CHRADR023157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 12 Mar 2012 13:27:10 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] mceusb: add Formosa device ID 0xe042
Date: Mon, 12 Mar 2012 13:27:03 -0400
Message-Id: <1331573223-22676-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yet another device ID that has started showing up in the wild.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 60d3c1e..0918c69 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -361,6 +361,8 @@ static struct usb_device_id mceusb_dev_table[] = {
 	{ USB_DEVICE(VENDOR_FORMOSA, 0xe03c) },
 	/* Formosa Industrial Computing */
 	{ USB_DEVICE(VENDOR_FORMOSA, 0xe03e) },
+	/* Formosa Industrial Computing */
+	{ USB_DEVICE(VENDOR_FORMOSA, 0xe042) },
 	/* Fintek eHome Infrared Transceiver (HP branded) */
 	{ USB_DEVICE(VENDOR_FINTEK, 0x5168) },
 	/* Fintek eHome Infrared Transceiver */
-- 
1.7.1

