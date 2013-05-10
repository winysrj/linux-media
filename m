Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4806 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3EJK4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 06:56:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] davinci: vpfe: fix error path in probe
Date: Fri, 10 May 2013 12:55:47 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1368161318-16128-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1368161318-16128-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305101255.47709.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri May 10 2013 06:48:38 Lad Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> The error path on failure was calling mutex_unlock(), but there was
> no actuall call before for mutex_lock(). This patch fixes this issue
> by pointing it to proper go label.
> 
> Reported-by: Jose Pablo Carballo <jose.carballo@ridgerun.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpfe_capture.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index 8c50d30..3827fe1 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -1837,7 +1837,7 @@ static int vpfe_probe(struct platform_device *pdev)
>  	if (NULL == ccdc_cfg) {
>  		v4l2_err(pdev->dev.driver,
>  			 "Memory allocation failed for ccdc_cfg\n");
> -		goto probe_free_lock;
> +		goto probe_free_dev_mem;
>  	}
>  
>  	mutex_lock(&ccdc_lock);
> 

Just FYI:

After applying this patch I get a compiler warning that the probe_free_lock
label is unused. I've added a patch removing that label.

Regards,

	Hans
