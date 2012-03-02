Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55421 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab2CBUl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 15:41:28 -0500
Received: by iagz16 with SMTP id z16so2764466iag.19
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2012 12:41:27 -0800 (PST)
Date: Fri, 2 Mar 2012 14:41:19 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Jarod Wilson <jarod@redhat.com>,
	Torsten Crass <torsten.crass@eBiology.de>
Subject: [PATCH 3/4] [media] staging: lirc_serial: Fix deadlock on resume
 failure
Message-ID: <20120302204119.GD22323@burratino>
References: <1321422581.2885.50.camel@deadeye>
 <20120302034545.GA31860@burratino>
 <1330662942.8460.229.camel@deadeye>
 <20120302203913.GA22323@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302203913.GA22323@burratino>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ben Hutchings <ben@decadent.org.uk>
Date: Wed, 16 Nov 2011 01:53:25 -0300

commit 1ff1d88e862948ae5bfe490248c023ff8ac2855d upstream.

A resume function cannot remove the device it is resuming!

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/staging/lirc/lirc_serial.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/lirc/lirc_serial.c b/drivers/staging/lirc/lirc_serial.c
index fa023da6bdaa..4b8fefb954d3 100644
--- a/drivers/staging/lirc/lirc_serial.c
+++ b/drivers/staging/lirc/lirc_serial.c
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
1.7.9.2

