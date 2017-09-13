Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33558 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751056AbdIMFft (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 01:35:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Wu-Cheng Li <wuchengli@chromium.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l-ioctl: Fix typo on v4l_print_frmsizeenum
Date: Wed, 13 Sep 2017 08:35:49 +0300
Message-ID: <18372913.S0YZhg91k1@avalon>
In-Reply-To: <20170908154710.2115-1-ricardo.ribalda@gmail.com>
References: <20170908154710.2115-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thank you for the patch.

On Friday, 8 September 2017 18:47:10 EEST Ricardo Ribalda Delgado wrote:
> max_width and max_height are swap with step_width and step_height.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> 
> Since that this bug has been here for ever. I do not know if we should
> notify stable or not
> 
> I have also cut the lines to respect the 80 char limit
> 
>  drivers/media/v4l2-core/v4l2-ioctl.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index b60a6b0841d1..79614992ee21
> 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -730,9 +730,12 @@ static void v4l_print_frmsizeenum(const void *arg, bool
> write_only) break;
>  	case V4L2_FRMSIZE_TYPE_STEPWISE:
>  		pr_cont(", min=%ux%u, max=%ux%u, step=%ux%u\n",
> -				p->stepwise.min_width,  p->stepwise.min_height,
> -				p->stepwise.step_width, p->stepwise.step_height,
> -				p->stepwise.max_width,  p->stepwise.max_height);
> +				p->stepwise.min_width,
> +				p->stepwise.min_height,
> +				p->stepwise.max_width,
> +				p->stepwise.max_height,
> +				p->stepwise.step_width,
> +				p->stepwise.step_height);

If you fix the indentation as well (aligning p-> right after the '(') you 
could keep two arguments per line :-)

>  		break;
>  	case V4L2_FRMSIZE_TYPE_CONTINUOUS:
>  		/* fall through */


-- 
Regards,

Laurent Pinchart
