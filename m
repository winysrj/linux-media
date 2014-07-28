Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49562 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbaG1QAZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 12:00:25 -0400
Message-ID: <53D67395.4080309@iki.fi>
Date: Mon, 28 Jul 2014 19:00:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bimow Chen <Bimow.Chen@ite.com.tw>, linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: dvb-usb-v2: Update firmware and driver for performance
 of ITEtech IT9135
References: <1406275880.18033.3.camel@ite-desktop>
In-Reply-To: <1406275880.18033.3.camel@ite-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Bimow!
I did a lot of testing today for that patch. I used only single tuner 
device having IT9135 BX chip. Running it against modulator I saw 
sensitivity was increased around 5 dBm (TX power).

However, I am not 100% happy with that patch. See comments below.

On 07/25/2014 11:11 AM, Bimow Chen wrote:
> Fix performance issue of IT9135 AX and BX chip versions.
>
>
> 0001-Update-firmware-and-driver-for-performance-of-ITEtec.patch
>
>
>>From 57fe102419e83e73080af15cc3ad3fe241d7f8b4 Mon Sep 17 00:00:00 2001
> From: Bimow Chen<Bimow.Chen@ite.com.tw>
> Date: Thu, 24 Jul 2014 13:23:39 +0800
> Subject: [PATCH 1/1] Update firmware and driver for performance of ITEtech IT9135
>
> Fix performance issue of IT9135 AX and BX chip versions.
>
> Signed-off-by: Bimow Chen<bimow.chen@ite.com.tw>
> Signed-off-by: Bimow Chen<Bimow.Chen@ite.com.tw>
> ---
>   Documentation/dvb/get_dvb_firmware        |   24 +++++++++++++-----------
>   drivers/media/dvb-frontends/af9033.c      |   18 ++++++++++++++++++
>   drivers/media/dvb-frontends/af9033_priv.h |   20 +++++++++-----------
>   drivers/media/tuners/tuner_it913x.c       |    6 ------
>   drivers/media/usb/dvb-usb-v2/af9035.c     |   11 +++++++++++
>   5 files changed, 51 insertions(+), 28 deletions(-)
>
> diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
> index d91b8be..efa100a 100755
> --- a/Documentation/dvb/get_dvb_firmware
> +++ b/Documentation/dvb/get_dvb_firmware
> @@ -708,23 +708,25 @@ sub drxk_terratec_htc_stick {
>   }
>
>   sub it9135 {
> -	my $sourcefile = "dvb-usb-it9135.zip";
> -	my $url ="http://www.ite.com.tw/uploads/firmware/v3.6.0.0/$sourcefile";
> -	my $hash = "1e55f6c8833f1d0ae067c2bb2953e6a9";
> -	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 0);
> -	my $outfile = "dvb-usb-it9135.fw";
> +	my $url ="http://www.ite.com.tw/uploads/firmware/v3.25.0.0/";
> +	my $file1 = "dvb-usb-it9135-01.zip";
>   	my $fwfile1 = "dvb-usb-it9135-01.fw";
> +	my $hash1 = "02fcf11174eda84745dae7e61c5ff9ba";
> +	my $file2 = "dvb-usb-it9135-02.zip";
>   	my $fwfile2 = "dvb-usb-it9135-02.fw";
> +	my $hash2 = "d5e1437dc24358578e07999475d4cac9";
>
>   	checkstandard();
>
> -	wgetfile($sourcefile, $url);
> -	unzip($sourcefile, $tmpdir);
> -	verify("$tmpdir/$outfile", $hash);
> -	extract("$tmpdir/$outfile", 64, 8128, "$fwfile1");
> -	extract("$tmpdir/$outfile", 12866, 5817, "$fwfile2");
> +	wgetfile($file1, $url . $file1);
> +	unzip($file1, "");
> +	verify("$fwfile1", $hash1);
> +
> +	wgetfile($file2, $url . $file2);
> +	unzip($file2, "");
> +	verify("$fwfile2", $hash2);
>
> -	"$fwfile1 $fwfile2"
> +	"$file1 $file2"
>   }
>
>   sub tda10071 {

Split that get_dvb_firmware stuff to own separate patch.


> diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
> index be4bec2..e96e655 100644
> --- a/drivers/media/dvb-frontends/af9033.c
> +++ b/drivers/media/dvb-frontends/af9033.c
> @@ -274,6 +274,22 @@ static int af9033_init(struct dvb_frontend *fe)
>   		{ 0x800045, state->cfg.adc_multiplier, 0xff },
>   	};
>
> +	/* power up tuner - for performance */
> +	switch (state->cfg.tuner) {
> +	case AF9033_TUNER_IT9135_38:
> +	case AF9033_TUNER_IT9135_51:
> +	case AF9033_TUNER_IT9135_52:
> +	case AF9033_TUNER_IT9135_60:
> +	case AF9033_TUNER_IT9135_61:
> +	case AF9033_TUNER_IT9135_62:
> +		ret = af9033_wr_reg(state, 0x80ec40, 0x1);
> +		ret |= af9033_wr_reg(state, 0x80fba8, 0x0);
> +		ret |= af9033_wr_reg(state, 0x80ec57, 0x0);
> +		ret |= af9033_wr_reg(state, 0x80ec58, 0x0);
> +		if (ret < 0)
> +			goto err;
> +	}
> +

