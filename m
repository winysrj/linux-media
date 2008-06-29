Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5TMdLHS012606
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 18:39:21 -0400
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5TMd8sj007998
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 18:39:08 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
In-Reply-To: <486597B6.2010300@gimpelevich.san-francisco.ca.us>
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<200803161724.20459.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.00.26.941363@gimpelevich.san-francisco.ca.us>
	<200803161840.37910.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.49.51.923202@gimpelevich.san-francisco.ca.us>
	<1206573402.3912.50.camel@pc08.localdom.local>
	<653f28469c9babb5326973c119fd78db@gimpelevich.san-francisco.ca.us>
	<loom.20080627T025843-957@post.gmane.org>
	<1214599398.2640.23.camel@pc10.localdom.local>
	<486597B6.2010300@gimpelevich.san-francisco.ca.us>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 00:35:49 +0200
Message-Id: <1214778949.8680.18.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, mchehab@infradead.org
Subject: Re: [PATCH] Re: LifeVideo To-Go Cardbus, tuner problems
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

Am Freitag, den 27.06.2008, 18:45 -0700 schrieb Daniel Gimpelevich:
> hermann pitton wrote:
> > Don't touch the spaces after commas on previous entries, add only
> > support for the saa7133 device you really tested on, run "make
> > checkpatch" and add spaces after commas ;)
> 
> Done; attached.
> 
> > Peter had more of the recent LifeView devices.
> > 
> > Seems he is pointing to some difference concerning the s-video inputs on
> > cardbus and Mini PCI devices I'm not aware of. I'm not sure what he
> > likes us to do.
> 
> As I said before, I addressed that and more before I even said anything 
> about it on the list at all.

I would like to hear his arguments nevertheless, but also saw Mauro
pulled it in already.

> > And as said, send at least relevant dmesg output when loading the driver
> > and tuner modules, preferably with i2c_scan=1 enabled.
> 
> I would need to borrow the card again to do that, and I'm not sure it 
> would be all that useful for differentiation.

OK, but this is exactly what should not happen.

> > As just seen with an early Compro saa7133, we have no safety, that not
> > later on devices appear with the same PCI subsystem, which are in fact
> > different, and have no means then to keep the auto detection working
> > without such potentially useful information.
> 
> Seems to me that the contents of the tveeprom may be a more reliable 
> mechanism.

How you mean?

Having at least "dmesg" with the eeprom dump and gpio init of the card
is the minimum prerequisite to even think about it.

Only Hauppauge provides support for what they are encoding in the
eeprom.

Philips has a standard for eeprom programming, manufacturers are advised
to go with, but do they?

For sure not.

Since win98 at least they modified eeprom content at their behalves,
most obviously are the differences for tuner enumeration, but kept the
original Philips driver file names to render each other useless by
overriding the files.

Best so far that time was, "please uninstall all other TV cards and
drivers on your system", before you try ours.

Since some time you can find something with !!! in the Philips/NXP
drivers there, _not_ to continue to do so.

> > That it has no remote and no radio support I likely already asked.
> 
> It has whatever Card 39 has.
> 
> > Send a copy directly to Mauro and Hartmut too.
> > I'll ack it, if Peter doesn't have objections.
> 
> Done.

Thanks,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
