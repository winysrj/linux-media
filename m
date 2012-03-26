Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:40962 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112Ab2CZNLj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 09:11:39 -0400
Date: Mon, 26 Mar 2012 14:10:23 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux@arm.linux.org.uk,
	mchehab@infradead.org, kernel@pengutronix.de,
	u.kleine-koenig@pengutronix.de,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] i.MX27: visstrim_m10: Remove use of
 MX2_CAMERA_SWAP16.
Message-ID: <20120326121023.GD18420@sapphire.tkos.co.il>
References: <1332760804-22743-1-git-send-email-javier.martin@vista-silicon.com>
 <1332760804-22743-4-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332760804-22743-4-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Mon, Mar 26, 2012 at 01:20:04PM +0200, Javier Martin wrote:
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  arch/arm/mach-imx/mach-imx27_visstrim_m10.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> index 3128cfe..4db00c6 100644
> --- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> +++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> @@ -164,7 +164,7 @@ static struct platform_device visstrim_tvp5150 = {
>  
>  
>  static struct mx2_camera_platform_data visstrim_camera = {
> -	.flags = MX2_CAMERA_CCIR | MX2_CAMERA_CCIR_INTERLACE | MX2_CAMERA_SWAP16 | MX2_CAMERA_PCLK_SAMPLE_RISING,
> +	.flags = MX2_CAMERA_CCIR | MX2_CAMERA_CCIR_INTERLACE | MX2_CAMERA_PCLK_SAMPLE_RISING,
>  	.clk = 100000,
>  };

The order of the last two patches in this series should be switched to 
preserve bisectability.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
