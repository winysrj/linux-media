Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab2CJQkr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 11:40:47 -0500
Message-ID: <4F5B8401.3030701@redhat.com>
Date: Sat, 10 Mar 2012 13:40:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eduard Bloch <edi@gmx.de>
CC: Jonathan Nieder <jrnieder@gmail.com>, linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: Re: [RFC/PATCH] New Terratec DVB USB IDs, symbolic names in az6027_usb_table
References: <20111222215356.GA4499@rotes76.wohnheim.uni-kl.de> <20111222234446.GB10497@elie.Belkin> <20120310160423.GA6106@rotes76.wohnheim.uni-kl.de>
In-Reply-To: <20120310160423.GA6106@rotes76.wohnheim.uni-kl.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-03-2012 13:04, Eduard Bloch escreveu:
> Hello Jonathan, hello LinuxTV,
> * Jonathan Nieder [Thu, Dec 22 2011, 05:44:46PM]:
> 
>> > Eduard, meet the LinuxTV project.  linux-media folks, meet Eduard.
>> > Patch follows.
> Hello guys and sorry for the delay.
> 
>> > Eduard: may we have your sign-off?  Please see
>> > Documentation/SubmittingPatches, section 12 "Sign your work" for what
>> > this means.
> Originally I hesitated to consider this changes trivial enough,

Well, trivial or not, someone has to do the patch ;)

> but
> after adopting/rewriting many parts of it, I think we can go along with
> that. I also modified az6027.c to the symbolic name structure suggested
> by Jonathan for dw2102.c which is AFAICS already accepted in mainline
> kernel.

Please, don't mix different logical changes on the same patch. If you have
more than one change to do, send it as a patch set.

> Btw, there is a little potential flaw with symbolic names: an array
> entry without position id impilicitly goes to the position after the
> last used symbolic name, which might overwrite data on another position
> instead of adding it where it's supposed to be (like null terminator in
> our case). In dw2102.c that didn't matter yet because the order of enum
> entries matches the device id array order, but for az6027.c I added a
> max-value enum entry and used the reference for the null terminator.
> 
> IMO it's subject for discussion whether this is needed/allowed/acceptable.
> 
> And there is another fix from LKML for a regression affecting several
> drivers including dw2102, and AFAICS it is not fixed neither in
> linux-3.3-rc* nor in linux-media branch yet.
> 
> Regards,
> Eduard.
> 
> 
> az6027-C99-init-and-Terratec-device-ids.patch
> 
> 
>>From 650ff9ccd82ef11a4b87feaff9c619e562ab898a Mon Sep 17 00:00:00 2001
> From: Eduard Bloch <blade@debian.org>
> Date: Sat, 10 Mar 2012 16:13:51 +0100
> Subject: [PATCH] Squashed commit of the following:
> 
> az6027.c: Use C99 style array initialization with position identifiers
> az6027.c: Added USB ID of latest TERRATEC S7 revision
> dw2102.c: Added USB ID of latest TERRATEC Cinergy S2 USB HD
> dvb_frontend.c: From LKML, Signed-off-by: Simon Arlott <simon@fire.lp0.eu>,
>   fixes regression from 7e0722215a510921cbb73ab4c37477d4dcb91bf8
> Signed-off-by: Eduard Bloch <blade@debian.org>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |    2 +
>  drivers/media/dvb/dvb-usb/az6027.c        |   45 ++++++++++++++++++++---------
>  drivers/media/dvb/dvb-usb/dvb-usb-ids.h   |    1 +
>  drivers/media/dvb/dvb-usb/dw2102.c        |   16 +++++++++-
>  4 files changed, 49 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index fbbe545..4555baa 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -655,6 +655,8 @@ restart:
>  					dprintk("%s: Retune requested, FESTATE_RETUNE\n", __func__);
>  					re_tune = true;
>  					fepriv->state = FESTATE_TUNED;
> +				} else {
> +					re_tune = false;
>  				}

