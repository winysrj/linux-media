Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58804 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751184AbdJILPr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:15:47 -0400
Date: Mon, 9 Oct 2017 14:15:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 02/24] media: v4l2-flash-led-class.h: add kernel-doc to
 two ancillary funcs
Message-ID: <20171009111545.tbkwf3n7rqxogsyh@valkosipuli.retiisi.org.uk>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <f7e55a81bf0e687d55ffead522f00096a3e001c5.1507544011.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7e55a81bf0e687d55ffead522f00096a3e001c5.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch.

On Mon, Oct 09, 2017 at 07:19:08AM -0300, Mauro Carvalho Chehab wrote:
> There are two ancillary functions at v4l2-flash-led-class.h
> that aren't documented.
> 
> Document them.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-flash-led-class.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
> index 5c1d50f78e12..39a5daa977aa 100644
> --- a/include/media/v4l2-flash-led-class.h
> +++ b/include/media/v4l2-flash-led-class.h
> @@ -91,12 +91,24 @@ struct v4l2_flash {
>  	struct v4l2_ctrl **ctrls;
>  };
>  
> +/**
> + * v4l2_subdev_to_v4l2_flash - Returns a &v4l2_flash from the

v4l2_flash -> struct v4l2_flash ?

Same below. With these,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> + * &struct v4l2_subdev embedded on it.
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + */
>  static inline struct v4l2_flash *v4l2_subdev_to_v4l2_flash(
>  							struct v4l2_subdev *sd)
>  {
>  	return container_of(sd, struct v4l2_flash, sd);
>  }
>  
> +/**
> + * v4l2_ctrl_to_v4l2_flash - Returns a &v4l2_flash from the
> + * &struct v4l2_ctrl embedded on it.
> + *
> + * @c: pointer to &struct v4l2_ctrl
> + */
>  static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
>  {
>  	return container_of(c->handler, struct v4l2_flash, hdl);

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
