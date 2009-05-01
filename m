Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59188 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762131AbZEAV0D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2009 17:26:03 -0400
Date: Fri, 1 May 2009 23:26:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Johnson, Charles F" <charles.f.johnson@intel.com>,
	"Zhu, Daniel" <daniel.zhu@intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/5] V4L2 patches for Intel Moorestown Camera Imaging
 Drivers
In-Reply-To: <0A882F4D99BBF6449D58E61AAFD7EDD613793923@pdsmsx502.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0905012324190.11081@axis700.grange>
References: <90b950fc0904292317m500820efv66755aed31b46853@mail.gmail.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB030548BA1B@dbde02.ent.ti.com>
 <0A882F4D99BBF6449D58E61AAFD7EDD613793923@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Apr 2009, Zhang, Xiaolin wrote:

> Hi All,
> 
> Here is the a set of V4L2 camera sensors and ISP drivers to support the 
> Intel Moorestown camera imaging subsystem. The Camera Imaging interface 
> in Moorestown is responsible for capturing both still and video frames. 
> The CI handles demosaicing, color synthesis, filtering, image 
> enhancement functions and JPEG encode. Intel Moorestown platform can 
> support either a single camera or two cameras. A platform with two 
> cameras will have on the same side as this display and the second on the 
> opposite side the display. The camera on the display side will be used 
> for video conferencing (with low resolution SoC cameras) and the other 
> camera is used to still image capture or video recode (with high 
> resolution RAW cameras).
> 
> In this set of driver patches, I will submit the 5 patches to enable the 
> ISP HW and 3 cameras module (two SoCs: 1.3MP - Omnivision 9665, 2MP - 
> Omnivison 2650 and one RAW: 5MP - Omnivision 5630).
> 1. Intel Moorestown ISP driver.
> 2. Intel Moorestown camera sensor pseudo driver. This is to uniform the 
> interfaces for ISP due to supporting dual cameras.
> 3. Intel Moorestown 2MP camera sensor driver.
> 4. Intel Moorestown 5MP camera sensor driver.
> 5. Intel Moorestown 1.3MP camera sensor driver.
> 
> I will post the above 5 patches in near feature.

I think this is a perfect candidate for the use of the v4l2-(sub)dev API, 
and should be converted to use it, am I right?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
