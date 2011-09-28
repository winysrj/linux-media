Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:29543 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab1I1NeD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 09:34:03 -0400
Message-ID: <4E832241.7030501@iki.fi>
Date: Wed, 28 Sep 2011 16:33:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/9 v9] V4L: add two new ioctl()s for multi-size videobuffer
 management
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <201109271306.21095.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271417280.5816@axis700.grange> <201109271540.52649.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271847310.7004@axis700.grange> <Pine.LNX.4.64.1109281502380.30317@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109281502380.30317@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> A possibility to preallocate and initialise buffers of different sizes
> in V4L2 is required for an efficient implementation of a snapshot
> mode. This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> VIDIOC_PREPARE_BUF and defines respective data structures.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Hi Guennadi,

Thanks for the patch and your tireless efforts on this!

VIDIOC_PREPARE_BUF is actually _IOW (rather than _IOWR) in this patch. I
guess it shouldn't be this way, or have I failed to understand
something? :-)

[clip]

> @@ -2189,6 +2202,11 @@ struct v4l2_dbg_chip_ident {
>  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
>  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
>  
> +/* Experimental, the below two ioctls may change over the next couple of kernel
> +   versions */
> +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> +#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)
> +
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>  


-- 
Sakari Ailus
sakari.ailus@iki.fi
