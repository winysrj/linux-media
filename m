Return-path: <linux-media-owner@vger.kernel.org>
Received: from zose-mta12.web4all.fr ([178.33.204.89]:48742 "EHLO
	zose-mta12.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3CGMSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 07:18:07 -0500
Date: Thu, 7 Mar 2013 13:13:03 +0100 (CET)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <962516300.332041.1362658383433.JavaMail.root@advansee.com>
In-Reply-To: <CACKLOr22R45bCbfntvhLVh=kf2fGq6umXZtDsKjsNVbNHAK6Rw@mail.gmail.com>
References: <CACKLOr22R45bCbfntvhLVh=kf2fGq6umXZtDsKjsNVbNHAK6Rw@mail.gmail.com>
Subject: Re: mt9m111/mt9m131: kernel 3.8 issues.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Javier Martin,

On Thursday, March 7, 2013 10:43:42 AM, Javier Martin wrote:
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

I am using the MT9M131 with an i.MX35 board and Linux 3.4.5. It works nicely. I
have not noticed 1 and 3. However, I have noticed 2, for which I already have
posted a patch (here: https://patchwork.kernel.org/patch/2187291/), but I have
not yet received any feedback.

> This patch is just to provide a quick fix for points 1 and 2 just in
> case you feel like testing this in kernel 3.8. If you consider these
> fix are valid I'll send a proper patch later:

It's not straightforward to port my board to 3.8, but I've just reviewed the
code in linux-next (see below).

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

This hunk does the same thing as my patch mentioned above, so please don't send
anything for that.

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

There is indeed a bug, introduced by commit 4bbc6d5. The issue is:
 mt9m111_set_context(mt9m111, mt9m111->ctx);
in mt9m111_restore_state() called (indirectly) from mt9m111_s_power() from
mt9m111_video_probe() with ctx still NULL, before mt9m111_init() has been called
to initialize ctx to &context_b.

So the fix would not be what you did, but rather to reorganize things a little
bit to avoid this out-of-order init and use of ctx.

Best regards,
Benoît
