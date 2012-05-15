Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758824Ab2EONpV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 09:45:21 -0400
Message-ID: <4FB25DDC.7000803@redhat.com>
Date: Tue, 15 May 2012 10:45:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	tuukkat76@gmail.com, Kamil Debski <k.debski@samsung.com>,
	Kim HeungJun <riverful@gmail.com>, teturtia@gmail.com,
	pradeep.sawlani@gmail.com
Subject: Re: [GIT PULL FOR v3.5 v2] V4L2 subdev and sensor control changes
 and SMIA++ driver
References: <20120410193559.GB4552@valkosipuli.localdomain>
In-Reply-To: <20120410193559.GB4552@valkosipuli.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-04-2012 16:35, Sakari Ailus escreveu:
> Hi Mauro,
> 
> This patchset adds
> 
> - Integer menu controls,
> - Selection IOCTL for subdevs,
> - Sensor control improvements,
> - link_validate() media entity and V4L2 subdev pad ops,
> - OMAP 3 ISP driver improvements,
> - SMIA++ sensor driver and
> - Other V4L2 and media improvements (see individual patches)
> 
> Changes since pull for 3.5 v1:
> 
> - Rebased on top of for_v3.5 branch --- some of the earlier patches are
>   included in that branch: integer menu and subdev selections
>   (apart from docs)
> - Fix DocBook build warnings in subdev selections and DPCM compressed raw
>   bayer pixel format documentation
> 
> Changes since pull for 3.4 v3:
> 
> - Changed kernel revision and V4L2 changelog dates appropriately for Linux
>   3.5.
> 
> Changes since pull v2:
> 
> - Fixed incorrect 4CC codes in documentation for compresed raw bayer formats
> 
> Changes since pull v1:
> 
> - Correct selection rectangle field description in subdev selection
>   documentation (thanks to Sylwester)
> - Use roundup() instead of ALIGN() in SMIA++ driver
> - Rebased on current media_tree.git/staging/for_v3.4
> 
> ---
> 
...
>  drivers/media/video/smiapp/smiapp-debug.h          |   32 +

Please get rid of this horrible file that has just:

#ifdef CONFIG_VIDEO_SMIAPP_DEBUG
#define DEBUG
#endif

There's absolutely no reason to add something as ugly as this. To make this
worse, it breaks media-build out-of-tree compilation:

/home/v4l/media_build/v4l/smiapp-pll.c:25:33: fatal error: smiapp/smiapp-debug.h: No such file or directory
compilation terminated.

Thanks!
Mauro
