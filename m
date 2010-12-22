Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:11939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab0LVQui (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 11:50:38 -0500
Message-ID: <4D122C53.4070300@redhat.com>
Date: Wed, 22 Dec 2010 14:50:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Anatolij Gustschin <agust@denx.de>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Detlev Zundel <dzu@denx.de>
Subject: Re: [1/2] media: saa7115: allow input standard autodetection for
 SAA7113
References: <1292264377-31877-1-git-send-email-agust@denx.de>
In-Reply-To: <1292264377-31877-1-git-send-email-agust@denx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 13-12-2010 16:19, Anatolij Gustschin escreveu:
> Autodetect input's standard using field frequency detection
> feature (FIDT in status byte at 0x1F) of the SAA7113.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> 
> ---
> drivers/media/video/saa7115.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
> index 301c62b..f28a4c7 100644
> --- a/drivers/media/video/saa7115.c
> +++ b/drivers/media/video/saa7115.c
> @@ -1348,6 +1348,18 @@ static int saa711x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
>  	int reg1e;
>  
>  	*std = V4L2_STD_ALL;
> +
> +	if (state->ident == V4L2_IDENT_SAA7113) {
> +		int reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
> +
> +		if (reg1f & 0x20)
> +			*std = V4L2_STD_NTSC;
> +		else
> +			*std = V4L2_STD_PAL;

This is wrong. The meaning of bit 5 of reg 0x1f is if the standard is 50Hz
or 60Hz based (so, it detects the monocromatic standard, not the color
standard). So, instead, it should be doing:

	if (reg1f & 0x20)
		*std = V4L2_STD_525_60;
	else
		*std = V4L2_STD_625_50;

Also, this kind of detection could be used also for the other supported chips
on this driver (I checked datasheets of saa7111/saa7111a/saa7114/saa7118).

So, the better is to code it as: 

 	if (state->ident != V4L2_IDENT_SAA7115) {
		int reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
		if (reg1f & 0x20)
			*std = V4L2_STD_525_60;
		else
			*std = V4L2_STD_625_50;
 		return 0;
	}

> +
> +		return 0;
> +	}
> +
>  	if (state->ident != V4L2_IDENT_SAA7115)
>  		return 0;
>  	reg1e = saa711x_read(sd, R_1E_STATUS_BYTE_1_VD_DEC);
> 

