Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1HKrobf015376
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 15:53:50 -0500
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1HKrJpR031015
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 15:53:19 -0500
From: Peter Missel <peter.missel@onlinehome.de>
To: video4linux-list@redhat.com
Date: Sun, 17 Feb 2008 21:53:00 +0100
References: <200802171428.10859.peter_s_d@fastmail.com.au>
	<1203279545.3473.184.camel@pc08.localdom.local>
In-Reply-To: <1203279545.3473.184.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802172153.00901.peter.missel@onlinehome.de>
Cc: linux-dvb@linuxtv.org, "Peter D." <peter_s_d@fastmail.com.au>
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

Greetings all!

Let me clear things up a bit.

> > First clarification, duo versus hybrid.
> > Are "duo" cards equipped with two independent tuners that can both be
> > used at the same time?
> > Are "hybrid" cards necessarily equipped with digital and analogue tuners?
> > Can a two tuner card be both a duo and a hybrid, if one tuner is digital
> > the other is analogue and they can both be used at the same time?
>

LifeView are using two vendor IDs - 4E42h for all (!) their OEMs, and their 
own one for LifeView branded cards. Hence we need two PCI ID entries for 
everything, each pair pointing back to the same card data.

Then, card types.

The analog-only and "hybrid" have one single tuner, for DVB-T or analog. 
The "Duo" cards have two tuner frontends, one for DVB-T and the other for 
analog.
"Trio" cards add a DVB-S frontend, which cannot be used at the same time as 
the DVB-T frontend. Like the Duo, these can run one digital and one analog 
stream in parallel.

Finally, card shapes.

Each card type comes in CardBus, PCI, and MiniPCI shape. The flavors are 
compatible, so that again, the PCI ID data point back to the same card entry 
for e.g. the PCI and CardBus Duo.

The card type/shape combinations are distinctly identified by their subsystem 
ID. No need to guesstimate anything.

That's the plan at least.

regards,
Peter

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
