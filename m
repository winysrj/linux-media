Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39074 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757940Ab3BFU0i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Feb 2013 15:26:38 -0500
Date: Wed, 6 Feb 2013 22:26:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrzej Hajda <a.hajda@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC: add parameters to V4L controls
Message-ID: <20130206202632.GA22278@valkosipuli.retiisi.org.uk>
References: <50EAA78E.4090904@samsung.com>
 <201301071310.54428.hverkuil@xs4all.nl>
 <510AA736.5060803@samsung.com>
 <1409971.Bs77k1Sp6U@avalon>
 <510EB23E.6070100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510EB23E.6070100@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, Feb 03, 2013 at 07:53:50PM +0100, Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> On 02/01/2013 11:17 PM, Laurent Pinchart wrote:
> [...]
> >>>>There could be added four pseudo-controls, lets call them for short:
> >>>>LEFT, TOP, WIDTH, HEIGHT. Those controls could be passed together with
> >>>>V4L2_AUTO_FOCUS_AREA_RECTANGLE control in one ioctl as a kind of
> >>>>parameters.
> >>>>
> >>>>For example setting auto-focus spot would require calling
> >>>>VIDIOC_S_EXT_CTRLS with the following controls:
> >>>>- V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
> >>>>- LEFT = ...
> >>>>- RIGHT = ...
> >>>>
> >>>>Setting AF rectangle:
> >>>>- V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
> >>>>- LEFT = ...
> >>>>- TOP = ...
> >>>>- WIDTH = ...
> >>>>- HEIGHT = ...
> >>>>
> >>>>Setting  AF object detection (no parameters required):
> >>>>- V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION
> >>>
> >>>If you want to do this, then you have to make LEFT/TOP/WIDTH/HEIGHT real
> >>>controls. There is no such thing as a pseudo control. So you need five
> >>>new controls in total:
> >>>
> >>>V4L2_CID_AUTO_FOCUS_AREA
> >>>V4L2_CID_AUTO_FOCUS_LEFT
> >>>V4L2_CID_AUTO_FOCUS_RIGHT
> >>>V4L2_CID_AUTO_FOCUS_WIDTH
> >>>V4L2_CID_AUTO_FOCUS_HEIGHT
> >>>
> >>>I have no problem with this from the point of view of the control API, but
> >>>whether this is the best solution for implementing auto-focus is a
> >>>different issue and input from sensor specialists is needed as well
> >>>(added Laurent and Sakari to the CC list).
> >>>
> >>>The primary concern I have is that this does not scale to multiple focus
> >>>rectangles. This might not be relevant to auto focus, though.
> >>
> >>I think for more advanced hardware/configurations there is a need to
> >>associate more information with the rectangles anyway. So the selections
> >>API seems too limited. Probably a new IOCTL would be needed for that,
> >>either standard or private.
> >>
> >>We've discussed it here with Andrzej and using such 4 controls to specify
> >>the AF rectangle looks sufficient from our POV.
> >>
> >>I would just probably rename LEFT/RIGHT to POS_X/POS_Y or something,
> >>as these 2 controls could be used in a focus mode where only spot
> >>position needs to be specified.
> >
> >If position and size are sufficient, could we use the selection API instead ?
> >An alternative would be to introduce rectangle controls. I'm a bit
> >uncomfortable with using 4 controls here, as this could quickly grow out of
> >control.
> 
> Yes, the selection API could be used as well. I actually have tested this
> in the past with the s5c73m3 camera and its spot auto focus mode.
> 
> I just wanted to be sure there is no better alternatives, as it looked
> a bit unusual to handle single feature with a mix of the controls and
> the selection API calls. Although it works, such an interface looks a bit
> clumsy to me, especially in cases where all we need is to pass just (x,y)
> coordinates.

Selections are essentially controls but for rectangles.

The original use case was to support configuring scaling, cropping etc. on
subdevs but they're not really bound to image processing configuration.

Controls have been more generic to begin with.

> I have quickly added support for rectangle controls type [1] to see how
> big changes it would require and what would be missing without significant
> changes in the controls API.
> 
> So the main issues there are: the min/max/step/default value cannot
> be queried (VIDIOC_QUERYCTRL) and it is troublesome to handle them in
> the kernel, the control value change events wouldn't really work.
> 
> I learnt VIDIOC_QUERYCTRL is not supported for V4L2_CTRL_TYPE_INTEGER64
> control type, then maybe we could have similarly some features not
> available for V4L2_CTRL_TYPE_RECTANGLE ? Until there are further
> extensions that address this;)
> 
> [1] http://git.linuxtv.org/snawrocki/media.git/ov965x-2-rect-type-ctrl

Hmm. Had you proposed this two years ago, selections could well look
entirely different.

We still have them now. There would be use cases for pad specific controls,
too; pixel rate for instance should be one. For this reason I don't see
selections really much different from controls.

The selections are the same on subdevs and video nodes. Unifying them (with
some compat code for either of the current interfaces) and providing a new
IOCTL to access both was what I thought could be one solution to the
problem.

Or --- we could add "selection controls" which would be just like selections
but with the control interface. What's relevant in struct v4l2_ext_control
would be the ID field, while the "value" field in struct v4l2_ext_control
would be a pointer to a struct describing the selection control. Half of the
reserved field could be used for the pad (they're 16-bit ints). No control
ID clashes with the selection IDs, so this could even work with the existing
selection targets.

Either solution would avoid creating another rectangle type with an ID that
would be separate from selections.

Thoughts, comments?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
