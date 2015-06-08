Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31088 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbFHGA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 02:00:57 -0400
Message-id: <55752F7A.1000709@samsung.com>
Date: Mon, 08 Jun 2015 08:00:26 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Vaishali Thakkar <vthakkar1994@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] [media] s5k5baf: Convert use of __constant_cpu_to_be16 to
 cpu_to_be16
References: <20150606015327.GA15272@vaishali-Ideapad-Z570>
In-reply-to: <20150606015327.GA15272@vaishali-Ideapad-Z570>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2015 03:53 AM, Vaishali Thakkar wrote:
> In little endian cases, macro cpu_to_be16 unfolds to __swab16 which
> provides special case for constants. In big endian cases,
> __constant_cpu_to_be16 and cpu_to_be16 expand directly to the
> same expression. So, replace __constant_cpu_to_be16 with
> cpu_to_be16 with the goal of getting rid of the definition of
> __constant_cpu_to_be16 completely.
>
> The semantic patch that performs this transformation is as follows:
>
> @@expression x;@@
>
> - __constant_cpu_to_be16(x)
> + cpu_to_be16(x)
>
> Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>

> ---
>  drivers/media/i2c/s5k5baf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index 297ef04..7a43b55 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -491,7 +491,7 @@ static void s5k5baf_write_arr_seq(struct s5k5baf *state, u16 addr,
>  	v4l2_dbg(3, debug, c, "i2c_write_seq(count=%d): %*ph\n", count,
>  		 min(2 * count, 64), seq);
>  
> -	buf[0] = __constant_cpu_to_be16(REG_CMD_BUF);
> +	buf[0] = cpu_to_be16(REG_CMD_BUF);
>  
>  	while (count > 0) {
>  		int n = min_t(int, count, ARRAY_SIZE(buf) - 1);

