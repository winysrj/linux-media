Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:43191 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab0BWPeE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 10:34:04 -0500
Subject: Re: Chroma gain configuration
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <afc23983d22d02e5832ce68b75f35890.squirrel@webmail.xs4all.nl>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	 <201002222254.05573.hverkuil@xs4all.nl>
	 <829197381002221400i6e4f4b17u42597d5138171e19@mail.gmail.com>
	 <201002230853.36928.hverkuil@xs4all.nl>
	 <1266934843.4589.20.camel@palomino.walls.org>
	 <afc23983d22d02e5832ce68b75f35890.squirrel@webmail.xs4all.nl>
Content-Type: text/plain
Date: Tue, 23 Feb 2010 10:33:43 -0500
Message-Id: <1266939223.4589.48.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-02-23 at 15:41 +0100, Hans Verkuil wrote:
> > On Tue, 2010-02-23 at 08:53 +0100, Hans Verkuil wrote:
> >> On Monday 22 February 2010 23:00:32 Devin Heitmueller wrote:
> >> > On Mon, Feb 22, 2010 at 4:54 PM, Hans Verkuil <hverkuil@xs4all.nl>
> >> wrote:
> >
> >> > Of course, if you and Mauro wanted to sign off on the creation of a
> >> > new non-private user control called V4L2_CID_CHROMA_GAIN, that would
> >> > also resolve my problem.  :-)
> >>
> >> Hmm, Mauro is right: the color controls we have now are a bit of a mess.
> >> Perhaps this is a good moment to try and fix them. Suppose we had no
> >> color
> >> controls at all: how would we design them in that case? When we know
> >> what we
> >> really need, then we can compare that with what we have and figure out
> >> what
> >> we need to do to make things right again.

> Let me rephrase my question: how would you design the user color controls?

> E.g., the controls that are exported in GUIs to the average user.

Look at the knobs on an old TV or look at the menu on more modern
televisions:

1. Hue (or Tint) (at least NTSC TVs have this control)
2. Brightness
3. Saturation

These are the three parameters to which the Human Visual System
sensitive.

Any other controls are fixing problems that the hardware can't seem to
get right on it's own - right?


>  Most of
> the controls you mentioned above are meaningless to most users. When we
> have subdev device nodes, then such controls can become accessible to
> applications to do fine-tuning, but they do not belong in a GUI in e.g.
> tvtime or xawtv.
> 
> The problem is of course in that grey area between obviously user-level
> controls like brightness and obviously (to me at least) expert-level
> controls like chroma coring.

Right, so an expert can see colors bleeding to the side in portions of
the image and guess that it's a comb filter problem.  What's my recourse
at that point, when I see such a clip submitted from user and identify
it's a comb filter problem?  "Tough, you're not an expert, so I can't
give you manual control over the comb filter so you can fix your
problem" ?

Also, just because a user can't guess what to do, doesn't mean they are
incapable of "mashing buttons" until they find something that works.  I
don't quite see the value in restricting controls from users, when the
only consequence of such restriction is them coming back here asking
what else they can try to solve a problem.  It's frustrating to have a
setting on the chip that could fix a user problem and knowing there is
no control coded up for it.  It just makes the debug cycle longer.


What is the benefit to us or to end users for denying controls to
non-expert users?


OK, I'm done ranting now. :)

Regards,
Andy