You moved that initialization here from tuner_it913x driver. What I 
understand register range 0xec00 - 0xefff belongs to integrated RF 
tuner. This is demodulator driver and I really like to separate 
functionality as much as possible per correct driver.

I did some testing and find out the actual need here is 0xfba8 register, 
which is needed to set before FSM is triggered. That reg is 0 by 
default, but tuner_it913x driver set it to 1 during sleep.

Name of 0xfba8 register is p_reg_dyn0_clk, which indicates it is some 
sort of clock. I don't have documentation... Maybe it should be 
controlled by demod driver power-management?

All the other registers should just go back to tuner_it913x driver.


>   	/* program clock control */
>   	clock_cw = af9033_div(state, state->cfg.clock, 1000000ul, 19ul);
>   	buf[0] = (clock_cw >>  0) & 0xff;
> @@ -440,6 +456,8 @@ static int af9033_init(struct dvb_frontend *fe)
>   	case AF9033_TUNER_IT9135_61:
>   	case AF9033_TUNER_IT9135_62:
>   		ret = af9033_wr_reg(state, 0x800000, 0x01);
> +		ret |= af9033_wr_reg(state, 0x00d827, 0x00);
> +		ret |= af9033_wr_reg(state, 0x00d829, 0x00);

Useless change. Those registers are already set few lines earlier.

