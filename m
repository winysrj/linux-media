Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hyatt.suomi.net ([82.128.152.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JRErw-0005pS-FC
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 23:53:52 +0100
Received: from tiku.suomi.net ([82.128.154.67])
	by hyatt.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0JWG007HWI8U0B40@hyatt.suomi.net> for
	linux-dvb@linuxtv.org; Tue, 19 Feb 2008 00:53:18 +0200 (EET)
Received: from spam2.suomi.net (spam2.suomi.net [212.50.131.166])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0JWG00FPJI8U8RA0@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Tue, 19 Feb 2008 00:53:18 +0200 (EET)
Date: Tue, 19 Feb 2008 00:53:01 +0200
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <ea4209750802181424q4ac90c7ag33ad8b8d79e258fd@mail.gmail.com>
To: Albert Comerma <albert.comerma@gmail.com>
Message-id: <47BA0C4D.4070102@iki.fi>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_jG5QrK9ozB3XOAbkQSvKDA)"
References: <ea4209750801161224p6b75d7fanbdcd29e7d367802d@mail.gmail.com>
	<47B9D533.7050504@iki.fi>
	<ea4209750802181306tcc8c98clff330d4289523d96@mail.gmail.com>
	<47BA011D.9060003@iki.fi>
	<ea4209750802181424q4ac90c7ag33ad8b8d79e258fd@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Yuan EC372S (STK7700D based device)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--Boundary_(ID_jG5QrK9ozB3XOAbkQSvKDA)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

latest v4l-master + patch you give.

regards
Antti

Albert Comerma wrote:
> Uhm... that's strange, I don't have any of this cards to test, but other 
> people reported that this solution was working. Could you post the 
> dib0700_devices.c you're using to have a look?
> 
> Albert
> 
> 2008/2/18, Antti Palosaari <crope@iki.fi <mailto:crope@iki.fi>>:
> 
>     moi
>     It does not work for me. It says same PID-filter timeout as I have got
>     earlier. I don't have amplified antenna now, but I can say that all
>     other DVB-T sticks I have are working with this small antenna. It could
>     be that sensitivity of this hardware is bad or there is something wrong
>     with driver or firmware. Lets try to test it Windows to see if it is
>     working or not.
>     Logs attached.
> 
> 
>     regards
>     Antti
> 
>     Albert Comerma wrote:
> 
>      > Hey people, we already solved this problems. I submitted a patch
>     a few
>      > days ago, but I think it's not on the current sources. I send
>     again the
>      > patch. Basically it must use the same frontend description as
>     asus cards.
>      >
>      > Albert
>      >
> 
>      > 2008/2/18, Antti Palosaari <crope@iki.fi <mailto:crope@iki.fi>
>     <mailto:crope@iki.fi <mailto:crope@iki.fi>>>:
> 
>      >
>      >     moikka
>      >     I have also this device (express card). I haven't looked
>     inside yet, but
>      >     I think there is DibCOM STK7700D (in my understanding dual
>     demod chip)
>      >     and only *one* MT2266 tuner. I tried various GPIO settings but no
>      >     luck yet.
>      >     GPIO6 is for MT2266.
>      >     GPIO9 and GPIO10 are for frontend.
>      >
>      >     Looks like tuner goes to correct frequency because I got always
>      >     PID-filter timeouts when tuning to correct freq. I will now
>     try to take
>      >     some usb-sniffs to see configuration used. Any help is welcome.
>      >
>      >     regards
>      >     Antti
>      >
>      >     Albert Comerma wrote:
>      >      > Hi!, with Michel (mm-sl@ibelgique.com
>     <mailto:mm-sl@ibelgique.com>
> 
>      >     <mailto:mm-sl@ibelgique.com <mailto:mm-sl@ibelgique.com>>
>     <mailto:mm-sl@ibelgique.com <mailto:mm-sl@ibelgique.com>
> 
>      >     <mailto:mm-sl@ibelgique.com <mailto:mm-sl@ibelgique.com>>>) who
>      >
>      >      > is a owner of this Yuan card we added the device to
>      >     dib0700_devices, and
>      >      > we got it recognized without problems. The only problem is
>     that no
>      >      > channel is detected on scan on kaffeine or other software... I
>      >     post some
>      >      > dmesg. We don't know where it may be the problem... or how to
>      >     detect it...
>      >      >
>      >      > usb 4-2: new high speed USB device using ehci_hcd and
>     address 6
>      >      > usb 4-2: new device found, idVendor=1164, idProduct=1edc
>      >      > usb 4-2: new device strings: Mfr=1, Product=2, SerialNumber=3
>      >      > usb 4-2: Product: STK7700D
>      >      > usb 4-2: Manufacturer: YUANRD
>      >      > usb 4-2: SerialNumber: 0000000001
>      >      > usb 4-2: configuration #1 chosen from 1 choice
>      >      > dvb-usb: found a 'Yuan EC372S' in cold state, will try to
>     load a
>      >     firmware
>      >      > dvb-usb: downloading firmware from file
>     'dvb-usb-dib0700-1.10.fw'
>      >      > dib0700: firmware started successfully.
>      >      > dvb-usb: found a 'Yuan EC372S' in warm state.
>      >      > dvb-usb: will pass the complete MPEG2 transport stream to the
>      >     software
>      >      > demuxer.
>      >      > DVB: registering new adapter (Yuan EC372S)
>      >      > dvb-usb: no frontend was attached by 'Yuan EC372S'
>      >      > dvb-usb: will pass the complete MPEG2 transport stream to the
>      >     software
>      >      > demuxer.
>      >      > DVB: registering new adapter (Yuan EC372S)
>      >      > DVB: registering frontend 1 (DiBcom 7000PC)...
>      >      > MT2266: successfully identified
>      >      > input: IR-receiver inside an USB DVB receiver as
>     /class/input/input10
>      >      > dvb-usb: schedule remote query interval to 150 msecs.
>      >      > dvb-usb: Yuan EC372S successfully initialized and connected.
>      >      >
>      >      >
>      >
>      >      >
>      >    
>     ------------------------------------------------------------------------
>      >      >
>      >      > _______________________________________________
>      >      > linux-dvb mailing list
> 
>      >      > linux-dvb@linuxtv.org <mailto:linux-dvb@linuxtv.org>
>     <mailto:linux-dvb@linuxtv.org <mailto:linux-dvb@linuxtv.org>>
> 
>      >      > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>      >
>      >
>      >
>      >     --
>      >     http://palosaari.fi/
>      >
>      >
>      >
>      >
>     ------------------------------------------------------------------------
>      >
>      > _______________________________________________
>      > linux-dvb mailing list
>      > linux-dvb@linuxtv.org <mailto:linux-dvb@linuxtv.org>
>      > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 
>     --
>     http://palosaari.fi/
> 
> 
>     Bus 001 Device 005: ID 1164:1edc YUAN High-Tech Development Co., Ltd
>     Device Descriptor:
>       bLength                18
>       bDescriptorType         1
>       bcdUSB               2.00
>       bDeviceClass            0 (Defined at Interface level)
>       bDeviceSubClass         0
>       bDeviceProtocol         0
>       bMaxPacketSize0        64
>       idVendor           0x1164 YUAN High-Tech Development Co., Ltd
>       idProduct          0x1edc
>       bcdDevice            1.00
>       iManufacturer           1 YUANRD
>       iProduct                2 STK7700D
>       iSerial                 3 0000000001
>       bNumConfigurations      1
>       Configuration Descriptor:
>         bLength                 9
>         bDescriptorType         2
>         wTotalLength           46
>         bNumInterfaces          1
>         bConfigurationValue     1
>         iConfiguration          0
>         bmAttributes         0xa0
>           Remote Wakeup
>         MaxPower              500mA
>         Interface Descriptor:
>           bLength                 9
>           bDescriptorType         4
>           bInterfaceNumber        0
>           bAlternateSetting       0
>           bNumEndpoints           4
>           bInterfaceClass       255 Vendor Specific Class
>           bInterfaceSubClass      0
>           bInterfaceProtocol      0
>           iInterface              0
>           Endpoint Descriptor:
>             bLength                 7
>             bDescriptorType         5
>             bEndpointAddress     0x01  EP 1 OUT
>             bmAttributes            2
>               Transfer Type            Bulk
>               Synch Type               None
>               Usage Type               Data
>             wMaxPacketSize     0x0200  1x 512 bytes
>             bInterval               1
>           Endpoint Descriptor:
>             bLength                 7
>             bDescriptorType         5
>             bEndpointAddress     0x81  EP 1 IN
>             bmAttributes            2
>               Transfer Type            Bulk
>               Synch Type               None
>               Usage Type               Data
>             wMaxPacketSize     0x0200  1x 512 bytes
>             bInterval               1
>           Endpoint Descriptor:
>             bLength                 7
>             bDescriptorType         5
>             bEndpointAddress     0x82  EP 2 IN
>             bmAttributes            2
>               Transfer Type            Bulk
>               Synch Type               None
>               Usage Type               Data
>             wMaxPacketSize     0x0200  1x 512 bytes
>             bInterval               1
>           Endpoint Descriptor:
>             bLength                 7
>             bDescriptorType         5
>             bEndpointAddress     0x83  EP 3 IN
>             bmAttributes            2
>               Transfer Type            Bulk
>               Synch Type               None
>               Usage Type               Data
>             wMaxPacketSize     0x0200  1x 512 bytes
>             bInterval               1
>     Device Qualifier (for other device speed):
>       bLength                10
>       bDescriptorType         6
>       bcdUSB               2.00
>       bDeviceClass            0 (Defined at Interface level)
>       bDeviceSubClass         0
>       bDeviceProtocol         0
>       bMaxPacketSize0        64
>       bNumConfigurations      1
> 
>     Feb 18 23:50:53 localhost kernel: usb 1-8: USB disconnect, address 5
>     Feb 18 23:50:55 localhost kernel: usb 1-8: new high speed USB device
>     using ehci_hcd and address 6
>     Feb 18 23:50:55 localhost kernel: usb 1-8: configuration #1 chosen
>     from 1 choice
>     Feb 18 23:50:55 localhost kernel: dib0700: loaded with support for 6
>     different device-types
>     Feb 18 23:50:55 localhost kernel: dvb-usb: found a 'Yuan EC372S' in
>     cold state, will try to load a firmware
>     Feb 18 23:50:55 localhost kernel: dvb-usb: downloading firmware from
>     file 'dvb-usb-dib0700-1.10.fw'
>     Feb 18 23:50:55 localhost kernel: dib0700: firmware started
>     successfully.
>     Feb 18 23:50:56 localhost kernel: dvb-usb: found a 'Yuan EC372S' in
>     warm state.
>     Feb 18 23:50:56 localhost kernel: dvb-usb: will pass the complete
>     MPEG2 transport stream to the software demuxer.
>     Feb 18 23:50:56 localhost kernel: DVB: registering new adapter (Yuan
>     EC372S)
>     Feb 18 23:50:56 localhost kernel: DVB: registering frontend 0
>     (DiBcom 7000PC)...
>     Feb 18 23:50:56 localhost kernel: MT2266: successfully identified
>     Feb 18 23:50:56 localhost kernel: dvb-usb: Yuan EC372S successfully
>     initialized and connected.
>     Feb 18 23:50:56 localhost kernel: usbcore: registered new interface
>     driver dvb_usb_dib0700
> 
>     [crope@localhost linuxtv]$ scandvb fi-Oulu
>     scanning fi-Oulu
>     using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>     initial transponder 634000000 0 2 9 3 1 2 0
>     initial transponder 714000000 0 2 9 3 1 2 0
>     initial transponder 738000000 0 2 9 3 1 2 0
>     initial transponder 602000000 0 2 9 3 1 2 0
>      >>> tune to:
>     634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>     WARNING: filter timeout pid 0x0011
>     WARNING: filter timeout pid 0x0000
>     WARNING: filter timeout pid 0x0010
>      >>> tune to:
>     714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>     WARNING: filter timeout pid 0x0011
>     WARNING: filter timeout pid 0x0000
>     WARNING: filter timeout pid 0x0010
>      >>> tune to:
>     738000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>     WARNING: filter timeout pid 0x0011
>     WARNING: filter timeout pid 0x0000
>     WARNING: filter timeout pid 0x0010
>      >>> tune to:
>     602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>     WARNING: filter timeout pid 0x0011
>     WARNING: filter timeout pid 0x0000
>     WARNING: filter timeout pid 0x0010
>     dumping lists (0 services)
>     Done.
>     [crope@localhost linuxtv]$
> 
> 
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
http://palosaari.fi/

--Boundary_(ID_jG5QrK9ozB3XOAbkQSvKDA)
Content-type: text/x-csrc; name=dib0700_devices.c
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=dib0700_devices.c

/* Linux driver for devices based on the DiBcom DiB0700 USB bridge
 *
 *	This program is free software; you can redistribute it and/or modify it
 *	under the terms of the GNU General Public License as published by the Free
 *	Software Foundation, version 2.
 *
 *  Copyright (C) 2005-7 DiBcom, SA
 */
#include "dib0700.h"

#include "dib3000mc.h"
#include "dib7000m.h"
#include "dib7000p.h"
#include "mt2060.h"
#include "mt2266.h"
#include "dib0070.h"

static int force_lna_activation;
module_param(force_lna_activation, int, 0644);
MODULE_PARM_DESC(force_lna_activation, "force the activation of Low-Noise-Amplifyer(s) (LNA), "
		"if applicable for the device (default: 0=automatic/off).");

struct dib0700_adapter_state {
	int (*set_param_save) (struct dvb_frontend *, struct dvb_frontend_parameters *);
};

/* Hauppauge Nova-T 500 (aka Bristol)
 *  has a LNA on GPIO0 which is enabled by setting 1 */
static struct mt2060_config bristol_mt2060_config[2] = {
	{
		.i2c_address = 0x60,
		.clock_out   = 3,
	}, {
		.i2c_address = 0x61,
	}
};

static struct dibx000_agc_config bristol_dib3000p_mt2060_agc_config = {
	.band_caps = BAND_VHF | BAND_UHF,
	.setup     = (1 << 8) | (5 << 5) | (0 << 4) | (0 << 3) | (0 << 2) | (2 << 0),

	.agc1_max = 42598,
	.agc1_min = 17694,
	.agc2_max = 45875,
	.agc2_min = 0,

	.agc1_pt1 = 0,
	.agc1_pt2 = 59,

	.agc1_slope1 = 0,
	.agc1_slope2 = 69,

	.agc2_pt1 = 0,
	.agc2_pt2 = 59,

	.agc2_slope1 = 111,
	.agc2_slope2 = 28,
};

static struct dib3000mc_config bristol_dib3000mc_config[2] = {
	{	.agc          = &bristol_dib3000p_mt2060_agc_config,
		.max_time     = 0x196,
		.ln_adc_level = 0x1cc7,
		.output_mpeg2_in_188_bytes = 1,
	},
	{	.agc          = &bristol_dib3000p_mt2060_agc_config,
		.max_time     = 0x196,
		.ln_adc_level = 0x1cc7,
		.output_mpeg2_in_188_bytes = 1,
	}
};

static int bristol_frontend_attach(struct dvb_usb_adapter *adap)
{
	struct dib0700_state *st = adap->dev->priv;
	if (adap->id == 0) {
		dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 0); msleep(10);
		dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 1); msleep(10);
		dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0); msleep(10);
		dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1); msleep(10);

		if (force_lna_activation)
			dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
		else
			dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 0);

		if (dib3000mc_i2c_enumeration(&adap->dev->i2c_adap, 2, DEFAULT_DIB3000P_I2C_ADDRESS, bristol_dib3000mc_config) != 0) {
			dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0); msleep(10);
			return -ENODEV;
		}
	}
	st->mt2060_if1[adap->id] = 1220;
	return (adap->fe = dvb_attach(dib3000mc_attach, &adap->dev->i2c_adap,
		(10 + adap->id) << 1, &bristol_dib3000mc_config[adap->id])) == NULL ? -ENODEV : 0;
}

