Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38704 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758036AbdJMNYl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 09:24:41 -0400
Subject: Re: [PATCH v2 02/17] media: v4l2-common: get rid of v4l2_routing dead
 struct
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <cover.1506548682.git.mchehab@s-opensource.com>
 <a47fda6dbbdf84a9bdc607acfc769d00e8cb22f6.1506548682.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <84ee3a09-dec8-286e-94ce-7adf31f766a5@xs4all.nl>
Date: Fri, 13 Oct 2017 15:24:34 +0200
MIME-Version: 1.0
In-Reply-To: <a47fda6dbbdf84a9bdc607acfc769d00e8cb22f6.1506548682.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/17 23:46, Mauro Carvalho Chehab wrote:
> This struct is not used anymore. Get rid of it and update
> the documentation about what should still be converted.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  include/media/v4l2-common.h | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index aac8b7b6e691..7dbecbe3009c 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -224,10 +224,11 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
>  
>  /* ------------------------------------------------------------------------- */
>  
> -/* Note: these remaining ioctls/structs should be removed as well, but they are
> -   still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET) and
> -   v4l2-int-device.h (v4l2_routing). To remove these ioctls some more cleanup
> -   is needed in those modules. */
> +/*
> + * FIXME: these remaining ioctls/structs should be removed as well, but they
> + * are still used in tuner-simple.c (TUNER_SET_CONFIG) and cx18/ivtv (RESET).
> + * To remove these ioctls some more cleanup is needed in those modules.
> + */
>  
>  /* s_config */
>  struct v4l2_priv_tun_config {
> @@ -238,11 +239,6 @@ struct v4l2_priv_tun_config {
>  
>  #define VIDIOC_INT_RESET            	_IOW ('d', 102, u32)

Regarding this one: I *think* (long time ago) that the main reason for this
was to reset a locked up IR blaster. I wonder if this is still needed after
Sean's rework of this. Once that's all done and merged this would probably
merit another look to see if it can be removed.

Regards,

	Hans

>  
> -struct v4l2_routing {
> -	u32 input;
> -	u32 output;
> -};
> -
>  /* ------------------------------------------------------------------------- */
>  
>  /* Miscellaneous helper functions */
> 
