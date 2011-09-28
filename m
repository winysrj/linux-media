Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:32931 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1I1UPT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 16:15:19 -0400
Date: Wed, 28 Sep 2011 23:15:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/9 v10] V4L: add two new ioctl()s for multi-size
 videobuffer management
Message-ID: <20110928201514.GD6180@valkosipuli.localdomain>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
 <201109271306.21095.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1109271417280.5816@axis700.grange>
 <201109271540.52649.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1109271847310.7004@axis700.grange>
 <Pine.LNX.4.64.1109281502380.30317@axis700.grange>
 <Pine.LNX.4.64.1109281653580.19957@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1109281653580.19957@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wed, Sep 28, 2011 at 04:56:11PM +0200, Guennadi Liakhovetski wrote:
> @@ -2099,6 +2103,15 @@ struct v4l2_dbg_chip_ident {
>  	__u32 revision;    /* chip revision, chip specific */
>  } __attribute__ ((packed));
>  
> +/* VIDIOC_CREATE_BUFS */
> +struct v4l2_create_buffers {
> +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
> +	__u32			count;
> +	enum v4l2_memory        memory;
> +	struct v4l2_format	format;		/* "type" is used always, the rest if sizeimage == 0 */
> +	__u32			reserved[8];
> +};

What about the kerneldoc comments you wrote right after v6 on 1st September
for v4l2_create_buffers and the same for the compat32 version?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
