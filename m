Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46311 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2GFIEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 04:04:50 -0400
Received: by wibhm11 with SMTP id hm11so546731wib.1
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 01:04:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340892520-9063-1-git-send-email-peter.senna@gmail.com>
References: <1340892520-9063-1-git-send-email-peter.senna@gmail.com>
Date: Fri, 6 Jul 2012 13:34:48 +0530
Message-ID: <CAHFNz9+2+EQjmHR4w9TXgV37xB5uaUOpJoqY00adWZ_6M_VZxw@mail.gmail.com>
Subject: Re: [PATCH] [V3] stv090x: variable 'no_signal' set but not used
From: Manu Abraham <abraham.manu@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 28, 2012 at 7:38 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> Remove variable and ignore return value of stv090x_chk_signal().
>
> Tested by compilation only.
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Reviewed-by: Manu Abraham <manu@linuxtv.org>

> ---
>  drivers/media/dvb/frontends/stv090x.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
> index d79e69f..ea86a56 100644
> --- a/drivers/media/dvb/frontends/stv090x.c
> +++ b/drivers/media/dvb/frontends/stv090x.c
> @@ -3172,7 +3172,7 @@ static enum stv090x_signal_state stv090x_algo(struct stv090x_state *state)
>         enum stv090x_signal_state signal_state = STV090x_NOCARRIER;
>         u32 reg;
>         s32 agc1_power, power_iq = 0, i;
> -       int lock = 0, low_sr = 0, no_signal = 0;
> +       int lock = 0, low_sr = 0;
>
>         reg = STV090x_READ_DEMOD(state, TSCFGH);
>         STV090x_SETFIELD_Px(reg, RST_HWARE_FIELD, 1); /* Stop path 1 stream merger */
> @@ -3413,7 +3413,7 @@ static enum stv090x_signal_state stv090x_algo(struct stv090x_state *state)
>                                 goto err;
>                 } else {
>                         signal_state = STV090x_NODATA;
> -                       no_signal = stv090x_chk_signal(state);
> +                       stv090x_chk_signal(state);
>                 }
>         }
>         return signal_state;
> --
> 1.7.10.2
>
