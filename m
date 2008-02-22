Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.syd.koalatelecom.com.au ([123.108.76.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter_s_d@fastmail.com.au>) id 1JSXgx-00071p-E1
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 14:11:56 +0100
From: "Peter D." <peter_s_d@fastmail.com.au>
To: hermann pitton <hermann-pitton@arcor.de>
Date: Sat, 23 Feb 2008 00:11:39 +1100
References: <200802171428.10859.peter_s_d@fastmail.com.au>
	<200802172153.00901.peter.missel@onlinehome.de>
	<1203463532.5358.15.camel@pc08.localdom.local>
In-Reply-To: <1203463532.5358.15.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802230011.40110.peter_s_d@fastmail.com.au>
Cc: Peter Missel <peter.missel@onlinehome.de>, linux-dvb@linuxtv.org,
	video4linux-list@redhat.com
Subject: Re: [linux-dvb] auto detection of Flytv duo/hybrid and pci/cardbus
	confusion
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

On Wednesday 20 February 2008, hermann pitton wrote:
> Am Sonntag, den 17.02.2008, 21:53 +0100 schrieb Peter Missel:
> > Greetings all!
> >
> > Let me clear things up a bit.
> >
> > > > First clarification, duo versus hybrid.
> > > > Are "duo" cards equipped with two independent tuners that can both
> > > > be used at the same time?
> > > > Are "hybrid" cards necessarily equipped with digital and analogue
> > > > tuners? Can a two tuner card be both a duo and a hybrid, if one
> > > > tuner is digital the other is analogue and they can both be used at
> > > > the same time?
> >
> > LifeView are using two vendor IDs - 4E42h for all (!) their OEMs, and
> > their own one for LifeView branded cards. Hence we need two PCI ID
> > entries for everything, each pair pointing back to the same card data.
> >
> > Then, card types.
> >
> > The analog-only and "hybrid" have one single tuner, for DVB-T or
> > analog. The "Duo" cards have two tuner frontends, one for DVB-T and the
> > other for analog.
> > "Trio" cards add a DVB-S frontend, which cannot be used at the same
> > time as the DVB-T frontend. Like the Duo, these can run one digital and
> > one analog stream in parallel.
> >
> > Finally, card shapes.
> >
> > Each card type comes in CardBus, PCI, and MiniPCI shape. The flavors
> > are compatible, so that again, the PCI ID data point back to the same
> > card entry for e.g. the PCI and CardBus Duo.
> >
> > The card type/shape combinations are distinctly identified by their
> > subsystem ID. No need to guesstimate anything.
> >
> > That's the plan at least.
> >
> > regards,
> > Peter
>
> Hi Peter!
>
> Your plan is fine so far.
>
> We might add some more comments to group devices obviously together,
> since those looking first time at it are a bit lost.
>
> For such i2c IR limits, we have your and Eddi's comments.
>
> Since we can't help it easily, Peter D. should suggest the older version
> of the MSI A/D for auto detection. It won't make anything more worse on
> that not fully clear Vivanco stuff, except Hartmut might have ideas.
>
> Cheers,
> Hermann

I think that you just suggested something.  I'm going to stand at 
the side and nod my head.  ;-)  

What should I do to make it an official suggestion?  


-- 
sig goes here...
Peter D.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
