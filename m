Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56835 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754011Ab3ALWCR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jan 2013 17:02:17 -0500
Message-ID: <50F1DE2B.6060508@iki.fi>
Date: Sun, 13 Jan 2013 00:05:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
CC: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: RFC: add parameters to V4L controls
References: <50EAA78E.4090904@samsung.com>
In-Reply-To: <50EAA78E.4090904@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Andrzej Hajda wrote:
> Hi,
> 
> I have included this proposition already in the post "[PATCH RFC 0/2]
> V4L: Add auto focus area control and selection" but it left unanswered.
> I repost it again in a separate e-mail, I hope this way it will be
> easier to attract attention.
> 
> Problem description
> 
> Currently V4L2 controls can have only single value (of type int, int64,
> string). Some hardware controls require more than single int parameter,
> for example to set auto-focus (AF) rectangle four coordinates should be
> passed, to set auto-focus spot two coordinates should be passed.
> 
> Current solution
> 
> In case of AF rectangle we can reuse selection API as in "[PATCH RFC
> 0/2] V4L: Add auto focus area control and selection" post.
> Pros:
> - reuse existing API,
> Cons:
> - two IOCTL's to perform one action,

I think changing AF mode and AF window of interest are still two
operations: you may well change just either one, and be happy with it.
You might want to disable AF during the configuration from the
application. Would this work for you?

> - non-atomic operation,

True, but this is the way V4L2 works.

There are many cases where implementing multiple more or less unrelated
operations atomically would be beneficial, but so far there always have
been workarounds to perform those actions non-atomicly. Format
configuration, for example.

Atomic operations are hard to get right and typically the required
effort refutes the gain of doing so in drivers, and everything that may
be done atomically always must be implemented beforehand in drivers.

Your use case would be from the more simple end, though.

> - fits well only for rectangles and spots (but with unused fields width,
> height), in case of other parameters we should find a different way.
> 
> Proposed solution
> 
> The solution takes an advantage of the fact VIDIOC_(G/S/TRY)_EXT_CTRLS
> ioctls can be called with multiple controls per call.
> 
> I will present it using AF area control example.
> 
> There could be added four pseudo-controls, lets call them for short:
> LEFT, TOP, WIDTH, HEIGHT.
> Those controls could be passed together with V4L2_AUTO_FOCUS_AREA_RECTANGLE
> control in one ioctl as a kind of parameters.
> 
> For example setting auto-focus spot would require calling
> VIDIOC_S_EXT_CTRLS
> with the following controls:
> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
> - LEFT = ...
> - RIGHT = ...
> 
> Setting AF rectangle:
> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
> - LEFT = ...
> - TOP = ...
> - WIDTH = ...
> - HEIGHT = ...
> 
> Setting  AF object detection (no parameters required):
> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION
> 
> I have presented all three cases to show the advantages of this solution:
> - atomicity - control and its parameters are passed in one call,
> - flexibility - we are not limited by a fixed number of parameters,
> - no-redundancy - we can pass only required parameters
>     (no need to pass null width and height in case of spot selection),
> - extensibility - it is possible to extend parameters in the future,
> for example add parameters to V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION,
> without breaking API,
> - backward compatibility,
> - re-usability - this schema could be used in other controls,
>     pseudo-controls could be re-used in other controls as well.
> - API backward compatibility.

What I'm not terribly fond of in the above proposal is that it uses
several controls to describe rectangles which are an obvious domain of
the selection API: selections are roughly like controls but rather use a
rectangle type instead of a single integer value (or a string).

Also, I can't see any other reason to use controls for this than making
the operation atomic.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
