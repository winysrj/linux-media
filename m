Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep22.mx.upcmail.net ([62.179.121.42]:42182 "EHLO
	fep22.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab3K0XId (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 18:08:33 -0500
Received: from edge03.upcmail.net ([192.168.13.238])
          by viefep22-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20131127230830.DWC1568.viefep22-int.chello.at@edge03.upcmail.net>
          for <linux-media@vger.kernel.org>;
          Thu, 28 Nov 2013 00:08:30 +0100
Message-ID: <52967B6D.6010407@hispeed.ch>
Date: Thu, 28 Nov 2013 00:08:29 +0100
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] az6007: support Technisat Cablestar Combo HDCI
 (minus remote)
References: <1383421772-28243-1-git-send-email-rscheidegger_lists@hispeed.ch>
In-Reply-To: <1383421772-28243-1-git-send-email-rscheidegger_lists@hispeed.ch>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any chances this could get applied?

Thanks,

Roland

Am 02.11.2013 20:49, schrieb linux-media-owner@vger.kernel.org:
> This is similar to the Terratec H7. It works with the same az6007 firmware as
> the former, however the drx-k firmware of the H7 will NOT work. Hence use
> a different firmware name. The firmware does not need to exist as the one in
> the eeprom is just fine as long as the h7 one doesn't get loaded, but maybe
> some day someone wants to load it (the one from the h5 would work too).
> Also since the config entry is now different anyway disable support for rc.
> AFAIK the Technisat remote (TS35) is RC5 and the code (which a code comment
> claims doesn't work anyway) only would handle NEC hence it's pointless creating
> a device and polling it if we already know it can't work.
> CI is untested.
> Originally based on idea found on
> http://www.linuxtv.org/wiki/index.php/TechniSat_CableStar_Combo_HD_CI claiming
> only id needs to be added (but failed to mention it only worked because the
> driver couldn't find the h7 drx-k firmware...).
> 
> Signed-off-by: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
> ---
>  drivers/media/dvb-core/dvb-usb-ids.h  |  1 +
>  drivers/media/usb/dvb-usb-v2/az6007.c | 59 +++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index 419a2d6..4a53454 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -365,6 +365,7 @@
>  #define USB_PID_TERRATEC_DVBS2CI_V2			0x10ac
>  #define USB_PID_TECHNISAT_USB2_HDCI_V1			0x0001
>  #define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002
> +#define USB_PID_TECHNISAT_USB2_CABLESTAR_HDCI		0x0003
>  #define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2		0x0004
>  #define USB_PID_TECHNISAT_USB2_DVB_S2			0x0500
>  #define USB_PID_CPYTO_REDI_PC50A			0xa803
> diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
> index 44c64ef3..c1051c3 100644
> --- a/drivers/media/usb/dvb-usb-v2/az6007.c
> +++ b/drivers/media/usb/dvb-usb-v2/az6007.c
> @@ -68,6 +68,19 @@ static struct drxk_config terratec_h7_drxk = {
>  	.microcode_name = "dvb-usb-terratec-h7-drxk.fw",
>  };
>  
> +static struct drxk_config cablestar_hdci_drxk = {
> +	.adr = 0x29,
> +	.parallel_ts = true,
> +	.dynamic_clk = true,
> +	.single_master = true,
> +	.enable_merr_cfg = true,
> +	.no_i2c_bridge = false,
> +	.chunk_size = 64,
> +	.mpeg_out_clk_strength = 0x02,
> +	.qam_demod_parameter_count = 2,
> +	.microcode_name = "dvb-usb-technisat-cablestar-hdci-drxk.fw",
> +};
> +
>  static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
>  {
>  	struct az6007_device_state *st = fe_to_priv(fe);
> @@ -630,6 +643,27 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
>  	return 0;
>  }
>  
> +static int az6007_cablestar_hdci_frontend_attach(struct dvb_usb_adapter *adap)
> +{
> +	struct az6007_device_state *st = adap_to_priv(adap);
> +	struct dvb_usb_device *d = adap_to_d(adap);
> +
> +	pr_debug("attaching demod drxk\n");
> +
> +	adap->fe[0] = dvb_attach(drxk_attach, &cablestar_hdci_drxk,
> +				 &d->i2c_adap);
> +	if (!adap->fe[0])
> +		return -EINVAL;
> +
> +	adap->fe[0]->sec_priv = adap;
> +	st->gate_ctrl = adap->fe[0]->ops.i2c_gate_ctrl;
> +	adap->fe[0]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
> +
> +	az6007_ci_init(adap);
> +
> +	return 0;
> +}
> +
>  static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
>  {
>  	struct dvb_usb_device *d = adap_to_d(adap);
> @@ -868,6 +902,29 @@ static struct dvb_usb_device_properties az6007_props = {
>  	}
>  };
>  
> +static struct dvb_usb_device_properties az6007_cablestar_hdci_props = {
> +	.driver_name         = KBUILD_MODNAME,
> +	.owner               = THIS_MODULE,
> +	.firmware            = AZ6007_FIRMWARE,
> +
> +	.adapter_nr          = adapter_nr,
> +	.size_of_priv        = sizeof(struct az6007_device_state),
> +	.i2c_algo            = &az6007_i2c_algo,
> +	.tuner_attach        = az6007_tuner_attach,
> +	.frontend_attach     = az6007_cablestar_hdci_frontend_attach,
> +	.streaming_ctrl      = az6007_streaming_ctrl,
> +/* ditch get_rc_config as it can't work (TS35 remote, I believe it's rc5) */
> +	.get_rc_config       = NULL,
> +	.read_mac_address    = az6007_read_mac_addr,
> +	.download_firmware   = az6007_download_firmware,
> +	.identify_state	     = az6007_identify_state,
> +	.power_ctrl          = az6007_power_ctrl,
> +	.num_adapters        = 1,
> +	.adapter             = {
> +		{ .stream = DVB_USB_STREAM_BULK(0x02, 10, 4096), }
> +	}
> +};
> +
>  static struct usb_device_id az6007_usb_table[] = {
>  	{DVB_USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_6007,
>  		&az6007_props, "Azurewave 6007", RC_MAP_EMPTY)},
> @@ -875,6 +932,8 @@ static struct usb_device_id az6007_usb_table[] = {
>  		&az6007_props, "Terratec H7", RC_MAP_NEC_TERRATEC_CINERGY_XS)},
>  	{DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7_2,
>  		&az6007_props, "Terratec H7", RC_MAP_NEC_TERRATEC_CINERGY_XS)},
> +	{DVB_USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_CABLESTAR_HDCI,
> +		&az6007_cablestar_hdci_props, "Technisat CableStar Combo HD CI", RC_MAP_EMPTY)},
>  	{0},
>  };
>  
> 

