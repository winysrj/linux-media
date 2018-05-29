Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38338 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966399AbeE2TzW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 15:55:22 -0400
MIME-Version: 1.0
In-Reply-To: <20180525131239.45exrwgxr2f3kb57@kili.mountain>
References: <a322043a-5b45-b695-4302-173c5111896b@xs4all.nl> <20180525131239.45exrwgxr2f3kb57@kili.mountain>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 29 May 2018 19:54:51 +0000
Message-ID: <CA+V-a8sAnQ=apqSYMGrG8kQQ92odssu=Rqb9Q-2Fj8ya5ZkyFQ@mail.gmail.com>
Subject: Re: [PATCH v3] media: davinci vpbe: array underflow in vpbe_enum_outputs()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 7:26 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> In vpbe_enum_outputs() we check if (temp_index >= cfg->num_outputs) but
> the problem is that temp_index can be negative.  I've changed the types
> to unsigned to fix this issue.
>
> Fixes: 66715cdc3224 ("[media] davinci vpbe: VPBE display driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: fix it a different way
> v3: change everything to unsigned because that's the right thing to do
>     and looks nicer.
>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> diff --git a/include/media/davinci/vpbe.h b/include/media/davinci/vpbe.h
> index 79a566d7defd..180a05e91497 100644
> --- a/include/media/davinci/vpbe.h
> +++ b/include/media/davinci/vpbe.h
> @@ -92,7 +92,7 @@ struct vpbe_config {
>         struct encoder_config_info *ext_encoders;
>         /* amplifier information goes here */
>         struct amp_config_info *amp;
> -       int num_outputs;
> +       unsigned int num_outputs;
>         /* Order is venc outputs followed by LCD and then external encoders */
>         struct vpbe_output *outputs;
>  };
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index 18c035ef84cf..c6fee53bff4d 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -126,7 +126,7 @@ static int vpbe_enum_outputs(struct vpbe_device *vpbe_dev,
>                              struct v4l2_output *output)
>  {
>         struct vpbe_config *cfg = vpbe_dev->cfg;
> -       int temp_index = output->index;
> +       unsigned int temp_index = output->index;
>
>         if (temp_index >= cfg->num_outputs)
>                 return -EINVAL;
