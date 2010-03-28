Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:16368 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab0C1HrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 03:47:03 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 15:46:35 +0800
Subject: [PATCH v2 0/10] V4L2 patches for Intel Moorestown Camera Imaging
 Drivers
Message-ID: <33AB447FBD802F4E932063B962385B351D6D534A@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

Here is the second version of V4L2 camera sensors and ISP driver patch set to support the Intel Moorestown camera imaging subsystem. 

The Camera Imaging interface (CI) in Moorestown is responsible for still image and video capture which can handle demosaicing, color synthesis, filtering, image enhancement, etc functionalities with a integrated JPEG encode. 
Intel Moorestown platform can support either a single camera or dual cameras. If a platform with dual camera will have one low resolution camera on the same side as this display for video conference and a high resolution camera on the opposite side the display for high quality still image capture.

The driver framework is updated to the v4l2 sub-dev and video buffer framework, in this set of driver patches, I will submit the 10 patches to enable the camera subsystem with the device drivers for ISP HW and 4 cameras module (two SoCs: 1.3MP - Omnivision 9665, 2MP - Omnivison 2650 and two RAWs: 5MP - Omnivision 5630, 5MP - Samsong s5k4e1).

1. Intel Moorestown ISP driver - header files.
2. Intel Moorestown ISP driver - V4L2 implementation including hardware component functionality  
3. Intel Moorestown flash sub-dev driver
4. Intel Moorestown 2MP camera (ov2650) sensor subdev driver.
5. Intel Moorestown 1.3MP camera (ov9665) sensor subdev driver.
6. Intel Moorestown 5MP camera (ov5630) sensor subdev driver.
7. Intel Moorestown 5MP camera (ov5630) lens subdev driver.
8. Intel Moorestown 5MP camera (s5k4e1) sensor subdev driver.
9. Intel Moorestown 5MP camera (s5k4e1) lens subdev driver
10. make/kconfig files change to enable camera drivers for intel Moorestown platform.

Please review them and comments are welcome as always. 

Regards,

Xiaolin
Xiaolin.zhang@intel.com
