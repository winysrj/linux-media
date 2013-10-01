Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:48737 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3JAFjt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 01:39:49 -0400
Received: by mail-la0-f54.google.com with SMTP id ea20so5308586lab.41
        for <linux-media@vger.kernel.org>; Mon, 30 Sep 2013 22:39:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1379666181-19546-8-git-send-email-sachin.kamat@linaro.org>
References: <1379666181-19546-1-git-send-email-sachin.kamat@linaro.org>
	<1379666181-19546-8-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 1 Oct 2013 11:09:47 +0530
Message-ID: <CAHFNz9+S8oUk+ixQghD2fehj38RgkgCvVB_g2Qy1qRonpjJPhQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] [media] pci: bt878: Remove redundant pci_set_drvdata
From: Manu Abraham <abraham.manu@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	m.chehab@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 20, 2013 at 2:06 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Driver core sets driver data to NULL upon failure or remove.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Manu Abraham <manu@linuxtv.org>
> ---
>  drivers/media/pci/bt8xx/bt878.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
> index 66eb0ba..2bd2483 100644
> --- a/drivers/media/pci/bt8xx/bt878.c
> +++ b/drivers/media/pci/bt8xx/bt878.c
> @@ -563,7 +563,6 @@ static void bt878_remove(struct pci_dev *pci_dev)
>         bt->shutdown = 1;
>         bt878_mem_free(bt);
>
> -       pci_set_drvdata(pci_dev, NULL);
>         pci_disable_device(pci_dev);
>         return;
>  }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
