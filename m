Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58759 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933610AbbGHLZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jul 2015 07:25:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Bjornar Salberg <bsalberg@cisco.com>
Subject: Re: [RFC] How to get current position/status of iris/focus/pan/tilt/zoom?
Date: Wed, 08 Jul 2015 14:25:18 +0300
Message-ID: <2062145.8YAJ1MQW9W@avalon>
In-Reply-To: <559527D7.1030408@xs4all.nl>
References: <559527D7.1030408@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 02 July 2015 14:00:23 Hans Verkuil wrote:
> When using V4L2_CID_IRIS/FOCUS/PAN/TILT/ZOOM_ABSOLUTE/RELATIVE, how do you
> know when the new position has been reached? If this is controlled through
> a motor, then it may take some time and ideally you would like to be able
> to get the current absolute position (if the hardware knows) and whether
> the final position has been reached or not.

There's only two drivers implementing pan and tilt (pwc and uvcvideo), one 
driver implementing focus and iris (uvcvideo) and three drivers implementing 
zoom (uvcvideo, m5mols and s5c73m3). Both m5mols and s5c73m3 seem to use the 
zoom control for digital zoom, so we can ignore them for this discussion. 
Where's thus left with pwc and uvcvideo. I'll comment mainly on the latter.

> In addition, it should be possible to raise fault conditions.

UVC specifies a way to implement asynchronous controls and report, through a 
USB interrupt endpoint, completion of the control set operation. This can be 
used by devices to report that physical motion has finished, or to report 
errors. Whether a control is implemented in a synchronous or asynchronous way 
is device dependent.

> The way the ABSOLUTE controls are defined is ambiguous since it doesn't say
> anything about what it returns when you read it: is that the current
> absolute position, or the last set absolute position? I suspect it is the
> second one.
>
> If it is the second one, then I propose a V4L2_CID_IRIS_CURRENT control (and
> ditto for the other variants) that is a read-only control returning the
> current position with the same range and unit as the ABSOLUTE control.

UVC doesn't explicitly define what a device should report. It hints in a 
couple of places that it should be the current position, but I believe it 
might be device-dependent in practice.

> For the status/fault information I think the V4L2_CID_AUTO_FOCUS_STATUS
> comes close, but it is too specific for auto focus. For manually
> positioning things this might be more suitable:
> 
> V4L2_CID_IRIS_STATUS	bitmask
> 
> 	V4L2_IRIS_STATUS_MOVING (or perhaps _BUSY?)
> 	V4L2_IRIS_STATUS_FAILED
> 
> And ditto for the other variants.

Do we need to report that the control set operation is in progress, or could 
applications infer that information from the fact that they haven't received a 
control change event that notifies of end of motion ?

Failures need to be reported, but they're not limited to the controls you 
mention above, at least in theory. A UVC device is free to implement any 
control as an asynchronous control and report failures. Would it make sense to 
add a control change error event instead of creating status controls for lots 
of V4L2 controls ?

> Interaction between V4L2_CID_FOCUS_STATUS and AUTO_FOCUS_STATUS:
> 
> If auto focus is enabled, then FOCUS_STATUS is always 0, if auto focus is
> disabled, then AUTO_FOCUS_STATUS is always IDLE.

-- 
Regards,

Laurent Pinchart

