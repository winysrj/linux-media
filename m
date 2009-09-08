Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44335 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbZIHCdM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Sep 2009 22:33:12 -0400
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] cx25840: fix determining the
	firmware name
From: Andy Walls <awalls@radix.net>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Hans Verkuil via Mercurial <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <303a8ee30909071822jfa6c932i41f3dc3a97684b2c@mail.gmail.com>
References: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
	 <37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
	 <20090907021002.2f4d3a57@caramujo.chehab.org>
	 <37219a840909062220p3ae71dc0t4df96fd140c5c7b4@mail.gmail.com>
	 <20090907030652.04e2d2a3@caramujo.chehab.org>
	 <1252340384.3146.52.camel@palomino.walls.org>
	 <37219a840909070925k25ed146bn9c3725596c9490b9@mail.gmail.com>
	 <20090907183632.195dc3e5@caramujo.chehab.org>
	 <37219a840909071521j67e9c3d6h1e9b2e1a8ded45cd@mail.gmail.com>
	 <20090907194007.37c222cc@caramujo.chehab.org>
	 <303a8ee30909071822jfa6c932i41f3dc3a97684b2c@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 22:30:42 -0400
Message-Id: <1252377042.321.57.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-09-07 at 21:22 -0400, Michael Krufky wrote:
> On Mon, Sep 7, 2009 at 6:40 PM, Mauro Carvalho
> Chehab<mchehab@infradead.org> wrote:
> > Em Mon, 7 Sep 2009 18:21:01 -0400
> > Michael Krufky <mkrufky@kernellabs.com> escreveu:
> >
> >> Mauro,
> >>
> >> For the Conexant *reference designs* the firmwares are identical, yes.
> >>
> >> If you look at the windows drivers, there are some additional bits
> >> used for separate firmwares depending on which actual silicon is
> >> present.  This is specific to the implementation by the vendors.
> >
> > If firmware versions are vendor-specific, then the patch "cx25840: fix
> > determining the  firmware name" doesn't work, since people may have two boards
> > with the same silicon from different vendors, each requiring his own
> > vendor-specific firmware.
> >
> > The solution seems to have a setup parameter with the firmware name, adding the
> > firmware name at the *-cards.c, like what's done with xc3028 firmwares. This
> > also means that we need vendor's rights to distribute the specific firmwares.
> >>
> >> Not everybody is using the firmware images that you are pointing at...
> >>  There is in fact a need to keep the filenames separate.  Some
> >> firmware for one silicon may conflict with firmware for other silicon.
> >>
> >> -Mike
> 
> Let me clarify:
> 
> As far as I understand, there are some additional bits in the cx23885
> firmware for use with certain vendor-specific stuff.  That cx23885
> firmware is compatible with all other cx23885 firmware, but not
> necessarily the cx25840.
> 
> Likewise, there are some additional bits in the cx25840 firmware for
> certain vendor-specific stuff, that is compatible with all other
> cx25840 firmware, but not necessarily the cx23885.
> 
> As I understand, if additional bits are added for a specific product,
> they might be added to the firmware in addition to the other bits
> already present for *that* firmware image.  This means, any cx23885
> firmware is OK to use for any cx23885, and any cx25840 firmware is OK
> to use for any cx25840.
> 
> You will notice that most of these images can be interchanged between
> one another, but the additional bits are specific to the flavor of the
> silicon.
> 
> There is no actual vendor-specific firmware -- all firmware for these
> parts are uniform for that part.  However, there are some
> cx23885-specific bits that only apply to the cx23885, just as there
> may be some cx25840-specific bits that only apply to the cx25840.
> 
> I dont know how to explain this any clearer.

Might I add a slightly off-topic rant: the cx25840 module is a
maintenance headache due to the desire to handle all these different
devices with "common code".  If you take a look at the code, there's a
good deal that's not in common, and I'm wondering what the benefit of
the common code base is exactly.  Maintenance-wise, the cx25840 module
takes a lot more thought and testing to modify properly.

For example, just changing the module to get the Video Clock for the
CX23888 set properly took a ridiculous amount of effort:

http://linuxtv.org/hg/~awalls/cx23888-ir/rev/70bde4976fc3
http://linuxtv.org/hg/~awalls/cx23888-ir/rev/c3d2791d89f3
http://linuxtv.org/hg/~awalls/cx23888-ir/rev/b42e0af29652
http://linuxtv.org/hg/~awalls/cx23888-ir/rev/caf03e99d49f
http://linuxtv.org/hg/~awalls/cx23888-ir/rev/7078cafc3d44

Especially in this change to separate out the configuration of the audio
clocks for the individual families:

http://linuxtv.org/hg/~awalls/cx23888-ir/rev/b42e0af29652

it became very obvious how much of the analog audio functionality isn't
complete for the CX2388[578] and CX2310[12].  It wasn't really visible
before.

I also swept up a minor inconsistency/bug in that change.  If you look,
the SA_MCLK_DIV was not being set properly for 32 ksps serial audio for
CX2583[67] chips due to a conditional check for a cx2583x chip type.
Did it matter for a CX2583x chip that doesn't have audio?  No, but it
was being set for the CX2583x for all the other cases by the conditional
code at the top of the function.  This inconsistency/bug was invisible
due to being buried in the mess of conditional code paths to accommodate
multiple cores.


BTW, the cx25840 module still needs some work.  Things that spring to
mind:

1. Allowing the bridge driver to specify GPIO settings cleanly.  At
least one LeadTek board needs this.

2. Adding IR controller functionality for the CX23885 (and CX2584x and
CX2310x if anyone has a device with it hooked up).

3. Adding event notifications to alert the bridge driver when the audio
format and mode has changed (in hopes of clearing up the PVR-150 and
PVR-500 tinny audio problem).

4. At least the cx23885 driver and cx231xx driver break the abstraction
of separation by accessing A/V core registers directly from the bridge
driver.  The cx23885 module does it to configure the AUX_PLL for NetUP
cards, IIRC.  The cx231xx driver does it to set up the analog frontend
input mux, IIRC.



The biggest maintenance problem with this module is the regression
testing when changing a common code path used by all the cores.  Those
common code paths I perceive as very fragile.


What is the exact benefit we're after here by making things common
between all these cores?  Code reuse is not a benefit, if it leads to
more expensive maintenance.

I had considered moving the cx18-av code from the cx18 module into the
cx25840 module, but could never find a reason to undertake all the work.
Memory footprint isn't a good reason: desktop PC memory is cheap and
embedded systems would likely only use one type of card anyway.  The
return on investment seems like it would be less than 0.

OK.  I'm done ranting...


Regards,
Andy


> One thing that might be a good idea -- perhaps the bridge-level driver
> that needs to attach the cx25840 module should specify to the cx25840
> module the filename of the firmware that should be requested.  A
> module option would *not* be the best idea -- we should not expect
> users to know about this.  Perhaps a default firmware filename could
> be named by cx25840.  *but*  we should not simply cause every driver
> to all use the same filename unless the original driver author can
> vouch for this as the appropriate course of action.

> Regards,
> 
> Mike


