Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41405 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdE2AmL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 20:42:11 -0400
Subject: Re: [PATCH 7/7] [media] v4l: rcar_fdp1: use proper name for the R-Car
 SoC
To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20170528093051.11816-1-wsa+renesas@sang-engineering.com>
 <20170528093051.11816-8-wsa+renesas@sang-engineering.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <7ee334ac-0274-ed9c-a903-93defd5900d8@ideasonboard.com>
Date: Mon, 29 May 2017 09:41:49 +0900
MIME-Version: 1.0
In-Reply-To: <20170528093051.11816-8-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram

Thankyou for the fixup

On 28/05/17 18:30, Wolfram Sang wrote:
> It is 'R-Car', not 'RCar'. No code or binding changes, only descriptive text.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


Mauro,

I'll leave this for you to pick up when you're ready.

Thanks

Kieran

> ---
> I suggest this trivial patch should be picked individually per susbsystem.
> 
>  drivers/media/platform/rcar_fdp1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
> index 42f25d241edd7c..0da0eba9202cdd 100644
> --- a/drivers/media/platform/rcar_fdp1.c
> +++ b/drivers/media/platform/rcar_fdp1.c
> @@ -1,5 +1,5 @@
>  /*
> - * Renesas RCar Fine Display Processor
> + * Renesas R-Car Fine Display Processor
>   *
>   * Video format converter and frame deinterlacer device.
>   *
> 
