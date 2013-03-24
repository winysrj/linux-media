Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:49930 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3CXQqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 12:46:22 -0400
Received: by mail-vb0-f54.google.com with SMTP id p14so1167590vbm.13
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 09:46:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363894748-28000-2-git-send-email-mchehab@redhat.com>
References: <1363894748-28000-1-git-send-email-mchehab@redhat.com>
	<1363894748-28000-2-git-send-email-mchehab@redhat.com>
Date: Sun, 24 Mar 2013 12:46:21 -0400
Message-ID: <CAOcJUbzX4RnnvoUh+i-EKWLc3=bOck6Mqu38eYK62bYwC9K-ng@mail.gmail.com>
Subject: Re: [PATCH 2/4] [media] tuners: use IS_ENABLED
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>, Michael Buesch <m@bues.ch>,
	Hans-Frieder Vogt <hfvogt@gmx.net>
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
> Cc: Antti Palosaari <crope@iki.fi>
> Cc: Michael Buesch <m@bues.ch>
> Cc: Hans-Frieder Vogt <hfvogt@gmx.net>
> Cc: Michael Krufky <mkrufky@kernellabs.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/tuners/e4000.h    | 3 +--
>  drivers/media/tuners/fc0011.h   | 3 +--
>  drivers/media/tuners/fc0012.h   | 3 +--
>  drivers/media/tuners/fc0013.h   | 3 +--
>  drivers/media/tuners/fc2580.h   | 3 +--
>  drivers/media/tuners/max2165.h  | 3 +--
>  drivers/media/tuners/mc44s803.h | 3 +--
>  drivers/media/tuners/mxl5005s.h | 3 +--
>  drivers/media/tuners/tda18212.h | 3 +--
>  drivers/media/tuners/tda18218.h | 3 +--
>  drivers/media/tuners/tua9001.h  | 3 +--
>  drivers/media/tuners/xc5000.h   | 3 +--
>  12 files changed, 12 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
> index 71b1935..7801270 100644
> --- a/drivers/media/tuners/e4000.h
> +++ b/drivers/media/tuners/e4000.h
> @@ -36,8 +36,7 @@ struct e4000_config {
>         u32 clock;
>  };
>
> -#if defined(CONFIG_MEDIA_TUNER_E4000) || \
> -       (defined(CONFIG_MEDIA_TUNER_E4000_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_E4000)
>  extern struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
>                 struct i2c_adapter *i2c, const struct e4000_config *cfg);
>  #else
> diff --git a/drivers/media/tuners/fc0011.h b/drivers/media/tuners/fc0011.h
> index 0ee581f..33db6e4 100644
> --- a/drivers/media/tuners/fc0011.h
> +++ b/drivers/media/tuners/fc0011.h
> @@ -22,8 +22,7 @@ enum fc0011_fe_callback_commands {
>         FC0011_FE_CALLBACK_RESET,
>  };
>
> -#if defined(CONFIG_MEDIA_TUNER_FC0011) ||\
> -    defined(CONFIG_MEDIA_TUNER_FC0011_MODULE)
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC0011)
>  struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
>                                    struct i2c_adapter *i2c,
>                                    const struct fc0011_config *config);
> diff --git a/drivers/media/tuners/fc0012.h b/drivers/media/tuners/fc0012.h
> index 54508fc..668d70d 100644
> --- a/drivers/media/tuners/fc0012.h
> +++ b/drivers/media/tuners/fc0012.h
> @@ -48,8 +48,7 @@ struct fc0012_config {
>         bool clock_out;
>  };
>
> -#if defined(CONFIG_MEDIA_TUNER_FC0012) || \
> -       (defined(CONFIG_MEDIA_TUNER_FC0012_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC0012)
>  extern struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
>                                         struct i2c_adapter *i2c,
>                                         const struct fc0012_config *cfg);
> diff --git a/drivers/media/tuners/fc0013.h b/drivers/media/tuners/fc0013.h
> index 594efd6..34aa1c3 100644
> --- a/drivers/media/tuners/fc0013.h
> +++ b/drivers/media/tuners/fc0013.h
> @@ -25,8 +25,7 @@
>  #include "dvb_frontend.h"
>  #include "fc001x-common.h"
>
> -#if defined(CONFIG_MEDIA_TUNER_FC0013) || \
> -       (defined(CONFIG_MEDIA_TUNER_FC0013_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC0013)
>  extern struct dvb_frontend *fc0013_attach(struct dvb_frontend *fe,
>                                         struct i2c_adapter *i2c,
>                                         u8 i2c_address, int dual_master,
> diff --git a/drivers/media/tuners/fc2580.h b/drivers/media/tuners/fc2580.h
> index 222601e..2dbf91f 100644
> --- a/drivers/media/tuners/fc2580.h
> +++ b/drivers/media/tuners/fc2580.h
> @@ -36,8 +36,7 @@ struct fc2580_config {
>         u32 clock;
>  };
>
> -#if defined(CONFIG_MEDIA_TUNER_FC2580) || \
> -       (defined(CONFIG_MEDIA_TUNER_FC2580_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC2580)
>  extern struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
>         struct i2c_adapter *i2c, const struct fc2580_config *cfg);
>  #else
> diff --git a/drivers/media/tuners/max2165.h b/drivers/media/tuners/max2165.h
> index c063c36..531c79d 100644
> --- a/drivers/media/tuners/max2165.h
> +++ b/drivers/media/tuners/max2165.h
> @@ -30,8 +30,7 @@ struct max2165_config {
>         u8 osc_clk; /* in MHz, selectable values: 4,16,18,20,22,24,26,28 */
>  };
>
> -#if defined(CONFIG_MEDIA_TUNER_MAX2165) || \
> -    (defined(CONFIG_MEDIA_TUNER_MAX2165_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_MAX2165)
>  extern struct dvb_frontend *max2165_attach(struct dvb_frontend *fe,
>         struct i2c_adapter *i2c,
>         struct max2165_config *cfg);
> diff --git a/drivers/media/tuners/mc44s803.h b/drivers/media/tuners/mc44s803.h
> index 34f3892..cfaed1b 100644
> --- a/drivers/media/tuners/mc44s803.h
> +++ b/drivers/media/tuners/mc44s803.h
> @@ -30,8 +30,7 @@ struct mc44s803_config {
>         u8 dig_out;
>  };
>
> -#if defined(CONFIG_MEDIA_TUNER_MC44S803) || \
> -    (defined(CONFIG_MEDIA_TUNER_MC44S803_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_MC44S803)
>  extern struct dvb_frontend *mc44s803_attach(struct dvb_frontend *fe,
>          struct i2c_adapter *i2c, struct mc44s803_config *cfg);
>  #else
> diff --git a/drivers/media/tuners/mxl5005s.h b/drivers/media/tuners/mxl5005s.h
> index fc8a1ff..5b070e9 100644
> --- a/drivers/media/tuners/mxl5005s.h
> +++ b/drivers/media/tuners/mxl5005s.h
> @@ -116,8 +116,7 @@ struct mxl5005s_config {
>         u8 AgcMasterByte;
>  };
>
> -#if defined(CONFIG_MEDIA_TUNER_MXL5005S) || \
> -       (defined(CONFIG_MEDIA_TUNER_MXL5005S_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_MXL5005S)
>  extern struct dvb_frontend *mxl5005s_attach(struct dvb_frontend *fe,
>                                             struct i2c_adapter *i2c,
>                                             struct mxl5005s_config *config);
> diff --git a/drivers/media/tuners/tda18212.h b/drivers/media/tuners/tda18212.h
> index 9bd5da4..056636b 100644
> --- a/drivers/media/tuners/tda18212.h
> +++ b/drivers/media/tuners/tda18212.h
> @@ -36,8 +36,7 @@ struct tda18212_config {
>         u16 if_dvbc;
>  };
>
> -#if defined(CONFIG_MEDIA_TUNER_TDA18212) || \
> -       (defined(CONFIG_MEDIA_TUNER_TDA18212_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA18212)
>  extern struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
>         struct i2c_adapter *i2c, struct tda18212_config *cfg);
>  #else
> diff --git a/drivers/media/tuners/tda18218.h b/drivers/media/tuners/tda18218.h
> index b4180d1..4b81b9c 100644
> --- a/drivers/media/tuners/tda18218.h
> +++ b/drivers/media/tuners/tda18218.h
> @@ -29,8 +29,7 @@ struct tda18218_config {
>         u8 loop_through:1;
>  };
>
> -#if defined(CONFIG_MEDIA_TUNER_TDA18218) || \
> -       (defined(CONFIG_MEDIA_TUNER_TDA18218_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA18218)
>  extern struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
>         struct i2c_adapter *i2c, struct tda18218_config *cfg);
>  #else
> diff --git a/drivers/media/tuners/tua9001.h b/drivers/media/tuners/tua9001.h
> index cf5b815..d3faf29 100644
> --- a/drivers/media/tuners/tua9001.h
> +++ b/drivers/media/tuners/tua9001.h
> @@ -50,8 +50,7 @@ struct tua9001_config {
>  #define TUA9001_CMD_RESETN  1
>  #define TUA9001_CMD_RXEN    2
>
> -#if defined(CONFIG_MEDIA_TUNER_TUA9001) || \
> -       (defined(CONFIG_MEDIA_TUNER_TUA9001_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_TUA9001)
>  extern struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
>                 struct i2c_adapter *i2c, struct tua9001_config *cfg);
>  #else
> diff --git a/drivers/media/tuners/xc5000.h b/drivers/media/tuners/xc5000.h
> index b1a5474..bb1040b 100644
> --- a/drivers/media/tuners/xc5000.h
> +++ b/drivers/media/tuners/xc5000.h
> @@ -56,8 +56,7 @@ struct xc5000_config {
>   * it's passed back to a bridge during tuner_callback().
>   */
>
> -#if defined(CONFIG_MEDIA_TUNER_XC5000) || \
> -    (defined(CONFIG_MEDIA_TUNER_XC5000_MODULE) && defined(MODULE))
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_XC5000)
>  extern struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
>                                           struct i2c_adapter *i2c,
>                                           const struct xc5000_config *cfg);
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
