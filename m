Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:54257 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753307Ab0ESPFd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 11:05:33 -0400
Received: from ::ffff:70.89.177.214 ([70.89.177.214]) by xenotime.net for <linux-media@vger.kernel.org>; Wed, 19 May 2010 08:05:28 -0700
Message-ID: <4BF3FE3B.9090509@xenotime.net>
Date: Wed, 19 May 2010 08:05:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 0/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
References: <33AB447FBD802F4E932063B962385B351E895D82@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351E895D82@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zhang, Xiaolin wrote:
> Hi linux-media, 
> 
> Here is the third version of V4L2 ISP driver patchset for Intel Moorestown camera imaging subsystem to address community feedback, especially from Hans. 
> 
> Beginning from this version, I am going to split the whole camera driver into two parts: one is dedicated for v4l2 subdev patchset including 4 different cameras, 1 flash led, 2 VCM lens driver and another one is dedicated for v4l2 ISP patchset including only ISP driver with different logical component. Since it is a complicated one subsystem and after this split, it is more clear without logical dependency and would be a convenient for community review. 

Please break lines around column 70 to 72.

> In this set of V4L2 ISP driver patches, I will submit the following 10 patches to add intel atom ISP support to the Linux v4l2 subsystem:
> 
> 1. control ISP data path setting 
> 2. control ISP functional block setting
> 3. 3A statistics block setting.
> 4. JPEG encoder block setting
> 5. memory interface and register spec.
> 6. specific sensor interface setting
> 7. v4l2 ISP driver implementation.
> 8. isp/sensor data structure declaration.
> 9. private ioctl information.
> 10. build system change.
> 
> Please review them and comments are welcome as always. 

Please see Documentation/SubmittingPatches, section 15:
The canonical patch format, especially the Subject: line part,
which says:

The "subsystem" in the email's Subject should identify which
area or subsystem of the kernel is being patched.

The "summary phrase" in the email's Subject should concisely
describe the patch which that email contains.  The "summary
phrase" should not be a filename.  Do not use the same "summary
phrase" for every patch in a whole patch series (where a "patch
series" is an ordered sequence of multiple, related patches).


Basically your 10 items above should be in the subject line of
the 10 patches:

Subject: [PATCH 1/10] v4l ISP: control ISP data path setting

etc.