static int eeprom_read(struct i2c_adapter *adap,u8 adrs,u8 *pval)
{
	struct i2c_msg msg[2] = {
		{ .addr = 0x50, .flags = 0,        .buf = &adrs, .len = 1 },
		{ .addr = 0x50, .flags = I2C_M_RD, .buf = pval,  .len = 1 },
	};
	if (i2c_transfer(adap, msg, 2) != 2) return -EREMOTEIO;
	return 0;
}

static int bristol_tuner_attach(struct dvb_usb_adapter *adap)
{
	struct i2c_adapter *prim_i2c = &adap->dev->i2c_adap;
	struct i2c_adapter *tun_i2c = dib3000mc_get_tuner_i2c_master(adap->fe, 1);
	s8 a;
	int if1=1220;
	if (adap->dev->udev->descriptor.idVendor  == USB_VID_HAUPPAUGE &&
		adap->dev->udev->descriptor.idProduct == USB_PID_HAUPPAUGE_NOVA_T_500_2) {
		if (!eeprom_read(prim_i2c,0x59 + adap->id,&a)) if1=1220+a;
	}
	return dvb_attach(mt2060_attach,adap->fe, tun_i2c,&bristol_mt2060_config[adap->id],
		if1) == NULL ? -ENODEV : 0;
}

