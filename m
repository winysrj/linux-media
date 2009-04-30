Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21482 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZD3ISk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 04:18:40 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Johnson, Charles F" <charles.f.johnson@intel.com>,
	"Zhu, Daniel" <daniel.zhu@intel.com>
Date: Thu, 30 Apr 2009 16:18:01 +0800
Subject: [PATCH 0/5] V4L2 patches for Intel Moorestown Camera Imaging Drivers
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD613793923@pdsmsx502.ccr.corp.intel.com>
References: <90b950fc0904292317m500820efv66755aed31b46853@mail.gmail.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB030548BA1B@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB030548BA1B@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Here is the a set of V4L2 camera sensors and ISP drivers to support the Intel Moorestown camera imaging subsystem. The Camera Imaging interface in Moorestown is responsible for capturing both still and video frames. The CI handles demosaicing, color synthesis, filtering, image enhancement functions and JPEG encode. Intel Moorestown platform can support either a single camera or two cameras. A platform with two cameras will have on the same side as this display and the second on the opposite side the display. The camera on the display side will be used for video conferencing (with low resolution SoC cameras) and the other camera is used to still image capture or video recode (with high resolution RAW cameras).

In this set of driver patches, I will submit the 5 patches to enable the ISP HW and 3 cameras module (two SoCs: 1.3MP - Omnivision 9665, 2MP - Omnivison 2650 and one RAW: 5MP - Omnivision 5630).
1. Intel Moorestown ISP driver.
2. Intel Moorestown camera sensor pseudo driver. This is to uniform the interfaces for ISP due to supporting dual cameras. 
3. Intel Moorestown 2MP camera sensor driver.
4. Intel Moorestown 5MP camera sensor driver.
5. Intel Moorestown 1.3MP camera sensor driver.

I will post the above 5 patches in near feature.

Regards,

Xiaolin
Xiaolin.zhang@intel.com

