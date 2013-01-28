Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2238 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab3A1OXg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 09:23:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [media] staging: go7007: fix test for V4L2_STD_SECAM
Date: Mon, 28 Jan 2013 15:22:49 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	YAMANE Toshiaki <yamanetoshi@gmail.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, Ross Cohen <rcohen@snurgle.org>,
	kernel-janitors@vger.kernel.org
References: <20130128141942.GC24528@elgon.mountain>
In-Reply-To: <20130128141942.GC24528@elgon.mountain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281522.49633.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 28 2013 15:19:42 Dan Carpenter wrote:
> The current test doesn't make a lot of sense.  It's likely to be true,
> which is what we would want in most cases.  From looking at how this is
> handled in other drivers,  I think "&" was intended instead of "*".
> It's an easy mistake to make because they are next to each other on the
> keyboard.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

For the record, it should indeed be '&'. Nice catch.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> diff --git a/drivers/staging/media/go7007/wis-saa7113.c b/drivers/staging/media/go7007/wis-saa7113.c
> index 8810c1e..891cde7 100644
> --- a/drivers/staging/media/go7007/wis-saa7113.c
> +++ b/drivers/staging/media/go7007/wis-saa7113.c
> @@ -141,7 +141,7 @@ static int wis_saa7113_command(struct i2c_client *client,
>  		} else if (dec->norm & V4L2_STD_PAL) {
>  			write_reg(client, 0x0e, 0x01);
>  			write_reg(client, 0x10, 0x48);
> -		} else if (dec->norm * V4L2_STD_SECAM) {
> +		} else if (dec->norm & V4L2_STD_SECAM) {
>  			write_reg(client, 0x0e, 0x50);
>  			write_reg(client, 0x10, 0x48);
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
