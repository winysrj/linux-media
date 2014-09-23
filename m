Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58123 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaIWGhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 02:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140922080008.GB12362@mwanda>
References: <20140922080008.GB12362@mwanda>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 23 Sep 2014 07:36:35 +0100
Message-ID: <CA+V-a8uFTMJS+_u7YZuO1qxj5+crYKCtDNdssA23Pd5ur4NeNQ@mail.gmail.com>
Subject: Re: [patch] [media] davinci: remove an unneeded check
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thanks for the patch!

On Mon, Sep 22, 2014 at 9:00 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We don't need to check "ret", we know it's zero.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

>
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index c557eb5..3eb6e4b 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -442,11 +442,10 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
>                 return ret;
>
>         /* Update the values of sizeimage and bytesperline */
> -       if (!ret) {
> -               pix->bytesperline = ccdc_dev->hw_ops.get_line_length();
> -               pix->sizeimage = pix->bytesperline * pix->height;
> -       }
> -       return ret;
> +       pix->bytesperline = ccdc_dev->hw_ops.get_line_length();
> +       pix->sizeimage = pix->bytesperline * pix->height;
> +
> +       return 0;
>  }
>
>  static int vpfe_initialize_device(struct vpfe_device *vpfe_dev)
