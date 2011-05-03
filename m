Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab1ECPYA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 11:24:00 -0400
Message-ID: <4DC01E0C.3070205@redhat.com>
Date: Tue, 03 May 2011 12:23:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tobias Lorenz <tobias.lorenz@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] remove #ifdef to show rds support by i2c driver.
References: <201105012101.43801.tobias.lorenz@gmx.net>
In-Reply-To: <201105012101.43801.tobias.lorenz@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-05-2011 16:01, Tobias Lorenz escreveu:
> This removes some #ifdef statements.
> RDS support is now indicated by I2C driver too.
> The functionality was already in the driver.

This is also applied.

> 
> Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
> ---
>  drivers/media/radio/si470x/radio-si470x-common.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c 
> b/drivers/media/radio/si470x/radio-si470x-common.c
> index f016220..bf58931 100644
> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> @@ -687,12 +687,8 @@ static int si470x_vidioc_g_tuner(struct file *file, void 
> *priv,

Also, your patches are being mangled by your emailer.

Please, rebase your patches against staging/for_v2.6.40, test and re-send
them with an email software that works.

Thanks
Mauro
