Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:56998 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbZCQB00 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 21:26:26 -0400
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Corey Taylor <johnfivealive@yahoo.com>, linux-media@vger.kernel.org
In-Reply-To: <1237251478.3303.37.camel@palomino.walls.org>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
	 <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
	 <63160.21731.qm@web56906.mail.re3.yahoo.com>
	 <1237251478.3303.37.camel@palomino.walls.org>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 02:24:38 +0100
Message-Id: <1237253078.8250.11.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 16.03.2009, 20:57 -0400 schrieb Andy Walls:
> On Mon, 2009-03-16 at 15:53 -0700, Corey Taylor wrote:
> > >Corey,
> > >
> > >As far as I know, with ATSC/QAM you typically won't see the same sort
> > >of "tearing" artifacts with a digital source, as those sorts of
> > >distortions are usually a product of analog transmission.  When you
> > >encounter these issues with digital sources, it's usually some product
> > >of the video card/X11 during playback.
> > 
> > >Perhaps you should make a small clip of MPEG available on a public
> > >HTTP server, so people can take a look and offer an opinion.
> > 
> > >Devin
> > 
> > Hi Devin, thanks for writing back.
> > 
> > I played the recording back on a MacBook Pro in VLC. It still displays the same artifacts.
> > 
> > My KWorld card works just fine with the same cable feed in to the same PC.
> > 
> > Could
> > it be that this HVR 1600 card is somehow incompatible with my
> > motherboard? 
> 
> Well, no.  It's more likely a system level issue.
> 
> 1.  Can you provide the output of 
> 
> $ cat /proc/interrupts
> 
> so I can see what device drivers are sharing IRQ 18 with the CX23418?
> 
> 
> 2. To turn on debugging to /var/log/messages and save some memory, as
> root, could you
> 
> # service mythbackend stop    (or otherwise kill the backend)
> # modprobe -r cx18
> # modprobe cx18 debug=7 enc_ts_bufsize=32 enc_ts_bufs=64 \
> 	enc_yuv_bufs=0 enc_idx_bufs=0
> 
> 
> 3. Test the digital side of the card with mplayer (you'll need a
> channels.conf in ~/.mplayer/channels.conf IIRC)
> 
> $ mplayer dvb://WFOO-DT -cache 8192
> 
> And see if you still see the artifcats.
> 
> Stop mplayer and look in your /var/log/messages for things like:
> 
> Mar 15 20:26:24 palomino kernel: cx18-0: Could not find buf 28 for stream encoder MPEG
> Mar 15 20:26:25 palomino kernel: cx18-0: Skipped TS, buffer 93, 31 times - it must have dropped out of rotation
> Mar 15 20:48:07 palomino kernel: cx18-0: Skipped TS, buffer 82, 31 times - it must have dropped out of rotation
> Mar 15 20:48:07 palomino kernel: cx18-0: Could not find buf 84 for stream TS
> Mar 15 21:01:13 palomino kernel: cx18-0: Fell behind! Ignoring stale mailbox with  inconsistent data. Lost buffer for mailbox seq n
> o 2218756
> Mar 15 21:01:13 palomino kernel: cx18-0: Skipped encoder VBI, buffer 115, 18 times - it must have dropped out of rotation
> 
> or messages about "Possibly falling behind...".  These are indicative of
> a system that can't keep up with the CX23418 firmware for some system
> level reason.
> 
> 
> 4.  Start up the mythbackend and tune to a digital channel:
> 
> # service mythbackend start  (or otherwise restart the mythbackend)
> 
> $ mythfrontend
> 
> Again check /var/log/messages for "Fell behind", "Possibly falling
> behind" and buffers that must have "dropped out of rotation".
> These are signs of a system that is not keeping up in servicing the
> CX23418 interrupt.
> 
> If the sequence numbers in the "falling behind" messages happen quite
> often or occur in bursts that are very close together, then you will
> likely see artifacts.
> 
> 
> Please provide your /var/log/messages output to the list (or to me, if
> it is too big).
> 
> 
> 
> If you don't have alot of those messages griping about falling behind,
> it could be RF signal strength related, or it could be something DMA
> related.
> 
> 
> 
> 
> 
> 
> > I've read in various places that this card works best with
> > PCI 2.3 compliant motherboards. Not sure mine meets that spec.
> 
> That's a red herring - a bad hypothesis I made a while ago.
> 
> What really was the difference is the PCI bridge that is set to
> subtractive decode.  If the PCI-PCI bridge set to subtractive decode is
> the one the CX23418 is behind, then the bridge retries a failed
> transaction to the CX23418.  On older systems (like many PCI 2.2
> systems), the bridge set to subtractive decode is a PCI-ISA bridge, so
> when a transaction to the CX23418 fails, that PCI-ISA bridge retries it
> on the ISA bus.
> 
> The latest cx18 driver automatically checks retries PCI bus transactions
> to the CX23418 - so that problem is effectively not an issue. 
> 
> 
> > Anyway, I captured some test video so you can see the problem firsthand.
> > 
> > Here's a link to a file generated by MythTV:
> > 
> > http://onpubco.com/tmp/hvr1600_dtv_sample.mpg (164MB, sorry for the large size! Right-click, save as, etc..)
> 
> I have dialup; 164 MB is to big for me to easily work with at the
> moment.

I have a good pipe again.

The file is definitely flawed already at recording level.

At least not fully smooth and recoverable with fairly recent libxine and
mplayer stuff, xv and vdpau. Can test it on recent m$ vista stuff as
well, but should not make any difference for my experience so far.

Cheers,
Hermann

> Regards,
> Andy
> 
> 
> > Here's the cx18 init output:
> > 
> > [   17.737667] cx18:  Start initialization, version 1.1.0
> > [   17.741016] cx18-0: Initializing card 0
> > [   17.741021] cx18-0: Autodetected Hauppauge card
> > [   17.744228] cx18 0000:04:09.0: PCI INT A -> Link[LNKB] -> GSI 18 (level, low) -> IRQ 18
> > [   17.747652] cx18-0: cx23418 revision 01010000 (B)
> > [   17.969685] cx18-0: Autodetected Hauppauge HVR-1600
> > [   17.969687] cx18-0: Simultaneous Digital and Analog TV capture supported
> > [   18.257142] tuner 3-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
> > [   18.287116] cs5345 2-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
> > [   18.364413] cx18-0: Registered device video0 for encoder MPEG (64 x 32 kB)
> > [   18.364417] DVB: registering new adapter (cx18)
> > [   18.493747] cx18-0: DVB Frontend registered
> > [   18.493750] cx18-0: Registered DVB adapter0 for TS (32 x 32 kB)
> > [   18.493793] cx18-0: Registered device video32 for encoder YUV (16 x 128 kB)
> > [   18.493834] cx18-0: Registered device vbi0 for encoder VBI (20 x 51984 bytes)
> > [   18.493870] cx18-0: Registered device video24 for encoder PCM audio (256 x 4 kB)
> > [   18.493873] cx18-0: Initialized card: Hauppauge HVR-1600
> > [   18.508191] cx18:  End initialization
> > [   33.928073] firmware: requesting v4l-cx23418-cpu.fw
> > [   34.135866] cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
> > [   34.161645] firmware: requesting v4l-cx23418-apu.fw
> > [   34.299395] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
> > [   34.305792] cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
> > [   34.512034] firmware: requesting v4l-cx23418-cpu.fw
> > [   34.658343] firmware: requesting v4l-cx23418-apu.fw
> > [   34.981741] firmware: requesting v4l-cx23418-dig.fw
> > [   35.261965] cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
> > [   42.284654] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> 
> 


