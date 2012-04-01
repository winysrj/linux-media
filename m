Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40864 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab2DAPyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:05 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 10/11] Ignore timeouts waiting for the IRQ0 flag.
Date: Sun,  1 Apr 2012 17:53:50 +0200
Message-Id: <1333295631-31866-10-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

As others have noticed, sometimes, especially during DMA transfers, the IRQ0
flag is never properly set and thus reads never return.  (The typical case for
this is when we've just done a write and the en50221 thread is waiting for the
CAM status word to signal STATUSREG_DA; if this doesn't happen in a reasonable
amount of time, the upstream libdvben50221.so will report errors back to
mumudvb.)

I have no idea why this happens more often on SMP systems than on UMP systems,
but they really seem to do. I haven't found any reasonable workaround for
reliable polling either, so I'm making a hack -- if there's nothing returned in
two milliseconds, the read is simply assumed to have completed.

This is an unfortunate hack, but in practice it's identical to earlier
behavior except with a shorter timeout.

Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
---
 drivers/media/dvb/mantis/mantis_hif.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_hif.c b/drivers/media/dvb/mantis/mantis_hif.c
index a3ec2a2..0da3c6d 100644
--- a/drivers/media/dvb/mantis/mantis_hif.c
+++ b/drivers/media/dvb/mantis/mantis_hif.c
@@ -45,11 +45,19 @@ static int mantis_hif_sbuf_opdone_wait(struct mantis_ca *ca)
 	struct mantis_pci *mantis = ca->ca_priv;
 	int rc = 0;
 
+	/*
+	 * HACK: Sometimes, especially during DMA transfers, and especially on
+	 * SMP systems (!), the IRQ-0 flag is never set, or at least we don't get it
+	 * (could it be that we're clearing it?). Thus, simply wait for 2 ms and then
+	 * assume we got an answer even if we didn't. This works around lots of CA
+	 * timeouts. The code with 500 ms wait and -EREMOTEIO is technically the
+	 * correct one, though.
+	 */
 	if (wait_event_timeout(ca->hif_opdone_wq,
 			       test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event),
-			       msecs_to_jiffies(500)) == 0) {
+			       msecs_to_jiffies(2)) == 0) {
 
-		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Smart buffer operation timeout !", mantis->num);
+		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Smart buffer operation timeout ! (ignoring)", mantis->num);
 		rc = -EREMOTEIO;
 	}
 	dprintk(MANTIS_DEBUG, 1, "Smart Buffer Operation complete");
-- 
1.7.9.5

