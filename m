Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1119 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2KUT6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 14:58:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: Re: [PATCH] adv7604: convert struct i2c_msg initialization to C99 format
Date: Wed, 21 Nov 2012 20:58:12 +0100
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com
References: <1351141356-3093-1-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1351141356-3093-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211212058.12185.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu October 25 2012 07:02:36 Shubhrajyoti D wrote:
> Convert the struct i2c_msg initialization to C99 format. This makes
> maintaining and editing the code simpler. Also helps once other fields
> like transferred are added in future.
> 
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/i2c/adv7604.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 109bc9b..89fc854 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -403,9 +403,19 @@ static inline int edid_read_block(struct v4l2_subdev *sd, unsigned len, u8 *val)
>  	struct i2c_client *client = state->i2c_edid;
>  	u8 msgbuf0[1] = { 0 };
>  	u8 msgbuf1[256];
> -	struct i2c_msg msg[2] = { { client->addr, 0, 1, msgbuf0 },
> -				  { client->addr, 0 | I2C_M_RD, len, msgbuf1 }
> -				};
> +	struct i2c_msg msg[2] = {
> +		{
> +			.addr = client->addr,
> +			.len = 1,
> +			.buf = msgbuf0
> +		},
> +		{
> +			.addr = client->addr,
> +			.flags = I2C_M_RD,
> +			.len = len,
> +			.buf = msgbuf1
> +		},
> +	};
>  
>  	if (i2c_transfer(client->adapter, msg, 2) < 0)
>  		return -EIO;
> 
