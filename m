Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab3JRUaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 16:30:22 -0400
Date: Fri, 18 Oct 2013 22:30:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
cc: m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: make sure that all subdevices are powered on
 when needed
In-Reply-To: <1381952506-2405-1-git-send-email-fschaefer.oss@googlemail.com>
Message-ID: <Pine.LNX.4.64.1310182228130.12288@axis700.grange>
References: <1381952506-2405-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank

Thanks for the patch

On Wed, 16 Oct 2013, Frank Schäfer wrote:

> Commit 622b828ab7 ("v4l2_subdev: rename tuner s_standby operation to
> core s_power") replaced the tuner s_standby call in the em28xx driver with
> a (s_power, 0) call which suspends all subdevices.
> But it neglected to add corresponding (s_power, 1) calls to make sure that
> the subdevices are powered on again when needed.
> 
> This patch fixes this issue by adding a (s_power, 1) call to
> function em28xx_wake_i2c().
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-core.c |    1 +
>  1 Datei geändert, 1 Zeile hinzugefügt(+)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index fc157af..8896789 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -1243,6 +1243,7 @@ EXPORT_SYMBOL_GPL(em28xx_init_usb_xfer);
>   */
>  void em28xx_wake_i2c(struct em28xx *dev)
>  {
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  s_power, 1);
>  	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
>  	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
>  			INPUT(dev->ctl_input)->vmux, 0, 0);

Do I understand it right, that you're proposing this as an alternative to 
my power-balancing patch? It's certainly smaller and simpler, have you 
also tested it with the ov2640 and my clock patches to see, whether this 
really balances calls to .s_power() perfectly?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
