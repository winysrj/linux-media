Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46679 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZKHCku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 21:40:50 -0500
Received: by bwz27 with SMTP id 27so2397222bwz.21
        for <linux-media@vger.kernel.org>; Sat, 07 Nov 2009 18:40:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <702870ef0911070328v4d39afd9kc2469fb3e78ba203@mail.gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
	 <829197380911051304g1544e277s870f869be14e1a18@mail.gmail.com>
	 <25126.64.213.30.2.1257464759.squirrel@webmail.exetel.com.au>
	 <829197380911051551q3b844c5ek490a5eb7c96783e9@mail.gmail.com>
	 <39786.64.213.30.2.1257466403.squirrel@webmail.exetel.com.au>
	 <40380.64.213.30.2.1257474692.squirrel@webmail.exetel.com.au>
	 <829197380911051843r4a55bddcje8c014f5548ca247@mail.gmail.com>
	 <702870ef0911061659q208b73c3te7d62f5a220e9499@mail.gmail.com>
	 <829197380911061743o64c4661gfdee5c65f680904e@mail.gmail.com>
	 <702870ef0911070328v4d39afd9kc2469fb3e78ba203@mail.gmail.com>
Date: Sat, 7 Nov 2009 21:40:54 -0500
Message-ID: <829197380911071840l41fbaa8et58641ea99ad79b94@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: Robert Lowery <rglowery@exemail.com.au>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 7, 2009 at 6:28 AM, Vincent McIntyre
<vincent.mcintyre@gmail.com> wrote:
> Hi Devin
>
>> please confirm exactly which of your boards is not working.
>
> Sorry for being unclear.
>
> I have three test setups I am working with, all on the same computer.
> 1. Ubuntu Hardy, kernel 2.6.24-23-rt and drivers from v4l-dvb tip.
> 2. Ubuntu Karmic, kernel 2.6.31-14-generic, stock Ubuntu drivers.
> 3. Ubuntu Karmic, kernel 2.6.31-14-generic, v4l-dvb tip.
>
> Setups 2 & 3 are the same install, on a separate hard disk from setup 1.
> I change between 2 & 3 by installing the v4l modules or restoring the
> ubuntu stuff from backup. (rsync -av --delete).
>
> The computer has two DVB-T cards.
>
> First device is the same as Robert's, I believe. It has two tuners. lsusb gives:
> Bus 003 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
> (ZL10353+xc2028/xc3028) (initialized)
> Bus 003 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
> (ZL10353+xc2028/xc3028) (initialized)
> I have a 'rev1' version of this board.
>
>
> Second device is DViCO FusionHDTV Dual Digital Express, a PCIe card
> based on cx23885[1] It also has two tuners. lspci gives:
> 04:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
> CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
>        Subsystem: DViCO Corporation Device [18ac:db78]
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 19
>        Region 0: Memory at 90000000 (64-bit, non-prefetchable) [size=2M]
>        Capabilities: <access denied>
>        Kernel driver in use: cx23885
>        Kernel modules: cx23885
>
> With Robert's patch compiled in:
>  * On setup 1
>  I am able to tune both cards and there are no errors from the cxusb module
>   or dvb-usb anymore.
>   I tested each of the four tuners, by running dvbscan with
> appropriate arguments to
>   select the right /dev/dvb/adapterN.
>
>   I just realised I should probably revert the patch and check which
> tuners show the
>   original problem. Before I was taking the default choice (adapter0,
> I think) which is
>    one of lhe Dual Digital 4 tuners.
>
>  * I have yet to test setup 2,
>   I have built the patched kernel module but the box is back 'in
> production' right now.
>   I plan to test tomorrow.
>
>  * On setup 3. I attempted to tune using dvbscan, w_scan and vlc.
>   Again, I was not specific about which tuner the applications should use.
>   So to answer your question, I think it is the lsusb id 0fe9:db78
> that is unable to tune.
>   I will check the tuners individually, tomorrow.
>
>   My impression was that the failures were because of API differences
> between the
>   applications (all provided as part of the ubuntu install) and the
> V4L modules. I have
>   not tried to build v4l-apps from the mercurial tree.
>
> So, I hope this makes things clearer. Happy to run tests if you have
> any time to look at this.

Hello Vince,

I think the next step at this point is for you to definitively find a
use case that does not work with the latest v4l-dvb tip and Robert's
patch, and include exactly what kernel you tested with and which board
is having the problem (including the PCI or USB ID).

At this point, your description seems a bit vague in terms of what is
working and what is not.  If you do the additional testing to narrow
down specifically the failure case you are experiencing, I will see
what I can do.

That said, I'm preparing a tree with Robert's patch since I am pretty
confident at least his particular problem is now addressed.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
