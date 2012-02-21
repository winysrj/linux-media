Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50382 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab2BUQPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 11:15:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 04/33] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION IOCTLs
Date: Tue, 21 Feb 2012 17:15:05 +0100
Message-ID: <1429308.tLqNDhgYvj@avalon>
In-Reply-To: <1329703032-31314-4-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-4-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

One more comment.

On Monday 20 February 2012 03:56:43 Sakari Ailus wrote:

[snip]

> +/* active cropping area */
> +#define V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE			0x0000
> +/* cropping bounds */
> +#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			0x0002
> +/* current composing area */
> +#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE		0x0100
> +/* composing bounds */

I'm not sure if ACTIVE is a good name here. It sounds confusing as we already 
have V4L2_SUBDEV_FORMAT_ACTIVE.

-- 
Regards,

Laurent Pinchart
