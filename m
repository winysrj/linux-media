Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44665 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751087AbZCCHcl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2009 02:32:41 -0500
Date: Tue, 3 Mar 2009 08:32:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] sh_mobile_ceu: Add SOCAM_DATA_ACTIVE_{HIGH/LOW} flags
In-Reply-To: <u7i37l9ff.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903030828310.5059@axis700.grange>
References: <u7i37l9ff.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Mar 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/sh_mobile_ceu_camera.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 96cf857..bb10899 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -107,6 +107,8 @@ static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
>  
>  	flags = SOCAM_MASTER |
>  		SOCAM_PCLK_SAMPLE_RISING |
> +		SOCAM_DATA_ACTIVE_HIGH |
> +		SOCAM_DATA_ACTIVE_LOW |
>  		SOCAM_HSYNC_ACTIVE_HIGH |
>  		SOCAM_HSYNC_ACTIVE_LOW |
>  		SOCAM_VSYNC_ACTIVE_HIGH |
> -- 
> 1.5.6.3

Please, have a look at the current V4L/DVB next tree at

git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git

I already added the SOCAM_DATA_ACTIVE_HIGH flag to sh-mobile-ceu flags, 
because otherwise it would be a regression. Sorry, I should have told you, 
that I had to extend your patch a bit. As for supporting 
SOCAM_DATA_ACTIVE_LOW too - does, for instance, sh7722 really support 
that? I remember I had a short look at it at that time and didn't find any 
way to switch. If it does, and if you want to support it, you have to also 
add support for switching between the two polarities. For now a NAK.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
