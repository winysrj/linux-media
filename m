Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:53712 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbeCFQFb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 11:05:31 -0500
Date: Tue, 6 Mar 2018 17:05:26 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH] media: ov772x: constify ov772x_frame_intervals
Message-ID: <20180306160526.GC19648@w540>
References: <7b69f2cb91319abdacf37be501db2eae45112a09.1520350517.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7b69f2cb91319abdacf37be501db2eae45112a09.1520350517.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Mar 06, 2018 at 10:35:22AM -0500, Mauro Carvalho Chehab wrote:
> The values on this array never changes. Make it const.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Since I'm sure there will be more cleanup/fixes on tw9910 and ov772x,
could you please take into account my series:
[PATCH v2 00/11] media: ov772x/tw9910 cleanup
before any additional change to these 2 drivers?

Thanks
   j
> ---
>  drivers/media/i2c/ov772x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 16665af0c712..321105bb3161 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -531,7 +531,7 @@ static const struct ov772x_win_size ov772x_win_sizes[] = {
>  /*
>   * frame rate settings lists
>   */
> -static unsigned int ov772x_frame_intervals[] = { 5, 10, 15, 20, 30, 60 };
> +static const unsigned int ov772x_frame_intervals[] = { 5, 10, 15, 20, 30, 60 };
>
>  /*
>   * general function
> --
> 2.14.3
>
