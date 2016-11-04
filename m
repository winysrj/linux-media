Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36371 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755103AbcKDJBB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 05:01:01 -0400
Received: by mail-qk0-f176.google.com with SMTP id o68so88956861qkf.3
        for <linux-media@vger.kernel.org>; Fri, 04 Nov 2016 02:01:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1478246311-15944-1-git-send-email-maninder.s2@samsung.com>
References: <1478246311-15944-1-git-send-email-maninder.s2@samsung.com>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Fri, 4 Nov 2016 10:00:59 +0100
Message-ID: <CA+M3ks6A=Y9GkKNyS+AFeHor1qN0rNO6uS6e=ayQciHCoG685Q@mail.gmail.com>
Subject: Re: [PATCH] staging: st-cec: add parentheses around complex macros
To: Maninder Singh <maninder.s2@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@stlinux.com,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Ravikant Bijendra Sharma <ravikant.s2@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks,

Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

2016-11-04 8:58 GMT+01:00 Maninder Singh <maninder.s2@samsung.com>:
> This patch fixes the following checkpatch.pl error:
> ERROR: Macros with complex values should be enclosed in parentheses
>
> Signed-off-by: Maninder Singh <maninder.s2@samsung.com>
> ---
>  drivers/staging/media/st-cec/stih-cec.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/staging/me=
dia/st-cec/stih-cec.c
> index 2143448..b22394a 100644
> --- a/drivers/staging/media/st-cec/stih-cec.c
> +++ b/drivers/staging/media/st-cec/stih-cec.c
> @@ -108,11 +108,11 @@
>
>  /* Constants for CEC_BIT_TOUT_THRESH register */
>  #define CEC_SBIT_TOUT_47MS BIT(1)
> -#define CEC_SBIT_TOUT_48MS BIT(0) | BIT(1)
> +#define CEC_SBIT_TOUT_48MS (BIT(0) | BIT(1))
>  #define CEC_SBIT_TOUT_50MS BIT(2)
>  #define CEC_DBIT_TOUT_27MS BIT(0)
>  #define CEC_DBIT_TOUT_28MS BIT(1)
> -#define CEC_DBIT_TOUT_29MS BIT(0) | BIT(1)
> +#define CEC_DBIT_TOUT_29MS (BIT(0) | BIT(1))
>
>  /* Constants for CEC_BIT_PULSE_THRESH register */
>  #define CEC_BIT_LPULSE_03MS BIT(1)
> --
> 1.7.9.5
>



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
