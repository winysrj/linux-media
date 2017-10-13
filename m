Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57267 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757944AbdJMLWv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 07:22:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 02/17] media: v4l2-common: get rid of v4l2_routing dead struct
Date: Fri, 13 Oct 2017 14:23:04 +0300
Message-ID: <9198105.3c1GWqMa0K@avalon>
In-Reply-To: <a47fda6dbbdf84a9bdc607acfc769d00e8cb22f6.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com> <a47fda6dbbdf84a9bdc607acfc769d00e8cb22f6.1506548682.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Thursday, 28 September 2017 00:46:45 EEST Mauro Carvalho Chehab wrote:
> This struct is not used anymore. Get rid of it and update
> the documentation about what should still be converted.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/media/v4l2-common.h | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index aac8b7b6e691..7dbecbe3009c 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -224,10 +224,11 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd,
> struct spi_device *spi,
> 
>  /*
> -------------------------------------------------------------------------
> */
> 
> -/* Note: these remaining ioctls/structs should be removed as well, but they
> are -   still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET)
> and -   v4l2-int-device.h (v4l2_routing). To remove these ioctls some more
> cleanup -   is needed in those modules. */
> +/*
> + * FIXME: these remaining ioctls/structs should be removed as well, but
> they + * are still used in tuner-simple.c (TUNER_SET_CONFIG) and cx18/ivtv
> (RESET). + * To remove these ioctls some more cleanup is needed in those
> modules. + */
> 
>  /* s_config */
>  struct v4l2_priv_tun_config {
> @@ -238,11 +239,6 @@ struct v4l2_priv_tun_config {
> 
>  #define VIDIOC_INT_RESET            	_IOW ('d', 102, u32)
> 
> -struct v4l2_routing {
> -	u32 input;
> -	u32 output;
> -};
> -
>  /*
> -------------------------------------------------------------------------
> */
> 
>  /* Miscellaneous helper functions */


-- 
Regards,

Laurent Pinchart