/* STK7700D: Pinnacle/Terratec/Hauppauge Dual DVB-T Diversity */

/* MT226x */
static struct dibx000_agc_config stk7700d_7000p_mt2266_agc_config[2] = {
	{
		BAND_UHF, // band_caps

		/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=1, P_agc_inv_pwm1=1, P_agc_inv_pwm2=1,
		* P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=2, P_agc_write=0 */
		(0 << 15) | (0 << 14) | (1 << 11) | (1 << 10) | (1 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (5 << 1) | (0 << 0), // setup

		1130,  // inv_gain
		21,  // time_stabiliz

		0,  // alpha_level
		118,  // thlock

		0,     // wbd_inv
		3530,  // wbd_ref
		1,     // wbd_sel
		0,     // wbd_alpha

		65535,  // agc1_max
		33770,  // agc1_min
		65535,  // agc2_max
		23592,  // agc2_min

		0,    // agc1_pt1
		62,   // agc1_pt2
		255,  // agc1_pt3
		64,   // agc1_slope1
		64,   // agc1_slope2
		132,  // agc2_pt1
		192,  // agc2_pt2
		80,   // agc2_slope1
		80,   // agc2_slope2

		17,  // alpha_mant
		27,  // alpha_exp
		23,  // beta_mant
		51,  // beta_exp

		1,  // perform_agc_softsplit
	}, {
		BAND_VHF | BAND_LBAND, // band_caps

		/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=1, P_agc_inv_pwm1=1, P_agc_inv_pwm2=1,
		* P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=2, P_agc_write=0 */
		(0 << 15) | (0 << 14) | (1 << 11) | (1 << 10) | (1 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (2 << 1) | (0 << 0), // setup

		2372, // inv_gain
		21,   // time_stabiliz

		0,    // alpha_level
		118,  // thlock

		0,    // wbd_inv
		3530, // wbd_ref
		1,     // wbd_sel
		0,    // wbd_alpha

		65535, // agc1_max
		0,     // agc1_min
		65535, // agc2_max
		23592, // agc2_min

		0,    // agc1_pt1
		128,  // agc1_pt2
		128,  // agc1_pt3
		128,  // agc1_slope1
		0,    // agc1_slope2
		128,  // agc2_pt1
		253,  // agc2_pt2
		81,   // agc2_slope1
		0,    // agc2_slope2

		17,  // alpha_mant
		27,  // alpha_exp
		23,  // beta_mant
		51,  // beta_exp

		1,  // perform_agc_softsplit
	}
};

static struct dibx000_bandwidth_config stk7700d_mt2266_pll_config = {
	60000, 30000, // internal, sampling
	1, 8, 3, 1, 0, // pll_cfg: prediv, ratio, range, reset, bypass
	0, 0, 1, 1, 2, // misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc, modulo
	(3 << 14) | (1 << 12) | (524 << 0), // sad_cfg: refsel, sel, freq_15k
	0, // ifreq
	20452225, // timf
};

static struct dib7000p_config stk7700d_dib7000p_mt2266_config[] = {
	{	.output_mpeg2_in_188_bytes = 1,
		.hostbus_diversity = 1,
		.tuner_is_baseband = 1,

		.agc_config_count = 2,
		.agc = stk7700d_7000p_mt2266_agc_config,
		.bw  = &stk7700d_mt2266_pll_config,

