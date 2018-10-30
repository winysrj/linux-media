Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:47637 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727820AbeJ3U4d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 16:56:33 -0400
Subject: Re: [PATCH 2/4] tw9910: No SoC camera dependency
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: mchehab@kernel.org
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
 <20181029230029.14630-3-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2f16f40b-e0cd-847e-8245-671bad4e6025@xs4all.nl>
Date: Tue, 30 Oct 2018 13:03:18 +0100
MIME-Version: 1.0
In-Reply-To: <20181029230029.14630-3-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/30/2018 12:00 AM, Sakari Ailus wrote:
> The tw9910 driver does not depend on SoC camera framework. Don't include
> the header, but instead include media/v4l2-async.h which the driver really
> needs.

You might want to make a note of the fact that soc_camera.h includes
v4l2-async.h, so removing soc_camera.h requires adding v4l2-async.h.

I couldn't understand how it compiled before without the v4l2-async.h
header until I saw that soc_camera.h includes it.

Regards,

	Hans

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/tw9910.c | 1 +
>  include/media/i2c/tw9910.h | 2 --
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
> index 7087ce946af1..6478bd41afb8 100644
> --- a/drivers/media/i2c/tw9910.c
> +++ b/drivers/media/i2c/tw9910.c
> @@ -27,6 +27,7 @@
>  #include <linux/videodev2.h>
>  
>  #include <media/i2c/tw9910.h>
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-subdev.h>
>  
>  #define GET_ID(val)  ((val & 0xF8) >> 3)
> diff --git a/include/media/i2c/tw9910.h b/include/media/i2c/tw9910.h
> index bec8f7bce745..2f93799d5a21 100644
> --- a/include/media/i2c/tw9910.h
> +++ b/include/media/i2c/tw9910.h
> @@ -16,8 +16,6 @@
>  #ifndef __TW9910_H__
>  #define __TW9910_H__
>  
> -#include <media/soc_camera.h>
> -
>  /**
>   * tw9910_mpout_pin - MPOUT (multi-purpose output) pin functions
>   */
> 
