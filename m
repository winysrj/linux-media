Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54757 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbbCKNt1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 09:49:27 -0400
Date: Wed, 11 Mar 2015 10:48:34 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Kamil Debski <k.debski@samsung.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, linux-input@vger.kernel.org
Subject: Re: [RFC v2 2/7] media: rc: Add cec protocol handling
Message-ID: <20150311104834.16fe758f@concha.lan>
In-Reply-To: <000f01d05bee$002b34c0$00819e40$%debski@samsung.com>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
	<1421942679-23609-3-git-send-email-k.debski@samsung.com>
	<20150308112033.7d807164@recife.lan>
	<000f01d05bee$002b34c0$00819e40$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 Mar 2015 12:24:53 +0100
Kamil Debski <k.debski@samsung.com> escreveu:

> Hi Mauro,
> 
> I have some more comments/questions below.
> 
> From: Mauro Carvalho Chehab [mailto:mchehab@osg.samsung.com]
> Sent: Sunday, March 08, 2015 3:21 PM
> > 
> > Em Thu, 22 Jan 2015 17:04:34 +0100
> > Kamil Debski <k.debski@samsung.com> escreveu:
> > 
> > (c/c linux-input ML)
> > 
> > > Add cec protocol handling the RC framework.
> > 
> > I added some comments, that reflects my understanding from what's there
> > at the keymap definitions found at:
> > 	http://xtreamerdev.googlecode.com/files/CEC_Specs.pdf
> > 
> > 
> > >
> > > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > > ---
> > >  drivers/media/rc/keymaps/Makefile |    1 +
> > >  drivers/media/rc/keymaps/rc-cec.c |  133
> > +++++++++++++++++++++++++++++++++++++
> > >  drivers/media/rc/rc-main.c        |    1 +
> > >  include/media/rc-core.h           |    1 +
> > >  include/media/rc-map.h            |    5 +-
> > >  5 files changed, 140 insertions(+), 1 deletion(-)  create mode
> 
> [snip]
> 
> > 
> > > +	{ 0x60, KEY_PLAY }, /* XXX CEC Spec: Play Function */
> > > +	{ 0x61, KEY_PLAYPAUSE }, /* XXX CEC Spec: Pause-Play Function */
> > > +	{ 0x62, KEY_RECORD }, /* XXX CEC Spec: Record Function */
> > > +	{ 0x63, KEY_PAUSE }, /* XXX CEC Spec: Pause-Record Function */
> > > +	{ 0x64, KEY_STOP }, /* XXX CEC Spec: Stop Function */
> > > +	{ 0x65, KEY_MUTE }, /* XXX CEC Spec: Mute Function */
> > > +	/* 0x66: CEC Spec: Restore Volume Function */
> > > +	{ 0x67, KEY_TUNER }, /* XXX CEC Spec: Tune Function */
> > > +	{ 0x68, KEY_MEDIA }, /* CEC Spec: Select Media Function */
> > > +	{ 0x69, KEY_SWITCHVIDEOMODE} /* XXX CEC Spec: Select A/V Input
> > Function */,
> > > +	{ 0x6a, KEY_AUDIO} /* CEC Spec: Select Audio Input Function */,
> > > +	{ 0x6b, KEY_POWER} /* CEC Spec: Power Toggle Function */,
> > > +	{ 0x6c, KEY_SLEEP} /* XXX CEC Spec: Power Off Function */,
> > > +	{ 0x6d, KEY_WAKEUP} /* XXX CEC Spec: Power On Function */,
> > 
> > Those "function" keycodes look weird. What's the difference between
> > those and the pure non-function variants?
> 
> The note 2 applies to most of these function buttons. It says:
> "2 During a recording or timed recording, a device may ask the user
> for confirmation of this action before executing it."

Ok. So, it seems that we need to add new keycodes for those function variants,
as they should be handled on a different way than the usual keycodes.
>  
> > The spec (CEC 13.13.3) says that:
> > 
> > 	"Unlike the other codes, which just pass remote control presses
> > 	 to the target (often with manufacturer-specific results),
> > 	 the Functions are deterministic, ie they specify exactly the
> > state
> > 	 after executing these commands. Several of these also have
> > further
> > 	 operands, specifying the function in more detail, immediately
> > 	 following the relevant [UI Command] operand."
> > 
> > Some codes are actually compund ones. For example, 0x60 has a "play
> > mode"
> > operand. So, the actual mapping would be:
> > 
> > 0x60 + 0x24 - "play forward"
> > 0x61 + 0x20 - "play reverse"
> > ...
> > (see CEC17 for operand descriptions)
> > 
> > So, IMHO, the mapping should be
> > 
> > 	{ 0x6024, KEY_PLAY },
> > 	{ 0x6020, KEY_PLAY_REVERSE }, // to be created
> 
> The note 1 says that they can be issued without the additional operand
> specified:
> "1 Functions with additional operands may also be used without the
> additional operand: in this case the behavior is manufacturer-specific."
> 
> Will this do?
> 	{ 0x60, KEY_PLAY },
> 	{ 0x6024, KEY_PLAY },
>  	{ 0x6020, KEY_PLAY_REVERSE }, // to be created
> Or will the framework get confused that an incomplete key code was
> received?

The above should work.

> Another question I have is about the following operations:
> 0x67 Tune Function
> 0x68 Select Media Function
> 0x69 Select A/V Input Function
> 0x6a Select Audio Input Function
> These operations take an additional operand that is large number.
> 1-255 for 0x68-0x6a or even a more complex operand such as the channel
> number for 0x67.
> 
> Any suggestion on how to implement these correctly?

Well, the scancode may have any size. The current rc core implementation
is limited to u64. The scancode seek uses binary search, so it should
be fast, even for a big 64 bits table.

So, supporting a big number is not an issue to the core.

For the channel number, however, I suspect that we need to think on a
better alternative, like sending a sequence of numeric keycodes.

Maybe Dmitry has a better suggestion.

> 
> > 	...
> > 
> > 
> > > +	/* 0x6e-0x70: Reserved */
> > > +	{ 0x71, KEY_BLUE }, /* XXX CEC Spec: F1 (Blue) */
> > > +	{ 0x72, KEY_RED }, /* XXX CEC Spec: F2 (Red) */
> > > +	{ 0x73, KEY_GREEN }, /* XXX CEC Spec: F3 (Green) */
> > > +	{ 0x74, KEY_YELLOW }, /* XXX CEC Spec: F4 (Yellow) */
> > > +	{ 0x75, KEY_F5 },
> > > +	{ 0x76, KEY_CONNECT }, /* XXX CEC Spec: Data - see Note 3 */
> > > +	/* Note 3: This is used, for example, to enter or leave a digital
> > TV
> > > +	 * data broadcast application. */
> > 
> 
> [snip]
> 
> Best wishes,


-- 

Cheers,
Mauro
