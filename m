Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57694 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962Ab2AFS0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 13:26:19 -0500
Received: by ghbg21 with SMTP id g21so822421ghb.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 10:26:19 -0800 (PST)
Date: Fri, 6 Jan 2012 12:26:14 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Hunold <michael@mihu.de>,
	Johannes Stezenbach <js@sig21.net>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 1/2] [media] dvb-bt8xx: use dprintk for debug statements
Message-ID: <20120106182614.GF15740@elie.hsd1.il.comcast.net>
References: <E1RjBAD-0006Ue-NL@www.linuxtv.org>
 <20120106182519.GE15740@elie.hsd1.il.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106182519.GE15740@elie.hsd1.il.comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This way, the messages will be tagged with KERN_DEBUG and not clutter
the log from dmesg unless the "debug" module parameter is set.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/bt8xx/dvb-bt8xx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index b9d927270318..2f38cca7604b 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -205,7 +205,7 @@ static int cx24108_tuner_set_params(struct dvb_frontend *fe)
 		0x00120000,0x00140000};
 
 	#define XTAL 1011100 /* Hz, really 1.0111 MHz and a /10 prescaler */
-	printk("cx24108 debug: entering SetTunerFreq, freq=%d\n",freq);
+	dprintk("cx24108 debug: entering SetTunerFreq, freq=%d\n",freq);
 
 	/* This is really the bit driving the tuner chip cx24108 */
 
@@ -216,7 +216,7 @@ static int cx24108_tuner_set_params(struct dvb_frontend *fe)
 
 	/* decide which VCO to use for the input frequency */
 	for(i = 1; (i < ARRAY_SIZE(osci) - 1) && (osci[i] < freq); i++);
-	printk("cx24108 debug: select vco #%d (f=%d)\n",i,freq);
+	dprintk("cx24108 debug: select vco #%d (f=%d)\n",i,freq);
 	band=bandsel[i];
 	/* the gain values must be set by SetSymbolrate */
 	/* compute the pll divider needed, from Conexant data sheet,
@@ -232,7 +232,7 @@ static int cx24108_tuner_set_params(struct dvb_frontend *fe)
 	    ((a&0x1f)<<11);
 	/* everything is shifted left 11 bits to left-align the bits in the
 	   32bit word. Output to the tuner goes MSB-aligned, after all */
-	printk("cx24108 debug: pump=%d, n=%d, a=%d\n",pump,n,a);
+	dprintk("cx24108 debug: pump=%d, n=%d, a=%d\n",pump,n,a);
 	cx24110_pll_write(fe,band);
 	/* set vga and vca to their widest-band settings, as a precaution.
 	   SetSymbolrate might not be called to set this up */
-- 
1.7.8.2

