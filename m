Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa012msr.fastwebnet.it ([85.18.95.72])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dark.schneider@iol.it>) id 1LKD2n-0005id-9R
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 15:36:34 +0100
Received: from gdc1 (1.12.64.59) by aa012msr.fastwebnet.it (8.0.013.8)
	id 493011FE0495538A for linux-dvb@linuxtv.org;
	Tue, 6 Jan 2009 15:35:55 +0100
Date: Tue, 6 Jan 2009 15:35:55 +0100
From: Gabriele Dini Ciacci <dark.schneider@iol.it>
To: linux-dvb@linuxtv.org
Message-ID: <20090106153555.69d5d95b@gdc1>
Mime-Version: 1.0
Subject: [linux-dvb] [PATCH] Drivers for Pinnacle pctv200e and pctv60e
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,
I am new here, time ago I have updated a stub driver for pctv200e to
the "latest" (of 9 months ago) dvb API, last week, after updating my
kernel, I made necessary changes for 2.6.28.

I am using the driver on a pctv60e and it is very stable, I use it
daily. It should work for pctv200e but not owning the device I cannot
test it.

The code need to be cleaned, as I am not an experienced kernel coder.
The code in mt352.c contains an hard-coded address for the device, while
Pinnalce devices with that tuner uses a different address. Currently
the address is "hijacked" to be the correct one. This is a hack, and i
think that mt352.c should be changed to support multiple addresses,
selected via defines or something.

Remote support is missing, cause it was not working out of the box. I
do not use it and so developing it for myself only was not very useful,
if someone wants it or is interested I can have a look.

The patch is generally messy, I need help there. I do not know if I
have to change all the functions to take as parameter an adapter_nr or
change the caller to continue to pass them a struct dvb_usb_device
obtained with i2c_get_adapdata(adapter_nr).

Here is the patch, thanks meanwhile.

Best Regards,
Gabriele Dini Ciacci

Signed-off-by: Gabriele Dini Ciacci <gab@diniciacci.org>

----------- 
http://linux-wildo.sf.net
http://www.diniciacci.org

diff -uprN v4l-dvd/linux/drivers/media/dvb/dvb-usb/Kconfig
my_v4l-dvb/linux/drivers/media/dvb/dvb-usb/Kconfig ---
v4l-dvd/linux/drivers/media/dvb/dvb-usb/Kconfig	2009-01-06
00:16:39.000000000 +0100 +++
my_v4l-dvb/linux/drivers/media/dvb/dvb-usb/Kconfig	2009-01-06
15:22:31.000000000 +0100 @@ -299,3 +299,9 @@ config DVB_USB_AF9015
select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMIZE help Say Y here
to support the Afatech AF9015 based DVB-T USB2.0 receiver +
+config DVB_USB_PCTV200E
+	tristate "Pinnacle PCTV200e and PCTV60e support"
+	depends on DVB_USB && EXPERIMENTAL
+	help
+	  Say Y here to support for PCTV200e or PCTV60e
diff -uprN v4l-dvd/linux/drivers/media/dvb/dvb-usb/Makefile
my_v4l-dvb/linux/drivers/media/dvb/dvb-usb/Makefile ---
v4l-dvd/linux/drivers/media/dvb/dvb-usb/Makefile	2009-01-06
00:16:39.000000000 +0100 +++
my_v4l-dvb/linux/drivers/media/dvb/dvb-usb/Makefile	2009-01-06
00:20:40.000000000 +0100 @@ -54,6 +54,8 @@
obj-$(CONFIG_DVB_USB_DIB0700) += dvb-usb dvb-usb-opera-objs = opera1.o
obj-$(CONFIG_DVB_USB_OPERA1) += dvb-usb-opera.o +dvb-usb-pctv200e-objs
= pctv200e.o +obj-$(CONFIG_DVB_USB_PCTV200E) += dvb-usb-pctv200e.o
 
 dvb-usb-af9005-objs = af9005.o af9005-fe.o
 obj-$(CONFIG_DVB_USB_AF9005) += dvb-usb-af9005.o
