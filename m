Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57298 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752031AbdBML0J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 06:26:09 -0500
Subject: Re: [PATCH] Staging: media: bcm2048: Fixed coding style issue.
To: Ran Algawi <ran.algawi@gmail.com>, gregkh@linuxfoundation.org
References: <1486935932-2146-1-git-send-email-ran.algawi@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bfc49a13-0db6-730c-8f64-54a0ffe11cca@xs4all.nl>
Date: Mon, 13 Feb 2017 12:26:03 +0100
MIME-Version: 1.0
In-Reply-To: <1486935932-2146-1-git-send-email-ran.algawi@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2017 10:45 PM, Ran Algawi wrote:
> Fixed a coding style issue, where an octal value was needed insted of decimal.
> 
> Signed-off-by: Ran Algawi <ran.algawi@gmail.com>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 37bd439..d605c41 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -300,7 +300,7 @@ struct bcm2048_device {
>  };
>  
>  static int radio_nr = -1;	/* radio device minor (-1 ==> auto assign) */
> -module_param(radio_nr, int, 0);
> +module_param(radio_nr, int, 0000);

Let's make this 0444, just like most other media drivers with a radio_nr param.

In fact, I propose that you make this patch more useful by looking at the output of:

git grep module_param drivers/media/|grep '\(video_nr\)\|\(radio_nr\)\|\(vbi_nr\)'

and change all to 0444. I see a mix of 0000, 0444 and 0644 being used, but 0444
is really the only sensible one.

	Hans

>  MODULE_PARM_DESC(radio_nr,
>  		 "Minor number for radio device (-1 ==> auto assign)");
>  
> 
