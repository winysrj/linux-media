Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32275 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab0ESDFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 23:05:46 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 19 May 2010 11:03:53 +0800
Subject: [PATCH v3 0/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895D82@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi linux-media, 

Here is the third version of V4L2 ISP driver patchset for Intel Moorestown camera imaging subsystem to address community feedback, especially from Hans. 

Beginning from this version, I am going to split the whole camera driver into two parts: one is dedicated for v4l2 subdev patchset including 4 different cameras, 1 flash led, 2 VCM lens driver and another one is dedicated for v4l2 ISP patchset including only ISP driver with different logical component. Since it is a complicated one subsystem and after this split, it is more clear without logical dependency and would be a convenient for community review. 

In this set of V4L2 ISP driver patches, I will submit the following 10 patches to add intel atom ISP support to the Linux v4l2 subsystem:

1. control ISP data path setting 
2. control ISP functional block setting
3. 3A statistics block setting.
4. JPEG encoder block setting
5. memory interface and register spec.
6. specific sensor interface setting
7. v4l2 ISP driver implementation.
8. isp/sensor data structure declaration.
9. private ioctl information.
10. build system change.

Please review them and comments are welcome as always. 

Regards,

Xiaolin
Xiaolin.zhang@intel.com
