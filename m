Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53898 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1CFN1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 08:27:30 -0500
Received: by fxm17 with SMTP id 17so3385140fxm.19
        for <linux-media@vger.kernel.org>; Sun, 06 Mar 2011 05:27:29 -0800 (PST)
Date: Sun, 6 Mar 2011 14:20:20 +0100
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: linux-media@vger.kernel.org
Subject: patches missing in git ? - TT S2 1600
Message-ID: <20110306142020.7fe695ca@grobi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I have one patch lying around which will fix a kernel oops if more than
one TT S2 1600 is build into the same computer. 

It still applies and compiles - does someone know if this has been
obsoleted by another patch or if that means it is still missing ? 

Thanks !

Kind Regards 

Steffen

diff -r 7c0b887911cf linux/drivers/media/dvb/frontends/stv090x.c
--- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Apr 05 22:56:43 2010 -0400
+++ b/linux/drivers/media/dvb/frontends/stv090x.c	Sun Apr 11 13:46:43 2010 +0200
@@ -4664,7 +4664,7 @@ 
 	if (stv090x_i2c_gate_ctrl(state, 1) < 0)
 		goto err;
 
-	if (state->config->tuner_sleep) {
+	if (fe->tuner_priv && state->config->tuner_sleep) {
 		if (state->config->tuner_sleep(fe) < 0)
 			goto err_gateoff;
 	}

