Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36406 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751011AbdLNNt4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 08:49:56 -0500
Date: Thu, 14 Dec 2017 15:49:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH] [media] vb2: clear V4L2_BUF_FLAG_LAST when filling
 vb2_buffer
Message-ID: <20171214134953.qfgyokewahmdyfzr@valkosipuli.retiisi.org.uk>
References: <20171208140128.19740-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171208140128.19740-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Fri, Dec 08, 2017 at 03:01:28PM +0100, Philipp Zabel wrote:
> V4L2_BUF_FLAG_LAST is a signal from the driver to userspace for buffers
> on the capture queue. When userspace queues back a capture buffer with
> the flag set, we should clear it.
> 
> Otherwise, if userspace restarts streaming after EOS, without
> reallocating the buffers, mem2mem devices will erroneously signal EOS
> prematurely, as soon as the already flagged buffer is dequeued.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 4075314a69893..fac3cd6f901d5 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -434,6 +434,8 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>  	} else {
>  		/* Zero any output buffer flags as this is a capture buffer */
>  		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
> +		/* Zero last flag, this is a signal from driver to userspace */
> +		vbuf->flags &= ~V4L2_BUF_FLAG_LAST;

Thanks for the patch.

How about:

	vbuf->flags &= ~(V4L2_BUFFER_OUT_FLAGS | V4L2_BUF_FLAG_LAST);

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
