Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39712 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbbFIWH4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2015 18:07:56 -0400
Date: Tue, 9 Jun 2015 19:07:49 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Joe Perches <joe@perches.com>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] lmedm04: Neaten logging
Message-ID: <20150609190749.56a1c6dd@recife.lan>
In-Reply-To: <1432542547.2846.55.camel@perches.com>
References: <1432542547.2846.55.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joe,

Em Mon, 25 May 2015 01:29:07 -0700
Joe Perches <joe@perches.com> escreveu:

> Use a more current logging style.
> 
> o Use pr_fmt
> o Add missing newlines to formats
> o Remove used-once lme_debug macro incorporating it into dbg_info
> o Remove unnecessary allocation error messages
> o Remove unnecessary semicolons from #defines
> o Remove info macro and convert uses to pr_info
> o Fix spelling of snippet
> o Use %phN extension

There are a few checkpatch warnings:

WARNING: line over 80 characters
#145: FILE: drivers/media/usb/dvb-usb-v2/lmedm04.c:337:
+			debug_data_snippet(5, "INT Remote data snippet in", ibuf);

ERROR: space prohibited before that ',' (ctx:WxW)
#190: FILE: drivers/media/usb/dvb-usb-v2/lmedm04.c:452:
+	pr_info("Firmware Status: %x (%x)\n", ret , data[2]);
 	                                          ^

ERROR: space prohibited before that ',' (ctx:WxW)
#251: FILE: drivers/media/usb/dvb-usb-v2/lmedm04.c:630:
+		pr_info("FRM Firmware Download Failed (%04x)\n" , ret);
 		                                                ^
