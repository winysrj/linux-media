Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1095 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0CBUzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 15:55:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: How do private controls actually work?
Date: Tue, 2 Mar 2010 21:56:05 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com> <201003022128.06210.hverkuil@xs4all.nl> <829197381003021242p1ae9d91ek68e2c063024d316@mail.gmail.com>
In-Reply-To: <829197381003021242p1ae9d91ek68e2c063024d316@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003022156.05519.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 02 March 2010 21:42:39 Devin Heitmueller wrote:
> On Tue, Mar 2, 2010 at 3:28 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >> Between trying to figure out what the expected behavior is supposed to
> >> be (given the complete lack of documentation on how private controls
> >> are expected to be implemented in the extended controls API) and
> >> isolating and fixing the regression, it's hard not to be a little
> >> irritated at this situation.  This was supposed to be a very small
> >> change - a single private control to a mature driver.  And now it
> >> seems like I'm going to have to extend the basic infrastructure in the
> >> decoder driver, the bridge driver, add a new class of controls, all so
> >> I can poke one register?
> >
> > As you can see it is not that bad. That said, there is one disadvantage:
> > the em28xx driver does not support the V4L2_CTRL_FLAG_NEXT_CTRL that is needed
> > to enumerate this private user control. I do not know whether you need it since
> > you can still get and set the control, even if you can't enumerate it.
> 
> It's funny though.  I haven't looked at that part of the code
> specifically, but the em28xx driver does appear to show private
> controls in the output of the queryctrl() command (at least it is
> showing up in the output of "v4l2-ctl -l".  Are there two different
> APIs for enumerating controls?

That's probably when enumerating the PRIVATE_BASE controls. But that will not
work for private user class controls (i.e. CLASS_USER | 0x1000).
 
> > Unfortunately implementing this flag is non-trivial. We are missing code that
> > can administrate all the controls, whether they are from the main host driver
> > or from subdev drivers. The control framework that I'm working should handle
> > that, but it's not there yet. There is a support function in v4l2-common.c,
> > though: v4l2_ctrl_next(). It works, but it requires that bridge drivers know
> > which controls are handled by both the bridge driver and all subdev drivers.
> > That's not ideal since bridge drivers shouldn't have to know that from subdev
> > drivers.
> >
> > Looking at the em28xx driver I think that supporting V4L2_CTRL_FLAG_NEXT_CTRL
> > in em28xx is too much work. So for the time being I think we should support
> > both a CHROMA_GAIN control using the old PRIVATE_BASE offset, and the proper
> > SAA7115_CHROMA_GAIN control. Once we have a working framework, then the
> > PRIVATE_BASE variant can be removed.
> 
> I had some extended discussion with Mauro on this yesterday on
> #linuxtv, and he is now in favor of introducing a standard user
> control for chroma gain, as opposed to doing a private control at all.

That will also solve the problem :-)
 
> > I find all this just as irritating as you, but unfortunately I cannot conjure
> > up the time I need to finish it out of thin air :-( This part of the V4L2 API
> > is actually quite complex to correctly implement in drivers. So there is little
> > point in modifying individual drivers. Instead we just will have to wait for
> > the control framework to arrive.
> 
> Yeah, I understand.  Thanks for taking the time to help clarify how
> this stuff is intended to wrok.

No problem.

	Hans

> 
> Devin
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
