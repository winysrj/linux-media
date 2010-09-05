Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:41127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0IEITJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 04:19:09 -0400
Message-ID: <4C8353D3.3050708@redhat.com>
Date: Sun, 05 Sep 2010 10:24:51 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca_cpia1: Add lamp control for Intel Play QX3 microscope
References: <1283476182.17527.4.camel@morgan.silverblock.net>
In-Reply-To: <1283476182.17527.4.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi,

p.s. (forgot to mention this in my previous mail)

On 09/03/2010 03:09 AM, Andy Walls wrote:

<snip>

> @@ -447,6 +449,20 @@
>   		.set = sd_setcomptarget,
>   		.get = sd_getcomptarget,
>   	},
> +	{
> +		{
> +#define V4L2_CID_LAMPS (V4L2_CID_PRIVATE_BASE+1)
> +			.id	 = V4L2_CID_LAMPS,
> +			.type    = V4L2_CTRL_TYPE_MENU,
> +			.name    = "Lamps",
> +			.minimum = 0,
> +			.maximum = 3,
> +			.step    = 1,
> +			.default_value = 0,
> +		},
> +		.set = sd_setlamps,
> +		.get = sd_getlamps,
> +	},
>   };
>
>   static const struct v4l2_pix_format mode[] = {

We only want this control to be available on the qx3 and not on
all cpia1 devices, so you need to add something like the following to
sd_config:

	if (!(id->idVendor == 0x0813 && id->idProduct == 0x0001))
		gspca_dev->ctrl_dis = 1 << LAMPS_IDX;

Where LAMPS_IDX is a define giving the index of V4L2_CID_LAMPS in the
sd_ctrls array, see the ov519 gspca driver for example.

Regards,

Hans
