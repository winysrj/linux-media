Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52137 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1IFLlM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 07:41:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC] New class for low level sensors controls?
Date: Tue, 6 Sep 2011 13:41:11 +0200
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	hechtb@googlemail.com, g.liakhovetski@gmx.de
References: <20110906113653.GF1393@valkosipuli.localdomain>
In-Reply-To: <20110906113653.GF1393@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109061341.11991.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 06 September 2011 13:36:53 Sakari Ailus wrote:
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

Other controls often found in bayer sensors are black level compensation and 
test pattern.

> None of these controls are suitable for use of general purpose applications
> (let alone the end user!) but for the camera control algorithms.
> 
> We have a control class called V4L2_CTRL_CLASS_CAMERA for camera controls.
> However, the controls in this class are relatively high level controls
> which are suitable for end user. The algorithms in the libv4l or a webcam
> could implement many of these controls whereas I see that only
> V4L2_CID_EXPOSURE_ABSOLUTE might be implemented by raw bayer sensors.
> 
> My question is: would it make sense to create a new class of controls for
> the low level sensor controls in a similar fashion we have a control class
> for the flash controls?

I think it would, but I'm not sure how we should name that class. 
V4L2_CTRL_CLASS_SENSOR is tempting, but many of the controls that will be 
found there (digital gains, black leverl compensation, test pattern, ...) can 
also be found in ISPs or other hardware blocks.

-- 
Regards,

Laurent Pinchart
