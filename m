Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36786 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3LJQub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 11:50:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lisa Nguyen <lisa@xenapiadmin.com>
Cc: prabhakar.csengg@gmail.com,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH v2] staging: media: davinci_vpfe: Rewrite return statement in vpfe_video.c
Date: Tue, 10 Dec 2013 17:50:41 +0100
Message-ID: <2939201.P8qvUzaVN6@avalon>
In-Reply-To: <20131210160541.GA15282@ubuntu>
References: <20131210160541.GA15282@ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lisa,

Thank you for the patch.

On Tuesday 10 December 2013 08:05:42 Lisa Nguyen wrote:
> Rewrite the return statement in vpfe_video.c to eliminate the
> use of a ternary operator. This will prevent the checkpatch.pl
> script from generating a warning saying to remove () from
> this particular return statement.
> 
> Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
> ---
> Changes since v2:
> - Aligned -ETIMEDOUT return statement with if condition
> 
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> b/drivers/staging/media/davinci_vpfe/vpfe_video.c index 24d98a6..22e31d2
> 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -346,7 +346,10 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline
> *pipe) }
>  	mutex_unlock(&mdev->graph_mutex);
> 
> -	return (ret == 0) ? ret : -ETIMEDOUT ;
> +	if (ret == 0)
> +		return ret;
> +
> +	return -ETIMEDOUT;

I don't want to point the obvious, but what about just

	return ret ? -ETIMEDOUT : 0;

or, if this is just about fixing the checkpatch.pl warning,

	return ret == 0 ? ret : -ETIMEDOUT;

(I'd prefer the first)

>  }
> 
>  /*

-- 
Regards,

Laurent Pinchart