This were fixed on another patch. I think that the patch is already upstream.

>  
>  				if (fe->ops.tune)
> diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
> index 5e45ae6..eee669c 100644
> --- a/drivers/media/dvb/dvb-usb/az6027.c
> +++ b/drivers/media/dvb/dvb-usb/az6027.c
> @@ -1079,15 +1079,28 @@ int az6027_identify_state(struct usb_device *udev,
>  	return 0;
>  }
>  
> +enum az6027_table_entry {
> +	AZUREWAVE_AZ6027,
> +	ELGATO_EYETV_SAT,
> +	TECHNISAT_USB2_HDCI_V1,
> +	TECHNISAT_USB2_HDCI_V2,
> +	TERRATEC_DVBS2CI_V1,
> +	TERRATEC_DVBS2CI_V2,
> +	TERRATEC_DVBS2CI_V3,
> +
> +	az6027_table_entry_enum_max

Please use uppercases on the above.

> +};
>  
>  static struct usb_device_id az6027_usb_table[] = {
> -	{ USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_AZ6027) },
> -	{ USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V1) },
> -	{ USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V2) },
> -	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V1) },
> -	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V2) },
> -	{ USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT) },
> -	{ },
> +	[AZUREWAVE_AZ6027] = { USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_AZ6027) },
> +	[ELGATO_EYETV_SAT] = { USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT) },
> +	[TECHNISAT_USB2_HDCI_V1] = { USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V1) },
> +	[TECHNISAT_USB2_HDCI_V2] = { USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V2) },
> +	[TERRATEC_DVBS2CI_V1] = { USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V1) },
> +	[TERRATEC_DVBS2CI_V2] = { USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V2) },
> +	[TERRATEC_DVBS2CI_V3] = { USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V3) },
> +
> +	[az6027_table_entry_enum_max] = { 0 }
>  };
>  
>  MODULE_DEVICE_TABLE(usb, az6027_usb_table);
> @@ -1135,31 +1148,35 @@ static struct dvb_usb_device_properties az6027_properties = {
>  
>  	.i2c_algo         = &az6027_i2c_algo,
>  
> -	.num_device_descs = 6,
> +	.num_device_descs = 7,
>  	.devices = {
>  		{
>  			.name = "AZUREWAVE DVB-S/S2 USB2.0 (AZ6027)",
> -			.cold_ids = { &az6027_usb_table[0], NULL },
> +			.cold_ids = { &az6027_usb_table[AZUREWAVE_AZ6027], NULL },
>  			.warm_ids = { NULL },
>  		}, {
>  			.name = "TERRATEC S7",
> -			.cold_ids = { &az6027_usb_table[1], NULL },
> +			.cold_ids = { &az6027_usb_table[TERRATEC_DVBS2CI_V1], NULL },
>  			.warm_ids = { NULL },
>  		}, {
>  			.name = "TERRATEC S7 MKII",
> -			.cold_ids = { &az6027_usb_table[2], NULL },
> +			.cold_ids = { &az6027_usb_table[TERRATEC_DVBS2CI_V2], NULL },
>  			.warm_ids = { NULL },
>  		}, {
>  			.name = "Technisat SkyStar USB 2 HD CI",
> -			.cold_ids = { &az6027_usb_table[3], NULL },
> +			.cold_ids = { &az6027_usb_table[TECHNISAT_USB2_HDCI_V1], NULL },
>  			.warm_ids = { NULL },
>  		}, {
>  			.name = "Technisat SkyStar USB 2 HD CI",
> -			.cold_ids = { &az6027_usb_table[4], NULL },
> +			.cold_ids = { &az6027_usb_table[TECHNISAT_USB2_HDCI_V2], NULL },
>  			.warm_ids = { NULL },
>  		}, {
>  			.name = "Elgato EyeTV Sat",
> -			.cold_ids = { &az6027_usb_table[5], NULL },
> +			.cold_ids = { &az6027_usb_table[ELGATO_EYETV_SAT], NULL },
> +			.warm_ids = { NULL },
> +		}, {
> +			.name = "TERRATEC S7 Rev.3",
> +			.cold_ids = { &az6027_usb_table[TERRATEC_DVBS2CI_V3], NULL },
>  			.warm_ids = { NULL },
>  		},
>  		{ NULL },
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> index d390dda..55cac30 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> @@ -331,6 +331,7 @@
>  #define USB_PID_AZUREWAVE_AZ6027			0x3275
>  #define USB_PID_TERRATEC_DVBS2CI_V1			0x10a4
>  #define USB_PID_TERRATEC_DVBS2CI_V2			0x10ac
> +#define USB_PID_TERRATEC_DVBS2CI_V3			0x10b0
>  #define USB_PID_TECHNISAT_USB2_HDCI_V1			0x0001
>  #define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002
>  #define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2		0x0004


Ideally, the above should be on two separate patches, one adding the new USB IDs and
the other one converting the structure to use the new way. That makes easier for reviewers
to see what changed on each patch.

> diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
> index 451c5a7..87fcb7b 100644
> --- a/drivers/media/dvb/dvb-usb/dw2102.c
> +++ b/drivers/media/dvb/dvb-usb/dw2102.c
> @@ -1181,6 +1181,14 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
>  {
>  	u8 obuf[3] = { 0xe, 0x80, 0 };
>  	u8 ibuf[] = { 0 };
> +	
> +	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +
> +	//power on su3000

Don't use // comments. Did you ran scripts/checkpatch.pl? It should have warned you
that the above syntax is not allowed.

> +	obuf[0] = 0xe;
> +	obuf[1] = 0x02;
> +	obuf[2] = 1;
>  
>  	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
>  		err("command 0x0e transfer failed.");

The above code is a separate patch. Btw, for each patch, you should add a description
saying why the change is needed.

> @@ -1448,6 +1456,7 @@ enum dw2102_table_entry {
>  	PROF_7500,
>  	GENIATECH_SU3000,
>  	TERRATEC_CINERGY_S2,
> +	TERRATEC_CINERGY_S2rev2,
>  	TEVII_S480_1,
>  	TEVII_S480_2,
>  	X3M_SPC1400HD,
> @@ -1466,6 +1475,7 @@ static struct usb_device_id dw2102_table[] = {
>  	[PROF_7500] = {USB_DEVICE(0x3034, 0x7500)},
>  	[GENIATECH_SU3000] = {USB_DEVICE(0x1f4d, 0x3000)},
>  	[TERRATEC_CINERGY_S2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00a8)},
> +	[TERRATEC_CINERGY_S2rev2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00b0)},
>  	[TEVII_S480_1] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_1)},
>  	[TEVII_S480_2] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_2)},
>  	[X3M_SPC1400HD] = {USB_DEVICE(0x1f4d, 0x3100)},
> @@ -1857,7 +1867,7 @@ static struct dvb_usb_device_properties su3000_properties = {
>  		}},
>  		}
>  	},
> -	.num_device_descs = 3,
> +	.num_device_descs = 4,
>  	.devices = {
>  		{ "SU3000HD DVB-S USB2.0",
>  			{ &dw2102_table[GENIATECH_SU3000], NULL },
> @@ -1871,6 +1881,10 @@ static struct dvb_usb_device_properties su3000_properties = {
>  			{ &dw2102_table[X3M_SPC1400HD], NULL },
>  			{ NULL },
>  		},
> +		{ "Terratec Cinergy S2 USB HD Rev.2",
> +			{ &dw2102_table[TERRATEC_CINERGY_S2rev2], NULL },
> +			{ NULL },
> +		},
>  	}
>  };

This should be a separate patchset as well, as it adds support for a new device variant.

Regards,
Mauro
