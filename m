Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47006 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZIBDXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 23:23:50 -0400
Received: by ewy2 with SMTP id 2so417521ewy.17
        for <linux-media@vger.kernel.org>; Tue, 01 Sep 2009 20:23:51 -0700 (PDT)
Date: Wed, 2 Sep 2009 13:24:01 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH] Add FM radio for the XC5000
Message-ID: <20090902132401.47d809b7@glory.loctelecom.ru>
In-Reply-To: <829197380909011853i4ca0445btf7ecd2fab8738dee@mail.gmail.com>
References: <20090902113705.168af9f0@glory.loctelecom.ru>
	<829197380909011853i4ca0445btf7ecd2fab8738dee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin

Yes I agree. Not so good way. I was send because didn't recieved any reply from Steven Toth.
Main reason do FM radio working right now.

I think you can do next step for writing this workaround and make patch for it. 
I'll write config and make some tests for our card.

With my best regards, Dmitry.

> On Tue, Sep 1, 2009 at 9:37 PM, Dmitri Belimov<d.belimov@gmail.com>
> wrote:
> > Hi All
> >
> > Add FM radio for the xc5000 silicon tuner chip.
> >
> > diff -r 28f8b0ebd224 linux/drivers/media/common/tuners/xc5000.c
> > --- a/linux/drivers/media/common/tuners/xc5000.c        Sun Aug 23
> > 13:55:25 2009 -0300 +++
> > b/linux/drivers/media/common/tuners/xc5000.c        Wed Sep 02
> > 06:32:12 2009 +1000 @@ -747,14 +747,11 @@ return ret;
> >  }
> >
> > -static int xc5000_set_analog_params(struct dvb_frontend *fe,
> > +static int xc5000_set_tv_freq(struct dvb_frontend *fe,
> >        struct analog_parameters *params)
> >  {
> >        struct xc5000_priv *priv = fe->tuner_priv;
> >        int ret;
> > -
> > -       if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS)
> > -               xc_load_fw_and_init_tuner(fe);
> >
> >        dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
> >                __func__, params->frequency);
> > @@ -834,6 +831,67 @@
> >
> >        return 0;
> >  }
> > +
> > +static int xc5000_set_radio_freq(struct dvb_frontend *fe,
> > +       struct analog_parameters *params)
> > +{
> > +       struct xc5000_priv *priv = fe->tuner_priv;
> > +       int ret = -EINVAL;
> > +
> > +       dprintk(1, "%s() frequency=%d (in units of khz)\n",
> > +               __func__, params->frequency);
> > +
> > +       priv->freq_hz = params->frequency * 125 / 2;
> > +
> > +       priv->rf_mode = XC_RF_MODE_AIR;
> > +
> > +       ret = xc_SetTVStandard(priv,
> > +               XC5000_Standard[FM_Radio_INPUT1].VideoMode,
> > +               XC5000_Standard[FM_Radio_INPUT1].AudioMode);
> > +
> > +       if (ret != XC_RESULT_SUCCESS) {
> > +               printk(KERN_ERR "xc5000: xc_SetTVStandard
> > failed\n");
> > +               return -EREMOTEIO;
> > +       }
> > +
> > +       ret = xc_SetSignalSource(priv, priv->rf_mode);
> > +       if (ret != XC_RESULT_SUCCESS) {
> > +               printk(KERN_ERR
> > +                       "xc5000: xc_SetSignalSource(%d) failed\n",
> > +                       priv->rf_mode);
> > +               return -EREMOTEIO;
> > +       }
> > +
> > +       xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
> > +
> > +       return 0;
> > +}
> > +
> > +static int xc5000_set_analog_params(struct dvb_frontend *fe,
> > +                            struct analog_parameters *params)
> > +{
> > +       struct xc5000_priv *priv = fe->tuner_priv;
> > +       int ret = -EINVAL;
> > +
> > +       if (priv->i2c_props.adap == NULL)
> > +               return -EINVAL;
> > +
> > +       if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS)
> > +               xc_load_fw_and_init_tuner(fe);
> > +
> > +       switch (params->mode) {
> > +       case V4L2_TUNER_RADIO:
> > +               ret = xc5000_set_radio_freq(fe, params);
> > +               break;
> > +       case V4L2_TUNER_ANALOG_TV:
> > +       case V4L2_TUNER_DIGITAL_TV:
> > +               ret = xc5000_set_tv_freq(fe, params);
> > +               break;
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> >
> >  static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
> >  {
> >
> > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov
> > <d.belimov@gmail.com>
> >
> > With my best regards, Dmitry.
> 
> Hello Dmitri,
> 
> A few comments;
> 
> I don't think the code should have FM1 hard-coded as the only valid
> input.  You should probably add a parameter to the xc500_config struct
> to specify which FM input to use (so the person defining the board
> profile can define which input is appropriate).
> 
> Does the signal lock register actually work for FM?  I assume it does,
> but I'm not sure.
> 
> Also, I would probably have him move the setting of priv->rf_mode
> further down in the function.  That way it the xc5000_priv struct
> won't get out of sync with the actual state of the device if the call
> to xc_SetTVStandard() fails.
> 
> Other than those two things though it looks ok at first glance.
> 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
