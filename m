Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33127 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2B0AW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 19:22:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 04/33] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION IOCTLs
Date: Mon, 27 Feb 2012 01:22:34 +0100
Message-ID: <1411719.Jn3cQENcA7@avalon>
In-Reply-To: <4F45D633.7080008@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1429308.tLqNDhgYvj@avalon> <4F45D633.7080008@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 23 February 2012 08:01:23 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > [snip]
> > 
> >> +/* active cropping area */
> >> +#define V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE			0x0000
> >> +/* cropping bounds */
> >> +#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			0x0002
> >> +/* current composing area */
> >> +#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE		0x0100
> >> +/* composing bounds */
> > 
> > I'm not sure if ACTIVE is a good name here. It sounds confusing as we
> > already have V4L2_SUBDEV_FORMAT_ACTIVE.
> 
> We are using V4L2_SEL_TGT_COMPOSE_ACTIVE on V4L2 nodes already --- the
> name I'm using here just mirrors the naming on V4L2 device nodes. If I
> choose a different name here, some of that analogy is lost.
> 
> That said, I'm not against changing this but the equivalent change
> should then be made on V4L2 selection API for consistency.

I'm not against changing the V4L2 selection API either :-) Just think about 
developers talking about "try crop active" or "active crop bounds". Even 
worse, will "active crop" refer to the active target or the active "which" ? 
That will be very confusing.

-- 
Regards,

Laurent Pinchart
