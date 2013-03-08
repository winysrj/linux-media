Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab3CHSDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 13:03:23 -0500
Date: Fri, 8 Mar 2013 19:03:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
	benoit.thebaudeau@advansee.com
Subject: Re: mt9m111/mt9m131: kernel 3.8 issues.
In-Reply-To: <CACKLOr22R45bCbfntvhLVh=kf2fGq6umXZtDsKjsNVbNHAK6Rw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1303081900580.24912@axis700.grange>
References: <CACKLOr22R45bCbfntvhLVh=kf2fGq6umXZtDsKjsNVbNHAK6Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 7 Mar 2013, javier Martin wrote:

> Hi,
> I am testing mt9m131 sensor (which is supported in mt9m111.c) in
> mainline kernel 3.8 with my Visstrim M10, which is an i.MX27 board.
> 
> Since both mx2_camera.c and mt9m111.c are soc_camera drivers making it
> work was quite straightforward. However, I've found several issues
> regarding mt9m111.c:
> 
> 1. mt9m111 probe is broken. It will give an oops since it tries to use
> a context before it's been assigned.
> 2. mt9m111 auto exposure control is broken too (see the patch below).
> 3. After I've fixed 1 and 2 the colours in the pictures I grab are
> dull and not vibrant, green is very dark and red seems like pink, blue
> and yellow look fine though. I have both auto exposure and auto white
> balance enabled.
> 
> I can see in the list that you have tried this sensor before. Have you
> also noticed these problems (specially 3)?
> 
> This patch is just to provide a quick fix for points 1 and 2 just in
> case you feel like testing this in kernel 3.8. If you consider these
> fix are valid I'll send a proper patch later:
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9m111.c
> b/drivers/media/i2c/soc_camera/mt9m111.c
> index 62fd94a..7d99655 100644
> --- a/drivers/media/i2c/soc_camera/mt9m111.c
> +++ b/drivers/media/i2c/soc_camera/mt9m111.c
> @@ -704,7 +704,7 @@ static int mt9m111_set_autoexposure(struct mt9m111
> *mt9m111, int on)
>  {
>         struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
> 
> -       if (on)
> +       if (on == V4L2_EXPOSURE_AUTO)
>                 return reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
>         return reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
>  }
> @@ -916,6 +916,9 @@ static int mt9m111_video_probe(struct i2c_client *client)
>         s32 data;
>         int ret;
> 
> +       /* Assign context to avoid oops */
> +       mt9m111->ctx = &context_a;
> +
>         ret = mt9m111_s_power(&mt9m111->subdev, 1);
>         if (ret < 0)
>                 return ret;

Yes, there is an Oops currently in mt9m111, that this patch would fix, 
thanks! But please, do it a bit differently: please, move the lines

	/* Default HIGHPOWER context */
	mt9m111->ctx = &context_b;

from mt9m111_init() to probing, instead of adding a context_a selection. 
And I think it would be more logical to move those lines to 
mt9m111_probe(), directly below the mt9m111 allocation, not to 
mt9m111_video_probe(). Please, make this change and submit a patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
