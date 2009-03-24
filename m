Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:50813 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759252AbZCXNCf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 09:02:35 -0400
Date: Tue, 24 Mar 2009 06:02:32 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [REVIEWv2] bttv v4l2_subdev conversion
In-Reply-To: <200903240819.26398.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903240508460.28292@shell2.speakeasy.net>
References: <200903192124.52524.hverkuil@xs4all.nl> <200903210949.21924.hverkuil@xs4all.nl>
 <Pine.LNX.4.58.0903231724300.28292@shell2.speakeasy.net>
 <200903240819.26398.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 24 Mar 2009, Hans Verkuil wrote:
> On Tuesday 24 March 2009 01:38:04 Trent Piepho wrote:
> > On Sat, 21 Mar 2009, Hans Verkuil wrote:
> > > On Saturday 21 March 2009 06:56:18 Trent Piepho wrote:
> > > > It seems like one could still disable loading modules for that bttv
> > > > might think it needs.  When you're testing modules that have not been
> > > > installed, any calls to request_module() will load the wrong version
> > > > and cause all sorts of breakage.  It should still be possible to
> > > > disable any attempts by the driver to do that.
> > >
> > > The idea is to either let the driver use the card definition info and
> > > probing to detect the audio chip, or to tell it which one to load
> > > explicitly. That's sufficient in my opinion.
> >
> > I still think it should be possible to prevent the driver from calling
> > request_module().  If you're trying to test drivers then a call to
> > request_module can cause a kernel oops.
>
> You mean you want to be able to load the driver without loading any audio
> module? Or do you mean something else? It must be me, but I still don't

Without loading a module that has not already been loaded.

> understand what scenario you are trying to prevent. Note that just calling
> request_module() doesn't do anything but load the module in memory. Without
> autoprobing it will never attach to a i2c adapter.

It loads the module that is located in /lib/modules/`uname -r` into memory.
If you are testing modules are are NOT installed there, then it loads the
*wrong* module.  It can cause an opps if say a v4l core struct has changed
sizes between the module installed in /lib and the modules that have been
loaded with insmod.

> > > No.  If you add a new card definition and that card has a saa6588,
> > > then this bit should be available for you.  Otherwise I just know
> > > that people will just skip that chip ('Hey!  I can't set it!  Oh,
> > > I'll skip it then...') instead of asking for adding saa6588 support.
> > >
> > > The only reason it's not used is that the one board that can have it
> > > has to test for it dynamically as it is an add-on.
> >
> > Do you really think anyone is going to add a new card defition to bttv
> > that has a saa6588?  All these years and there is only one obscure card
> > that has a saa6588 as an add on.  No one even makes bttv cards with
> > tuners anymore.  The only bttv cards we've seen added in a long time
> > are multi-chip cards with no tuners.
>
> I wasn't thinking so much of new devices as existing devices that never
> recorded the presence of a saa6588.  We use 17 bits of the 32 available
> in the bitfield.  This will be the 18th.  I see absolutely no problem
> with that.

You're not counting the two u8 values.  They share the same bits as the
bitfield.  I can shink the card database again if just two bits can be
removed.  The 'onemore' field is entirely unused, probably added years ago
for some future use that never appeared, so that can be deleted.  The audio
chip fields aren't taking into account that the same card can't have
multiple audio chips so it should be possible to save another bit there.

Adding unused fields just makes it harder to clean up this stuff later.
How hard is cleaning up this cruft?  Well, my patches that cleaned up
bttv's card database were complex enough to use 1316 words to describe
them.  Compare that to every single patch you've commited from Jan 1st to
Mar 12th of this year, which total 1351 words.

> > > > > unsigned int tuner_type; /* tuner chip type */ unsigned int
> > > > > tda9887_conf; unsigned int svhs, dig; + unsigned int
> > > > > has_saa6588:1;
> > > >
> > > > You're better off not using a bitfield here.  Because of padding,
> > > > it still takes 32 bits (or more, depending on the alignment of
> > > > bttv_pll_info) in the struct but takes more code to use.
> > >
> > > Mauro wants a bitfield, he gets a bitfield.  I'm not going
> > > back-and-forth on this.  Personally I don't care one way or the
> > > other.
> >
> > So Mauro, why a bit field?  It doesn't save any space here.
>
> Because this clearly shows that it is a on-off value and not an integer
> that can have other values as well.

"bool"

Though it's obvious from the name anyway..
