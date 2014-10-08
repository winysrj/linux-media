Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.uli-eckhardt.de ([85.214.28.137]:38035 "EHLO
	mail.uli-eckhardt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751749AbaJHQwP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 12:52:15 -0400
Message-ID: <54356BB9.5000609@uli-eckhardt.de>
Date: Wed, 08 Oct 2014 18:52:09 +0200
From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: Tevii S480 on Unicable SCR System
References: <542C4B14.8030708@uli-eckhardt.de>
In-Reply-To: <542C4B14.8030708@uli-eckhardt.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have digged a little bit deeper in the code and hopefully found a more general solution 
by initializing the voltage in dvb_frontend.c in the function dvb_register_frontend.
This should be a more global approach which may also fix this type of problems
with other cards. I will test this patch the next days on a different system with a 
CineS2 V5.5 card.

Any opinions about this patch or is my first attempt with patching only the code
for the Tevii S480 a better solution?

-----------------------------------------------------------------------------
diff -r f62f56c648b0 drivers/media/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb-core/dvb_frontend.c     Wed Oct 08 17:30:52 2014 +0200
+++ b/drivers/media/dvb-core/dvb_frontend.c     Wed Oct 08 17:40:20 2014 +0200
@@ -2622,6 +2622,14 @@
                             fe, DVB_DEVICE_FRONTEND);
 
        /*
+        * Ensure that frontend voltage is switched off on initialization
+        */
+       if (dvb_powerdown_on_sleep) {
+               if (fe->ops.set_voltage)
+                       fe->ops.set_voltage(fe, SEC_VOLTAGE_OFF);
+       }
+
+       /*
         * Initialize the cache to the proper values according with the
         * first supported delivery system (ops->delsys[0])
         */

-----------------------------------------------------------------------------

Am 01.10.2014 um 20:42 schrieb Ulrich Eckhardt:
> Hi,
> 
> i have a development computer with a Tevii S480 connected to a Satellite channel
> router (EN50494). As long as I haven't started a video application this
> computers blocks any other receiver connected to this cable. I have measured the
> output of the Tevii card and found, that after start of the computer, the output
> is set to 18V. This is not reset after loading and initializing the drivers. So
> no other receiver could sent DiSEqC commands to the SCR until
> a video application at this computer initializes the voltage correctly. I think
> the voltage needs to be switched off until this card is really in use by an
> application.
> 
> I have patched the file drivers/media/dvb-frontends/ds3000.c to initialize the
> voltage to OFF, which works for me. But I am not sure, if this is really the
> correct solution:
-- 
Ulrich Eckhardt                  http://www.uli-eckhardt.de

Ein Blitzableiter auf dem Kirchturm ist das denkbar stärkste 
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)

