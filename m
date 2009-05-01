Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17240 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765140AbZEAPCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2009 11:02:22 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Johnson, Charles F" <charles.f.johnson@intel.com>,
	"Zhu, Daniel" <daniel.zhu@intel.com>
Date: Fri, 1 May 2009 23:01:52 +0800
Subject: RE: [PATCH 0/5] V4L2 patches for Intel Moorestown Camera Imaging
 	Drivers
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD613793A72@pdsmsx502.ccr.corp.intel.com>
References: <90b950fc0904292317m500820efv66755aed31b46853@mail.gmail.com>
	 <5A47E75E594F054BAF48C5E4FC4B92AB030548BA1B@dbde02.ent.ti.com>
	 <0A882F4D99BBF6449D58E61AAFD7EDD613793923@pdsmsx502.ccr.corp.intel.com>
 <5e9665e10904300232teee3ddq95e3cb60d95445e4@mail.gmail.com>
In-Reply-To: <5e9665e10904300232teee3ddq95e3cb60d95445e4@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yes, I am working on it. maybe it is caused from ISP big size issue.  I am trying to reduce the ISP driver code (around 800k)

Xiaolin

-----Original Message-----
From: Dongsoo, Nathaniel Kim [mailto:dongsoo.kim@gmail.com] 
Sent: Thursday, April 30, 2009 5:33 PM
To: Zhang, Xiaolin
Cc: linux-media@vger.kernel.org; Johnson, Charles F; Zhu, Daniel
Subject: Re: [PATCH 0/5] V4L2 patches for Intel Moorestown Camera Imaging Drivers

Hello Xiaolin,

I think the first patch is missing. Following your description, it may
be the "Intel Moorestown ISP driver.".
Can you re-post it please?
BTW, I didn't notice that Atom processor had a camera interface, and
even it supports dual camera as well. Can I find some datasheet or
user manual to take a look at how it works?
Cheers,

Nate

On Thu, Apr 30, 2009 at 5:18 PM, Zhang, Xiaolin <xiaolin.zhang@intel.com> wrote:
> Hi All,
>
> Here is the a set of V4L2 camera sensors and ISP drivers to support the Intel Moorestown camera imaging subsystem. The Camera Imaging interface in Moorestown is responsible for capturing both still and video frames. The CI handles demosaicing, color synthesis, filtering, image enhancement functions and JPEG encode. Intel Moorestown platform can support either a single camera or two cameras. A platform with two cameras will have on the same side as this display and the second on the opposite side the display. The camera on the display side will be used for video conferencing (with low resolution SoC cameras) and the other camera is used to still image capture or video recode (with high resolution RAW cameras).
>
> In this set of driver patches, I will submit the 5 patches to enable the ISP HW and 3 cameras module (two SoCs: 1.3MP - Omnivision 9665, 2MP - Omnivison 2650 and one RAW: 5MP - Omnivision 5630).
> 1. Intel Moorestown ISP driver.
> 2. Intel Moorestown camera sensor pseudo driver. This is to uniform the interfaces for ISP due to supporting dual cameras.
> 3. Intel Moorestown 2MP camera sensor driver.
> 4. Intel Moorestown 5MP camera sensor driver.
> 5. Intel Moorestown 1.3MP camera sensor driver.
>
> I will post the above 5 patches in near feature.
>
> Regards,
>
> Xiaolin
> Xiaolin.zhang@intel.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
