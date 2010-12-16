Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:18981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab0LPTBR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 14:01:17 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBGJ1Hxp001429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 14:01:17 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 4/4] mceusb: add another Fintek device ID
Date: Thu, 16 Dec 2010 14:00:37 -0500
Message-Id: <1292526037-21491-5-git-send-email-jarod@redhat.com>
In-Reply-To: <1292526037-21491-1-git-send-email-jarod@redhat.com>
References: <1292526037-21491-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 9c55e32..2d91134 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -281,6 +281,8 @@ static struct usb_device_id mceusb_dev_table[] = {
 	{ USB_DEVICE(VENDOR_FORMOSA, 0xe03c) },
 	/* Formosa Industrial Computing */
 	{ USB_DEVICE(VENDOR_FORMOSA, 0xe03e) },
+	/* Fintek eHome Infrared Transceiver (HP branded) */
+	{ USB_DEVICE(VENDOR_FINTEK, 0x5168) },
 	/* Fintek eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_FINTEK, 0x0602) },
 	/* Fintek eHome Infrared Transceiver (in the AOpen MP45) */
-- 
1.7.1

