Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JxooT-0003Pn-Hz
	for linux-dvb@linuxtv.org; Sun, 18 May 2008 21:45:00 +0200
From: Andy Walls <awalls@radix.net>
To: Jelle De Loecker <skerit@kipdola.com>
In-Reply-To: <483027AE.6020107@kipdola.com>
References: <482CC0F0.30005@kipdola.com>
	<E1JwrWW-0006Ye-00.goga777-bk-ru@f139.mail.ru>
	<482D1AB7.3070101@kipdola.com> <20080518121250.7dc0eaac@bk.ru>
	<482FF520.4070303@kipdola.com>
	<854d46170805180424r1ca63161h51f6f5e43c78d45f@mail.gmail.com>
	<4830158C.2030309@kipdola.com>
	<854d46170805180507q33d8b71ct16547fce16603d66@mail.gmail.com>
	<483027AE.6020107@kipdola.com>
Date: Sun, 18 May 2008 15:44:59 -0400
Message-Id: <1211139899.3380.15.camel@palomino.walls.org>
Mime-Version: 1.0
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

On Sun, 2008-05-18 at 14:57 +0200, Jelle De Loecker wrote:
> And when I give mplayer a go I get this:
>         $ dvbstream -o | mplayer -
>         dvbstream will stop after -1 seconds (71582788 minutes)
>         Output to stdout
>         Streaming 0 streams
>         MPlayer 1.0rc2-4.2.3 (C) 2000-2007 MPlayer Team
>         CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz (Family:
>         6, Model: 15, Stepping: 6)
>         CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
>         Compiled with runtime CPU detection.
>         mplayer: could not connect to socket
>         mplayer: No such file or directory
>         Failed to open LIRC support. You will not be able to use your
>         remote control.
>         
>         Playing -.
>         Reading from stdin...
>         Cannot seek backward in linear streams!
>         Seek failed
> Sorry for extensively testing your patience! I, too, wish it would
> have "just worked" :)

This "just worked" for me using mplayer with a digital video broadcast
from my HVR-1600 with the cx18 driver (I'm in ATSC country):

$ scandvb -A 1 -v -a 0  /usr/share/dvb-apps/atsc/us-ATSC-center-frequencies-8VSB \
	> channels.conf
$ cp channels.conf ~/.mplayer/channels.conf
$ mplayer dvb://WRC-1 -vf scale=960:540

The "scandvb" command name might be a rename by Fedora/Redhat of the
standard command name.

I had to use the '-vf scale=960:540' to display the 1080i content on my
1024 line display.  Also note that mplayer sometimes wrongly decodes a52
audio (at least from ATSC streams) so it'll gripe every so often.

For reference:

$ mplayer --help | head -1
MPlayer 1.0rc2-4.1.2 (C) 2000-2007 MPlayer Team

$ uname -rvi
2.6.23.15-80.fc7 #1 SMP Sun Feb 10 16:52:18 EST 2008 x86_64


Regards,
Andy

> Thank you,
> 
> Jelle De Loecker



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
