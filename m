Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ELBXSG008759
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 17:11:33 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ELBHFg017475
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 17:11:17 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: stuart <stuart@xnet.com>
In-Reply-To: <48F4F552.7060800@xnet.com>
References: <48CD6F11.8020900@xnet.com>
	<1221431625.4566.5.camel@pc10.localdom.local>
	<48CEC847.8030404@xnet.com> <48F4AD7B.7050802@xnet.com>
	<1224011459.5486.19.camel@pc10.localdom.local>
	<48F4F552.7060800@xnet.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 23:04:42 +0200
Message-Id: <1224018283.5486.28.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Dwaine Garden <dwainegarden@rogers.com>, video4linux-list@redhat.com
Subject: Re: KWorld 120 IR control?
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


Am Dienstag, den 14.10.2008, 14:38 -0500 schrieb stuart:
> 
> hermann pitton wrote:
> > Hi,
> > 
> > Am Dienstag, den 14.10.2008, 09:32 -0500 schrieb stuart:
> >> stuart wrote:
> >>> hermann pitton wrote:
> >>>> stuart wrote:
> >>>>> hermann pitton wrote:
> >>>>> Hi Stuart,
> >>>>>
> >>>>> Am Sonntag, den 14.09.2008, 15:07 -0500 schrieb stuart:
> >>>>>> Hi...
> >>>>>>
> >>>>>> This is my monthly (humm, more like quarterly) bump to see if anyone 
> >>>>>> has looked at (or can tell me what to do with) the KWorld 120 
> >>>>>> video4linux drivers when it comes to getting the IR hardware to work.
> >>>>>>
> >>>>>> I would think, by now, there are a lot of these cards out there.  
> >>>>>> Were not the KWorld 110 and 115 ATSC tuners popular here?  And 
> >>>>>> haven't they been replaced by the KWorld 120?  If so, what are people 
> >>>>>> doing for IR?
> >>>>>>
> >>>>>> ...thanks
> >>>>>>
> >>>>> Mauro, better we all of course, need to review Brian Rogers latest patch
> >>>>> from Thursday on this to get it in.
> >>>>>
> >>>>> Based on this, likely Dwaine Garden is the one who can further proceed
> >>>>> for the Kworld stuff too.
> >>>>>
> >>>>> Cheers,
> >>>>> Hermann
> >>>> Hey, thanks to all who have contributed to the KWorld-120 v4l driver! If 
> >>>> it wasn't obvious, I've been enjoying the sound and video from my v4l 
> >>>> driven KWorld-120 for months now.
> >>>>
> >>>> So, are these IR remote control patches in Staging (the v4l somewhat 
> >>>> stable pre-release version).  I've pulled and compiled from that repo 
> >>>> before - no problem if that's where the new IR code is.
> >>>>
> >>>> ...thanks
> >>> there have been patches on the lists for KS003 and KS007 i2c driven
> >>> remotes, but nothing is in yet.
> >>>
> >>> Brian Rogers current version likely will make it in now for the saa7134
> >>> MSI TV@nywhere, based on Henry Wong's old patch.
> >>>
> >>> Mauro will have a look at it again next week after Portland.
> >>>
> >>> It likely can provide the base for other cards and drivers too then.
> >>>
> >>> Cheers,
> >>> Hermann
> >>
> >> Re: KWorld 120 IR control "Montly Bump"...
> >>
> >> Sorry to bother you guys again.  But some Brick and Mortar Frys stores 
> >> (on line it's still the full $60) have this card on sale.
> >>
> >> Perhaps if you could tell me (us) what to watch for in the different v4l 
> >> repositories we could track this feature our selves.
> >>
> >> ...thanks
> >>
> > 
> > hmm, you called it successor/replacement of the Kworld saa7134 ATSC
> > cards and I thought this would indicate that there is a KS003 or KS007
> > i2c controller with 16 pins at 0x30.
> > 
> > This is likely wrong.
> > 
> > The patch for the KS003 on the saa7134 MSI TV@nywhere is in v4l-dvb now.
> > 
> > I think it was not reported yet, what IR controller is on the ATSC 120.
> > Maybe it is some known stuff and support can be added easily, but dunno.
> > 
> > Please be patient, can't tell if Mauro had any time to look at the
> > remote at all so far.
> > 
> > You can try to identify the remote and controller chip by searching
> > through http://www.bttv-gallery.de.
> > 
> > You find already supported Kworld cards then in cx88-input.c,
> > saa7134-input.c ...
> > 
> > Cheers,
> > Hermann
> > 
> 
> Hi Hermann...
> 
> Thanks for taking the time to write back...
> 
> There is extensive information about the Kworld 120 here:
> http://www.mythtv.org/wiki/index.php/Kworld_ATSC_120
> ...we've added information to it down through the months.
> 
> [From the above page:]
> ---------------------
> Major components used
> 
>      * Xceive XC3028 (tuner & analog IF demodulator)
>      * Samsung S5H1409 (digital demodulator, Conexant CX24227 compatible)
>      * Conexant cx23880 (A/V Decoder & PCI bridge)
> ---------------------
> Status
> 
> As of 27 Mar 2008 and revision 7448 of the main v4l-dvb repository, this 
> card can be used in both analog and digital ATSC modes via a set of 
> experimental drivers. The FM radio, composite video, and S-Video inputs 
> all work when the card is initialized into analog mode. Due to a 
> resource conflict in the driver caused by this card's architecture, a 
> reboot is necessary to switch between analog and ATSC modes. The cause 
> of this issue has been located, and work is ongoing to fix it.
> 
> The remote control is not currently supported in any mode, yet.
> 
> The Line-out jack is somewhat functional, but is not considered ready to 
> use, yet.
> ---------------------

Hi Stuart,

thanks, I tried to look it up better this time and saw this already at
the linuxtv wiki. Also found a reasonable picture, but not good enough.
At least no 16 pins KS007 so far.

We must identify the IR controller chip.

Guessing doesn't help any further.

The only thing you can blindly try, see the v4l-wiki about remotes, is
to start with a mask of 0x0 for key codes and hope something happens on
the GPIOs.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
