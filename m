Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:29454 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270Ab2BXLte (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 06:49:34 -0500
Message-ID: <4F45D633.7080008@iki.fi>
Date: Thu, 23 Feb 2012 08:01:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 04/33] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
 IOCTLs
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-4-git-send-email-sakari.ailus@iki.fi> <1429308.tLqNDhgYvj@avalon>
In-Reply-To: <1429308.tLqNDhgYvj@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> [snip]
> 
>> +/* active cropping area */
>> +#define V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE			0x0000
>> +/* cropping bounds */
>> +#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			0x0002
>> +/* current composing area */
>> +#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE		0x0100
>> +/* composing bounds */
> 
> I'm not sure if ACTIVE is a good name here. It sounds confusing as we already 
> have V4L2_SUBDEV_FORMAT_ACTIVE.

We are using V4L2_SEL_TGT_COMPOSE_ACTIVE on V4L2 nodes already --- the
name I'm using here just mirrors the naming on V4L2 device nodes. If I
choose a different name here, some of that analogy is lost.

That said, I'm not against changing this but the equivalent change
should then be made on V4L2 selection API for consistency.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