>   		if (ret < 0)
>   			goto err;
>   	}
> diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
> index fc2ad58..ded7b67 100644
> --- a/drivers/media/dvb-frontends/af9033_priv.h
> +++ b/drivers/media/dvb-frontends/af9033_priv.h
> @@ -1418,7 +1418,7 @@ static const struct reg_val tuner_init_it9135_60[] = {
>   	{ 0x800068, 0x0a },
>   	{ 0x80006a, 0x03 },
>   	{ 0x800070, 0x0a },
> -	{ 0x800071, 0x05 },
> +	{ 0x800071, 0x0a },
>   	{ 0x800072, 0x02 },
>   	{ 0x800075, 0x8c },
>   	{ 0x800076, 0x8c },
> @@ -1484,7 +1484,6 @@ static const struct reg_val tuner_init_it9135_60[] = {
>   	{ 0x800104, 0x02 },
>   	{ 0x800105, 0xbe },
>   	{ 0x800106, 0x00 },
> -	{ 0x800109, 0x02 },
>   	{ 0x800115, 0x0a },
>   	{ 0x800116, 0x03 },
>   	{ 0x80011a, 0xbe },
> @@ -1510,7 +1509,6 @@ static const struct reg_val tuner_init_it9135_60[] = {
>   	{ 0x80014b, 0x8c },
>   	{ 0x80014d, 0xac },
>   	{ 0x80014e, 0xc6 },
> -	{ 0x80014f, 0x03 },
>   	{ 0x800151, 0x1e },
>   	{ 0x800153, 0xbc },
>   	{ 0x800178, 0x09 },
> @@ -1522,9 +1520,10 @@ static const struct reg_val tuner_init_it9135_60[] = {
>   	{ 0x80018d, 0x5f },
>   	{ 0x80018f, 0xa0 },
>   	{ 0x800190, 0x5a },
> -	{ 0x80ed02, 0xff },
> -	{ 0x80ee42, 0xff },
> -	{ 0x80ee82, 0xff },
> +	{ 0x800191, 0x00 },
> +	{ 0x80ed02, 0x40 },
> +	{ 0x80ee42, 0x40 },
> +	{ 0x80ee82, 0x40 },
>   	{ 0x80f000, 0x0f },
>   	{ 0x80f01f, 0x8c },
>   	{ 0x80f020, 0x00 },
> @@ -1699,7 +1698,6 @@ static const struct reg_val tuner_init_it9135_61[] = {
>   	{ 0x800104, 0x02 },
>   	{ 0x800105, 0xc8 },
>   	{ 0x800106, 0x00 },
> -	{ 0x800109, 0x02 },
>   	{ 0x800115, 0x0a },
>   	{ 0x800116, 0x03 },
>   	{ 0x80011a, 0xc6 },
> @@ -1725,7 +1723,6 @@ static const struct reg_val tuner_init_it9135_61[] = {
>   	{ 0x80014b, 0x8c },
>   	{ 0x80014d, 0xa8 },
>   	{ 0x80014e, 0xc6 },
> -	{ 0x80014f, 0x03 },
>   	{ 0x800151, 0x28 },
>   	{ 0x800153, 0xcc },
>   	{ 0x800178, 0x09 },
> @@ -1737,9 +1734,10 @@ static const struct reg_val tuner_init_it9135_61[] = {
>   	{ 0x80018d, 0x5f },
>   	{ 0x80018f, 0xfb },
>   	{ 0x800190, 0x5c },
> -	{ 0x80ed02, 0xff },
> -	{ 0x80ee42, 0xff },
> -	{ 0x80ee82, 0xff },
> +	{ 0x800191, 0x00 },
> +	{ 0x80ed02, 0x40 },
> +	{ 0x80ee42, 0x40 },
> +	{ 0x80ee82, 0x40 },
>   	{ 0x80f000, 0x0f },
>   	{ 0x80f01f, 0x8c },
>   	{ 0x80f020, 0x00 },

Those init tables are dumped out from windows driver version 12.07.06.1. 
Windows driver likely has some logic to override those 0xff values... so 
those are programmed wrong and sensitivity was worse. According to tests 
I made, these changes seems to have some good effect for sensitivity.

> diff --git a/drivers/media/tuners/tuner_it913x.c b/drivers/media/tuners/tuner_it913x.c
> index 6f30d7e..eb7e588 100644
> --- a/drivers/media/tuners/tuner_it913x.c
> +++ b/drivers/media/tuners/tuner_it913x.c
> @@ -200,12 +200,6 @@ static int it913x_init(struct dvb_frontend *fe)
>   		}
>   	}
>
> -	/* Power Up Tuner - common all versions */
> -	ret = it913x_wr_reg(state, PRO_DMOD, 0xec40, 0x1);
> -	ret |= it913x_wr_reg(state, PRO_DMOD, 0xfba8, 0x0);
> -	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec57, 0x0);
> -	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec58, 0x0);
> -
>   	return it913x_wr_reg(state, PRO_DMOD, 0xed81, val);
>   }
>
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 7b9b75f..3e212ae 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -602,6 +602,8 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
>   	if (ret < 0)
>   		goto err;
>
> +	msleep(30);
> +

I think that sleep is to avoid error which happens sometimes when device 
is plugged?


>   	/* firmware loaded, request boot */
>   	req.cmd = CMD_FW_BOOT;
>   	ret = af9035_ctrl_msg(d, &req);
> @@ -621,6 +623,15 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
>   		goto err;
>   	}
>
> +	/* tuner RF initial */
> +	if (state->chip_type == 0x9135) {
> +		ret = af9035_wr_reg(d, 0x80ec4c, 0x68);
> +		if (ret < 0)
> +			goto err;
> +
> +		msleep(30);
> +	}
> +

That is also RF tuner register and should go to tuner_it913x driver. Reg 
name is p_reg_t_ctrl, but I have no idea what it is actually. Move it to 
it913x_init() or it913x_attach(), prefer init over attach.

That was the change which has absolutely biggest effect for better 
sensitivity.

>   	dev_info(&d->udev->dev, "%s: firmware version=%d.%d.%d.%d",
>   			KBUILD_MODNAME, rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
>

That kind patches should be split to smaller ones. There was no hard 
relation between the drivers, so you could split needed changes for 4 
patches:
1) get_dvb_firmware()
2) af9035 driver
3) af9033 driver
4) tuner_it913x driver

regards
Antti

-- 
http://palosaari.fi/
