Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:38397 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760623Ab1LPTeW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 14:34:22 -0500
From: Matthieu CASTET <castet.matthieu@free.fr>
To: linux-media@vger.kernel.org
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Subject: [PATCH] tm6000 : dvb doesn't work on usb1.1
Date: Fri, 16 Dec 2011 20:34:12 +0100
Message-Id: <1324064052-7631-1-git-send-email-castet.matthieu@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
---
 drivers/staging/tm6000/tm6000-dvb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index 8f2a50b..cbecb7d 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -396,6 +396,11 @@ static int dvb_init(struct tm6000_core *dev)
 	if (!dev->caps.has_dvb)
 		return 0;
 
+	if (dev->udev->speed == USB_SPEED_FULL) {
+		printk(KERN_INFO "This USB2.0 device cannot be run on a USB1.1 port. (it lacks a hardware PID filter)\n");
+		return 0;
+	}
+
 	dvb = kzalloc(sizeof(struct tm6000_dvb), GFP_KERNEL);
 	if (!dvb) {
 		printk(KERN_INFO "Cannot allocate memory\n");
-- 
1.7.5.4

