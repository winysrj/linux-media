Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:48786 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbeJJQpw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 12:45:52 -0400
Subject: Re: [PATCH] vicodec: lower minimum height to 360
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Helen Koike <helen.koike@collabora.com>
References: <42690466-7b3e-acd6-de8e-d55cbe96dcf4@xs4all.nl>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham+renesas@ideasonboard.com
Message-ID: <d31cb75e-9cee-78bf-9a17-7f312dc39f9c@ideasonboard.com>
Date: Wed, 10 Oct 2018 10:24:30 +0100
MIME-Version: 1.0
In-Reply-To: <42690466-7b3e-acd6-de8e-d55cbe96dcf4@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch,

On 10/10/18 08:03, Hans Verkuil wrote:
> Lower the minimum height to 360 to be consistent with the webcam input of vivid.
> 
> The 480 was rather arbitrary but it made it harder to use vivid as a source for
> encoding since the default resolution when you load vivid is 640x360.

As this is a virtual codec, is the minimum width and height really so
'large' ?

What about 320x240 or such? (or even 32x32...)

Or is the aim to provide minimum frame sizes and a means to verify
userspace correctly handles the minimum frame sizes too ?

I could certainly acknowledge it's worth providing a means for a
userspace app to test that it handles minimum sizes correctly.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

If the minimum is desired:

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 1eb9132bfc85..b292cff26c86 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -42,7 +42,7 @@ MODULE_PARM_DESC(debug, " activates debug info");
>  #define MAX_WIDTH		4096U
>  #define MIN_WIDTH		640U
>  #define MAX_HEIGHT		2160U
> -#define MIN_HEIGHT		480U
> +#define MIN_HEIGHT		360U
> 
>  #define dprintk(dev, fmt, arg...) \
>  	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
> 