		.gpio_dir = DIB7000P_GPIO_DEFAULT_DIRECTIONS,
		.gpio_val = DIB7000P_GPIO_DEFAULT_VALUES,
		.gpio_pwm_pos = DIB7000P_GPIO_DEFAULT_PWM_POS,
	},
	{	.output_mpeg2_in_188_bytes = 1,
		.hostbus_diversity = 1,
		.tuner_is_baseband = 1,

		.agc_config_count = 2,
		.agc = stk7700d_7000p_mt2266_agc_config,
		.bw  = &stk7700d_mt2266_pll_config,

		.gpio_dir = DIB7000P_GPIO_DEFAULT_DIRECTIONS,
		.gpio_val = DIB7000P_GPIO_DEFAULT_VALUES,
		.gpio_pwm_pos = DIB7000P_GPIO_DEFAULT_PWM_POS,
	}
};

static struct mt2266_config stk7700d_mt2266_config[2] = {
	{	.i2c_address = 0x60
	},
	{	.i2c_address = 0x60
	}
};

static int stk7700P2_frontend_attach(struct dvb_usb_adapter *adap)
{
	if (adap->id == 0) {
		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
		msleep(10);
		dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
		dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
		dib0700_set_gpio(adap->dev, GPIO7, GPIO_OUT, 1);
		dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
		msleep(10);
		dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
		msleep(10);
		dib7000p_i2c_enumeration(&adap->dev->i2c_adap,1,18,stk7700d_dib7000p_mt2266_config);
	}

	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,0x80+(adap->id << 1),
				&stk7700d_dib7000p_mt2266_config[adap->id]);

	return adap->fe == NULL ? -ENODEV : 0;
}

static int stk7700d_frontend_attach(struct dvb_usb_adapter *adap)
{
	if (adap->id == 0) {
		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
		msleep(10);
		dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
		dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
		dib0700_set_gpio(adap->dev, GPIO7, GPIO_OUT, 1);
		dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
		msleep(10);
		dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
		msleep(10);
		dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
		dib7000p_i2c_enumeration(&adap->dev->i2c_adap,2,18,stk7700d_dib7000p_mt2266_config);
	}

	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,0x80+(adap->id << 1),
				&stk7700d_dib7000p_mt2266_config[adap->id]);

	return adap->fe == NULL ? -ENODEV : 0;
}

static int stk7700d_tuner_attach(struct dvb_usb_adapter *adap)
{
	struct i2c_adapter *tun_i2c;
	tun_i2c = dib7000p_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
	return dvb_attach(mt2266_attach, adap->fe, tun_i2c,
		&stk7700d_mt2266_config[adap->id]) == NULL ? -ENODEV : 0;;
}

#define DEFAULT_RC_INTERVAL 150

static u8 rc_request[] = { REQUEST_POLL_RC, 0 };

static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
{
	u8 key[4];
	int i;
	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
	struct dib0700_state *st = d->priv;
	*event = 0;
	*state = REMOTE_NO_KEY_PRESSED;
	i=dib0700_ctrl_rd(d,rc_request,2,key,4);
	if (i<=0) {
		err("RC Query Failed");
		return -1;
	}
	if (key[0]==0 && key[1]==0 && key[2]==0 && key[3]==0) return 0;
	if (key[3-1]!=st->rc_toggle) {
		for (i=0;i<d->props.rc_key_map_size; i++) {
			if (keymap[i].custom == key[3-2] && keymap[i].data == key[3-3]) {
				*event = keymap[i].event;
				*state = REMOTE_KEY_PRESSED;
				st->rc_toggle=key[3-1];
				return 0;
			}
		}
		err("Unknown remote controller key : %2X %2X",(int)key[3-2],(int)key[3-3]);
	}
	return 0;
}

static struct dvb_usb_rc_key dib0700_rc_keys[] = {
	/* Key codes for the tiny Pinnacle remote*/
	{ 0x07, 0x00, KEY_MUTE },
	{ 0x07, 0x01, KEY_MENU }, // Pinnacle logo
	{ 0x07, 0x39, KEY_POWER },
	{ 0x07, 0x03, KEY_VOLUMEUP },
	{ 0x07, 0x09, KEY_VOLUMEDOWN },
	{ 0x07, 0x06, KEY_CHANNELUP },
	{ 0x07, 0x0c, KEY_CHANNELDOWN },
	{ 0x07, 0x0f, KEY_1 },
	{ 0x07, 0x15, KEY_2 },
	{ 0x07, 0x10, KEY_3 },
	{ 0x07, 0x18, KEY_4 },
	{ 0x07, 0x1b, KEY_5 },
	{ 0x07, 0x1e, KEY_6 },
	{ 0x07, 0x11, KEY_7 },
	{ 0x07, 0x21, KEY_8 },
	{ 0x07, 0x12, KEY_9 },
	{ 0x07, 0x27, KEY_0 },
	{ 0x07, 0x24, KEY_SCREEN }, // 'Square' key
	{ 0x07, 0x2a, KEY_TEXT },   // 'T' key
	{ 0x07, 0x2d, KEY_REWIND },
	{ 0x07, 0x30, KEY_PLAY },
	{ 0x07, 0x33, KEY_FASTFORWARD },
	{ 0x07, 0x36, KEY_RECORD },
	{ 0x07, 0x3c, KEY_STOP },
	{ 0x07, 0x3f, KEY_CANCEL }, // '?' key
	/* Key codes for the Terratec Cinergy DT XS Diversity, similar to cinergyT2.c */
	{ 0xeb, 0x01, KEY_POWER },
	{ 0xeb, 0x02, KEY_1 },
	{ 0xeb, 0x03, KEY_2 },
	{ 0xeb, 0x04, KEY_3 },
	{ 0xeb, 0x05, KEY_4 },
	{ 0xeb, 0x06, KEY_5 },
	{ 0xeb, 0x07, KEY_6 },
	{ 0xeb, 0x08, KEY_7 },
	{ 0xeb, 0x09, KEY_8 },
	{ 0xeb, 0x0a, KEY_9 },
	{ 0xeb, 0x0b, KEY_VIDEO },
	{ 0xeb, 0x0c, KEY_0 },
	{ 0xeb, 0x0d, KEY_REFRESH },
	{ 0xeb, 0x0f, KEY_EPG },
	{ 0xeb, 0x10, KEY_UP },
	{ 0xeb, 0x11, KEY_LEFT },
	{ 0xeb, 0x12, KEY_OK },
	{ 0xeb, 0x13, KEY_RIGHT },
	{ 0xeb, 0x14, KEY_DOWN },
	{ 0xeb, 0x16, KEY_INFO },
	{ 0xeb, 0x17, KEY_RED },
	{ 0xeb, 0x18, KEY_GREEN },
	{ 0xeb, 0x19, KEY_YELLOW },
	{ 0xeb, 0x1a, KEY_BLUE },
	{ 0xeb, 0x1b, KEY_CHANNELUP },
	{ 0xeb, 0x1c, KEY_VOLUMEUP },
	{ 0xeb, 0x1d, KEY_MUTE },
	{ 0xeb, 0x1e, KEY_VOLUMEDOWN },
	{ 0xeb, 0x1f, KEY_CHANNELDOWN },
	{ 0xeb, 0x40, KEY_PAUSE },
	{ 0xeb, 0x41, KEY_HOME },
	{ 0xeb, 0x42, KEY_MENU }, /* DVD Menu */
	{ 0xeb, 0x43, KEY_SUBTITLE },
	{ 0xeb, 0x44, KEY_TEXT }, /* Teletext */
	{ 0xeb, 0x45, KEY_DELETE },
	{ 0xeb, 0x46, KEY_TV },
	{ 0xeb, 0x47, KEY_DVD },
	{ 0xeb, 0x48, KEY_STOP },
	{ 0xeb, 0x49, KEY_VIDEO },
	{ 0xeb, 0x4a, KEY_AUDIO }, /* Music */
	{ 0xeb, 0x4b, KEY_SCREEN }, /* Pic */
	{ 0xeb, 0x4c, KEY_PLAY },
	{ 0xeb, 0x4d, KEY_BACK },
	{ 0xeb, 0x4e, KEY_REWIND },
	{ 0xeb, 0x4f, KEY_FASTFORWARD },
	{ 0xeb, 0x54, KEY_PREVIOUS },
	{ 0xeb, 0x58, KEY_RECORD },
	{ 0xeb, 0x5c, KEY_NEXT },

