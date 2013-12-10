Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39168 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750721Ab3LJThL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 14:37:11 -0500
Date: Tue, 10 Dec 2013 21:36:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Fix buffer flags handling when querying buffer
Message-ID: <20131210193636.GP30652@valkosipuli.retiisi.org.uk>
References: <1386640419-2922-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386640419-2922-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 10, 2013 at 02:53:39AM +0100, Laurent Pinchart wrote:
> A missing break resulted in all done buffers being flagged with
> V4L2_BUF_FLAG_QUEUED. Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/ispqueue.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
> index e15f013..5f0f8fa 100644
> --- a/drivers/media/platform/omap3isp/ispqueue.c
> +++ b/drivers/media/platform/omap3isp/ispqueue.c
> @@ -553,8 +553,10 @@ static void isp_video_buffer_query(struct isp_video_buffer *buf,
>  	switch (buf->state) {
>  	case ISP_BUF_STATE_ERROR:
>  		vbuf->flags |= V4L2_BUF_FLAG_ERROR;
> +		/* Fallthrough */
>  	case ISP_BUF_STATE_DONE:
>  		vbuf->flags |= V4L2_BUF_FLAG_DONE;
> +		break;
>  	case ISP_BUF_STATE_QUEUED:
>  	case ISP_BUF_STATE_ACTIVE:
>  		vbuf->flags |= V4L2_BUF_FLAG_QUEUED;

Oh, how is it possible this bug has passed through the review? :-) Nice fix!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
