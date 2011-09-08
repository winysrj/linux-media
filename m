Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55168 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab1IHLY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 07:24:29 -0400
Received: by ywf7 with SMTP id 7so550733ywf.19
        for <linux-media@vger.kernel.org>; Thu, 08 Sep 2011 04:24:29 -0700 (PDT)
Message-ID: <4E68A5E7.8070800@gmail.com>
Date: Thu, 08 Sep 2011 16:54:23 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	hechtb@googlemail.com, g.liakhovetski@gmx.de
Subject: Re: [RFC] New class for low level sensors controls?
References: <20110906113653.GF1393@valkosipuli.localdomain> <201109061341.11991.laurent.pinchart@ideasonboard.com> <20110906122226.GH1393@valkosipuli.localdomain>
In-Reply-To: <20110906122226.GH1393@valkosipuli.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/06/2011 05:52 PM, Sakari Ailus wrote:
> On Tue, Sep 06, 2011 at 01:41:11PM +0200, Laurent Pinchart wrote:
>> Hi Sakari,
>>
>> On Tuesday 06 September 2011 13:36:53 Sakari Ailus wrote:
>>> Hi all,
>>>
>>> We are beginning to have raw bayer image sensor drivers in the mainline.
>>> Typically such sensors are not controlled by general purpose applications
>>> but e.g. require a camera control algorithm framework in user space. This
>>> needs to be implemented in libv4l for general purpose applications to work
>>> properly on this kind of hardware.
>>>
>>> These sensors expose controls such as
>>>
>>> - Per-component gain controls. Red, blue, green (blue) and green (red)
>>>    gains.
>>>
>>> - Link frequency. The frequency of the data link from the sensor to the
>>>    bridge.
>>>
>>> - Horizontal and vertical blanking.
>>
>> Other controls often found in bayer sensors are black level compensation and
>> test pattern.

Does all BAYER sensor allow the dark level compensation programming? I 
thought it must be auto dark level compensation, which is done by the 
sensor. The sensor detects the optical black value at start of each 
frame, and analog-to-digital conversion is shifted to compensate the 
dark level for that frame. Hence I am thinking if this should be a 
controllable feature.

>>
>>> None of these controls are suitable for use of general purpose applications
>>> (let alone the end user!) but for the camera control algorithms.
>>>
>>> We have a control class called V4L2_CTRL_CLASS_CAMERA for camera controls.
>>> However, the controls in this class are relatively high level controls
>>> which are suitable for end user. The algorithms in the libv4l or a webcam
>>> could implement many of these controls whereas I see that only
>>> V4L2_CID_EXPOSURE_ABSOLUTE might be implemented by raw bayer sensors.
>>>
>>> My question is: would it make sense to create a new class of controls for
>>> the low level sensor controls in a similar fashion we have a control class
>>> for the flash controls?
>>
>> I think it would, but I'm not sure how we should name that class.
>> V4L2_CTRL_CLASS_SENSOR is tempting, but many of the controls that will be
>> found there (digital gains, black leverl compensation, test pattern, ...) can
>> also be found in ISPs or other hardware blocks.
>
> I don't think ISPs typically implement test patterns. Do you know of any?
>
I know atleast two sensors (ov5642 and s5k4bafx) which have inbuilt ISP, 
programmed through i2c. They both have test patten generator. I think 
RAW(BAYER) sensors themselves cannot generate a test pattern without 
some h/w entity to convert RGGB into color bars in RGB or YUV.

> Should we separate controls which clearly apply to sensors only from the
> rest?
>
> For sensors only:
>
> - Analog gain(s)
> - Horizontal and vertical blanking
> - Link frequency
> - Test pattern

Where should the shutter operation be listed into? Also type (rolling, 
global) and method (manual, electronic) of shutter operation?

>
> The following can be implemented also on ISPs:
>
> - Per-component gains
> - Black level compensation
>
> Do we have more to add to the list?
>
> If we keep the two the same class, I could propose the following names:
>
> V4L2_CTRL_CLASS_LL_CAMERA (for low level camera)

Instead of LL_CAMERA, wouldnt something like CAM_SENSOR_ARRAY would be 
more meaningful? We control the sensor array properties in this level.

> V4L2_CTRL_CLASS_SOURCE
> V4L2_CTRL_CLASS_IMAGE_SOURCE
>
> The last one would be a good name for the sensor control class, as far as I
> understand some are using tuners with the OMAP 3 ISP these days. For the
> another one, I propose V4L2_CTRL_CLASS_ISP.
>
> Better names are always welcome. :-)
>

Regards,
Subash
