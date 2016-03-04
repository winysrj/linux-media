Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48657 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710AbcCDUFa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 15:05:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 4/8] media: Rename is_media_entity_v4l2_io to is_media_entity_v4l2_video_device
Date: Fri, 04 Mar 2016 22:05:19 +0200
Message-ID: <9109129.tbtAE6EurM@avalon>
In-Reply-To: <56D83D1F.6020309@xs4all.nl>
References: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1456844246-18778-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <56D83D1F.6020309@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 03 March 2016 14:33:19 Hans Verkuil wrote:
> On 03/01/16 15:57, Laurent Pinchart wrote:
> > All users of is_media_entity_v4l2_io() (the exynos4-is, omap3isp,
> > davince_vpfe and omap4iss drivers) use the function to check whether
> > entities are video_device instances, either to ensure they can cast the
> > entity to a struct video_device, or to count the number of video nodes
> > users.
> > 
> > The purpose of the function is thus to identify whether the media entity
> > instance is an instance of the video_device object, not to check whether
> > it can perform I/O. Rename it accordingly, we will introduce a more
> > specific is_media_entity_v4l2_io() check when needed.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Thanks for the much clearer commit text, that makes it much more
> understandable what is going on here.

You're welcome, my pleasure.

-- 
Regards,

Laurent Pinchart

