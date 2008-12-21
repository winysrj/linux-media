Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LEEIM-0008SN-7v
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 03:43:55 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0812210301090.22383@ybpnyubfg.ybpnyqbznva>
References: <20081220224557.GF12059@titan.makhutov-it.de>
	<alpine.DEB.2.00.0812210301090.22383@ybpnyubfg.ybpnyqbznva>
Date: Sun, 21 Dec 2008 03:44:33 +0100
Message-Id: <1229827473.2557.11.camel@pc10.localdom.local>
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


Am Sonntag, den 21.12.2008, 03:29 +0100 schrieb BOUWSMA Barry:
> On Sat, 20 Dec 2008, Artem Makhutov wrote:
> 
> > 1. The stb0899 driver is broken and is producing a bad stream
> > 2. The network streaming of VLC and dvbstream is broken
> 
> Use the `-o:' option of `dvbstream' to write to a file,
> then see if this file is corrupted or damaged.  If this
> is so, then case 1 above would be correct.
> 
> 
> > Do you know any other methods to stream a DVB-S2 channel over network?
> 
> There's no difference between a DVB-S2 channel and any
> other source of 188-byte Transport Stream packets, be
> they video, radio, data, or whatever.
> 
> I've used `dvbstream' in the past to stream multicast
> data; the problem I had was in the limited support of
> the players I was using to handle the stream properly.
> I also think I may have had to hack `dvbstream' slightly
> to properly support and tag the payloads, though I may
> be mis-remembering.
> 
> At the moment I'm using `dvbstream' to stdout, then
> piping that to extract the audio payload of interest,
> which I then pipe to a different streaming program that
> performs better for a simple audio stream without the
> excess overhead of the TS, and it's working well.
> 
> The only problem I've had has been the interaction with
> the various hardware I use on the purity of the stream
> -- if the USB ethernet is connected one way, it causes
> the stream from the DVB receiver to be corrupted, and
> if the receiver is connected through a particular USB
> hub, its stream is again corrupted occasionally.  It is
> all very annoying when I forget, and confusing to try
> and track down these imperfections -- for example, I've
> now determined that a particular external USB->HDD
> adapter cannot be connected directly to my EHCI card,
> nor to the first hub, but seems fine when a second hub
> is connected to the first, then the disk to that
> daisy-chain.  And on another machine, the two EHCI USB
> ports don't work at all, while working wonderfully with
> NetBSD.
> 
> That off-topic rambling was to note that problems often
> may be caused by seemingly unrelated things for reasons
> which I cannot understand, not being intimate with the
> kernel internals or how hardware works.
> 
> Back on-topic, I have used `dvbstream' to multicast TS
> of radio and video, tuning directly with it (i.e., no
> `szap' needed) with no real problems, though it is the
> standard `dvbtools' version that I've undoubtedly hacked.
> 
> barry bouwsma
> 

Hi,

I must admit that I did not read it all yet this time.

But a good probe might be to save the HD S2 stuff to a file and then try
to get it over a nfs mount with xine for example on other PCs.

On consumer level it only has advantages, skip the commercials ...

This works since stoneage within local networks.

If you are trying to get it out over the internet, it might cause some
more questions of course.

Cheers,
Hermann









_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
