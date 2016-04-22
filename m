Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43444 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbcDVOho (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 10:37:44 -0400
Date: Fri, 22 Apr 2016 11:37:38 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/2] v4l: Add meta-data video device type
Message-ID: <20160422113738.021a5cde@recife.lan>
In-Reply-To: <571A2EBF.3010209@xs4all.nl>
References: <1461199227-22506-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1461199227-22506-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<571875BF.8080500@xs4all.nl>
	<27064764.ckB5ZcOUBB@avalon>
	<5719D6BC.1010000@xs4all.nl>
	<20160422105834.6c86c86c@recife.lan>
	<571A2EBF.3010209@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Apr 2016 16:01:35 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> >>>>> + *	%VFL_TYPE_META - Meta-data (including statistics)    
> >>>>
> >>>> I would drop the '(including statistics)' part. It feels weird that
> >>>> 'statistics' are singled out, it makes the reader wonder what is so special
> >>>> about it that it needs to be mentioned explicitly.    
> >>>
> >>> Done.  
> > 
> > It actually makes sense to put statistics as an example of such
> > metadata, as this is the main(and currently only) usage for this
> > devnode.  
> 
> Then I would say 'like statistics' here. 

Fine for me. I would keep it like that.

> But I still don't like this to be
> honest. Heck, Nick Dyer posted a patch series for getting diagnostics yesterday,
> which would be a good fit as well.

Nick patches are interesting. AFAIKT, input devices like touchscreen (and some
trackballs) actually produce a real 2D grey image. In the case of Nick's
patch, it seems that it is a new 16 bits per pixel grey image format:
	+#define V4L2_PIX_FMT_YS16    v4l2_fourcc('Y', 'S', '1', '6') /* signed 16-bit Greyscale */

We need to ask him for mor info, how this is packaged, and what's the
difference from the previously supported formats:
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 #define V4L2_PIX_FMT_Y16_BE  v4l2_fourcc_be('Y', '1', '6', ' ') /* 16  Greyscale BE  */

IMO, if this is indeed a real image, it should not be using the
metadata buffer format, as this is not metadata, but an image stream.

An interesting question is: in such case, should it use a normal
/dev/video devnode or the new /dev/metadata devnode.

> 
> Anyway, it's not worth a long discussion :-)


-- 
Thanks,
Mauro
