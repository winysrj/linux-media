Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LEPlY-0007AE-Jc
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 15:58:53 +0100
Received: by ik-out-1112.google.com with SMTP id c28so513216ika.1
	for <linux-dvb@linuxtv.org>; Sun, 21 Dec 2008 06:58:45 -0800 (PST)
Date: Sun, 21 Dec 2008 15:58:37 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Artem Makhutov <artem@makhutov.org>
In-Reply-To: <20081221140416.GJ12059@titan.makhutov-it.de>
Message-ID: <alpine.DEB.2.00.0812211542250.22383@ybpnyubfg.ybpnyqbznva>
References: <20081220224557.GF12059@titan.makhutov-it.de>
	<alpine.DEB.2.00.0812210301090.22383@ybpnyubfg.ybpnyqbznva>
	<20081221140416.GJ12059@titan.makhutov-it.de>
MIME-Version: 1.0
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

On Sun, 21 Dec 2008, Artem Makhutov wrote:

> > Use the `-o:' option of `dvbstream' to write to a file,
> > then see if this file is corrupted or damaged.  If this
> > is so, then case 1 above would be correct.

> Everything looks like my SkyStar HD/TT-3200 is producing a little bit
> currupt stream for DVB-S2 under linux. DVB-S looks prette good.
> I will try to playback the recorded stream under Windows
> today afternoon.

Hi, me again :-)  Sorry to be writing so much today...

I actually do not know if you are receiving ASTRA HD from
19E2, or from elsewhere, and I now realize that earlier,
I assumed that you did...

As I noted in my last mail, please try `mplayer -vo null
etc.' to detect corrupted video.  The `-nosound' option
means that every frame will be checked, no matter how
slow my^H^H your machine.

In case the bandwidth is of concern, because I do not
know what to expect from HD DVB-S2 transponders...

I'm assuming, from your headers, you're somewhere in
germany -- if you are within the Astra 2D footprint at
28E2, meaning, the west or northwest, you can receive
the BBC-HD signal with a reasonable dish -- this will
fill about 7 to 8GB per hour on disk, and is sent via
DVB-S at present.  Around Berlin, you'll need perhaps a
2 metre dish.  If you can tune it, this will give a DVB-S 
reference at a decent bitrate, probably similar to ASTRA
HD.

Alternatively, on DVB-S, Eins Festival HD starts in less
than 24 hours; the bitrate is not so high -- I have some
files from the past Easter holiday that require, for
example, 21GB from somtime after 13h to just after 17h,
so a bit better than good quality SD video, but slightly
less than the BBC-HD stream.  Both these are H.264.

With a few hours of suitable HD recording, you can then
definitively say, oh yeah, the -S2 transport streams are
indeed corrupt and the -S streams perfect, or not, or
something.  That would be very useful, if it isn't
already widely known.


thnks,
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
