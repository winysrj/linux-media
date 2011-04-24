Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61253 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab1DXHpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2011 03:45:11 -0400
Received: by fxm17 with SMTP id 17so881680fxm.19
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2011 00:45:10 -0700 (PDT)
Date: Sun, 24 Apr 2011 09:44:58 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Issa Gorissen <flop.m@usa.net>
Cc: linux-media@vger.kernel.org, tuxoholic@hotmail.de,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: stb0899/stb6100 tuning problems
Message-ID: <20110424094458.02881033@grobi>
In-Reply-To: <4DB33CBF.6010003@usa.net>
References: <4DB33CBF.6010003@usa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 23 Apr 2011 22:55:27 +0200
Issa Gorissen <flop.m@usa.net> wrote:

> Hi,
> 
> Running kernel 2.6.39rc4. I've got trouble with tuning some
> transponders on Hotbird 13°E with a TT S2-3200.
> The transponders have been emitting DVB-S until end of march when they
> now emit DVB-S2 signals. They are:
> - 11681.00H 27500 3/4 8psk nid:319 tid:15900 on Hotbird 6
> - 12692.00H 27500 3/4 8psk nid:319 tid:9900 on Hotbird 9
> 
> 
> [1] https://patchwork.kernel.org/patch/244201/
> [2]
> http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg09214.html
> 
> 1) Patch [2] is merged into kernel 2.6.39rc4. Using scan-s2, I get no
> service available.
> 
> 2) I applied patch [1] and still could not get any service with
> scan-s2 from those transponders.
> 
> 3) I *reverted* patch[2] and now scan-s2 returns partial results.
> scan-s2 can tune onto the transponder on Hotbird 6 really quick and
> gives back the full services list.
> But I have to run scan-s2 with scan iterations count set to as high as
> 100 to be able to get results from the transponder on Hotbird 9.
> 
> When those transponders were emitting in DVB-S, I had no problem at
> all.
> 
> Can someone try the same thing on those transponders and report
> please ?

As mentioned before, try to use [1] + [2] + following patch. I would
expect this to be working. Please confirm. 

--- a/linux/drivers/media/dvb/frontends/stb0899_drv.c   2011-02-26 06:44:11.000000000 +0000
+++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c   2011-04-24 07:39:06.000000000 +0000
@@ -1426,9 +1426,9 @@ static void stb0899_set_iterations(struc
        if (iter_scale > config->ldpc_max_iter)
                iter_scale = config->ldpc_max_iter;

-       reg = STB0899_READ_S2REG(STB0899_S2DEMOD, MAX_ITER);
+       reg = STB0899_READ_S2REG(STB0899_S2FEC, MAX_ITER);
        STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
-       stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
+       stb0899_write_s2reg(state, STB0899_S2FEC, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
 }

 static enum dvbfe_search stb0899_search(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
