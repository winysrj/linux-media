Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1JxhgA-0007FC-3E
	for linux-dvb@linuxtv.org; Sun, 18 May 2008 14:07:55 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1428817fga.25
	for <linux-dvb@linuxtv.org>; Sun, 18 May 2008 05:07:50 -0700 (PDT)
Message-ID: <854d46170805180507q33d8b71ct16547fce16603d66@mail.gmail.com>
Date: Sun, 18 May 2008 14:07:50 +0200
From: "Faruk A" <fa@elwak.com>
To: "Jelle De Loecker" <skerit@kipdola.com>
In-Reply-To: <4830158C.2030309@kipdola.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <482CC0F0.30005@kipdola.com>
	<E1JwrWW-0006Ye-00.goga777-bk-ru@f139.mail.ru>
	<482D1AB7.3070101@kipdola.com> <20080518121250.7dc0eaac@bk.ru>
	<482FF520.4070303@kipdola.com>
	<854d46170805180424r1ca63161h51f6f5e43c78d45f@mail.gmail.com>
	<4830158C.2030309@kipdola.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend S2-3200 Scanning
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

> I've managed to get a lock - well no problem there actually, but when I try
> to use mplayer I'm lost:
>
> $ mplayer /dev/dvb/adapter0/dvr0 (or mplayer -fs /dev/dvb/adapter0/dvr0)
> MPlayer 1.0rc2-4.2.3 (C) 2000-2007 MPlayer Team
> CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz (Family: 6, Model: 15,
> Stepping: 6)
> CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
> Compiled with runtime CPU detection.
> mplayer: could not connect to socket
> mplayer: No such file or directory
> Failed to open LIRC support. You will not be able to use your remote
> control.
>
> Playing /dev/dvb/adapter0/dvr0.
>
> So it says it's playing (the "could not connect to socket" is purely a lirc
> problem) but where's the video?
> I also tried gmplayer, but that just locks up.
>
> mythtv: there is multiproto patch for mythtv-svn. I tried it but it
> always failed med after 1 hour of compiling it's nothing to do with
> the patch anyway here is the link to the patch.
>
> http://pansy.at/gernot/mythtv-multiproto-hack.diff.gz
>
> easiest way is to use vdr, I'm using vdr-1.6.0-1 stable version.
> if you want to use the stable version you have to search for this
> patch [ANNOUNCE] DVB-S2 + H.264 support for VDR-1.5.18 in vdr mailing
> list and patch the vdr source.
>
>
> Thanks for the info, I'll be sure to give that a go this evening!

did you run szap with -rp ? make sure the channel you tuned to is not encrypted.

here is another ugly way of doing it.
u need dvbstream and vlc

szap -rp "BBC World"
dvbstream -o | vlc -
or with with mplayer: dvbstream -o | mplayer -

There is two version of dvbstream out there, patched and unpatched.
it should work with both of them, but with multiproto patched version
you dont need to run szap it can tune and lock to channels by it self.

link to the patched version:
http://www.coolatoola.com/dvbstream.multiproto.tgz

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
