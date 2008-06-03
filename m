Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m530mJEE013793
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 20:48:19 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m530m5kP021893
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 20:48:06 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080602175147.05844edf@gaivota>
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
	<20080530145830.GA7177@opus.istwok.net>
	<37219a840806010018m342ff1bh394248e62e0a8807@mail.gmail.com>
	<20080601190328.GA23388@opus.istwok.net>
	<37219a840806011210h6c7b55b0tc4bcfec1bcf3ad9b@mail.gmail.com>
	<1212353180.3512.13.camel@pc10.localdom.local>
	<37219a840806021304t605b67e2hed8f3db1a4912955@mail.gmail.com>
	<20080602175147.05844edf@gaivota>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 02:45:50 +0200
Message-Id: <1212453950.2574.11.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: David Engel <david@istwok.net>, video4linux-list@redhat.com,
	Jason Pontious <jpontious@gmail.com>, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: Kworld 115-No Analog Channels
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


Am Montag, den 02.06.2008, 17:51 -0300 schrieb Mauro Carvalho Chehab:
> On Mon, 2 Jun 2008 16:04:49 -0400
> "Michael Krufky" <mkrufky@linuxtv.org> wrote:
> 
> > On Sun, Jun 1, 2008 at 4:46 PM, hermann pitton <hermann-pitton@arcor.de> wrote:
> > > Am Sonntag, den 01.06.2008, 15:10 -0400 schrieb Michael Krufky:
> > >> On Sun, Jun 1, 2008 at 3:03 PM, David Engel <david@istwok.net> wrote:
> > >> > On Sun, Jun 01, 2008 at 03:18:45AM -0400, Michael Krufky wrote:
> > >> >> On Fri, May 30, 2008 at 10:58 AM, David Engel <david@istwok.net> wrote:
> > >> >> > I ran into a similar (probably the same) problem last week.  My search
> > >> >> > of the list archives revealed a known tuner detection regression in
> > >> >> > 2.6.25.  It's supposed to be fixed in Mercurial but I didn't test it
> > >> >> > because it was simpler to just go back to 2.6.24.x.  I don't know why
> > >> >> > the fix hasn't made it into 2.6.25.x yet.
> > >> >>
> > >> >> Which fix?  What problem does it fix?  More details, please :-)
> > >> >
> > >> > When I ran into the problem last week, I went searching and ran across
> > >> > this thread:
> > >> >
> > >> > https://www.redhat.com/mailman/private/video4linux-list/2008-April/msg00221.html
> > >>
> > >> This is in the private archives...  Do you have a link from gmane or
> > >> some other public archive?
> > >
> > > it is the first posting from Ian Pickworth there, followed by an reply
> > > by me, since Ian helped on several cx88 norm setting issues and also
> > > with the tda9887 radio support, you might not remember anymore, but to
> > > leave him without reply is beyond my scope.
> > >
> > > The bug was confirmed then by Gert, who did the initial empress encoder
> > > support.
> > >
> > > However, Mauro fixed the eeprom detection then within all that immense
> > > traffic and work during the last merge window open.
> > >
> > > Remaining serious issues are, since 2.6.25 the users can't select the
> > > PAL/SECAM subnorms anymore after the ioctl2 conversion, which is an
> > > extremely bad idea on saa713x, and further it is more improved on 2.6.26
> > > now, that they are not even to set the tuner type anymore, without to
> > > change it in the source, which is another extremely bad idea, as I
> > > posted several times.
> > >
> > > I don't blame anyone, Hartmut and me were also too much focused on the
> > > outstanding DVB-S stuff that time and did not care much about analog,
> > > but the driver is in serious troubles now and I'm a little bit grumpy,
> > > or at least not in the mood to explain again and again were we are ...
> > 
> > Hermann,
> > 
> > Please don't top-post.

No, I didn't.

I only used/abused exactly this to point at the outstanding issues
again, or do you seriously assume that I don't know that the Kworld ATSC
stuff is not within eeprom tuner detection issues on saa7134?

> > 
> > David Engel's problem is unrelated to the issue that you describe -- I
> > will address his issue in a separate email.
> > 
> > The issue that you are describing is due to the change in load order
> > during initialization.  Mauro made this change very late in the
> > 2.6.25-rc stages, against my recommendation.
> > 
> > I am staying away from this issue, since I advised against that
> > change.  So, I defer to Mauro (cc added).
> > 
> > Mauro, are you aware that this is still an issue?
> > 
> > ...some helpful hints:
> > 
> > this will not work unless we do the following, in this order:
> > 
> > #1 bring up the i2c bus
> > #2 allow tveeprom.ko client module to attach, so that
> > (bridgedriver)_card_setup can read tuner info from tveeprom
> > #3 allow tuner.ko client to attach
> > 
> > We must not call SET_TYPE until after all of the above have completed.
> 
> This won't work, since tveeprom and tuner can be compiled in kernel or they may
> already be loaded (for example, if you have two boards on your machine with
> different bridges, the second bridge setup will run after the load of those
> modules). 
> 
> We can postpone the call of SET_TYPE, or allow that a second SET_TYPE to be
> accepted, but we can't make any assumption about the module load order.
> 
> If, previously, the driver were assuming a that I2C drivers were compiled
> as module, and a certain load order, the driver were already broken.

Yes, this was tested by me and confirmed and posted.

Unluckily I don't have enough free PCI slots currently anymore to trace
the two analog only cards I have with tuner eeprom detection 24/7.

> The problem is not related to when a driver is loaded, but when I2C binding
> happens.
> 
> Since we are using the old probe methods on most boards, after I2C is
> initialized by the bridge, any existing i2c driver will try to bind on it.
> Also, there's no control on the order that each i2c driver will be attached to
> the i2c bus.
> 
> The proper fix is to migrate all drivers to the way that ivtv and cx18 are
> probing i2c devices. This way, we can control when I2C bind for tveeprom and
> for tuner will happen. So, we can do what you are meaning: bind first tveeprom,
> then do the proper card setup and bind the tuner.

Mike, Mauro, thanks for confirming that it is not unnoticed and
forgotten.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
