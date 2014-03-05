Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:57696 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbaCELmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 06:42:14 -0500
Received: by mail-ob0-f169.google.com with SMTP id va2so874745obc.28
        for <linux-media@vger.kernel.org>; Wed, 05 Mar 2014 03:42:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1394017710-671-1-git-send-email-sw0312.kim@samsung.com>
References: <187b01cf385bb9b4510$%debski@samsung.com>
	<1394017710-671-1-git-send-email-sw0312.kim@samsung.com>
Date: Wed, 5 Mar 2014 17:12:14 +0530
Message-ID: <CAK9yfHx_yx9qvitSGfNZWJfRK1ZtrOu3VdhJh-aEZ4LNv_8Z-A@mail.gmail.com>
Subject: Re: [PATCH] [media] s5-mfc: remove meaningless memory bank assignment
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 March 2014 16:38, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
> There was assignment of memory bank with dma address converted
> from physical address. But allocation has been changed with dma
> function, so the assignment is not necessary.
>
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> ---
> change from v1
> - fixes subject and adds proper description
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> index 2475a3c..ee05f2d 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> @@ -44,8 +44,6 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
>                 return -ENOMEM;
>         }
>
> -       dev->bank1 = dev->bank1;

Are you sure this isn't some kind of typo? If not then your commit
description is too verbose
to actually say that the code is redundant and could be removed. The
code here is something like

 a = a;

which does not make sense nor add any value and hence redundant and
could be removed.

-- 
With warm regards,
Sachin
