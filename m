Return-path: <linux-media-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38916
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377Ab2IOQYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 12:24:47 -0400
Date: Sat, 15 Sep 2012 13:24:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/5] video:omap3isp:fix up ENOIOCTLCMD error handling
Message-ID: <20120915132437.74dd11bb@infradead.org>
In-Reply-To: <1946796.hhZ2Ot34qB@avalon>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1346052196-32682-5-git-send-email-gaowanlong@cn.fujitsu.com>
	<1946796.hhZ2Ot34qB@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Sep 2012 06:03:21 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Wanlong,
> 
> Thanks for the patch.
> 
> On Monday 27 August 2012 15:23:15 Wanlong Gao wrote:
> > At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
> > translated as ENOTTY to user mode.
> > 
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Cc: linux-media@vger.kernel.org
> > Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > ---
> >  drivers/media/video/omap3isp/ispvideo.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/ispvideo.c
> > b/drivers/media/video/omap3isp/ispvideo.c index b37379d..2dd982e 100644
> > --- a/drivers/media/video/omap3isp/ispvideo.c
> > +++ b/drivers/media/video/omap3isp/ispvideo.c
> > @@ -337,7 +337,7 @@ __isp_video_get_format(struct isp_video *video, struct
> > v4l2_format *format) fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> >  	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
> >  	if (ret == -ENOIOCTLCMD)
> > -		ret = -EINVAL;
> > +		ret = -ENOTTY;
> 
> I don't think this location should be changed. __isp_video_get_format() is 
> called by isp_video_check_format() only, which in turn is called by 
> isp_video_streamon() only. A failure to retrieve the format in 
> __isp_video_get_format() does not really mean the VIDIOC_STREAMON is not 
> supported.
> 
> I'll apply hunks 2 to 5 and drop hunk 1 if that's fine with you.
> 

Not quite sure how to tag it at patchwork... I guess I'll mark it as "accepted",
as, from what I understood, Laurent partially accepted it, and will be adding
on his tree.

Regards,
Mauro
