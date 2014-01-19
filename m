Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:37651 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaASRca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 12:32:30 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZN00J81SQ4IK20@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sun, 19 Jan 2014 12:32:29 -0500 (EST)
Date: Sun, 19 Jan 2014 15:32:24 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [ANNOUNCE EXPERIMENTAL] PCTV 80e driver
Message-id: <20140119153224.122ce0d4@samsung.com>
In-reply-to: <CAGoCfiwp0WPMceeyQUHU-GJkSkiQzpF-YoJ+ueiFNqNOEQNK4A@mail.gmail.com>
References: <20140119022328.55f6a741@samsung.com>
 <20140119113926.60e0f586@samsung.com>
 <CAGoCfiwp0WPMceeyQUHU-GJkSkiQzpF-YoJ+ueiFNqNOEQNK4A@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 19 Jan 2014 11:50:55 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Sun, Jan 19, 2014 at 8:39 AM, Mauro Carvalho Chehab
> <m.chehab@samsung.com> wrote:
> > It seems that subsequent tuning makes the device worse, reducing the
> > maximum effective packet bandwidth. Btw, this happens with both xHCI
> > and EHCI drivers, so, it is not related to any USB 3.0 issue.
> 
> I'm pretty sure I saw this and had a patch.  I don't recall the exact
> circumstances under which it happened, but I believe it had to do with
> stopping and then restarting the streaming on the em28xx too quickly.
> The state machine inside the em28xx gets confused and you end up
> getting a misaligned stream (which is why you see hundreds of
> different PIDs in output from tools such as dvbtraffic).

Do you still has your old tree? I'm not seeing it anymore at kernellabs.

> 
> > Enabling some demux logs, it is possible to see that there are too many
> > FEC errors:
> >
> > [73514.186880] dvb_dmx_swfilter_packet: 4546 callbacks suppressed
> > [73514.186933] TEI detected. PID=0x17f data1=0xc1
> > [73514.186965] TEI detected. PID=0x1c68 data1=0xbc
> > [73514.186993] TEI detected. PID=0x17f data1=0xc1
> > [73514.187022] TEI detected. PID=0x1c68 data1=0xbc
> > [73514.187049] TEI detected. PID=0x17f data1=0xc1
> > [73514.187080] TEI detected. PID=0x1c68 data1=0xbc
> > [73514.187105] TEI detected. PID=0x17f data1=0xc1
> > [73514.194878] TEI detected. PID=0x1c68 data1=0xbc
> > [73514.194906] TEI detected. PID=0x17f data1=0xc1
> > [73514.194927] TEI detected. PID=0x1c68 data1=0xbc
> > [73521.569205] TS speed 402 Kbits/sec
> 
> Are these actually valid PIDs you're expecting data on?  If not, then
> it could just be the issue I described above.  Does the TEI check
> occur after it has found the SYNC byte?

Yes. it keeps repeating several times, even after finding the SYNC.

This patch makes the behavior stable:
	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/88c9318cbea60d189a9b10cbc4c5a73f8b002336

Even so, the bitstream of my test signal is 19Mbps, while the measured
speed with the valid packets is being about 3Mbps.

I'm now playing with the em28xx code that allocates URBs, as it might
be related (yet, it works properly with HVR-950).

> > I'm starting to suspect that this could be a hardware issue.
> >
> > It would be good to see if others can use it and tune to several
> > channels.
> >
> >> Ah, I didn't work at the remote controller yet. I'll handle it after
> >> doing more tests with the DVB functionality.
> >
> > Remote controller support was added.
> 
> Should be trivial - I added the support for the em2874's RC using that
> device - the RC support went upstream years ago but not the actual
> board profile.

Yes, the patch was a single line one:
	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/69473d44d1daf434f1e567f40a8247bb8056cfc3
> 
> Probably worth mentioning that while I got signal lock on ATSC, I
> didn't any significant analysis into the quality of the SNR. It's
> possible that additional optimization of the frontend is required in
> order to achieve optimal performance. 

It is unlikely to be due to some optimization, as I'm not injecting
any errors via the RF generator.

> Also, I didn't do the ClearQAM
> support yet, although that should be a fairly straightforward exercise
> (should just be another block in the set_frontend() call which sets
> the modulation appropriately).

Ok. I'll handle it after being sure that VSB is working properly.

Btw, I noticed that there are two "extra" firmwares, that aren't currently
used, defined, on your driver, at drxj_mc_vsb.h and drxj_mc_vsbqam.h.

Do you remember when those should be used? Or are them just two variants
of the main firmware, with support for just VSB and just ClearQAM?

Regards,
Mauro