diff -uprN v4l-dvd/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
my_v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h ---
v4l-dvd/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-01-06
00:16:39.000000000 +0100 +++
my_v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
2009-01-06 00:31:01.000000000 +0100 @@ -174,6 +174,7 @@ #define
USB_PID_PINNACLE_PCTV73E			0x0237 #define
USB_PID_PINNACLE_PCTV801E			0x023a #define
USB_PID_PINNACLE_PCTV801E_SE			0x023b +#define
USB_PID_PCTV_60E				0x0216 #define
USB_PID_PCTV_200E				0x020e #define
USB_PID_PCTV_400E				0x020f #define
USB_PID_PCTV_450E				0x0222 diff -uprN
v4l-dvd/linux/drivers/media/dvb/dvb-usb/pctv200e.c
my_v4l-dvb/linux/drivers/media/dvb/dvb-usb/pctv200e.c ---
v4l-dvd/linux/drivers/media/dvb/dvb-usb/pctv200e.c	1970-01-01
01:00:00.000000000 +0100 +++
my_v4l-dvb/linux/drivers/media/dvb/dvb-usb/pctv200e.c	2009-01-06
15:30:32.000000000 +0100 @@ -0,0 +1,644 @@ +/*
+ * DVB USB compliant linux driver for Pinnacle PCTV 200e DVB-T reciever
+ *
+ * Copyright (C) 2008 Gabriele Dini Ciacci <gab@diniciacci.org>
+ *               2007 Jakob Steidl (jakob.steidl@gmail.com)
+ *               based on  Patrick Boettcher's driver for the Nebula
Electronics uDigiTV
+ *
+ *
+ *	This program is free software; you can redistribute it
and/or modify it
+ *	under the terms of the GNU General Public License as
published by the Free
+ *	Software Foundation, version 2.
+ *
+ * see Documentation/dvb/README.dvb-usb for more information
+ */
+
+// mt352 registers
+#define CLOCK_CTL		0x89
+#define RESET			0x50
+#define	ACQ_CTL         	0x53
+#define	TRL_NOMINAL_RATE_1  	0x54
+#define	INPUT_FREQ_1    	0x56
+#define	UNKNOWN_3	    	0x5e
+#define AGC_TARGET		0x67
+#define CAPT_RANGE		0x75
+#define	SNR_SELECT_1    	0x79
+#define UNKNOWN_1		0x7B
+#define	SCAN_CTL		0x88
+#define	MCLK_RATIO		0x8B
+#define GPP_CTL			0x8C
+#define ADC_CTL_1		0x8E
+#define UNKNOWN_2		0x98
+
+#include "pctv200e.h"
+
+#include "dvb-usb.h"
+#include "mt352.h"
+#include "mt2060.h"
+#include "mt2060_priv.h"
+
+
+
+/* debug */
+// To enable the debug set a value 1 for dvb_usb_pctv200e_debug
+int dvb_usb_pctv200e_debug=0;
+static int ctrl_msg_last_device=0;
+static int ctrl_msg_last_operation=0;
+
+static struct mt352_config pctv200e_mt352_config;
+static struct mt2060_config pctv200e_mt2060_config;
+
+module_param_named(debug,dvb_usb_pctv200e_debug, int, 0644);
+MODULE_PARM_DESC( debug, "Set debug level (1=info,xfer=2,rc=4 (RC is
the codeword for ALL ;) (|-able))." DVB_USB_DEBUG_STATUS ); +
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+/* I2C */
+/*
+01 c0 02 03 80
+ -  request type (read: 0x01, write: 0x02)
+     - addr to be read or written (0xc0 ... tuner)
+	 - number of of bits that follow
+	     - just data
+		 - data (optional, if number data >1)
+*/
+
+static int pctv200e_ctrl_msg(struct dvb_usb_device *d,
+		u8 addr, u8 rw, u8 reg, u8 *wbuf, int wlen, u8
*rbuf,int rlen) +{
+	// atm,  u8 rw is being ignored, it should be clear from the
+	int wo = (rbuf == NULL || rlen == 0); /* then its a
write-only*/
+	int counter;
+	u8 sndbuf[5],rcvbuf[64] = { 0 };
+//	u8 sndbuf[8],rcvbuf[5]; /* actually we don't know the max.
answer lenght //yet.. +
+	if (wlen>64) {
+		warn ("pctv200e_ctrl_msg: failed, command too long!");
+		return 0;
+	}
+
+	memset(sndbuf,0,5); memset(rcvbuf,0,64);
+
+	if (ctrl_msg_last_device == 0) {
+
+// The very first time we send the following sequence "0x15 0x80" and
then "0x16 0x00"
+		sndbuf[0] = 0x15;
+		sndbuf[1] = 0x80;
+		dvb_usb_generic_rw(d,sndbuf,2,rcvbuf,64,4);
+		if (dvb_usb_pctv200e_debug) {
+			warn("crtl_msg() wlen: %d, rlen: %d, READ: %x
%x %x %x
%x",wlen,rlen,sndbuf[0],sndbuf[1],sndbuf[2],sndbuf[3],sndbuf[4]);
+			warn("crtl_msg() RECEIVED: %x %x %x %x %x %x
%x %x %x %x %x %x
%x",rcvbuf[0],rcvbuf[1],rcvbuf[2],rcvbuf[3],rcvbuf[4],rcvbuf[5],rcvbuf[6],rcvbuf[7],rcvbuf[8],rcvbuf[9],rcvbuf[10],rcvbuf[11],rcvbuf[12]);
+
+			sndbuf[0] = 0x16;
+			sndbuf[1] = 0x00;
+			dvb_usb_generic_rw(d,sndbuf,2,rcvbuf,64,4);
+			warn("crtl_msg() wlen: %d, rlen: %d, READ: %x
%x %x %x
%x",wlen,rlen,sndbuf[0],sndbuf[1],sndbuf[2],sndbuf[3],sndbuf[4]);
+			warn("crtl_msg() RECEIVED: %x %x %x %x %x %x
%x %x %x %x %x %x
%x",rcvbuf[0],rcvbuf[1],rcvbuf[2],rcvbuf[3],rcvbuf[4],rcvbuf[5],rcvbuf[6],rcvbuf[7],rcvbuf[8],rcvbuf[9],rcvbuf[10],rcvbuf[11],rcvbuf[12]);
+		}
+	} 
+
+	// Now start to check the last operation and send the
intermedium sequence	
+	// If the command is sent to the tuner mt2060
+	// first we sent the sequence "0x16 0x01", and below after the
command
+	// then we send the sequence "0x16 0x00".
+	// This is not needed when the command goes to the demod mt352
+
+	if (addr == pctv200e_mt2060_config.i2c_address ) {
+
+		sndbuf[0] = 0x16;
+		sndbuf[1] = 0x01;
+		dvb_usb_generic_rw(d,sndbuf,2,rcvbuf,64,4);
+
+		if (dvb_usb_pctv200e_debug) {
+			warn("crtl_msg() wlen: %d, rlen: %d, READ: %x
%x %x %x
%x",wlen,rlen,sndbuf[0],sndbuf[1],sndbuf[2],sndbuf[3],sndbuf[4]);
+			warn("crtl_msg() RECEIVED: %x %x %x %x %x %x
%x %x %x %x %x %x
%x",rcvbuf[0],rcvbuf[1],rcvbuf[2],rcvbuf[3],rcvbuf[4],rcvbuf[5],rcvbuf[6],rcvbuf[7],rcvbuf[8],rcvbuf[9],rcvbuf[10],rcvbuf[11],rcvbuf[12]);
+		}
+
+	}
+
+	sndbuf[1] = addr;
+
+	ctrl_msg_last_device = addr;
+	// We store who which address was access (DEMOD or TUNER)
+//	memcpy(&sndbuf[5],wbuf,wlen);
+
+	if (wo) {
+		ctrl_msg_last_operation = 0x01;
+		sndbuf[0] = 0x01;
+		sndbuf[2] = 0x02;
+		sndbuf[3] = reg;
+
+		// We convert multiple writes into single writes
+		for (counter=0; counter < wlen; counter++) {
+			sndbuf[4] = wbuf[counter];
+
+		// For Pinnacle cards it should be send 0xf4 for
ACQ_CTL as mentioned
+		// in mt352.c. At this moment the mt352.c send by
default 0x50,
+		// so we intercept and change the value here.
+		// This way we don't need to change  mt352.c
+
+			if ((addr == 0x3e) & (sndbuf[3] == ACQ_CTL) &
(sndbuf[4] == 0x50)) {
+				if (dvb_usb_pctv200e_debug)
+					warn("crtl_msg(): Changed
ACQ_CTL value to 0xf4!!!");
+				sndbuf[4] = 0xf4;
+			}
+
+//			memcpy(&sndbuf[3],wbuf,wlen);
+			if (dvb_usb_pctv200e_debug) {
+				warn("crtl_msg() wlen: %d, rlen:
%d,WRITE: %x %x %x %x
%x",wlen,rlen,sndbuf[0],sndbuf[1],sndbuf[2],sndbuf[3],sndbuf[4]);
+			}
+
+			dvb_usb_generic_rw(d,sndbuf,5,rcvbuf,64,4);
+
+			if (dvb_usb_pctv200e_debug) {
+				warn("crtl_msg() RECEIVED: %x %x %x %x
%x %x %x %x %x %x %x %x
%x",rcvbuf[0],rcvbuf[1],rcvbuf[2],rcvbuf[3],rcvbuf[4],rcvbuf[5],rcvbuf[6],rcvbuf[7],rcvbuf[8],rcvbuf[9],rcvbuf[10],rcvbuf[11],rcvbuf[12]);
+			}
+
+			if (rcvbuf[0] != 0x1) {
+			warn("crtl_msg() WRITE ERROR: returned byte
[0] not 0x1"); +//			return -EIO;
+			}
+
+			if (rcvbuf[1] != 0x0) {
+			warn("crtl_msg() WRITE ERROR: returned
error!"); +//			return -EIO;
+			}
+			// it is write_regs, so we increment the
register value
+			sndbuf[3] = sndbuf[3]+1;
+		}
+
+	} else {
+		ctrl_msg_last_operation = 0x02;
+		sndbuf[0] = 0x02;
+		sndbuf[2] = 0x01;
+		sndbuf[3] = 0x01;
+		sndbuf[4] = reg;
+
+		if (dvb_usb_pctv200e_debug) {
+			warn("crtl_msg() wlen: %d, rlen: %d, READ: %x
%x %x %x
%x",wlen,rlen,sndbuf[0],sndbuf[1],sndbuf[2],sndbuf[3],sndbuf[4]);
+		}
+
+		dvb_usb_generic_rw(d,sndbuf,5,rcvbuf,64,4);
+
+		if (rlen > 0) {
+			memcpy(rbuf,&rcvbuf[2],rlen);
+		}
+
+		if (dvb_usb_pctv200e_debug) {
+			warn("crtl_msg() RECEIVED: %x %x %x %x %x %x
%x %x %x %x %x %x
%x",rcvbuf[0],rcvbuf[1],rcvbuf[2],rcvbuf[3],rcvbuf[4],rcvbuf[5],rcvbuf[6],rcvbuf[7],rcvbuf[8],rcvbuf[9],rcvbuf[10],rcvbuf[11],rcvbuf[12]);
+		}
+	}
+
+	if (addr == pctv200e_mt2060_config.i2c_address ) {
+
+		sndbuf[0] = 0x16;
+		sndbuf[1] = 0x00;
+		dvb_usb_generic_rw(d,sndbuf,2,rcvbuf,64,4);
+
+		if (dvb_usb_pctv200e_debug) {
+			warn("crtl_msg() wlen: %d, rlen: %d, READ: %x
%x %x %x
%x",wlen,rlen,sndbuf[0],sndbuf[1],sndbuf[2],sndbuf[3],sndbuf[4]);
+			warn("crtl_msg() RECEIVED: %x %x %x %x %x %x
%x %x %x %x %x %x
%x",rcvbuf[0],rcvbuf[1],rcvbuf[2],rcvbuf[3],rcvbuf[4],rcvbuf[5],rcvbuf[6],rcvbuf[7],rcvbuf[8],rcvbuf[9],rcvbuf[10],rcvbuf[11],rcvbuf[12]);
+		}
+
+	}
+
+	return 0;
+}
+
+static int pctv200e_cmd_msg(struct dvb_usb_device *d, u8 *wbuf, int
wlen) +{
+	u8 sndbuf[64] = { 0 };
+	u8 rcvbuf[64] = { 0 };
+//	u8 sndbuf[8],rcvbuf[5]; /* actually we don't know the max.
answer lenght //yet.. */
+	if (wlen>64) {
+		warn ("pctv200e_cmd_msg: failed, command too long!");
+		return 0;
+	}
+	memset(sndbuf,0,64); memset(rcvbuf,0,64);
+	memcpy(sndbuf,wbuf,wlen);
+
+	if (dvb_usb_pctv200e_debug)
+		warn("cmd_msg() wlen: %d, WRITE: %x %x %x %x
%x",wlen,sndbuf[0],sndbuf[1],sndbuf[2],sndbuf[3],sndbuf[4]); +
+	dvb_usb_generic_rw(d,sndbuf,wlen,rcvbuf,64,4);
+
+	if (rcvbuf[1] != 0x00) {
+		warn("crtl_msg() WRITE ERROR: returned error!");
+	}
+
+	if (dvb_usb_pctv200e_debug)
+		warn("cmd_msg() RECEIVED: %x %x %x %x %x %x %x %x %x
%x %x %x
%x",rcvbuf[0],rcvbuf[1],rcvbuf[2],rcvbuf[3],rcvbuf[4],rcvbuf[5],rcvbuf[6],rcvbuf[7],rcvbuf[8],rcvbuf[9],rcvbuf[10],rcvbuf[11],rcvbuf[12]);
+
+	return 0;
+}
+
+
+static int pctv200e_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg
msg[],int num) +{
+	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int i;
+
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
+	if (num > 2)
+		warn("more than 2 i2c messages at a time is not
handled yet. TODO."); +
+	for (i = 0; i < num; i++) {
+		/* write/read request */
+		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
+			if (pctv200e_ctrl_msg(d, msg[i].addr,USB_READ,
msg[i].buf[0], NULL, 0, msg[i+1].buf,msg[i+1].len) < 0)
+				break;
+			i++;
+		} else
+			if (pctv200e_ctrl_msg(d,msg[i].addr,USB_WRITE,
msg[i].buf[0],&msg[i].buf[1],msg[i].len-1,NULL,0) < 0)
+				break;
+	}
+
+	mutex_unlock(&d->i2c_mutex);
+	if (dvb_usb_pctv200e_debug)
+		warn("pctv200e_i2c_xfer() called.");
+	return i;
+}
+
+static u32 pctv200e_i2c_func(struct i2c_adapter *adapter)
+{
+	warn ("pctv200e_i2c_func: entering, done nothing");
+	return I2C_FUNC_I2C;
+}
+
+static struct i2c_algorithm pctv200e_i2c_algo = {
+	.master_xfer   = pctv200e_i2c_xfer,
+	.functionality = pctv200e_i2c_func,
+};
+
+/* Callbacks for DVB USB */
+static int pctv200e_identify_state (struct usb_device *udev, struct
+		dvb_usb_device_properties *props, struct
dvb_usb_device_description **desc,
+		int *cold)
+{
+	*cold = udev->descriptor.iManufacturer == 0 &&
udev->descriptor.iProduct == 0;
+	return 0;
+}
+// probably this needs to be changed.
+static int pctv200e_mt352_demod_init(struct dvb_frontend *fe)
+{
+//	We implement the RESET sequence for the demod mt352
+	static u8 clock_config []  = { CLOCK_CTL,  0xbd, 0x28 };
+	static u8 reset []         = { RESET,      0x80 };
+	static u8 reset_stop []    = { RESET,      0x00 };
+	static u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
+	static u8 agc_cfg []       = { AGC_TARGET, 0x1c };
+//	static u8 gpp_ctl_cfg []   = { GPP_CTL,    0x33 };
+	static u8 capt_range_cfg[] = { CAPT_RANGE, 0x30 };
+
+	static u8 input_freq[]        = { INPUT_FREQ_1, 0x31, 0xb5 };
+	static u8 clock_ratio[]       = { MCLK_RATIO, 0x00 };
+	static u8 scan_ctl[]          = { SCAN_CTL, 0x0d };
+	static u8 unknown_1[]         = { UNKNOWN_1, 0x04 };
+
+	static u8 acq_ctl[]           = { ACQ_CTL, 0xf4 };
+
+	static u8 trl_nominal_rate[]  = { TRL_NOMINAL_RATE_1, 0x73,
0x1c }; +
+	static u8 unknown_2[]  = { UNKNOWN_2, 0x00, 0x00, 0x80, 0x20,
0x80, 0x80, 0x55, 0x62, 0x00 }; +
+	static u8 unknown_3[]  = { UNKNOWN_3, 0x01 };
+
+//	static u8 snr_select_1[]  = { SNR_SELECT_1, 0x20, 0x00 };
+
+	mt352_write(fe, clock_config,   sizeof(clock_config));
+	udelay(1000);
+	mt352_write(fe, reset,          sizeof(reset));
+	mt352_write(fe, reset_stop,     sizeof(reset_stop));
+
+	mt352_write(fe, adc_ctl_1_cfg,  sizeof(adc_ctl_1_cfg));
+	mt352_write(fe, input_freq,     sizeof(input_freq));
+	mt352_write(fe, clock_ratio,    sizeof(clock_ratio));
+	mt352_write(fe, scan_ctl,       sizeof(scan_ctl));
+
+	mt352_write(fe, unknown_1,      sizeof(unknown_1));
+
+	mt352_write(fe, acq_ctl,          sizeof(acq_ctl));
+	mt352_write(fe, capt_range_cfg,   sizeof(capt_range_cfg));
+	mt352_write(fe, agc_cfg,          sizeof(agc_cfg));
+	mt352_write(fe, trl_nominal_rate, sizeof(trl_nominal_rate));
+
+	mt352_write(fe, unknown_2,      sizeof(unknown_2));
+	mt352_write(fe, unknown_3,      sizeof(unknown_3));
+
+//	mt352_write(fe, snr_select_1,   sizeof(snr_select_1));
+//	mt352_write(fe, gpp_ctl_cfg,    sizeof(gpp_ctl_cfg));
+
+	warn ("PCTV200e initialized mt352");
+	return 0;
+}
+
+static struct mt352_config pctv200e_mt352_config = {
+	.demod_address = 0x3e,
+	.demod_init    = pctv200e_mt352_demod_init,
+	.no_tuner      = 1,
+	.adc_clock     = 20333,
+	.if2           = 56468,
+};
+
+static struct mt2060_config pctv200e_mt2060_config = {
+	.i2c_address = 0xc0,
+	.clock_out   = 1,
+};
+
+/*
+static int pctv200e_mt2060_tuner_set_params(struct v4l_dvb_tuner_ops
*ops, struct dvb_int_frontend_parameters *fep) +{
+	warn ("pctv200e_mt2060_tuner_set_params: setting parameters!");
+
+	ops->set_params (ops,fep);
+
+	//	ret = fe->ops.tuner_ops.set_params(fe, fep);
+
+	return 0;
+}
+*/
+
+static u16 if1 = 1220; // this is probably wrong, but we need some
value to compile this shite +
+
+// source (for the tuner attach: dibusb-common.c)
+static int pctv200e_frontend_attach(struct dvb_usb_adapter *adap)
+{
+        warn(" trying to attach a frontend.");
+	static u8 cmd_buf3[] = { 0x10, 0xED};
+	static u8 cmd_buf4[] = { 0x11, 0x41};
+	static u8 cmd_buf5[] = { 0x12, 0x01};
+	// Sending "0x18 0x01" turns the antenna power on
+	// Sending "0x18 0x00" turns the antenna power off
+	static u8 cmd_buf6[] = { 0x18, 0x01};
+
+	if ((adap->fe = dvb_attach(mt352_attach,
&pctv200e_mt352_config, &adap->dev->i2c_adap)) != NULL) {
+	//		adap->fe->ops.tuner_ops.calc_regs =
dvb_usb_tuner_calc_regs;
+		warn(" attaching and initializing mt352frontend
attached."); +//		pctv200e_cmd_msg(adap->dev, cmd_buf1,
sizeof(cmd_buf1));
+		pctv200e_mt352_demod_init (adap->fe);
+		// Send, maybe is start command?
+//		pctv200e_cmd_msg(adap->dev, cmd_buf1,
sizeof(cmd_buf1)); +//		pctv200e_cmd_msg(adap->dev,
cmd_buf2, sizeof(cmd_buf2));
+		pctv200e_cmd_msg(adap->dev, cmd_buf3,
sizeof(cmd_buf3));
+		pctv200e_cmd_msg(adap->dev, cmd_buf4,
sizeof(cmd_buf4));
+		pctv200e_cmd_msg(adap->dev, cmd_buf5,
sizeof(cmd_buf5));
+		pctv200e_cmd_msg(adap->dev, cmd_buf6,
sizeof(cmd_buf6)); +//		pctv200e_cmd_msg(adap->dev,
cmd_buf1, sizeof(cmd_buf1)); +
+		warn(" frontend attached.");
+		return 0;
+	} 
+	warn(" frontend attach FAILED.");
+	return -EIO;
+}
+
+static int pctv200e_tuner_attach(struct dvb_usb_adapter *adap)
+{
+  
+        warn(" trying to attach a tuner.");
+	//	adap->fe->ops.tuner_ops.fe = adap->fe;
+
+//	if ((adap->fe = dvb_attach(mt2060_attach,
&adap->fe->ops.tuner_ops, +//	if ((dvb_attach(mt2060_attach,
&adap->fe->ops.tuner_ops,
+	if ((dvb_attach(mt2060_attach, adap->fe,
+		&adap->dev->i2c_adap, &pctv200e_mt2060_config,
if1)) != NULL) {
+	  //		adap->fe->ops.tuner_ops.fe = adap->fe;
+//		adap->fe->ops.tuner_ops.set_params =
pctv200e_mt2060_tuner_set_params; +//		adap->pll_addr =
0xc0;
+		//		adap->pll_desc = &dvb_pll_tded4;
+		warn("tuner mt2060 attached.");
+		//	        if (!dvb_attach(dvb_pll_attach,
adap->fe, 0xc0, NULL, DVB_PLL_TDED4)) return -ENODEV;
+		//		warn("pll tuner attached.");
+		return 0;
+	}
+
+	warn("frontend_attach failed (mt2060)");
+
+	return -EIO;
+}
+
+// currently not aim of my mission
+#if 0
+
+static struct dvb_usb_rc_key pctv200e_rc_keys[] = {
+	{ 0x5f, 0x55, KEY_0 },
+	{ 0x6f, 0x55, KEY_1 },
+	{ 0x9f, 0x55, KEY_2 },
+	{ 0xaf, 0x55, KEY_3 },
+	{ 0x5f, 0x56, KEY_4 },
+	{ 0x6f, 0x56, KEY_5 },
+	{ 0x9f, 0x56, KEY_6 },
+	{ 0xaf, 0x56, KEY_7 },
+	{ 0x5f, 0x59, KEY_8 },
+	{ 0x6f, 0x59, KEY_9 },
+	{ 0x9f, 0x59, KEY_TV },
+	{ 0xaf, 0x59, KEY_AUX },
+	{ 0x5f, 0x5a, KEY_DVD },
+	{ 0x6f, 0x5a, KEY_POWER },
+	{ 0x9f, 0x5a, KEY_MHP },     /* labelled 'Picture' */
+	{ 0xaf, 0x5a, KEY_AUDIO },
+	{ 0x5f, 0x65, KEY_INFO },
+	{ 0x6f, 0x65, KEY_F13 },     /* 16:9 */
+	{ 0x9f, 0x65, KEY_F14 },     /* 14:9 */
+	{ 0xaf, 0x65, KEY_EPG },
+	{ 0x5f, 0x66, KEY_EXIT },
+	{ 0x6f, 0x66, KEY_MENU },
+	{ 0x9f, 0x66, KEY_UP },
+	{ 0xaf, 0x66, KEY_DOWN },
+	{ 0x5f, 0x69, KEY_LEFT },
+	{ 0x6f, 0x69, KEY_RIGHT },
+	{ 0x9f, 0x69, KEY_ENTER },
+	{ 0xaf, 0x69, KEY_CHANNELUP },
+	{ 0x5f, 0x6a, KEY_CHANNELDOWN },
+	{ 0x6f, 0x6a, KEY_VOLUMEUP },
+	{ 0x9f, 0x6a, KEY_VOLUMEDOWN },
+	{ 0xaf, 0x6a, KEY_RED },
+	{ 0x5f, 0x95, KEY_GREEN },
+	{ 0x6f, 0x95, KEY_YELLOW },
+	{ 0x9f, 0x95, KEY_BLUE },
+	{ 0xaf, 0x95, KEY_SUBTITLE },
+	{ 0x5f, 0x96, KEY_F15 },     /* AD */
+	{ 0x6f, 0x96, KEY_TEXT },
+	{ 0x9f, 0x96, KEY_MUTE },
+	{ 0xaf, 0x96, KEY_REWIND },
+	{ 0x5f, 0x99, KEY_STOP },
+	{ 0x6f, 0x99, KEY_PLAY },
+	{ 0x9f, 0x99, KEY_FASTFORWARD },
+	{ 0xaf, 0x99, KEY_F16 },     /* chapter */
+	{ 0x5f, 0x9a, KEY_PAUSE },
+	{ 0x6f, 0x9a, KEY_PLAY },
+	{ 0x9f, 0x9a, KEY_RECORD },
+	{ 0xaf, 0x9a, KEY_F17 },     /* picture in picture */
+	{ 0x5f, 0xa5, KEY_KPPLUS },  /* zoom in */
+	{ 0x6f, 0xa5, KEY_KPMINUS }, /* zoom out */
+	{ 0x9f, 0xa5, KEY_F18 },     /* capture */
+	{ 0xaf, 0xa5, KEY_F19 },     /* web */
+	{ 0x5f, 0xa6, KEY_EMAIL },
+	{ 0x6f, 0xa6, KEY_PHONE },
+	{ 0x9f, 0xa6, KEY_PC },
+};
+
+static int pctv200e_rc_query(struct dvb_usb_device *d, u32 *event, int
*state) +{
+	int i;
+	u8 key[5];
+	u8 b[4] = { 0 };
+
+	*event = 0;
+	*state = REMOTE_NO_KEY_PRESSED;
+
+	pctv200e_ctrl_msg(d,USB_READ_REMOTE,0,NULL,0,&key[1],4);
+
+	/* Tell the device we've read the remote. Not sure how
necessary
+	   this is, but the Nebula SDK does it. */
+	pctv200e_ctrl_msg(d,USB_WRITE_REMOTE,0,b,4,NULL,0);
+
+	/* if something is inside the buffer, simulate key press */
+	if (key[1] != 0)
+	{
+		  for (i = 0; i < d->props.rc_key_map_size; i++) {
+			if (d->props.rc_key_map[i].custom == key[1] &&
+			    d->props.rc_key_map[i].data == key[2]) {
+				*event = d->props.rc_key_map[i].event;
+				*state = REMOTE_KEY_PRESSED;
+				return 0;
+			}
+		}
+	}
+
+	if (key[0] != 0)
+		warn("key: %x %x %x %x
%x\n",key[0],key[1],key[2],key[3],key[4]);
+	return 0;
+}
+#endif
+
+/* DVB USB Driver stuff */
+static struct dvb_usb_device_properties pctv200e_properties;
+
+static int pctv200e_probe(struct usb_interface *intf,
+		const struct usb_device_id *id)
+{
+// Scheduled for removal [GDC]
+//	struct dvb_usb_device *d;
+// cause we removed &d from next one.
+	int ret;
+	if ((ret = dvb_usb_device_init(intf, &pctv200e_properties,
+                                       THIS_MODULE, NULL, adapter_nr))
== 0) { +#if 0
+		u8 b[4] = { 0 };
+// Do not know if we use this here, or change all the functions to take
+// an adapter_nr as parameter.
+                struct dvb_usb_device *d =
i2c_get_adapdata(adapter_nr);
+		/* do we need that?? */
+		if (d != NULL) {  /* do that only when the firmware is
loaded  */
+			b[0] = 1;
+
pctv200e_ctrl_msg(d,USB_WRITE_REMOTE_TYPE,0,b,4,NULL,0); +
+			b[0] = 0;
+
pctv200e_ctrl_msg(d,USB_WRITE_REMOTE,0,b,4,NULL,0);
+		}
+#endif
+	}
+	warn("usb_device_init sucessfull.");
+	return ret;
+}
+
+
+static struct usb_device_id pctv200e_table [] = {
+		{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_200E) },
+		{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_60E) },
+		{ }		/* Terminating entry */
+};
+MODULE_DEVICE_TABLE (usb, pctv200e_table);
+
+// change me
+static struct dvb_usb_device_properties pctv200e_properties = {
+	.caps = DVB_USB_ADAP_HAS_PID_FILTER |
DVB_USB_ADAP_NEED_PID_FILTERING | DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = CYPRESS_FX2,
+	//.firmware = "dvb-usb-digitv-02.fw", // no!
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.frontend_attach  = pctv200e_frontend_attach,
+			.tuner_attach     = pctv200e_tuner_attach,
+
+			/* parameter for the MPEG2-data transfer */
+			.stream = {
+				.type = USB_BULK,
+				.count = 7,
+				.endpoint = 0x02,
+				.u = {
+					.bulk = {
+						.buffersize = 4096,
+					}
+				}
+			},
+		}
+	},
+	.identify_state   = pctv200e_identify_state,
+
+	/*.rc_interval      = 1000,
+	.rc_key_map       = pctv200e_rc_keys,
+	.rc_key_map_size  = ARRAY_SIZE(pctv200e_rc_keys),
+	.rc_query         = pctv200e_rc_query,*/
+
+	.i2c_algo         = &pctv200e_i2c_algo,
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+
+	.num_device_descs = 2,
+	.devices = {
+		{   "Pinnacle PCTV 200e DVB-T",
+			{ &pctv200e_table[0], NULL },
+			{ NULL },
+		},
+		{   "Pinnacle PCTV 60e DVB-T",
+			{ &pctv200e_table[1], NULL },
+			{ NULL },
+		},
+		{ NULL },
+	}
+};
+
+static struct usb_driver pctv200e_driver = {
+#if LINUX_VERSION_CODE <=  KERNEL_VERSION(2,6,15)
+	.owner		= THIS_MODULE,
+#endif
+	.name		= "dvb_usb_pctv200e",
+	.probe		= pctv200e_probe,
+	.disconnect 	= dvb_usb_device_exit,
+	.id_table	= pctv200e_table,
+};
+
+/* module stuff */
+static int __init pctv200e_module_init(void)
+{
+	int result;
+	if ((result = usb_register(&pctv200e_driver))) {
+		err("usb_register failed. Error number %d",result);
+		return result;
+	}
+	warn("usb_register successfull.");
+
+	return 0;
+}
+
+static void __exit pctv200e_module_exit(void)
+{
+	/* deregister this driver from the USB subsystem */
+	warn("usb_DEregister started.");
+	usb_deregister(&pctv200e_driver);
+	warn("usb_DEregister successfull.");
+}
+
+module_init (pctv200e_module_init);
+module_exit (pctv200e_module_exit);
+
+MODULE_AUTHOR("Jakob Steidl <jakob.steidl@gmail.com>, Gabriele Dini
Ciacci <gabriele@diniciacci.org>"); +MODULE_DESCRIPTION("Driver for
Pinnacle PCTV 200e and 60e DVB-T USB2.0"); +MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
diff -uprN v4l-dvd/linux/drivers/media/dvb/dvb-usb/pctv200e.h
my_v4l-dvb/linux/drivers/media/dvb/dvb-usb/pctv200e.h ---
v4l-dvd/linux/drivers/media/dvb/dvb-usb/pctv200e.h	1970-01-01
01:00:00.000000000 +0100 +++
my_v4l-dvb/linux/drivers/media/dvb/dvb-usb/pctv200e.h	2008-01-02
02:09:34.000000000 +0100 @@ -0,0 +1,35 @@ +#ifndef _DVB_USB_PCTV200E_H_
+#define _DVB_USB_PCTV200E_H_ +
+#define DVB_USB_LOG_PREFIX "pctv200e"
+#include "dvb-usb.h"
+
+extern int dvb_usb_pctv200e_debug;
+#define deb_rc(args...)   dprintk(dvb_usb_pctv200e_debug,0x01,args)
+
+/*
+#define USB_READ_EEPROM         1
+
+#define USB_READ_COFDM          2
+#define USB_WRITE_COFDM         5
+
+#define USB_WRITE_TUNER         6
+
+#define USB_READ_REMOTE         3
+#define USB_WRITE_REMOTE        7
+#define USB_WRITE_REMOTE_TYPE   8
+
+#define USB_DEV_INIT            9
+*/
+
+
+#define USB_READ	1
+#define USB_WRITE	2
+
+#define TUNER_ADDR 0xc0
+#define DEMUX_ADDR 0x3e
+
+
+
+
+#endif

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
