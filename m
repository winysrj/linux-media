Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57613 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab0LWJiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 04:38:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: What if add enumerations at the V4L2_FOCUS_MODE_AUTO?
Date: Thu, 23 Dec 2010 10:38:31 +0100
Cc: riverful.kim@samsung.com,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"Sylwester Nawrocki" <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
References: <201012150119.43918.laurent.pinchart@ideasonboard.com> <201012231019.38840.laurent.pinchart@ideasonboard.com> <201012231031.19672.hverkuil@xs4all.nl>
In-Reply-To: <201012231031.19672.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012231038.31856.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

On Thursday 23 December 2010 10:31:19 Hans Verkuil wrote:
> On Thursday, December 23, 2010 10:19:38 Laurent Pinchart wrote:
> > On Wednesday 15 December 2010 11:03:37 Hans Verkuil wrote:
> > > > On Wednesday 15 December 2010 08:57:29 Hans Verkuil wrote:
> > > > 
> > > > Hence my question, should we add a way to pass rectangles (basically
> > > > a structv4l2_rect) through the control ioctls ? It would make sense.
> > > 
> > > I thought it over and came to the conclusion that we should not do
> > > that. Instead we can create four separate controls.
> > 
> > That's not very clean, is it ?
> 
> Why not? It's perfectly consistent with the way controls work.

Because it multiplies the number of required controls by 4. There's also no 
way for applications to know that the controls are grouped together.

> > > The problem we run into when adding more complex types is that we can
> > > no longer communicate min and max values (something that we definitely
> > > want when dealing with coordinates).
> > 
> > Why not ? We should still support querying min/max/def values on a struct
> > v4l2_ctrl. This would of course require an extended queryctrl ioctl.
> 
> Which will make apps even more complicated. I thought about this as well,
> but it's a road that will lead to chaos.

Sorry, I don't see why a v4l2_rect type will lead to chaos. That doesn't mean 
we need to support any data structure as control data, just a very limited 
number V4L2 standard ones.

> > > Another reason is how the control mechanism is designed: they only
> > > support the basic types (int, bool, string, enum, int64 and a 'button'
> > > aka action). And the controls are grouped into classes which are named
> > > through the 'ctrl_class' control.
> > > 
> > > So effectively controls represent a field in a class (or struct) and
> > > each class can be presented as a tab page in a control panel.
> > > 
> > > Simple and straightforward.
> > > 
> > > If we start to add complex types, then it becomes really hard to define
> > > the meta data of the control since you are really defining a
> > > 'mini-class'.
> > 
> > I agree that arbitrary complex controls might not be a good idea, but
> > v4l2_rect is a pretty standard data structure in V4L2 and something that
> > can be useful for different controls.
> > 
> > > It sounds nice initially, but we really should not do this since I
> > > believe it will lead to chaos later on. You want complex types, then
> > > use ioctls, not controls. Or split up the complex type into multiple
> > > simple types.
> > 
> > Then let's use an ioctl for focus control. I don't like it.
> 
> I would vote for 4 controls. Since FOCUS_MODE_AUTO is a control it makes no
> sense to make an ioctl to set the rectangle. That would be a strange mix.
> 
> And having 4 controls for the rectangle will actually look good in GUIs,

Applications will display the controls without knowing they are related. 
Having a v4l2_rect type would actually allow applications to display the 
control better.

> and with S_EXT_CTRLS you can set all focus-related controls in one call.

Then don't tell me that an extended queryctrl ioctl would make apps even more 
complicated, when you advocate using four separate values to change a single 
control ;-)

-- 
Regards,

Laurent Pinchart
