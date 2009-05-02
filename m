Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2619 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbZEBPmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 11:42:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 0/5] V4L2 patches for Intel Moorestown Camera Imaging Drivers
Date: Sat, 2 May 2009 17:42:44 +0200
Cc: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Johnson, Charles F" <charles.f.johnson@intel.com>,
	"Zhu, Daniel" <daniel.zhu@intel.com>
References: <90b950fc0904292317m500820efv66755aed31b46853@mail.gmail.com> <0A882F4D99BBF6449D58E61AAFD7EDD613793923@pdsmsx502.ccr.corp.intel.com> <Pine.LNX.4.64.0905012324190.11081@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0905012324190.11081@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905021742.44828.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
