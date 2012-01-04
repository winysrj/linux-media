Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:35098 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2ADOE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 09:04:27 -0500
Date: Wed, 4 Jan 2012 16:04:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC/PATCH 1/5] v4l: Convert V4L2_CID_FOCUS_AUTO control to a
 menu control
Message-ID: <20120104140422.GD9323@valkosipuli.localdomain>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
 <20111231120025.GD3677@valkosipuli.localdomain>
 <4F008E87.1070706@gmail.com>
 <201201021217.00336.laurent.pinchart@ideasonboard.com>
 <4F0219C3.1030401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0219C3.1030401@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Mon, Jan 02, 2012 at 09:55:31PM +0100, Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> On 01/02/2012 12:16 PM, Laurent Pinchart wrote:
> >> * controls for starting/stopping auto focusing (V4L2_CID_FOCUS_AUTO ==
> >> false)
> >>
> >>   V4L2_CID_START_AUTO_FOCUS (button) - start auto focusing,
> >>   V4L2_CID_STOP_AUTO_FOCUS  (button) - stop auto focusing (might be also
> >>                                        useful in V4L2_FOCUS_AUTO == true),
> > 
> > Maybe V4L2_CID_AUTO_FOCUS_START and V4L2_CID_AUTO_FOCUS_STOP to be consistent 
> > with the other proposed controls ?
> 
> Yes, you're right, I'll change them to make consistent with others.
> I've noticed that too, but a little bit too late:)
> 
> >> * auto focus status
> >>
> >>   V4L2_CID_AUTO_FOCUS_STATUS (menu, read-only) - whether focusing is in
> >>                                                  progress or not,
> >>   possible entries:
> >>
> >>   - V4L2_AUTO_FOCUS_STATUS_IDLE,    // auto focusing not enabled or force
> >>                                        stopped 
> >>   - V4L2_AUTO_FOCUS_STATUS_BUSY,    // focusing in progress
> >>   - V4L2_AUTO_FOCUS_STATUS_SUCCESS, // single-shot auto focusing succeed
> >>                                     // or continuous AF in progress
> >>   - V4L2_AUTO_FOCUS_STATUS_FAIL,    // auto focusing failed
> >>
> >>
> >> * V4L2_CID_FOCUS_AUTO would retain its current semantics:
> >>
> >>   V4L2_CID_FOCUS_AUTO (boolean) - selects auto/manual focus
> >>       false - manual
> >>       true  - auto continuous
> >>
> >> * AF algorithm scan range, V4L2_CID_FOCUS_AUTO_SCAN_RANGE with choices:
> >>
> >>   - V4L2_AUTO_FOCUS_SCAN_RANGE_NORMAL,
> >>   - V4L2_AUTO_FOCUS_SCAN_RANGE_MACRO,
> >>   - V4L2_AUTO_FOCUS_SCAN_RANGE_INFINITY
> >>
> ...
> >>
> >> * select auto focus mode
> >>
> >> V4L2_CID_AUTO_FOCUS_MODE
> >>         V4L2_AUTO_FOCUS_MODE_NORMAL     - "normal" auto focus (whole frame?)
> >>         V4L2_AUTO_FOCUS_MODE_SPOT       - spot location passed with other
> >>         controls or selection API
> >>         V4L2_AUTO_FOCUS_MODE_RECTANGLE  - rectangle passed with other
> >>         controls or selection API
> > 
> > Soudns good to me.
> >
> >>> parameter. We also need to discuss how the af statistics window
> >>> configuration is done. I'm not certain there could even be a standardised
> >>
> >> Do we need multiple windows for AF statistics ?
> >>
> >> If not, I'm inclined to use four separate controls for window
> >> configuration. (X, Y, WIDTH, HEIGHT). This was Hans' preference in
> >> previous discussions [1].
> > 
> > For the OMAP3 ISP we need multiple statistics windows. AEWB can use more than 
> > 32 windows. Having separate controls for that wouldn't be practical.
> 
> OK, so the control API in current form doesn't seem capable of setting up the
> statistics windows. There is also little space in struct v4l2_ext_control for
> any major extensions.
> 
> We might need to define dedicated set of selection targets in the selection
> API for handling multiple windows.
> 
> Yet, to avoid forcing applications to use the selection API where rectangles
> aren't needed - only single spot coordinates, how about defining following
> two controls ?
> 
> * AF spot coordinates when focus mode is set to V4L2_AUTO_FOCUS_MODE_SPOT
> 
>  - V4L2_CID_AUTO_FOCUS_POSITION_X - horizontal position in pixels relative
>                                     to the left of frame
>  - V4L2_CID_AUTO_FOCUS_POSITION_Y - vertical position in pixels relative
>                                     to the top of frame

What's a spot focus mode?

Any AF statistics from a single pixel have no meaning, so there has to be
more. It sounds like a small rectangle to me. :-)

But being able to provide more windows would be rather important. You don't
need to look at too special cameras before you can have seven or so focus
windows.

The selection API could be used for this, as proposed already. We could have
a new V4L2_(SUBDEV_)SELECTION_STAT_AF target to configure windows. We could
add an id field to define the window ID to struct v4l2_(subdev_)selection.
One control would be required to tell how many statistics windows do you
have.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
