Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1NKCDxn018098
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 15:12:13 -0500
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1NKBa0Y011035
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 15:11:37 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: "Peter D." <peter_s_d@fastmail.com.au>
In-Reply-To: <200802230011.40110.peter_s_d@fastmail.com.au>
References: <200802171428.10859.peter_s_d@fastmail.com.au>
	<200802172153.00901.peter.missel@onlinehome.de>
	<1203463532.5358.15.camel@pc08.localdom.local>
	<200802230011.40110.peter_s_d@fastmail.com.au>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 21:05:19 +0100
Message-Id: <1203797119.4664.4.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: linux-dvb@linuxtv.org, video4linux-list@redhat.com
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

Hi,

Am Samstag, den 23.02.2008, 00:11 +1100 schrieb Peter D.:
> On Wednesday 20 February 2008, hermann pitton wrote:
> > Am Sonntag, den 17.02.2008, 21:53 +0100 schrieb Peter Missel:
> > > Greetings all!
> > >
> > > Let me clear things up a bit.
> > >
> > > > > First clarification, duo versus hybrid.
> > > > > Are "duo" cards equipped with two independent tuners that can both
> > > > > be used at the same time?
> > > > > Are "hybrid" cards necessarily equipped with digital and analogue
> > > > > tuners? Can a two tuner card be both a duo and a hybrid, if one
> > > > > tuner is digital the other is analogue and they can both be used at
> > > > > the same time?
> > >
> > > LifeView are using two vendor IDs - 4E42h for all (!) their OEMs, and
> > > their own one for LifeView branded cards. Hence we need two PCI ID
> > > entries for everything, each pair pointing back to the same card data.
> > >
> > > Then, card types.
> > >
> > > The analog-only and "hybrid" have one single tuner, for DVB-T or
> > > analog. The "Duo" cards have two tuner frontends, one for DVB-T and the
> > > other for analog.
> > > "Trio" cards add a DVB-S frontend, which cannot be used at the same
> > > time as the DVB-T frontend. Like the Duo, these can run one digital and
> > > one analog stream in parallel.
> > >
> > > Finally, card shapes.
> > >
> > > Each card type comes in CardBus, PCI, and MiniPCI shape. The flavors
> > > are compatible, so that again, the PCI ID data point back to the same
> > > card entry for e.g. the PCI and CardBus Duo.
> > >
> > > The card type/shape combinations are distinctly identified by their
> > > subsystem ID. No need to guesstimate anything.
> > >
> > > That's the plan at least.
> > >
> > > regards,
> > > Peter
> >
> > Hi Peter!
> >
> > Your plan is fine so far.
> >
> > We might add some more comments to group devices obviously together,
> > since those looking first time at it are a bit lost.
> >
> > For such i2c IR limits, we have your and Eddi's comments.
> >
> > Since we can't help it easily, Peter D. should suggest the older version
> > of the MSI A/D for auto detection. It won't make anything more worse on
> > that not fully clear Vivanco stuff, except Hartmut might have ideas.
> >
> > Cheers,
> > Hermann
> 
> I think that you just suggested something.  I'm going to stand at 
> the side and nod my head.  ;-)  
> 
> What should I do to make it an official suggestion?  
> 

the usual ;)

Create a patch against the current v4l-dvb master repo.

Try README.patches. Send it and add the Signed-off-by line.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
