Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab1GRTyp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 15:54:45 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6IJsjW3003862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 15:54:45 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH v2 3/9] [media] mceusb: set wakeup bits for IR-based resume
Date: Mon, 18 Jul 2011 15:54:23 -0400
Message-Id: <1311018869-22794-4-git-send-email-jarod@redhat.com>
In-Reply-To: <1310681394-3530-1-git-send-email-jarod@redhat.com>
References: <1310681394-3530-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Its not uncommon for folks to force these bits enabled, because people
do want to wake their htpc kit via their remote. Lets just set the bits
for 'em.

v2: rebase for mdelay->msleep changes

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index b1ea485..ab074a3 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -37,6 +37,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
+#include <linux/pm_wakeup.h>
 #include <media/rc-core.h>
 
 #define DRIVER_VERSION	"1.91"
@@ -1289,6 +1290,10 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, ir);
 
+	/* enable wake via this device */
+	device_set_wakeup_capable(ir->dev, true);
+	device_set_wakeup_enable(ir->dev, true);
+
 	dev_info(&intf->dev, "Registered %s on usb%d:%d\n", name,
 		 dev->bus->busnum, dev->devnum);
 
-- 
1.7.1

