Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4759 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1IZJvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 05:51:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC] New class for low level sensors controls?
Date: Mon, 26 Sep 2011 11:51:05 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hechtb@googlemail.com,
	g.liakhovetski@gmx.de
References: <20110906113653.GF1393@valkosipuli.localdomain>
In-Reply-To: <20110906113653.GF1393@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261151.05572.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 06, 2011 13:36:53 Sakari Ailus wrote:
> Hi all,
> 
> We are beginning to have raw bayer image sensor drivers in the mainline.
> Typically such sensors are not controlled by general purpose applications
> but e.g. require a camera control algorithm framework in user space. This
> needs to be implemented in libv4l for general purpose applications to work
> properly on this kind of hardware.
> 
> These sensors expose controls such as
> 
> - Per-component gain controls. Red, blue, green (blue) and green (red)
>   gains.
> 
> - Link frequency. The frequency of the data link from the sensor to the
>   bridge.
> 
> - Horizontal and vertical blanking.
> 
> None of these controls are suitable for use of general purpose applications
> (let alone the end user!) but for the camera control algorithms.
> 
> We have a control class called V4L2_CTRL_CLASS_CAMERA for camera controls.
> However, the controls in this class are relatively high level controls which
> are suitable for end user. The algorithms in the libv4l or a webcam could
> implement many of these controls whereas I see that only
> V4L2_CID_EXPOSURE_ABSOLUTE might be implemented by raw bayer sensors.
> 
> My question is: would it make sense to create a new class of controls for
> the low level sensor controls in a similar fashion we have a control class
> for the flash controls?

I'm plowing through all the mails on this list that piled up during the last
3-4 weeks, so my reply is a bit late :-)

I don't believe a new class is the right approach. If such controls are part
of a sub-device, then they can be marked 'private', which means they are only
accessible through the subdev device node.

For low-level controls that are part of the bridge chip there is currently no
suitable way of hiding them.

In that case the best approach would be to add a new control flag called
V4L2_CTRL_FLAG_HIDE (or _INVISIBLE, or _LOW_LEVEL, or something similar).
Applications can filter such controls and not show them.

I've toyed with this idea before, but of course it has the disadvantage of
requiring application support.

One alternative to this is to let QUERYCTRL skip such hidden controls unless
instructed otherwise (e.g. by adding a V4L2_CTRL_FLAG_SHOW_ALL to the control's
id). But I think that's getting a bit too complex.

I think adding a 'HIDE' flag of some sort is a good idea. It's simple and does
the job.

Regards,

	Hans
