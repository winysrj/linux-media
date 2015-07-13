Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60889 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbbGMJWg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 05:22:36 -0400
Message-ID: <55A38324.1010007@xs4all.nl>
Date: Mon, 13 Jul 2015 11:21:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Benoit Parrot <bparrot@ti.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [Patch v3 1/1] media: am437x-vpfe: Fix a race condition during
 release
References: <1435612716-3952-1-git-send-email-bparrot@ti.com>
In-Reply-To: <1435612716-3952-1-git-send-email-bparrot@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/29/2015 11:18 PM, Benoit Parrot wrote:
> There was a race condition where during cleanup/release operation
> on-going streaming would cause a kernel panic because the hardware
> module was disabled prematurely with IRQ still pending.
> 
> Fixes: 417d2e507edc ("[media] media: platform: add VPFE capture driver support for AM437X")
> Cc: <stable@vger.kernel.org> # v4.0+
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
> Changes since v2:
> - fix the stable commit reference syntax
> 
>  drivers/media/platform/am437x/am437x-vpfe.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> index a30cc2f7e4f1..eb25c43da126 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -1185,14 +1185,21 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe)
>  static int vpfe_release(struct file *file)
>  {
>  	struct vpfe_device *vpfe = video_drvdata(file);
> +	bool fh_singular = v4l2_fh_is_singular_file(file);

Close, but no cigar.

The assignment to fh_singular should be moved inside the mutex. Right now
there still is a race condition between setting fh_singular and taking
the lock.

Regards,

	Hans

>  	int ret;
>  
>  	mutex_lock(&vpfe->lock);
>  
> -	if (v4l2_fh_is_singular_file(file))
> -		vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
> +	/* the release helper will cleanup any on-going streaming */
>  	ret = _vb2_fop_release(file, NULL);
>  
> +	/*
> +	 * If this was the last open file.
> +	 * Then de-initialize hw module.
> +	 */
> +	if (fh_singular)
> +		vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
> +
>  	mutex_unlock(&vpfe->lock);
>  
>  	return ret;
> 

