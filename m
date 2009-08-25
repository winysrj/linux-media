Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:54393 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZHYQku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 12:40:50 -0400
Received: by ey-out-2122.google.com with SMTP id 25so809552eya.19
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2009 09:40:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090819160700.049985b5@glory.loctelecom.ru>
References: <20090819160700.049985b5@glory.loctelecom.ru>
Date: Tue, 25 Aug 2009 12:40:50 -0400
Message-ID: <37219a840908250940m3393f73ftbaa28639ca0f93cd@mail.gmail.com>
Subject: Re: tuner, code for discuss
From: Michael Krufky <mkrufky@kernellabs.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Dmitri,

We have a new mailing list for linux-media, please use this in the
future, cc added.

Apologies for my delayed reply -- I was out of town for some time.
Please see my comments below.

On Wed, Aug 19, 2009 at 2:07 AM, Dmitri Belimov<d.belimov@gmail.com> wrote:
> Hi All.
>
> Sorry my delay. I was busy with our new tuner, make PCB layout and other.
> Now I am free for write some code.
>
> This diff has new tuner definition.
> 1. By default charge pump is ON
> 2. For radio mode charge pump set to OFF
> 3. Set correct AGC value in radio mode
> 4. Add control gain of AGC.
> 5. New function simple_get_tv_gain and simple_set_tv_gain for read/write gain of AGC.
> 6. Add some code for control gain from saa7134 part. By default this control is OFF
> 7. When TV card can manipulate this control, enable it.
>
> I don't understand how to correct call new function for read/write value of AGC TOP.
>
> What you think about it??
>
> With my best regards, Dmitry.

Dmitry,

In general, this patch is fine, but it needs a little more work before
we move forward with it.

First off, for the patch hunk that writes the AUX byte, there is
already a better mechanism in place for this.  Please take a look at
the .initdata and .sleepdata components of struct tunertype -- thanks
to Trent Piepho for this innovation, this is a more efficient way to
handle the Auxiliary byte, and it is already used on various tuners.
See the various TUA603x implementations for examples.
(TUNER_THOMSON_DTT761X, TUNER_PHILIPS_FMD1216ME_MK3,
TUNER_LG_TDVS_H06XF, TUNER_PHILIPS_FMD1216MEX_MK3)  If you need some
better explanation on how to use these fields, please mention so. You
probably don't need to use the .sleepdata field, but the .initdata
field is the right place for this.

As for the set / get gain functionality, can you give us some detail
as to where and when it would be appropriate to call those functions?
Under which conditions would you change this setting?  Will these
functions only be used internally by the tuning subsystem, or is there
any need to expose them to userspace?  If they do need to be exposed
to userspace, a higher level of explanation will be needed.

Thanks for the patch, I am interested to see more details.

Regards,

Mike Krufky

