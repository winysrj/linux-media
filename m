Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35685 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932579AbbGVIVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 04:21:49 -0400
Date: Wed, 22 Jul 2015 11:21:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Bjornar Salberg <bsalberg@cisco.com>
Subject: Re: [RFC] How to get current position/status of
 iris/focus/pan/tilt/zoom?
Message-ID: <20150722082147.GA12092@valkosipuli.retiisi.org.uk>
References: <559527D7.1030408@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <559527D7.1030408@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Jul 02, 2015 at 02:00:23PM +0200, Hans Verkuil wrote:
> When using V4L2_CID_IRIS/FOCUS/PAN/TILT/ZOOM_ABSOLUTE/RELATIVE, how do you know
> when the new position has been reached? If this is controlled through a motor,
> then it may take some time and ideally you would like to be able to get the
> current absolute position (if the hardware knows) and whether the final position
> has been reached or not.

On voice coil lenses it's also not possible to know when the position has
been reached, however you can estimate when it has happened based on the
intended movement and algorithm used to move the lens. This is far from
trivial though.

For low-level lends drivers knowing where the lens is is not feasible IMO at
the moment.

> 
> In addition, it should be possible to raise fault conditions.

Do you know of hardware that can do this? The only non-buffer related
devices that can do this I'm aware of are flash controllers.

I'd only define them if there's actual hardware that can actually raise
these conditions.

> 
> The way the ABSOLUTE controls are defined is ambiguous since it doesn't say
> anything about what it returns when you read it: is that the current absolute
> position, or the last set absolute position? I suspect it is the second one.

I wonder if this has been really well thought out when the controls were
defined. I share your assumption.

> If it is the second one, then I propose a V4L2_CID_IRIS_CURRENT control (and
> ditto for the other variants) that is a read-only control returning the current
> position with the same range and unit as the ABSOLUTE control.

This makes perfect sense if you have hardware that can tell the current
position.

Only one of the RELATIVE and ABSOLUTE controls should be implemented. I
guess no driver in mainline would implement both, I've seen such outside
mainline though. :-)

> 
> For the status/fault information I think the V4L2_CID_AUTO_FOCUS_STATUS comes
> close, but it is too specific for auto focus. For manually positioning things
> this might be more suitable:
> 
> V4L2_CID_IRIS_STATUS	bitmask
> 
> 	V4L2_IRIS_STATUS_MOVING (or perhaps _BUSY?)
> 	V4L2_IRIS_STATUS_FAILED
> 
> And ditto for the other variants.

If you have hardware that can give you the information, sure.

> Interaction between V4L2_CID_FOCUS_STATUS and AUTO_FOCUS_STATUS:
> 
> If auto focus is enabled, then FOCUS_STATUS is always 0, if auto focus is
> disabled, then AUTO_FOCUS_STATUS is always IDLE.

Looks good to me.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
