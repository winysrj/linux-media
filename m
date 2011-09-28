Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab1I1UiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 16:38:05 -0400
Date: Wed, 28 Sep 2011 22:38:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/9 v10] V4L: add two new ioctl()s for multi-size
 videobuffer management
In-Reply-To: <20110928201514.GD6180@valkosipuli.localdomain>
Message-ID: <Pine.LNX.4.64.1109282235580.21237@axis700.grange>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
 <201109271306.21095.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271417280.5816@axis700.grange>
 <201109271540.52649.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271847310.7004@axis700.grange>
 <Pine.LNX.4.64.1109281502380.30317@axis700.grange>
 <Pine.LNX.4.64.1109281653580.19957@axis700.grange>
 <20110928201514.GD6180@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 28 Sep 2011, Sakari Ailus wrote:

> Hi Guennadi,
> 
> On Wed, Sep 28, 2011 at 04:56:11PM +0200, Guennadi Liakhovetski wrote:
> > @@ -2099,6 +2103,15 @@ struct v4l2_dbg_chip_ident {
> >  	__u32 revision;    /* chip revision, chip specific */
> >  } __attribute__ ((packed));
> >  
> > +/* VIDIOC_CREATE_BUFS */
> > +struct v4l2_create_buffers {
> > +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
> > +	__u32			count;
> > +	enum v4l2_memory        memory;
> > +	struct v4l2_format	format;		/* "type" is used always, the rest if sizeimage == 0 */
> > +	__u32			reserved[8];
> > +};
> 
> What about the kerneldoc comments you wrote right after v6 on 1st September
> for v4l2_create_buffers and the same for the compat32 version?

Looks like someone is trying very hard to cause me a heart failure;-) They 
are in a separate patch:

http://patchwork.linuxtv.org/patch/338/

and let's leave it that way.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
