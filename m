Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36234 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbaGQL3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 07:29:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] tvp5150: Fix device ID kernel log message
Date: Thu, 17 Jul 2014 13:29:51 +0200
Message-ID: <1427497.bCxcs01A7z@avalon>
In-Reply-To: <1401132511-5236-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401132511-5236-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Ping ?

On Monday 26 May 2014 21:28:31 Laurent Pinchart wrote:
> The driver mistakenly prints the ROM version instead of the device ID to
> the kernel log when detecting the chip. Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/tvp5150.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index a912125..937e48b 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -1148,10 +1148,10 @@ static int tvp5150_probe(struct i2c_client *c,
>  		/* Is TVP5150A */
>  		if (tvp5150_id[2] == 3 || tvp5150_id[3] == 0x21) {
>  			v4l2_info(sd, "tvp%02x%02xa detected.\n",
> -				  tvp5150_id[2], tvp5150_id[3]);
> +				  tvp5150_id[0], tvp5150_id[1]);
>  		} else {
>  			v4l2_info(sd, "*** unknown tvp%02x%02x chip detected.\n",
> -				  tvp5150_id[2], tvp5150_id[3]);
> +				  tvp5150_id[0], tvp5150_id[1]);
>  			v4l2_info(sd, "*** Rom ver is %d.%d\n",
>  				  tvp5150_id[2], tvp5150_id[3]);
>  		}

-- 
Regards,

Laurent Pinchart

