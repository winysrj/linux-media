Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LEWyo-0007RD-6X
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 23:40:59 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Artem Makhutov <artem@makhutov.org>
In-Reply-To: <20081221135926.GI12059@titan.makhutov-it.de>
References: <20081220224557.GF12059@titan.makhutov-it.de>
	<alpine.DEB.2.00.0812210301090.22383@ybpnyubfg.ybpnyqbznva>
	<1229827473.2557.11.camel@pc10.localdom.local>
	<20081221135926.GI12059@titan.makhutov-it.de>
Date: Sun, 21 Dec 2008 23:41:31 +0100
Message-Id: <1229899291.2584.75.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to stream DVB-S2 channels over network?
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

Hi,

Am Sonntag, den 21.12.2008, 14:59 +0100 schrieb Artem Makhutov:
> Hi,
> 
> On Sun, Dec 21, 2008 at 03:44:33AM +0100, hermann pitton wrote:
> > I must admit that I did not read it all yet this time.
> > 
> > But a good probe might be to save the HD S2 stuff to a file and then try
> > to get it over a nfs mount with xine for example on other PCs.
> > 
> > On consumer level it only has advantages, skip the commercials ...
> > 
> > This works since stoneage within local networks.
> > 
> > If you are trying to get it out over the internet, it might cause some
> > more questions of course.
> 
> The STB can only playpack UDP Streams, so NFS will not help me much.

should have read better.

> I have recorded the stream to a file and will try to playback it under windows.
> My CPU is too slow to playback the stream without GPU acceleration under linux.
> 

The pDVD with GPU acceleration plays my Linux recorded BBC HD 1080i
stuff without any visible issues. So that should work in any case at
first I guess. (all on saa7134 DVB-S stuff)

I recently tried libxine with vdpau support, but on Linux recorded 1080i
BBC HD stuff it shows only a grey surface. The same recorded under
windows it plays already fine, but it often needs several attempts to
get playback started and it does not like seeking. It also doesn't like
my channels.conf yet, but I don't expect it to do any better on live
watching for now.

The recent mplayer vdpau patches do work fine for playback of all
recorded 1080i stuff and mpeg2 sound is without any sync issues.
It is only a simple 9500GT here, but the GPU stays totally cool and no
fan turns on like some supposed. 

The only issue left are some flashing green and purple blocks at the
bottom line, but others seem not to have it and it might be related to
the current implementation of that video card.

Unfortunately on vdpau live watching mplayer loses A/V sync like it does
with -vo xv even for playback only. That works mostly fine with kaffeine
xv against that libxine as long it stays with mpeg2 audio, but really
safe is only to playback from recordings, since they fumble around with
audio and that sort of AC3 they have seems not to be for me yet.
CPUs are of course at 30% on the amd quad with xv and ffmpeg h264 then.

Cheers,
Hermann



 




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
