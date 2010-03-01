Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52875 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0CAK7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 05:59:36 -0500
Date: Mon, 1 Mar 2010 11:59:20 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firedtv: correct version number and current/next in CA_PMT
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org, Henrik Kurelid <henrik@kurelid.se>
Message-ID: <tkrat.dc97d52c76a2dc07@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Date: Tue, 21 Jul 2009 18:45:50 +0200
From: Henrik Kurelid <henrik@kurelid.se>

The version number in the CA_PMT message sent to the hardware was
alwaysed set to zero. This could cause problems if the PMT would
change during decryption of a channel since the new CA_PMT would have
the same version number as the old. The version number is now copied
from the original PMT.

Signed-off-by: Henrik Kurelid <henrik@kurelid.se>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This patch got stuck somehow on the long way upstream. :-)
Would be good to get into one of the next .34-rc releases.

 drivers/media/dvb/firewire/firedtv-avc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -1096,7 +1096,7 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
 
 	c->operand[15] = msg[1]; /* Program number */
 	c->operand[16] = msg[2];
-	c->operand[17] = 0x01; /* Version number=0 + current/next=1 */
+	c->operand[17] = msg[3]; /* Version number and current/next */
 	c->operand[18] = 0x00; /* Section number=0 */
 	c->operand[19] = 0x00; /* Last section number=0 */
 	c->operand[20] = 0x1f; /* PCR_PID=1FFF */

-- 
Stefan Richter
-=====-==-=- --== ----=
http://arcgraph.de/sr/

