Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:45332 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946944Ab3BHTXU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 14:23:20 -0500
Received: by mail-vc0-f176.google.com with SMTP id fk10so542589vcb.7
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2013 11:23:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E1U3sYh-0001KV-Eo@www.linuxtv.org>
References: <E1U3sYh-0001KV-Eo@www.linuxtv.org>
Date: Fri, 8 Feb 2013 14:23:18 -0500
Message-ID: <CAOcJUbyOQKFvaGfBFb9w3nZeg-428EeYGw2gvAfDAdhRswtonQ@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.9] [media] [PATH, 1/2] mxl5007 move reset to attach
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: linuxtv-commits@linuxtv.org, Antti Palosaari <crope@iki.fi>,
	Jose Alberto Reguero <jareguero@telefonica.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

This isn't ready for merge yet.  Please revert it.  This needs more
work as I explained on the mailing list.

-Mike Krufky

On Fri, Feb 8, 2013 at 12:37 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] [PATH,1/2] mxl5007 move reset to attach
> Author:  Jose Alberto Reguero <jareguero@telefonica.net>
> Date:    Sun Feb 3 18:30:38 2013 -0300
>
> This patch move the soft reset to the attach function because with dual
> tuners, when one tuner do reset, the other one is perturbed, and the
> stream has errors.
>
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>  drivers/media/tuners/mxl5007t.c |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=0a3237704dec476be3cdfbe8fc9df9cc65b14442
>
> diff --git a/drivers/media/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
> index 69e453e..eb61304 100644
> --- a/drivers/media/tuners/mxl5007t.c
> +++ b/drivers/media/tuners/mxl5007t.c
> @@ -531,10 +531,6 @@ static int mxl5007t_tuner_init(struct mxl5007t_state *state,
>         struct reg_pair_t *init_regs;
>         int ret;
>
> -       ret = mxl5007t_soft_reset(state);
> -       if (mxl_fail(ret))
> -               goto fail;
> -
>         /* calculate initialization reg array */
>         init_regs = mxl5007t_calc_init_regs(state, mode);
>
> @@ -900,7 +896,20 @@ struct dvb_frontend *mxl5007t_attach(struct dvb_frontend *fe,
>                 /* existing tuner instance */
>                 break;
>         }
> +
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 1);
> +
> +       ret = mxl5007t_soft_reset(state);
> +
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +       if (mxl_fail(ret))
> +               goto fail;
> +
>         fe->tuner_priv = state;
> +
>         mutex_unlock(&mxl5007t_list_mutex);
>
>         memcpy(&fe->ops.tuner_ops, &mxl5007t_tuner_ops,
>
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
