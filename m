Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59229 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3CXQpI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 12:45:08 -0400
Received: by mail-vc0-f170.google.com with SMTP id lf10so4306284vcb.1
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 09:45:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363894748-28000-4-git-send-email-mchehab@redhat.com>
References: <1363894748-28000-1-git-send-email-mchehab@redhat.com>
	<1363894748-28000-4-git-send-email-mchehab@redhat.com>
Date: Sun, 24 Mar 2013 12:45:07 -0400
Message-ID: <CAOcJUbx6MFDmP-6V2T0LQ-RQ_DWEG9uqvo559w9jD9qmAQa73A@mail.gmail.com>
Subject: Re: [PATCH 4/4] [media] dvb-usb/dvb-usb-v2: use IS_ENABLED
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>

On Thu, Mar 21, 2013 at 3:39 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Instead of checking everywhere there for 3 symbols, use instead
> IS_ENABLED macro.
>
> This replacement was done using this small perl script:
>
> my $data;
> $data .= $_ while (<>);
> if ($data =~ m/CONFIG_([A-Z\_\d]*)_MODULE/) {
>         $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
>         $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
>         $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
>         $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)\!]+defined\(CONFIG_($f)_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
>
>         $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)\)\)*,IS_ENABLED(CONFIG_$f),g;
>         $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)\)\)*,IS_ENABLED(CONFIG_$f),g;
>         $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
>         $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
> }
> print $data;
>
> Cc: Michael Krufky <mkrufky@linuxtv.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h | 3 +--
>  drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h | 3 +--
>  drivers/media/usb/dvb-usb/dibusb-common.c     | 3 +--
>  3 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
> index 432706a..40dd409 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
> @@ -31,8 +31,7 @@ struct mxl111sf_demod_config {
>                             struct mxl111sf_reg_ctrl_info *ctrl_reg_info);
>  };
>
> -#if defined(CONFIG_DVB_USB_MXL111SF) || \
> -       (defined(CONFIG_DVB_USB_MXL111SF_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_DVB_USB_MXL111SF)
>  extern
>  struct dvb_frontend *mxl111sf_demod_attach(struct mxl111sf_state *mxl_state,
>                                            struct mxl111sf_demod_config *cfg);
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
> index ff33396..634eee3 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
> @@ -60,8 +60,7 @@ struct mxl111sf_tuner_config {
>
>  /* ------------------------------------------------------------------------ */
>
> -#if defined(CONFIG_DVB_USB_MXL111SF) || \
> -       (defined(CONFIG_DVB_USB_MXL111SF_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_DVB_USB_MXL111SF)
>  extern
>  struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
>                                            struct mxl111sf_state *mxl_state,
> diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
> index af0d432..ecb9360 100644
> --- a/drivers/media/usb/dvb-usb/dibusb-common.c
> +++ b/drivers/media/usb/dvb-usb/dibusb-common.c
> @@ -232,8 +232,7 @@ static struct dibx000_agc_config dib3000p_panasonic_agc_config = {
>         .agc2_slope2 = 0x1e,
>  };
>
> -#if defined(CONFIG_DVB_DIB3000MC) ||                                   \
> -       (defined(CONFIG_DVB_DIB3000MC_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_DVB_DIB3000MC)
>
>  static struct dib3000mc_config mod3000p_dib3000p_config = {
>         &dib3000p_panasonic_agc_config,
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
