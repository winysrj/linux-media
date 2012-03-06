Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45775 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab2CFQ07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 11:26:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Subject: Re: [PATCH v4 04/34] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION IOCTLs
Date: Tue, 06 Mar 2012 17:27:19 +0100
Message-ID: <1506799.pbV6Ic45Ex@avalon>
In-Reply-To: <20120306155036.GJ1075@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain> <12441257.HgrTH0oxIp@avalon> <20120306155036.GJ1075@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 06 March 2012 17:50:36 Sakari Ailus wrote:
> On Mon, Mar 05, 2012 at 11:59:22AM +0100, Laurent Pinchart wrote:
> > On Friday 02 March 2012 19:30:12 Sakari Ailus wrote:
> > > Add support for VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
> > > IOCTLs. They replace functionality provided by VIDIOC_SUBDEV_S_CROP and
> > > VIDIOC_SUBDEV_G_CROP IOCTLs and also add new functionality (composing).
> > > 
> > > VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP continue to be supported.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > Except for the ACTIVE name,
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Maybe we could discuss this on IRC with Tomasz ?
> 
> Tomasz wasn't online when I checked.
> 
> How about "CURRENT"?

Sounds good to me. Let's see if Tomasz will be online tomorrow ;-)

-- 
Regards,

Laurent Pinchart

