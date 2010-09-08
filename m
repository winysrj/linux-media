Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34892 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab0IHVIk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 17:08:40 -0400
Received: by yxp4 with SMTP id 4so296250yxp.19
        for <linux-media@vger.kernel.org>; Wed, 08 Sep 2010 14:08:39 -0700 (PDT)
Message-ID: <4C87FB59.7030707@gmail.com>
Date: Wed, 08 Sep 2010 18:08:41 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] added support for DM040832731 DVB-S USB BOX - Correction
References: <AANLkTilIWY_jHqRQwejiP4-jkQBwFQjDMgH1riH7rsyq@mail.gmail.com> <4C51C58D.5060404@redhat.com>
In-Reply-To: <4C51C58D.5060404@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 29-07-2010 15:16, Mauro Carvalho Chehab escreveu:
> Em 16-07-2010 10:43, Malcolm Priestley escreveu:
>> DVB USB Driver for DM04 LME2510 + LG TDQY - P001F =(TDA8263 + TDA10086H)
>>
>> Corrected patch error.
>>
>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> 
> Hi Malcom,
> 
> Please read the developers section of our Wiki page for instructions on how to submit
> a driver:
> 	http://linuxtv.org/wiki/index.php/Developer_Section
> 
> In special, you need to read what's inside "Submiting your work" in order to fix some
> troubles I identified on your driver.

Not sure why, but I lost the email where you submitted your new driver on my inbox. I got it
from patchwork and applied.

Em 08-09-2010 18:01, Mauro Carvalho Chehab escreveu:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media-tree.git tree:
> 
> Subject: V4L/DVB: Support or LME2510(C) DM04/QQBOX USB DVB-S BOXES
> Author:  Malcolm Priestley <tvboxspy@gmail.com>
> Date:    Thu Sep 2 17:29:30 2010 -0300
> 
> DM04/QQBOX DVB-S USB BOX with LME2510C+SHARP:BS2F7HZ7395 or LME2510+LGTDQT-P001F tuner.
> 
> [mchehab@redhat.com: Fix merge conflicts/compilation and CodingStyle issues]

There were some API changes at USB, and a few trivial CodingStyle issues.

I didn't double checked if all those patchwork patches you've mentioned were applied. For sure
I've applied the other patch from you adding the frontend.

Please double check if everything is ok and ping me, if I missed something.

> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  Documentation/dvb/get_dvb_firmware    |   46 ++-
>  Documentation/dvb/lmedm04.txt         |   55 ++
>  drivers/media/IR/keymaps/Makefile     |    1 +
>  drivers/media/IR/keymaps/rc-lme2510.c |   68 +++
>  drivers/media/dvb/dvb-usb/Kconfig     |   11 +
>  drivers/media/dvb/dvb-usb/Makefile    |    3 +
>  drivers/media/dvb/dvb-usb/lmedm04.c   |  936 +++++++++++++++++++++++++++++++++
>  drivers/media/dvb/dvb-usb/lmedm04.h   |  187 +++++++
>  include/media/rc-map.h                |    1 +
>  9 files changed, 1307 insertions(+), 1 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media-tree.git?a=commitdiff;h=0a11672a8a3431296ed99be16e7cb57bc004e080
> 
> diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
> index 350959f..59690de 100644
> --- a/Documentation/dvb/get_dvb_firmware
> +++ b/Documentation/dvb/get_dvb_firmware
> @@ -26,7 +26,8 @@ use IO::Handle;
>  		"dec3000s", "vp7041", "dibusb", "nxt2002", "nxt2004",
>  		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
>  		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
> -		"af9015", "ngene", "az6027");
> +		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
> +		"lme2510c_s7395_old");
>  
>  # Check args
>  syntax() if (scalar(@ARGV) != 1);
> @@ -584,6 +585,49 @@ sub az6027{
>  
>      $firmware;
>  }
> +
> +sub lme2510_lg {
> +    my $sourcefile = "LMEBDA_DVBS.sys";
> +    my $hash = "fc6017ad01e79890a97ec53bea157ed2";
> +    my $outfile = "dvb-usb-lme2510-lg.fw";
> +    my $hasho = "caa065d5fdbd2c09ad57b399bbf55cad";
> +
> +    checkstandard();
> +
> +    verify($sourcefile, $hash);
> +    extract($sourcefile, 4168, 3841, $outfile);
> +    verify($outfile, $hasho);
> +    $outfile;
> +}
> +
> +sub lme2510c_s7395 {
> +    my $sourcefile = "US2A0D.sys";
> +    my $hash = "b0155a8083fb822a3bd47bc360e74601";
> +    my $outfile = "dvb-usb-lme2510c-s7395.fw";
> +    my $hasho = "3a3cf1aeebd17b6ddc04cebe131e94cf";
> +
> +    checkstandard();
> +
> +    verify($sourcefile, $hash);
> +    extract($sourcefile, 37248, 3720, $outfile);
> +    verify($outfile, $hasho);
> +    $outfile;
> +}
> +
> +sub lme2510c_s7395_old {
> +    my $sourcefile = "LMEBDA_DVBS7395C.sys";
> +    my $hash = "7572ae0eb9cdf91baabd7c0ba9e09b31";
> +    my $outfile = "dvb-usb-lme2510c-s7395.fw";
> +    my $hasho = "90430c5b435eb5c6f88fd44a9d950674";
> +
> +    checkstandard();
> +
> +    verify($sourcefile, $hash);
> +    extract($sourcefile, 4208, 3881, $outfile);
> +    verify($outfile, $hasho);
> +    $outfile;
> +}
> +
>  # ---------------------------------------------------------------
>  # Utilities
>  
> diff --git a/Documentation/dvb/lmedm04.txt b/Documentation/dvb/lmedm04.txt
> new file mode 100644
> index 0000000..4bde457
> --- /dev/null
> +++ b/Documentation/dvb/lmedm04.txt
> @@ -0,0 +1,55 @@
> +To extract firmware for the DM04/QQBOX you need to copy the
> +following file(s) to this directory.
> +
> +for DM04+/QQBOX LME2510C (Sharp 7395 Tuner)
> +-------------------------------------------
> +
> +The Sharp 7395 driver can be found in windows/system32/driver
> +
> +US2A0D.sys (dated 17 Mar 2009)
> +
> +
> +and run
> +./get_dvb_firmware lme2510c_s7395
> +
> +	will produce
> +	dvb-usb-lme2510c-s7395.fw
> +
> +An alternative but older firmware can be found on the driver
> +disk DVB-S_EN_3.5A in BDADriver/driver
> +
> +LMEBDA_DVBS7395C.sys (dated 18 Jan 2008)
> +
> +and run
> +./get_dvb_firmware lme2510c_s7395_old
> +
> +	will produce
> +	dvb-usb-lme2510c-s7395.fw
> +
> +--------------------------------------------------------------------
> +
> +The LG firmware can be found on the driver
> +disk DM04+_5.1A[LG] in BDADriver/driver
> +
> +for DM04 LME2510 (LG Tuner)
> +---------------------------
> +
> +LMEBDA_DVBS.sys (dated 13 Nov 2007)
> +
> +and run
> +./get_dvb_firmware lme2510_lg
> +
> +	will produce
> +	dvb-usb-lme2510-lg.fw
> +
> +
> +Other LG firmware can be extracted manually from US280D.sys
> +only found in windows/system32/driver.
> +However, this firmware does not run very well under Windows
> +or with the Linux driver.
> +
> +dd if=US280D.sys ibs=1 skip=36856 count=3976 of=dvb-usb-lme2510-lg.fw
> +
> +---------------------------------------------------------------------
> +
> +Copy the firmware file(s) to /lib/firmware
> diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
> index c032b9d..f755b21 100644
> --- a/drivers/media/IR/keymaps/Makefile
> +++ b/drivers/media/IR/keymaps/Makefile
> @@ -39,6 +39,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
>  			rc-kworld-315u.o \
>  			rc-kworld-plus-tv-analog.o \
>  			rc-lirc.o \
> +			rc-lme2510.o \
>  			rc-manli.o \
>  			rc-msi-tvanywhere.o \
>  			rc-msi-tvanywhere-plus.o \
> diff --git a/drivers/media/IR/keymaps/rc-lme2510.c b/drivers/media/IR/keymaps/rc-lme2510.c
> new file mode 100644
> index 0000000..40dcf0b
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-lme2510.c
> @@ -0,0 +1,68 @@
> +/* LME2510 remote control
> + *
> + *
> + * Copyright (C) 2010 Malcolm Priestley (tvboxspy@gmail.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <media/rc-map.h>
> +
> +
> +static struct ir_scancode lme2510_rc[] = {
> +	{ 0xba45, KEY_0 },
> +	{ 0xa05f, KEY_1 },
> +	{ 0xaf50, KEY_2 },
> +	{ 0xa25d, KEY_3 },
> +	{ 0xbe41, KEY_4 },
> +	{ 0xf50a, KEY_5 },
> +	{ 0xbd42, KEY_6 },
> +	{ 0xb847, KEY_7 },
> +	{ 0xb649, KEY_8 },
> +	{ 0xfa05, KEY_9 },
> +	{ 0xbc43, KEY_POWER },
> +	{ 0xb946, KEY_SUBTITLE },
> +	{ 0xf906, KEY_PAUSE },
> +	{ 0xfc03, KEY_MEDIA_REPEAT},
> +	{ 0xfd02, KEY_PAUSE },
> +	{ 0xa15e, KEY_VOLUMEUP },
> +	{ 0xa35c, KEY_VOLUMEDOWN },
> +	{ 0xf609, KEY_CHANNELUP },
> +	{ 0xe51a, KEY_CHANNELDOWN },
> +	{ 0xe11e, KEY_PLAY },
> +	{ 0xe41b, KEY_ZOOM },
> +	{ 0xa659, KEY_MUTE },
> +	{ 0xa55a, KEY_TV },
> +	{ 0xe718, KEY_RECORD },
> +	{ 0xf807, KEY_EPG },
> +	{ 0xfe01, KEY_STOP },
> +
> +};
> +
> +static struct rc_keymap lme2510_map = {
> +	.map = {
> +		.scan    = lme2510_rc,
> +		.size    = ARRAY_SIZE(lme2510_rc),
> +		.ir_type = IR_TYPE_UNKNOWN,
> +		.name    = RC_MAP_LME2510,
> +	}
> +};
> +
> +static int __init init_rc_lme2510_map(void)
> +{
> +	return ir_register_map(&lme2510_map);
> +}
> +
> +static void __exit exit_rc_lme2510_map(void)
> +{
> +	ir_unregister_map(&lme2510_map);
> +}
> +
> +module_init(init_rc_lme2510_map)
> +module_exit(exit_rc_lme2510_map)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
> index c57f828..4734ec0 100644
> --- a/drivers/media/dvb/dvb-usb/Kconfig
> +++ b/drivers/media/dvb/dvb-usb/Kconfig
> @@ -347,3 +347,14 @@ config DVB_USB_AZ6027
>  	select DVB_STB6100 if !DVB_FE_CUSTOMISE
>  	help
>  	  Say Y here to support the AZ6027 device
> +
> +config DVB_USB_LME2510
> +	tristate "LME DM04/QQBOX DVB-S USB2.0 support"
> +	depends on DVB_USB
> +	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
> +	select DVB_TDA826X if !DVB_FE_CUSTOMISE
> +	select DVB_STV0288 if !DVB_FE_CUSTOMISE
> +	select DVB_IX2505V if !DVB_FE_CUSTOMISE
> +	depends on IR_CORE
> +	help
> +	  Say Y here to support the LME DM04/QQBOX DVB-S USB2.0 .
> diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
> index 1a19245..5b1d12f 100644
> --- a/drivers/media/dvb/dvb-usb/Makefile
> +++ b/drivers/media/dvb/dvb-usb/Makefile
> @@ -88,6 +88,9 @@ obj-$(CONFIG_DVB_USB_EC168) += dvb-usb-ec168.o
>  dvb-usb-az6027-objs = az6027.o
>  obj-$(CONFIG_DVB_USB_AZ6027) += dvb-usb-az6027.o
>  
> +dvb-usb-lmedm04-objs = lmedm04.o
> +obj-$(CONFIG_DVB_USB_LME2510) += dvb-usb-lmedm04.o
> +
>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
>  # due to tuner-xc3028
>  EXTRA_CFLAGS += -Idrivers/media/common/tuners
> diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> new file mode 100644
> index 0000000..d5374ac
> --- /dev/null
> +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> @@ -0,0 +1,936 @@
> +/* DVB USB compliant linux driver for
> + *
> + * DM04/QQBOX DVB-S USB BOX	LME2510C + SHARP:BS2F7HZ7395
> + *				LME2510 + LGTDQT-P001F
> + *
> + * MVB7395 (LME2510C+SHARP:BS2F7HZ7395)
> + * SHARP:BS2F7HZ7395 = (STV0288+Sharp IX2505V)
> + *
> + * MV001F (LME2510 +LGTDQY-P001F)
> + * LG TDQY - P001F =(TDA8263 + TDA10086H)
> + *
> + * For firmware see Documentation/dvb/lmedm04.txt
> + *
> + * I2C addresses:
> + * 0xd0 - STV0288	- Demodulator
> + * 0xc0 - Sharp IX2505V	- Tuner
> + * --or--
> + * 0x1c - TDA10086   - Demodulator
> + * 0xc0 - TDA8263    - Tuner
> + *
> + * ***Please Note***
> + *		There are other variants of the DM04
> + *		***NOT SUPPORTED***
> + *		MVB0001F (LME2510C+LGTDQT-P001F)
> + *		MV0194 (LME2510+SHARP0194)
> + *		MVB0194 (LME2510C+SHARP0194)
> + *
> + *
> + * VID = 3344  PID LME2510=1122 LME2510C=1120
> + *
> + * Copyright (C) 2010 Malcolm Priestley (tvboxspy@gmail.com)
> + * LME2510(C)(C) Leaguerme (Shenzhen) MicroElectronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License Version 2, as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + *
> + * see Documentation/dvb/README.dvb-usb for more information
> + *
> + * Known Issues :
> + *	LME2510: Non Intel USB chipsets fail to maintain High Speed on
> + * Boot or Hot Plug.
> + *
> + *	DiSEqC functions are not fully supported in this driver. The main
> + * reason is the frontend is cut off during streaming. Allowing frontend
> + * access will stall the driver. Applications that attempt to this, the
> + * commands are ignored.
> + *
> + *	PID functions have been removed from this driver version due to
> + * problems with different firmware and application versions.
> + */
> +#define DVB_USB_LOG_PREFIX "LME2510(C)"
> +#include <linux/usb.h>
> +#include <linux/usb/input.h>
> +#include <media/ir-core.h>
> +
> +#include "dvb-usb.h"
> +#include "lmedm04.h"
> +#include "tda826x.h"
> +#include "tda10086.h"
> +#include "stv0288.h"
> +#include "ix2505v.h"
> +
> +
> +
> +/* debug */
> +static int dvb_usb_lme2510_debug;
> +#define l_dprintk(var, level, args...) do { \
> +	if ((var >= level)) \
> +		printk(KERN_DEBUG DVB_USB_LOG_PREFIX ": " args); \
> +} while (0)
> +
> +#define deb_info(level, args...) l_dprintk(dvb_usb_lme2510_debug, level, args)
> +#define debug_data_snipet(level, name, p) \
> +	 deb_info(level, name" (%02x%02x%02x%02x%02x%02x%02x%02x)", \
> +		*p, *(p+1), *(p+2), *(p+3), *(p+4), \
> +			*(p+5), *(p+6), *(p+7));
> +
> +
> +module_param_named(debug, dvb_usb_lme2510_debug, int, 0644);
> +MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able))."
> +			DVB_USB_DEBUG_STATUS);
> +
> +DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> +#define TUNER_LG 0x1
> +#define TUNER_S7395 0x2
> +
> +struct lme2510_state {
> +	u8 id;
> +	u8 tuner_config;
> +	u8 signal_lock;
> +	u8 signal_level;
> +	u8 signal_sn;
> +	u8 time_key;
> +	u8 i2c_talk_onoff;
> +	u8 i2c_gate;
> +	u8 i2c_tuner_gate_w;
> +	u8 i2c_tuner_gate_r;
> +	u8 i2c_tuner_addr;
> +	void *buffer;
> +	struct urb *lme_urb;
> +	void *usb_buffer;
> +
> +};
> +
> +static int lme2510_bulk_write(struct usb_device *dev,
> +				u8 *snd, int len, u8 pipe)
> +{
> +	int ret, actual_l;
> +	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, pipe),
> +				snd, len , &actual_l, 500);
> +	return ret;
> +}
> +
> +static int lme2510_bulk_read(struct usb_device *dev,
> +				u8 *rev, int len, u8 pipe)
> +{
> +	int ret, actual_l;
> +
> +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, pipe),
> +				 rev, len , &actual_l, 500);
> +	return ret;
> +}
> +
> +static int lme2510_usb_talk(struct dvb_usb_device *d,
> +		u8 *wbuf, int wlen, u8 *rbuf, int rlen)
> +{
> +	struct lme2510_state *st = d->priv;
> +	u8 *buff;
> +	int ret = 0;
> +
> +	if (st->usb_buffer == NULL) {
> +		st->usb_buffer = kmalloc(512, GFP_KERNEL);
> +		if (st->usb_buffer == NULL) {
> +			info("MEM Error no memory");
> +			return -ENOMEM;
> +		}
> +	}
> +	buff = st->usb_buffer;
> +
> +	/* the read/write capped at 512 */
> +	memcpy(buff, wbuf, (wlen > 512) ? 512 : wlen);
> +
> +
> +	ret = mutex_lock_interruptible(&d->usb_mutex);
> +
> +	if (ret < 0)
> +		return -EAGAIN;
> +
> +	ret |= usb_clear_halt(d->udev, usb_sndbulkpipe(d->udev, 0x01));
> +	msleep(5);
> +	ret |= lme2510_bulk_write(d->udev, buff, wlen , 0x1);
> +
> +	msleep(5);
> +	ret |= usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x1));
> +
> +	msleep(5);
> +	ret |= lme2510_bulk_read(d->udev, buff, (rlen > 512) ?
> +			512 : rlen , 0x1);
> +
> +	if (rlen > 0)
> +		memcpy(rbuf, buff, rlen);
> +
> +	mutex_unlock(&d->usb_mutex);
> +
> +	return (ret < 0) ? -ENODEV : 0;
> +}
> +
> +static int lme2510_remote_keypress(struct dvb_usb_adapter *adap, u16 keypress)
> +{
> +	struct dvb_usb_device *d = adap->dev;
> +
> +	deb_info(1, "INT Key Keypress =%04x", keypress);
> +
> +	if (keypress > 0)
> +		ir_keydown(d->rc_input_dev, keypress, 0);
> +
> +	return 0;
> +}
> +
> +static void lme2510_int_response(struct urb *lme_urb)
> +{
> +	struct dvb_usb_adapter *adap = lme_urb->context;
> +	struct lme2510_state *st = adap->dev->priv;
> +	static u8 *ibuf, *rbuf;
> +	int i = 0, offset;
> +
> +	switch (lme_urb->status) {
> +	case 0:
> +	case -ETIMEDOUT:
> +		break;
> +	case -ECONNRESET:
> +	case -ENOENT:
> +	case -ESHUTDOWN:
> +		return;
> +	default:
> +		info("Error %x", lme_urb->status);
> +		break;
> +	}
> +
> +	rbuf = (u8 *) lme_urb->transfer_buffer;
> +
> +	offset = ((lme_urb->actual_length/8) > 4)
> +			? 4 : (lme_urb->actual_length/8) ;
> +
> +
> +	for (i = 0; i < offset; ++i) {
> +		ibuf = (u8 *)&rbuf[i*8];
> +		deb_info(5, "INT O/S C =%02x C/O=%02x Type =%02x%02x",
> +		offset, i, ibuf[0], ibuf[1]);
> +
> +		switch (ibuf[0]) {
> +		case 0xaa:
> +			debug_data_snipet(1, "INT Remote data snipet in", ibuf);
> +			lme2510_remote_keypress(adap,
> +				(u16)(ibuf[4]<<8)+ibuf[5]);
> +			break;
> +		case 0xbb:
> +			switch (st->tuner_config) {
> +			case TUNER_LG:
> +				st->signal_lock = ibuf[2];
> +				st->signal_level = ibuf[4];
> +				st->signal_sn = ibuf[3];
> +				st->time_key = ibuf[7];
> +				break;
> +			case TUNER_S7395:
> +				/* Tweak for earlier firmware*/
> +				if (ibuf[1] == 0x03) {
> +					st->signal_level = ibuf[3];
> +					st->signal_sn = ibuf[2];
> +				} else {
> +					st->signal_level = ibuf[4];
> +					st->signal_sn = ibuf[5];
> +				}
> +				break;
> +			default:
> +				break;
> +			}
> +			debug_data_snipet(5, "INT Remote data snipet in", ibuf);
> +		break;
> +		case 0xcc:
> +			debug_data_snipet(1, "INT Control data snipet", ibuf);
> +			break;
> +		default:
> +			debug_data_snipet(1, "INT Unknown data snipet", ibuf);
> +		break;
> +		}
> +	}
> +	usb_submit_urb(lme_urb, GFP_ATOMIC);
> +}
> +
> +static int lme2510_int_read(struct dvb_usb_adapter *adap)
> +{
> +	struct lme2510_state *lme_int = adap->dev->priv;
> +
> +	lme_int->lme_urb = usb_alloc_urb(0, GFP_ATOMIC);
> +
> +	if (lme_int->lme_urb == NULL)
> +			return -ENOMEM;
> +
> +	lme_int->buffer = usb_alloc_coherent(adap->dev->udev, 5000, GFP_ATOMIC,
> +					&lme_int->lme_urb->transfer_dma);
> +
> +	if (lme_int->buffer == NULL)
> +			return -ENOMEM;
> +
> +	usb_fill_int_urb(lme_int->lme_urb,
> +				adap->dev->udev,
> +				usb_rcvintpipe(adap->dev->udev, 0xa),
> +				lme_int->buffer,
> +				4096,
> +				lme2510_int_response,
> +				adap,
> +				11);
> +
> +	lme_int->lme_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +	usb_submit_urb(lme_int->lme_urb, GFP_ATOMIC);
> +	info("INT Interupt Service Started");
> +
> +	return 0;
> +}
> +
> +static int lme2510_return_status(struct usb_device *dev)
> +{
> +	int ret = 0;
> +	u8 data[10] = {0};
> +	ret |= usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
> +			0x06, 0x80, 0x0302, 0x00, data, 0x0006, 200);
> +	info("Firmware Status: %x (%x)", ret , data[2]);
> +
> +	return (ret < 0) ? -ENODEV : data[2];
> +}
> +
> +static int lme2510_msg(struct dvb_usb_device *d,
> +		u8 *wbuf, int wlen, u8 *rbuf, int rlen)
> +{
> +	int ret = 0;
> +	struct lme2510_state *st = d->priv;
> +
> +	if (st->i2c_talk_onoff == 1) {
> +		if ((wbuf[2] == 0x1c) & (wbuf[3] == 0x0e))
> +			msleep(80); /*take your time when waiting for tune*/
> +
> +		if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
> +			return -EAGAIN;
> +
> +		ret = lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
> +
> +		mutex_unlock(&d->i2c_mutex);
> +		switch (st->tuner_config) {
> +		case TUNER_S7395:
> +			if (wbuf[3] == 0x24)
> +				st->signal_lock = rbuf[1];
> +			break;
> +		default:
> +			break;
> +		}
> +
> +	} else {
> +		switch (st->tuner_config) {
> +		case TUNER_LG:
> +			switch (wbuf[3]) {
> +			case 0x0e:
> +				rbuf[0] = 0x55;
> +				rbuf[1] = st->signal_lock;
> +				break;
> +			case 0x43:
> +				rbuf[0] = 0x55;
> +				rbuf[1] = st->signal_level;
> +				break;
> +			case 0x1c:
> +				rbuf[0] = 0x55;
> +				rbuf[1] = st->signal_sn;
> +				break;
> +			default:
> +				break;
> +			}
> +			break;
> +		case TUNER_S7395:
> +			switch (wbuf[3]) {
> +			case 0x10:
> +				rbuf[0] = 0x55;
> +				rbuf[1] = (st->signal_level & 0x80)
> +						? 0 : (st->signal_level * 2);
> +				break;
> +			case 0x2d:
> +				rbuf[0] = 0x55;
> +				rbuf[1] = st->signal_sn;
> +				break;
> +			case 0x24:
> +				rbuf[0] = 0x55;
> +				rbuf[1] = (st->signal_level & 0x80)
> +						? 0 : st->signal_lock;
> +			default:
> +				break;
> +			}
> +			break;
> +		default:
> +			break;
> +
> +		}
> +
> +		deb_info(4, "I2C From Interupt Message out(%02x) in(%02x)",
> +				wbuf[3], rbuf[1]);
> +
> +	}
> +
> +	return ret;
> +}
> +
> +
> +static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
> +				 int num)
> +{
> +	struct dvb_usb_device *d = i2c_get_adapdata(adap);
> +	struct lme2510_state *st = d->priv;
> +	static u8 obuf[64], ibuf[512];
> +	int i, read, read_o;
> +	u16 len;
> +	u8 gate = st->i2c_gate;
> +
> +	if (gate == 0)
> +		gate = 5;
> +
> +	if (num > 2)
> +		warn("more than 2 i2c messages"
> +			"at a time is not handled yet.	TODO.");
> +
> +	for (i = 0; i < num; i++) {
> +		read_o = 1 & (msg[i].flags & I2C_M_RD);
> +		read = i+1 < num && (msg[i+1].flags & I2C_M_RD);
> +		read |= read_o;
> +		gate = (msg[i].addr == st->i2c_tuner_addr)
> +			? (read)	? st->i2c_tuner_gate_r
> +					: st->i2c_tuner_gate_w
> +			: st->i2c_gate;
> +		obuf[0] = gate | (read << 7);
> +
> +		if (gate == 5)
> +			obuf[1] = (read) ? 2 : msg[i].len + 1;
> +		else
> +			obuf[1] = msg[i].len + read + 1;
> +
> +		obuf[2] = msg[i].addr;
> +		if (read) {
> +			if (read_o)
> +				len = 3;
> +			else {
> +				memcpy(&obuf[3], msg[i].buf, msg[i].len);
> +				obuf[msg[i].len+3] = msg[i+1].len;
> +				len = msg[i].len+4;
> +			}
> +		} else {
> +			memcpy(&obuf[3], msg[i].buf, msg[i].len);
> +			len = msg[i].len+3;
> +		}
> +
> +		if (lme2510_msg(d, obuf, len, ibuf, 512) < 0) {
> +			deb_info(1, "i2c transfer failed.");
> +			return -EAGAIN;
> +		}
> +
> +		if (read) {
> +			if (read_o)
> +				memcpy(msg[i].buf, &ibuf[1], msg[i].len);
> +			else {
> +				memcpy(msg[i+1].buf, &ibuf[1], msg[i+1].len);
> +				i++;
> +			}
> +		}
> +	}
> +	return i;
> +}
> +
> +static u32 lme2510_i2c_func(struct i2c_adapter *adapter)
> +{
> +	return I2C_FUNC_I2C;
> +}
> +
> +static struct i2c_algorithm lme2510_i2c_algo = {
> +	.master_xfer   = lme2510_i2c_xfer,
> +	.functionality = lme2510_i2c_func,
> +};
> +
> +/* Callbacks for DVB USB */
> +static int lme2510_identify_state(struct usb_device *udev,
> +		struct dvb_usb_device_properties *props,
> +		struct dvb_usb_device_description **desc,
> +		int *cold)
> +{
> +	if (lme2510_return_status(udev) == 0x44)
> +		*cold = 1;
> +	else
> +		*cold = 0;
> +	return 0;
> +}
> +
> +static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
> +{
> +	struct lme2510_state *st = adap->dev->priv;
> +	static u8 reset[] =  LME_RESET;
> +	static u8 stream_on[] = LME_ST_ON_W;
> +	static u8 clear_reg_3[] =  LME_CLEAR_PID;
> +	static u8 rbuf[1];
> +	int ret = 0, len = 2, rlen = sizeof(rbuf);
> +
> +	deb_info(1, "STM  (%02x)", onoff);
> +
> +	if (onoff == 1)	{
> +		st->i2c_talk_onoff = 0;
> +		msleep(400); /* give enough time for i2c to stop */
> +		ret |= lme2510_usb_talk(adap->dev,
> +				 stream_on,  len, rbuf, rlen);
> +	} else {
> +		deb_info(1, "STM Steam Off");
> +		if  (st->tuner_config == TUNER_LG)
> +			ret |= lme2510_usb_talk(adap->dev, clear_reg_3,
> +				sizeof(clear_reg_3), rbuf, rlen);
> +		else
> +			ret |= lme2510_usb_talk(adap->dev,
> +				 reset, sizeof(reset), rbuf, rlen);
> +
> +		msleep(400);
> +		st->i2c_talk_onoff = 1;
> +	}
> +
> +	return (ret < 0) ? -ENODEV : 0;
> +}
> +
> +static int lme2510_int_service(struct dvb_usb_adapter *adap)
> +{
> +	struct dvb_usb_device *d = adap->dev;
> +	struct input_dev *input_dev;
> +	char *ir_codes = RC_MAP_LME2510;
> +	int ret = 0;
> +
> +	info("STA Configuring Remote");
> +
> +	usb_make_path(d->udev, d->rc_phys, sizeof(d->rc_phys));
> +
> +	strlcat(d->rc_phys, "/ir0", sizeof(d->rc_phys));
> +
> +	input_dev = input_allocate_device();
> +	if (!input_dev)
> +		return -ENOMEM;
> +
> +	input_dev->name = "LME2510 Remote Control";
> +	input_dev->phys = d->rc_phys;
> +
> +	usb_to_input_id(d->udev, &input_dev->id);
> +
> +	ret |= ir_input_register(input_dev, ir_codes, NULL, "LME 2510");
> +
> +	if (ret) {
> +		input_free_device(input_dev);
> +		return ret;
> +	}
> +
> +	d->rc_input_dev = input_dev;
> +	/* Start the Interupt */
> +	ret = lme2510_int_read(adap);
> +
> +	if (ret < 0) {
> +		ir_input_unregister(input_dev);
> +		input_free_device(input_dev);
> +	}
> +	return (ret < 0) ? -ENODEV : 0;
> +}
> +
> +static u8 check_sum(u8 *p, u8 len)
> +{
> +	u8 sum = 0;
> +	while (len--)
> +		sum += *p++;
> +	return sum;
> +}
> +
> +static int lme2510_download_firmware(struct usb_device *dev,
> +					const struct firmware *fw)
> +{
> +	int ret = 0;
> +	u8 data[512] = {0};
> +	u16 j, wlen, len_in, start, end;
> +	u8 packet_size, dlen, i;
> +	u8 *fw_data;
> +
> +	packet_size = 0x31;
> +	len_in = 1;
> +
> +
> +	info("FRM Starting Firmware Download");
> +
> +	for (i = 1; i < 3; i++) {
> +		start = (i == 1) ? 0 : 512;
> +		end = (i == 1) ? 512 : fw->size;
> +		for (j = start; j < end; j += (packet_size+1)) {
> +			fw_data = (u8 *)(fw->data + j);
> +			if ((end - j) > packet_size) {
> +				data[0] = i;
> +				dlen = packet_size;
> +			} else {
> +				data[0] = i | 0x80;
> +				dlen = (u8)(end - j)-1;
> +			}
> +		data[1] = dlen;
> +		memcpy(&data[2], fw_data, dlen+1);
> +		wlen = (u8) dlen + 4;
> +		data[wlen-1] = check_sum(fw_data, dlen+1);
> +		deb_info(1, "Data S=%02x:E=%02x CS= %02x", data[3],
> +				data[dlen+2], data[dlen+3]);
> +		ret |= lme2510_bulk_write(dev, data,  wlen, 1);
> +		ret |= lme2510_bulk_read(dev, data, len_in , 1);
> +		ret |= (data[0] == 0x88) ? 0 : -1;
> +		}
> +	}
> +	usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
> +			0x06, 0x80, 0x0200, 0x00, data, 0x0109, 1000);
> +
> +
> +	data[0] = 0x8a;
> +	len_in = 1;
> +	msleep(2000);
> +	ret |= lme2510_bulk_write(dev, data , len_in, 1); /*Resetting*/
> +	ret |= lme2510_bulk_read(dev, data, len_in, 1);
> +	msleep(400);
> +
> +	if (ret < 0)
> +		info("FRM Firmware Download Failed (%04x)" , ret);
> +	else
> +		info("FRM Firmware Download Completed - Resetting Device");
> +
> +
> +	return (ret < 0) ? -ENODEV : 0;
> +}
> +
> +
> +static int lme2510_kill_urb(struct usb_data_stream *stream)
> +{
> +	int i;
> +	for (i = 0; i < stream->urbs_submitted; i++) {
> +		deb_info(3, "killing URB no. %d.", i);
> +
> +		/* stop the URB */
> +		usb_kill_urb(stream->urb_list[i]);
> +	}
> +	stream->urbs_submitted = 0;
> +	return 0;
> +}
> +
> +static struct tda10086_config tda10086_config = {
> +	.demod_address = 0x1c,
> +	.invert = 0,
> +	.diseqc_tone = 1,
> +	.xtal_freq = TDA10086_XTAL_16M,
> +};
> +
> +static struct stv0288_config lme_config = {
> +	.demod_address = 0xd0,
> +	.min_delay_ms = 15,
> +	.inittab = s7395_inittab,
> +};
> +
> +static struct ix2505v_config lme_tuner = {
> +	.tuner_address = 0xc0,
> +	.min_delay_ms = 100,
> +	.tuner_gain = 0x0,
> +	.tuner_chargepump = 0x3,
> +};
> +
> +
> +static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
> +					fe_sec_voltage_t voltage)
> +{
> +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> +	struct lme2510_state *st = adap->dev->priv;
> +	static u8 voltage_low[]	= LME_VOLTAGE_L;
> +	static u8 voltage_high[] = LME_VOLTAGE_H;
> +	static u8 reset[] = LME_RESET;
> +	static u8 clear_reg_3[] =  LME_CLEAR_PID;
> +	static u8 rbuf[1];
> +	int ret = 0, len = 3, rlen = 1;
> +
> +	msleep(100);
> +
> +	if  (st->tuner_config == TUNER_LG)
> +		ret |= lme2510_usb_talk(adap->dev, clear_reg_3,
> +			sizeof(clear_reg_3), rbuf, rlen);
> +	else
> +		ret |= lme2510_usb_talk(adap->dev,
> +			 reset, sizeof(reset), rbuf, rlen);
> +
> +	/*always check & stop streaming*/
> +	lme2510_kill_urb(&adap->stream);
> +	adap->feedcount = 0;
> +
> +		switch (voltage) {
> +
> +		case SEC_VOLTAGE_18:
> +			ret |= lme2510_usb_talk(adap->dev,
> +				voltage_high, len, rbuf, rlen);
> +		break;
> +
> +		case SEC_VOLTAGE_OFF:
> +		case SEC_VOLTAGE_13:
> +		default:
> +			ret |= lme2510_usb_talk(adap->dev,
> +				voltage_low, len, rbuf, rlen);
> +		break;
> +
> +
> +	};
> +	st->i2c_talk_onoff = 1;
> +	return (ret < 0) ? -ENODEV : 0;
> +}
> +
> +static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
> +{
> +	int ret = 0;
> +	struct lme2510_state *st = adap->dev->priv;
> +
> +	/* Interupt Start  */
> +	ret = lme2510_int_service(adap);
> +	if (ret < 0) {
> +		info("INT Unable to start Interupt Service");
> +		return -ENODEV;
> +	}
> +
> +	st->i2c_talk_onoff = 1;
> +	st->i2c_gate = 4;
> +
> +	adap->fe = dvb_attach(tda10086_attach, &tda10086_config,
> +		&adap->dev->i2c_adap);
> +
> +	if (adap->fe) {
> +		info("TUN Found Frontend TDA10086");
> +		memcpy(&adap->fe->ops.info.name,
> +				&"DM04_LG_TDQY-P001F DVB-S", 24);
> +		adap->fe->ops.set_voltage = dm04_lme2510_set_voltage;
> +		st->i2c_tuner_gate_w = 4;
> +		st->i2c_tuner_gate_r = 4;
> +		st->i2c_tuner_addr = 0xc0;
> +		if (dvb_attach(tda826x_attach, adap->fe, 0xc0,
> +			&adap->dev->i2c_adap, 1)) {
> +			info("TUN TDA8263 Found");
> +			st->tuner_config = TUNER_LG;
> +			return 0;
> +		}
> +		kfree(adap->fe);
> +		adap->fe = NULL;
> +	}
> +	st->i2c_gate = 5;
> +	adap->fe = dvb_attach(stv0288_attach, &lme_config,
> +			&adap->dev->i2c_adap);
> +
> +	if (adap->fe) {
> +		info("FE Found Stv0288");
> +		memcpy(&adap->fe->ops.info.name,
> +				&"DM04_SHARP:BS2F7HZ7395", 22);
> +		adap->fe->ops.set_voltage = dm04_lme2510_set_voltage;
> +		st->i2c_tuner_gate_w = 4;
> +		st->i2c_tuner_gate_r = 5;
> +		st->i2c_tuner_addr = 0xc0;
> +		if (dvb_attach(ix2505v_attach , adap->fe, &lme_tuner,
> +					&adap->dev->i2c_adap)) {
> +			st->tuner_config = TUNER_S7395;
> +			info("TUN Sharp IX2505V silicon tuner");
> +			return 0;
> +		}
> +		kfree(adap->fe);
> +		adap->fe = NULL;
> +	}
> +
> +	info("DM04 Not Supported");
> +	return -ENODEV;
> +}
> +
> +static int lme2510_powerup(struct dvb_usb_device *d, int onoff)
> +{
> +	struct lme2510_state *st = d->priv;
> +	st->i2c_talk_onoff = 1;
> +	return 0;
> +}
> +
> +/* DVB USB Driver stuff */
> +static struct dvb_usb_device_properties lme2510_properties;
> +static struct dvb_usb_device_properties lme2510c_properties;
> +
> +static int lme2510_probe(struct usb_interface *intf,
> +		const struct usb_device_id *id)
> +{
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +	int ret = 0;
> +
> +	usb_reset_configuration(udev);
> +
> +	usb_set_interface(udev, intf->cur_altsetting->desc.bInterfaceNumber, 1);
> +
> +	if (udev->speed != USB_SPEED_HIGH) {
> +		ret = usb_reset_device(udev);
> +		info("DEV Failed to connect in HIGH SPEED mode");
> +		return -ENODEV;
> +	}
> +
> +	if (0 == dvb_usb_device_init(intf, &lme2510_properties,
> +				     THIS_MODULE, NULL, adapter_nr)) {
> +		info("DEV registering device driver");
> +		return 0;
> +	}
> +	if (0 == dvb_usb_device_init(intf, &lme2510c_properties,
> +				     THIS_MODULE, NULL, adapter_nr)) {
> +		info("DEV registering device driver");
> +		return 0;
> +	}
> +
> +	info("DEV lme2510 Error");
> +	return -ENODEV;
> +
> +}
> +
> +static struct usb_device_id lme2510_table[] = {
> +	{ USB_DEVICE(0x3344, 0x1122) },  /* LME2510 */
> +	{ USB_DEVICE(0x3344, 0x1120) },  /* LME2510C */
> +	{}		/* Terminating entry */
> +};
> +
> +MODULE_DEVICE_TABLE(usb, lme2510_table);
> +
> +static struct dvb_usb_device_properties lme2510_properties = {
> +	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
> +	.usb_ctrl = DEVICE_SPECIFIC,
> +	.download_firmware = lme2510_download_firmware,
> +	.firmware = "dvb-usb-lme2510-lg.fw",
> +
> +	.size_of_priv = sizeof(struct lme2510_state),
> +	.num_adapters = 1,
> +	.adapter = {
> +		{
> +			.streaming_ctrl   = lme2510_streaming_ctrl,
> +			.frontend_attach  = dm04_lme2510_frontend_attach,
> +			/* parameter for the MPEG2-data transfer */
> +			.stream = {
> +				.type = USB_BULK,
> +				.count = 10,
> +				.endpoint = 0x06,
> +				.u = {
> +					.bulk = {
> +						.buffersize = 4096,
> +
> +					}
> +				}
> +			}
> +		}
> +	},
> +	.power_ctrl       = lme2510_powerup,
> +	.identify_state   = lme2510_identify_state,
> +	.i2c_algo         = &lme2510_i2c_algo,
> +	.generic_bulk_ctrl_endpoint = 0,
> +	.num_device_descs = 1,
> +	.devices = {
> +		{   "DM04 LME2510 DVB-S USB 2.0",
> +			{ &lme2510_table[0], NULL },
> +			},
> +
> +	}
> +};
> +
> +static struct dvb_usb_device_properties lme2510c_properties = {
> +	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
> +	.usb_ctrl = DEVICE_SPECIFIC,
> +	.download_firmware = lme2510_download_firmware,
> +	.firmware = "dvb-usb-lme2510c-s7395.fw",
> +	.size_of_priv = sizeof(struct lme2510_state),
> +	.num_adapters = 1,
> +	.adapter = {
> +		{
> +			.streaming_ctrl   = lme2510_streaming_ctrl,
> +			.frontend_attach  = dm04_lme2510_frontend_attach,
> +			/* parameter for the MPEG2-data transfer */
> +			.stream = {
> +				.type = USB_BULK,
> +				.count = 8,
> +				.endpoint = 0x8,
> +				.u = {
> +					.bulk = {
> +						.buffersize = 4096,
> +
> +					}
> +				}
> +			}
> +		}
> +	},
> +	.power_ctrl       = lme2510_powerup,
> +	.identify_state   = lme2510_identify_state,
> +	.i2c_algo         = &lme2510_i2c_algo,
> +	.generic_bulk_ctrl_endpoint = 0,
> +	.num_device_descs = 1,
> +	.devices = {
> +		{   "DM04 LME2510C USB2.0",
> +			{ &lme2510_table[1], NULL },
> +			},
> +	}
> +};
> +
> +void lme2510_exit_int(struct dvb_usb_device *d)
> +{
> +	struct lme2510_state *st = d->priv;
> +	if (st->lme_urb != NULL) {
> +		st->i2c_talk_onoff = 0;
> +		st->signal_lock = 0;
> +		st->signal_level = 0;
> +		st->signal_sn = 0;
> +		kfree(st->usb_buffer);
> +		usb_kill_urb(st->lme_urb);
> +		usb_free_coherent(d->udev, 5000, st->buffer,
> +				  st->lme_urb->transfer_dma);
> +		info("Interupt Service Stopped");
> +		ir_input_unregister(d->rc_input_dev);
> +		info("Remote Stopped");
> +	}
> +	return;
> +}
> +
> +void lme2510_exit(struct usb_interface *intf)
> +{
> +	struct dvb_usb_device *d = usb_get_intfdata(intf);
> +	if (d != NULL) {
> +		d->adapter[0].feedcount = 0;
> +		lme2510_exit_int(d);
> +		dvb_usb_device_exit(intf);
> +	}
> +
> +}
> +
> +static struct usb_driver lme2510_driver = {
> +	.name		= "LME2510C_DVBS",
> +	.probe		= lme2510_probe,
> +	.disconnect	= lme2510_exit,
> +	.id_table	= lme2510_table,
> +};
> +
> +/* module stuff */
> +static int __init lme2510_module_init(void)
> +{
> +	int result = usb_register(&lme2510_driver);
> +	if (result) {
> +		err("usb_register failed. Error number %d", result);
> +		return result;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit lme2510_module_exit(void)
> +{
> +	/* deregister this driver from the USB subsystem */
> +	usb_deregister(&lme2510_driver);
> +}
> +
> +module_init(lme2510_module_init);
> +module_exit(lme2510_module_exit);
> +
> +MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
> +MODULE_DESCRIPTION("LM2510(C) DVB-S USB2.0");
> +MODULE_VERSION("1.4");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb/dvb-usb/lmedm04.h b/drivers/media/dvb/dvb-usb/lmedm04.h
> new file mode 100644
> index 0000000..5a66c7e
> --- /dev/null
> +++ b/drivers/media/dvb/dvb-usb/lmedm04.h
> @@ -0,0 +1,187 @@
> +/* DVB USB compliant linux driver for
> + *
> + * DM04/QQBOX DVB-S USB BOX	LME2510C + SHARP:BS2F7HZ7395
> + *				LME2510C + LGTDQT-P001F
> + *
> + * MVB7395 (LME2510C+SHARP:BS2F7HZ7395)
> + * SHARP:BS2F7HZ7395 = (STV0288+Sharp IX2505V)
> + *
> + * MVB0001F (LME2510C+LGTDQT-P001F)
> + * LG TDQY - P001F =(TDA8263 + TDA10086H)
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation,  version 2.
> + * *
> + * see Documentation/dvb/README.dvb-usb for more information
> + */
> +#ifndef _DVB_USB_LME2510_H_
> +#define _DVB_USB_LME2510_H_
> +
> +/* Streamer &  PID
> + *
> + * Note:	These commands do not actually stop the streaming
> + *		but form some kind of packet filtering/stream count
> + *		or tuning related functions.
> + *  06 XX
> + *  offset 1 = 00 Enable Streaming
> + *
> + *
> + *  PID
> + *  03 XX XX  ----> reg number ---> setting....20 XX
> + *  offset 1 = length
> + *  offset 2 = start of data
> + *  end byte -1 = 20
> + *  end byte = clear pid always a0, other wise 9c, 9a ??
> + *
> + *  RESET (also clears PID filter)
> + *  3a 01 00
> +*/
> +#define LME_ST_ON_W	{0x06, 0x00}
> +#define LME_RESET   {0x3a, 0x01, 0x00}
> +#define LME_CLEAR_PID   {0x03, 0x02, 0x20, 0xa0}
> +
> +
> +/* LME Power Control
> + *  07 XX XX
> + *  offset 1 = 01  Power? my device cannot be powered down
> + *  offset 2 = 00=Voltage low 01=Voltage high
> + */
> +
> +#define LME_VOLTAGE_L	{0x07, 0x01, 0x00}
> +#define LME_VOLTAGE_H	{0x07, 0x01, 0x01}
> +
> +
> +/* Initial stv0288 settings for 7395 Frontend */
> +static u8 s7395_inittab[] = {
> +	0x00, 0x11,
> +	0x01, 0x15,
> +	0x02, 0x20,
> +	0x03, 0x8e,
> +	0x04, 0x8e,
> +	0x05, 0x12,
> +	0x06, 0xff,
> +	0x07, 0x20,
> +	0x08, 0x00,
> +	0x09, 0x00,
> +	0x0a, 0x04,
> +	0x0b, 0x00,
> +	0x0c, 0x00,
> +	0x0d, 0x00,
> +	0x0e, 0xc1,
> +	0x0f, 0x54,
> +	0x10, 0x40,
> +	0x11, 0x7a,
> +	0x12, 0x03,
> +	0x13, 0x48,
> +	0x14, 0x84,
> +	0x15, 0xc5,
> +	0x16, 0xb8,
> +	0x17, 0x9c,
> +	0x18, 0x00,
> +	0x19, 0xa6,
> +	0x1a, 0x88,
> +	0x1b, 0x8f,
> +	0x1c, 0xf0,
> +	0x1e, 0x80,
> +	0x20, 0x0b,
> +	0x21, 0x54,
> +	0x22, 0xff,
> +	0x23, 0x01,
> +	0x24, 0x9a,
> +	0x25, 0x7f,
> +	0x26, 0x00,
> +	0x27, 0x00,
> +	0x28, 0x46,
> +	0x29, 0x66,
> +	0x2a, 0x90,
> +	0x2b, 0xfa,
> +	0x2c, 0xd9,
> +	0x2d, 0x02,
> +	0x2e, 0xb1,
> +	0x2f, 0x00,
> +	0x30, 0x0,
> +	0x31, 0x1e,
> +	0x32, 0x14,
> +	0x33, 0x0f,
> +	0x34, 0x09,
> +	0x35, 0x0c,
> +	0x36, 0x05,
> +	0x37, 0x2f,
> +	0x38, 0x16,
> +	0x39, 0xbd,
> +	0x3a, 0x0,
> +	0x3b, 0x13,
> +	0x3c, 0x11,
> +	0x3d, 0x30,
> +	0x3e, 0x00,
> +	0x3f, 0x00,
> +	0x40, 0x63,
> +	0x41, 0x04,
> +	0x42, 0x60,
> +	0x43, 0x00,
> +	0x44, 0x00,
> +	0x45, 0x00,
> +	0x46, 0x00,
> +	0x47, 0x00,
> +	0x4a, 0x00,
> +	0x4b, 0xd1,
> +	0x4c, 0x33,
> +	0x50, 0x12,
> +	0x51, 0x36,
> +	0x52, 0x21,
> +	0x53, 0x94,
> +	0x54, 0xb2,
> +	0x55, 0x29,
> +	0x56, 0x64,
> +	0x57, 0x2b,
> +	0x58, 0x54,
> +	0x59, 0x86,
> +	0x5a, 0x00,
> +	0x5b, 0x9b,
> +	0x5c, 0x08,
> +	0x5d, 0x7f,
> +	0x5e, 0xff,
> +	0x5f, 0x8d,
> +	0x70, 0x0,
> +	0x71, 0x0,
> +	0x72, 0x0,
> +	0x74, 0x0,
> +	0x75, 0x0,
> +	0x76, 0x0,
> +	0x81, 0x0,
> +	0x82, 0x3f,
> +	0x83, 0x3f,
> +	0x84, 0x0,
> +	0x85, 0x0,
> +	0x88, 0x0,
> +	0x89, 0x0,
> +	0x8a, 0x0,
> +	0x8b, 0x0,
> +	0x8c, 0x0,
> +	0x90, 0x0,
> +	0x91, 0x0,
> +	0x92, 0x0,
> +	0x93, 0x0,
> +	0x94, 0x1c,
> +	0x97, 0x0,
> +	0xa0, 0x48,
> +	0xa1, 0x0,
> +	0xb0, 0xb8,
> +	0xb1, 0x3a,
> +	0xb2, 0x10,
> +	0xb3, 0x82,
> +	0xb4, 0x80,
> +	0xb5, 0x82,
> +	0xb6, 0x82,
> +	0xb7, 0x82,
> +	0xb8, 0x20,
> +	0xb9, 0x0,
> +	0xf0, 0x0,
> +	0xf1, 0x0,
> +	0xf2, 0xc0,
> +	0xff, 0xff,
> +};
> +
> +#endif
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index 6c0324e..57281b1 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -96,6 +96,7 @@ void rc_map_init(void);
>  #define RC_MAP_KWORLD_315U               "rc-kworld-315u"
>  #define RC_MAP_KWORLD_PLUS_TV_ANALOG     "rc-kworld-plus-tv-analog"
>  #define RC_MAP_LIRC                      "rc-lirc"
> +#define RC_MAP_LME2510                   "rc-lme2510"
>  #define RC_MAP_MANLI                     "rc-manli"
>  #define RC_MAP_MSI_TVANYWHERE_PLUS       "rc-msi-tvanywhere-plus"
>  #define RC_MAP_MSI_TVANYWHERE            "rc-msi-tvanywhere"
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits

