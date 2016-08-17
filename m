Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57324 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750927AbcHQJCU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 05:02:20 -0400
Date: Wed, 17 Aug 2016 12:01:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
Subject: Re: [RESEND PATCH] [media] vb2: Fix vb2_core_dqbuf() kernel-doc
Message-ID: <20160817090144.GD3182@valkosipuli.retiisi.org.uk>
References: <1471357216-23230-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471357216-23230-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tue, Aug 16, 2016 at 10:20:16AM -0400, Javier Martinez Canillas wrote:
> The kernel-doc has the wrong function name and also the pindex
> parameter is missing in the documentation.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
> This patch was posted some weeks ago but I noticed that wasn't
> picked by patchwork, so I'm resend it.
> 
>  drivers/media/v4l2-core/videobuf2-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index ca8ffeb56d72..1dbd7beb71f0 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1726,8 +1726,9 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
>  }
>  
>  /**
> - * vb2_dqbuf() - Dequeue a buffer to the userspace
> + * vb2_core_dqbuf() - Dequeue a buffer to the userspace
>   * @q:		videobuf2 queue
> + * @pindex:	id number of the buffer

How about: "Pointer to the buffer index. May be NULL.".

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

>   * @pb:		buffer structure passed from userspace to vidioc_dqbuf handler
>   *		in driver
>   * @nonblocking: if true, this call will not sleep waiting for a buffer if no

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
