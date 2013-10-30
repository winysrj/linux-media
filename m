Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57670 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3J3HqD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 03:46:03 -0400
Received: by mail-wi0-f177.google.com with SMTP id f4so992302wiw.10
        for <linux-media@vger.kernel.org>; Wed, 30 Oct 2013 00:46:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c171c58417eb45b816caa1fd8cb0d74ae813dbbf.1382995303.git.lisa@xenapiadmin.com>
References: <c171c58417eb45b816caa1fd8cb0d74ae813dbbf.1382995303.git.lisa@xenapiadmin.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 30 Oct 2013 13:15:41 +0530
Message-ID: <CA+V-a8voBQyaMS4QRWQsBGSSE6zE0BF5mZyC9=BKXhGYsMa4ZA@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: media: davinci_vpfe: Rewrite return
 statement in vpfe_video.c
To: Lisa Nguyen <lisa@xenapiadmin.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lisa,

Thanks for the patch.

On Tue, Oct 29, 2013 at 2:53 AM, Lisa Nguyen <lisa@xenapiadmin.com> wrote:
> Rewrite the return statement in vpfe_video.c to eliminate the
> use of a ternary operator. This will prevent the checkpatch.pl
> script from generating a warning saying to remove () from
> this particular return statement.
>
> Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 24d98a6..49aafe4 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -346,7 +346,10 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
>         }
>         mutex_unlock(&mdev->graph_mutex);
>
> -       return (ret == 0) ? ret : -ETIMEDOUT ;
> +       if (ret == 0)
> +               return ret;
> +       else
I would remove this else and align the below return statement.

> +               return -ETIMEDOUT;
>  }
>
>  /*
Regards,
--Prabhakar Lad