	/* Key codes for the Haupauge WinTV Nova-TD, copied from nova-t-usb2.c (Nova-T USB2) */
	{ 0x1e, 0x00, KEY_0 },
	{ 0x1e, 0x01, KEY_1 },
	{ 0x1e, 0x02, KEY_2 },
	{ 0x1e, 0x03, KEY_3 },
	{ 0x1e, 0x04, KEY_4 },
	{ 0x1e, 0x05, KEY_5 },
	{ 0x1e, 0x06, KEY_6 },
	{ 0x1e, 0x07, KEY_7 },
	{ 0x1e, 0x08, KEY_8 },
	{ 0x1e, 0x09, KEY_9 },
	{ 0x1e, 0x0a, KEY_KPASTERISK },
	{ 0x1e, 0x0b, KEY_RED },
	{ 0x1e, 0x0c, KEY_RADIO },
	{ 0x1e, 0x0d, KEY_MENU },
	{ 0x1e, 0x0e, KEY_GRAVE }, /* # */
	{ 0x1e, 0x0f, KEY_MUTE },
	{ 0x1e, 0x10, KEY_VOLUMEUP },
	{ 0x1e, 0x11, KEY_VOLUMEDOWN },
	{ 0x1e, 0x12, KEY_CHANNEL },
	{ 0x1e, 0x14, KEY_UP },
	{ 0x1e, 0x15, KEY_DOWN },
	{ 0x1e, 0x16, KEY_LEFT },
	{ 0x1e, 0x17, KEY_RIGHT },
	{ 0x1e, 0x18, KEY_VIDEO },
	{ 0x1e, 0x19, KEY_AUDIO },
	{ 0x1e, 0x1a, KEY_MEDIA },
	{ 0x1e, 0x1b, KEY_EPG },
	{ 0x1e, 0x1c, KEY_TV },
	{ 0x1e, 0x1e, KEY_NEXT },
	{ 0x1e, 0x1f, KEY_BACK },
	{ 0x1e, 0x20, KEY_CHANNELUP },
	{ 0x1e, 0x21, KEY_CHANNELDOWN },
	{ 0x1e, 0x24, KEY_LAST }, /* Skip backwards */
	{ 0x1e, 0x25, KEY_OK },
	{ 0x1e, 0x29, KEY_BLUE},
	{ 0x1e, 0x2e, KEY_GREEN },
	{ 0x1e, 0x30, KEY_PAUSE },
	{ 0x1e, 0x32, KEY_REWIND },
	{ 0x1e, 0x34, KEY_FASTFORWARD },
	{ 0x1e, 0x35, KEY_PLAY },
	{ 0x1e, 0x36, KEY_STOP },
	{ 0x1e, 0x37, KEY_RECORD },
	{ 0x1e, 0x38, KEY_YELLOW },
	{ 0x1e, 0x3b, KEY_GOTO },
	{ 0x1e, 0x3d, KEY_POWER },

	/* Key codes for the Leadtek Winfast DTV Dongle */
	{ 0x00, 0x42, KEY_POWER },
	{ 0x07, 0x7c, KEY_TUNER },
	{ 0x0f, 0x4e, KEY_PRINT }, /* PREVIEW */
	{ 0x08, 0x40, KEY_SCREEN }, /* full screen toggle*/
	{ 0x0f, 0x71, KEY_DOT }, /* frequency */
	{ 0x07, 0x43, KEY_0 },
	{ 0x0c, 0x41, KEY_1 },
	{ 0x04, 0x43, KEY_2 },
	{ 0x0b, 0x7f, KEY_3 },
	{ 0x0e, 0x41, KEY_4 },
	{ 0x06, 0x43, KEY_5 },
	{ 0x09, 0x7f, KEY_6 },
	{ 0x0d, 0x7e, KEY_7 },
	{ 0x05, 0x7c, KEY_8 },
	{ 0x0a, 0x40, KEY_9 },
	{ 0x0e, 0x4e, KEY_CLEAR },
	{ 0x04, 0x7c, KEY_CHANNEL }, /* show channel number */
	{ 0x0f, 0x41, KEY_LAST }, /* recall */
	{ 0x03, 0x42, KEY_MUTE },
	{ 0x06, 0x4c, KEY_RESERVED }, /* PIP button*/
	{ 0x01, 0x72, KEY_SHUFFLE }, /* SNAPSHOT */
	{ 0x0c, 0x4e, KEY_PLAYPAUSE }, /* TIMESHIFT */
	{ 0x0b, 0x70, KEY_RECORD },
	{ 0x03, 0x7d, KEY_VOLUMEUP },
	{ 0x01, 0x7d, KEY_VOLUMEDOWN },
	{ 0x02, 0x42, KEY_CHANNELUP },
	{ 0x00, 0x7d, KEY_CHANNELDOWN },
};

/* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */
static struct dibx000_agc_config stk7700p_7000m_mt2060_agc_config = {
	BAND_UHF | BAND_VHF,       // band_caps

	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=5, P_agc_inv_pwm1=0, P_agc_inv_pwm2=0,
	 * P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=2, P_agc_write=0 */
	(0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (2 << 1) | (0 << 0), // setup

	712,  // inv_gain
	41,  // time_stabiliz

	0,  // alpha_level
	118,  // thlock

	0,     // wbd_inv
	4095,  // wbd_ref
	0,     // wbd_sel
	0,     // wbd_alpha

	42598,  // agc1_max
	17694,  // agc1_min
	45875,  // agc2_max
	2621,  // agc2_min
	0,  // agc1_pt1
	76,  // agc1_pt2
	139,  // agc1_pt3
	52,  // agc1_slope1
	59,  // agc1_slope2
	107,  // agc2_pt1
	172,  // agc2_pt2
	57,  // agc2_slope1
	70,  // agc2_slope2

	21,  // alpha_mant
	25,  // alpha_exp
	28,  // beta_mant
	48,  // beta_exp

	1,  // perform_agc_softsplit
	{  0,     // split_min
	   107,   // split_max
	   51800, // global_split_min
	   24700  // global_split_max
	},
};

static struct dibx000_agc_config stk7700p_7000p_mt2060_agc_config = {
	BAND_UHF | BAND_VHF,

	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=5, P_agc_inv_pwm1=0, P_agc_inv_pwm2=0,
	 * P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=2, P_agc_write=0 */
	(0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (2 << 1) | (0 << 0), // setup

	712, // inv_gain
	41,  // time_stabiliz

	0,   // alpha_level
	118, // thlock

	0,    // wbd_inv
	4095, // wbd_ref
	0,    // wbd_sel
	0,    // wbd_alpha

	42598, // agc1_max
	16384, // agc1_min
	42598, // agc2_max
	    0, // agc2_min

	  0,   // agc1_pt1
	137,   // agc1_pt2
	255,   // agc1_pt3

	  0,   // agc1_slope1
	255,   // agc1_slope2

	0,     // agc2_pt1
	0,     // agc2_pt2

	 0,    // agc2_slope1
	41,    // agc2_slope2

	15, // alpha_mant
	25, // alpha_exp

	28, // beta_mant
	48, // beta_exp

	0, // perform_agc_softsplit
};

static struct dibx000_bandwidth_config stk7700p_pll_config = {
	60000, 30000, // internal, sampling
	1, 8, 3, 1, 0, // pll_cfg: prediv, ratio, range, reset, bypass
	0, 0, 1, 1, 0, // misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc, modulo
	(3 << 14) | (1 << 12) | (524 << 0), // sad_cfg: refsel, sel, freq_15k
	60258167, // ifreq
	20452225, // timf
	30000000, // xtal
};

static struct dib7000m_config stk7700p_dib7000m_config = {
	.dvbt_mode = 1,
	.output_mpeg2_in_188_bytes = 1,
	.quartz_direct = 1,

	.agc_config_count = 1,
	.agc = &stk7700p_7000m_mt2060_agc_config,
	.bw  = &stk7700p_pll_config,

	.gpio_dir = DIB7000M_GPIO_DEFAULT_DIRECTIONS,
	.gpio_val = DIB7000M_GPIO_DEFAULT_VALUES,
	.gpio_pwm_pos = DIB7000M_GPIO_DEFAULT_PWM_POS,
};

static struct dib7000p_config stk7700p_dib7000p_config = {
	.output_mpeg2_in_188_bytes = 1,

	.agc_config_count = 1,
	.agc = &stk7700p_7000p_mt2060_agc_config,
	.bw  = &stk7700p_pll_config,

	.gpio_dir = DIB7000M_GPIO_DEFAULT_DIRECTIONS,
	.gpio_val = DIB7000M_GPIO_DEFAULT_VALUES,
	.gpio_pwm_pos = DIB7000M_GPIO_DEFAULT_PWM_POS,
};

static int stk7700p_frontend_attach(struct dvb_usb_adapter *adap)
{
	struct dib0700_state *st = adap->dev->priv;
	/* unless there is no real power management in DVB - we leave the device on GPIO6 */

	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
	dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 0); msleep(50);

	dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 1); msleep(10);
	dib0700_set_gpio(adap->dev, GPIO9,  GPIO_OUT, 1);

	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0); msleep(10);
	dib0700_ctrl_clock(adap->dev, 72, 1);
	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1); msleep(100);

	dib0700_set_gpio(adap->dev,  GPIO0, GPIO_OUT, 1);

	st->mt2060_if1[0] = 1220;

	if (dib7000pc_detection(&adap->dev->i2c_adap)) {
		adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
		st->is_dib7000pc = 1;
	} else
		adap->fe = dvb_attach(dib7000m_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000m_config);

	return adap->fe == NULL ? -ENODEV : 0;
}

static struct mt2060_config stk7700p_mt2060_config = {
	0x60
};

static int stk7700p_tuner_attach(struct dvb_usb_adapter *adap)
{
	struct i2c_adapter *prim_i2c = &adap->dev->i2c_adap;
	struct dib0700_state *st = adap->dev->priv;
	struct i2c_adapter *tun_i2c;
	s8 a;
	int if1=1220;
	if (adap->dev->udev->descriptor.idVendor  == USB_VID_HAUPPAUGE &&
		adap->dev->udev->descriptor.idProduct == USB_PID_HAUPPAUGE_NOVA_T_STICK) {
		if (!eeprom_read(prim_i2c,0x58,&a)) if1=1220+a;
	}
	if (st->is_dib7000pc)
		tun_i2c = dib7000p_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
	else
		tun_i2c = dib7000m_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);

	return dvb_attach(mt2060_attach, adap->fe, tun_i2c, &stk7700p_mt2060_config,
		if1) == NULL ? -ENODEV : 0;
}

/* DIB7070 generic */
static struct dibx000_agc_config dib7070_agc_config = {
	BAND_UHF | BAND_VHF | BAND_LBAND | BAND_SBAND,
	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=5, P_agc_inv_pwm1=0, P_agc_inv_pwm2=0,
	 * P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=5, P_agc_write=0 */
	(0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (5 << 1) | (0 << 0), // setup

	600, // inv_gain
	10,  // time_stabiliz

	0,  // alpha_level
	118,  // thlock

	0,     // wbd_inv
	3530,  // wbd_ref
	1,     // wbd_sel
	5,     // wbd_alpha

	65535,  // agc1_max
		0,  // agc1_min

	65535,  // agc2_max
	0,      // agc2_min

	0,      // agc1_pt1
	40,     // agc1_pt2
	183,    // agc1_pt3
	206,    // agc1_slope1
	255,    // agc1_slope2
	72,     // agc2_pt1
	152,    // agc2_pt2
	88,     // agc2_slope1
	90,     // agc2_slope2

	17,  // alpha_mant
	27,  // alpha_exp
	23,  // beta_mant
	51,  // beta_exp

	0,  // perform_agc_softsplit
};

static int dib7070_tuner_reset(struct dvb_frontend *fe, int onoff)
{
	return dib7000p_set_gpio(fe, 8, 0, !onoff);
}

static int dib7070_tuner_sleep(struct dvb_frontend *fe, int onoff)
{
	return dib7000p_set_gpio(fe, 9, 0, onoff);
}

static struct dib0070_config dib7070p_dib0070_config[2] = {
	{
		.i2c_address = DEFAULT_DIB0070_I2C_ADDRESS,
		.reset = dib7070_tuner_reset,
		.sleep = dib7070_tuner_sleep,
		.clock_khz = 12000,
		.clock_pad_drive = 4
	}, {
		.i2c_address = DEFAULT_DIB0070_I2C_ADDRESS,
		.reset = dib7070_tuner_reset,
		.sleep = dib7070_tuner_sleep,
		.clock_khz = 12000,

	}
};

static int dib7070_set_param_override(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
{
	struct dvb_usb_adapter *adap = fe->dvb->priv;
	struct dib0700_adapter_state *state = adap->priv;

	u16 offset;
	u8 band = BAND_OF_FREQUENCY(fep->frequency/1000);
	switch (band) {
		case BAND_VHF: offset = 950; break;
		case BAND_UHF:
		default: offset = 550; break;
	}
	deb_info("WBD for DiB7000P: %d\n", offset + dib0070_wbd_offset(fe));
	dib7000p_set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
	return state->set_param_save(fe, fep);
}

static int dib7070p_tuner_attach(struct dvb_usb_adapter *adap)
{
	struct dib0700_adapter_state *st = adap->priv;
	struct i2c_adapter *tun_i2c = dib7000p_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);

	if (adap->id == 0) {
		if (dvb_attach(dib0070_attach, adap->fe, tun_i2c, &dib7070p_dib0070_config[0]) == NULL)
			return -ENODEV;
	} else {
		if (dvb_attach(dib0070_attach, adap->fe, tun_i2c, &dib7070p_dib0070_config[1]) == NULL)
			return -ENODEV;
	}

	st->set_param_save = adap->fe->ops.tuner_ops.set_params;
	adap->fe->ops.tuner_ops.set_params = dib7070_set_param_override;
	return 0;
}

static struct dibx000_bandwidth_config dib7070_bw_config_12_mhz = {
	60000, 15000, // internal, sampling
	1, 20, 3, 1, 0, // pll_cfg: prediv, ratio, range, reset, bypass
	0, 0, 1, 1, 2, // misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc, modulo
	(3 << 14) | (1 << 12) | (524 << 0), // sad_cfg: refsel, sel, freq_15k
	(0 << 25) | 0, // ifreq = 0.000000 MHz
	20452225, // timf
	12000000, // xtal_hz
};

static struct dib7000p_config dib7070p_dib7000p_config = {
	.output_mpeg2_in_188_bytes = 1,

