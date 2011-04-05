Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41198 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1DETHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 15:07:16 -0400
Received: by fxm17 with SMTP id 17so491567fxm.19
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2011 12:07:14 -0700 (PDT)
Date: Tue, 5 Apr 2011 21:07:04 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: "Issa Gorissen" <flop.m@usa.net>
Cc: <linux-media@vger.kernel.org>
Subject: Re: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
Message-ID: <20110405210704.24555a04@grobi>
In-Reply-To: <632PDek8o1744S03.1302001214@web03.cms.usa.net>
References: <632PDek8o1744S03.1302001214@web03.cms.usa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 05 Apr 2011 13:00:14 +0200
"Issa Gorissen" <flop.m@usa.net> wrote:

> Hi,
> 
> Eutelsat made a recent migration from DVB-S to DVB-S2 (since
> 31/3/2011) on two transponders on HB13E
> 
> - HOT BIRD 6 13° Est TP 159 Freq 11,681 Ghz DVB-S2 FEC 3/4 27500
> Msymb/s 0.2 Pilot off Polar H
> 
> - HOT BIRD 9 13° Est TP 99 Freq 12,692 Ghz DVB-S2 FEC 3/4 27500
> Msymb/s 0.2 Pilot off Polar H
> 
> 
> Before those changes, with my TT S2 3200, I was able to watch TV on
> those transponders. Now, I cannot even tune on those transponders. I
> have tried with scan-s2 and w_scan and the latest drivers from git.
> They both find the transponders but cannot tune onto it.
> 
> Something noteworthy is that my other card, a DuoFlex S2 can tune
> fine on those transponders.
> 
> My question is; can someone try this as well with a TT S2 3200 and
> post the results ?

i read something about it lately here (german!): 
http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv-dvb-s2/p977938-stb0899-fec-3-4-tester-gesucht/#post977938

It says in stb0899_drv.c function:
static void stb0899_set_iterations(struct stb0899_state *state) 

This:
reg = STB0899_READ_S2REG(STB0899_S2DEMOD, MAX_ITER);
STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);

should be replaced with this:

reg = STB0899_READ_S2REG(STB0899_S2FEC, MAX_ITER);
STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
stb0899_write_s2reg(state, STB0899_S2FEC, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);

Basically replace STB0899_S2DEMOD with STB0899_S2FEC in this 2 lines
affected.

Kind Regards 

Steffen

