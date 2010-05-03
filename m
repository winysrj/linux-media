Return-path: <linux-media-owner@vger.kernel.org>
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:56980 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932433Ab0ECPin (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 11:38:43 -0400
Message-ID: <4BDEEE35.6040308@gmail.com>
Date: Tue, 04 May 2010 01:39:33 +1000
From: Jed <jedi.theone@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ideal DVB-C PCI/e card?
References: <4BDE5AA1.1050000@gmail.com> <87pr1dbf1q.fsf@nemi.mork.no>
In-Reply-To: <87pr1dbf1q.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Excellent response, & thank-you for so much detail!
I apologise for my anaemic response, but it is very late here now, 
that's my excuse anyway! ;)

Just curious, why did you pick VDR over MythTV?
I would rather use the later + OSCam (maybe) if feasible.

Thanks again for the excellent feedback, it's heartening to know there's 
other videoguard2 users out there!

Good-night.

On 3/05/10 5:49 PM, Bjørn Mork wrote:
> [answering this in private since any details about softcams etc usually
> is unwanted on mailinglists]
>
> Jed<jedi.theone@gmail.com>  writes:
>
>> I was wondering if someone could recommend a decent DVB-C tuner card?
>> Ideally it would be a dual DVB-C card, but I'm not sure they exist?!
>
> I've been looking for the same, but not been able to find one.  The
> closest is the foilware from Netup, but it is probably going to be too
> expensive when/if it is available anyway.
>
> Nor does there seem to be any DVB-C PCIe cards or USB sticks with Linux
> support.  There are rumours about working external USB boxes.  I haven't
> verified those, as I didn't really want any external box adding to the
> cable mess...
>
>> I have a subscription to a PayTV provider here in Australia that uses
>> an encryption scheme called NDS or Videoguard2.
>> So I'll also need the right card reader and combo of software in order
>> to decrypt and then capture.
>
> I'm doing much of the same here, also using NDS/Videoguard2.  Unless
> I've missed something, this excludes using any (official) hardware CAM
> so  you don't have to worry about CI slots :-)
>
> I am using two budget cards ("budget" is a must, as they are the cards
> capable of delivering a full TS to the host):
>
> 1) TerraTec Cinergy C PCI:
>
> bjorn@canardo:~$ lspci -vvnns 5:0
> 05:00.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
>          Subsystem: TERRATEC Electronic GmbH Device [153b:1178]
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>          Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium>TAbort-<TAbort+<MAbort->SERR-<PERR- INTx-
>          Latency: 64 (2000ns min, 63750ns max)
>          Interrupt: pin A routed to IRQ 16
>          Region 0: Memory at fcfff000 (32-bit, prefetchable) [size=4K]
>          Kernel driver in use: Mantis
>          Kernel modules: mantis
>
> 2) Mystique CaBiX-C2 (available from www.dvbshop.net):
>
> bjorn@canardo:~$ lspci -vvnns 5:1
> 05:01.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01)
>          Subsystem: KNC One Device [1894:0022]
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>          Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
>          Latency: 64 (3750ns min, 9500ns max)
>          Interrupt: pin A routed to IRQ 17
>          Region 0: Memory at feaffc00 (32-bit, non-prefetchable) [size=512]
>          Kernel driver in use: budget_av
>          Kernel modules: budget-av
>
>
>
> The TerraTec card is working very well, but requires the mantis driver
> which entered linux in 2.6.33.  This means that there are few
> distributions providing it at the moment, as most of them are going for
> 2.6.32.
>
> The Mystique card also does it's job, but I have had a few problems with
> the driver when some other part of the system is failing (in my case, a
> SATA disk).  The driver seems to be very fragile wrt timeouts, and is
> far too eager to fill the log with identical useless messages.  I'm
> planning to fix this as soon as I get around to it, but...
>
> If I were to buy the cards a second time, then I think I would buy two
> Terratec cards.
>
> For smartcard reader I am using a simple and cheap reader from OmniKey:
>
> bjorn@canardo:~$ lsusb -s 5:2
> Bus 005 Device 002: ID 076b:3021 OmniKey AG CardMan 3121
>
>
> I've also tested with another CCID USB reader, SCM SCR331, which also
> worked just fine.  What you want to look for is a reader supported by
> libccid ("apt-cache show libccid" in Debian/Ubuntu will show you the
> list).  You may also want to check out which voltages the readers
> support.  Modern cards tend to lower their Vcc all the time, and there
> are a few stories of burnt cards (I assume that's because of running a
> 3.3 V card in a reader only capable of providing 5 V).
>
>
>> This stuff I can mostly work out for myself.....
>> But if you have any knowledge or experience in that area, then I'd be
>> most appreciative if you can share.
>> As it definitely isn't for technical minnows!
>>
>> Oh and in case you're worried, doing this sort of thing is not -yet-
>> illegal in Australia.
>
> That's the situation here in Norway as well, provided that you actually
> pay for the subscription.   At least that's my interpretation of the
> legal status :-)
>
> When I started this project, I briefly tried sasc-ng.  I did work OK but
> I disliked the need to use the dvbloopback module.  Mostly a principle
> wrt out-of-tree drivers.  But I would probably have continued to use it
> if I hadn't discovered that VDR provided everything I needed (I
> initially rejected it because I got the wrong impression that it
> couldn't run on a headless box, which is what I do).  The VDR softcam
> plugin eliminates the need for any in-kernel hacks.  It's all just
> userspace.
>
> So now I am happily using VDR with vdr-sc.  I could not make the
> videoguard2 smartcard driver for vdr-sc working (didn't try hard -
> probably only a minor configuration problem on my side), but am instead
> using vdr-sc as a cardclient against oscam.  I've built oscam with PCSC
> support so that all card communication goes through pcscd.
>
> This setup works for me, but I'm still not 100% sure that card updates
> are working.  There is something weird with the interface between vdr-sc
> and oscam.  So there are certainly some bugs to sort out, both in vdr-sc
> and in oscam.  But one of my main reasons for choosing these over other
> options is the open source.  This does make it possible to fix bugs and
> contribute.  And both packages do have active developers who respond to
> the reports and suggestions they get.
>
> The list of mostly working features:
>   - decrypting multiple channels simultaneously. Of course limited to the
>     two frequecies which I can tune, but there doesn't seem to be any
>     other limit on the number of channels I can use
>   - both HD and SD decryption (also when using a subscription card from a
>     SD only STB!)
>   - automatic configuration of the smartcard/STB mating.  This is
>     currently a bit flakey but work is on the way to improve it.  You
>     can always work around it by configuring "BoxID" manually, so it's
>     not a big problem anyway
>
> Hope this helps.   Looking forward to hearing how things go. The more
> open source Videoguard2 users we get, the better :-)
>
>
> Bjørn
>
