Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1CPUYl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:24:41 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2GKOfhO021269
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 16:24:41 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 6/6] mceusb: topseed 0x0011 needs gen3 init for tx to work
Date: Wed, 16 Mar 2011 16:24:31 -0400
Message-Id: <1300307071-19665-7-git-send-email-jarod@redhat.com>
In-Reply-To: <1300307071-19665-1-git-send-email-jarod@redhat.com>
References: <1300307071-19665-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index eedefce..044fb7a 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -261,7 +261,7 @@ static struct usb_device_id mceusb_dev_table[] = {
 	  .driver_info = MCE_GEN2_TX_INV },
 	/* Topseed eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_TOPSEED, 0x0011),
-	  .driver_info = MCE_GEN2_TX_INV },
+	  .driver_info = MCE_GEN3 },
 	/* Ricavision internal Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_RICAVISION, 0x0010) },
 	/* Itron ione Libra Q-11 */
-- 
1.7.1

