Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36743 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab3GRBB6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 21:01:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [BRAINSTORM] Controls, matrices and properties
Date: Thu, 18 Jul 2013 03:02:42 +0200
Message-ID: <1751715.hnucGEH0MP@avalon>
In-Reply-To: <201307081306.56324.hverkuil@xs4all.nl>
References: <201307081306.56324.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the proposal.

On Monday 08 July 2013 13:06:56 Hans Verkuil wrote:
> Hi all,
> 
> I have been working on support for passing matrices to/from drivers using a
> new matrix API. See this earlier thread for more background information:
> 
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/662
> 00
> 
> The basic feedback is that, yes, matrices are useful, but it is yet another
> control-like API.
> 
> My problem with using the control API for things like this is that the
> control API has been designed for use with GUIs: e.g. the controls are
> elements that the end-user can modify through a GUI. Things like a matrix or
> some really low-level driver property are either hard to model in a GUI or
> too advanced and obscure for an end-user.

That's true for some controls as well. I think the controls API has evolved 
over time to accommodate the needs of both user-facing, GUI-friendly controls 
and low-level controls (especially in the embedded world). The controls APIs 
(both the userspace API and the in-kernel control framework) were suitable for 
both (after a bit of tweaking in some cases), so we just haven't realized how 
conceptually different controls were. There's not much more in common between 
a brightness level and a flash strobe time then between a contrast level and a 
gamma table or motion detection matrix.

> On the other hand, the control framework has all the desirable properties
> that you would want: atomicity (as far as is allowed by the hardware), the
> ability to get/set multiple controls in one ioctl, efficient, inheritance
> of subdev controls in bridge devices, events, etc.
> 
> I'm wondering whether we cannot tweak the control API a bit to make it
> possible to use it for matrices and general 'properties' as well. The main
> requirement for me is that when applications enumerate over controls such
> properties should never turn up in the enumerations: only controls suitable
> for a GUI should appear. After all, an application would have no idea what
> to do with a matrix of e.g. 200x300 elements.
> 
> While it is possible to extend queryctrl to e.g. enumerate only properties
> instead of controls, it is probably better to create a new VIDIOC_QUERYPROP
> ioctl. Also because the v4l2_queryctrl is pretty full and has no support to
> set the minimum/maximum values of a 64 bit value. In addition, the name
> field is not needed for a property, I think. Currently the name is there
> for the GUI, not for identification purposes.

Names indeed feel a bit out of place. Even for GUI-related controls the 
controls API doesn't support localization (not that it should!), so handling 
control names in a central location in userspace would make sense (names can 
still be provided by the kernel as hints though, to simplify basic command 
line applications).

Moreover, I've never been really convinced by the GUI-related flags we 
currently have in the controls API. They feel like a policy decision to me, 
and should ideally (at least in my ideal view of V4L2) be part of userspace. 
If an application wants to render controls as knobs instead of sliders I don't 
see a reason why the kernel should hint otherwise. Maybe we could rethink, 
while developing the properties API, how userspace should use properties 
globally, from a userspace point of view. What is it that intrinsically make 
some of the controls we have today be displayed as sliders for instance ? Is 
it really a property of the control ? What influences our idea of how controls 
should be rendered ?

At the end of the day, whether we should present a control to a user will 
depend on the user and his/her use cases. There's no one-size-fits-them-all 
rule to decide whether all individual controls should or should not be 
displayed in a panel application. I haven't really thought this topic through, 
but a binary decision made in the kernel doesn't look like the right solution 
to me. As Sakari noted, user-facing panel applications could just whitelist 
controls they want to display. This would work for the most simple cases, but 
would require updating all those userspace applications when we add a user-
facing control, which adds an additional burden to developers and make 
extensions slower to roll out. One could however argue that such controls are 
very rarely added. I have no clear answer to this question.

> For setting/getting controls the existing extended control API can be used,
> although I would be inclined to go for VIDIOC_G/S/TRY_PROPS ioctls as well.
> For example, when I set a matrix property it is very desirable to pass only
> a subset of the matrix along instead of a full matrix. In my original matrix
> proposal I had a v4l2_rect struct that defined that. But there is no space
> in struct v4l2_ext_control to store such information.
> 
> In general, implementing properties requires more variation since the GUI
> restriction has been lifted. Also, properties can be assigned to specific
> internal objects (e.g. buffer specific properties), so you need fields to
> tell the kernel with which object the property is associated.
> 
> However, although the public API is different from the control API, there
> is no reason not to use the internal control framework for both.
> 
> Internally controls and properties work pretty much the same way and can all
> be handled by the control framework. Only supporting e.g. per-buffer
> controls would take work since that is currently not implemented.

We'll probably find out along the way that we'll need more extensions to the 
control framework, but I'm not worried about that. We have a solid code base, 
and it's a pure in-kernel API.

> At the moment this is just an idea and I don't want to spend time on
> creating a detailed RFC if people don't like it. So comments are welcome!

Please count me in. I'm definitely in favour of discussing the idea further. 
Face-to-face discussions are needed, but we should first brainstorm ideas on 
the list to let them sink through in everyone's mind at least for a couple of 
weeks before a meeting.

-- 
Regards,

Laurent Pinchart