	.agc_config_count = 1,
	.agc = &dib7070_agc_config,
	.bw  = &dib7070_bw_config_12_mhz,
	.tuner_is_baseband = 1,
	.spur_protect = 1,

	.gpio_dir = DIB7000P_GPIO_DEFAULT_DIRECTIONS,
	.gpio_val = DIB7000P_GPIO_DEFAULT_VALUES,
	.gpio_pwm_pos = DIB7000P_GPIO_DEFAULT_PWM_POS,

	.hostbus_diversity = 1,
};

/* STK7070P */
static int stk7070p_frontend_attach(struct dvb_usb_adapter *adap)
{
	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
	msleep(10);
	dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
	dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
	dib0700_set_gpio(adap->dev, GPIO7, GPIO_OUT, 1);
	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);

	dib0700_ctrl_clock(adap->dev, 72, 1);

	msleep(10);
	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
	msleep(10);
	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);

	dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18, &dib7070p_dib7000p_config);

	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80, &dib7070p_dib7000p_config);
	return adap->fe == NULL ? -ENODEV : 0;
}

/* STK7070PD */
static struct dib7000p_config stk7070pd_dib7000p_config[2] = {
	{
		.output_mpeg2_in_188_bytes = 1,

		.agc_config_count = 1,
		.agc = &dib7070_agc_config,
		.bw  = &dib7070_bw_config_12_mhz,
		.tuner_is_baseband = 1,
		.spur_protect = 1,

		.gpio_dir = DIB7000P_GPIO_DEFAULT_DIRECTIONS,
		.gpio_val = DIB7000P_GPIO_DEFAULT_VALUES,
		.gpio_pwm_pos = DIB7000P_GPIO_DEFAULT_PWM_POS,

		.hostbus_diversity = 1,
	}, {
		.output_mpeg2_in_188_bytes = 1,

		.agc_config_count = 1,
		.agc = &dib7070_agc_config,
		.bw  = &dib7070_bw_config_12_mhz,
		.tuner_is_baseband = 1,
		.spur_protect = 1,

		.gpio_dir = DIB7000P_GPIO_DEFAULT_DIRECTIONS,
		.gpio_val = DIB7000P_GPIO_DEFAULT_VALUES,
		.gpio_pwm_pos = DIB7000P_GPIO_DEFAULT_PWM_POS,

		.hostbus_diversity = 1,
	}
};

static int stk7070pd_frontend_attach0(struct dvb_usb_adapter *adap)
{
	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
	msleep(10);
	dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
	dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
	dib0700_set_gpio(adap->dev, GPIO7, GPIO_OUT, 1);
	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);

	dib0700_ctrl_clock(adap->dev, 72, 1);

	msleep(10);
	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
	msleep(10);
	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);

	dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 2, 18, stk7070pd_dib7000p_config);

	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80, &stk7070pd_dib7000p_config[0]);
	return adap->fe == NULL ? -ENODEV : 0;
}

static int stk7070pd_frontend_attach1(struct dvb_usb_adapter *adap)
{
	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x82, &stk7070pd_dib7000p_config[1]);
	return adap->fe == NULL ? -ENODEV : 0;
}

/* DVB-USB and USB stuff follows */
struct usb_device_id dib0700_usb_id_table[] = {
/* 0 */	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK7700P) },
		{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK7700P_PC) },

		{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500) },
		{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500_2) },
		{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_STICK) },
/* 5 */	{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR) },
		{ USB_DEVICE(USB_VID_COMPRO,    USB_PID_COMPRO_VIDEOMATE_U500) },
		{ USB_DEVICE(USB_VID_UNIWILL,   USB_PID_UNIWILL_STK7700P) },
		{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_STK7700P) },
		{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_STICK_2) },
/* 10 */{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_2) },
		{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV2000E) },
		{ USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY) },
		{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_TD_STICK) },
		{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK7700D) },
/* 15 */{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK7070P) },
		{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV_DVB_T_FLASH) },
		{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK7070PD) },
		{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV_DUAL_DIVERSITY_DVB_T) },
		{ USB_DEVICE(USB_VID_COMPRO,    USB_PID_COMPRO_VIDEOMATE_U500_PC) },
/* 20 */{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_EXPRESS) },
		{ USB_DEVICE(USB_VID_GIGABYTE,  USB_PID_GIGABYTE_U7000) },
		{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC, USB_PID_ARTEC_T14BR) },
		{ USB_DEVICE(USB_VID_ASUS,      USB_PID_ASUS_U3000) },
		{ USB_DEVICE(USB_VID_ASUS,      USB_PID_ASUS_U3100) },
/* 25 */	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_STICK_3) },
		{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_MYTV_T) },
		{ USB_DEVICE(USB_VID_YUAN, USB_PID_YUAN_EC372S) },
		{ 0 }		/* Terminating entry */
};
MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);

#define DIB0700_DEFAULT_DEVICE_PROPERTIES \
	.caps              = DVB_USB_IS_AN_I2C_ADAPTER, \
	.usb_ctrl          = DEVICE_SPECIFIC, \
	.firmware          = "dvb-usb-dib0700-1.10.fw", \
	.download_firmware = dib0700_download_firmware, \
	.no_reconnect      = 1, \
	.size_of_priv      = sizeof(struct dib0700_state), \
	.i2c_algo          = &dib0700_i2c_algo, \
	.identify_state    = dib0700_identify_state

