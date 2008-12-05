Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vps1.tull.net ([66.180.172.116])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <nick-linuxtv@nick-andrew.net>) id 1L8Z7O-00023X-De
	for linux-dvb@linuxtv.org; Fri, 05 Dec 2008 12:45:13 +0100
MIME-Version: 1.0
Message-Id: <6810946716817a6c1172.1228477484@marcab.local.tull.net>
In-Reply-To: <patchbomb.1228477483@marcab.local.tull.net>
Date: Fri, 05 Dec 2008 22:44:44 +1100
From: Nick Andrew <nick-linuxtv@nick-andrew.net>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH 1 of 2] Fix spelling of 'lose'
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

# HG changeset patch
# User Nick Andrew <nick@nick-andrew.net>
# Date 1228476704 -39600
# Node ID 6810946716817a6c1172912541b9e348b1a44401
# Parent  6bab82c6096e66523ea8c77eb1843550b9a096b9
Fix spelling of 'lose'

Change 'loose' to 'lose'

Signed-off-by: Nick Andrew <nick@nick-andrew.net>

diff -r 6bab82c6096e -r 681094671681 linux/drivers/media/dvb/ttpci/av7110.c
--- a/linux/drivers/media/dvb/ttpci/av7110.c	Wed Dec 03 15:32:11 2008 -0200
+++ b/linux/drivers/media/dvb/ttpci/av7110.c	Fri Dec 05 22:31:44 2008 +1100
@@ -2848,7 +2848,7 @@
 		 * we must do it here even though saa7146_core did it already),
 		 * and b) that if we were to disable an edge triggered irq
 		 * (like the gpio irqs sadly are) temporarily we would likely
-		 * loose some. This sucks :-(
+		 * lose some. This sucks :-(
 		 */
 		SAA7146_IER_DISABLE(av7110->dev, MASK_19);
 		SAA7146_ISR_CLEAR(av7110->dev, MASK_19);

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
