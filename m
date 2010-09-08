Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48697 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755941Ab0IHQvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 12:51:08 -0400
Subject: Re: [PATCH 7/8] IR: extend ir_raw_event and do refactoring
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	lirc-list@lists.sourceforge.net,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <AANLkTinr6mN=t=vNnR3pSBxXb0ud=Ymrqn_WyDNkUJTz@mail.gmail.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
	 <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>
	 <AANLkTinr6mN=t=vNnR3pSBxXb0ud=Ymrqn_WyDNkUJTz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 12:50:46 -0400
Message-ID: <1283964646.6372.90.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, 2010-09-08 at 11:26 -0400, Jarod Wilson wrote:
> On Mon, Sep 6, 2010 at 5:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > Add new event types for timeout & carrier report
> > Move timeout handling from ir_raw_event_store_with_filter to
> > ir-lirc-codec, where it is really needed.
> > Now lirc bridge ensures proper gap handling.
> > Extend lirc bridge for carrier & timeout reports
> >
> > Note: all new ir_raw_event variables now should be initialized
> > like that: DEFINE_IR_RAW_EVENT(ev);
> >
> > To clean an existing event, use init_ir_raw_event(&ev);
> >
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  drivers/media/IR/ene_ir.c          |    4 +-
> >  drivers/media/IR/ir-core-priv.h    |   13 ++++++-
> >  drivers/media/IR/ir-jvc-decoder.c  |    5 +-
> >  drivers/media/IR/ir-lirc-codec.c   |   78 +++++++++++++++++++++++++++++++-----
> >  drivers/media/IR/ir-nec-decoder.c  |    5 +-
> >  drivers/media/IR/ir-raw-event.c    |   45 +++++++-------------
> >  drivers/media/IR/ir-rc5-decoder.c  |    5 +-
> >  drivers/media/IR/ir-rc6-decoder.c  |    5 +-
> >  drivers/media/IR/ir-sony-decoder.c |    5 +-
> >  drivers/media/IR/mceusb.c          |    3 +-
> >  drivers/media/IR/streamzap.c       |    8 ++-
> >  include/media/ir-core.h            |   40 ++++++++++++++++---
> >  12 files changed, 153 insertions(+), 63 deletions(-)
> ...
> > @@ -162,22 +164,48 @@ u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
> >  /* From ir-raw-event.c */
> >
> >  struct ir_raw_event {
> > -       unsigned                        pulse:1;
> > -       unsigned                        duration:31;
> > +       union {
> > +               u32             duration;
> > +
> > +               struct {
> > +                       u32     carrier;
> > +                       u8      duty_cycle;
> > +               };
> > +       };
> > +
> > +       unsigned                pulse:1;
> > +       unsigned                reset:1;
> > +       unsigned                timeout:1;
> > +       unsigned                carrier_report:1;
> >  };
> 
> I'm generally good with this entire patch, but the union usage looks a
> bit odd, as the members aren't of the same size, which is generally
> what I've come to expect looking at other code.

Having a union with different sized members is perfectly valid C code. 

Just look at the definition of the XEvent in Xlib.h.  The "int type;" is
smaller than everything, and the XAnyEvent is smaller than the other
event types.

The size of the union will be the size of its largest member.



>  I'd be inclined to
> simply move duty_cycle out of the union and leave just duration and
> carrier in it.

That's not necessary and it could be confusing depending on where you
put duty_cycle.

Regards,
Andy

>  However, as discussed on irc and upon looking at the
> code, we don't actually do anything useful with duty_cycle yet, so
> perhaps just cut it out entirely for the moment, and add it later when
> its of use.
> 