#define DIB0700_DEFAULT_STREAMING_CONFIG(ep) \
	.streaming_ctrl   = dib0700_streaming_ctrl, \
	.stream = { \
		.type = USB_BULK, \
		.count = 4, \
		.endpoint = ep, \
		.u = { \
			.bulk = { \
				.buffersize = 39480, \
			} \
		} \
	}

struct dvb_usb_device_properties dib0700_devices[] = {
	{
		DIB0700_DEFAULT_DEVICE_PROPERTIES,

		.num_adapters = 1,
		.adapter = {
			{
				.frontend_attach  = stk7700p_frontend_attach,
				.tuner_attach     = stk7700p_tuner_attach,

				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
			},
		},

		.num_device_descs = 8,
		.devices = {
			{   "DiBcom STK7700P reference design",
				{ &dib0700_usb_id_table[0], &dib0700_usb_id_table[1] },
				{ NULL },
			},
			{   "Hauppauge Nova-T Stick",
				{ &dib0700_usb_id_table[4], &dib0700_usb_id_table[9], NULL },
				{ NULL },
			},
			{   "AVerMedia AVerTV DVB-T Volar",
				{ &dib0700_usb_id_table[5], &dib0700_usb_id_table[10] },
				{ NULL },
			},
			{   "Compro Videomate U500",
				{ &dib0700_usb_id_table[6], &dib0700_usb_id_table[19] },
				{ NULL },
			},
			{   "Uniwill STK7700P based (Hama and others)",
				{ &dib0700_usb_id_table[7], NULL },
				{ NULL },
			},
			{   "Leadtek Winfast DTV Dongle (STK7700P based)",
				{ &dib0700_usb_id_table[8], NULL },
				{ NULL },
			},
			{   "AVerMedia AVerTV DVB-T Express",
				{ &dib0700_usb_id_table[20] },
				{ NULL },
			},
			{   "Gigabyte U7000",
				{ &dib0700_usb_id_table[21], NULL },
				{ NULL },
			}
		},

		.rc_interval      = DEFAULT_RC_INTERVAL,
		.rc_key_map       = dib0700_rc_keys,
		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
		.rc_query         = dib0700_rc_query
	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,

		.num_adapters = 2,
		.adapter = {
			{
				.frontend_attach  = bristol_frontend_attach,
				.tuner_attach     = bristol_tuner_attach,

				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
			}, {
				.frontend_attach  = bristol_frontend_attach,
				.tuner_attach     = bristol_tuner_attach,

				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
			}
		},

		.num_device_descs = 1,
		.devices = {
			{   "Hauppauge Nova-T 500 Dual DVB-T",
				{ &dib0700_usb_id_table[2], &dib0700_usb_id_table[3], NULL },
				{ NULL },
			},
		},

		.rc_interval      = DEFAULT_RC_INTERVAL,
		.rc_key_map       = dib0700_rc_keys,
		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
		.rc_query         = dib0700_rc_query
	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,

		.num_adapters = 2,
		.adapter = {
			{
				.frontend_attach  = stk7700d_frontend_attach,
				.tuner_attach     = stk7700d_tuner_attach,

				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
			}, {
				.frontend_attach  = stk7700d_frontend_attach,
				.tuner_attach     = stk7700d_tuner_attach,

				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
			}
		},

		.num_device_descs = 4,
		.devices = {
			{   "Pinnacle PCTV 2000e",
				{ &dib0700_usb_id_table[11], NULL },
				{ NULL },
			},
			{   "Terratec Cinergy DT XS Diversity",
				{ &dib0700_usb_id_table[12], NULL },
				{ NULL },
			},
			{   "Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity",
				{ &dib0700_usb_id_table[13], NULL },
				{ NULL },
			},
			{   "DiBcom STK7700D reference design",
				{ &dib0700_usb_id_table[14], NULL },
				{ NULL },
			}
		},

		.rc_interval      = DEFAULT_RC_INTERVAL,
		.rc_key_map       = dib0700_rc_keys,
		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
		.rc_query         = dib0700_rc_query

	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,

		.num_adapters = 1,
		.adapter = {
			{
				.frontend_attach  = stk7700P2_frontend_attach,
				.tuner_attach     = stk7700d_tuner_attach,

				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
			},
		},

		.num_device_descs = 2,
		.devices = {
			{   "ASUS My Cinema U3000 Mini DVBT Tuner",
				{ &dib0700_usb_id_table[23], NULL },
				{ NULL },
			},
			{   "Yuan EC372S",
				{ &dib0700_usb_id_table[27], NULL },
				{ NULL },
			}
		}
	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,

		.num_adapters = 1,
		.adapter = {
			{
				.frontend_attach  = stk7070p_frontend_attach,
				.tuner_attach     = dib7070p_tuner_attach,

				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),

				.size_of_priv     = sizeof(struct dib0700_adapter_state),
			},
		},

		.num_device_descs = 6,
		.devices = {
			{   "DiBcom STK7070P reference design",
				{ &dib0700_usb_id_table[15], NULL },
				{ NULL },
			},
			{   "Pinnacle PCTV DVB-T Flash Stick",
				{ &dib0700_usb_id_table[16], NULL },
				{ NULL },
			},
			{   "Artec T14BR DVB-T",
				{ &dib0700_usb_id_table[22], NULL },
				{ NULL },
			},
			{   "ASUS My Cinema U3100 Mini DVBT Tuner",
				{ &dib0700_usb_id_table[24], NULL },
				{ NULL },
			},
			{   "Hauppauge Nova-T Stick",
				{ &dib0700_usb_id_table[25], NULL },
				{ NULL },
			},
			{   "Hauppauge Nova-T MyTV.t",
				{ &dib0700_usb_id_table[26], NULL },
				{ NULL },
			},
		},

		.rc_interval      = DEFAULT_RC_INTERVAL,
		.rc_key_map       = dib0700_rc_keys,
		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
		.rc_query         = dib0700_rc_query

	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,

		.num_adapters = 2,
		.adapter = {
			{
				.frontend_attach  = stk7070pd_frontend_attach0,
				.tuner_attach     = dib7070p_tuner_attach,

				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),

				.size_of_priv     = sizeof(struct dib0700_adapter_state),
			}, {
				.frontend_attach  = stk7070pd_frontend_attach1,
				.tuner_attach     = dib7070p_tuner_attach,

				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),

				.size_of_priv     = sizeof(struct dib0700_adapter_state),
			}
		},

		.num_device_descs = 2,
		.devices = {
			{   "DiBcom STK7070PD reference design",
				{ &dib0700_usb_id_table[17], NULL },
				{ NULL },
			},
			{   "Pinnacle PCTV Dual DVB-T Diversity Stick",
				{ &dib0700_usb_id_table[18], NULL },
				{ NULL },
			}
		}
	},
};

int dib0700_device_count = ARRAY_SIZE(dib0700_devices);

--Boundary_(ID_jG5QrK9ozB3XOAbkQSvKDA)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary_(ID_jG5QrK9ozB3XOAbkQSvKDA)--
