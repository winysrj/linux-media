Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63509 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3CGMfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 07:35:47 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so696738wgb.11
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2013 04:35:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361903569-30244-1-git-send-email-benoit.thebaudeau@advansee.com>
References: <1361903569-30244-1-git-send-email-benoit.thebaudeau@advansee.com>
Date: Thu, 7 Mar 2013 13:35:43 +0100
Message-ID: <CACKLOr3mgdn2GbSkk5SAUoTmZKzNs7T8RYJWHg+kVV5RSbD5Hg@mail.gmail.com>
Subject: Re: [PATCH] soc-camera: mt9m111: Fix auto-exposure control
From: javier Martin <javier.martin@vista-silicon.com>
To: =?ISO-8859-1?Q?Beno=EEt_Th=E9baudeau?=
	<benoit.thebaudeau@advansee.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	=?ISO-8859-1?Q?Micka=EBl_Guivarc=27h?=
	<mickael.guivarch@advansee.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 26 February 2013 19:32, Benoît Thébaudeau
<benoit.thebaudeau@advansee.com> wrote:
> Commit f9bd5843658e18a7097fc7258c60fb840109eaa8 changed V4L2_CID_EXPOSURE_AUTO
> from boolean to enum, and commit af8425c54beb3c32cbb503a379132b3975535289
> changed the creation of this control into a menu for the mt9m111. However,
> mt9m111_set_autoexposure() is still interpreting the value set for this control
> as a boolean, which also conflicts with the default value of this control set to
> V4L2_EXPOSURE_AUTO (0).
>
> This patch makes mt9m111_set_autoexposure() interpret the value set for
> V4L2_CID_EXPOSURE_AUTO as defined by enum v4l2_exposure_auto_type.
>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Mickaël Guivarc'h <mickael.guivarch@advansee.com>
> Cc: <linux-media@vger.kernel.org>
> Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
> ---
>  drivers/media/i2c/soc_camera/mt9m111.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
> index bbc4ff9..0b0ebaa 100644
> --- a/drivers/media/i2c/soc_camera/mt9m111.c
> +++ b/drivers/media/i2c/soc_camera/mt9m111.c
> @@ -701,11 +701,11 @@ static int mt9m111_set_global_gain(struct mt9m111 *mt9m111, int gain)
>         return reg_write(GLOBAL_GAIN, val);
>  }
>
> -static int mt9m111_set_autoexposure(struct mt9m111 *mt9m111, int on)
> +static int mt9m111_set_autoexposure(struct mt9m111 *mt9m111, int val)
>  {
>         struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
>
> -       if (on)
> +       if (val == V4L2_EXPOSURE_AUTO)
>                 return reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
>         return reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
>  }
> --
> 1.7.10.4

This solves a real issue.

Tested-By: Javier Martin <javier.martin@vista-silicon.com>


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
