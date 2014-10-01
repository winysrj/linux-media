Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.uli-eckhardt.de ([85.214.28.137]:57013 "EHLO
	mail.uli-eckhardt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbaJASv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Oct 2014 14:51:57 -0400
Received: from [IPv6:2001:4dd0:ff00:8975:90ad:362d:ca31:4d1d] (unknown [IPv6:2001:4dd0:ff00:8975:90ad:362d:ca31:4d1d])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.uli-eckhardt.de (Postfix) with ESMTPSA id 7D904548B03
	for <linux-media@vger.kernel.org>; Wed,  1 Oct 2014 20:42:28 +0200 (CEST)
Message-ID: <542C4B14.8030708@uli-eckhardt.de>
Date: Wed, 01 Oct 2014 20:42:28 +0200
From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Tevii S480 on Unicable SCR System
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i have a development computer with a Tevii S480 connected to a Satellite channel
router (EN50494). As long as I haven't started a video application this
computers blocks any other receiver connected to this cable. I have measured the
output of the Tevii card and found, that after start of the computer, the output
is set to 18V. This is not reset after loading and initializing the drivers. So
no other receiver could sent DiSEqC commands to the SCR until
a video application at this computer initializes the voltage correctly. I think
the voltage needs to be switched off until this card is really in use by an
application.

I have patched the file drivers/media/dvb-frontends/ds3000.c to initialize the
voltage to OFF, which works for me. But I am not sure, if this is really the
correct solution:

--- ds3000.orig 2014-10-01 19:41:37.611631299 +0200
+++ ds3000.c    2014-10-01 20:18:19.602930920 +0200
@@ -864,6 +864,7 @@
        memcpy(&state->frontend.ops, &ds3000_ops,
                        sizeof(struct dvb_frontend_ops));
        state->frontend.demodulator_priv = state;
+       ds3000_set_voltage (&state->frontend, SEC_VOLTAGE_OFF);
        return &state->frontend;

 error3:

-------------------------------------------------------

Best Regards
Uli
-- 
Ulrich Eckhardt                  http://www.uli-eckhardt.de

Ein Blitzableiter auf dem Kirchturm ist das denkbar stärkste
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)
