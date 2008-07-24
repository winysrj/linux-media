Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server42.ukservers.net ([217.10.138.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stephen@rowles.org.uk>) id 1KLzJ4-0005b9-73
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 13:48:27 +0200
Received: from server42.ukservers.net (localhost.localdomain [127.0.0.1])
	by server42.ukservers.net (Postfix smtp) with ESMTP id 77D71A72E8
	for <linux-dvb@linuxtv.org>; Thu, 24 Jul 2008 12:47:51 +0100 (BST)
Received: from miner.localdomain (unknown [78.149.208.47])
	by server42.ukservers.net (Postfix smtp) with ESMTP id 52B7EA72B1
	for <linux-dvb@linuxtv.org>; Thu, 24 Jul 2008 12:47:51 +0100 (BST)
Received: from manicminer.homeip.net (miner [127.0.0.1])
	by miner.localdomain (Postfix) with ESMTP id 323DD18474
	for <linux-dvb@linuxtv.org>; Thu, 24 Jul 2008 12:47:51 +0100 (BST)
Message-ID: <44812.81.144.130.125.1216900071.squirrel@manicminer.homeip.net>
In-Reply-To: <488863EF.8000402@iinet.net.au>
References: <488860FE.5020500@iinet.net.au> <4888623F.5000108@to-st.de>
	<488863EF.8000402@iinet.net.au>
Date: Thu, 24 Jul 2008 12:47:51 +0100 (BST)
From: "Stephen Rowles" <stephen@rowles.org.uk>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] dvb mpeg2?
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

> MPEG2-TS is what is supposed to be the format, but how can I discover if
> it really is?
>
> Regards,
> Tim Farrington

I use mplayer e.g.

mplayer -identify 06-29_20_00_Top_Gear.ts -frames 0 -vo null -nosound

Which after lots of output finally gives the following and you can see at
the bottom in my case that this is a Mpeg 1/2 video, which is encapsulated
inside an mpegts file (ID_DEMUXER line below). For reference I recorded
this file from my DVB-T USB stick using mplayer with the -dumpstream
command.

VIDEO:  MPEG2  720x576  (aspect 3)  25.000 fps  6500.0 kbps (812.5 kbyte/s)
ID_FILENAME=06-29_20_00_Top_Gear.ts
ID_DEMUXER=mpegts
ID_VIDEO_FORMAT=0x10000002
ID_VIDEO_BITRATE=6500000
ID_VIDEO_WIDTH=720
ID_VIDEO_HEIGHT=576
ID_VIDEO_FPS=25.000
ID_VIDEO_ASPECT=0.0000
ID_LENGTH=2074.19
==========================================================================
Opening video decoder: [mpegpes] MPEG 1/2 Video passthrough
VDec: vo config request - 720 x 576 (preferred colorspace: Mpeg PES)
VDec: using Mpeg PES as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
VO: [null] 720x576 => 720x576 Mpeg PES
Selected video codec: [mpegpes] vfm: mpegpes (MPEG-PES output (.mpg or
DXR3/IVTV/DVB card))
==========================================================================
ID_VIDEO_CODEC=mpegpes
Audio: no sound
Starting playback...


Exiting... (End of file)



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
