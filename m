Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:35635 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886AbbGGLMv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2015 07:12:51 -0400
MIME-Version: 1.0
In-Reply-To: <1435612716-3952-1-git-send-email-bparrot@ti.com>
References: <1435612716-3952-1-git-send-email-bparrot@ti.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 7 Jul 2015 12:12:18 +0100
Message-ID: <CA+V-a8sy_4N0afCKVo1NckcU1Jj1pAG1Q1SusxvWtfiGkNRdmw@mail.gmail.com>
Subject: Re: [Patch v3 1/1] media: am437x-vpfe: Fix a race condition during release
To: Benoit Parrot <bparrot@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 29, 2015 at 10:18 PM, Benoit Parrot <bparrot@ti.com> wrote:
> There was a race condition where during cleanup/release operation
> on-going streaming would cause a kernel panic because the hardware
> module was disabled prematurely with IRQ still pending.
>
> Fixes: 417d2e507edc ("[media] media: platform: add VPFE capture driver support for AM437X")
> Cc: <stable@vger.kernel.org> # v4.0+
> Signed-off-by: Benoit Parrot <bparrot@ti.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
> Changes since v2:
> - fix the stable commit reference syntax
>
>  drivers/media/platform/am437x/am437x-vpfe.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> index a30cc2f7e4f1..eb25c43da126 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -1185,14 +1185,21 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe)
>  static int vpfe_release(struct file *file)
>  {
>         struct vpfe_device *vpfe = video_drvdata(file);
> +       bool fh_singular = v4l2_fh_is_singular_file(file);
>         int ret;
>
>         mutex_lock(&vpfe->lock);
>
> -       if (v4l2_fh_is_singular_file(file))
> -               vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
> +       /* the release helper will cleanup any on-going streaming */
>         ret = _vb2_fop_release(file, NULL);
>
> +       /*
> +        * If this was the last open file.
> +        * Then de-initialize hw module.
> +        */
> +       if (fh_singular)
> +               vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
> +
>         mutex_unlock(&vpfe->lock);
>
>         return ret;
> --
> 1.8.5.1
>
