Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42632 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3LKMCg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 07:02:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lisa Nguyen <lisa@xenapiadmin.com>
Cc: prabhakar.csengg@gmail.com,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH v3] staging: media: davinci_vpfe: Rewrite return statement in vpfe_video.c
Date: Wed, 11 Dec 2013 13:02:48 +0100
Message-ID: <1716044.mWq9ph1Vrl@avalon>
In-Reply-To: <20131211060921.GA4772@ubuntu>
References: <20131211060921.GA4772@ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lisa,

Thank you for the patch.

On Tuesday 10 December 2013 22:09:22 Lisa Nguyen wrote:
> Rewrite the return statement in vpfe_video.c. This will prevent
> the checkpatch.pl script from generating a warning saying
> to remove () from this particular return statement.
> 
> Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>

Acked-by; Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> Changes since v3:
> - Removed () from return statement per Laurent Pinchart's suggestion
> 
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> b/drivers/staging/media/davinci_vpfe/vpfe_video.c index 24d98a6..3b036be
> 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -346,7 +346,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline
> *pipe) }
>  	mutex_unlock(&mdev->graph_mutex);
> 
> -	return (ret == 0) ? ret : -ETIMEDOUT ;
> +	return ret ? -ETIMEDOUT : 0;
>  }
> 
>  /*
-- 
Regards,

Laurent Pinchart

