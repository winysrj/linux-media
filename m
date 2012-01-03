Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50106 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab2ACSaI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Jan 2012 13:30:08 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Ri97c-0004nu-L2
	for linux-media@vger.kernel.org; Tue, 03 Jan 2012 19:30:04 +0100
Received: from 173-17-187-188.client.mchsi.com ([173.17.187.188])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 19:30:04 +0100
Received: from richardh68 by 173-17-187-188.client.mchsi.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 19:30:04 +0100
To: linux-media@vger.kernel.org
From: Tim <richardh68@hotmail.com>
Subject: Re: Working on Avermedia Duet A188 (saa716x and lgdt3304)
Date: Tue, 3 Jan 2012 18:05:15 +0000 (UTC)
Message-ID: <loom.20120103T181436-85@post.gmane.org>
References: <518438.15436.qm@web63402.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 I'd like to try this again, as my last working tuner died this week. I've had 
this card sitting around for over
> a year hoping for support, but it doesn't look like anyone else is working on 
it.
> 
> What kind of information is needed to make the card work? Will I need to find 
firmware somewhere? It looks
> like the basics are there with Manu's work on the SAA716x and Jared and 
Michael's work on the LGDT3304, but
> how do I customize these to work with the A188?
> 
> Any help would be appreciated, thanks!
> 
> Oblib
> 
>       
> 

I have been playing with this aswell.. I haven't done C since college.
I hope someone could help us with this..

I have done some leg work here.. 

1) I have contacted Avermedia to see if they will release the source to the 
windows drivers.. Can't hurt to ask.. waiting their response.. it had to be 
referred to R&D department. So it Wasnt No..

2) The actual components on the board are 
2x TDA18271hdc2 in what appears to be a master slave setup(maybe.. Only one coax 
input) 
2x LGDT3304 
1x 60E

3) I have pulled this repository and worked from there..
http://linuxtv.org/hg/~endriss/mirror-saa716x/
I have edited the SAA71x budget Driver so that it recognizes the card and 
the cards rom tells us this..

