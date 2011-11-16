Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52342 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077Ab1KPFxe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 00:53:34 -0500
Message-ID: <1321422805.2885.54.camel@deadeye>
Subject: [PATCH 3/5] staging: lirc_serial: Fix deadlock on resume failure
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Wed, 16 Nov 2011 05:53:25 +0000
In-Reply-To: <1321422581.2885.50.camel@deadeye>
References: <1321422581.2885.50.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A resume function cannot remove the device it is resuming!

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
I haven't seen any report of this deadlock, but it seems pretty obvious.

Ben.

 drivers/staging/media/lirc/lirc_serial.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index d833772..befe626 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -1127,10 +1127,8 @@ static int lirc_serial_resume(struct platform_device *dev)
 {
 	unsigned long flags;
 
-	if (hardware_init_port() < 0) {
-		lirc_serial_exit();
+	if (hardware_init_port() < 0)
 		return -EINVAL;
-	}
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
 	/* Enable Interrupt */
-- 
1.7.7.2