> diff -r 3f7e382dfae5 linux/drivers/media/common/tuners/tuner-simple.c
> --- a/linux/drivers/media/common/tuners/tuner-simple.c  Sun Aug 16 21:53:17 2009 -0300
> +++ b/linux/drivers/media/common/tuners/tuner-simple.c  Wed Aug 19 10:54:07 2009 +1000
> @@ -116,6 +116,7 @@
>
>        u32 frequency;
>        u32 bandwidth;
> +       signed int gain;
>  };
>
>  /* ---------------------------------------------------------------------- */
> @@ -144,6 +145,7 @@
>        case TUNER_PHILIPS_FM1256_IH3:
>        case TUNER_LG_NTSC_TAPE:
>        case TUNER_TCL_MF02GIP_5N:
> +       case TUNER_TCL_MFPE05_2:
>                return ((status & TUNER_SIGNAL) == TUNER_STEREO_MK3);
>        default:
>                return status & TUNER_STEREO;
> @@ -491,6 +493,39 @@
>                                   "(should be 4)\n", rc);
>                break;
>        }
> +       case TUNER_TCL_MFPE05_2:
> +               {
> +               u8 tgain;
> +
> +               printk("posttune TCL_MFPE05_2\r\n");
> +               tgain = 0x20;           /* TOP = 112 dB, ATC = OFF */
> +
> +               switch ( priv->gain )
> +               {
> +               case 0:
> +                       tgain = 0x60;   /* TOP = External AGC, ATC = OFF */
> +                       break;
> +               case 1:
> +                       tgain = 0x00;   /* TOP = 118 dB, ATC = OFF */
> +                       break;
> +               case 2:
> +                       tgain = 0x10;   /* TOP = 115 dB, ATC = OFF */
> +                       break;
> +               case 4:
> +                       tgain = 0x30;   /* TOP = 109 dB, ATC = OFF */
> +                       break;
> +               case 5:
> +                       tgain = 0x40;   /* TOP = 106 dB, ATC = OFF */
> +                       break;
> +               case 6:
> +                       tgain = 0x50;   /* TOP = 103 dB, ATC = OFF */
> +                       break;
> +               }
> +
> +               simple_set_aux_byte(fe, config, tgain);
> +
> +               break;
> +               }
>        }
>
>        return 0;
> @@ -499,6 +534,7 @@
>  static int simple_radio_bandswitch(struct dvb_frontend *fe, u8 *buffer)
>  {
>        struct tuner_simple_priv *priv = fe->tuner_priv;
> +       u8 rc;
>
>        switch (priv->type) {
>        case TUNER_TENA_9533_DI:
> @@ -513,6 +549,11 @@
>        case TUNER_LG_NTSC_TAPE:
>        case TUNER_PHILIPS_FM1256_IH3:
>        case TUNER_TCL_MF02GIP_5N:
> +               buffer[3] = 0x19;
> +               break;
> +       case TUNER_TCL_MFPE05_2:
> +               rc = buffer[2]&0xbf;
> +               buffer[2] = rc;         /* Switch OFF Charge Pump */
>                buffer[3] = 0x19;
>                break;
>        case TUNER_TNF_5335MF:
> @@ -753,6 +794,42 @@
>        rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 4);
>        if (4 != rc)
>                tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
> +
> +       /* Write AUX byte */
> +       switch (priv->type) {
> +       case TUNER_TCL_MFPE05_2:
> +       printk("write AUX byte\n");
> +               simple_set_aux_byte(fe, 0x98, 0x20);
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +static int simple_set_tv_gain(struct dvb_frontend *fe,
> +                             u8 tvgain)
> +{
> +       struct tuner_simple_priv *priv = fe->tuner_priv;
> +
> +       switch (priv->type) {
> +       case TUNER_TCL_MFPE05_2:
> +               priv->gain = tvgain;
> +               break;
> +       } /* switch (priv->type) */
> +
> +       return 0;
> +}
> +
> +static int simple_get_tv_gain(struct dvb_frontend *fe,
> +                             u8 *tvgain)
> +{
> +       struct tuner_simple_priv *priv = fe->tuner_priv;
> +
> +       switch (priv->type) {
> +       case TUNER_TCL_MFPE05_2:
> +               *tvgain = priv->gain;
> +               break;
> +       } /* switch (priv->type) */
>
>        return 0;
>  }
> diff -r 3f7e382dfae5 linux/drivers/media/common/tuners/tuner-types.c
> --- a/linux/drivers/media/common/tuners/tuner-types.c   Sun Aug 16 21:53:17 2009 -0300
> +++ b/linux/drivers/media/common/tuners/tuner-types.c   Wed Aug 19 10:54:07 2009 +1000
> @@ -1321,6 +1321,31 @@
>        },
>  };
>
> +/* ------------ TUNER_TCL_MFPE05_2 - TCL MFPE05-2 ALL ------------ */
> +
> +static struct tuner_range tuner_tcl_mfpe05_2_all_ranges[] = {
> +       { 16 * 158.00 /*MHz*/, 0xc6, 0x01, },
> +       { 16 * 441.00 /*MHz*/, 0xc6, 0x02, },
> +       { 16 * 864.00        , 0xc6, 0x04, },
> +};
> +
> +static struct tuner_params tuner_tcl_mfpe05_2_all_params[] = {
> +       {
> +               .type   = TUNER_PARAM_TYPE_PAL,
> +               .ranges = tuner_tcl_mfpe05_2_all_ranges,
> +               .count  = ARRAY_SIZE(tuner_tcl_mfpe05_2_all_ranges),
> +               .cb_first_if_lower_freq = 1,
> +               .has_tda9887 = 1,
> +               .port1_active = 1,
> +               .port2_active = 1,
> +               .port2_invert_for_secam_lc = 1,
> +               .port1_fm_high_sensitivity = 1,
> +               .default_top_mid = -2,
> +               .default_top_secam_mid = -2,
> +               .default_top_secam_high = -2,
> +       },
> +};
> +
>  /* --------------------------------------------------------------------- */
>
>  struct tunertype tuners[] = {
> @@ -1779,6 +1804,12 @@
>                .params = tuner_partsnic_pti_5nf05_params,
>                .count  = ARRAY_SIZE(tuner_partsnic_pti_5nf05_params),
>        },
> +
> +       [TUNER_TCL_MFPE05_2] = { /* TCL ALL */
> +               .name   = "TCL MFPE05-2 MK3 PAL/SECAM multi (Beholder Lab)",
> +               .params = tuner_tcl_mfpe05_2_all_params,
> +               .count  = ARRAY_SIZE(tuner_tcl_mfpe05_2_all_params),
> +       },
>  };
>  EXPORT_SYMBOL(tuners);
>
> diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Sun Aug 16 21:53:17 2009 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Wed Aug 19 10:54:07 2009 +1000
> @@ -4500,7 +4500,7 @@
>                /* Alexey Osipov <lion-simba@pridelands.ru> */
>                .name           = "Beholder BeholdTV M6",
>                .audio_clock    = 0x00187de7,
> -               .tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
> +               .tuner_type     = TUNER_TCL_MFPE05_2,
>                .radio_type     = UNSET,
>                .tuner_addr     = ADDR_UNSET,
>                .radio_addr     = ADDR_UNSET,
> @@ -4537,7 +4537,7 @@
>                /* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
>                .name           = "Beholder BeholdTV M63",
>                .audio_clock    = 0x00187de7,
> -               .tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
> +               .tuner_type     = TUNER_TCL_MFPE05_2,
>                .radio_type     = UNSET,
>                .tuner_addr     = ADDR_UNSET,
>                .radio_addr     = ADDR_UNSET,
> @@ -7099,6 +7099,18 @@
>                }
>                break;
>        }
> +       case SAA7134_BOARD_BEHOLD_M6:
> +       case SAA7134_BOARD_BEHOLD_M63:
> +       {
> +               struct v4l2_queryctrl* ctl;
> +               struct saa7134_fh *fh;
> +               struct file *fl;
> +
> +               ctl->id = V4L2_CID_GAIN;
> +               if (saa7134_queryctrl(fl,fh,ctl)==0){
> +                       ctl->flags &= ~(V4L2_CTRL_FLAG_DISABLED); /* enable this control */
> +               }
> +       }
>        } /* switch() */
>
>        /* initialize tuner */
> diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134-video.c
> --- a/linux/drivers/media/video/saa7134/saa7134-video.c Sun Aug 16 21:53:17 2009 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134-video.c Wed Aug 19 10:54:07 2009 +1000
> @@ -413,6 +413,15 @@
>                .step          = 1,
>                .default_value = 0,
>                .type          = V4L2_CTRL_TYPE_INTEGER,
> +       },{
> +               .id             = V4L2_CID_GAIN,
> +               .name           = "Gain",
> +               .minimum        = 0,
> +               .maximum        = 6,
> +               .step           = 1,
> +               .default_value  = 3,
> +               .type           = V4L2_CTRL_TYPE_INTEGER,
> +               .flags          = V4L2_CTRL_FLAG_DISABLED,
>        },{
>                .id            = V4L2_CID_HFLIP,
>                .name          = "Mirror",
> @@ -1128,6 +1137,9 @@
>        case V4L2_CID_HUE:
>                c->value = dev->ctl_hue;
>                break;
> +       case V4L2_CID_GAIN:
> +               c->value = dev->ctl_gain;
> +               break;
>        case V4L2_CID_CONTRAST:
>                c->value = dev->ctl_contrast;
>                break;
> @@ -1214,6 +1226,9 @@
>                dev->ctl_hue = c->value;
>                saa_writeb(SAA7134_DEC_CHROMA_HUE, dev->ctl_hue);
>                break;
> +       case V4L2_CID_GAIN:
> +               dev->ctl_gain = c->value;
> +               break;
>        case V4L2_CID_CONTRAST:
>                dev->ctl_contrast = c->value;
>                saa_writeb(SAA7134_DEC_LUMA_CONTRAST,
> @@ -2534,6 +2549,7 @@
>        dev->ctl_bright     = ctrl_by_id(V4L2_CID_BRIGHTNESS)->default_value;
>        dev->ctl_contrast   = ctrl_by_id(V4L2_CID_CONTRAST)->default_value;
>        dev->ctl_hue        = ctrl_by_id(V4L2_CID_HUE)->default_value;
> +       dev->ctl_gain       = ctrl_by_id(V4L2_CID_GAIN)->default_value;
>        dev->ctl_saturation = ctrl_by_id(V4L2_CID_SATURATION)->default_value;
>        dev->ctl_volume     = ctrl_by_id(V4L2_CID_AUDIO_VOLUME)->default_value;
>        dev->ctl_mute       = 1; // ctrl_by_id(V4L2_CID_AUDIO_MUTE)->default_value;
> diff -r 3f7e382dfae5 linux/drivers/media/video/saa7134/saa7134.h
> --- a/linux/drivers/media/video/saa7134/saa7134.h       Sun Aug 16 21:53:17 2009 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134.h       Wed Aug 19 10:54:07 2009 +1000
> @@ -565,6 +565,7 @@
>        int                        ctl_bright;
>        int                        ctl_contrast;
>        int                        ctl_hue;
> +       int                        ctl_gain;             /* gain */
>        int                        ctl_saturation;
>        int                        ctl_freq;
>        int                        ctl_mute;             /* audio */
> diff -r 3f7e382dfae5 linux/include/media/tuner.h
> --- a/linux/include/media/tuner.h       Sun Aug 16 21:53:17 2009 -0300
> +++ b/linux/include/media/tuner.h       Wed Aug 19 10:54:07 2009 +1000
> @@ -127,6 +127,7 @@
>  #define TUNER_PHILIPS_FM1216MK5                79
>  #define TUNER_PHILIPS_FQ1216LME_MK3    80      /* Active loopthrough, no FM */
>  #define TUNER_PARTSNIC_PTI_5NF05       81
> +#define TUNER_TCL_MFPE05_2             82      /*TCL clone of the Philips FM1216ME_MK3*/
>
>  /* tv card specific */
>  #define TDA9887_PRESENT                (1<<0)
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
