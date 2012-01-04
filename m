Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:34659 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab2ADPyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 10:54:19 -0500
Date: Wed, 4 Jan 2012 17:54:13 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] v4l2: v4l2-fh: v4l2_fh_is_singular should use list
 head to test
Message-ID: <20120104155413.GH9323@valkosipuli.localdomain>
References: <1324481454-30066-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324481454-30066-1-git-send-email-scott.jiang.linux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

Thanks for the patch.

On Wed, Dec 21, 2011 at 10:30:54AM -0500, Scott Jiang wrote:
> list_is_singular accepts a list head to test whether a list has just one entry.
> fh->list is the entry, fh->vdev->fh_list is the list head.
> 
> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
> ---
>  drivers/media/video/v4l2-fh.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
> index 9e3fc04..8292c4a 100644
> --- a/drivers/media/video/v4l2-fh.c
> +++ b/drivers/media/video/v4l2-fh.c
> @@ -113,7 +113,7 @@ int v4l2_fh_is_singular(struct v4l2_fh *fh)
>  	if (fh == NULL || fh->vdev == NULL)
>  		return 0;
>  	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> -	is_singular = list_is_singular(&fh->list);
> +	is_singular = list_is_singular(&fh->vdev->fh_list);
>  	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>  	return is_singular;
>  }

Is there an issue that this patch resolves, or am I missing something? As
far as I can see, the list_is_singular() test returns the same result
whether you are testing a list item which is part of the list, or its head
in struct video_device.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
