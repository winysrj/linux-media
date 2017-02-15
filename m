Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-1.rwth-aachen.de ([134.130.5.186]:40369 "EHLO
        mx-out-1.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755086AbdBOXbE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 18:31:04 -0500
From: Stefan Bruens <stefan.bruens@rwth-aachen.de>
To: Antti Palosaari <crope@iki.fi>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
Subject: Re: [PATCH v2 3/3] [media] dvbsky: MyGica T230C support
Date: Thu, 16 Feb 2017 00:31:01 +0100
Message-ID: <8751632.4KFmXH3LkI@pebbles.site>
In-Reply-To: <599879d5-7925-6013-f8bb-a42df69e3f30@iki.fi>
References: <20170215015122.4647-1-stefan.bruens@rwth-aachen.de> <884178a1fe9a4178a480b592e71820f7@rwthex-w2-b.rwth-ad.de> <599879d5-7925-6013-f8bb-a42df69e3f30@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

first thanks for for the review. Note the t230c_attach is mostly a copy of the 
t330_attach (which is very similar to the t680c_attach), so any of your 
comments should probably applied to the other attach functions to have a 
common coding style.

On Mittwoch, 15. Februar 2017 10:27:09 CET Antti Palosaari wrote:
> On 02/15/2017 03:51 AM, Stefan Brüns wrote:
[...]
> > diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c
> > b/drivers/media/usb/dvb-usb-v2/dvbsky.c index 02dbc6c45423..729496e5a52e
> > 100644
> > --- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
> > +++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> > @@ -665,6 +665,68 @@ static int dvbsky_t330_attach(struct dvb_usb_adapter
> > *adap)> 
> >  	return ret;
> >  
> >  }
> > 
> > +static int dvbsky_mygica_t230c_attach(struct dvb_usb_adapter *adap)
> > +{
> > +	struct dvbsky_state *state = adap_to_priv(adap);
> > +	struct dvb_usb_device *d = adap_to_d(adap);
> > +	int ret = 0;
> 
> you could return ret completely as you don't assign its value runtime

Sure, so something like:

  ...
  return 0;
fail_foo:
  xxx;
fail bar:
  yyy;
  return -ENODEV;

Some of the other attach functions assign ret = -ENODEV and then goto one of 
the fail_foo: labels.

 
> > +	struct i2c_adapter *i2c_adapter;
> > +	struct i2c_client *client_demod, *client_tuner;
> > +	struct i2c_board_info info;
> > +	struct si2168_config si2168_config;
> > +	struct si2157_config si2157_config;
> > +
> > +	/* attach demod */
> > +	memset(&si2168_config, 0, sizeof(si2168_config));
> 
> prefer sizeof dst

You mean sizeof(struct si2168_config) ?
 
> > +	si2168_config.i2c_adapter = &i2c_adapter;
> > +	si2168_config.fe = &adap->fe[0];
> > +	si2168_config.ts_mode = SI2168_TS_PARALLEL;
> > +	si2168_config.ts_clock_inv = 1;
> 
> it has boolean type

Sure
 
> > +	memset(&info, 0, sizeof(struct i2c_board_info));
> > +	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
> 
> I would prefer sizeof dst here too.

Most occurences of similar code in media/usb/ use I2C_NAME_SIZE, found two 
occurences of "strlcpy(buf, ..., sizeof(buf)), but of course I can change 
this.
 
> > +	info.addr = 0x64;
> > +	info.platform_data = &si2168_config;
> > +
> > +	request_module(info.type);
> 
> Use module name here. Even it is same than device id on that case, it is
> not always the case.

While si2157 driver has several supported chip types, si2168 only supports 
si2168 (several revisions). Both request_module("foobar") and 
request_module(info.type) are common in media/usb/. Change nevertheless?
 
> > +	client_demod = i2c_new_device(&d->i2c_adap, &info);
> > +	if (client_demod == NULL ||
> > +			client_demod->dev.driver == NULL)
> 
> You did not ran checkpatch.pl for that patch? or doesn't it complain
> anymore about these?

Checkpatch did not complain.
 
[...]
> > @@ -858,6 +946,9 @@ static const struct usb_device_id dvbsky_id_table[] =
> > {
> > 
> >  	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S2_R4,
> >  	
> >  		&dvbsky_s960_props, "Terratec Cinergy S2 Rev.4",
> >  		RC_MAP_DVBSKY) },
> > 
> > +	{ DVB_USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230C,
> > +		&mygica_t230c_props, "Mygica T230C DVB-T/T2/C",
> 
> Drop supported DTV standard names from device name. Also it is MyGica
> not Mygica.

The print on the stick says: "MyGica(R) DVB-T2", label on the backside says 
"T230C<serial number>". According to the USB descriptors it is a "Geniatech" 
"EyeTV Stick". According to the box it is a "MyGica(R)" "Mini DVB-T2 USB Stick 
T230C"

Would "MyGica DVB-T2 T230C" be ok?
 
Kind regards,

Stefan

-- 
Stefan Brüns  /  Bergstraße 21  /  52062 Aachen
home: +49 241 53809034     mobile: +49 151 50412019
work: +49 2405 49936-424
