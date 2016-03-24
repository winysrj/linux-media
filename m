Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56835 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbcCXL5j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 07:57:39 -0400
Date: Thu, 24 Mar 2016 08:57:22 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	<linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v6 0/2] media: Add entity types
Message-ID: <20160324085722.04419e58@recife.lan>
In-Reply-To: <2944762.eWEcyXcTe9@avalon>
References: <1458809408-32611-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<20160324083840.6fb306b4@recife.lan>
	<2944762.eWEcyXcTe9@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 24 Mar 2016 13:54:57 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> On Thursday 24 Mar 2016 08:38:40 Mauro Carvalho Chehab wrote:
> > Em Thu, 24 Mar 2016 10:50:06 +0200 Laurent Pinchart escreveu:  
> > > Hello,
> > > 
> > > This patch series adds an obj_type field to the media entity structure. It
> > > is a resend of v5 with the MEDIA_ENTITY_TYPE_INVALID type replaced by
> > > MEDIA_ENTITY_TYPE_BASE to identify media entity instances not embedded in
> > > another structure.  
> > 
> > Patches looked OK to me. I'll apply them next week.  
> 
> Thank you. I'll send a patch series for the VSP driver that applies on top of 
> these two patches, and will send the pull request when media entity types will 
> be merged in your tree.

Well, you can put the VSP patches and this series on the same pull request.

> 
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > > Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> > > 
> > > Laurent Pinchart (2):
> > >   media: Add obj_type field to struct media_entity
> > >   media: Rename is_media_entity_v4l2_io to
> > >   
> > >     is_media_entity_v4l2_video_device
> > >  
> > >  drivers/media/platform/exynos4-is/media-dev.c   |  4 +-
> > >  drivers/media/platform/omap3isp/ispvideo.c      |  2 +-
> > >  drivers/media/v4l2-core/v4l2-dev.c              |  1 +
> > >  drivers/media/v4l2-core/v4l2-mc.c               |  2 +-
> > >  drivers/media/v4l2-core/v4l2-subdev.c           |  1 +
> > >  drivers/staging/media/davinci_vpfe/vpfe_video.c |  2 +-
> > >  drivers/staging/media/omap4iss/iss_video.c      |  2 +-
> > >  include/media/media-entity.h                    | 78 ++++++++++----------
> > >  8 files changed, 48 insertions(+), 44 deletions(-)  
> 


-- 
Thanks,
Mauro
