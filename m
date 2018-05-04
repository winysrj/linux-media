Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34162 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751562AbeEDNyC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 09:54:02 -0400
Message-ID: <1525442037.21176.659.camel@linux.intel.com>
Subject: Re: [PATCH] media: staging: atomisp: fix a potential missing-check
 bug
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "open list:STAGING - ATOMISP DRIVER" <linux-media@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 04 May 2018 16:53:57 +0300
In-Reply-To: <1525418996-19246-1-git-send-email-wang6495@umn.edu>
References: <1525418996-19246-1-git-send-email-wang6495@umn.edu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-05-04 at 02:29 -0500, Wenwen Wang wrote:
> At the end of atomisp_subdev_set_selection(), the function
> atomisp_subdev_get_rect() is invoked to get the pointer to v4l2_rect.
> Since
> this function may return a NULL pointer, it is firstly invoked to
> check
> the returned pointer. If the returned pointer is not NULL, then the
> function is invoked again to obtain the pointer and the memory content
> at the location of the returned pointer is copied to the memory
> location of
> r. In most cases, the pointers returned by the two invocations are
> same.
> However, given that the pointer returned by the function
> atomisp_subdev_get_rect() is not a constant, it is possible that the
> two
> invocations return two different pointers. For example, another thread
> may
> race to modify the related pointers during the two invocations. In
> that
> case, even if the first returned pointer is not null, the second
> returned
> pointer might be null, which will cause issues such as null pointer
> dereference.
> 
> This patch saves the pointer returned by the first invocation and
> removes
> the second invocation. If the returned pointer is not NULL, the memory
> content is copied according to the original code.
> 

The driver will be gone soon, don't bother with it anymore.
Thanks!

> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
> ---
>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c | 6 ++++-
> -
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git
> a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
> b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
> index 49a9973..d5fa513 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
> @@ -366,6 +366,7 @@ int atomisp_subdev_set_selection(struct
> v4l2_subdev *sd,
>  	unsigned int i;
>  	unsigned int padding_w = pad_w;
>  	unsigned int padding_h = pad_h;
> +	struct v4l2_rect *p;
>  
>  	stream_id = atomisp_source_pad_to_stream_id(isp_sd,
> vdev_pad);
>  
> @@ -536,9 +537,10 @@ int atomisp_subdev_set_selection(struct
> v4l2_subdev *sd,
>  		ffmt[pad]->height = comp[pad]->height;
>  	}
>  
> -	if (!atomisp_subdev_get_rect(sd, cfg, which, pad, target))
> +	p = atomisp_subdev_get_rect(sd, cfg, which, pad, target);
> +	if (!p)
>  		return -EINVAL;
> -	*r = *atomisp_subdev_get_rect(sd, cfg, which, pad, target);
> +	*r = *p;
>  
>  	dev_dbg(isp->dev, "sel actual: l %d t %d w %d h %d\n",
>  		r->left, r->top, r->width, r->height);

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