and please see below:

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/usb/dvb-usb-v2/lmedm04.c | 105 +++++++++++++++------------------
>  1 file changed, 49 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> index 5de6f7c..7e8e58b 100644
> --- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
> +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> @@ -67,6 +67,8 @@
>   * M88RS2000 suffers from loss of lock.
>   */
>  #define DVB_USB_LOG_PREFIX "LME2510(C)"
> +#define pr_fmt(fmt) DVB_USB_LOG_PREFIX ": " fmt
> +
>  #include <linux/usb.h>
>  #include <linux/usb/input.h>
>  #include <media/rc-core.h>
> @@ -84,25 +86,22 @@
>  #include "ts2020.h"
>  
>  
> -#define LME2510_C_S7395	"dvb-usb-lme2510c-s7395.fw";
> -#define LME2510_C_LG	"dvb-usb-lme2510c-lg.fw";
> -#define LME2510_C_S0194	"dvb-usb-lme2510c-s0194.fw";
> -#define LME2510_C_RS2000 "dvb-usb-lme2510c-rs2000.fw";
> -#define LME2510_LG	"dvb-usb-lme2510-lg.fw";
> -#define LME2510_S0194	"dvb-usb-lme2510-s0194.fw";
> +#define LME2510_C_S7395	"dvb-usb-lme2510c-s7395.fw"
> +#define LME2510_C_LG	"dvb-usb-lme2510c-lg.fw"
> +#define LME2510_C_S0194	"dvb-usb-lme2510c-s0194.fw"
> +#define LME2510_C_RS2000 "dvb-usb-lme2510c-rs2000.fw"
> +#define LME2510_LG	"dvb-usb-lme2510-lg.fw"
> +#define LME2510_S0194	"dvb-usb-lme2510-s0194.fw"
>  
>  /* debug */
>  static int dvb_usb_lme2510_debug;
> -#define lme_debug(var, level, args...) do { \
> -	if ((var >= level)) \
> -		pr_debug(DVB_USB_LOG_PREFIX": " args); \
> +#define deb_info(level, fmt, ...)					\
> +do {									\
> +	if (dvb_usb_lme2510_debug >= level)				\
> +		pr_debug(fmt, ##__VA_ARGS__);				\
>  } while (0)


The usage of both a debug level and pr_debug() is not nice, as,
if CONFIG_DYNAMIC_DEBUG is enabled (with is the case on most distros),
one needing to debug would need to both pass a debug level AND to enable
the debug line via sysfs, with is not nice.

We might of course remove debug levels as a hole and just use 
pr_debug(), but the end result is generally worse (didn't chec
the specifics on this file).

So, the better here would be to use printk like:

#define deb_info(level, fmt, ...)\
	do { if (dvb_usb_lme2510_debug >= level)\
		printk(KERN_DEBUG pr_fmt(fmt), ## arg);\
	} while (0)

Ok, this issue were already present on the old code, but IMHO the
best is to either use the above definition of deb_info() or to just
call pr_debug() and get rid of dvb_usb_lme2510_debug.

Regards,
Mauro

> -#define deb_info(level, args...) lme_debug(dvb_usb_lme2510_debug, level, args)
> -#define debug_data_snipet(level, name, p) \
> -	 deb_info(level, name" (%02x%02x%02x%02x%02x%02x%02x%02x)", \
> -		*p, *(p+1), *(p+2), *(p+3), *(p+4), \
> -			*(p+5), *(p+6), *(p+7));
> -#define info(args...) pr_info(DVB_USB_LOG_PREFIX": "args)
> +#define debug_data_snippet(level, name, p)				\
> +	deb_info(level, name " (%*phN)\n", 8, p)
>  
>  module_param_named(debug, dvb_usb_lme2510_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able)).");
> @@ -182,10 +181,8 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
>  
>  	if (st->usb_buffer == NULL) {
>  		st->usb_buffer = kmalloc(64, GFP_KERNEL);
> -		if (st->usb_buffer == NULL) {
> -			info("MEM Error no memory");
> +		if (st->usb_buffer == NULL)
>  			return -ENOMEM;
> -		}
>  	}
>  	buff = st->usb_buffer;
>  
> @@ -234,7 +231,7 @@ static int lme2510_enable_pid(struct dvb_usb_device *d, u8 index, u16 pid_out)
>  	u8 pid_no = index * 2;
>  	u8 pid_len = pid_no + 2;
>  	int ret = 0;
> -	deb_info(1, "PID Setting Pid %04x", pid_out);
> +	deb_info(1, "PID Setting Pid %04x\n", pid_out);
>  
>  	if (st->pid_size == 0)
>  		ret |= lme2510_stream_restart(d);
> @@ -275,7 +272,7 @@ static void lme2510_int_response(struct urb *lme_urb)
>  	case -ESHUTDOWN:
>  		return;
>  	default:
> -		info("Error %x", lme_urb->status);
> +		pr_info("Error %x\n", lme_urb->status);
>  		break;
>  	}
>  
> @@ -286,17 +283,17 @@ static void lme2510_int_response(struct urb *lme_urb)
>  
>  	for (i = 0; i < offset; ++i) {
>  		ibuf = (u8 *)&rbuf[i*8];
> -		deb_info(5, "INT O/S C =%02x C/O=%02x Type =%02x%02x",
> -		offset, i, ibuf[0], ibuf[1]);
> +		deb_info(5, "INT O/S C =%02x C/O=%02x Type =%02x%02x\n",
> +			 offset, i, ibuf[0], ibuf[1]);
>  
>  		switch (ibuf[0]) {
>  		case 0xaa:
> -			debug_data_snipet(1, "INT Remote data snipet", ibuf);
> +			debug_data_snippet(1, "INT Remote data snippet", ibuf);
>  			if ((ibuf[4] + ibuf[5]) == 0xff) {
>  				key = RC_SCANCODE_NECX((ibuf[2] ^ 0xff) << 8 |
>  						       (ibuf[3] > 0) ? (ibuf[3] ^ 0xff) : 0,
>  						       ibuf[5]);
> -				deb_info(1, "INT Key =%08x", key);
> +				deb_info(1, "INT Key =%08x\n", key);
>  				if (adap_to_d(adap)->rc_dev != NULL)
>  					rc_keydown(adap_to_d(adap)->rc_dev,
>  						   RC_TYPE_NEC, key, 0);
> @@ -337,13 +334,13 @@ static void lme2510_int_response(struct urb *lme_urb)
>  			if (!signal_lock)
>  				st->lock_status &= ~FE_HAS_LOCK;
>  
> -			debug_data_snipet(5, "INT Remote data snipet in", ibuf);
> +			debug_data_snippet(5, "INT Remote data snippet in", ibuf);
>  		break;
>  		case 0xcc:
> -			debug_data_snipet(1, "INT Control data snipet", ibuf);
> +			debug_data_snippet(1, "INT Control data snippet", ibuf);
>  			break;
>  		default:
> -			debug_data_snipet(1, "INT Unknown data snipet", ibuf);
> +			debug_data_snippet(1, "INT Unknown data snippet", ibuf);
>  		break;
>  		}
>  	}
> @@ -391,7 +388,7 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
>  	lme_int->lme_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
>  
>  	usb_submit_urb(lme_int->lme_urb, GFP_ATOMIC);
> -	info("INT Interrupt Service Started");
> +	pr_info("INT Interrupt Service Started\n");
>  
>  	return 0;
>  }
> @@ -404,7 +401,7 @@ static int lme2510_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
>  	static u8 rbuf[1];
>  	int ret = 0;
>  
> -	deb_info(1, "PID Clearing Filter");
> +	deb_info(1, "PID Clearing Filter\n");
>  
>  	mutex_lock(&d->i2c_mutex);
>  
> @@ -428,8 +425,7 @@ static int lme2510_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
>  	struct dvb_usb_device *d = adap_to_d(adap);
>  	int ret = 0;
>  
> -	deb_info(3, "%s PID=%04x Index=%04x onoff=%02x", __func__,
> -		pid, index, onoff);
> +	deb_info(3, "PID=%04x Index=%04x onoff=%02x\n", pid, index, onoff);
>  
>  	if (onoff) {
>  		mutex_lock(&d->i2c_mutex);
> @@ -453,7 +449,7 @@ static int lme2510_return_status(struct dvb_usb_device *d)
>  
>  	ret |= usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
>  			0x06, 0x80, 0x0302, 0x00, data, 0x0006, 200);
> -	info("Firmware Status: %x (%x)", ret , data[2]);
> +	pr_info("Firmware Status: %x (%x)\n", ret , data[2]);
>  
>  	ret = (ret < 0) ? -ENODEV : data[2];
>  	kfree(data);
> @@ -516,7 +512,7 @@ static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  		}
>  
>  		if (lme2510_msg(d, obuf, len, ibuf, 64) < 0) {
> -			deb_info(1, "i2c transfer failed.");
> +			deb_info(1, "i2c transfer failed\n");
>  			mutex_unlock(&d->i2c_mutex);
>  			return -EAGAIN;
>  		}
> @@ -554,13 +550,13 @@ static int lme2510_streaming_ctrl(struct dvb_frontend *fe, int onoff)
>  	static u8 rbuf[1];
>  	int ret = 0, rlen = sizeof(rbuf);
>  
> -	deb_info(1, "STM  (%02x)", onoff);
> +	deb_info(1, "STM  (%02x)\n", onoff);
>  
>  	/* Streaming is started by FE_HAS_LOCK */
>  	if (onoff == 1)
>  		st->stream_on = 1;
>  	else {
> -		deb_info(1, "STM Steam Off");
> +		deb_info(1, "STM Stream Off\n");
>  		/* mutex is here only to avoid collision with I2C */
>  		mutex_lock(&d->i2c_mutex);
>  
> @@ -596,13 +592,10 @@ static int lme2510_download_firmware(struct dvb_usb_device *d,
>  	len_in = 1;
>  
>  	data = kzalloc(128, GFP_KERNEL);
> -	if (!data) {
> -		info("FRM Could not start Firmware Download"\
> -			"(Buffer allocation failed)");
> +	if (!data)
>  		return -ENOMEM;
> -	}
>  
> -	info("FRM Starting Firmware Download");
> +	pr_info("FRM Starting Firmware Download\n");
>  
>  	for (i = 1; i < 3; i++) {
>  		start = (i == 1) ? 0 : 512;
> @@ -620,8 +613,8 @@ static int lme2510_download_firmware(struct dvb_usb_device *d,
>  			memcpy(&data[2], fw_data, dlen+1);
>  			wlen = (u8) dlen + 4;
>  			data[wlen-1] = check_sum(fw_data, dlen+1);
> -			deb_info(1, "Data S=%02x:E=%02x CS= %02x", data[3],
> -				data[dlen+2], data[dlen+3]);
> +			deb_info(1, "Data S=%02x:E=%02x CS= %02x\n",
> +				 data[3], data[dlen+2], data[dlen+3]);
>  			lme2510_usb_talk(d, data, wlen, data, len_in);
>  			ret |= (data[0] == 0x88) ? 0 : -1;
>  		}
> @@ -634,9 +627,9 @@ static int lme2510_download_firmware(struct dvb_usb_device *d,
>  	msleep(400);
>  
>  	if (ret < 0)
> -		info("FRM Firmware Download Failed (%04x)" , ret);
> +		pr_info("FRM Firmware Download Failed (%04x)\n" , ret);
>  	else
> -		info("FRM Firmware Download Completed - Resetting Device");
> +		pr_info("FRM Firmware Download Completed - Resetting Device\n");
>  
>  	kfree(data);
>  	return RECONNECTS_USB;
> @@ -646,7 +639,7 @@ static void lme_coldreset(struct dvb_usb_device *d)
>  {
>  	u8 data[1] = {0};
>  	data[0] = 0x0a;
> -	info("FRM Firmware Cold Reset");
> +	pr_info("FRM Firmware Cold Reset\n");
>  
>  	lme2510_usb_talk(d, data, sizeof(data), data, sizeof(data));
>  
> @@ -738,7 +731,7 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
>  
>  	if (cold) {
>  		dvb_usb_lme2510_firmware = st->dvb_usb_lme2510_firmware;
> -		info("FRM Changing to %s firmware", fw_lme);
> +		pr_info("FRM Changing to %s firmware\n", fw_lme);
>  		lme_coldreset(d);
>  		return NULL;
>  	}
> @@ -751,7 +744,7 @@ static int lme2510_kill_urb(struct usb_data_stream *stream)
>  	int i;
>  
>  	for (i = 0; i < stream->urbs_submitted; i++) {
> -		deb_info(3, "killing URB no. %d.", i);
> +		deb_info(3, "killing URB no. %d\n", i);
>  		/* stop the URB */
>  		usb_kill_urb(stream->urb_list[i]);
>  	}
> @@ -978,7 +971,7 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
>  		adap->fe[0] = dvb_attach(tda10086_attach,
>  			&tda10086_config, &d->i2c_adap);
>  		if (adap->fe[0]) {
> -			info("TUN Found Frontend TDA10086");
> +			pr_info("TUN Found Frontend TDA10086\n");
>  			st->i2c_tuner_gate_w = 4;
>  			st->i2c_tuner_gate_r = 4;
>  			st->i2c_tuner_addr = 0x60;
> @@ -994,7 +987,7 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
>  		adap->fe[0] = dvb_attach(stv0299_attach,
>  				&sharp_z0194_config, &d->i2c_adap);
>  		if (adap->fe[0]) {
> -			info("FE Found Stv0299");
> +			pr_info("FE Found Stv0299\n");
>  			st->i2c_tuner_gate_w = 4;
>  			st->i2c_tuner_gate_r = 5;
>  			st->i2c_tuner_addr = 0x60;
> @@ -1011,7 +1004,7 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
>  			&d->i2c_adap);
>  
>  		if (adap->fe[0]) {
> -			info("FE Found Stv0288");
> +			pr_info("FE Found Stv0288\n");
>  			st->i2c_tuner_gate_w = 4;
>  			st->i2c_tuner_gate_r = 5;
>  			st->i2c_tuner_addr = 0x60;
> @@ -1028,7 +1021,7 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
>  			&m88rs2000_config, &d->i2c_adap);
>  
>  		if (adap->fe[0]) {
> -			info("FE Found M88RS2000");
> +			pr_info("FE Found M88RS2000\n");
>  			dvb_attach(ts2020_attach, adap->fe[0], &ts2020_config,
>  					&d->i2c_adap);
>  			st->i2c_tuner_gate_w = 5;
> @@ -1042,7 +1035,7 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
>  	}
>  
>  	if (adap->fe[0] == NULL) {
> -		info("DM04/QQBOX Not Powered up or not Supported");
> +		pr_info("DM04/QQBOX Not Powered up or not Supported\n");
>  		return -ENODEV;
>  	}
>  
> @@ -1103,9 +1096,9 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
>  	}
>  
>  	if (ret)
> -		info("TUN Found %s tuner", tun_msg[ret]);
> +		pr_info("TUN Found %s tuner\n", tun_msg[ret]);
>  	else {
> -		info("TUN No tuner found --- resetting device");
> +		pr_info("TUN No tuner found --- resetting device\n");
>  		lme_coldreset(d);
>  		return -ENODEV;
>  	}
> @@ -1113,7 +1106,7 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
>  	/* Start the Interrupt*/
>  	ret = lme2510_int_read(adap);
>  	if (ret < 0) {
> -		info("INT Unable to start Interrupt Service");
> +		pr_info("INT Unable to start Interrupt Service\n");
>  		return -ENODEV;
>  	}
>  
> @@ -1218,7 +1211,7 @@ static void *lme2510_exit_int(struct dvb_usb_device *d)
>  		usb_kill_urb(st->lme_urb);
>  		usb_free_coherent(d->udev, 128, st->buffer,
>  				  st->lme_urb->transfer_dma);
> -		info("Interrupt Service Stopped");
> +		pr_info("Interrupt Service Stopped\n");
>  	}
>  
>  	return buffer;
> 
> 
