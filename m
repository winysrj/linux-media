Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:46739 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3EMHkr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 03:40:47 -0400
Received: by mail-ve0-f170.google.com with SMTP id 14so1481864vea.15
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 00:40:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_RFb8soKV_ceoozB4ms2tGY+o-m6j+Z9ES38NnrhgU7Q@mail.gmail.com>
References: <CAPgLHd_RFb8soKV_ceoozB4ms2tGY+o-m6j+Z9ES38NnrhgU7Q@mail.gmail.com>
Date: Mon, 13 May 2013 15:40:46 +0800
Message-ID: <CAHG8p1AWKw_FFMfiA=C_Wyb1cVYLW9_A+wmTaWMQPJrCJGom+A@mail.gmail.com>
Subject: Re: [PATCH] [media] blackfin: fix error return code in bcap_probe()
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	yongjun_wei@trendmicro.com.cn,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei Yongjun,

>  drivers/media/platform/blackfin/bfin_capture.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 0e55b08..2d1e032 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -1070,6 +1070,7 @@ static int bcap_probe(struct platform_device *pdev)
>                 if (!config->num_inputs) {
>                         v4l2_err(&bcap_dev->v4l2_dev,
>                                         "Unable to work without input\n");
> +                       ret = -EINVAL;
>                         goto err_unreg_vdev;
>                 }
>
It's better to move this check to  the beginning of this function as I
did in my bfin_display patch.

Scott
