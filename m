Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31127 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab0ERJXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 05:23:40 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 18 May 2010 17:21:45 +0800
Subject: [PATCH v3 0/8] V4L2 subdev patchset for Intel Moorestown Camera
 Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E89572B@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi linux-media, 

Here is the third version of V4L2 camera sensors and ISP driver patchset for Intel Moorestown camera imaging subsystem to address community feedback, especially from Hans. 

Beginning from this version, I am going to split the whole camera driver into two parts: one is dedicated for v4l2 subdev patchset including 4 different cameras, 1 flash led, 2 VCM lens driver and another one is dedicated for v4l2 ISP patchset including only ISP driver with different logical component. Since it is a complicated one subsystem and after this split, it is more clear without logical dependency and would be a convenient for community review. 

At this point, I only submit the v4l2 subdev patchset and the ISP patchset will be submitted later. 

In this set of v4l2 subdev driver patches, I will submit the following 8 patches to add 4 different cameras, 1 flash led, 2 VCM lens driver support to the Linux v4l2 subsystem:

1. a common sensor v4l2-subdev private structures and resolution definition. 
2. OVT 2MP camera (ov2650) sensor subdev driver.
3. OVT 5MP camera (ov5630) sensor subdev driver.
4. OVT 1.3MP camera (ov9665) sensor subdev driver.
5. Samsung 5MP camera (s5k4e1) sensor driver.
6. Analog Device (AD5820) VCM/lens subdev driver.
7. Renesas (R2A30419BX) VCMlens subdev driver
8. National Semiconductor LM3552 flash led subdev driver

Please review them and comments are welcome as always. 

Regards,

Xiaolin
Xiaolin.zhang@intel.com

