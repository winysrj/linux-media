Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51164 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1I0RIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 13:08:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 2/9 v7] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Tue, 27 Sep 2011 19:08:38 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1109080942172.31156@axis700.grange> <201109271234.20485.hverkuil@xs4all.nl>
In-Reply-To: <201109271234.20485.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271908.39400.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 27 September 2011 12:34:20 Hans Verkuil wrote:
> On Thursday, September 08, 2011 09:45:15 Guennadi Liakhovetski wrote:
> > A possibility to preallocate and initialise buffers of different sizes
> > in V4L2 is required for an efficient implementation of a snapshot
> > mode. This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > VIDIOC_PREPARE_BUF and defines respective data structures.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---

[snip]

> > @@ -2096,6 +2098,33 @@ static long __video_do_ioctl(struct file *file,
> > 
> >  		dbgarg(cmd, "type=0x%8.8x", sub->type);
> >  		break;
> >  	
> >  	}
> > 
> > +	case VIDIOC_CREATE_BUFS:
> > +	{
> > +		struct v4l2_create_buffers *create = arg;
> > +
> > +		if (!ops->vidioc_create_bufs)
> > +			break;
> 
> Just as with REQBUFS you need to add code here to handle priority checking:
> 
> 		if (ret_prio) {
> 			ret = ret_prio;
> 			break;
> 		}

Speaking of prio support, how is locking handled here ? Does video_ioctl2() 
require drivers to synchronize all ioctl calls or can it work with fine-grain 
locking ?
 
> > +		ret = check_fmt(ops, create->format.type);
> > +		if (ret)
> > +			break;
> > +
> > +		ret = ops->vidioc_create_bufs(file, fh, create);
> > +
> > +		dbgarg(cmd, "count=%d @ %d\n", create->count, create->index);
> > +		break;
> > +	}

-- 
Regards,

Laurent Pinchart
