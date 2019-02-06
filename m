Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF636C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 17:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B954920B1F
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 17:36:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=vanguardiasur-com-ar.20150623.gappssmtp.com header.i=@vanguardiasur-com-ar.20150623.gappssmtp.com header.b="C5VU72Qp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfBFRgS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 12:36:18 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:46035 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728473AbfBFRgR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 12:36:17 -0500
Received: by mail-vs1-f68.google.com with SMTP id x28so4890987vsh.12
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 09:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanguardiasur-com-ar.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UILYWHb/EltJt2A6nbNGfC809ovXnOw5uaXq0X2JZw0=;
        b=C5VU72QpnWftNs6xNaypTyDbOGUNlKhi/timor5MkDrNDQZyclyTxWmy8gGa2HHOx5
         sKjc5SiIXe1HojLFmz6HzPmIMhjuu9VeclY5l6O3FrpSqTg0RHjaDhNzaEM0MmcSBV55
         scfvVfgeY1hKwRTqviDZkYjYNishytOmaUeFy+Ehd/HdnoTDKCRUutLFyVPLUwzFuqYz
         0gaYGJv7m8Lzi+ETT7dP6kUAVrzs9LevqeSwV6wOYOWWsVyEXG/dQD1su4V23KpRYnNi
         sAhepX00i7EK0UIw6ovlRipILU4/xFmdp14VX/f/5ELQUq/3xf+jc5kOvNRwuaSCot3/
         KlTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UILYWHb/EltJt2A6nbNGfC809ovXnOw5uaXq0X2JZw0=;
        b=a2cH36ghMDxBd+7HvCCPLqSW3OwaTNxKS2WIi67X3nf8RkCG3jYYbiy7fsh3Isu9eL
         ExD2GV/h0tOlXzfqNuKj6DTjpPtRQWt+mWhV9FSUhyJKOd6p/MsUifdtxfSzOJz4w5B7
         QfEqeKz7LajeDWLWwww/QnN3MZhE5PFuwnhMN/0RYFalb207Rche0Vhh8FmBe1zlt4hU
         DFWgyRD7t0w02QXGIFY10d2iB9tpn2g1+NL34bqzzKF9SEryTpTbG4e368XmwYtjr+cM
         0e+cBn+OXwAb88dk3Gvp3eO+vzwXz1EqsEN7T864kJd1H5oBDz8y94prM+X2d7sPOr5q
         VErg==
X-Gm-Message-State: AHQUAuaf6nBuQpLHtms1ErjeyGsusCVMzzNDEu/O1DuQ7OhfyMaAZeQC
        C1Y2Mdac+LYX9X4KYHs/dgyZVUSMBtilV1JW3ldLFg==
X-Google-Smtp-Source: AHgI3Ibb8CR735AKbmFlWqWv/SE8B++L6q5pZHqDaN5A9/L5Q6U7laYN4fS9Hvp1wtriQN5xPk7lCUHva5bJy3tbyFk=
X-Received: by 2002:a67:7b4a:: with SMTP id w71mr2553645vsc.105.1549474576198;
 Wed, 06 Feb 2019 09:36:16 -0800 (PST)
MIME-Version: 1.0
References: <20190206173239.18046-1-tiwai@suse.de>
In-Reply-To: <20190206173239.18046-1-tiwai@suse.de>
From:   Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date:   Wed, 6 Feb 2019 14:36:05 -0300
Message-ID: <CAAEAJfA2fr6XwL-k9xNqToFypUZ-CvfotJpq6EHDBNiEgmCO8g@mail.gmail.com>
Subject: Re: [PATCH] media: Drop superfluous PCM preallocation error checks
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 6 Feb 2019 at 14:32, Takashi Iwai <tiwai@suse.de> wrote:
>
> snd_pcm_lib_preallocate_pages() and co always succeed, so the error
> check is simply redundant.  Drop it.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>
> This is a piece I overlooked in the previous patchset:
>    https://www.spinics.net/lists/alsa-devel/msg87223.html
>
> Media people, please give ACK if this is OK.  Then I'll merge it together
> with other relevant patches.  Thanks!
>
>  drivers/media/pci/solo6x10/solo6x10-g723.c | 4 +---
>  drivers/media/pci/tw686x/tw686x-audio.c    | 3 ++-

tw686x changes look good.

Acked-by: Ezequiel Garcia <ezequiel@collabora.com>

Thanks,
Eze

>  2 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/p=
ci/solo6x10/solo6x10-g723.c
> index 2cc05a9d57ac..a16242a9206f 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-g723.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
> @@ -360,13 +360,11 @@ static int solo_snd_pcm_init(struct solo_dev *solo_=
dev)
>              ss; ss =3D ss->next, i++)
>                 sprintf(ss->name, "Camera #%d Audio", i);
>
> -       ret =3D snd_pcm_lib_preallocate_pages_for_all(pcm,
> +       snd_pcm_lib_preallocate_pages_for_all(pcm,
>                                         SNDRV_DMA_TYPE_CONTINUOUS,
>                                         snd_dma_continuous_data(GFP_KERNE=
L),
>                                         G723_PERIOD_BYTES * PERIODS,
>                                         G723_PERIOD_BYTES * PERIODS);
> -       if (ret < 0)
> -               return ret;
>
>         solo_dev->snd_pcm =3D pcm;
>
> diff --git a/drivers/media/pci/tw686x/tw686x-audio.c b/drivers/media/pci/=
tw686x/tw686x-audio.c
> index a28329698e20..fb0e7573b5ae 100644
> --- a/drivers/media/pci/tw686x/tw686x-audio.c
> +++ b/drivers/media/pci/tw686x/tw686x-audio.c
> @@ -301,11 +301,12 @@ static int tw686x_snd_pcm_init(struct tw686x_dev *d=
ev)
>              ss; ss =3D ss->next, i++)
>                 snprintf(ss->name, sizeof(ss->name), "vch%u audio", i);
>
> -       return snd_pcm_lib_preallocate_pages_for_all(pcm,
> +       snd_pcm_lib_preallocate_pages_for_all(pcm,
>                                 SNDRV_DMA_TYPE_DEV,
>                                 snd_dma_pci_data(dev->pci_dev),
>                                 TW686X_AUDIO_PAGE_MAX * AUDIO_DMA_SIZE_MA=
X,
>                                 TW686X_AUDIO_PAGE_MAX * AUDIO_DMA_SIZE_MA=
X);
> +       return 0;
>  }
>
>  static void tw686x_audio_dma_free(struct tw686x_dev *dev,
> --
> 2.16.4
>


--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
