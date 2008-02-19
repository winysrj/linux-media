Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1JLLO3b026787
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 16:21:24 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1JLKuRr030909
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 16:20:56 -0500
Date: Tue, 19 Feb 2008 18:20:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: mkrufky@linuxtv.org
Message-ID: <20080219182043.7434bd56@gaivota>
In-Reply-To: <47BB3F60.2030801@linuxtv.org>
References: <20080219065109.199ee966@gaivota>
	<47BB3F60.2030801@linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: c.pascoe@itee.uq.edu.au, video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	fragabr@gmail.com
Subject: Re: [EXPERIMENTAL] cx88+xc3028 - tests are required - was: Re: Wh
 en xc3028/xc2028 will be supported?
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

> > It is not that simple. Steven patch works for DTV on PCI Nano; Christopher
> > patches for some other DiVCO boards (DTV also); my port of Markus patch
> for
> > other boards (tested by Dâniel Fraga - Analog TV).
> >   
> 
> What does one board have to do with another?  Just because these boards 
> all use xceive tuners does not mean that they should be grouped together.

No, but we have patches for all of them.

> Because the user has the ability to load cx8800 without cx88-dvb, and 
> likewise, the user has the ability to load cx88-dvb without cx8800, the 
> attach call must be fully qualified such that the other side of the 
> driver is not required to be loaded in order for the tuner to work.

If you take a look at the code, you'll see that all code is at cx88xx. This
module is loaded by cx8800, if you're using analog, or by cx8802, if you're
using cx88-dvb or cx88-blackbird.

The code initializes xc3028 before tuner attach.

> In the case of FusionHDTV5 pci nano, there will never be an attach call 
> from the analog side of the driver, since the tuner is hidden behind the 
> s5h1409's i2c gate, and analog mode is not supported with the current 
> driver.  If you set i2c_scan=1 on the PCI nano, the xceive tuner will 
> not even show up in the scan.

The proper fix is to open the i2c gate before loading tuner. This will allow
i2c_scan to work and both analog and digital modes will work. Btw, this
somewhat similar to what dvico_fusionhdtv_hybrid_init() does on cx88-cards.

I've added a patch that should open the bridge for s5h1409. Please test. 


> > We need one solution that works for all boards, not just yours.
> >
> > That's said, maybe SET_TUNER_CONFIG is being called too early. Maybe the
> way to
> > fix this is to create an special function to initialize it, that would be
> > called later by cx8800 or cx8802.
> both cx8800 *and* cx8802 need this functionality.  Please keep in mind 
> that some users do not ever use analog mode of these cards, and some 
> have even blacklisted cx8800 from loading.  This is fine, because cx8800 
> is not needed for cx88-dvb to function properly.  This is a level of 
> flexibility that we do not want to remove.
> 
> The _real_ problem is that the tuner is being attached to the bridge 
> driver in two locations -- analog side and digital side.  This problem 
> will be entirely avoided once we are attaching the tuner driver in a 
> single location, globally to the entire driver.  Such changes are 
> planned to be dealt with in tuner refactor phase 4, but I am still 
> dealing with refactoring the prerequisites for this scenario, in phase 3 
> -- all will come in due time, but for now, we must provide a fully 
> qualified attachment call each time we attach a tuner driver.

It would be really nice to avoid having to attach it later, on cx88-dvb,
although the double attach won't hurt. I'm not sure on how you want to avoid
this.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
