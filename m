Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36769 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3GRBGk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 21:06:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [BRAINSTORM] Controls, matrices and properties
Date: Thu, 18 Jul 2013 03:07:26 +0200
Message-ID: <1462134.bc1z0qkCPU@avalon>
In-Reply-To: <51DDD26D.4060304@iki.fi>
References: <201307081306.56324.hverkuil@xs4all.nl> <51DDD26D.4060304@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Just a small question below, I've addressed all the rest in a reply to Hans' 
original e-mail.

On Thursday 11 July 2013 00:30:21 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > Hi all,
> > 
> > I have been working on support for passing matrices to/from drivers using
> > a new matrix API. See this earlier thread for more background information:
> > 
> > http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/6
> > 6200
> > 
> > The basic feedback is that, yes, matrices are useful, but it is yet
> > another control-like API.
> > 
> > My problem with using the control API for things like this is that the
> > control API has been designed for use with GUIs: e.g. the controls are
> > elements that the end-user can modify through a GUI. Things like a matrix
> > or some really low-level driver property are either hard to model in a
> > GUI or too advanced and obscure for an end-user.
> 
> We also have a lot of low level controls.
> 
> GUI implementations can always choose not to show matrix controls. I
> think a low level control flag has been proposed earlier on, but AFAIR
> the conclusion that time around was that it's sometimes difficult to
> define what is actually a low level control and what isn't.
> 
> IMHO (and according to Unix principles, too), APIs should provide means,
> not policy. Saying that controls should be used for something that can
> (or should) be displayed by a GUI, and what isn't displayed in a GUI
> isn't a control, definitely falls into this category.
> 
> > On the other hand, the control framework has all the desirable properties
> > that you would want: atomicity (as far as is allowed by the hardware),
> > the ability to get/set multiple controls in one ioctl, efficient,
> > inheritance of subdev controls in bridge devices, events, etc.
> > 
> > I'm wondering whether we cannot tweak the control API a bit to make it
> > possible to use it for matrices and general 'properties' as well. The
> > main requirement for me is that when applications enumerate over controls
> > such properties should never turn up in the enumerations: only controls
> > suitable for a GUI should appear. After all, an application would have no
> > idea what to do with a matrix of e.g. 200x300 elements.
> 
> This sounds like the low-level control flag. I'm certainly not against
> it. I have to admit I'm not someone who'd ever access controls through a
> GUI, and if it helps, then why not.
> 
> Alternatively... how about just ignoring control types that aren't
> supported in GUI? That'd be probably even easier for GUIs than checking
> a flag --- just ignore what you don't know about.
> 
> > While it is possible to extend queryctrl to e.g. enumerate only properties
> > instead of controls, it is probably better to create a new
> > VIDIOC_QUERYPROP ioctl. Also because the v4l2_queryctrl is pretty full and
> > has no support to set the minimum/maximum values of a 64 bit value. In
> > addition, the name field is not needed for a property, I think. Currently
> > the name is there for the GUI, not for identification purposes.
> 
> The are drivers that use private controls the ID of which is only
> defined as a macro in the driver. I wonder if user space programs expect
> controls under certain names.
> 
> Alternatively we could require that macro definitions exists for all new
> controls.
> 
> Would you intend VIDIOC_QUERYPROP to replace VIDIOC_QUERYCTRL or not? I
> might just create an extended version of QUERYCTRL which would fix the
> limits for 64-bit controls, too... it'd be easy to add a wrapper in
> v4l2-ioctl.c to implement the original VIDIOV_QUERYCTRL for drivers that
> implement the extended version (like we've done a bunch of time already).
> 
> > For setting/getting controls the existing extended control API can be
> > used, although I would be inclined to go for VIDIOC_G/S/TRY_PROPS ioctls
> > as well. For example, when I set a matrix property it is very desirable to
> > pass only a subset of the matrix along instead of a full matrix. In my
> > original matrix proposal I had a v4l2_rect struct that defined that. But
> > there is no space in struct v4l2_ext_control to store such information.
> 
> Doe you have a use case for this?
> 
> An unrelated thing, which is out of scope for now, but something to think
> about: when passing around large amounts of (configuration) data the number
> of times the data is copied really counts. Especially on embedded systems.
> 
> Memory mapping helps avoiding problems --- what would happen is that the
> driver would access memory mapped to the device directly and the driver
> would then get the address to pass to the device as the configuration. Like
> video buffers, but for control, not data.

Would you map that memory to userspace as well ?

> This requires a new RFC (one or more). For later, definitely.
> 
> > In general, implementing properties requires more variation since the GUI
> > restriction has been lifted. Also, properties can be assigned to specific
> > internal objects (e.g. buffer specific properties), so you need fields to
> > tell the kernel with which object the property is associated.
> 
> Interesting idea. Definitely.
> 
> > However, although the public API is different from the control API, there
> > is no reason not to use the internal control framework for both.
> 
> This could be extended ^ 2 controls. For existing controls the scope
> would always be either the video node or the subdev node.
> 
> What do you think? I think that functionality-wise it'd be a superset,
> so implementing the existing extended controls could be done as a
> backwards compatibility measure, both for drivers and applications.
> 
> > Internally controls and properties work pretty much the same way and can
> > all be handled by the control framework. Only supporting e.g. per-buffer
> > controls would take work since that is currently not implemented.
> > 
> > At the moment this is just an idea and I don't want to spend time on
> > creating a detailed RFC if people don't like it. So comments are welcome!
> 
> I definitely like these ideas, and I wrote down some of my own above.
> 
> :-) I think that at this point there are so many ideas on how to improve
> 
> what we currently have, and your matrix RFC answered to a subset of
> these aspirations.
> 
> I think we can do more without introducing a bunch of new IOCTLs every
> time a bit of new functionality is introduced, at least it without being
> a full superset of something that exists.

-- 
Regards,

Laurent Pinchart

