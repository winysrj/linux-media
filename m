Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:54112 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028AbbBBK0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 05:26:44 -0500
Message-ID: <54CF50BC.10601@xs4all.nl>
Date: Mon, 02 Feb 2015 11:26:04 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org, hans.verkuil@cisco.com,
	m.chehab@samsung.com
Subject: Re: [PATCH] media: adv7604: CP CSC uses a different register on adv7604
 and adv7611
References: <1422280360-20461-1-git-send-email-jean-michel.hautbois@vodalys.com>
In-Reply-To: <1422280360-20461-1-git-send-email-jean-michel.hautbois@vodalys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

On 01/26/2015 02:52 PM, Jean-Michel Hautbois wrote:
> The bits are the same, but register is 0xf4 on ADV7611 instead of 0xfc.
> When reading back the value in log_status, differentiate both.
> 
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> ---
>  drivers/media/i2c/adv7604.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index e43dd2e..32e53e0 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2310,8 +2310,12 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
>  			(reg_io_0x02 & 0x04) ? "(16-235)" : "(0-255)",
>  			((reg_io_0x02 & 0x04) ^ (reg_io_0x02 & 0x01)) ?
>  				"enabled" : "disabled");
> -	v4l2_info(sd, "Color space conversion: %s\n",
> +	if (state->info->type == ADV7604)
> +		v4l2_info(sd, "Color space conversion: %s\n",
>  			csc_coeff_sel_rb[cp_read(sd, 0xfc) >> 4]);
> +	else
> +		v4l2_info(sd, "Color space conversion: %s\n",
> +			csc_coeff_sel_rb[cp_read(sd, 0xf4) >> 4]);
>  
>  	if (!is_digital_input(sd))
>  		return 0;
> 

You need to add this register to the adv7604_chip_info struct, just like is
done for other registers that have this issue.

Regards,

	Hans
