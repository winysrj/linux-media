Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42670 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758828Ab2IMVBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 17:01:43 -0400
Date: Fri, 14 Sep 2012 00:01:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Antoine Reversat <a.reversat@gmail.com>
Subject: Re: [PATCH] omap3isp: Use monotonic timestamps for statistics
 buffers
Message-ID: <20120913210139.GL6834@valkosipuli.retiisi.org.uk>
References: <1347566003-14500-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347566003-14500-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch!

On Thu, Sep 13, 2012 at 09:53:23PM +0200, Laurent Pinchart wrote:
> V4L2 buffers use the monotonic clock, while statistics buffers use wall
> time. This makes it difficult to correlate video frames and statistics.
> 
> Switch statistics buffers to the monotonic clock to fix this.
> 
> Reported-by: Antoine Reversat <a.reversat@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/ispstat.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> index b8640be..52263cc 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -253,10 +253,14 @@ isp_stat_buf_find_oldest_or_empty(struct ispstat *stat)
>  
>  static int isp_stat_buf_queue(struct ispstat *stat)
>  {
> +	struct timespec ts;
> +
>  	if (!stat->active_buf)
>  		return STAT_NO_BUF;
>  
> -	do_gettimeofday(&stat->active_buf->ts);
> +	ktime_get_ts(&ts);
> +	stat->active_buf->ts.tv_sec = ts.tv_sec;
> +	stat->active_buf->ts.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>  
>  	stat->active_buf->buf_size = stat->buf_size;
>  	if (isp_stat_buf_check_magic(stat, stat->active_buf)) {

I didn't think wall clock timestamps were used for statistics. This change
is sure going to affect anyone using them --- which likely equates to no-one
since I can hardly see use for wall clock timestams in such use.

How about using struct timespec instead?

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
