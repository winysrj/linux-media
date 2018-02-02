Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55582 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750799AbeBBJXA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Feb 2018 04:23:00 -0500
Date: Fri, 2 Feb 2018 11:22:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH 4/8] i2c: ov9650: fix potential integer overflow in
 __ov965x_set_frame_interval
Message-ID: <20180202092257.xknpdvc4bcrg4dyi@valkosipuli.retiisi.org.uk>
References: <cover.1517268667.git.gustavo@embeddedor.com>
 <8ccf6acf10745fd1b9f33a7cacd5365e125633bf.1517268668.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ccf6acf10745fd1b9f33a7cacd5365e125633bf.1517268668.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 29, 2018 at 06:32:01PM -0600, Gustavo A. R. Silva wrote:
> Cast fi->interval.numerator to u64 in order to avoid a potential integer
> overflow. This variable is being used in a context that expects an
> expression of type u64.
> 
> Addresses-Coverity-ID: 1324146 ("Unintentional integer overflow")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/media/i2c/ov9650.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index e519f27..c674a49 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -1130,7 +1130,7 @@ static int __ov965x_set_frame_interval(struct ov965x *ov965x,
>  	if (fi->interval.denominator == 0)
>  		return -EINVAL;
>  
> -	req_int = (u64)(fi->interval.numerator * 10000) /
> +	req_int = (u64)fi->interval.numerator * 10000 /
>  		fi->interval.denominator;

This requires do_div(). I've applied the patch with this change:

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 88276dba828d..5bea31cd41aa 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1136,8 +1136,8 @@ static int __ov965x_set_frame_interval(struct ov965x *ov965x,
 	if (fi->interval.denominator == 0)
 		return -EINVAL;
 
-	req_int = (u64)fi->interval.numerator * 10000 /
-		fi->interval.denominator;
+	req_int = (u64)fi->interval.numerator * 10000;
+	do_div(req_int, fi->interval.denominator);
 
 	for (i = 0; i < ARRAY_SIZE(ov965x_intervals); i++) {
 		const struct ov965x_interval *iv = &ov965x_intervals[i];

>  
>  	for (i = 0; i < ARRAY_SIZE(ov965x_intervals); i++) {
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
