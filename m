Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44166 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab3BAWRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 17:17:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Andrzej Hajda <a.hajda@samsung.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: RFC: add parameters to V4L controls
Date: Fri, 01 Feb 2013 23:17:54 +0100
Message-ID: <1409971.Bs77k1Sp6U@avalon>
In-Reply-To: <510AA736.5060803@samsung.com>
References: <50EAA78E.4090904@samsung.com> <201301071310.54428.hverkuil@xs4all.nl> <510AA736.5060803@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 31 January 2013 18:17:42 Sylwester Nawrocki wrote:
> On 01/07/2013 01:10 PM, Hans Verkuil wrote:
> > On Mon January 7 2013 11:46:38 Andrzej Hajda wrote:
> [...]
> 
> >> Currently V4L2 controls can have only single value (of type int, int64,
> >> string). Some hardware controls require more than single int parameter,
> >> for example to set auto-focus (AF) rectangle four coordinates should be
> >> passed, to set auto-focus spot two coordinates should be passed.
> >> 
> >> Current solution
> >> 
> >> In case of AF rectangle we can reuse selection API as in "[PATCH RFC
> >> 0/2] V4L: Add auto focus area control and selection" post.
> >> Pros:
> >> - reuse existing API,
> >> Cons:
> >> - two IOCTL's to perform one action,
> >> - non-atomic operation,
> >> - fits well only for rectangles and spots (but with unused fields width,
> >> height), in case of other parameters we should find a different way.
> >> 
> >> Proposed solution
> >> 
> >> The solution takes an advantage of the fact VIDIOC_(G/S/TRY)_EXT_CTRLS
> >> ioctls can be called with multiple controls per call.
> >> 
> >> I will present it using AF area control example.
> >> 
> >> There could be added four pseudo-controls, lets call them for short:
> >> LEFT, TOP, WIDTH, HEIGHT. Those controls could be passed together with
> >> V4L2_AUTO_FOCUS_AREA_RECTANGLE control in one ioctl as a kind of
> >> parameters.
> >> 
> >> For example setting auto-focus spot would require calling
> >> VIDIOC_S_EXT_CTRLS with the following controls:
> >> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
> >> - LEFT = ...
> >> - RIGHT = ...
> >> 
> >> Setting AF rectangle:
> >> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
> >> - LEFT = ...
> >> - TOP = ...
> >> - WIDTH = ...
> >> - HEIGHT = ...
> >> 
> >> Setting  AF object detection (no parameters required):
> >> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION
> > 
> > If you want to do this, then you have to make LEFT/TOP/WIDTH/HEIGHT real
> > controls. There is no such thing as a pseudo control. So you need five
> > new controls in total:
> > 
> > V4L2_CID_AUTO_FOCUS_AREA
> > V4L2_CID_AUTO_FOCUS_LEFT
> > V4L2_CID_AUTO_FOCUS_RIGHT
> > V4L2_CID_AUTO_FOCUS_WIDTH
> > V4L2_CID_AUTO_FOCUS_HEIGHT
> > 
> > I have no problem with this from the point of view of the control API, but
> > whether this is the best solution for implementing auto-focus is a
> > different issue and input from sensor specialists is needed as well
> > (added Laurent and Sakari to the CC list).
> > 
> > The primary concern I have is that this does not scale to multiple focus
> > rectangles. This might not be relevant to auto focus, though.
> 
> I think for more advanced hardware/configurations there is a need to
> associate more information with the rectangles anyway. So the selections
> API seems too limited. Probably a new IOCTL would be needed for that,
> either standard or private.
> 
> We've discussed it here with Andrzej and using such 4 controls to specify
> the AF rectangle looks sufficient from our POV.
> 
> I would just probably rename LEFT/RIGHT to POS_X/POS_Y or something,
> as these 2 controls could be used in a focus mode where only spot
> position needs to be specified.

If position and size are sufficient, could we use the selection API instead ? 
An alternative would be to introduce rectangle controls. I'm a bit 
uncomfortable with using 4 controls here, as this could quickly grow out of 
control.

-- 
Regards,

Laurent Pinchart

