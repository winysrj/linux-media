Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50830 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab2EOMn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 08:43:57 -0400
Received: by wgbds11 with SMTP id ds11so4319584wgb.1
        for <linux-media@vger.kernel.org>; Tue, 15 May 2012 05:43:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F4BEAAB.3000603@gmx.de>
References: <4F4BEAAB.3000603@gmx.de>
Date: Tue, 15 May 2012 18:13:54 +0530
Message-ID: <CAHFNz9Lk2YSBAoBvjm-tDNk-rpe77x36S0GGJ306=qPWWYTdDw@mail.gmail.com>
Subject: Re: [PATCH 1/3] stv090x: Fix typo in register macros
From: Manu Abraham <abraham.manu@gmail.com>
To: Andreas Regel <andreas.regel@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

Sorry about the late reply.

Which datasheet revision are you using ? I looked at RevG and found that the
register ERRCNT22 @ 0xF59D, 0xF39D do have bitfields by name Px_ERR_CNT2
on Page 227.

Did you overlook that by some chance ?

Best Regards,
Manu


On Tue, Feb 28, 2012 at 2:12 AM, Andreas Regel <andreas.regel@gmx.de> wrote:
> Fix typo in register macros of ERRCNT2.
>
> Signed-off-by: Andreas Regel <andreas.regel@gmx.de>
> ---
>  drivers/media/dvb/frontends/stv090x.c     |    2 +-
>  drivers/media/dvb/frontends/stv090x_reg.h |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/stv090x.c
> b/drivers/media/dvb/frontends/stv090x.c
> index 4aef187..6c3c095 100644
> --- a/drivers/media/dvb/frontends/stv090x.c
> +++ b/drivers/media/dvb/frontends/stv090x.c
> @@ -3526,7 +3526,7 @@ static int stv090x_read_per(struct dvb_frontend *fe,
> u32 *per)
>        } else {
>                /* Counter 2 */
>                reg = STV090x_READ_DEMOD(state, ERRCNT22);
> -               h = STV090x_GETFIELD_Px(reg, ERR_CNT2_FIELD);
> +               h = STV090x_GETFIELD_Px(reg, ERR_CNT22_FIELD);
>                reg = STV090x_READ_DEMOD(state, ERRCNT21);
>                m = STV090x_GETFIELD_Px(reg, ERR_CNT21_FIELD);
> diff --git a/drivers/media/dvb/frontends/stv090x_reg.h
> b/drivers/media/dvb/frontends/stv090x_reg.h
> index 93741ee..26c8885 100644
> --- a/drivers/media/dvb/frontends/stv090x_reg.h
> +++ b/drivers/media/dvb/frontends/stv090x_reg.h
> @@ -2232,8 +2232,8 @@
>  #define STV090x_P2_ERRCNT22
>  STV090x_Px_ERRCNT22(2)
>  #define STV090x_OFFST_Px_ERRCNT2_OLDVALUE_FIELD                7
>  #define STV090x_WIDTH_Px_ERRCNT2_OLDVALUE_FIELD                1
> -#define STV090x_OFFST_Px_ERR_CNT2_FIELD                        0
> -#define STV090x_WIDTH_Px_ERR_CNT2_FIELD                        7
> +#define STV090x_OFFST_Px_ERR_CNT22_FIELD               0
> +#define STV090x_WIDTH_Px_ERR_CNT22_FIELD               7
>  #define STV090x_Px_ERRCNT21(__x)                      (0xF59E - (__x - 1) *
> 0x200)
>  #define STV090x_P1_ERRCNT21
>  STV090x_Px_ERRCNT21(1)
> --
> 1.7.2.5
>
