Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1LMtaMU031527
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 17:55:36 -0500
Received: from mail-in-07.arcor-online.net (mail-in-07.arcor-online.net
	[151.189.21.47])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1LMt32f022260
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 17:55:03 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Werner Braun <werner.braun@gmx.de>, video4linux-list@redhat.com
In-Reply-To: <200802202341.32370.werner.braun@gmx.de>
References: <200802202341.32370.werner.braun@gmx.de>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 23:49:09 +0100
Message-Id: <1203634149.8866.14.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] auto detection of Flytv duo/hybrid and pci/cardbus
	confusion
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

Am Mittwoch, den 20.02.2008, 23:41 +0100 schrieb Werner Braun:
> >Am Sonntag, den 17.02.2008, 21:53 +0100 schrieb Peter Missel:
> >> Greetings all!
> >> 
> >> Let me clear things up a bit.
> >> 
> >> > > First clarification, duo versus hybrid.
> >> > > Are "duo" cards equipped with two independent tuners that can both be
> >> > > used at the same time?
> >> > > Are "hybrid" cards necessarily equipped with digital and analogue 
> tuners?
> >> > > Can a two tuner card be both a duo and a hybrid, if one tuner is 
> digital
> >> > > the other is analogue and they can both be used at the same time?
> >> >
> >> 
> >> LifeView are using two vendor IDs - 4E42h for all (!) their OEMs, and their 
> >> own one for LifeView branded cards. Hence we need two PCI ID entries for 
> >> everything, each pair pointing back to the same card data.
> >> 
> >> Then, card types.
> >> 
> >> The analog-only and "hybrid" have one single tuner, for DVB-T or analog. 
> >> The "Duo" cards have two tuner frontends, one for DVB-T and the other for 
> >> analog.
> >> "Trio" cards add a DVB-S frontend, which cannot be used at the same time as 
> >> the DVB-T frontend. Like the Duo, these can run one digital and one analog 
> >> stream in parallel.
> >> 
> >> Finally, card shapes.
> >> 
> >> Each card type comes in CardBus, PCI, and MiniPCI shape. The flavors are 
> >> compatible, so that again, the PCI ID data point back to the same card 
> entry 
> >> for e.g. the PCI and CardBus Duo.
> >> 
> >> The card type/shape combinations are distinctly identified by their 
> subsystem 
> >> ID. No need to guesstimate anything.
> >> 
> >> That's the plan at least.
> >> 
> >> regards,
> >> Peter
> >
> >Hi Peter!
> >
> >Your plan is fine so far.
> >
> >We might add some more comments to group devices obviously together,
> >since those looking first time at it are a bit lost.
> >
> >For such i2c IR limits, we have your and Eddi's comments.
> >
> >Since we can't help it easily, Peter D. should suggest the older version
> >of the MSI A/D for auto detection. It won't make anything more worse on
> >that not fully clear Vivanco stuff, except Hartmut might have ideas.
> 
> >Cheers,
> >Hermann
> 
> Hermann and Peter,
> 
> I guess it was me with the Vivanco card in May/June last year. I took a time 
> out from the mailing list due to time constraints, but am back and willing to 
> help you sorting out the open issues, as far as my limited competences allow 
> for it.
> 
> The current status with my Vivanco 21057 card (4e42:3306) is:
> 
> - DVB-T works with the patches you suggested last year
> - Analog not (but did not bother anyway)
> - FM: did not try
> - Remote: dto. (I'm sitting in front of the computer anyway)
> 
> Funny thing: since Kernel 2.6.22, firmware upload does not work any longer. I 
> have to boot XP before and do a warm reboot, then DVB-T under Linux works.
> 
> Best regards
> Werner
> 

Hi,

Werner, yes it was your device coming back in mind.

We know now about the new A/D version V1.1, saw only a fuzzy picture so
far, but looks like a KS003 something for the remote and not that PIC on
the prior, different addresses, IIRC.

That one also has the supposed LNA in the tuner area visible.

Must look it up again, but for what I remember I did not find a
difference between your Vivanco card and what Peter D. has.

We also have regspy output from a recent cardbus A/D NB, but Mauro can't
test any DVB-T currently and analog is fine on that one with card=94.

However, maybe the differences of the gpio settings in DVB-T mode
visible there may help us to figure out a pattern we miss.

analog
SAA7134_GPIO_GPMODE:             8078e700   (10000000 01111000 11100111
00000000)                 
SAA7134_GPIO_GPSTATUS:           08218000   (00001000 00100001 10000000
00000000)
composite
SAA7134_GPIO_GPSTATUS:           08218000   (00001000 00100001 10000000
00000000)                  
s-video
SAA7134_GPIO_GPSTATUS:           08218000   (00001000 00100001 10000000
00000000)                 
radio                
SAA7134_GPIO_GPSTATUS:           08018000   (00001000 00000001 10000000
00000000)
dvb-t                 
SAA7134_GPIO_GPSTATUS:           08e08000   (00001000 11100000 10000000
00000000)
---------------------------------------------------------------------------------
board init: gpio is 8210000                      1000 00100001 00000000
00000000


Cheers,
Hermann








--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
