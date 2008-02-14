Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1EMx26k006479
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 17:59:02 -0500
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1EMweu2003054
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 17:58:41 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <47B4B9AE.5010907@t-online.de>
References: <47B392A5.2030908@t-online.de>
	<1202986913.5036.3.camel@pc08.localdom.local>
	<1203005937.5871.12.camel@pc08.localdom.local>
	<47B4B9AE.5010907@t-online.de>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 23:53:59 +0100
Message-Id: <1203029639.6805.66.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	LInux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Mdeion / Creatix CTX948 DVB-S driver is ready	for
	testing
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Hartmut,

Am Donnerstag, den 14.02.2008, 22:59 +0100 schrieb Hartmut Hackmann:
> Hi, Hermann
> 
> I am a bit confused....
> 
> hermann pitton schrieb:
> > Hi,
> > 
> > Am Donnerstag, den 14.02.2008, 12:01 +0100 schrieb hermann pitton:
> >> Am Donnerstag, den 14.02.2008, 02:00 +0100 schrieb Hartmut Hackmann: 
> >>> Hi, folks
> >>>
> >>> In my personal repository:
> >>>   http://linuxtv.org/hg/~hhackmann/v4l-dvb-experimental/
> >>> you will find a driver that supports this card, DVB-T and DVB-S
> >>>
> >>> It might also work for
> >>> - one section of the MD8800
> >>> - similar boards based on saa713x, tda10086, tda826x, isl6405
> >>>
> >>> The board will show up as MD8800. According to Hermann, the configurations
> >>> for analog TV and DVB-T are identical.
> >>> If you want to use the board with DVB-S, you will need to load the
> >>> saa7134-dvb module with the option "use_frontend=1". The default 0 is
> >>> DVB-T. For those who got the board from a second source: don't forget
> >>> to connect the 12v (the floppy supply) connector.
> >>>
> >>> I don't have a dish, so i depend on your reports. To get the MD8800
> >>> running, i need a volunteer who does the testing for me. He should be able
> >>> to apply patches, compile the driver and read kernel logs.
> >>>
> >>> Good luck
> >>>   Hartmut
> >>>
> >> Hartmut,
> >>
> >> great job, thank you very much!
> >>
> >> Can't wait, result of a first voltage measurement on the md8800 Quad.
> >>
> >> The upper LNB connector associated to the second saa7134 16be:0008
> >> device has correct voltage.
> >>
> >> Since my stuff is not in the original green PCI slot and I have only the
> >> first 16be:0007 device active, can't test much more for now here.
> > 
> > back on the machine and thinking about it twice ...
> > 
> > The Quad works for me as well on the upper LNB connector, despite of
> > that I previously used the lower one successfully with RF loopthrough
> > from an external receiver.
> > 
> > So, in case of the Quad, just let it be autodetected and try on the
> > first adapter and upper LNB connector.
> > 
> So this one works as well, great! But which one is it?
> Please tell me the minor device id. I need to use it to separate the 2 sections.
> i will need to control the other one in a very different way.

Seems default is some RF loopthrough.

I'll need to measure too against loopthrough conditions, but for sure
voltage is only on the upper connector and previously with the RF feed
from the external receiver the lower connector was fine enough.

No voltage in any previous testing and the 12Volts were always
connected.

Both slightly different Quads from different fabs work as well as the
CTX948. In my case it is the 16be:0007 and to the 16be:0008 I have no
access.

> > Even more fun :)
> > 
> > Cheers,
> > Hermann
> > 
> >> People with the card in the original Medion PC could set
> >> "options saa7134-dvb use_frontend=1 debug=1"
> >> in /etc/modprobe.conf and then do "depmod -a".
> >>
> >> The Syntek v4l usb stkwebcam still produces a compilation error and
> >> needs to be disabled in "make xconfig" or something else.
> >>
> Hm, i didn't have any compile problems ...

This happens on an almost given up FC5 with some 2.6.20 ...

> >> After "make" it is best to do "make rmmod" on top of your
> >> v4l-dvb-experimental first. Those new to the v4l-dvb development stuff
> >> might do also "make rminstall" and then check that no *.ko is left
> >> in /lib/modules/kernel_in_use/kernel/drivers/media/*
> >> Especially the old video_buf.ko in the video dir needs to be removed.
> >> Check with "ls -R |grep .ko" and then "make install".
> >>
> >> Now I suggest to "modprobe saa7134 card=117,96"
> >> In that case DVB-T is supported on the lower antenna connector and first
> >> adapter and DVB-S on the upper LNB connector and second adapter.
> >>
> >> Or to have it simple, it is safe to "make rmmod" and
> >> "modprobe saa7134 card=5,96 tuner=54,54"
> >> This way on the first device is only analog TV enabled, don't forget to
> >> use it first to have good DVB-T reception later anyway, and the only
> >> frontend is the DVB-S one in question for testing.
> >>
> Why? the cards should be autodetected. Or is there a variant of the 948 with
> a device id different from 16be:000d?
> It should be possible to give a list to the use_frontend=xx option.
> Something like use_frontend=0,1,0 which should select DVB-S only for the
> 2nd instance. Am i wrong?
> Of corse you will need to select the right frontend which is not easy with
> some applications.
> 
> <snip>

This was all about first ideas on the Quads.
On the CTX948 there is no problem _at all_!

For the Quad I took my first idea back and said, just let it be auto
detected and take the first frontend then and the upper LNB connector.

Sorry for confusion, but it is still a little ...

> But thank you for your fast reporting!
> 
> Another issue: You have some patches waiting for integration. We can use
> my other repository for this.

We might be already through here and you might like to commit first ;)

> Best regards
>    Hartmut

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
