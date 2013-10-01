Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4691 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3JAGkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 02:40:14 -0400
Message-ID: <524A6E3C.5020401@xs4all.nl>
Date: Tue, 01 Oct 2013 08:39:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 1/1] [media] radio-sf16fmr2: Remove redundant dev_set_drvdata
References: <1379666271-20141-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1379666271-20141-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2013 10:37 AM, Sachin Kamat wrote:
> Driver core sets driver data to NULL upon failure or remove.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/radio/radio-sf16fmr2.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
> index f1e3714..448cac9 100644
> --- a/drivers/media/radio/radio-sf16fmr2.c
> +++ b/drivers/media/radio/radio-sf16fmr2.c
> @@ -295,7 +295,6 @@ static void fmr2_remove(struct fmr2 *fmr2)
>  static int fmr2_isa_remove(struct device *pdev, unsigned int ndev)
>  {
>  	fmr2_remove(dev_get_drvdata(pdev));
> -	dev_set_drvdata(pdev, NULL);
>  
>  	return 0;
>  }
> 

