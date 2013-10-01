Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36675 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3JAFhd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 01:37:33 -0400
Received: by mail-lb0-f174.google.com with SMTP id w6so5311562lbh.5
        for <linux-media@vger.kernel.org>; Mon, 30 Sep 2013 22:37:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1379666181-19546-4-git-send-email-sachin.kamat@linaro.org>
References: <1379666181-19546-1-git-send-email-sachin.kamat@linaro.org>
	<1379666181-19546-4-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 1 Oct 2013 11:07:32 +0530
Message-ID: <CAHFNz9+VFBo-9fA1bs1_wKR_GENzNHK24z8mFZ+M6QDhZZGBYQ@mail.gmail.com>
Subject: Re: [PATCH 4/9] [media] pci: mantis: Remove redundant pci_set_drvdata
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
> Cc: Manu Abraham <abraham.manu@gmail.com>
Acked-by: Manu Abraham <manu@linuxtv.org>
> ---
>  drivers/media/pci/mantis/mantis_pci.c |    2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/media/pci/mantis/mantis_pci.c b/drivers/media/pci/mantis/mantis_pci.c
> index a846036..9e89e04 100644
> --- a/drivers/media/pci/mantis/mantis_pci.c
> +++ b/drivers/media/pci/mantis/mantis_pci.c
> @@ -143,7 +143,6 @@ fail1:
>
>  fail0:
>         dprintk(MANTIS_ERROR, 1, "ERROR: <%d> exiting", ret);
> -       pci_set_drvdata(pdev, NULL);
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(mantis_pci_init);
> @@ -161,7 +160,6 @@ void mantis_pci_exit(struct mantis_pci *mantis)
>         }
>
>         pci_disable_device(pdev);
> -       pci_set_drvdata(pdev, NULL);
>  }
>  EXPORT_SYMBOL_GPL(mantis_pci_exit);
>
> --
> 1.7.9.5
>
