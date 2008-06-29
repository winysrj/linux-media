Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5TNd5CY030247
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 19:39:05 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5TNcqRR028825
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 19:38:52 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
In-Reply-To: <1214778949.8680.18.camel@pc10.localdom.local>
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
	<1214778949.8680.18.camel@pc10.localdom.local>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 01:35:39 +0200
Message-Id: <1214782539.8680.33.camel@pc10.localdom.local>
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


Am Montag, den 30.06.2008, 00:35 +0200 schrieb hermann pitton:
> Hi,
> 
> Am Freitag, den 27.06.2008, 18:45 -0700 schrieb Daniel Gimpelevich:
> > hermann pitton wrote:

[snip]
> 
> > > That it has no remote and no radio support I likely already asked.
> > 
> > It has whatever Card 39 has.

Oh, forgot to point at this, since should be clear.

You can't say anything about it ...

You just throw back the limited detection capabilities we have on this
and say _we_ are all fine, but this is a tautolgie.

You/we don't know if it is a saa7133/35 or 7131e bridge.

You/we don't know if it is a tda8275, tda8275c1, tda8275a or tda8275ac1
tuner.

What about, when it comes to introduce some chip specific audio
capabilities not yet turned on!

Some will claim soon or later on LKLM, that we have something
ambigious/fishy here.

To make it short, the patch this way is not acked by me and Mauro can
look it up then.

Cheers,
Hermann








--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
