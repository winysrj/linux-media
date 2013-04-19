Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4135 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3DSHXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 03:23:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 05/24] V4L2: allow dummy file-handle initialisation by v4l2_fh_init()
Date: Fri, 19 Apr 2013 09:22:50 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de> <1366320945-21591-6-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-6-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304190922.50517.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu April 18 2013 23:35:26 Guennadi Liakhovetski wrote:
> v4l2_fh_init() can be used to initialise dummy file-handles with vdev ==
> NULL.

Why would you want that?

Anyway, this would definitely have to be documented as well in v4l2-fh.h.

I'm still going through your patch series so there may be a good reason
for allowing this, but it definitely doesn't make me happy.

Regards,

	Hans

> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/v4l2-core/v4l2-fh.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
> index e57c002..7ae608b 100644
> --- a/drivers/media/v4l2-core/v4l2-fh.c
> +++ b/drivers/media/v4l2-core/v4l2-fh.c
> @@ -33,10 +33,12 @@
>  void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
>  {
>  	fh->vdev = vdev;
> -	/* Inherit from video_device. May be overridden by the driver. */
> -	fh->ctrl_handler = vdev->ctrl_handler;
> +	if (vdev) {
> +		/* Inherit from video_device. May be overridden by the driver. */
> +		fh->ctrl_handler = vdev->ctrl_handler;
> +		set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
> +	}
>  	INIT_LIST_HEAD(&fh->list);
> -	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
>  	fh->prio = V4L2_PRIORITY_UNSET;
>  	init_waitqueue_head(&fh->wait);
>  	INIT_LIST_HEAD(&fh->available);
> 
