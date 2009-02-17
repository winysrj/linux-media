Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:35786 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZBQRSt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 12:18:49 -0500
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 39D552F6DC
	for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 18:18:30 +0100 (CET)
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH] mt9m111: Call icl->reset() on mt9m111_reset().
References: <20090217112339.f959035b.ospite@studenti.unina.it>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 17 Feb 2009 18:17:13 +0100
In-Reply-To: <20090217112339.f959035b.ospite@studenti.unina.it> (Antonio Ospite's message of "Tue\, 17 Feb 2009 11\:23\:39 +0100")
Message-ID: <87prhhrnja.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antonio Ospite <ospite@studenti.unina.it> writes:

> Call icl->reset() on mt9m111_reset().
>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
>
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index c043f62..92dd7f3 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -393,6 +393,8 @@ static int mt9m111_disable(struct soc_camera_device *icd)
>  
>  static int mt9m111_reset(struct soc_camera_device *icd)
>  {
> +	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
> +	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
>  	int ret;
>  
>  	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
> @@ -401,6 +403,10 @@ static int mt9m111_reset(struct soc_camera_device *icd)
>  	if (!ret)
>  		ret = reg_clear(RESET, MT9M111_RESET_RESET_MODE
>  				| MT9M111_RESET_RESET_SOC);
> +
> +	if (icl->reset)
> +		icl->reset(&mt9m111->client->dev);
> +
>  	return ret;
>  }
>  

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Guennadi, would you queue that up for next, please ?

Cheers.

--
Robert
