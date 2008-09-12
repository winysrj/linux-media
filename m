Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1Ke3LH-00041X-2i
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 09:45:23 +0200
Received: by rn-out-0910.google.com with SMTP id m36so505958rnd.2
	for <linux-dvb@linuxtv.org>; Fri, 12 Sep 2008 00:45:19 -0700 (PDT)
Date: Fri, 12 Sep 2008 09:45:13 +0200
To: linux-dvb@linuxtv.org
Message-ID: <20080912074513.GB3216@gmail.com>
References: <48C70F88.4050701@linuxtv.org>
	<200809112024.24821.liplianin@tut.by>
	<20080911200931.GA25626@gmail.com>
	<200809120030.55445.liplianin@tut.by>
	<20080912051056.GA3216@gmail.com> <web-53239698@speedy.tutby.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <web-53239698@speedy.tutby.com>
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: Re: [linux-dvb] S2API simple szap-s2 utility
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Fri, Sep 12, 2008 at 09:30:04AM +0300, "?????? ????? <liplianin@tut.by>"=
@vdr.localdomain wrote:

> mplayer, kaffeine, xine works with properly filled channels.conf
>
>   mplayer dvb://channelname
>
> Or you may try:
> In one console
>   szap-s2 channelname -r
>
> In another
>   mplayer - < /dev/dvb/adaptero/dvr0
>

Thank you very much, I missed the -r yesterday :-)

Unfortunetely today I can't tune to anything, I always got this error : =

FE_SET_PROPERTY failed: Operation not permitted

Directly with mplayer, I only get sofar :

mplayer dvb://1@ZDF
MPlayer dev-SVN-r27546 (C) 2000-2008 MPlayer Team
CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz (Family: 6, Model:
15, Stepping: 6)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled for x86 CPU with extensions: MMX MMX2 SSE SSE2

Playing dvb://1@ZDF.
dvb_tune Freq: 11954000
TS file format detected.

Thanks.
-- =

Gr=E9goire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.o=
rg
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
