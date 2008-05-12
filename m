Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xdsl-83-150-88-111.nebulazone.fi ([83.150.88.111]
	helo=ncircle.nullnet.fi) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomimo@ncircle.nullnet.fi>) id 1Jvd5t-0001Q6-4p
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 20:50:02 +0200
Message-ID: <60450.192.168.9.10.1210618180.squirrel@ncircle.nullnet.fi>
In-Reply-To: <48236E1F.5080300@free.fr>
References: <43276.192.168.9.10.1192357983.squirrel@ncircle.nullnet.fi>
	<20071018181040.GA6960@dose.home.local>
	<20071018182940.GA7317@dose.home.local>
	<20071018201418.GA16574@dose.home.local>
	<47075.192.168.9.10.1193248379.squirrel@ncircle.nullnet.fi>
	<472A0CC2.8040509@free.fr> <480F9062.6000700@free.fr>
	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>
	<481B4A78.8090305@free.fr>
	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>
	<481F66B0.4090302@free.fr> <4821F9A9.6030304@ncircle.nullnet.fi>
	<48236E1F.5080300@free.fr>
Date: Mon, 12 May 2008 21:49:40 +0300 (EEST)
From: "Tomi Orava" <tomimo@ncircle.nullnet.fi>
To: "Thierry Merle" <thierry.merle@free.fr>
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20080512214940_42853"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Testers wanted for alternative version of Terratec
 Cinergy T2 driver
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

------=_20080512214940_42853
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



Hi Thierry,

And thanks a lot for your patch. I've now updated the
Cinergy T2 driver patch with your remote control cleanup.

>> However, I did not replace the original Cinergy T2 driver
>> as I think that this new driver should be located in the
>> very same directory as the rest of the usb-dvb drivers.
>>
> Agreed, but you should remove the old cinergyT2 driver.

Ok, the attached version of the patch does remove the old driver.

> Furthermore there is another issue: when I plug the device, the device
> usage count is set to 0.
> When I remove the device the device usage count goes to -1 (displayed a=
s
> 4294967295).
> This is a misbehavior of the dvb framework but perhaps something needs =
to
> be initialized somewhere in the driver. I will look at it...dvb-usb:
> TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully initialized =
and
> connected.
> I noticed this error when I plug the device (I load manually the driver
> before, so I suspect a thing in the probe function):

In my understanding this is a bug in the dvb-usb-framework that cannot
be fixed in Cinergy T2 driver. I checked that if you DON'T define the
menuconfig option:

"Load and attach frontend and tuner driver modules as needed" ie.
the CONFIG_MEDIA_ATTACH

The framework will use a different version of the function called
"dvb_frontend_detach" and thefore it will not call the symbol_put_addr
on linux/drivers/media/dvb/dvb-core/dvb_frontend.c line 1220.
With this option deselected the module reference count seems to stay
in sane values.

> I will look at the module count problem and the irrecord problem, we ar=
e
> close to propose this beautiful patch ;)

Heh,heh :)

Regards,
Tomi Orava


--=20

------=_20080512214940_42853
Content-Type: text/x-patch; name="CinergyT2-V8.patch"
Content-Disposition: attachment; filename="CinergyT2-V8.patch"
Content-Transfer-Encoding: quoted-printable

diff -r 41b3f12d6ce4 linux/drivers/media/dvb/Kconfig
--- a/linux/drivers/media/dvb/Kconfig	Tue May 06 11:09:01 2008 -0300
+++ b/linux/drivers/media/dvb/Kconfig	Mon May 12 21:42:16 2008 +0300
@@ -20,7 +20,6 @@ source "drivers/media/dvb/dvb-usb/Kconfi
 source "drivers/media/dvb/dvb-usb/Kconfig"
 source "drivers/media/dvb/ttusb-budget/Kconfig"
 source "drivers/media/dvb/ttusb-dec/Kconfig"
