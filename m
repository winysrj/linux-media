Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1JxkfY-0006f6-3E
	for linux-dvb@linuxtv.org; Sun, 18 May 2008 17:19:30 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1472559fga.25
	for <linux-dvb@linuxtv.org>; Sun, 18 May 2008 08:19:24 -0700 (PDT)
Message-ID: <854d46170805180819r6359d6aei61176c82b7b9a089@mail.gmail.com>
Date: Sun, 18 May 2008 17:19:23 +0200
From: "Faruk A" <fa@elwak.com>
To: "Jelle De Loecker" <skerit@kipdola.com>
In-Reply-To: <483027AE.6020107@kipdola.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <482CC0F0.30005@kipdola.com>
	<E1JwrWW-0006Ye-00.goga777-bk-ru@f139.mail.ru>
	<482D1AB7.3070101@kipdola.com> <20080518121250.7dc0eaac@bk.ru>
	<482FF520.4070303@kipdola.com>
	<854d46170805180424r1ca63161h51f6f5e43c78d45f@mail.gmail.com>
	<4830158C.2030309@kipdola.com>
	<854d46170805180507q33d8b71ct16547fce16603d66@mail.gmail.com>
	<483027AE.6020107@kipdola.com>
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

> Very strange,
>
> when I run dvbstream -o, without piping it into anything, I get a lot of
> binary feedback in the console, but I just can't open it in any program. (I
> tuned it using szap2, with the -rp option. I only tried unencrypted
> channels, so no problem there) dvbstream always says "streaming 0 streams"
> which is probably not so good.
>
> $ dvbstream -o | vlc -
> dvbstream will stop after -1 seconds (71582788 minutes)
> Output to stdout
> Streaming 0 streams
> VLC media player 0.8.6e Janus
> libdvdnav: Using dvdnav version 0.1.10 from http://dvd.sf.net
> libdvdread: Using libdvdcss version 1.2.5 for DVD access
> libdvdread: Can't stat -
> No such file or directory
> libdvdnav: vm: faild to open/read the DVD
> libdvbpsi error (PSI decoder): TS discontinuity (received 3, expected 0) for
> PID 0
>
> I even tried to output it to a file, but the file stays blank
>
> $ dvbstream -o:test.mpg
> Open file test.mpg
>
> MAP 0, file test.mpg: From -1 secs, To -1 secs, 0 PIDs -
> dvbstream will stop after -1 seconds (71582788 minutes)
> Streaming 0 streams
>
> And when I give mplayer a go I get this:
>
> $ dvbstream -o | mplayer -
> dvbstream will stop after -1 seconds (71582788 minutes)
> Output to stdout
> Streaming 0 streams
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
> Playing -.
> Reading from stdin...
> Cannot seek backward in linear streams!
> Seek failed
>
> Sorry for extensively testing your patience! I, too, wish it would have
> "just worked" :)
>
> Thank you,
>
> Jelle De Loecker
>

Thats all that i know, i started with dvb about 2 months ago and your
card is supported unlike my TT Connect S2-3650 CI, but some how i
managed it to work.

output to a file this two command should work.
as always run szip2 first.

cat /dev/dvb/adapter0/dvr0 > test.mpg
or
dvbstream -o > test2.mpg

dvbstream v0.5 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
Output to stdout
Streaming 0 streams

works 100% here Streaming 0 streams i thinks because we are using
output to file instead of streaming over network.

to stream i use:
dvbstream 8192 -i 192.168.0.103 -r 1234

dvbstream v0.5 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
Setting filter for PID 8192
Using 192.168.0.103:1234:2
version=2
Streaming 1 stream


8192 means stream the whole TS stream, -i your ip address and -r is port number.

then run vlc (mine is in Swedish so I'm guessing here) File-> Open
Networkstream or press Ctrl+N. The first option UDP/RTP enter port
number press OK.

or from command line: vlc udp://@:1234

Don't worry if nothing shows as i said before you are streaming the
whole TS stream. you can select the channels you wanna watch.
To select channels click on (in swedish Navigering) translates
Navigation -> Program-> you should see list of channels.

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
