Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway11.websitewelcome.com ([69.56.144.11])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1JxiS5-00016w-Ou
	for linux-dvb@linuxtv.org; Sun, 18 May 2008 14:57:27 +0200
Message-ID: <483027AE.6020107@kipdola.com>
Date: Sun, 18 May 2008 14:57:18 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: Faruk A <fa@elwak.com>
References: <482CC0F0.30005@kipdola.com>	<E1JwrWW-0006Ye-00.goga777-bk-ru@f139.mail.ru>	<482D1AB7.3070101@kipdola.com>
	<20080518121250.7dc0eaac@bk.ru>	<482FF520.4070303@kipdola.com>	<854d46170805180424r1ca63161h51f6f5e43c78d45f@mail.gmail.com>	<4830158C.2030309@kipdola.com>
	<854d46170805180507q33d8b71ct16547fce16603d66@mail.gmail.com>
In-Reply-To: <854d46170805180507q33d8b71ct16547fce16603d66@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend S2-3200 Scanning
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1550730261=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1550730261==
Content-Type: multipart/alternative;
 boundary="------------080100010609040307020604"

This is a multi-part message in MIME format.
--------------080100010609040307020604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Faruk A schreef:
>
> did you run szap with -rp ? make sure the channel you tuned to is not encrypted.
>
> here is another ugly way of doing it.
> u need dvbstream and vlc
>
> szap -rp "BBC World"
> dvbstream -o | vlc -
> or with with mplayer: dvbstream -o | mplayer -
>   
Very strange,

when I run dvbstream -o, without piping it into anything, I get a lot of 
binary feedback in the console, but I just can't open it in any program. 
(I tuned it using szap2, with the -rp option. I only tried unencrypted 
channels, so no problem there) dvbstream always says "streaming 0 
streams" which is probably not so good.

    $ dvbstream -o | vlc -
    dvbstream will stop after -1 seconds (71582788 minutes)
    Output to stdout
    Streaming 0 streams
    VLC media player 0.8.6e Janus
    libdvdnav: Using dvdnav version 0.1.10 from http://dvd.sf.net
    libdvdread: Using libdvdcss version 1.2.5 for DVD access
    libdvdread: Can't stat -
    No such file or directory
    libdvdnav: vm: faild to open/read the DVD
    libdvbpsi error (PSI decoder): TS discontinuity (received 3,
    expected 0) for PID 0


I even tried to output it to a file, but the file stays blank

    $ dvbstream -o:test.mpg
    Open file test.mpg

    MAP 0, file test.mpg: From -1 secs, To -1 secs, 0 PIDs -
    dvbstream will stop after -1 seconds (71582788 minutes)
    Streaming 0 streams


And when I give mplayer a go I get this:

    $ dvbstream -o | mplayer -
    dvbstream will stop after -1 seconds (71582788 minutes)
    Output to stdout
    Streaming 0 streams
    MPlayer 1.0rc2-4.2.3 (C) 2000-2007 MPlayer Team
    CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz (Family: 6,
    Model: 15, Stepping: 6)
    CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
    Compiled with runtime CPU detection.
    mplayer: could not connect to socket
    mplayer: No such file or directory
    Failed to open LIRC support. You will not be able to use your remote
    control.

    Playing -.
    Reading from stdin...
    Cannot seek backward in linear streams!
    Seek failed

Sorry for extensively testing your patience! I, too, wish it would have 
"just worked" :)

Thank you,

Jelle De Loecker

--------------080100010609040307020604
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
Faruk A schreef:
<blockquote
 cite="mid:854d46170805180507q33d8b71ct16547fce16603d66@mail.gmail.com"
 type="cite">
  <pre wrap=""><!---->
did you run szap with -rp ? make sure the channel you tuned to is not encrypted.

here is another ugly way of doing it.
u need dvbstream and vlc

szap -rp "BBC World"
dvbstream -o | vlc -
or with with mplayer: dvbstream -o | mplayer -
  </pre>
</blockquote>
Very strange,<br>
<br>
when I run dvbstream -o, without piping it into anything, I get a lot
of binary feedback in the console, but I just can't open it in any
program. (I tuned it using szap2, with the -rp option. I only tried
unencrypted channels, so no problem there) dvbstream always says
"streaming 0 streams" which is probably not so good.<br>
<br>
<blockquote>$ dvbstream -o | vlc -<br>
dvbstream will stop after -1 seconds (71582788 minutes)<br>
Output to stdout<br>
Streaming 0 streams<br>
VLC media player 0.8.6e Janus<br>
libdvdnav: Using dvdnav version 0.1.10 from <a class="moz-txt-link-freetext" href="http://dvd.sf.net">http://dvd.sf.net</a><br>
libdvdread: Using libdvdcss version 1.2.5 for DVD access<br>
libdvdread: Can't stat -<br>
No such file or directory<br>
libdvdnav: vm: faild to open/read the DVD<br>
libdvbpsi error (PSI decoder): TS discontinuity (received 3, expected
0) for PID 0<br>
</blockquote>
<br>
I even tried to output it to a file, but the file stays blank<br>
<br>
<blockquote>$ dvbstream -o:test.mpg<br>
Open file test.mpg<br>
  <br>
MAP 0, file test.mpg: From -1 secs, To -1 secs, 0 PIDs - <br>
dvbstream will stop after -1 seconds (71582788 minutes)<br>
Streaming 0 streams<br>
</blockquote>
<br>
And when I give mplayer a go I get this:<br>
<blockquote>$ dvbstream -o | mplayer -<br>
dvbstream will stop after -1 seconds (71582788 minutes)<br>
Output to stdout<br>
Streaming 0 streams<br>
MPlayer 1.0rc2-4.2.3 (C) 2000-2007 MPlayer Team<br>
CPU: Intel(R) Core(TM)2 CPU&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6600&nbsp; @ 2.40GHz (Family: 6, Model:
15, Stepping: 6)<br>
CPUflags:&nbsp; MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1<br>
Compiled with runtime CPU detection.<br>
mplayer: could not connect to socket<br>
mplayer: No such file or directory<br>
Failed to open LIRC support. You will not be able to use your remote
control.<br>
  <br>
Playing -.<br>
Reading from stdin...<br>
Cannot seek backward in linear streams!<br>
Seek failed<br>
</blockquote>
Sorry for extensively testing your patience! I, too, wish it would have
"just worked" :)<br>
<br>
Thank you,<br>
<br>
Jelle De Loecker<br>
</body>
</html>

--------------080100010609040307020604--


--===============1550730261==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1550730261==--
