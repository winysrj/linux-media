Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757966Ab1K3RIe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:08:34 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAUH8Y3r024426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 12:08:34 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 4/5] [media] tm6000: Allow auto-detecting tm6000 devices
Date: Wed, 30 Nov 2011 15:08:23 -0200
Message-Id: <1322672904-17340-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1322672904-17340-3-git-send-email-mchehab@redhat.com>
References: <1322672904-17340-1-git-send-email-mchehab@redhat.com>
 <1322672904-17340-2-git-send-email-mchehab@redhat.com>
 <1322672904-17340-3-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the tm6000 driver is on a good shape, we can enable
device autodetection, based on the USB ID.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tm6000/tm6000-cards.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-cards.c b/drivers/media/video/tm6000/tm6000-cards.c
index 0b54132..3873ce4 100644
--- a/drivers/media/video/tm6000/tm6000-cards.c
+++ b/drivers/media/video/tm6000/tm6000-cards.c
@@ -640,6 +640,7 @@ static struct usb_device_id tm6000_id_table[] = {
 	{ USB_DEVICE(0x6000, 0xdec3), .driver_info = TM6010_BOARD_BEHOLD_VOYAGER_LITE },
 	{ }
 };
+MODULE_DEVICE_TABLE(usb, tm6000_id_table);
 
 /* Control power led for show some activity */
 void tm6000_flash_led(struct tm6000_core *dev, u8 state)
-- 
1.7.7.3

