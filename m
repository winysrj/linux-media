Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37016 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754195AbdJIU0K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 16:26:10 -0400
Date: Mon, 9 Oct 2017 23:26:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 17/24] media: v4l2-subdev: fix a typo
Message-ID: <20171009202607.v42vczyt2fkm6oie@valkosipuli.retiisi.org.uk>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <8c66d4a7c2afddc52be7f42c5bc2cef218a0ecc6.1507544011.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c66d4a7c2afddc52be7f42c5bc2cef218a0ecc6.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 09, 2017 at 07:19:23AM -0300, Mauro Carvalho Chehab wrote:
> ownner -> owner
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-subdev.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index e215732eed45..345da052618c 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -814,7 +814,7 @@ struct v4l2_subdev_platform_data {
>   * @list: List of sub-devices
>   * @owner: The owner is the same as the driver's &struct device owner.
>   * @owner_v4l2_dev: true if the &sd->owner matches the owner of @v4l2_dev->dev
> - *	ownner. Initialized by v4l2_device_register_subdev().
> + *	owner. Initialized by v4l2_device_register_subdev().
>   * @flags: subdev flags, as defined by &enum v4l2_subdev_flags.
>   *
>   * @v4l2_dev: pointer to struct &v4l2_device

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
