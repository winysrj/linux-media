Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4432 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0C1Ias (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 04:30:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Subject: Re: [PATCH v2 0/10] V4L2 patches for Intel Moorestown Camera Imaging Drivers
Date: Sun, 28 Mar 2010 10:31:15 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>
References: <33AB447FBD802F4E932063B962385B351D6D534A@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351D6D534A@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003281031.15064.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Xiaolin!

Here are a few comments based on a first read-through.

First of all, patch 2/10 did not seem to make it to the list for some reason.
Because of that I'm deferring reviewing patches 1/10 and (of course) 2/10.

The other patches for the i2c devices all have the same problems, so I will
only review one and you can apply the comments made there to all the others.

A general comment I have is that I think there is too much debugging code.
Creating good debug code is an art. In my experience things like DBG_entering
and DBG_leaving just clutter the code and are pretty useless once the initial
implementation phase is finished. The trick is to have just enough debug or
logging available so that you can deduce the path taken by the driver.

What I found to be very useful as well is to implement VIDIOC_LOG_STATUS to
get a full status overview of the various (sub)devices at a given moment.

On Sunday 28 March 2010 09:46:35 Zhang, Xiaolin wrote:
> Hi, 
> 
> Here is the second version of V4L2 camera sensors and ISP driver patch set to support the Intel Moorestown camera imaging subsystem. 
> 
> The Camera Imaging interface (CI) in Moorestown is responsible for still image and video capture which can handle demosaicing, color synthesis, filtering, image enhancement, etc functionalities with a integrated JPEG encode. 
> Intel Moorestown platform can support either a single camera or dual cameras. If a platform with dual camera will have one low resolution camera on the same side as this display for video conference and a high resolution camera on the opposite side the display for high quality still image capture.
> 
> The driver framework is updated to the v4l2 sub-dev and video buffer framework, in this set of driver patches, I will submit the 10 patches to enable the camera subsystem with the device drivers for ISP HW and 4 cameras module (two SoCs: 1.3MP - Omnivision 9665, 2MP - Omnivison 2650 and two RAWs: 5MP - Omnivision 5630, 5MP - Samsong s5k4e1).
> 
> 1. Intel Moorestown ISP driver - header files.

Just a single comment on these files here: I see new PIXFMT defines in a
Moorestown-specific header: just add these to videodev2.h.

Regards,

	Hans

> 2. Intel Moorestown ISP driver - V4L2 implementation including hardware component functionality  
> 3. Intel Moorestown flash sub-dev driver
> 4. Intel Moorestown 2MP camera (ov2650) sensor subdev driver.
> 5. Intel Moorestown 1.3MP camera (ov9665) sensor subdev driver.
> 6. Intel Moorestown 5MP camera (ov5630) sensor subdev driver.
> 7. Intel Moorestown 5MP camera (ov5630) lens subdev driver.
> 8. Intel Moorestown 5MP camera (s5k4e1) sensor subdev driver.
> 9. Intel Moorestown 5MP camera (s5k4e1) lens subdev driver
> 10. make/kconfig files change to enable camera drivers for intel Moorestown platform.
> 
> Please review them and comments are welcome as always. 
> 
> Regards,
> 
> Xiaolin
> Xiaolin.zhang@intel.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
