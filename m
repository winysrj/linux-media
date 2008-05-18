Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway16.websitewelcome.com ([69.56.160.2])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1JxhFD-0005qj-EZ
	for linux-dvb@linuxtv.org; Sun, 18 May 2008 13:40:05 +0200
Message-ID: <4830158C.2030309@kipdola.com>
Date: Sun, 18 May 2008 13:39:56 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: Faruk A <fa@elwak.com>
References: <482CC0F0.30005@kipdola.com>	<E1JwrWW-0006Ye-00.goga777-bk-ru@f139.mail.ru>	<482D1AB7.3070101@kipdola.com>
	<20080518121250.7dc0eaac@bk.ru>	<482FF520.4070303@kipdola.com>
	<854d46170805180424r1ca63161h51f6f5e43c78d45f@mail.gmail.com>
In-Reply-To: <854d46170805180424r1ca63161h51f6f5e43c78d45f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend S2-3200 Scanning
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2106345901=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============2106345901==
Content-Type: multipart/alternative;
 boundary="------------050508090608030501080307"

This is a multi-part message in MIME format.
--------------050508090608030501080307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Faruk A schreef:
>
> szap -rp "BBC World"   (you can replace BBC World with any channel in
> your channel.conf) and make sure you get FE_HAS_LOCK before you start
> mplayer.
>
> mplayer /dev/dvb/adapter0/dvr0
>   

I've managed to get a lock - well no problem there actually, but when I 
try to use mplayer I'm lost:

$ mplayer /dev/dvb/adapter0/dvr0 (or mplayer -fs /dev/dvb/adapter0/dvr0)
MPlayer 1.0rc2-4.2.3 (C) 2000-2007 MPlayer Team
CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz (Family: 6, Model: 
15, Stepping: 6)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote 
control.

Playing /dev/dvb/adapter0/dvr0.

So it says it's playing (the "could not connect to socket" is purely a 
lirc problem) but where's the video?
I also tried gmplayer, but that just locks up.

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

Thanks for the info, I'll be sure to give that a go this evening!

--------------050508090608030501080307
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
<br>
Faruk A schreef:
<blockquote
 cite="mid:854d46170805180424r1ca63161h51f6f5e43c78d45f@mail.gmail.com"
 type="cite">
  <pre wrap=""><!---->
szap -rp "BBC World"   (you can replace BBC World with any channel in
your channel.conf) and make sure you get FE_HAS_LOCK before you start
mplayer.

mplayer /dev/dvb/adapter0/dvr0
  </pre>
</blockquote>
<br>
I've managed to get a lock - well no problem there actually, but when I
try to use mplayer I'm lost:<br>
<br>
$ mplayer /dev/dvb/adapter0/dvr0 (or mplayer -fs /dev/dvb/adapter0/dvr0)<br>
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
Playing /dev/dvb/adapter0/dvr0.<br>
<br>
So it says it's playing (the "could not connect to socket" is purely a
lirc problem) but where's the video?<br>
I also tried gmplayer, but that just locks up.<br>
<br>
<blockquote
 cite="mid:854d46170805180424r1ca63161h51f6f5e43c78d45f@mail.gmail.com"
 type="cite">
  <pre wrap="">
mythtv: there is multiproto patch for mythtv-svn. I tried it but it
always failed med after 1 hour of compiling it's nothing to do with
the patch anyway here is the link to the patch.

<a class="moz-txt-link-freetext" href="http://pansy.at/gernot/mythtv-multiproto-hack.diff.gz">http://pansy.at/gernot/mythtv-multiproto-hack.diff.gz</a>

easiest way is to use vdr, I'm using vdr-1.6.0-1 stable version.
if you want to use the stable version you have to search for this
patch [ANNOUNCE] DVB-S2 + H.264 support for VDR-1.5.18 in vdr mailing
list and patch the vdr source.
  </pre>
</blockquote>
<br>
Thanks for the info, I'll be sure to give that a go this evening!<br>
</body>
</html>

--------------050508090608030501080307--


--===============2106345901==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2106345901==--
