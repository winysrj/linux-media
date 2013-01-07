Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51172 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3AGUBE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 15:01:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: RFC: add parameters to V4L controls
Date: Mon, 07 Jan 2013 21:02:41 +0100
Message-ID: <15086879.jLpyhrHcbt@avalon>
In-Reply-To: <201301071310.54428.hverkuil@xs4all.nl>
References: <50EAA78E.4090904@samsung.com> <201301071310.54428.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 07 January 2013 13:10:54 Hans Verkuil wrote:
> On Mon January 7 2013 11:46:38 Andrzej Hajda wrote:
> > Hi,
> > 
> > I have included this proposition already in the post "[PATCH RFC 0/2]
> > V4L: Add auto focus area control and selection" but it left unanswered.
> > I repost it again in a separate e-mail, I hope this way it will be
> > easier to attract attention.
> > 
> > Problem description
> > 
> > Currently V4L2 controls can have only single value (of type int, int64,
> > string). Some hardware controls require more than single int parameter,
> > for example to set auto-focus (AF) rectangle four coordinates should be
> > passed, to set auto-focus spot two coordinates should be passed.
> > 
> > Current solution
> > 
> > In case of AF rectangle we can reuse selection API as in "[PATCH RFC
> > 0/2] V4L: Add auto focus area control and selection" post.
> > Pros:
> > - reuse existing API,
> > Cons:
> > - two IOCTL's to perform one action,
> > - non-atomic operation,

Is it really an issue in your use cases, or is this only a theoretical problem 
?

> > - fits well only for rectangles and spots (but with unused fields width,
> > height), in case of other parameters we should find a different way.
> > 
> > Proposed solution
> > 
> > The solution takes an advantage of the fact VIDIOC_(G/S/TRY)_EXT_CTRLS
> > ioctls can be called with multiple controls per call.
> > 
> > I will present it using AF area control example.
> > 
> > There could be added four pseudo-controls, lets call them for short:
> > LEFT, TOP, WIDTH, HEIGHT.
> > Those controls could be passed together with
> > V4L2_AUTO_FOCUS_AREA_RECTANGLE
> > control in one ioctl as a kind of parameters.
> > 
> > For example setting auto-focus spot would require calling
> > VIDIOC_S_EXT_CTRLS with the following controls:
> > - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
> > - LEFT = ...
> > - RIGHT = ...
> > 
> > Setting AF rectangle:
> > - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
> > - LEFT = ...
> > - TOP = ...
> > - WIDTH = ...
> > - HEIGHT = ...
> > 
> > Setting  AF object detection (no parameters required):
> > - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION
> 
> If you want to do this, then you have to make LEFT/TOP/WIDTH/HEIGHT real
> controls. There is no such thing as a pseudo control. So you need five
> new controls in total:
> 
> V4L2_CID_AUTO_FOCUS_AREA
> V4L2_CID_AUTO_FOCUS_LEFT
> V4L2_CID_AUTO_FOCUS_RIGHT
> V4L2_CID_AUTO_FOCUS_WIDTH
> V4L2_CID_AUTO_FOCUS_HEIGHT
> 
> I have no problem with this from the point of view of the control API, but
> whether this is the best solution for implementing auto-focus is a different
> issue and input from sensor specialists is needed as well (added Laurent
> and Sakari to the CC list).
> 
> The primary concern I have is that this does not scale to multiple focus
> rectangles. This might not be relevant to auto focus, though.

Time to implement a rectangle control type ? Or to make it possible to issue 
atomic transactions across ioctls ? We've been postponing this discussion for 
ages.

> > I have presented all three cases to show the advantages of this solution:
> > - atomicity - control and its parameters are passed in one call,
> > - flexibility - we are not limited by a fixed number of parameters,
> > - no-redundancy - we can pass only required parameters
> > 
> > 	(no need to pass null width and height in case of spot selection),
> > 
> > - extensibility - it is possible to extend parameters in the future,
> > for example add parameters to V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION,
> > without breaking API,
> > - backward compatibility,
> > - re-usability - this schema could be used in other controls,
> > 
> > 	pseudo-controls could be re-used in other controls as well.
> > 
> > - API backward compatibility.

-- 
Regards,

Laurent Pinchart