-source "drivers/media/dvb/cinergyT2/Kconfig"
=20
 comment "Supported FlexCopII (B2C2) Adapters"
 	depends on DVB_CORE && (PCI || USB) && I2C
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/cinergyT2/Kconfig
--- a/linux/drivers/media/dvb/cinergyT2/Kconfig	Tue May 06 11:09:01 2008 =
-0300
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,85 +0,0 @@
-config DVB_CINERGYT2
-	tristate "Terratec CinergyT2/qanu USB2 DVB-T receiver"
-	depends on DVB_CORE && USB && INPUT
-	help
-	  Support for "TerraTec CinergyT2" USB2.0 Highspeed DVB Receivers
-
-	  Say Y if you own such a device and want to use it.
-
-
-config DVB_CINERGYT2_TUNING
-	bool "sophisticated fine-tuning for CinergyT2 cards"
-	depends on DVB_CINERGYT2
-	help
-	  Here you can fine-tune some parameters of the CinergyT2 driver.
-
-	  Normally you don't need to touch this, but in exotic setups you
-	  may fine-tune your setup and adjust e.g. DMA buffer sizes for
-	  a particular application.
-
-
-config DVB_CINERGYT2_STREAM_URB_COUNT
-	int "Number of queued USB Request Blocks for Highspeed Stream Transfers=
"
-	depends on DVB_CINERGYT2_TUNING
-	default "32"
-	help
-	  USB Request Blocks for Highspeed Stream transfers are scheduled in
-	  a queue for the Host Controller.
-
-	  Usually the default value is a safe choice.
-
-	  You may increase this number if you are using this device in a
-	  Server Environment with many high-traffic USB Highspeed devices
-	  sharing the same USB bus.
-
-
-config DVB_CINERGYT2_STREAM_BUF_SIZE
-	int "Size of URB Stream Buffers for Highspeed Transfers"
-	depends on DVB_CINERGYT2_TUNING
-	default "512"
-	help
-	  Should be a multiple of native buffer size of 512 bytes.
-	  Default value is a safe choice.
-
-	  You may increase this number if you are using this device in a
-	  Server Environment with many high-traffic USB Highspeed devices
-	  sharing the same USB bus.
-
-
-config DVB_CINERGYT2_QUERY_INTERVAL
-	int "Status update interval [milliseconds]"
-	depends on DVB_CINERGYT2_TUNING
-	default "250"
-	help
-	  This is the interval for status readouts from the demodulator.
-	  You may try lower values if you need more responsive signal quality
-	  measurements.
-
-	  Please keep in mind that these updates cause traffic on the tuner
-	  control bus and thus may or may not affect reception sensitivity.
-
-	  The default value should be a safe choice for common applications.
-
-
-config DVB_CINERGYT2_ENABLE_RC_INPUT_DEVICE
-	bool "Register the onboard IR Remote Control Receiver as Input Device"
-	depends on DVB_CINERGYT2_TUNING
-	default y
-	help
-	  Enable this option if you want to use the onboard Infrared Remote
-	  Control Receiver as Linux-Input device.
-
-	  Right now only the keycode table for the default Remote Control
-	  delivered with the device is supported, please see the driver
-	  source code to find out how to add support for other controls.
-
-
-config DVB_CINERGYT2_RC_QUERY_INTERVAL
-	int "Infrared Remote Controller update interval [milliseconds]"
-	depends on DVB_CINERGYT2_TUNING && DVB_CINERGYT2_ENABLE_RC_INPUT_DEVICE
-	default "50"
-	help
-	  If you have a very fast-repeating remote control you can try lower
-	  values, for normal consumer receivers the default value should be
-	  a safe choice.
-
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/cinergyT2/Makefile
--- a/linux/drivers/media/dvb/cinergyT2/Makefile	Tue May 06 11:09:01 2008=
 -0300
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,3 +0,0 @@
-obj-$(CONFIG_DVB_CINERGYT2) +=3D cinergyT2.o
-
-EXTRA_CFLAGS +=3D -Idrivers/media/dvb/dvb-core/
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/cinergyT2/cinergyT2.c
--- a/linux/drivers/media/dvb/cinergyT2/cinergyT2.c	Tue May 06 11:09:01 2=
008 -0300
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,1178 +0,0 @@
-/*
- * TerraTec Cinergy T=C2=B2/qanu USB2 DVB-T adapter.
- *
- * Copyright (C) 2004 Daniel Mack <daniel@qanu.de> and
- *		    Holger Waechtler <holger@qanu.de>
- *
- *  Protocol Spec published on http://qanu.de/specs/terratec_cinergyT2.p=
df
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/usb.h>
-#include <linux/input.h>
-#include <linux/dvb/frontend.h>
-#include "compat.h"
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,15)
-#include <linux/mutex.h>
-#endif
-#include <linux/mm.h>
-#include <asm/io.h>
-
-#include "dmxdev.h"
-#include "dvb_demux.h"
-#include "dvb_net.h"
-
-#ifdef CONFIG_DVB_CINERGYT2_TUNING
-	#define STREAM_URB_COUNT (CONFIG_DVB_CINERGYT2_STREAM_URB_COUNT)
-	#define STREAM_BUF_SIZE (CONFIG_DVB_CINERGYT2_STREAM_BUF_SIZE)
-	#define QUERY_INTERVAL (CONFIG_DVB_CINERGYT2_QUERY_INTERVAL)
-	#ifdef CONFIG_DVB_CINERGYT2_ENABLE_RC_INPUT_DEVICE
-		#define RC_QUERY_INTERVAL (CONFIG_DVB_CINERGYT2_RC_QUERY_INTERVAL)
-		#define ENABLE_RC (1)
-	#endif
-#else
-	#define STREAM_URB_COUNT (32)
-	#define STREAM_BUF_SIZE (512)	/* bytes */
-	#define ENABLE_RC (1)
-	#define RC_QUERY_INTERVAL (50)	/* milliseconds */
-	#define QUERY_INTERVAL (333)	/* milliseconds */
-#endif
-
-#define DRIVER_NAME "TerraTec/qanu USB2.0 Highspeed DVB-T Receiver"
-
-static int debug;
-module_param_named(debug, debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
-
-DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
-
-#if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2,6,15)
-#define dprintk(level, args...)						\
-do {									\
-	if ((debug & level)) {						\
-		printk("%s: %s(): ", __stringify(KBUILD_MODNAME),	\
-		       __FUNCTION__);					\
-		printk(args); }						\
-} while (0)
-#else
-#define dprintk(level, args...)						\
-do {									\
-	if ((debug & level)) {						\
-		printk("%s: %s(): ", KBUILD_MODNAME,			\
-		       __func__);					\
-		printk(args); }						\
-} while (0)
-#endif
-
-enum cinergyt2_ep1_cmd {
-	CINERGYT2_EP1_PID_TABLE_RESET		=3D 0x01,
-	CINERGYT2_EP1_PID_SETUP			=3D 0x02,
-	CINERGYT2_EP1_CONTROL_STREAM_TRANSFER	=3D 0x03,
-	CINERGYT2_EP1_SET_TUNER_PARAMETERS	=3D 0x04,
-	CINERGYT2_EP1_GET_TUNER_STATUS		=3D 0x05,
-	CINERGYT2_EP1_START_SCAN		=3D 0x06,
-	CINERGYT2_EP1_CONTINUE_SCAN		=3D 0x07,
-	CINERGYT2_EP1_GET_RC_EVENTS		=3D 0x08,
-	CINERGYT2_EP1_SLEEP_MODE		=3D 0x09
-};
-
-struct dvbt_set_parameters_msg {
-	uint8_t cmd;
-	uint32_t freq;
-	uint8_t bandwidth;
-	uint16_t tps;
-	uint8_t flags;
-} __attribute__((packed));
-
-struct dvbt_get_status_msg {
-	uint32_t freq;
-	uint8_t bandwidth;
-	uint16_t tps;
-	uint8_t flags;
-	uint16_t gain;
-	uint8_t snr;
-	uint32_t viterbi_error_rate;
-	uint32_t rs_error_rate;
-	uint32_t uncorrected_block_count;
-	uint8_t lock_bits;
-	uint8_t prev_lock_bits;
-} __attribute__((packed));
-
-static struct dvb_frontend_info cinergyt2_fe_info =3D {
-	.name =3D DRIVER_NAME,
-	.type =3D FE_OFDM,
-	.frequency_min =3D 174000000,
-	.frequency_max =3D 862000000,
-	.frequency_stepsize =3D 166667,
-	.caps =3D FE_CAN_INVERSION_AUTO | FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
-		FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
-		FE_CAN_FEC_AUTO |
-		FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
-		FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO |
-		FE_CAN_HIERARCHY_AUTO | FE_CAN_RECOVER | FE_CAN_MUTE_TS
-};
-
-struct cinergyt2 {
-	struct dvb_demux demux;
-	struct usb_device *udev;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,15)
-	struct mutex sem;
-	struct mutex wq_sem;
-#else
-	struct semaphore sem;
-	struct semaphore wq_sem;
-#endif
-	struct dvb_adapter adapter;
-	struct dvb_device *fedev;
-	struct dmxdev dmxdev;
-	struct dvb_net dvbnet;
-
-	int streaming;
-	int sleeping;
-
-	struct dvbt_set_parameters_msg param;
-	struct dvbt_get_status_msg status;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	struct work_struct query_work;
-#else
-	struct delayed_work query_work;
-#endif
-
-	wait_queue_head_t poll_wq;
-	int pending_fe_events;
-	int disconnect_pending;
-	atomic_t inuse;
-
-	void *streambuf;
-	dma_addr_t streambuf_dmahandle;
-	struct urb *stream_urb [STREAM_URB_COUNT];
-
-#ifdef ENABLE_RC
-	struct input_dev *rc_input_dev;
-	char phys[64];
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	struct work_struct rc_query_work;
-#else
-	struct delayed_work rc_query_work;
-#endif
-	int rc_input_event;
-	u32 rc_last_code;
-	unsigned long last_event_jiffies;
-#endif
-};
-
-enum {
-	CINERGYT2_RC_EVENT_TYPE_NONE =3D 0x00,
-	CINERGYT2_RC_EVENT_TYPE_NEC  =3D 0x01,
-	CINERGYT2_RC_EVENT_TYPE_RC5  =3D 0x02
-};
-
-struct cinergyt2_rc_event {
-	char type;
-	uint32_t value;
-} __attribute__((packed));
-
-static const uint32_t rc_keys[] =3D {
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xfe01eb04,	KEY_POWER,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xfd02eb04,	KEY_1,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xfc03eb04,	KEY_2,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xfb04eb04,	KEY_3,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xfa05eb04,	KEY_4,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xf906eb04,	KEY_5,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xf807eb04,	KEY_6,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xf708eb04,	KEY_7,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xf609eb04,	KEY_8,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xf50aeb04,	KEY_9,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xf30ceb04,	KEY_0,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xf40beb04,	KEY_VIDEO,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xf20deb04,	KEY_REFRESH,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xf10eeb04,	KEY_SELECT,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xf00feb04,	KEY_EPG,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xef10eb04,	KEY_UP,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xeb14eb04,	KEY_DOWN,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xee11eb04,	KEY_LEFT,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xec13eb04,	KEY_RIGHT,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xed12eb04,	KEY_OK,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xea15eb04,	KEY_TEXT,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xe916eb04,	KEY_INFO,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xe817eb04,	KEY_RED,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xe718eb04,	KEY_GREEN,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xe619eb04,	KEY_YELLOW,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xe51aeb04,	KEY_BLUE,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xe31ceb04,	KEY_VOLUMEUP,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xe11eeb04,	KEY_VOLUMEDOWN,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xe21deb04,	KEY_MUTE,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xe41beb04,	KEY_CHANNELUP,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xe01feb04,	KEY_CHANNELDOWN,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xbf40eb04,	KEY_PAUSE,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xb34ceb04,	KEY_PLAY,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xa758eb04,	KEY_RECORD,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xab54eb04,	KEY_PREVIOUS,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xb748eb04,	KEY_STOP,
-	CINERGYT2_RC_EVENT_TYPE_NEC,	0xa35ceb04,	KEY_NEXT
-};
-
-static int cinergyt2_command (struct cinergyt2 *cinergyt2,
-			      char *send_buf, int send_buf_len,
-			      char *recv_buf, int recv_buf_len)
-{
-	int actual_len;
-	char dummy;
-	int ret;
-
-	ret =3D usb_bulk_msg(cinergyt2->udev, usb_sndbulkpipe(cinergyt2->udev, =
1),
-			   send_buf, send_buf_len, &actual_len, 1000);
-
-	if (ret)
-		dprintk(1, "usb_bulk_msg (send) failed, err %i\n", ret);
-
-	if (!recv_buf)
-		recv_buf =3D &dummy;
-
-	ret =3D usb_bulk_msg(cinergyt2->udev, usb_rcvbulkpipe(cinergyt2->udev, =
1),
-			   recv_buf, recv_buf_len, &actual_len, 1000);
-
-	if (ret)
-		dprintk(1, "usb_bulk_msg (read) failed, err %i\n", ret);
-
-	return ret ? ret : actual_len;
-}
-
-static void cinergyt2_control_stream_transfer (struct cinergyt2 *cinergy=
t2, int enable)
-{
-	char buf [] =3D { CINERGYT2_EP1_CONTROL_STREAM_TRANSFER, enable ? 1 : 0=
 };
-	cinergyt2_command(cinergyt2, buf, sizeof(buf), NULL, 0);
-}
-
-static void cinergyt2_sleep (struct cinergyt2 *cinergyt2, int sleep)
-{
-	char buf [] =3D { CINERGYT2_EP1_SLEEP_MODE, sleep ? 1 : 0 };
-	cinergyt2_command(cinergyt2, buf, sizeof(buf), NULL, 0);
-	cinergyt2->sleeping =3D sleep;
-}
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
-static void cinergyt2_stream_irq (struct urb *urb, struct pt_regs *regs)=
;
-#else
-static void cinergyt2_stream_irq (struct urb *urb);
-#endif
-
-static int cinergyt2_submit_stream_urb (struct cinergyt2 *cinergyt2, str=
uct urb *urb)
-{
-	int err;
-
-	usb_fill_bulk_urb(urb,
-			  cinergyt2->udev,
-			  usb_rcvbulkpipe(cinergyt2->udev, 0x2),
-			  urb->transfer_buffer,
-			  STREAM_BUF_SIZE,
-			  cinergyt2_stream_irq,
-			  cinergyt2);
-
-	if ((err =3D usb_submit_urb(urb, GFP_ATOMIC)))
-		dprintk(1, "urb submission failed (err =3D %i)!\n", err);
-
-	return err;
-}
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
-static void cinergyt2_stream_irq (struct urb *urb, struct pt_regs *regs)
-#else
-static void cinergyt2_stream_irq (struct urb *urb)
-#endif
-{
-	struct cinergyt2 *cinergyt2 =3D urb->context;
-
-	if (urb->actual_length > 0)
-		dvb_dmx_swfilter(&cinergyt2->demux,
-				 urb->transfer_buffer, urb->actual_length);
-
-	if (cinergyt2->streaming)
-		cinergyt2_submit_stream_urb(cinergyt2, urb);
-}
-
-static void cinergyt2_free_stream_urbs (struct cinergyt2 *cinergyt2)
-{
-	int i;
-
-	for (i=3D0; i<STREAM_URB_COUNT; i++)
-		usb_free_urb(cinergyt2->stream_urb[i]);
-
-	usb_buffer_free(cinergyt2->udev, STREAM_URB_COUNT*STREAM_BUF_SIZE,
-			    cinergyt2->streambuf, cinergyt2->streambuf_dmahandle);
-}
-
-static int cinergyt2_alloc_stream_urbs (struct cinergyt2 *cinergyt2)
-{
-	int i;
-
-	cinergyt2->streambuf =3D usb_buffer_alloc(cinergyt2->udev, STREAM_URB_C=
OUNT*STREAM_BUF_SIZE,
-					      GFP_KERNEL, &cinergyt2->streambuf_dmahandle);
-	if (!cinergyt2->streambuf) {
-		dprintk(1, "failed to alloc consistent stream memory area, bailing out=
!\n");
-		return -ENOMEM;
-	}
-
-	memset(cinergyt2->streambuf, 0, STREAM_URB_COUNT*STREAM_BUF_SIZE);
-
-	for (i=3D0; i<STREAM_URB_COUNT; i++) {
-		struct urb *urb;
-
-		if (!(urb =3D usb_alloc_urb(0, GFP_ATOMIC))) {
-			dprintk(1, "failed to alloc consistent stream urbs, bailing out!\n");
-			cinergyt2_free_stream_urbs(cinergyt2);
-			return -ENOMEM;
-		}
-
-		urb->transfer_buffer =3D cinergyt2->streambuf + i * STREAM_BUF_SIZE;
-		urb->transfer_buffer_length =3D STREAM_BUF_SIZE;
-
-		cinergyt2->stream_urb[i] =3D urb;
-	}
-
-	return 0;
-}
-
-static void cinergyt2_stop_stream_xfer (struct cinergyt2 *cinergyt2)
-{
-	int i;
-
-	cinergyt2_control_stream_transfer(cinergyt2, 0);
-
-	for (i=3D0; i<STREAM_URB_COUNT; i++)
-		usb_kill_urb(cinergyt2->stream_urb[i]);
-}
-
-static int cinergyt2_start_stream_xfer (struct cinergyt2 *cinergyt2)
-{
-	int i, err;
-
-	for (i=3D0; i<STREAM_URB_COUNT; i++) {
-		if ((err =3D cinergyt2_submit_stream_urb(cinergyt2, cinergyt2->stream_=
urb[i]))) {
-			cinergyt2_stop_stream_xfer(cinergyt2);
-			dprintk(1, "failed urb submission (%i: err =3D %i)!\n", i, err);
-			return err;
-		}
-	}
-
-	cinergyt2_control_stream_transfer(cinergyt2, 1);
-	return 0;
-}
-
-static int cinergyt2_start_feed(struct dvb_demux_feed *dvbdmxfeed)
-{
-	struct dvb_demux *demux =3D dvbdmxfeed->demux;
-	struct cinergyt2 *cinergyt2 =3D demux->priv;
-
-	if (cinergyt2->disconnect_pending)
-		return -EAGAIN;
-	if (mutex_lock_interruptible(&cinergyt2->sem))
-		return -ERESTARTSYS;
-
-	if (cinergyt2->streaming =3D=3D 0)
-		cinergyt2_start_stream_xfer(cinergyt2);
-
-	cinergyt2->streaming++;
-	mutex_unlock(&cinergyt2->sem);
-	return 0;
-}
-
-static int cinergyt2_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
-{
-	struct dvb_demux *demux =3D dvbdmxfeed->demux;
-	struct cinergyt2 *cinergyt2 =3D demux->priv;
-
-	if (cinergyt2->disconnect_pending)
-		return -EAGAIN;
-	if (mutex_lock_interruptible(&cinergyt2->sem))
-		return -ERESTARTSYS;
-
-	if (--cinergyt2->streaming =3D=3D 0)
-		cinergyt2_stop_stream_xfer(cinergyt2);
-
-	mutex_unlock(&cinergyt2->sem);
-	return 0;
-}
-
-/**
- *  convert linux-dvb frontend parameter set into TPS.
- *  See ETSI ETS-300744, section 4.6.2, table 9 for details.
- *
- *  This function is probably reusable and may better get placed in a su=
pport
- *  library.
- *
- *  We replace errornous fields by default TPS fields (the ones with val=
ue 0).
- */
-static uint16_t compute_tps (struct dvb_frontend_parameters *p)
-{
-	struct dvb_ofdm_parameters *op =3D &p->u.ofdm;
-	uint16_t tps =3D 0;
-
-	switch (op->code_rate_HP) {
-		case FEC_2_3:
-			tps |=3D (1 << 7);
-			break;
-		case FEC_3_4:
-			tps |=3D (2 << 7);
-			break;
-		case FEC_5_6:
-			tps |=3D (3 << 7);
-			break;
-		case FEC_7_8:
-			tps |=3D (4 << 7);
-			break;
-		case FEC_1_2:
-		case FEC_AUTO:
-		default:
-			/* tps |=3D (0 << 7) */;
-	}
-
-	switch (op->code_rate_LP) {
-		case FEC_2_3:
-			tps |=3D (1 << 4);
-			break;
-		case FEC_3_4:
-			tps |=3D (2 << 4);
-			break;
-		case FEC_5_6:
-			tps |=3D (3 << 4);
-			break;
-		case FEC_7_8:
-			tps |=3D (4 << 4);
-			break;
-		case FEC_1_2:
-		case FEC_AUTO:
-		default:
-			/* tps |=3D (0 << 4) */;
-	}
-
-	switch (op->constellation) {
-		case QAM_16:
-			tps |=3D (1 << 13);
-			break;
-		case QAM_64:
-			tps |=3D (2 << 13);
-			break;
-		case QPSK:
-		default:
-			/* tps |=3D (0 << 13) */;
-	}
-
-	switch (op->transmission_mode) {
-		case TRANSMISSION_MODE_8K:
-			tps |=3D (1 << 0);
-			break;
-		case TRANSMISSION_MODE_2K:
-		default:
-			/* tps |=3D (0 << 0) */;
-	}
-
-	switch (op->guard_interval) {
-		case GUARD_INTERVAL_1_16:
-			tps |=3D (1 << 2);
-			break;
-		case GUARD_INTERVAL_1_8:
-			tps |=3D (2 << 2);
-			break;
-		case GUARD_INTERVAL_1_4:
-			tps |=3D (3 << 2);
-			break;
-		case GUARD_INTERVAL_1_32:
-		default:
-			/* tps |=3D (0 << 2) */;
-	}
-
-	switch (op->hierarchy_information) {
-		case HIERARCHY_1:
-			tps |=3D (1 << 10);
-			break;
-		case HIERARCHY_2:
-			tps |=3D (2 << 10);
-			break;
-		case HIERARCHY_4:
-			tps |=3D (3 << 10);
-			break;
-		case HIERARCHY_NONE:
-		default:
-			/* tps |=3D (0 << 10) */;
-	}
-
-	return tps;
-}
-
-static int cinergyt2_open (struct inode *inode, struct file *file)
-{
-	struct dvb_device *dvbdev =3D file->private_data;
-	struct cinergyt2 *cinergyt2 =3D dvbdev->priv;
-	int err =3D -EAGAIN;
-
-	if (cinergyt2->disconnect_pending)
-		goto out;
-	err =3D mutex_lock_interruptible(&cinergyt2->wq_sem);
-	if (err)
-		goto out;
-
-	err =3D mutex_lock_interruptible(&cinergyt2->sem);
-	if (err)
-		goto out_unlock1;
-
-	if ((err =3D dvb_generic_open(inode, file)))
-		goto out_unlock2;
-
-	if ((file->f_flags & O_ACCMODE) !=3D O_RDONLY) {
-		cinergyt2_sleep(cinergyt2, 0);
-		schedule_delayed_work(&cinergyt2->query_work, HZ/2);
-	}
-
-	atomic_inc(&cinergyt2->inuse);
-
-out_unlock2:
-	mutex_unlock(&cinergyt2->sem);
-out_unlock1:
-	mutex_unlock(&cinergyt2->wq_sem);
-out:
-	return err;
-}
-
-static void cinergyt2_unregister(struct cinergyt2 *cinergyt2)
-{
-	dvb_net_release(&cinergyt2->dvbnet);
-	dvb_dmxdev_release(&cinergyt2->dmxdev);
-	dvb_dmx_release(&cinergyt2->demux);
-	dvb_unregister_device(cinergyt2->fedev);
-	dvb_unregister_adapter(&cinergyt2->adapter);
-
-	cinergyt2_free_stream_urbs(cinergyt2);
-	kfree(cinergyt2);
-}
-
-static int cinergyt2_release (struct inode *inode, struct file *file)
-{
-	struct dvb_device *dvbdev =3D file->private_data;
-	struct cinergyt2 *cinergyt2 =3D dvbdev->priv;
-
-	mutex_lock(&cinergyt2->wq_sem);
-
-	if (!cinergyt2->disconnect_pending && (file->f_flags & O_ACCMODE) !=3D =
O_RDONLY) {
-		cancel_rearming_delayed_work(&cinergyt2->query_work);
-
-		mutex_lock(&cinergyt2->sem);
-		cinergyt2_sleep(cinergyt2, 1);
-		mutex_unlock(&cinergyt2->sem);
-	}
-
-	mutex_unlock(&cinergyt2->wq_sem);
-
-	if (atomic_dec_and_test(&cinergyt2->inuse) && cinergyt2->disconnect_pen=
ding) {
-		warn("delayed unregister in release");
-		cinergyt2_unregister(cinergyt2);
-	}
-
-	return dvb_generic_release(inode, file);
-}
-
-static unsigned int cinergyt2_poll (struct file *file, struct poll_table=
_struct *wait)
-{
-	struct dvb_device *dvbdev =3D file->private_data;
-	struct cinergyt2 *cinergyt2 =3D dvbdev->priv;
-	unsigned int mask =3D 0;
-
-	if (cinergyt2->disconnect_pending)
-		return -EAGAIN;
-	if (mutex_lock_interruptible(&cinergyt2->sem))
-		return -ERESTARTSYS;
-
-	poll_wait(file, &cinergyt2->poll_wq, wait);
-
-	if (cinergyt2->pending_fe_events !=3D 0)
-		mask |=3D (POLLIN | POLLRDNORM | POLLPRI);
-
-	mutex_unlock(&cinergyt2->sem);
-
-	return mask;
-}
-
-
-static int cinergyt2_ioctl (struct inode *inode, struct file *file,
-		     unsigned cmd, unsigned long arg)
-{
-	struct dvb_device *dvbdev =3D file->private_data;
-	struct cinergyt2 *cinergyt2 =3D dvbdev->priv;
-	struct dvbt_get_status_msg *stat =3D &cinergyt2->status;
-	fe_status_t status =3D 0;
-
-	switch (cmd) {
-	case FE_GET_INFO:
-		return copy_to_user((void __user*) arg, &cinergyt2_fe_info,
-				    sizeof(struct dvb_frontend_info));
-
-	case FE_READ_STATUS:
-		if (0xffff - le16_to_cpu(stat->gain) > 30)
-			status |=3D FE_HAS_SIGNAL;
-		if (stat->lock_bits & (1 << 6))
-			status |=3D FE_HAS_LOCK;
-		if (stat->lock_bits & (1 << 5))
-			status |=3D FE_HAS_SYNC;
-		if (stat->lock_bits & (1 << 4))
-			status |=3D FE_HAS_CARRIER;
-		if (stat->lock_bits & (1 << 1))
-			status |=3D FE_HAS_VITERBI;
-
-		return copy_to_user((void  __user*) arg, &status, sizeof(status));
-
-	case FE_READ_BER:
-		return put_user(le32_to_cpu(stat->viterbi_error_rate),
-				(__u32 __user *) arg);
-
-	case FE_READ_SIGNAL_STRENGTH:
-		return put_user(0xffff - le16_to_cpu(stat->gain),
-				(__u16 __user *) arg);
-
-	case FE_READ_SNR:
-		return put_user((stat->snr << 8) | stat->snr,
-				(__u16 __user *) arg);
-
-	case FE_READ_UNCORRECTED_BLOCKS:
-	{
-		uint32_t unc_count;
-
-		unc_count =3D stat->uncorrected_block_count;
-		stat->uncorrected_block_count =3D 0;
-
-		/* UNC are already converted to host byte order... */
-		return put_user(unc_count,(__u32 __user *) arg);
-	}
-	case FE_SET_FRONTEND:
-	{
-		struct dvbt_set_parameters_msg *param =3D &cinergyt2->param;
-		struct dvb_frontend_parameters p;
-		int err;
-
-		if ((file->f_flags & O_ACCMODE) =3D=3D O_RDONLY)
-			return -EPERM;
-
-		if (copy_from_user(&p, (void  __user*) arg, sizeof(p)))
-			return -EFAULT;
-
-		if (cinergyt2->disconnect_pending)
-			return -EAGAIN;
-		if (mutex_lock_interruptible(&cinergyt2->sem))
-			return -ERESTARTSYS;
-
-		param->cmd =3D CINERGYT2_EP1_SET_TUNER_PARAMETERS;
-		param->tps =3D cpu_to_le16(compute_tps(&p));
-		param->freq =3D cpu_to_le32(p.frequency / 1000);
-		param->bandwidth =3D 8 - p.u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
-
-		stat->lock_bits =3D 0;
-		cinergyt2->pending_fe_events++;
-		wake_up_interruptible(&cinergyt2->poll_wq);
-
-		err =3D cinergyt2_command(cinergyt2,
-					(char *) param, sizeof(*param),
-					NULL, 0);
-
-		mutex_unlock(&cinergyt2->sem);
-
-		return (err < 0) ? err : 0;
-	}
-
-	case FE_GET_FRONTEND:
-		/**
-		 *  trivial to implement (see struct dvbt_get_status_msg).
-		 *  equivalent to FE_READ ioctls, but needs
-		 *  TPS -> linux-dvb parameter set conversion. Feel free
-		 *  to implement this and send us a patch if you need this
-		 *  functionality.
-		 */
-		break;
-
-	case FE_GET_EVENT:
-	{
-		/**
-		 *  for now we only fill the status field. the parameters
-		 *  are trivial to fill as soon FE_GET_FRONTEND is done.
-		 */
-		struct dvb_frontend_event __user *e =3D (void __user *) arg;
-		if (cinergyt2->pending_fe_events =3D=3D 0) {
-			if (file->f_flags & O_NONBLOCK)
-				return -EWOULDBLOCK;
-			wait_event_interruptible(cinergyt2->poll_wq,
-						 cinergyt2->pending_fe_events > 0);
-		}
-		cinergyt2->pending_fe_events =3D 0;
-		return cinergyt2_ioctl(inode, file, FE_READ_STATUS,
-					(unsigned long) &e->status);
-	}
-
-	default:
-		;
-	}
-
-	return -EINVAL;
-}
-
-static int cinergyt2_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct dvb_device *dvbdev =3D file->private_data;
-	struct cinergyt2 *cinergyt2 =3D dvbdev->priv;
-	int ret =3D 0;
-
-	lock_kernel();
-
-	if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
-		ret =3D -EPERM;
-		goto bailout;
-	}
-
-	if (vma->vm_end > vma->vm_start + STREAM_URB_COUNT * STREAM_BUF_SIZE) {
-		ret =3D -EINVAL;
-		goto bailout;
-	}
-
-	vma->vm_flags |=3D (VM_IO | VM_DONTCOPY);
-	vma->vm_file =3D file;
-
-	ret =3D remap_pfn_range(vma, vma->vm_start,
-			      virt_to_phys(cinergyt2->streambuf) >> PAGE_SHIFT,
-			      vma->vm_end - vma->vm_start,
-			      vma->vm_page_prot) ? -EAGAIN : 0;
-bailout:
-	unlock_kernel();
-	return ret;
-}
-
-static struct file_operations cinergyt2_fops =3D {
-	.owner          =3D THIS_MODULE,
-	.ioctl		=3D cinergyt2_ioctl,
-	.poll           =3D cinergyt2_poll,
-	.open           =3D cinergyt2_open,
-	.release        =3D cinergyt2_release,
-	.mmap		=3D cinergyt2_mmap
-};
-
-static struct dvb_device cinergyt2_fe_template =3D {
-	.users =3D ~0,
-	.writers =3D 1,
-	.readers =3D (~0)-1,
-	.fops =3D &cinergyt2_fops
-};
-
-#ifdef ENABLE_RC
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void cinergyt2_query_rc (void *data)
-#else
-static void cinergyt2_query_rc (struct work_struct *work)
-#endif
-{
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	struct cinergyt2 *cinergyt2 =3D data;
-#else
-	struct cinergyt2 *cinergyt2 =3D
-		container_of(work, struct cinergyt2, rc_query_work.work);
-#endif
-	char buf[1] =3D { CINERGYT2_EP1_GET_RC_EVENTS };
-	struct cinergyt2_rc_event rc_events[12];
-	int n, len, i;
-
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt=
2->sem))
-		return;
-
-	len =3D cinergyt2_command(cinergyt2, buf, sizeof(buf),
-				(char *) rc_events, sizeof(rc_events));
-	if (len < 0)
-		goto out;
-	if (len =3D=3D 0) {
-		if (time_after(jiffies, cinergyt2->last_event_jiffies +
-			       msecs_to_jiffies(150))) {
-			/* stop key repeat */
-			if (cinergyt2->rc_input_event !=3D KEY_MAX) {
-				dprintk(1, "rc_input_event=3D%d Up\n", cinergyt2->rc_input_event);
-				input_report_key(cinergyt2->rc_input_dev,
-						 cinergyt2->rc_input_event, 0);
-				input_sync(cinergyt2->rc_input_dev);
-				cinergyt2->rc_input_event =3D KEY_MAX;
-			}
-			cinergyt2->rc_last_code =3D ~0;
-		}
-		goto out;
-	}
-	cinergyt2->last_event_jiffies =3D jiffies;
-
-	for (n =3D 0; n < (len / sizeof(rc_events[0])); n++) {
-		dprintk(1, "rc_events[%d].value =3D %x, type=3D%x\n",
-			n, le32_to_cpu(rc_events[n].value), rc_events[n].type);
-
-		if (rc_events[n].type =3D=3D CINERGYT2_RC_EVENT_TYPE_NEC &&
-		    rc_events[n].value =3D=3D ~0) {
-			/* keyrepeat bit -> just repeat last rc_input_event */
-		} else {
-			cinergyt2->rc_input_event =3D KEY_MAX;
-			for (i =3D 0; i < ARRAY_SIZE(rc_keys); i +=3D 3) {
-				if (rc_keys[i + 0] =3D=3D rc_events[n].type &&
-				    rc_keys[i + 1] =3D=3D le32_to_cpu(rc_events[n].value)) {
-					cinergyt2->rc_input_event =3D rc_keys[i + 2];
-					break;
-				}
-			}
-		}
-
-		if (cinergyt2->rc_input_event !=3D KEY_MAX) {
-			if (rc_events[n].value =3D=3D cinergyt2->rc_last_code &&
-			    cinergyt2->rc_last_code !=3D ~0) {
-				/* emit a key-up so the double event is recognized */
-				dprintk(1, "rc_input_event=3D%d UP\n", cinergyt2->rc_input_event);
-				input_report_key(cinergyt2->rc_input_dev,
-						 cinergyt2->rc_input_event, 0);
-			}
-			dprintk(1, "rc_input_event=3D%d\n", cinergyt2->rc_input_event);
-			input_report_key(cinergyt2->rc_input_dev,
-					 cinergyt2->rc_input_event, 1);
-			input_sync(cinergyt2->rc_input_dev);
-			cinergyt2->rc_last_code =3D rc_events[n].value;
-		}
-	}
-
-out:
-	schedule_delayed_work(&cinergyt2->rc_query_work,
-			      msecs_to_jiffies(RC_QUERY_INTERVAL));
-
-	mutex_unlock(&cinergyt2->sem);
-}
-
-static int cinergyt2_register_rc(struct cinergyt2 *cinergyt2)
-{
-	struct input_dev *input_dev;
-	int i;
-	int err;
-
-	input_dev =3D input_allocate_device();
-	if (!input_dev)
-		return -ENOMEM;
-
-	usb_make_path(cinergyt2->udev, cinergyt2->phys, sizeof(cinergyt2->phys)=
);
-	strlcat(cinergyt2->phys, "/input0", sizeof(cinergyt2->phys));
-	cinergyt2->rc_input_event =3D KEY_MAX;
-	cinergyt2->rc_last_code =3D ~0;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	INIT_WORK(&cinergyt2->rc_query_work, cinergyt2_query_rc, cinergyt2);
-#else
-	INIT_DELAYED_WORK(&cinergyt2->rc_query_work, cinergyt2_query_rc);
-#endif
-
-	input_dev->name =3D DRIVER_NAME " remote control";
-	input_dev->phys =3D cinergyt2->phys;
-	input_dev->evbit[0] =3D BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
-	for (i =3D 0; i < ARRAY_SIZE(rc_keys); i +=3D 3)
-		set_bit(rc_keys[i + 2], input_dev->keybit);
-	input_dev->keycodesize =3D 0;
-	input_dev->keycodemax =3D 0;
-	input_dev->id.bustype =3D BUS_USB;
-	input_dev->id.vendor =3D cinergyt2->udev->descriptor.idVendor;
-	input_dev->id.product =3D cinergyt2->udev->descriptor.idProduct;
-	input_dev->id.version =3D 1;
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,22)
-	input_dev->dev.parent =3D &cinergyt2->udev->dev;
-#else
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,15)
-	input_dev->cdev.dev =3D &cinergyt2->udev->dev;
-#else
-	input_dev->dev =3D &cinergyt2->udev->dev;
-#endif
-#endif
-
-	err =3D input_register_device(input_dev);
-	if (err) {
-		input_free_device(input_dev);
-		return err;
-	}
-
-	cinergyt2->rc_input_dev =3D input_dev;
-	schedule_delayed_work(&cinergyt2->rc_query_work, HZ/2);
-
-	return 0;
-}
-
-static void cinergyt2_unregister_rc(struct cinergyt2 *cinergyt2)
-{
-	cancel_rearming_delayed_work(&cinergyt2->rc_query_work);
-	input_unregister_device(cinergyt2->rc_input_dev);
-}
-
-static inline void cinergyt2_suspend_rc(struct cinergyt2 *cinergyt2)
-{
-	cancel_rearming_delayed_work(&cinergyt2->rc_query_work);
-}
-
-static inline void cinergyt2_resume_rc(struct cinergyt2 *cinergyt2)
-{
-	schedule_delayed_work(&cinergyt2->rc_query_work, HZ/2);
-}
-
-#else
-
-static inline int cinergyt2_register_rc(struct cinergyt2 *cinergyt2) { r=
eturn 0; }
-static inline void cinergyt2_unregister_rc(struct cinergyt2 *cinergyt2) =
{ }
-static inline void cinergyt2_suspend_rc(struct cinergyt2 *cinergyt2) { }
-static inline void cinergyt2_resume_rc(struct cinergyt2 *cinergyt2) { }
-
-#endif /* ENABLE_RC */
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void cinergyt2_query (void *data)
-#else
-static void cinergyt2_query (struct work_struct *work)
-#endif
-{
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	struct cinergyt2 *cinergyt2 =3D (struct cinergyt2 *) data;
-#else
-	struct cinergyt2 *cinergyt2 =3D
-		container_of(work, struct cinergyt2, query_work.work);
-#endif
-	char cmd [] =3D { CINERGYT2_EP1_GET_TUNER_STATUS };
-	struct dvbt_get_status_msg *s =3D &cinergyt2->status;
-	uint8_t lock_bits;
-	uint32_t unc;
-
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt=
2->sem))
-		return;
-
-	unc =3D s->uncorrected_block_count;
-	lock_bits =3D s->lock_bits;
-
-	cinergyt2_command(cinergyt2, cmd, sizeof(cmd), (char *) s, sizeof(*s));
-
-	unc +=3D le32_to_cpu(s->uncorrected_block_count);
-	s->uncorrected_block_count =3D unc;
-
-	if (lock_bits !=3D s->lock_bits) {
-		wake_up_interruptible(&cinergyt2->poll_wq);
-		cinergyt2->pending_fe_events++;
-	}
-
-	schedule_delayed_work(&cinergyt2->query_work,
-			      msecs_to_jiffies(QUERY_INTERVAL));
-
-	mutex_unlock(&cinergyt2->sem);
-}
-
-static int cinergyt2_probe (struct usb_interface *intf,
-		  const struct usb_device_id *id)
-{
-	struct cinergyt2 *cinergyt2;
-	int err;
-
-	if (!(cinergyt2 =3D kzalloc (sizeof(struct cinergyt2), GFP_KERNEL))) {
-		dprintk(1, "out of memory?!?\n");
-		return -ENOMEM;
-	}
-
-	usb_set_intfdata (intf, (void *) cinergyt2);
-
-	mutex_init(&cinergyt2->sem);
-	mutex_init(&cinergyt2->wq_sem);
-	init_waitqueue_head (&cinergyt2->poll_wq);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	INIT_WORK(&cinergyt2->query_work, cinergyt2_query, cinergyt2);
-#else
-	INIT_DELAYED_WORK(&cinergyt2->query_work, cinergyt2_query);
-#endif
-
-	cinergyt2->udev =3D interface_to_usbdev(intf);
-	cinergyt2->param.cmd =3D CINERGYT2_EP1_SET_TUNER_PARAMETERS;
-
-	if (cinergyt2_alloc_stream_urbs (cinergyt2) < 0) {
-		dprintk(1, "unable to allocate stream urbs\n");
-		kfree(cinergyt2);
-		return -ENOMEM;
-	}
-
-	err =3D dvb_register_adapter(&cinergyt2->adapter, DRIVER_NAME,
-				   THIS_MODULE, &cinergyt2->udev->dev,
-				   adapter_nr);
-	if (err < 0) {
-		kfree(cinergyt2);
-		return err;
-	}
-
-	cinergyt2->demux.priv =3D cinergyt2;
-	cinergyt2->demux.filternum =3D 256;
-	cinergyt2->demux.feednum =3D 256;
-	cinergyt2->demux.start_feed =3D cinergyt2_start_feed;
-	cinergyt2->demux.stop_feed =3D cinergyt2_stop_feed;
-	cinergyt2->demux.dmx.capabilities =3D DMX_TS_FILTERING |
-					    DMX_SECTION_FILTERING |
-					    DMX_MEMORY_BASED_FILTERING;
-
-	if ((err =3D dvb_dmx_init(&cinergyt2->demux)) < 0) {
-		dprintk(1, "dvb_dmx_init() failed (err =3D %d)\n", err);
-		goto bailout;
-	}
-
-	cinergyt2->dmxdev.filternum =3D cinergyt2->demux.filternum;
-	cinergyt2->dmxdev.demux =3D &cinergyt2->demux.dmx;
-	cinergyt2->dmxdev.capabilities =3D 0;
-
-	if ((err =3D dvb_dmxdev_init(&cinergyt2->dmxdev, &cinergyt2->adapter)) =
< 0) {
-		dprintk(1, "dvb_dmxdev_init() failed (err =3D %d)\n", err);
-		goto bailout;
-	}
-
-	if (dvb_net_init(&cinergyt2->adapter, &cinergyt2->dvbnet, &cinergyt2->d=
emux.dmx))
-		dprintk(1, "dvb_net_init() failed!\n");
-
-	dvb_register_device(&cinergyt2->adapter, &cinergyt2->fedev,
-			    &cinergyt2_fe_template, cinergyt2,
-			    DVB_DEVICE_FRONTEND);
-
-	err =3D cinergyt2_register_rc(cinergyt2);
-	if (err)
-		goto bailout;
-
-	return 0;
-
-bailout:
-	dvb_net_release(&cinergyt2->dvbnet);
-	dvb_dmxdev_release(&cinergyt2->dmxdev);
-	dvb_dmx_release(&cinergyt2->demux);
-	dvb_unregister_adapter(&cinergyt2->adapter);
-	cinergyt2_free_stream_urbs(cinergyt2);
-	kfree(cinergyt2);
-	return -ENOMEM;
-}
-
-static void cinergyt2_disconnect (struct usb_interface *intf)
-{
-	struct cinergyt2 *cinergyt2 =3D usb_get_intfdata (intf);
-
-	cinergyt2_unregister_rc(cinergyt2);
-	cancel_rearming_delayed_work(&cinergyt2->query_work);
-	wake_up_interruptible(&cinergyt2->poll_wq);
-
-	cinergyt2->demux.dmx.close(&cinergyt2->demux.dmx);
-	cinergyt2->disconnect_pending =3D 1;
-
-	if (!atomic_read(&cinergyt2->inuse))
-		cinergyt2_unregister(cinergyt2);
-}
-
-static int cinergyt2_suspend (struct usb_interface *intf, pm_message_t s=
tate)
-{
-	struct cinergyt2 *cinergyt2 =3D usb_get_intfdata (intf);
-
-	if (cinergyt2->disconnect_pending)
-		return -EAGAIN;
-	if (mutex_lock_interruptible(&cinergyt2->wq_sem))
-		return -ERESTARTSYS;
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
-	if (state <=3D 0) {
-		mutex_unlock(&cinergyt2->wq_sem);
-		return 0;
-	}
-#endif
-	cinergyt2_suspend_rc(cinergyt2);
-	cancel_rearming_delayed_work(&cinergyt2->query_work);
-
-	mutex_lock(&cinergyt2->sem);
-	if (cinergyt2->streaming)
-		cinergyt2_stop_stream_xfer(cinergyt2);
-	cinergyt2_sleep(cinergyt2, 1);
-	mutex_unlock(&cinergyt2->sem);
-
-	mutex_unlock(&cinergyt2->wq_sem);
-
-	return 0;
-}
-
-static int cinergyt2_resume (struct usb_interface *intf)
-{
-	struct cinergyt2 *cinergyt2 =3D usb_get_intfdata (intf);
-	struct dvbt_set_parameters_msg *param =3D &cinergyt2->param;
-	int err =3D -EAGAIN;
-
-	if (cinergyt2->disconnect_pending)
-		goto out;
-	err =3D mutex_lock_interruptible(&cinergyt2->wq_sem);
-	if (err)
-		goto out;
-
-	err =3D mutex_lock_interruptible(&cinergyt2->sem);
-	if (err)
-		goto out_unlock1;
-
-	if (!cinergyt2->sleeping) {
-		cinergyt2_sleep(cinergyt2, 0);
-		cinergyt2_command(cinergyt2, (char *) param, sizeof(*param), NULL, 0);
-		if (cinergyt2->streaming)
-			cinergyt2_start_stream_xfer(cinergyt2);
-		schedule_delayed_work(&cinergyt2->query_work, HZ/2);
-	}
-
-	cinergyt2_resume_rc(cinergyt2);
-
-	mutex_unlock(&cinergyt2->sem);
-out_unlock1:
-	mutex_unlock(&cinergyt2->wq_sem);
-out:
-	return err;
-}
-
-static const struct usb_device_id cinergyt2_table [] __devinitdata =3D {
-	{ USB_DEVICE(0x0ccd, 0x0038) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(usb, cinergyt2_table);
-
-static struct usb_driver cinergyt2_driver =3D {
-#if LINUX_VERSION_CODE <=3D  KERNEL_VERSION(2,6,15)
-	.owner	=3D THIS_MODULE,
-#endif
-	.name	=3D "cinergyT2",
-	.probe	=3D cinergyt2_probe,
-	.disconnect	=3D cinergyt2_disconnect,
-	.suspend	=3D cinergyt2_suspend,
-	.resume		=3D cinergyt2_resume,
-	.id_table	=3D cinergyt2_table
-};
-
-static int __init cinergyt2_init (void)
-{
-	int err;
-
-	if ((err =3D usb_register(&cinergyt2_driver)) < 0)
-		dprintk(1, "usb_register() failed! (err %i)\n", err);
-
-	return err;
-}
-
-static void __exit cinergyt2_exit (void)
-{
-	usb_deregister(&cinergyt2_driver);
-}
-
-module_init (cinergyt2_init);
-module_exit (cinergyt2_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Holger Waechtler, Daniel Mack");
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/Kconfig
--- a/linux/drivers/media/dvb/dvb-usb/Kconfig	Tue May 06 11:09:01 2008 -0=
300
+++ b/linux/drivers/media/dvb/dvb-usb/Kconfig	Mon May 12 21:42:16 2008 +0=
300
@@ -241,3 +241,11 @@ config DVB_USB_AF9005_REMOTE
 	  Say Y here to support the default remote control decoding for the
 	  Afatech AF9005 based receiver.
=20
+config 	DVB_USB_CINERGY_T2
+	tristate "Terratec CinergyT2/qanu USB 2.0 DVB-T receiver"
+	depends on DVB_USB
+	help
+	  Support for "TerraTec CinergyT2" USB2.0 Highspeed DVB Receivers
+
+	  Say Y if you own such a device and want to use it.
+
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/Makefile
--- a/linux/drivers/media/dvb/dvb-usb/Makefile	Tue May 06 11:09:01 2008 -=
0300
+++ b/linux/drivers/media/dvb/dvb-usb/Makefile	Mon May 12 21:42:16 2008 +=
0300
@@ -61,6 +61,10 @@ dvb-usb-af9005-remote-objs =3D af9005-remo
 dvb-usb-af9005-remote-objs =3D af9005-remote.o
 obj-$(CONFIG_DVB_USB_AF9005_REMOTE) +=3D dvb-usb-af9005-remote.o
=20
+dvb-usb-cinergyT2-objs =3D cinergyT2-core.o cinergyT2-fe.o
+obj-$(CONFIG_DVB_USB_CINERGY_T2) +=3D dvb-usb-cinergyT2.o
+
+
 EXTRA_CFLAGS +=3D -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/fron=
tends/
 # due to tuner-xc3028
 EXTRA_CFLAGS +=3D -Idrivers/media/common/tuners
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c	Mon May 12 21:42:1=
6 2008 +0300
@@ -0,0 +1,230 @@
+/*
+ * TerraTec Cinergy T2/qanu USB2 DVB-T adapter.
+ *
+ * Copyright (C) 2007 Tomi Orava (tomimo@ncircle.nullnet.fi)
+ *
+ * Based on the dvb-usb-framework code and the
+ * original Terratec Cinergy T2 driver by:
+ *
+ * Copyright (C) 2004 Daniel Mack <daniel@qanu.de> and
+ *		    Holger Waechtler <holger@qanu.de>
+ *
+ *  Protocol Spec published on http://qanu.de/specs/terratec_cinergyT2.p=
df
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include "cinergyT2.h"
+
+
+/* debug */
+int dvb_usb_cinergyt2_debug;
+int disable_remote;
+
+module_param_named(debug, dvb_usb_cinergyt2_debug, int, 0644);
+MODULE_PARM_DESC(debug, "set debugging level (1=3Dinfo, xfer=3D2, rc=3D4=
 "
+		"(or-able)).");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+
+/* We are missing a release hook with usb_device data */
+struct dvb_usb_device *cinergyt2_usb_device;
+
+static struct dvb_usb_device_properties cinergyt2_properties;
+
+static int cinergyt2_streaming_ctrl(struct dvb_usb_adapter *adap, int en=
able)
+{
+	char buf [] =3D { CINERGYT2_EP1_CONTROL_STREAM_TRANSFER, enable ? 1 : 0=
 };
+	char result[64];
+	return dvb_usb_generic_rw(adap->dev, buf, sizeof(buf), result,
+				sizeof(result), 0);
+}
+
+static int cinergyt2_power_ctrl(struct dvb_usb_device *d, int enable)
+{
+	char buf[] =3D { CINERGYT2_EP1_SLEEP_MODE, enable ? 0 : 1 };
+	char state[3];
+	return dvb_usb_generic_rw(d, buf, sizeof(buf), state, sizeof(state), 0)=
;
+}
+
+static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	char query[] =3D { CINERGYT2_EP1_GET_FIRMWARE_VERSION };
+	char state[3];
+	int ret;
+
+	adap->fe =3D cinergyt2_fe_attach(adap->dev);
+
+	ret =3D dvb_usb_generic_rw(adap->dev, query, sizeof(query), state,
+				sizeof(state), 0);
+	if (ret < 0) {
+		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
+			"state info\n");
+	}
+
+	/* Copy this pointer as we are gonna need it in the release phase */
+	cinergyt2_usb_device =3D adap->dev;
+
+	return 0;
+}
+
+static struct dvb_usb_rc_key cinergyt2_rc_keys [] =3D {
+	{ 0x04,	0x01,	KEY_POWER },
+	{ 0x04,	0x02,	KEY_1 },
+	{ 0x04,	0x03,	KEY_2 },
+	{ 0x04,	0x04,	KEY_3 },
+	{ 0x04,	0x05,	KEY_4 },
+	{ 0x04,	0x06,	KEY_5 },
+	{ 0x04,	0x07,	KEY_6 },
+	{ 0x04,	0x08,	KEY_7 },
+	{ 0x04,	0x09,	KEY_8 },
+	{ 0x04,	0x0a,	KEY_9 },
+	{ 0x04,	0x0c,	KEY_0 },
+	{ 0x04,	0x0b,	KEY_VIDEO },
+	{ 0x04,	0x0d,	KEY_REFRESH },
+	{ 0x04,	0x0e,	KEY_SELECT },
+	{ 0x04,	0x0f,	KEY_EPG },
+	{ 0x04,	0x10,	KEY_UP },
+	{ 0x04,	0x14,	KEY_DOWN },
+	{ 0x04,	0x11,	KEY_LEFT },
+	{ 0x04,	0x13,	KEY_RIGHT },
+	{ 0x04,	0x12,	KEY_OK },
+	{ 0x04,	0x15,	KEY_TEXT },
+	{ 0x04,	0x16,	KEY_INFO },
+	{ 0x04,	0x17,	KEY_RED },
+	{ 0x04,	0x18,	KEY_GREEN },
+	{ 0x04,	0x19,	KEY_YELLOW },
+	{ 0x04,	0x1a,	KEY_BLUE },
+	{ 0x04,	0x1c,	KEY_VOLUMEUP },
+	{ 0x04,	0x1e,	KEY_VOLUMEDOWN },
+	{ 0x04,	0x1d,	KEY_MUTE },
+	{ 0x04,	0x1b,	KEY_CHANNELUP },
+	{ 0x04,	0x1f,	KEY_CHANNELDOWN },
+	{ 0x04,	0x40,	KEY_PAUSE },
+	{ 0x04,	0x4c,	KEY_PLAY },
+	{ 0x04,	0x58,	KEY_RECORD },
+	{ 0x04,	0x54,	KEY_PREVIOUS },
+	{ 0x04,	0x48,	KEY_STOP },
+	{ 0x04,	0x5c,	KEY_NEXT }
+};
+
+static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int =
*state)
+{
+	u8 key[5] =3D {0, 0, 0, 0, 0}, cmd =3D CINERGYT2_EP1_GET_RC_EVENTS;
+	*state =3D REMOTE_NO_KEY_PRESSED;
+
+	dvb_usb_generic_rw(d, &cmd, 1, key, sizeof(key), 0);
+	if (key[4] =3D=3D 0xff)
+		return 0;
+
+	/* hack to pass checksum on the custom field (is set to 0xeb) */
+	key[2] =3D ~0x04;
+	dvb_usb_nec_rc_key_to_event(d, key, event, state);
+	if (key[0] !=3D 0)
+		deb_info("key: %x %x %x %x %x\n",
+			 key[0], key[1], key[2], key[3], key[4]);
+
+	return 0;
+}
+
+static int cinergyt2_usb_probe(struct usb_interface *intf,
+				const struct usb_device_id *id)
+{
+	return dvb_usb_device_init(intf, &cinergyt2_properties,
+					THIS_MODULE, NULL, adapter_nr);
+}
+
+
+static struct usb_device_id cinergyt2_usb_table [] =3D {
+	{ USB_DEVICE(USB_VID_TERRATEC, 0x0038) },
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(usb, cinergyt2_usb_table);
+
+static struct dvb_usb_device_properties cinergyt2_properties =3D {
+
+	.num_adapters =3D 1,
+	.adapter =3D {
+		{
+			.streaming_ctrl   =3D cinergyt2_streaming_ctrl,
+			.frontend_attach  =3D cinergyt2_frontend_attach,
+
+			/* parameter for the MPEG2-data transfer */
+			.stream =3D {
+				.type =3D USB_BULK,
+				.count =3D 5,
+				.endpoint =3D 0x02,
+				.u =3D {
+					.bulk =3D {
+						.buffersize =3D 512,
+					}
+				}
+			},
+		}
+	},
+
+	.power_ctrl       =3D cinergyt2_power_ctrl,
+
+	.rc_interval      =3D 50,
+	.rc_key_map       =3D cinergyt2_rc_keys,
+	.rc_key_map_size  =3D ARRAY_SIZE(cinergyt2_rc_keys),
+	.rc_query         =3D cinergyt2_rc_query,
+
+	.generic_bulk_ctrl_endpoint =3D 1,
+
+	.num_device_descs =3D 1,
+	.devices =3D {
+		{ .name =3D "TerraTec/qanu USB2.0 Highspeed DVB-T Receiver",
+		  .cold_ids =3D {NULL},
+		  .warm_ids =3D { &cinergyt2_usb_table[0], NULL },
+		},
+		{ NULL },
+	}
+};
+
+
+static struct usb_driver cinergyt2_driver =3D {
+	.name		=3D "cinergyT2",
+	.probe		=3D cinergyt2_usb_probe,
+	.disconnect	=3D dvb_usb_device_exit,
+	.id_table	=3D cinergyt2_usb_table
+};
+
+static int __init cinergyt2_usb_init(void)
+{
+	int err;
+
+	err =3D usb_register(&cinergyt2_driver);
+	if (err) {
+		err("usb_register() failed! (err %i)\n", err);
+		return err;
+	}
+	return 0;
+}
+
+static void __exit cinergyt2_usb_exit(void)
+{
+	usb_deregister(&cinergyt2_driver);
+}
+
+module_init(cinergyt2_usb_init);
+module_exit(cinergyt2_usb_exit);
+
+MODULE_DESCRIPTION("Terratec Cinergy T2 DVB-T driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tomi Orava");
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/cinergyT2-fe.c	Mon May 12 21:42:16 =
2008 +0300
@@ -0,0 +1,351 @@
+/*
+ * TerraTec Cinergy T2/qanu USB2 DVB-T adapter.
+ *
+ * Copyright (C) 2007 Tomi Orava (tomimo@ncircle.nullnet.fi)
+ *
+ * Based on the dvb-usb-framework code and the
+ * original Terratec Cinergy T2 driver by:
+ *
+ * Copyright (C) 2004 Daniel Mack <daniel@qanu.de> and
+ *                  Holger Waechtler <holger@qanu.de>
+ *
+ *  Protocol Spec published on http://qanu.de/specs/terratec_cinergyT2.p=
df
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include "cinergyT2.h"
+
+
+/**
+ *  convert linux-dvb frontend parameter set into TPS.
+ *  See ETSI ETS-300744, section 4.6.2, table 9 for details.
+ *
+ *  This function is probably reusable and may better get placed in a su=
pport
+ *  library.
+ *
+ *  We replace errornous fields by default TPS fields (the ones with val=
ue 0).
+ */
+
+static uint16_t compute_tps(struct dvb_frontend_parameters *p)
+{
+	struct dvb_ofdm_parameters *op =3D &p->u.ofdm;
+	uint16_t tps =3D 0;
+
+	switch (op->code_rate_HP) {
+	case FEC_2_3:
+		tps |=3D (1 << 7);
+		break;
+	case FEC_3_4:
+		tps |=3D (2 << 7);
+		break;
+	case FEC_5_6:
+		tps |=3D (3 << 7);
+		break;
+	case FEC_7_8:
+		tps |=3D (4 << 7);
+		break;
+	case FEC_1_2:
+	case FEC_AUTO:
+	default:
+		/* tps |=3D (0 << 7) */;
+	}
+
+	switch (op->code_rate_LP) {
+	case FEC_2_3:
+		tps |=3D (1 << 4);
+		break;
+	case FEC_3_4:
+		tps |=3D (2 << 4);
+		break;
+	case FEC_5_6:
+		tps |=3D (3 << 4);
+		break;
+	case FEC_7_8:
+		tps |=3D (4 << 4);
+		break;
+	case FEC_1_2:
+	case FEC_AUTO:
+	default:
+		/* tps |=3D (0 << 4) */;
+	}
+
+	switch (op->constellation) {
+	case QAM_16:
+		tps |=3D (1 << 13);
+		break;
+	case QAM_64:
+		tps |=3D (2 << 13);
+		break;
+	case QPSK:
+	default:
+		/* tps |=3D (0 << 13) */;
+	}
+
+	switch (op->transmission_mode) {
+	case TRANSMISSION_MODE_8K:
+		tps |=3D (1 << 0);
+		break;
+	case TRANSMISSION_MODE_2K:
+	default:
+		/* tps |=3D (0 << 0) */;
+	}
+
+	switch (op->guard_interval) {
+	case GUARD_INTERVAL_1_16:
+		tps |=3D (1 << 2);
+		break;
+	case GUARD_INTERVAL_1_8:
+		tps |=3D (2 << 2);
+		break;
+	case GUARD_INTERVAL_1_4:
+		tps |=3D (3 << 2);
+		break;
+	case GUARD_INTERVAL_1_32:
+	default:
+		/* tps |=3D (0 << 2) */;
+	}
+
+	switch (op->hierarchy_information) {
+	case HIERARCHY_1:
+		tps |=3D (1 << 10);
+		break;
+	case HIERARCHY_2:
+		tps |=3D (2 << 10);
+		break;
+	case HIERARCHY_4:
+		tps |=3D (3 << 10);
+		break;
+	case HIERARCHY_NONE:
+	default:
+		/* tps |=3D (0 << 10) */;
+	}
+
+	return tps;
+}
+
+struct cinergyt2_fe_state {
+	struct dvb_frontend fe;
+	struct dvb_usb_device *d;
+};
+
+static int cinergyt2_fe_read_status(struct dvb_frontend *fe,
+					fe_status_t *status)
+{
+	struct cinergyt2_fe_state *state =3D fe->demodulator_priv;
+	struct dvbt_get_status_msg result;
+	u8 cmd [] =3D { CINERGYT2_EP1_GET_TUNER_STATUS };
+	int ret;
+
+	ret =3D dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (u8 *)&result,
+			sizeof(result), 0);
+	if (ret < 0)
+		return ret;
+
+	*status =3D 0;
+
+	if (0xffff - le16_to_cpu(result.gain) > 30)
+		*status |=3D FE_HAS_SIGNAL;
+	if (result.lock_bits & (1 << 6))
+		*status |=3D FE_HAS_LOCK;
+	if (result.lock_bits & (1 << 5))
+		*status |=3D FE_HAS_SYNC;
+	if (result.lock_bits & (1 << 4))
+		*status |=3D FE_HAS_CARRIER;
+	if (result.lock_bits & (1 << 1))
+		*status |=3D FE_HAS_VITERBI;
+
+	if ((*status & (FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC)) !=3D
+			(FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC))
+		*status &=3D ~FE_HAS_LOCK;
+
+	return 0;
+}
+
+static int cinergyt2_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct cinergyt2_fe_state *state =3D fe->demodulator_priv;
+	struct dvbt_get_status_msg status;
+	char cmd [] =3D { CINERGYT2_EP1_GET_TUNER_STATUS };
+	int ret;
+
+	ret =3D dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (char *)&status,
+				sizeof(status), 0);
+	if (ret < 0)
+		return ret;
+
+	*ber =3D le32_to_cpu(status.viterbi_error_rate);
+	return 0;
+}
+
+static int cinergyt2_fe_read_unc_blocks(struct dvb_frontend *fe, u32 *un=
c)
+{
+	struct cinergyt2_fe_state *state =3D fe->demodulator_priv;
+	struct dvbt_get_status_msg status;
+	u8 cmd [] =3D { CINERGYT2_EP1_GET_TUNER_STATUS };
+	int ret;
+
+	ret =3D dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (u8 *)&status,
+				sizeof(status), 0);
+	if (ret < 0) {
+		err("cinergyt2_fe_read_unc_blocks() Failed! (Error=3D%d)\n",
+			ret);
+		return ret;
+	}
+	*unc =3D le32_to_cpu(status.uncorrected_block_count);
+	return 0;
+}
+
+static int cinergyt2_fe_read_signal_strength(struct dvb_frontend *fe,
+						u16 *strength)
+{
+	struct cinergyt2_fe_state *state =3D fe->demodulator_priv;
+	struct dvbt_get_status_msg status;
+	char cmd [] =3D { CINERGYT2_EP1_GET_TUNER_STATUS };
+	int ret;
+
+	ret =3D dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (char *)&status,
+				sizeof(status), 0);
+	if (ret < 0) {
+		err("cinergyt2_fe_read_signal_strength() Failed!"
+			" (Error=3D%d)\n", ret);
+		return ret;
+	}
+	*strength =3D (0xffff - le16_to_cpu(status.gain));
+	return 0;
+}
+
+static int cinergyt2_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct cinergyt2_fe_state *state =3D fe->demodulator_priv;
+	struct dvbt_get_status_msg status;
+	char cmd [] =3D { CINERGYT2_EP1_GET_TUNER_STATUS };
+	int ret;
+
+	ret =3D dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (char *)&status,
+				sizeof(status), 0);
+	if (ret < 0) {
+		err("cinergyt2_fe_read_snr() Failed! (Error=3D%d)\n", ret);
+		return ret;
+	}
+	*snr =3D (status.snr << 8) | status.snr;
+	return 0;
+}
+
+static int cinergyt2_fe_init(struct dvb_frontend *fe)
+{
+	return 0;
+}
+
+static int cinergyt2_fe_sleep(struct dvb_frontend *fe)
+{
+	deb_info("cinergyt2_fe_sleep() Called\n");
+	return 0;
+}
+
+static int cinergyt2_fe_get_tune_settings(struct dvb_frontend *fe,
+				struct dvb_frontend_tune_settings *tune)
+{
+	tune->min_delay_ms =3D 800;
+	return 0;
+}
+
+static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe,
+				  struct dvb_frontend_parameters *fep)
+{
+	struct cinergyt2_fe_state *state =3D fe->demodulator_priv;
+	struct dvbt_set_parameters_msg param;
+	char result[2];
+	int err;
+
+	param.cmd =3D CINERGYT2_EP1_SET_TUNER_PARAMETERS;
+	param.tps =3D cpu_to_le16(compute_tps(fep));
+	param.freq =3D cpu_to_le32(fep->frequency / 1000);
+	param.bandwidth =3D 8 - fep->u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
+
+	err =3D dvb_usb_generic_rw(state->d,
+			(char *)&param, sizeof(param),
+			result, sizeof(result), 0);
+	if (err < 0)
+		err("cinergyt2_fe_set_frontend() Failed! err=3D%d\n", err);
+
+	return (err < 0) ? err : 0;
+}
+
+static int cinergyt2_fe_get_frontend(struct dvb_frontend *fe,
+				  struct dvb_frontend_parameters *fep)
+{
+	return 0;
+}
+
+static void cinergyt2_fe_release(struct dvb_frontend *fe)
+{
+	struct cinergyt2_fe_state *state =3D fe->demodulator_priv;
+	if (state !=3D NULL)
+		kfree(state);
+}
+
+static struct dvb_frontend_ops cinergyt2_fe_ops;
+
+struct dvb_frontend *cinergyt2_fe_attach(struct dvb_usb_device *d)
+{
+	struct cinergyt2_fe_state *s =3D kzalloc(sizeof(
+					struct cinergyt2_fe_state), GFP_KERNEL);
+	if (s =3D=3D NULL)
+		return NULL;
+
+	s->d =3D d;
+	memcpy(&s->fe.ops, &cinergyt2_fe_ops, sizeof(struct dvb_frontend_ops));
+	s->fe.demodulator_priv =3D s;
+	return &s->fe;
+}
+
+
+static struct dvb_frontend_ops cinergyt2_fe_ops =3D {
+	.info =3D {
+		.name			=3D DRIVER_NAME,
+		.type			=3D FE_OFDM,
+		.frequency_min		=3D 174000000,
+		.frequency_max		=3D 862000000,
+		.frequency_stepsize	=3D 166667,
+		.caps =3D FE_CAN_INVERSION_AUTO | FE_CAN_FEC_1_2
+			| FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
+			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8
+			| FE_CAN_FEC_AUTO | FE_CAN_QPSK
+			| FE_CAN_QAM_16 | FE_CAN_QAM_64
+			| FE_CAN_QAM_AUTO
+			| FE_CAN_TRANSMISSION_MODE_AUTO
+			| FE_CAN_GUARD_INTERVAL_AUTO
+			| FE_CAN_HIERARCHY_AUTO
+			| FE_CAN_RECOVER
+			| FE_CAN_MUTE_TS
+	},
+
+	.release		=3D cinergyt2_fe_release,
+
+	.init			=3D cinergyt2_fe_init,
+	.sleep			=3D cinergyt2_fe_sleep,
+
+	.set_frontend		=3D cinergyt2_fe_set_frontend,
+	.get_frontend		=3D cinergyt2_fe_get_frontend,
+	.get_tune_settings	=3D cinergyt2_fe_get_tune_settings,
+
+	.read_status		=3D cinergyt2_fe_read_status,
+	.read_ber		=3D cinergyt2_fe_read_ber,
+	.read_signal_strength	=3D cinergyt2_fe_read_signal_strength,
+	.read_snr		=3D cinergyt2_fe_read_snr,
+	.read_ucblocks		=3D cinergyt2_fe_read_unc_blocks,
+};
diff -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/cinergyT2.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/cinergyT2.h	Mon May 12 21:42:16 200=
8 +0300
@@ -0,0 +1,95 @@
+/*
+ * TerraTec Cinergy T2/qanu USB2 DVB-T adapter.
+ *
+ * Copyright (C) 2007 Tomi Orava (tomimo@ncircle.nullnet.fi)
+ *
+ * Based on the dvb-usb-framework code and the
+ * original Terratec Cinergy T2 driver by:
+ *
+ * Copyright (C) 2004 Daniel Mack <daniel@qanu.de> and
+ *                  Holger Waechtler <holger@qanu.de>
+ *
+ *  Protocol Spec published on http://qanu.de/specs/terratec_cinergyT2.p=
df
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License,  or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not,  write to the Free Software
+ * Foundation,  Inc.,  675 Mass Ave,  Cambridge,  MA 02139,  USA.
+ *
+ */
+
+#ifndef _DVB_USB_CINERGYT2_H_
+#define _DVB_USB_CINERGYT2_H_
+
+#include <linux/usb/input.h>
+
+#define DVB_USB_LOG_PREFIX "cinergyT2"
+#include "dvb-usb.h"
+
+#define DRIVER_NAME "TerraTec/qanu USB2.0 Highspeed DVB-T Receiver"
+
+extern int dvb_usb_cinergyt2_debug;
+
+#define deb_info(args...)  dprintk(dvb_usb_cinergyt2_debug,  0x001, args=
)
+#define deb_xfer(args...)  dprintk(dvb_usb_cinergyt2_debug,  0x002, args=
)
+#define deb_pll(args...)   dprintk(dvb_usb_cinergyt2_debug,  0x004, args=
)
+#define deb_ts(args...)    dprintk(dvb_usb_cinergyt2_debug,  0x008, args=
)
+#define deb_err(args...)   dprintk(dvb_usb_cinergyt2_debug,  0x010, args=
)
+#define deb_rc(args...)    dprintk(dvb_usb_cinergyt2_debug,  0x020, args=
)
+#define deb_fw(args...)    dprintk(dvb_usb_cinergyt2_debug,  0x040, args=
)
+#define deb_mem(args...)   dprintk(dvb_usb_cinergyt2_debug,  0x080, args=
)
+#define deb_uxfer(args...) dprintk(dvb_usb_cinergyt2_debug,  0x100, args=
)
+
+
+
+enum cinergyt2_ep1_cmd {
+	CINERGYT2_EP1_PID_TABLE_RESET		=3D 0x01,
+	CINERGYT2_EP1_PID_SETUP			=3D 0x02,
+	CINERGYT2_EP1_CONTROL_STREAM_TRANSFER	=3D 0x03,
+	CINERGYT2_EP1_SET_TUNER_PARAMETERS	=3D 0x04,
+	CINERGYT2_EP1_GET_TUNER_STATUS		=3D 0x05,
+	CINERGYT2_EP1_START_SCAN		=3D 0x06,
+	CINERGYT2_EP1_CONTINUE_SCAN		=3D 0x07,
+	CINERGYT2_EP1_GET_RC_EVENTS		=3D 0x08,
+	CINERGYT2_EP1_SLEEP_MODE		=3D 0x09,
+	CINERGYT2_EP1_GET_FIRMWARE_VERSION	=3D 0x0A
+};
+
+
+struct dvbt_get_status_msg {
+	uint32_t freq;
+	uint8_t bandwidth;
+	uint16_t tps;
+	uint8_t flags;
+	uint16_t gain;
+	uint8_t snr;
+	uint32_t viterbi_error_rate;
+	uint32_t rs_error_rate;
+	uint32_t uncorrected_block_count;
+	uint8_t lock_bits;
+	uint8_t prev_lock_bits;
+} __attribute__((packed));
+
+
+struct dvbt_set_parameters_msg {
+	uint8_t cmd;
+	uint32_t freq;
+	uint8_t bandwidth;
+	uint16_t tps;
+	uint8_t flags;
+} __attribute__((packed));
+
+
+extern struct dvb_frontend *cinergyt2_fe_attach(struct dvb_usb_device *d=
);
+
+#endif /* _DVB_USB_CINERGYT2_H_ */
+
------=_20080512214940_42853
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_20080512214940_42853--
