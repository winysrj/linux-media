Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37237 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbcBVOV6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 09:21:58 -0500
Subject: Re: [PATCH 3/5] [media] tvp5150: don't go past decoder->input_ent
 array
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
 <9d4dc6dc7e74437be0ad48495879bf0da458f713.1456150537.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56CB197D.5040904@osg.samsung.com>
Date: Mon, 22 Feb 2016 11:21:49 -0300
MIME-Version: 1.0
In-Reply-To: <9d4dc6dc7e74437be0ad48495879bf0da458f713.1456150537.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 02/22/2016 11:16 AM, Mauro Carvalho Chehab wrote:
> drivers/media/i2c/tvp5150.c:1394 tvp5150_parse_dt() warn: buffer overflow 'decoder->input_ent' 3 <= 3
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>   drivers/media/i2c/tvp5150.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index ef393f5daf2a..ff18444e19e4 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -1386,7 +1386,7 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
>   			goto err_connector;
>   		}
>
> -		if (input_type > TVP5150_INPUT_NUM) {
> +		if (input_type >= TVP5150_INPUT_NUM) {
>   			ret = -EINVAL;
>   			goto err_connector;
>   		}
>

Thanks for the fix.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
