Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2753 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab0CBU1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 15:27:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: How do private controls actually work?
Date: Tue, 2 Mar 2010 21:28:06 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com> <49ae9be6ffaaac102dc02f94f2fd047c.squirrel@webmail.xs4all.nl> <829197381003010220w57248cb2l636a75d5bf4b19c1@mail.gmail.com>
In-Reply-To: <829197381003010220w57248cb2l636a75d5bf4b19c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003022128.06210.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin!

As promised here is the follow-up on private controls.

First I refer you to an older posting of mine which is still pretty accurate:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg07999.html

As I mention there the intention is that I provide control support in the
v4l2 framework making it much easier to work with controls in drivers.

Unfortunately, I still haven't been able to find the time to continue my
work on this. Most annoying. I know exactly what I want and how to do it,
but I can't seem to manage to have 3-4 days of quiet to actually do it.

On Monday 01 March 2010 11:20:09 Devin Heitmueller wrote:
> On Mon, Mar 1, 2010 at 4:58 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > New private controls should not use V4L2_CID_PRIVATE_BASE at all. That
> > mechanism was a really bad idea. Instead a new control should be added to
> > the appropriate control class and with a offset >= 0x1000. See for example
> > the CX2341X private controls in videodev2.h.
> 
> So, you're suggesting that the following patch then is going to be
> NAK'd and that I'm going to have to go back and convert saa7115 to
> support the extended controls API, extend the em28xx driver to support
> the extended controls API, and retest with all the possible
> applications given how they might potentially be attempting to
> implement the rather poorly documented interface?
> 
> http://kernellabs.com/hg/~dheitmueller/em28xx-test/rev/a7d50db75420

I will NAK it only because you use V4L2_CID_PRIVATE_BASE. The rest of the
code is fine. It would be sufficient to create a private user control like
this:

#define V4L2_CID_SAA7115_BASE 		(V4L2_CTRL_CLASS_USER | 0x1000)
#define V4L2_CID_SAA7115_CHROMA_GAIN	(V4L2_CID_SAA7115_BASE+0)

> 
> And exactly what "class" of extended controls should I use for video
> decoders?  It would seem that a video decoder doesn't really fall into
> any of the existing categories - "Old-style user controls", "MPEG
> compression controls", "Camera controls", or "FM modulator controls".
> Are we saying that now I'm also going to be introducing a whole new
> class of control too?

CHROMA_AGC is a user control. And setting the CHROMA_GAIN should be in that
same class. It makes no sense to use two different classes for this.

> > The EXT_G/S_CTRLS ioctls do not accept PRIVATE_BASE because I want to
> > force driver developers to stop using PRIVATE_BASE. So only G/S_CTRL will
> > support controls in that range for backwards compatibility.
> 
> While we're on the topic, do you see any problem with the proposed fix
> for the regression you introduced?:
> 
> http://kernellabs.com/hg/~dheitmueller/em28xx-test/rev/142ae5aa9e8e

No problems at all. That's the correct fix.

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

> 
> Between trying to figure out what the expected behavior is supposed to
> be (given the complete lack of documentation on how private controls
> are expected to be implemented in the extended controls API) and
> isolating and fixing the regression, it's hard not to be a little
> irritated at this situation.  This was supposed to be a very small
> change - a single private control to a mature driver.  And now it
> seems like I'm going to have to extend the basic infrastructure in the
> decoder driver, the bridge driver, add a new class of controls, all so
> I can poke one register?

As you can see it is not that bad. That said, there is one disadvantage:
the em28xx driver does not support the V4L2_CTRL_FLAG_NEXT_CTRL that is needed
to enumerate this private user control. I do not know whether you need it since
you can still get and set the control, even if you can't enumerate it.

Unfortunately implementing this flag is non-trivial. We are missing code that
can administrate all the controls, whether they are from the main host driver
or from subdev drivers. The control framework that I'm working should handle
that, but it's not there yet. There is a support function in v4l2-common.c,
though: v4l2_ctrl_next(). It works, but it requires that bridge drivers know
which controls are handled by both the bridge driver and all subdev drivers.
That's not ideal since bridge drivers shouldn't have to know that from subdev
drivers.

Looking at the em28xx driver I think that supporting V4L2_CTRL_FLAG_NEXT_CTRL
in em28xx is too much work. So for the time being I think we should support
both a CHROMA_GAIN control using the old PRIVATE_BASE offset, and the proper
SAA7115_CHROMA_GAIN control. Once we have a working framework, then the
PRIVATE_BASE variant can be removed.

It's not elegant, but I don't see a better short-term solution.

I find all this just as irritating as you, but unfortunately I cannot conjure
up the time I need to finish it out of thin air :-( This part of the V4L2 API
is actually quite complex to correctly implement in drivers. So there is little
point in modifying individual drivers. Instead we just will have to wait for
the control framework to arrive.

I hope this helps,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
