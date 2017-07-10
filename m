Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30031 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753224AbdGJMZk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 08:25:40 -0400
Subject: Re: [PATCH] s5k5baf: remove unnecessary static in
 s5k5baf_get_selection()
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <81c29fdb-77ad-37bb-6353-0fee2d782189@samsung.com>
Date: Mon, 10 Jul 2017 14:25:20 +0200
MIME-version: 1.0
In-reply-to: <20170705180729.GA10314@embeddedgus>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20170705180734epcas5p3b658b32b6b0f5f0c77b7f068fb020d77@epcas5p3.samsung.com>
 <20170705180729.GA10314@embeddedgus>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05.07.2017 20:07, Gustavo A. R. Silva wrote:
> Remove unnecessary static on local variable rtype.
> Such variable is initialized before being used,
> on every execution path throughout the function.
> The static has no benefit and, removing it reduces
> the code size.
>
> This issue was detected using Coccinelle and the following semantic patch:
>
> @bad exists@
> position p;
> identifier x;
> type T;
> @@
>
> static T x@p;
> ...
> x = <+...x...+>
>
> @@
> identifier x;
> expression e;
> type T;
> position p != bad.p;
> @@
>
> -static
>  T x@p;
>  ... when != x
>      when strict
> ?x = e;
>
> In the following log you can see the difference in the code size. Also,
> there is a significant difference in the bss segment. This log is the
> output of the size command, before and after the code change:
>
> before:
>    text    data     bss     dec     hex filename
>   27765    5656     320   33741    83cd drivers/media/i2c/s5k5baf.o
>
> after:
>    text    data     bss     dec     hex filename
>   27733    5600     256   33589    8335 drivers/media/i2c/s5k5baf.o
>
>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>

 --
Regards
Andrzej

> ---
>  drivers/media/i2c/s5k5baf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index 962051b..f01722d 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -1374,7 +1374,7 @@ static int s5k5baf_get_selection(struct v4l2_subdev *sd,
>  				 struct v4l2_subdev_pad_config *cfg,
>  				 struct v4l2_subdev_selection *sel)
>  {
> -	static enum selection_rect rtype;
> +	enum selection_rect rtype;
>  	struct s5k5baf *state = to_s5k5baf(sd);
>  
>  	rtype = s5k5baf_get_sel_rect(sel->pad, sel->target);
