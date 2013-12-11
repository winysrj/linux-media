Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:39388 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3LKQ5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 11:57:24 -0500
Received: by mail-we0-f173.google.com with SMTP id u57so6892565wes.32
        for <linux-media@vger.kernel.org>; Wed, 11 Dec 2013 08:57:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131211060921.GA4772@ubuntu>
References: <20131211060921.GA4772@ubuntu>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 11 Dec 2013 22:27:02 +0530
Message-ID: <CA+V-a8uAYZxKrG54-mq-obBJEtexrEfs11ScV98wZD4ec16yFQ@mail.gmail.com>
Subject: Re: [PATCH v3] staging: media: davinci_vpfe: Rewrite return statement
 in vpfe_video.c
To: Lisa Nguyen <lisa@xenapiadmin.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lisa,

Thanks for the patch.

On Wed, Dec 11, 2013 at 11:39 AM, Lisa Nguyen <lisa@xenapiadmin.com> wrote:
> Rewrite the return statement in vpfe_video.c. This will prevent
> the checkpatch.pl script from generating a warning saying
> to remove () from this particular return statement.
>
> Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Will be queueing it for 3.14.

Regrads,
--Prabhakar Lad

> ---
> Changes since v3:
> - Removed () from return statement per Laurent Pinchart's suggestion
>
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 24d98a6..3b036be 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -346,7 +346,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
>         }
>         mutex_unlock(&mdev->graph_mutex);
>
> -       return (ret == 0) ? ret : -ETIMEDOUT ;
> +       return ret ? -ETIMEDOUT : 0;
>  }
>
>  /*
> --
> 1.7.9.5
>
