Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab1ECPQR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 11:16:17 -0400
Message-ID: <4DC01C3C.2010002@redhat.com>
Date: Tue, 03 May 2011 12:16:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tobias Lorenz <tobias.lorenz@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6] correct initialization of demphasis
References: <201105012101.15241.tobias.lorenz@gmx.net>
In-Reply-To: <201105012101.15241.tobias.lorenz@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-05-2011 16:01, Tobias Lorenz escreveu:
> This patch corrects the initialization of demphasis.

Patch were already applied
> 
> Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
> ---
>  drivers/media/radio/si470x/radio-si470x-common.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c 
> b/drivers/media/radio/si470x/radio-si470x-common.c
> index ac76dfe..f016220 100644
> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> @@ -357,7 +357,8 @@ int si470x_start(struct si470x_device *radio)
>  		goto done;
>  
>  	/* sysconfig 1 */
> -	radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
> +	radio->registers[SYSCONFIG1] =
> +		(de << 11) & SYSCONFIG1_DE;		/* DE */
>  	retval = si470x_set_register(radio, SYSCONFIG1);
>  	if (retval < 0)
>  		goto done;