[    7.154089] SAA7160 ROM: Data=157 bytes
[    7.154090] SAA7160 ROM: Version=1
[    7.154091] SAA7160 ROM: Devices=5
[    7.154092] SAA7160 ROM: Compressed=0
[    7.154092] 
[    7.154388]     SAA7160 ROM: ===== Device 0 =====
[    7.154390]    -----------------------------------------------------
[    7.154400]     10 00 ff ff  02 00 01 00   60 71 00 ff  01 00 1a 00 
[    7.154406]     ff 04 20 00  0c ff ff ff   ff 00 00 00  00 00 00 00 
[    7.154412]     00 02 08 24  0f 00 00 82   00 00 00 
[    7.154416]    -----------------------------------------------------
[    7.154427]     SAA7160 ROM: Device @ 0x7f
[    7.154428]     SAA7160 ROM: Size=16 bytes
[    7.154429]     SAA7160 ROM: Device ID=0x00
[    7.154430]     SAA7160 ROM: Master ID=0xff
[    7.154431]     SAA7160 ROM: Bus ID=0xff
[    7.154432]     SAA7160 ROM: Device type=0x10002
[    7.154433]     SAA7160 ROM: Implementation ID=0x7160
[    7.154434]     SAA7160 ROM: Path ID=0x00
[    7.154435]     SAA7160 ROM: GPIO ID=0xff
[    7.154436]     SAA7160 ROM: Address=1 bytes
[    7.154437]     SAA7160 ROM: Extended data=26 bytes
[    7.154438] 
[    7.154439]         SAA7160 ROM: Found GPIO device
[    7.154440]        -------------------------------------------------
[    7.154449]         04 20 00 0c  ff ff ff ff   00 00 00 00  00 00 00 00 
[    7.154455]        -------------------------------------------------
[    7.154465]         SAA7160 ROM: Size=4 bytes
[    7.154467]         SAA7160 ROM: Pins=32
[    7.154468]         SAA7160 ROM: Ext data=12
[    7.154468] 
[    7.154470]         SAA7160 ROM: Found streaming device
[    7.154471]        -------------------------------------------------
[    7.154480]         02 08 24 0f  00 00 82 00   00 00 
[    7.154484]        -------------------------------------------------
[    7.154494]         SAA7160 ROM: Size=2 bytes
[    7.154495]         SAA7160 ROM: Ext data=8 bytes
[    7.154496] 
[    7.154497]     SAA7160 ROM: ===== Device 1 =====
[    7.154498]    -----------------------------------------------------
[    7.154508]     10 02 00 00  40 00 00 00   87 00 00 00  01 00 14 00 
[    7.154514]     c0 02 12 01  ff 05 ff ff   ff 05 ff ff  ff ff ff ff 
[    7.154519]     ff 8e 06 ff  ff 
[    7.154522]    -----------------------------------------------------
[    7.154532]     SAA7160 ROM: Device @ 0x60
[    7.154533]     SAA7160 ROM: Size=16 bytes
[    7.154534]     SAA7160 ROM: Device ID=0x02
[    7.154535]     SAA7160 ROM: Master ID=0x00
[    7.154536]     SAA7160 ROM: Bus ID=0x00
[    7.154537]     SAA7160 ROM: Device type=0x40
[    7.154538]     SAA7160 ROM: Implementation ID=0x87
[    7.154539]     SAA7160 ROM: Path ID=0x00
[    7.154540]     SAA7160 ROM: GPIO ID=0x00
[    7.154541]     SAA7160 ROM: Address=1 bytes
[    7.154542]     SAA7160 ROM: Extended data=20 bytes
[    7.154543] 
[    7.154544]         SAA7160 ROM: Found Tuner device
[    7.154545]        -------------------------------------------------
[    7.154554]         02 12 01 ff  05 ff ff ff   05 ff ff ff  ff ff ff ff 
[    7.154560]         8e 06 ff ff 
[    7.154562]        -------------------------------------------------
[    7.154572]         SAA7160 ROM: Size=2 bytes
[    7.154573]         SAA7160 ROM: Ext data=18 bytes
[    7.154574] 
[    7.154575] 
[    7.154576]     SAA7160 ROM: ===== Device 2 =====
[    7.154577]    -----------------------------------------------------
[    7.154587]     10 03 00 00  00 01 00 00   87 00 00 00  01 00 03 00 
[    7.154592]     1c 03 08 00 
[    7.154594]    -----------------------------------------------------
[    7.154605]     SAA7160 ROM: Device @ 0x0e
[    7.154606]     SAA7160 ROM: Size=16 bytes
[    7.154607]     SAA7160 ROM: Device ID=0x03
[    7.154608]     SAA7160 ROM: Master ID=0x00
[    7.154609]     SAA7160 ROM: Bus ID=0x00
[    7.154610]     SAA7160 ROM: Device type=0x100
[    7.154611]     SAA7160 ROM: Implementation ID=0x87
[    7.154612]     SAA7160 ROM: Path ID=0x00
[    7.154613]     SAA7160 ROM: GPIO ID=0x00
[    7.154614]     SAA7160 ROM: Address=1 bytes
[    7.154615]     SAA7160 ROM: Extended data=3 bytes
[    7.154616] 
[    7.154617]         SAA7160 ROM: Found Channel Demodulator device
[    7.154618]        -------------------------------------------------
[    7.154627]         03 08 00 
[    7.154629]        -------------------------------------------------
[    7.154639]         SAA7160 ROM: Size=3 bytes
[    7.154640]         SAA7160 ROM: Ext data=0 bytes
[    7.154641] 
[    7.154641] 
[    7.154642]     SAA7160 ROM: ===== Device 3 =====
[    7.154643]    -----------------------------------------------------
[    7.154653]     10 04 00 01  40 00 00 00   87 00 01 00  01 00 14 00 
[    7.154659]     c0 02 12 01  ff 01 ff ff   ff 06 ff ff  ff ff ff ff 
[    7.154664]     ff 8e ff ff  ff 
[    7.154667]    -----------------------------------------------------
[    7.154677]     SAA7160 ROM: Device @ 0x60
[    7.154678]     SAA7160 ROM: Size=16 bytes
[    7.154679]     SAA7160 ROM: Device ID=0x04
[    7.154680]     SAA7160 ROM: Master ID=0x00
[    7.154681]     SAA7160 ROM: Bus ID=0x01
[    7.154682]     SAA7160 ROM: Device type=0x40
[    7.154683]     SAA7160 ROM: Implementation ID=0x87
[    7.154684]     SAA7160 ROM: Path ID=0x01
[    7.154685]     SAA7160 ROM: GPIO ID=0x00
[    7.154686]     SAA7160 ROM: Address=1 bytes
[    7.154688]     SAA7160 ROM: Extended data=20 bytes
[    7.154688] 
[    7.154689]         SAA7160 ROM: Found Tuner device
[    7.154690]        -------------------------------------------------
[    7.154699]         02 12 01 ff  01 ff ff ff   06 ff ff ff  ff ff ff ff 
[    7.154705]         8e ff ff ff 
[    7.154707]        -------------------------------------------------
[    7.154717]         SAA7160 ROM: Size=2 bytes
[    7.154718]         SAA7160 ROM: Ext data=18 bytes
[    7.154719] 
[    7.154719] 
[    7.154720]     SAA7160 ROM: ===== Device 4 =====
[    7.154721]    -----------------------------------------------------
[    7.154731]     10 05 00 01  00 01 00 00   87 00 01 00  01 00 03 00 
[    7.154737]     1c 03 06 00 
[    7.154739]    -----------------------------------------------------
[    7.154749]     SAA7160 ROM: Device @ 0x0e
[    7.154750]     SAA7160 ROM: Size=16 bytes
[    7.154751]     SAA7160 ROM: Device ID=0x05
[    7.154752]     SAA7160 ROM: Master ID=0x00
[    7.154753]     SAA7160 ROM: Bus ID=0x01
[    7.154754]     SAA7160 ROM: Device type=0x100
[    7.154755]     SAA7160 ROM: Implementation ID=0x87
[    7.154756]     SAA7160 ROM: Path ID=0x01
[    7.154757]     SAA7160 ROM: GPIO ID=0x00
[    7.154758]     SAA7160 ROM: Address=1 bytes
[    7.154759]     SAA7160 ROM: Extended data=3 bytes
[    7.154760] 
[    7.154761]         SAA7160 ROM: Found Channel Demodulator device
[    7.154762]        -------------------------------------------------
[    7.154771]         03 06 00 
[    7.154773]        -------------------------------------------------
[    7.154783]         SAA7160 ROM: Size=3 bytes
[    7.154784]         SAA7160 ROM: Ext data=0 bytes
[    7.154785] 

