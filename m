Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1JnfWx-0006AW-SP
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 21:48:58 +0200
Received: by fk-out-0910.google.com with SMTP id z22so2084920fkz.1
	for <linux-dvb@linuxtv.org>; Sun, 20 Apr 2008 12:48:51 -0700 (PDT)
Message-ID: <854d46170804201248k70b14c99k5aba1fa8079b4649@mail.gmail.com>
Date: Sun, 20 Apr 2008 21:48:50 +0200
From: "Faruk A" <fa@elwak.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <200804201739.35206.dkuhlen@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <200804190101.14457.dkuhlen@gmx.net>
	<200804201054.35570.dkuhlen@gmx.net>
	<854d46170804200605i711bda4ci2c2e1b78a3e1c47b@mail.gmail.com>
	<200804201739.35206.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version (RC-keymap)
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

>  Could you please try to change line 1547 in stb0899_algo.c to:
>
>  offsetfreq = ((((offsetfreq / 1024) * 1000) / (1<<7)) * (s32)(internal->master_clk/1000000)) / (s32)(1<<13);
>
>  this should use only 32bit ops and not over/underflow for the expected ranges ;)
>
>
>   Dominik

It works, with this new changes i had no problem loading the drivers.

One more thing i did some testing with vdr and dvbs2 it looks like it
locks in exactly after 1 minute
but no video or audio vdr just displays no signal. I don't know if is
the vdrs fault or the drivers
anyway i have attached a small log. (no attachment rejected by
moderator, I've sent copy of this mail to Dominik with attachment.
Tried pastebin too didn't help)

The dvb-s2 channel is ASTRA HD+ on ASTRA 19E
vdr version is 1.6.0 with Reinhard Nissl's DVB-S2 + H.264 patch

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
