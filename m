Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40860 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2DAPyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:05 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 09/11] Correct wait_event_timeout error return check.
Date: Sun,  1 Apr 2012 17:53:49 +0200
Message-Id: <1333295631-31866-9-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

wait_event_timeout() returns 0 on timeout, not -ERESTARTSYS.
Note that since this actually causes timeouts to be handled,
it makes the CA situation a lot worse without the next patch
in the series.
---
 drivers/media/dvb/mantis/mantis_hif.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_hif.c b/drivers/media/dvb/mantis/mantis_hif.c
index 6d42f73..a3ec2a2 100644
--- a/drivers/media/dvb/mantis/mantis_hif.c
+++ b/drivers/media/dvb/mantis/mantis_hif.c
@@ -47,7 +47,7 @@ static int mantis_hif_sbuf_opdone_wait(struct mantis_ca *ca)
 
 	if (wait_event_timeout(ca->hif_opdone_wq,
 			       test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event),
-			       msecs_to_jiffies(500)) == -ERESTARTSYS) {
+			       msecs_to_jiffies(500)) == 0) {
 
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Smart buffer operation timeout !", mantis->num);
 		rc = -EREMOTEIO;
@@ -63,7 +63,7 @@ static int mantis_hif_write_wait(struct mantis_ca *ca)
 
 	if (wait_event_timeout(ca->hif_write_wq,
 			       test_and_clear_bit(MANTIS_GPIF_WRACK_BIT, &mantis->gpif_status),
-			       msecs_to_jiffies(500)) == -ERESTARTSYS) {
+			       msecs_to_jiffies(500)) == 0) {
 
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Write ACK timed out !", mantis->num);
 		rc = -EREMOTEIO;
-- 
1.7.9.5

