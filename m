Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:35745 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbbKMPsW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 10:48:22 -0500
MIME-Version: 1.0
In-Reply-To: <1447417479-18095-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1447417479-18095-1-git-send-email-Julia.Lawall@lip6.fr>
Date: Fri, 13 Nov 2015 10:48:21 -0500
Message-ID: <CAOcJUbzGUP47PeLe2ng-BEh031T3ngMStYo9chas4uYqKA8gMQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/media/usb/dvb-usb-v2: constify
 mxl111sf_demod_config structure
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for this!

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>

On Fri, Nov 13, 2015 at 7:24 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> The mxl111sf_demod_config structure is never modified, so declare it
> as const.
>
> Done with the help of Coccinelle.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c |    4 ++--
>  drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h |    4 ++--
>  drivers/media/usb/dvb-usb-v2/mxl111sf.c       |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
> index ea37536..84f6de6 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
> @@ -35,7 +35,7 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able)).");
>  struct mxl111sf_demod_state {
>         struct mxl111sf_state *mxl_state;
>
> -       struct mxl111sf_demod_config *cfg;
> +       const struct mxl111sf_demod_config *cfg;
>
>         struct dvb_frontend fe;
>  };
> @@ -579,7 +579,7 @@ static struct dvb_frontend_ops mxl111sf_demod_ops = {
>  };
>
>  struct dvb_frontend *mxl111sf_demod_attach(struct mxl111sf_state *mxl_state,
> -                                          struct mxl111sf_demod_config *cfg)
> +                                  const struct mxl111sf_demod_config *cfg)
>  {
>         struct mxl111sf_demod_state *state = NULL;
>
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
> index 0bd83e5..7065aca 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
> @@ -35,11 +35,11 @@ struct mxl111sf_demod_config {
>  #if IS_ENABLED(CONFIG_DVB_USB_MXL111SF)
>  extern
>  struct dvb_frontend *mxl111sf_demod_attach(struct mxl111sf_state *mxl_state,
> -                                          struct mxl111sf_demod_config *cfg);
> +                                  const struct mxl111sf_demod_config *cfg);
>  #else
>  static inline
>  struct dvb_frontend *mxl111sf_demod_attach(struct mxl111sf_state *mxl_state,
> -                                          struct mxl111sf_demod_config *cfg)
> +                                  const struct mxl111sf_demod_config *cfg)
>  {
>         printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
>         return NULL;
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> index bec12b0..c4a4a99 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> @@ -731,7 +731,7 @@ fail:
>         return ret;
>  }
>
> -static struct mxl111sf_demod_config mxl_demod_config = {
> +static const struct mxl111sf_demod_config mxl_demod_config = {
>         .read_reg        = mxl111sf_read_reg,
>         .write_reg       = mxl111sf_write_reg,
>         .program_regs    = mxl111sf_ctrl_program_regs,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
