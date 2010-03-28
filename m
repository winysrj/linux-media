Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45406 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab0C1LaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 07:30:06 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>
Date: Sun, 28 Mar 2010 19:28:25 +0800
Subject: RE: [PATCH v2 0/10] V4L2 patches for Intel Moorestown Camera
 Imaging Drivers
Message-ID: <33AB447FBD802F4E932063B962385B351D6D5359@shsmsx501.ccr.corp.intel.com>
References: <33AB447FBD802F4E932063B962385B351D6D534A@shsmsx501.ccr.corp.intel.com>
 <201003281031.15064.hverkuil@xs4all.nl>
In-Reply-To: <201003281031.15064.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you comment. I will try to figure out why patch 2/10 is missing. maybe it is a little bit large. I will split it two more patches and resubmit again.

BRs
Xiaolin

-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Sunday, March 28, 2010 4:31 PM
To: Zhang, Xiaolin
Cc: linux-media@vger.kernel.org; Zhu, Daniel; Yu, Jinlu; Wang, Wen W; Huang, Kai; Hu, Gang A; Ba, Zheng
Subject: Re: [PATCH v2 0/10] V4L2 patches for Intel Moorestown Camera Imaging Drivers

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
