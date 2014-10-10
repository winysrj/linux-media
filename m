Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.uli-eckhardt.de ([85.214.28.137]:40402 "EHLO
	mail.uli-eckhardt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751672AbaJJRTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 13:19:16 -0400
Message-ID: <54381510.5080301@uli-eckhardt.de>
Date: Fri, 10 Oct 2014 19:19:12 +0200
From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: [PATCH][media] Fix LNB supply voltage of Tevii S480 on initialization
References: <542C4B14.8030708@uli-eckhardt.de>
In-Reply-To: <542C4B14.8030708@uli-eckhardt.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Tevii S480 outputs 18V on startup for the LNB supply voltage and does not 
automatically power down. This blocks other receivers connected 
to a satellite channel router (EN50494), since the receivers can not send the
required DiSEqC sequences when the Tevii card is connected to a the same SCR.

This patch switches off the LNB supply voltage on initialization of the frontend. 

Signed-off-by: Ulrich Eckhardt <uli@uli-eckhardt.de>

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -864,6 +864,7 @@
        memcpy(&state->frontend.ops, &ds3000_ops,
                        sizeof(struct dvb_frontend_ops));
        state->frontend.demodulator_priv = state;
+       ds3000_set_voltage (&state->frontend, SEC_VOLTAGE_OFF);
        return &state->frontend;
 
 error3:




-- 
Ulrich Eckhardt                  http://www.uli-eckhardt.de

Ein Blitzableiter auf dem Kirchturm ist das denkbar stärkste 
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)
