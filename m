Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38331 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbZEDPpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 11:45:01 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Johnson, Charles F" <charles.f.johnson@intel.com>,
	"Zhu, Daniel" <daniel.zhu@intel.com>
Date: Mon, 4 May 2009 23:44:54 +0800
Subject: RE: [PATCH 0/5] V4L2 patches for Intel Moorestown Camera Imaging
 Drivers
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD613810FEB@pdsmsx502.ccr.corp.intel.com>
References: <90b950fc0904292317m500820efv66755aed31b46853@mail.gmail.com>
 <0A882F4D99BBF6449D58E61AAFD7EDD613793923@pdsmsx502.ccr.corp.intel.com>
 <Pine.LNX.4.64.0905012324190.11081@axis700.grange>
 <200905021742.44828.hverkuil@xs4all.nl>
In-Reply-To: <200905021742.44828.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good comments. Only ISP driver is based on the V4L2 driver framework. The camera sensor used on the Moorestown platform is based on the I2C client driver. I will look at the Documentation/video4linux/v4l2-framework.txt and will consider your comment in our future plan. 

Welcome any more comments.

Thanks,
Xiaolin

-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Hans Verkuil
Sent: Saturday, May 02, 2009 11:43 PM
To: Guennadi Liakhovetski
Cc: Zhang, Xiaolin; linux-media@vger.kernel.org; Johnson, Charles F; Zhu, Daniel
Subject: Re: [PATCH 0/5] V4L2 patches for Intel Moorestown Camera Imaging Drivers

On Friday 01 May 2009 23:26:02 Guennadi Liakhovetski wrote:
> On Thu, 30 Apr 2009, Zhang, Xiaolin wrote:
> > Hi All,
> >
> > Here is the a set of V4L2 camera sensors and ISP drivers to support the
> > Intel Moorestown camera imaging subsystem. The Camera Imaging interface
> > in Moorestown is responsible for capturing both still and video frames.
> > The CI handles demosaicing, color synthesis, filtering, image
> > enhancement functions and JPEG encode. Intel Moorestown platform can
> > support either a single camera or two cameras. A platform with two
> > cameras will have on the same side as this display and the second on
> > the opposite side the display. The camera on the display side will be
> > used for video conferencing (with low resolution SoC cameras) and the
> > other camera is used to still image capture or video recode (with high
> > resolution RAW cameras).
> >
> > In this set of driver patches, I will submit the 5 patches to enable
> > the ISP HW and 3 cameras module (two SoCs: 1.3MP - Omnivision 9665, 2MP
> > - Omnivison 2650 and one RAW: 5MP - Omnivision 5630).
> > 1. Intel Moorestown ISP driver.
> > 2. Intel Moorestown camera sensor pseudo driver. This is to uniform the
> > interfaces for ISP due to supporting dual cameras.
> > 3. Intel Moorestown 2MP camera sensor driver.
> > 4. Intel Moorestown 5MP camera sensor driver.
> > 5. Intel Moorestown 1.3MP camera sensor driver.
> >
> > I will post the above 5 patches in near feature.
>
> I think this is a perfect candidate for the use of the v4l2-(sub)dev API,
> and should be converted to use it, am I right?

Absolutely. The sensor drivers must use v4l2_subdev, otherwise they will not 
be reusable by other drivers.

There is a lot of work that needs to be done before these sensor drivers can 
be merged. These sensor drivers are tightly coupled to the platform driver, 
thus preventing any reuse of these i2c devices. That's bad and something 
that needs to be fixed first.

Xiaolin, please take a look at Documentation/video4linux/v4l2-framework.txt 
for information on the new v4l2 framework. All v4l2 i2c drivers should use 
v4l2_subdev to enable reuse of these i2c devices in other platform drivers 
and webcams.

Regards,

	Hans

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