Currently I I am trying to attach the lgdt3304 at i2c address 0x0e  on bus A 
then try to attach the tda1827hdc2.. but the lgdt3304 never attaches


Here is what I have so far
#define SAA716x_MODEL_A188_DUET				"Aver Duet"
#define SAA716x_DEV_A188_DUET		"2x DVB-C"

static struct tda18271_std_map averduet_std_map = {
	.atsc_6   = { .if_freq = 3250, .agc_mode = 3, .std = 0,
		      .if_lvl = 1, .rfagc_top = 0x37, },
	.qam_6    = { .if_freq = 4000, .agc_mode = 3, .std = 1,
		      .if_lvl = 1, .rfagc_top = 0x37, },
};

static struct tda18271_config averduet_tda_config = {
	.std_map           = &averduet_std_map,
};

static struct lgdt3305_config averduet_lgdt3304_dev = {
	.i2c_addr           = 0x0e,
	.demod_chip         = LGDT3304,
	.spectral_inversion = 1,
	.deny_i2c_rptr      = 1,
	.mpeg_mode          = LGDT3305_MPEG_PARALLEL,
	.tpclk_edge         = LGDT3305_TPCLK_FALLING_EDGE,
	.tpvalid_polarity   = LGDT3305_TP_VALID_HIGH,
	.vsb_if_khz         = 3250,
	.qam_if_khz         = 4000,
};

static int averduet_frontend_attach(struct saa716x_adapter *adapter,
					       int count)
{
	struct saa716x_dev *saa716x = adapter->saa716x;
	struct saa716x_i2c *demod_i2c = &saa716x->i2c[SAA716x_I2C_BUS_A];
	struct saa716x_i2c *tuner_i2c = &saa716x->i2c[SAA716x_I2C_BUS_A];


	if (count < saa716x->config->adapters) {
		dprintk(SAA716x_DEBUG, 1, "Adapter (%d) SAA716x frontend Init",
			count);
		dprintk(SAA716x_DEBUG, 1, "Adapter (%d) Device ID=%02x", count,
			saa716x->pdev->subsystem_device);

		saa716x_gpio_set_output(saa716x, 14);

		/* Reset the demodulator */
		saa716x_gpio_write(saa716x, 14, 1);
		msleep(10);
		saa716x_gpio_write(saa716x, 14, 0);
		msleep(10);
		saa716x_gpio_write(saa716x, 14, 1);
		msleep(100);
		


		dprintk(SAA716x_ERROR, 1, "looking lgdt3304 @0x%02x",
				averduet_lgdt3304_dev.i2c_addr);
		adapter->fe = dvb_attach(lgdt3305_attach,
							   
&averduet_lgdt3304_dev,
							   &demod_i2c-
>i2c_adapter);


		if (adapter->fe) {

			dvb_attach(tda18271_attach, adapter->fe, 0x60,
				   &tuner_i2c->i2c_adapter, 
&averduet_tda_config);

		} else {
			goto exit;
		}



		if (1) {
			dprintk(SAA716x_NOTICE, 1, "found lgdt3304 @0x%02x",
					averduet_lgdt3304_dev.i2c_addr);



			/* call the init function once to initialize
			   tuner's clock output divider and demod's
			   master clock */
			if (adapter->fe->ops.init)
				adapter->fe->ops.init(adapter->fe);
		} else {
			goto exit;
		}

		dprintk(SAA716x_ERROR, 1, "Done!");
		return 0;
	}
exit:
	dprintk(SAA716x_ERROR, 1, "Frontend attach failed");
	return -ENODEV;
}

static struct saa716x_config averduet_config = {
	.model_name		= SAA716x_MODEL_A188_DUET,
	.dev_type		= SAA716x_DEV_A188_DUET,
	.boot_mode		= SAA716x_EXT_BOOT,
	.adapters		= 1,
	.frontend_attach	= averduet_frontend_attach,
	.irq_handler		= saa716x_budget_pci_irq,
	.i2c_rate		= SAA716x_I2C_RATE_100
};




Thank you for your help

Tim






