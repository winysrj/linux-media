Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33210 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1IWUsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 16:48:23 -0400
Received: by fxe4 with SMTP id 4so4192271fxe.19
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 13:48:21 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] Add support for PCTV452E.
Date: Fri, 23 Sep 2011 23:48:23 +0300
Cc: Oliver Freyermuth <o.freyermuth@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Doychin Dokov <root@net1.cc>,
	Steffen Barszus <steffenbpunkt@googlemail.com>,
	Dominik Kuhlen <dkuhlen@gmx.net>,
	Andre Weidemann <Andre.Weidemann@web.de>,
	"Michael H. Schimek" <mschimek@gmx.at>
References: <201105242151.22826.hselasky@c2i.net> <j43erv$8ft$1@dough.gmane.org> <4E7CE5F8.1050900@redhat.com>
In-Reply-To: <4E7CE5F8.1050900@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XCPfOapUNhZ8Mqv"
Message-Id: <201109232348.23088.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_XCPfOapUNhZ8Mqv
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Here is my version.
Made with git format-patch for branch staging/for_v3.2

--Boundary-00=_XCPfOapUNhZ8Mqv
Content-Type: text/x-patch;
  charset="us-ascii";
  name="0001-Add-support-for-pctv452e.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="0001-Add-support-for-pctv452e.patch"

=46rom cc44ac937f36ed51335eb11a7e28cf047a979a1c Mon Sep 17 00:00:00 2001
=46rom: Igor M. Liplianin <liplianin@me.by>
Date: Fri, 23 Sep 2011 23:31:25 +0300
Subject: [PATCH] Add support for pctv452e
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
=2D--
 drivers/media/dvb/dvb-usb/Kconfig       |   13 +
 drivers/media/dvb/dvb-usb/Makefile      |    4 +
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    3 +
 drivers/media/dvb/dvb-usb/pctv452e.c    | 1182 +++++++++++++++++++++++++++=
++++
 drivers/media/dvb/frontends/Kconfig     |   10 +
 drivers/media/dvb/frontends/Makefile    |    1 +
 drivers/media/dvb/frontends/lnbp22.c    |  148 ++++
 drivers/media/dvb/frontends/lnbp22.h    |   57 ++
 drivers/media/dvb/ttpci/ttpci-eeprom.c  |   29 +
 drivers/media/dvb/ttpci/ttpci-eeprom.h  |    1 +
 10 files changed, 1448 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/dvb-usb/pctv452e.c
 create mode 100644 drivers/media/dvb/frontends/lnbp22.c
 create mode 100644 drivers/media/dvb/frontends/lnbp22.h

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/=
Kconfig
index 2c773827..5825716 100644
=2D-- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -258,6 +258,19 @@ config DVB_USB_AF9005_REMOTE
 	  Say Y here to support the default remote control decoding for the
 	  Afatech AF9005 based receiver.
=20
+config DVB_USB_PCTV452E
+	tristate "Pinnacle PCTV HDTV Pro USB device/TT Connect S2-3600"
+	depends on DVB_USB
+	select TTPCI_EEPROM
+	select DVB_LNBP22 if !DVB_FE_CUSTOMISE
+	select DVB_STB0899 if !DVB_FE_CUSTOMISE
+	select DVB_STB6100 if !DVB_FE_CUSTOMISE
+	help
+	  Support for external USB adapter designed by Pinnacle,
+	  shipped under the brand name 'PCTV HDTV Pro USB'.
+	  Also supports TT Connect S2-3600/3650 cards.
+	  Say Y if you own such a device and want to use it.
+
 config DVB_USB_DW2102
 	tristate "DvbWorld & TeVii DVB-S/S2 USB2.0 support"
 	depends on DVB_USB
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb=
/Makefile
index 06f75f6..7d0710b 100644
=2D-- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -64,6 +64,9 @@ obj-$(CONFIG_DVB_USB_AF9005_REMOTE) +=3D dvb-usb-af9005-r=
emote.o
 dvb-usb-anysee-objs =3D anysee.o
 obj-$(CONFIG_DVB_USB_ANYSEE) +=3D dvb-usb-anysee.o
=20
+dvb-usb-pctv452e-objs =3D pctv452e.o
+obj-$(CONFIG_DVB_USB_PCTV452E) +=3D dvb-usb-pctv452e.o
+
 dvb-usb-dw2102-objs =3D dw2102.o
 obj-$(CONFIG_DVB_USB_DW2102) +=3D dvb-usb-dw2102.o
=20
@@ -104,4 +107,5 @@ obj-$(CONFIG_DVB_USB_MXL111SF) +=3D mxl111sf-tuner.o
 ccflags-y +=3D -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
 # due to tuner-xc3028
 ccflags-y +=3D -Idrivers/media/common/tuners
+EXTRA_CFLAGS +=3D -Idrivers/media/dvb/ttpci
=20
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dv=
b-usb/dvb-usb-ids.h
index 7433261..2ad33ba 100644
=2D-- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -241,6 +241,9 @@
 #define USB_PID_PCTV_200E				0x020e
 #define USB_PID_PCTV_400E				0x020f
 #define USB_PID_PCTV_450E				0x0222
+#define USB_PID_PCTV_452E				0x021f
+#define USB_PID_TECHNOTREND_CONNECT_S2_3600		0x3007
+#define USB_PID_TECHNOTREND_CONNECT_S2_3650_CI		0x300a
 #define USB_PID_NEBULA_DIGITV				0x0201
 #define USB_PID_DVICO_BLUEBIRD_LGDT			0xd820
 #define USB_PID_DVICO_BLUEBIRD_LG064F_COLD		0xd500
diff --git a/drivers/media/dvb/dvb-usb/pctv452e.c b/drivers/media/dvb/dvb-u=
sb/pctv452e.c
new file mode 100644
index 0000000..6151b3e
=2D-- /dev/null
+++ b/drivers/media/dvb/dvb-usb/pctv452e.c
@@ -0,0 +1,1182 @@
+/*
+ * PCTV 452e DVB driver
+ *
+ * Copyright (c) 2006-2008 Dominik Kuhlen <dkuhlen@gmx.net>
+ *
+ * TT connect S2-3650-CI Common Interface support, MAC readout
+ * Copyright (C) 2008 Michael H. Schimek <mschimek@gmx.at>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ */
+
+/* dvb usb framework */
+#define DVB_USB_LOG_PREFIX "pctv452e"
+#include "dvb-usb.h"
+
+/* Demodulator */
+#include "stb0899_drv.h"
+#include "stb0899_reg.h"
+#include "stb0899_cfg.h"
+/* Tuner */
+#include "stb6100.h"
+#include "stb6100_cfg.h"
+/* FE Power */
+#include "lnbp22.h"
+
+#include "dvb_ca_en50221.h"
+#include "ttpci-eeprom.h"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+#define ISO_BUF_COUNT      4
+#define FRAMES_PER_ISO_BUF 4
+#define ISO_FRAME_SIZE     940
+#define ISOC_INTERFACE_ALTERNATIVE 3
+
+#define SYNC_BYTE_OUT 0xaa
+#define SYNC_BYTE_IN  0x55
+
+/* guessed: (copied from ttusb-budget) */
+#define PCTV_CMD_RESET 0x15
+/* command to poll IR receiver */
+#define PCTV_CMD_IR    0x1b
+/* command to send I2C  */
+#define PCTV_CMD_I2C   0x31
+
+#define I2C_ADDR_STB0899 (0xd0 >> 1)
+#define I2C_ADDR_STB6100 (0xc0 >> 1)
+#define I2C_ADDR_LNBP22  (0x10 >> 1)
+#define I2C_ADDR_24C16   (0xa0 >> 1)
+#define I2C_ADDR_24C64   (0xa2 >> 1)
+
+
+/* pctv452e sends us this amount of data for each issued usb-command */
+#define PCTV_ANSWER_LEN 64
+/* Wait up to 1000ms for device  */
+#define PCTV_TIMEOUT 1000
+
+
+#define PCTV_LED_GPIO   STB0899_GPIO01
+#define PCTV_LED_GREEN  0x82
+#define PCTV_LED_ORANGE 0x02
+
+#define ci_dbg(format, arg...)				\
+do {							\
+	if (0)						\
+		printk(KERN_DEBUG DVB_USB_LOG_PREFIX	\
+			": " format "\n" , ## arg);	\
+} while (0)
+
+enum {
+	TT3650_CMD_CI_TEST =3D 0x40,
+	TT3650_CMD_CI_RD_CTRL,
+	TT3650_CMD_CI_WR_CTRL,
+	TT3650_CMD_CI_RD_ATTR,
+	TT3650_CMD_CI_WR_ATTR,
+	TT3650_CMD_CI_RESET,
+	TT3650_CMD_CI_SET_VIDEO_PORT
+};
+
+
+static struct stb0899_postproc pctv45e_postproc[] =3D {
+	{ PCTV_LED_GPIO, STB0899_GPIOPULLUP },
+	{ 0, 0 }
+};
+
+/*
+ * stores all private variables for communication with the PCTV452e DVB-S2
+ */
+struct pctv452e_state {
+	struct dvb_ca_en50221 ca;
+	struct mutex ca_mutex;
+
+	u8 c;	   /* transaction counter, wraps around...  */
+	u8 initialized; /* set to 1 if 0x15 has been sent */
+};
+
+static int tt3650_ci_msg(struct dvb_usb_device *d, u8 cmd, u8 *data,
+			 unsigned int write_len, unsigned int read_len)
+{
+	struct pctv452e_state *state =3D (struct pctv452e_state *)d->priv;
+	u8 buf[64];
+	u8 id;
+	unsigned int rlen;
+	int ret;
+
+	BUG_ON(NULL =3D=3D data && 0 !=3D (write_len | read_len));
+	BUG_ON(write_len > 64 - 4);
+	BUG_ON(read_len > 64 - 4);
+
+	id =3D state->c++;
+
+	buf[0] =3D SYNC_BYTE_OUT;
+	buf[1] =3D id;
+	buf[2] =3D cmd;
+	buf[3] =3D write_len;
+
+	memcpy(buf + 4, data, write_len);
+
+	rlen =3D (read_len > 0) ? 64 : 0;
+	ret =3D dvb_usb_generic_rw(d, buf, 4 + write_len,
+				  buf, rlen, /* delay_ms */ 0);
+	if (0 !=3D ret)
+		goto failed;
+
+	ret =3D -EIO;
+	if (SYNC_BYTE_IN !=3D buf[0] || id !=3D buf[1])
+		goto failed;
+
+	memcpy(data, buf + 4, read_len);
+
+	return 0;
+
+failed:
+	err("CI error %d; %02X %02X %02X -> %02X %02X %02X.",
+	     ret, SYNC_BYTE_OUT, id, cmd, buf[0], buf[1], buf[2]);
+
+	return ret;
+}
+
+static int tt3650_ci_msg_locked(struct dvb_ca_en50221 *ca,
+				u8 cmd, u8 *data, unsigned int write_len,
+				unsigned int read_len)
+{
+	struct dvb_usb_device *d =3D (struct dvb_usb_device *)ca->data;
+	struct pctv452e_state *state =3D (struct pctv452e_state *)d->priv;
+	int ret;
+
+	mutex_lock(&state->ca_mutex);
+	ret =3D tt3650_ci_msg(d, cmd, data, write_len, read_len);
+	mutex_unlock(&state->ca_mutex);
+
+	return ret;
+}
+
+static int tt3650_ci_read_attribute_mem(struct dvb_ca_en50221 *ca,
+				 int slot, int address)
+{
+	u8 buf[3];
+	int ret;
+
+	if (0 !=3D slot)
+		return -EINVAL;
+
+	buf[0] =3D (address >> 8) & 0x0F;
+	buf[1] =3D address;
+
+	ret =3D tt3650_ci_msg_locked(ca, TT3650_CMD_CI_RD_ATTR, buf, 2, 3);
+
+	ci_dbg("%s %04x -> %d 0x%02x",
+		__func__, address, ret, buf[2]);
+
+	if (ret < 0)
+		return ret;
+
+	return buf[2];
+}
+
+static int tt3650_ci_write_attribute_mem(struct dvb_ca_en50221 *ca,
+				 int slot, int address, u8 value)
+{
+	u8 buf[3];
+
+	ci_dbg("%s %d 0x%04x 0x%02x",
+		__func__, slot, address, value);
+
+	if (0 !=3D slot)
+		return -EINVAL;
+
+	buf[0] =3D (address >> 8) & 0x0F;
+	buf[1] =3D address;
+	buf[2] =3D value;
+
+	return tt3650_ci_msg_locked(ca, TT3650_CMD_CI_WR_ATTR, buf, 3, 3);
+}
+
+static int tt3650_ci_read_cam_control(struct dvb_ca_en50221 *ca,
+				 int			slot,
+				 u8			address)
+{
+	u8 buf[2];
+	int ret;
+
+	if (0 !=3D slot)
+		return -EINVAL;
+
+	buf[0] =3D address & 3;
+
+	ret =3D tt3650_ci_msg_locked(ca, TT3650_CMD_CI_RD_CTRL, buf, 1, 2);
+
+	ci_dbg("%s 0x%02x -> %d 0x%02x",
+		__func__, address, ret, buf[1]);
+
+	if (ret < 0)
+		return ret;
+
+	return buf[1];
+}
+
+static int tt3650_ci_write_cam_control(struct dvb_ca_en50221 *ca,
+				 int			slot,
+				 u8			address,
+				 u8			value)
+{
+	u8 buf[2];
+
+	ci_dbg("%s %d 0x%02x 0x%02x",
+		__func__, slot, address, value);
+
+	if (0 !=3D slot)
+		return -EINVAL;
+
+	buf[0] =3D address;
+	buf[1] =3D value;
+
+	return tt3650_ci_msg_locked(ca, TT3650_CMD_CI_WR_CTRL, buf, 2, 2);
+}
+
+static int tt3650_ci_set_video_port(struct dvb_ca_en50221 *ca,
+				 int			slot,
+				 int			enable)
+{
+	u8 buf[1];
+	int ret;
+
+	ci_dbg("%s %d %d", __func__, slot, enable);
+
+	if (0 !=3D slot)
+		return -EINVAL;
+
+	enable =3D !!enable;
+	buf[0] =3D enable;
+
+	ret =3D tt3650_ci_msg_locked(ca, TT3650_CMD_CI_SET_VIDEO_PORT, buf, 1, 1);
+	if (ret < 0)
+		return ret;
+
+	if (enable !=3D buf[0]) {
+		err("CI not %sabled.", enable ? "en" : "dis");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int tt3650_ci_slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
+{
+	return tt3650_ci_set_video_port(ca, slot, /* enable */ 0);
+}
+
+static int tt3650_ci_slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
+{
+	return tt3650_ci_set_video_port(ca, slot, /* enable */ 1);
+}
+
+static int tt3650_ci_slot_reset(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct dvb_usb_device *d =3D (struct dvb_usb_device *)ca->data;
+	struct pctv452e_state *state =3D (struct pctv452e_state *)d->priv;
+	u8 buf[1];
+	int ret;
+
+	ci_dbg("%s %d", __func__, slot);
+
+	if (0 !=3D slot)
+		return -EINVAL;
+
+	buf[0] =3D 0;
+
+	mutex_lock(&state->ca_mutex);
+
+	ret =3D tt3650_ci_msg(d, TT3650_CMD_CI_RESET, buf, 1, 1);
+	if (0 !=3D ret)
+		goto failed;
+
+	msleep(500);
+
+	buf[0] =3D 1;
+
+	ret =3D tt3650_ci_msg(d, TT3650_CMD_CI_RESET, buf, 1, 1);
+	if (0 !=3D ret)
+		goto failed;
+
+	msleep(500);
+
+	buf[0] =3D 0; /* FTA */
+
+	ret =3D tt3650_ci_msg(d, TT3650_CMD_CI_SET_VIDEO_PORT, buf, 1, 1);
+
+ failed:
+	mutex_unlock(&state->ca_mutex);
+
+	return ret;
+}
+
+static int tt3650_ci_poll_slot_status(struct dvb_ca_en50221 *ca,
+				 int			slot,
+				 int			open)
+{
+	u8 buf[1];
+	int ret;
+
+	if (0 !=3D slot)
+		return -EINVAL;
+
+	ret =3D tt3650_ci_msg_locked(ca, TT3650_CMD_CI_TEST, buf, 0, 1);
+	if (0 !=3D ret)
+		return ret;
+
+	if (1 =3D=3D buf[0])
+		return DVB_CA_EN50221_POLL_CAM_PRESENT |
+			DVB_CA_EN50221_POLL_CAM_READY;
+
+	return 0;
+
+}
+
+static void tt3650_ci_uninit(struct dvb_usb_device *d)
+{
+	struct pctv452e_state *state;
+
+	ci_dbg("%s", __func__);
+
+	if (NULL =3D=3D d)
+		return;
+
+	state =3D (struct pctv452e_state *)d->priv;
+	if (NULL =3D=3D state)
+		return;
+
+	if (NULL =3D=3D state->ca.data)
+		return;
+
+	/* Error ignored. */
+	tt3650_ci_set_video_port(&state->ca, /* slot */ 0, /* enable */ 0);
+
+	dvb_ca_en50221_release(&state->ca);
+
+	memset(&state->ca, 0, sizeof(state->ca));
+}
+
+static int tt3650_ci_init(struct dvb_usb_adapter *a)
+{
+	struct dvb_usb_device *d =3D a->dev;
+	struct pctv452e_state *state =3D (struct pctv452e_state *)d->priv;
+	int ret;
+
+	ci_dbg("%s", __func__);
+
+	mutex_init(&state->ca_mutex);
+
+	state->ca.owner =3D THIS_MODULE;
+	state->ca.read_attribute_mem =3D tt3650_ci_read_attribute_mem;
+	state->ca.write_attribute_mem =3D tt3650_ci_write_attribute_mem;
+	state->ca.read_cam_control =3D tt3650_ci_read_cam_control;
+	state->ca.write_cam_control =3D tt3650_ci_write_cam_control;
+	state->ca.slot_reset =3D tt3650_ci_slot_reset;
+	state->ca.slot_shutdown =3D tt3650_ci_slot_shutdown;
+	state->ca.slot_ts_enable =3D tt3650_ci_slot_ts_enable;
+	state->ca.poll_slot_status =3D tt3650_ci_poll_slot_status;
+	state->ca.data =3D d;
+
+	ret =3D dvb_ca_en50221_init(&a->dvb_adap,
+				   &state->ca,
+				   /* flags */ 0,
+				   /* n_slots */ 1);
+	if (0 !=3D ret) {
+		err("Cannot initialize CI: Error %d.", ret);
+		memset(&state->ca, 0, sizeof(state->ca));
+		return ret;
+	}
+
+	info("CI initialized.");
+
+	return 0;
+}
+
+#define CMD_BUFFER_SIZE 0x28
+static int pctv452e_i2c_msg(struct dvb_usb_device *d, u8 addr,
+				const u8 *snd_buf, u8 snd_len,
+				u8 *rcv_buf, u8 rcv_len)
+{
+	struct pctv452e_state *state =3D (struct pctv452e_state *)d->priv;
+	u8 buf[64];
+	u8 id;
+	int ret;
+
+	id =3D state->c++;
+
+	ret =3D -EINVAL;
+	if (snd_len > 64 - 7 || rcv_len > 64 - 7)
+		goto failed;
+
+	buf[0] =3D SYNC_BYTE_OUT;
+	buf[1] =3D id;
+	buf[2] =3D PCTV_CMD_I2C;
+	buf[3] =3D snd_len + 3;
+	buf[4] =3D addr << 1;
+	buf[5] =3D snd_len;
+	buf[6] =3D rcv_len;
+
+	memcpy(buf + 7, snd_buf, snd_len);
+
+	ret =3D dvb_usb_generic_rw(d, buf, 7 + snd_len,
+				  buf, /* rcv_len */ 64,
+				  /* delay_ms */ 0);
+	if (ret < 0)
+		goto failed;
+
+	/* TT USB protocol error. */
+	ret =3D -EIO;
+	if (SYNC_BYTE_IN !=3D buf[0] || id !=3D buf[1])
+		goto failed;
+
+	/* I2C device didn't respond as expected. */
+	ret =3D -EREMOTEIO;
+	if (buf[5] < snd_len || buf[6] < rcv_len)
+		goto failed;
+
+	memcpy(rcv_buf, buf + 7, rcv_len);
+
+	return rcv_len;
+
+failed:
+	err("I2C error %d; %02X %02X  %02X %02X %02X -> "
+	     "%02X %02X  %02X %02X %02X.",
+	     ret, SYNC_BYTE_OUT, id, addr << 1, snd_len, rcv_len,
+	     buf[0], buf[1], buf[4], buf[5], buf[6]);
+
+	return ret;
+}
+
+static int pctv452e_i2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *=
msg,
+				int num)
+{
+	struct dvb_usb_device *d =3D i2c_get_adapdata(adapter);
+	int i;
+
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
+	for (i =3D 0; i < num; i++) {
+		u8 addr, snd_len, rcv_len, *snd_buf, *rcv_buf;
+		int ret;
+
+		if (msg[i].flags & I2C_M_RD) {
+			addr =3D msg[i].addr;
+			snd_buf =3D NULL;
+			snd_len =3D 0;
+			rcv_buf =3D msg[i].buf;
+			rcv_len =3D msg[i].len;
+		} else {
+			addr =3D msg[i].addr;
+			snd_buf =3D msg[i].buf;
+			snd_len =3D msg[i].len;
+			rcv_buf =3D NULL;
+			rcv_len =3D 0;
+		}
+
+		ret =3D pctv452e_i2c_msg(d, addr, snd_buf, snd_len, rcv_buf,
+					rcv_len);
+		if (ret < rcv_len)
+			break;
+	}
+
+	mutex_unlock(&d->i2c_mutex);
+	return i;
+}
+
+static u32 pctv452e_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C;
+}
+
+static int pctv452e_power_ctrl(struct dvb_usb_device *d, int i)
+{
+	struct pctv452e_state *state =3D (struct pctv452e_state *)d->priv;
+	u8 b0[] =3D { 0xaa, 0, PCTV_CMD_RESET, 1, 0 };
+	u8 rx[PCTV_ANSWER_LEN];
+	int ret;
+
+	info("%s: %d\n", __func__, i);
+
+	if (!i)
+		return 0;
+
+	if (state->initialized)
+		return 0;
+
+	/* hmm where shoud this should go? */
+	ret =3D usb_set_interface(d->udev, 0, ISOC_INTERFACE_ALTERNATIVE);
+	if (ret !=3D 0)
+		info("%s: Warning set interface returned: %d\n",
+			__func__, ret);
+
+	/* this is a one-time initialization, dont know where to put */
+	b0[1] =3D state->c++;
+	/* reset board */
+	ret =3D dvb_usb_generic_rw(d, b0, sizeof(b0), rx, PCTV_ANSWER_LEN, 0);
+	if (ret)
+		return ret;
+
+	b0[1] =3D state->c++;
+	b0[4] =3D 1;
+	/* reset board (again?) */
+	ret =3D dvb_usb_generic_rw(d, b0, sizeof(b0), rx, PCTV_ANSWER_LEN, 0);
+	if (ret)
+		return ret;
+
+	state->initialized =3D 1;
+
+	return 0;
+}
+
+/* Remote control stuff */
+static struct rc_map_table rc_map_pctv452e_table[] =3D {
+	{0x0700, KEY_MUTE},
+	{0x0701, KEY_VENDOR},  /* pinnacle logo (top middle) */
+	{0x0739, KEY_POWER},
+	{0x0703, KEY_VOLUMEUP},
+	{0x0709, KEY_VOLUMEDOWN},
+	{0x0706, KEY_CHANNELUP},
+	{0x070c, KEY_CHANNELDOWN},
+	{0x070f, KEY_1},
+	{0x0715, KEY_2},
+	{0x0710, KEY_3},
+	{0x0718, KEY_4},
+	{0x071b, KEY_5},
+	{0x071e, KEY_6},
+	{0x0711, KEY_7},
+	{0x0721, KEY_8},
+	{0x0712, KEY_9},
+	{0x0727, KEY_0},
+	{0x0724, KEY_TV}, /* left of '0' */
+	{0x072a, KEY_T}, /* right of '0' */
+	{0x072d, KEY_REWIND},
+	{0x0733, KEY_FORWARD},
+	{0x0730, KEY_PLAY},
+	{0x0736, KEY_RECORD},
+	{0x073c, KEY_STOP},
+	{0x073f, KEY_HELP}
+};
+
+/* Remote Control Stuff fo S2-3600 (copied from TT-S1500): */
+static struct rc_map_table rc_map_s2_3600_table[] =3D {
+	{0x1501, KEY_POWER},
+	{0x1502, KEY_SHUFFLE}, /* ? double-arrow key */
+	{0x1503, KEY_1},
+	{0x1504, KEY_2},
+	{0x1505, KEY_3},
+	{0x1506, KEY_4},
+	{0x1507, KEY_5},
+	{0x1508, KEY_6},
+	{0x1509, KEY_7},
+	{0x150a, KEY_8},
+	{0x150b, KEY_9},
+	{0x150c, KEY_0},
+	{0x150d, KEY_UP},
+	{0x150e, KEY_LEFT},
+	{0x150f, KEY_OK},
+	{0x1510, KEY_RIGHT},
+	{0x1511, KEY_DOWN},
+	{0x1512, KEY_INFO},
+	{0x1513, KEY_EXIT},
+	{0x1514, KEY_RED},
+	{0x1515, KEY_GREEN},
+	{0x1516, KEY_YELLOW},
+	{0x1517, KEY_BLUE},
+	{0x1518, KEY_MUTE},
+	{0x1519, KEY_TEXT},
+	{0x151a, KEY_MODE},  /* ? TV/Radio */
+	{0x1521, KEY_OPTION},
+	{0x1522, KEY_EPG},
+	{0x1523, KEY_CHANNELUP},
+	{0x1524, KEY_CHANNELDOWN},
+	{0x1525, KEY_VOLUMEUP},
+	{0x1526, KEY_VOLUMEDOWN},
+	{0x1527, KEY_SETUP},
+	{0x153a, KEY_RECORD},/* these keys are only in the black remote */
+	{0x153b, KEY_PLAY},
+	{0x153c, KEY_STOP},
+	{0x153d, KEY_REWIND},
+	{0x153e, KEY_PAUSE},
+	{0x153f, KEY_FORWARD}
+};
+
+static int pctv452e_rc_query(struct dvb_usb_device *d, u32 *keyevent,
+				int *keystate)
+{
+	struct pctv452e_state *state =3D (struct pctv452e_state *)d->priv;
+	u8 b[CMD_BUFFER_SIZE];
+	u8 rx[PCTV_ANSWER_LEN];
+	u8 keybuf[5];
+	int ret, i;
+	u8 id =3D state->c++;
+
+	/* prepare command header  */
+	b[0] =3D SYNC_BYTE_OUT;
+	b[1] =3D id;
+	b[2] =3D PCTV_CMD_IR;
+	b[3] =3D 0;
+
+	*keystate =3D REMOTE_NO_KEY_PRESSED;
+
+	/* send ir request */
+	ret =3D dvb_usb_generic_rw(d, b, 4, rx, PCTV_ANSWER_LEN, 0);
+	if (ret !=3D 0)
+		return ret;
+
+	if (debug > 3) {
+		info("%s: read: %2d: %02x %02x %02x: ", __func__,
+				ret, rx[0], rx[1], rx[2]);
+		for (i =3D 0; (i < rx[3]) && ((i+3) < PCTV_ANSWER_LEN); i++)
+			info(" %02x", rx[i+3]);
+
+		info("\n");
+	}
+
+	if ((rx[3] =3D=3D 9) &&  (rx[12] & 0x01)) {
+		/* got a "press" event */
+		if (debug > 2)
+			info("%s: cmd=3D0x%02x sys=3D0x%02x\n",
+				__func__, rx[6], rx[7]);
+		/* DVB_USB_RC_NEC_KEY_PRESSED; why is this define'd privately?*/
+		keybuf[0] =3D 0x01;
+		keybuf[1] =3D rx[7];
+		keybuf[2] =3D ~keybuf[1]; /* fake checksum */
+		keybuf[3] =3D rx[6];
+		keybuf[4] =3D ~keybuf[3]; /* fake checksum */
+		dvb_usb_nec_rc_key_to_event(d, keybuf, keyevent, keystate);
+
+	}
+
+	return 0;
+}
+
+static int pctv452e_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
+{
+	const u8 mem_addr[] =3D { 0x1f, 0xcc };
+	u8 encoded_mac[20];
+	int ret;
+
+	ret =3D -EAGAIN;
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		goto failed;
+
+	ret =3D pctv452e_i2c_msg(d, I2C_ADDR_24C16,
+				mem_addr + 1, /* snd_len */ 1,
+				encoded_mac, /* rcv_len */ 20);
+	if (-EREMOTEIO =3D=3D ret)
+		/* Caution! A 24C16 interprets 0xA2 0x1F 0xCC as a
+		   byte write if /WC is low. */
+		ret =3D pctv452e_i2c_msg(d, I2C_ADDR_24C64,
+					mem_addr, 2,
+					encoded_mac, 20);
+
+	mutex_unlock(&d->i2c_mutex);
+
+	if (20 !=3D ret)
+		goto failed;
+
+	ret =3D ttpci_eeprom_decode_mac(mac, encoded_mac);
+	if (0 !=3D ret)
+		goto failed;
+
+	return 0;
+
+failed:
+	memset(mac, 0, 6);
+
+	return ret;
+}
+
+static const struct stb0899_s1_reg pctv452e_init_dev[] =3D {
+	{ STB0899_DISCNTRL1,	0x26 },
+	{ STB0899_DISCNTRL2,	0x80 },
+	{ STB0899_DISRX_ST0,	0x04 },
+	{ STB0899_DISRX_ST1,	0x20 },
+	{ STB0899_DISPARITY,	0x00 },
+	{ STB0899_DISFIFO,	0x00 },
+	{ STB0899_DISF22,	0x99 },
+	{ STB0899_DISF22RX,	0x85 }, /* 0xa8 */
+	{ STB0899_ACRPRESC,	0x11 },
+	{ STB0899_ACRDIV1,	0x0a },
+	{ STB0899_ACRDIV2,	0x05 },
+	{ STB0899_DACR1	,	0x00 },
+	{ STB0899_DACR2	,	0x00 },
+	{ STB0899_OUTCFG,	0x00 },
+	{ STB0899_MODECFG,	0x00 }, /* Inversion */
+	{ STB0899_IRQMSK_3,	0xf3 },
+	{ STB0899_IRQMSK_2,	0xfc },
+	{ STB0899_IRQMSK_1,	0xff },
+	{ STB0899_IRQMSK_0,	0xff },
+	{ STB0899_I2CCFG,	0x88 },
+	{ STB0899_I2CRPT,	0x58 },
+	{ STB0899_GPIO00CFG,	0x82 },
+	{ STB0899_GPIO01CFG,	0x82 }, /* LED: 0x02 green, 0x82 orange */
+	{ STB0899_GPIO02CFG,	0x82 },
+	{ STB0899_GPIO03CFG,	0x82 },
+	{ STB0899_GPIO04CFG,	0x82 },
+	{ STB0899_GPIO05CFG,	0x82 },
+	{ STB0899_GPIO06CFG,	0x82 },
+	{ STB0899_GPIO07CFG,	0x82 },
+	{ STB0899_GPIO08CFG,	0x82 },
+	{ STB0899_GPIO09CFG,	0x82 },
+	{ STB0899_GPIO10CFG,	0x82 },
+	{ STB0899_GPIO11CFG,	0x82 },
+	{ STB0899_GPIO12CFG,	0x82 },
+	{ STB0899_GPIO13CFG,	0x82 },
+	{ STB0899_GPIO14CFG,	0x82 },
+	{ STB0899_GPIO15CFG,	0x82 },
+	{ STB0899_GPIO16CFG,	0x82 },
+	{ STB0899_GPIO17CFG,	0x82 },
+	{ STB0899_GPIO18CFG,	0x82 },
+	{ STB0899_GPIO19CFG,	0x82 },
+	{ STB0899_GPIO20CFG,	0x82 },
+	{ STB0899_SDATCFG,	0xb8 },
+	{ STB0899_SCLTCFG,	0xba },
+	{ STB0899_AGCRFCFG,	0x1c }, /* 0x11 DVB-S; 0x1c DVB-S2 (1c, rjkm) */
+	{ STB0899_GPIO22,	0x82 },
+	{ STB0899_GPIO21,	0x91 },
+	{ STB0899_DIRCLKCFG,	0x82 },
+	{ STB0899_CLKOUT27CFG,	0x7e },
+	{ STB0899_STDBYCFG,	0x82 },
+	{ STB0899_CS0CFG,	0x82 },
+	{ STB0899_CS1CFG,	0x82 },
+	{ STB0899_DISEQCOCFG,	0x20 },
+	{ STB0899_NCOARSE,	0x15 }, /* 0x15 27Mhz, F/3 198MHz, F/6 108MHz */
+	{ STB0899_SYNTCTRL,	0x00 }, /* 0x00 CLKI, 0x02 XTALI */
+	{ STB0899_FILTCTRL,	0x00 },
+	{ STB0899_SYSCTRL,	0x00 },
+	{ STB0899_STOPCLK1,	0x20 }, /* orig: 0x00 budget-ci: 0x20 */
+	{ STB0899_STOPCLK2,	0x00 },
+	{ STB0899_INTBUFCTRL,	0x0a },
+	{ STB0899_AGC2I1,	0x00 },
+	{ STB0899_AGC2I2,	0x00 },
+	{ STB0899_AGCIQIN,	0x00 },
+	{ STB0899_TSTRES,	0x40 }, /* rjkm */
+	{ 0xffff,		0xff },
+};
+
+static const struct stb0899_s1_reg pctv452e_init_s1_demod[] =3D {
+	{ STB0899_DEMOD,	0x00 },
+	{ STB0899_RCOMPC,	0xc9 },
+	{ STB0899_AGC1CN,	0x01 },
+	{ STB0899_AGC1REF,	0x10 },
+	{ STB0899_RTC,		0x23 },
+	{ STB0899_TMGCFG,	0x4e },
+	{ STB0899_AGC2REF,	0x34 },
+	{ STB0899_TLSR,		0x84 },
+	{ STB0899_CFD,		0xf7 },
+	{ STB0899_ACLC,		0x87 },
+	{ STB0899_BCLC,		0x94 },
+	{ STB0899_EQON,		0x41 },
+	{ STB0899_LDT,		0xf1 },
+	{ STB0899_LDT2,		0xe3 },
+	{ STB0899_EQUALREF,	0xb4 },
+	{ STB0899_TMGRAMP,	0x10 },
+	{ STB0899_TMGTHD,	0x30 },
+	{ STB0899_IDCCOMP,	0xfd },
+	{ STB0899_QDCCOMP,	0xff },
+	{ STB0899_POWERI,	0x0c },
+	{ STB0899_POWERQ,	0x0f },
+	{ STB0899_RCOMP,	0x6c },
+	{ STB0899_AGCIQIN,	0x80 },
+	{ STB0899_AGC2I1,	0x06 },
+	{ STB0899_AGC2I2,	0x00 },
+	{ STB0899_TLIR,		0x30 },
+	{ STB0899_RTF,		0x7f },
+	{ STB0899_DSTATUS,	0x00 },
+	{ STB0899_LDI,		0xbc },
+	{ STB0899_CFRM,		0xea },
+	{ STB0899_CFRL,		0x31 },
+	{ STB0899_NIRM,		0x2b },
+	{ STB0899_NIRL,		0x80 },
+	{ STB0899_ISYMB,	0x1d },
+	{ STB0899_QSYMB,	0xa6 },
+	{ STB0899_SFRH,		0x2f },
+	{ STB0899_SFRM,		0x68 },
+	{ STB0899_SFRL,		0x40 },
+	{ STB0899_SFRUPH,	0x2f },
+	{ STB0899_SFRUPM,	0x68 },
+	{ STB0899_SFRUPL,	0x40 },
+	{ STB0899_EQUAI1,	0x02 },
+	{ STB0899_EQUAQ1,	0xff },
+	{ STB0899_EQUAI2,	0x04 },
+	{ STB0899_EQUAQ2,	0x05 },
+	{ STB0899_EQUAI3,	0x02 },
+	{ STB0899_EQUAQ3,	0xfd },
+	{ STB0899_EQUAI4,	0x03 },
+	{ STB0899_EQUAQ4,	0x07 },
+	{ STB0899_EQUAI5,	0x08 },
+	{ STB0899_EQUAQ5,	0xf5 },
+	{ STB0899_DSTATUS2,	0x00 },
+	{ STB0899_VSTATUS,	0x00 },
+	{ STB0899_VERROR,	0x86 },
+	{ STB0899_IQSWAP,	0x2a },
+	{ STB0899_ECNT1M,	0x00 },
+	{ STB0899_ECNT1L,	0x00 },
+	{ STB0899_ECNT2M,	0x00 },
+	{ STB0899_ECNT2L,	0x00 },
+	{ STB0899_ECNT3M,	0x0a },
+	{ STB0899_ECNT3L,	0xad },
+	{ STB0899_FECAUTO1,	0x06 },
+	{ STB0899_FECM,		0x01 },
+	{ STB0899_VTH12,	0xb0 },
+	{ STB0899_VTH23,	0x7a },
+	{ STB0899_VTH34,	0x58 },
+	{ STB0899_VTH56,	0x38 },
+	{ STB0899_VTH67,	0x34 },
+	{ STB0899_VTH78,	0x24 },
+	{ STB0899_PRVIT,	0xff },
+	{ STB0899_VITSYNC,	0x19 },
+	{ STB0899_RSULC,	0xb1 }, /* DVB =3D 0xb1, DSS =3D 0xa1 */
+	{ STB0899_TSULC,	0x42 },
+	{ STB0899_RSLLC,	0x41 },
+	{ STB0899_TSLPL,	0x12 },
+	{ STB0899_TSCFGH,	0x0c },
+	{ STB0899_TSCFGM,	0x00 },
+	{ STB0899_TSCFGL,	0x00 },
+	{ STB0899_TSOUT,	0x69 }, /* 0x0d for CAM */
+	{ STB0899_RSSYNCDEL,	0x00 },
+	{ STB0899_TSINHDELH,	0x02 },
+	{ STB0899_TSINHDELM,	0x00 },
+	{ STB0899_TSINHDELL,	0x00 },
+	{ STB0899_TSLLSTKM,	0x1b },
+	{ STB0899_TSLLSTKL,	0xb3 },
+	{ STB0899_TSULSTKM,	0x00 },
+	{ STB0899_TSULSTKL,	0x00 },
+	{ STB0899_PCKLENUL,	0xbc },
+	{ STB0899_PCKLENLL,	0xcc },
+	{ STB0899_RSPCKLEN,	0xbd },
+	{ STB0899_TSSTATUS,	0x90 },
+	{ STB0899_ERRCTRL1,	0xb6 },
+	{ STB0899_ERRCTRL2,	0x95 },
+	{ STB0899_ERRCTRL3,	0x8d },
+	{ STB0899_DMONMSK1,	0x27 },
+	{ STB0899_DMONMSK0,	0x03 },
+	{ STB0899_DEMAPVIT,	0x5c },
+	{ STB0899_PLPARM,	0x19 },
+	{ STB0899_PDELCTRL,	0x48 },
+	{ STB0899_PDELCTRL2,	0x00 },
+	{ STB0899_BBHCTRL1,	0x00 },
+	{ STB0899_BBHCTRL2,	0x00 },
+	{ STB0899_HYSTTHRESH,	0x77 },
+	{ STB0899_MATCSTM,	0x00 },
+	{ STB0899_MATCSTL,	0x00 },
+	{ STB0899_UPLCSTM,	0x00 },
+	{ STB0899_UPLCSTL,	0x00 },
+	{ STB0899_DFLCSTM,	0x00 },
+	{ STB0899_DFLCSTL,	0x00 },
+	{ STB0899_SYNCCST,	0x00 },
+	{ STB0899_SYNCDCSTM,	0x00 },
+	{ STB0899_SYNCDCSTL,	0x00 },
+	{ STB0899_ISI_ENTRY,	0x00 },
+	{ STB0899_ISI_BIT_EN,	0x00 },
+	{ STB0899_MATSTRM,	0xf0 },
+	{ STB0899_MATSTRL,	0x02 },
+	{ STB0899_UPLSTRM,	0x45 },
+	{ STB0899_UPLSTRL,	0x60 },
+	{ STB0899_DFLSTRM,	0xe3 },
+	{ STB0899_DFLSTRL,	0x00 },
+	{ STB0899_SYNCSTR,	0x47 },
+	{ STB0899_SYNCDSTRM,	0x05 },
+	{ STB0899_SYNCDSTRL,	0x18 },
+	{ STB0899_CFGPDELSTATUS1, 0x19 },
+	{ STB0899_CFGPDELSTATUS2, 0x2b },
+	{ STB0899_BBFERRORM,	0x00 },
+	{ STB0899_BBFERRORL,	0x01 },
+	{ STB0899_UPKTERRORM,	0x00 },
+	{ STB0899_UPKTERRORL,	0x00 },
+	{ 0xffff,		0xff },
+};
+
+static struct stb0899_config stb0899_config =3D {
+	.init_dev	=3D pctv452e_init_dev,
+	.init_s2_demod	=3D stb0899_s2_init_2,
+	.init_s1_demod	=3D pctv452e_init_s1_demod,
+	.init_s2_fec	=3D stb0899_s2_init_4,
+	.init_tst	=3D stb0899_s1_init_5,
+
+	.demod_address   =3D I2C_ADDR_STB0899, /* I2C Address */
+	.block_sync_mode =3D STB0899_SYNC_FORCED, /* ? */
+
+	.xtal_freq       =3D 27000000,	 /* Assume Hz ? */
+	.inversion       =3D IQ_SWAP_ON,       /* ? */
+
+	.lo_clk	  =3D 76500000,
+	.hi_clk	  =3D 99000000,
+
+	.ts_output_mode  =3D 0,	/* Use parallel mode */
+	.clock_polarity  =3D 0,
+	.data_clk_parity =3D 0,
+	.fec_mode	=3D 0,
+
+	.esno_ave	    =3D STB0899_DVBS2_ESNO_AVE,
+	.esno_quant	  =3D STB0899_DVBS2_ESNO_QUANT,
+	.avframes_coarse     =3D STB0899_DVBS2_AVFRAMES_COARSE,
+	.avframes_fine       =3D STB0899_DVBS2_AVFRAMES_FINE,
+	.miss_threshold      =3D STB0899_DVBS2_MISS_THRESHOLD,
+	.uwp_threshold_acq   =3D STB0899_DVBS2_UWP_THRESHOLD_ACQ,
+	.uwp_threshold_track =3D STB0899_DVBS2_UWP_THRESHOLD_TRACK,
+	.uwp_threshold_sof   =3D STB0899_DVBS2_UWP_THRESHOLD_SOF,
+	.sof_search_timeout  =3D STB0899_DVBS2_SOF_SEARCH_TIMEOUT,
+
+	.btr_nco_bits	  =3D STB0899_DVBS2_BTR_NCO_BITS,
+	.btr_gain_shift_offset =3D STB0899_DVBS2_BTR_GAIN_SHIFT_OFFSET,
+	.crl_nco_bits	  =3D STB0899_DVBS2_CRL_NCO_BITS,
+	.ldpc_max_iter	 =3D STB0899_DVBS2_LDPC_MAX_ITER,
+
+	.tuner_get_frequency	=3D stb6100_get_frequency,
+	.tuner_set_frequency	=3D stb6100_set_frequency,
+	.tuner_set_bandwidth	=3D stb6100_set_bandwidth,
+	.tuner_get_bandwidth	=3D stb6100_get_bandwidth,
+	.tuner_set_rfsiggain	=3D NULL,
+
+	/* helper for switching LED green/orange */
+	.postproc =3D pctv45e_postproc
+};
+
+static struct stb6100_config stb6100_config =3D {
+	.tuner_address =3D I2C_ADDR_STB6100,
+	.refclock      =3D 27000000
+};
+
+
+static struct i2c_algorithm pctv452e_i2c_algo =3D {
+	.master_xfer   =3D pctv452e_i2c_xfer,
+	.functionality =3D pctv452e_i2c_func
+};
+
+static int pctv452e_frontend_attach(struct dvb_usb_adapter *a)
+{
+	struct usb_device_id *id;
+
+	a->fe =3D dvb_attach(stb0899_attach, &stb0899_config, &a->dev->i2c_adap);
+	if (!a->fe)
+		return -ENODEV;
+	if ((dvb_attach(lnbp22_attach, a->fe, &a->dev->i2c_adap)) =3D=3D 0)
+		err("Cannot attach lnbp22\n");
+
+	id =3D a->dev->desc->warm_ids[0];
+	if (USB_VID_TECHNOTREND =3D=3D id->idVendor
+	    && USB_PID_TECHNOTREND_CONNECT_S2_3650_CI =3D=3D id->idProduct)
+		/* Error ignored. */
+		tt3650_ci_init(a);
+
+	return 0;
+}
+
+static int pctv452e_tuner_attach(struct dvb_usb_adapter *a)
+{
+	if (!a->fe)
+		return -ENODEV;
+	if (dvb_attach(stb6100_attach, a->fe, &stb6100_config,
+					&a->dev->i2c_adap) =3D=3D 0) {
+		err("%s failed\n", __func__);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static struct usb_device_id pctv452e_usb_table[] =3D {
+	{USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_452E)},
+	{USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2_3600)},
+	{USB_DEVICE(USB_VID_TECHNOTREND,
+				USB_PID_TECHNOTREND_CONNECT_S2_3650_CI)},
+	{}
+};
+MODULE_DEVICE_TABLE(usb, pctv452e_usb_table);
+
+static struct dvb_usb_device_properties pctv452e_properties =3D {
+	.caps =3D DVB_USB_IS_AN_I2C_ADAPTER, /* more ? */
+	.usb_ctrl =3D DEVICE_SPECIFIC,
+
+	.size_of_priv     =3D sizeof(struct pctv452e_state),
+
+	.identify_state   =3D 0, /* this is a warm only device */
+
+	.power_ctrl       =3D pctv452e_power_ctrl,
+	/* Untested. */
+	/* .read_mac_address =3D pctv452e_read_mac_address, */
+
+	.rc.legacy =3D {
+		.rc_map_table	=3D rc_map_pctv452e_table,
+		.rc_map_size	=3D ARRAY_SIZE(rc_map_pctv452e_table),
+		.rc_query	=3D pctv452e_rc_query,
+		.rc_interval	=3D 100,
+	},
+
+	.num_adapters     =3D 1,
+	.adapter =3D {{
+		.caps	     =3D 0,
+		.pid_filter_count =3D 0,
+
+		.streaming_ctrl   =3D NULL,
+
+		.frontend_attach  =3D pctv452e_frontend_attach,
+		.tuner_attach     =3D pctv452e_tuner_attach,
+
+		/* parameter for the MPEG2-data transfer */
+		.stream =3D {
+			.type     =3D USB_ISOC,
+			.count    =3D ISO_BUF_COUNT,
+			.endpoint =3D 0x02,
+			.u =3D {
+				.isoc =3D {
+					.framesperurb =3D FRAMES_PER_ISO_BUF,
+					.framesize    =3D ISO_FRAME_SIZE,
+					.interval     =3D 1
+				}
+			}
+		},
+		.size_of_priv     =3D 0
+	} },
+
+	.i2c_algo =3D &pctv452e_i2c_algo,
+
+	.generic_bulk_ctrl_endpoint =3D 1, /* allow generice rw function */
+
+	.num_device_descs =3D 1,
+	.devices =3D {
+		{ .name =3D "PCTV HDTV USB",
+		  .cold_ids =3D { NULL, NULL }, /* this is a warm only device */
+		  .warm_ids =3D { &pctv452e_usb_table[0], NULL }
+		},
+		{ 0 },
+	}
+};
+
+static struct dvb_usb_device_properties tt_connect_s2_3600_properties =3D {
+	.caps =3D DVB_USB_IS_AN_I2C_ADAPTER, /* more ? */
+	.usb_ctrl =3D DEVICE_SPECIFIC,
+
+	.size_of_priv		=3D sizeof(struct pctv452e_state),
+
+	.identify_state		=3D 0, /* this is a warm only device */
+
+	.power_ctrl		=3D pctv452e_power_ctrl,
+	.read_mac_address	=3D pctv452e_read_mac_address,
+
+	.rc.legacy =3D {
+		.rc_map_table	=3D rc_map_s2_3600_table,
+		.rc_map_size	=3D ARRAY_SIZE(rc_map_s2_3600_table),
+		.rc_query	=3D pctv452e_rc_query,
+		.rc_interval	=3D 500,
+	},
+
+	.num_adapters		=3D 1,
+	.adapter =3D {{
+		.caps =3D 0,
+		.pid_filter_count =3D 0,
+
+		.streaming_ctrl =3D NULL,
+
+		.frontend_attach =3D pctv452e_frontend_attach,
+		.tuner_attach =3D pctv452e_tuner_attach,
+
+		/* parameter for the MPEG2-data transfer */
+		.stream =3D {
+			.type =3D USB_ISOC,
+			.count =3D 7,
+			.endpoint =3D 0x02,
+			.u =3D {
+				.isoc =3D {
+					.framesperurb =3D 4,
+					.framesize =3D 940,
+					.interval =3D 1
+				}
+			}
+		},
+		.size_of_priv =3D 0
+	} },
+
+	.i2c_algo =3D &pctv452e_i2c_algo,
+
+	.generic_bulk_ctrl_endpoint =3D 1, /* allow generice rw function*/
+
+	.num_device_descs =3D 2,
+	.devices =3D {
+		{ .name =3D "Technotrend TT Connect S2-3600",
+		  .cold_ids =3D { NULL, NULL }, /* this is a warm only device */
+		  .warm_ids =3D { &pctv452e_usb_table[1], NULL }
+		},
+		{ .name =3D "Technotrend TT Connect S2-3650-CI",
+		  .cold_ids =3D { NULL, NULL },
+		  .warm_ids =3D { &pctv452e_usb_table[2], NULL }
+		},
+		{ 0 },
+	}
+};
+
+static void pctv452e_usb_disconnect(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d =3D usb_get_intfdata(intf);
+
+	tt3650_ci_uninit(d);
+	dvb_usb_device_exit(intf);
+}
+
+static int pctv452e_usb_probe(struct usb_interface *intf,
+				const struct usb_device_id *id)
+{
+	if (0 =3D=3D dvb_usb_device_init(intf, &pctv452e_properties,
+					THIS_MODULE, NULL, adapter_nr) ||
+	    0 =3D=3D dvb_usb_device_init(intf, &tt_connect_s2_3600_properties,
+					THIS_MODULE, NULL, adapter_nr))
+		return 0;
+
+	return -ENODEV;
+}
+
+static struct usb_driver pctv452e_usb_driver =3D {
+	.name       =3D "pctv452e",
+	.probe      =3D pctv452e_usb_probe,
+	.disconnect =3D pctv452e_usb_disconnect,
+	.id_table   =3D pctv452e_usb_table,
+};
+
+static struct usb_driver tt_connects2_3600_usb_driver =3D {
+	.name       =3D "dvb-usb-tt-connect-s2-3600-01.fw",
+	.probe      =3D pctv452e_usb_probe,
+	.disconnect =3D pctv452e_usb_disconnect,
+	.id_table   =3D pctv452e_usb_table,
+};
+
+static int __init pctv452e_usb_init(void)
+{
+	int ret =3D usb_register(&pctv452e_usb_driver);
+
+	if (ret) {
+		err("%s: usb_register failed! Error %d", __FILE__, ret);
+		return ret;
+	}
+	ret =3D usb_register(&tt_connects2_3600_usb_driver);
+	if (ret)
+		err("%s: usb_register failed! Error %d", __FILE__, ret);
+
+	return ret;
+}
+
+static void __exit pctv452e_usb_exit(void)
+{
+	usb_deregister(&pctv452e_usb_driver);
+	usb_deregister(&tt_connects2_3600_usb_driver);
+}
+
+module_init(pctv452e_usb_init);
+module_exit(pctv452e_usb_exit);
+
+MODULE_AUTHOR("Dominik Kuhlen <dkuhlen@gmx.net>");
+MODULE_AUTHOR("Andre Weidemann <Andre.Weidemann@web.de>");
+MODULE_AUTHOR("Michael H. Schimek <mschimek@gmx.at>");
+MODULE_DESCRIPTION("Pinnacle PCTV HDTV USB DVB / TT connect S2-3600 Driver=
");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/fronte=
nds/Kconfig
index 28fbb5c..4a2d2e6 100644
=2D-- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -607,6 +607,16 @@ config DVB_LNBP21
 	help
 	  An SEC control chips.
=20
+config DVB_LNBP22
+	tristate "LNBP22 SEC controllers"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  LNB power supply and control voltage
+	  regulator chip with step-up converter
+	  and I2C interface.
+	  Say Y when you want to support this chip.
+
 config DVB_ISL6405
 	tristate "ISL6405 SEC controller"
 	depends on DVB_CORE && I2C
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/front=
ends/Makefile
index 36c8d81..f639f67 100644
=2D-- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_DVB_LGDT330X) +=3D lgdt330x.o
 obj-$(CONFIG_DVB_LGDT3305) +=3D lgdt3305.o
 obj-$(CONFIG_DVB_CX24123) +=3D cx24123.o
 obj-$(CONFIG_DVB_LNBP21) +=3D lnbp21.o
+obj-$(CONFIG_DVB_LNBP22) +=3D lnbp22.o
 obj-$(CONFIG_DVB_ISL6405) +=3D isl6405.o
 obj-$(CONFIG_DVB_ISL6421) +=3D isl6421.o
 obj-$(CONFIG_DVB_TDA10086) +=3D tda10086.o
diff --git a/drivers/media/dvb/frontends/lnbp22.c b/drivers/media/dvb/front=
ends/lnbp22.c
new file mode 100644
index 0000000..84ad039
=2D-- /dev/null
+++ b/drivers/media/dvb/frontends/lnbp22.c
@@ -0,0 +1,148 @@
+/*
+ * lnbp22.h - driver for lnb supply and control ic lnbp22
+ *
+ * Copyright (C) 2006 Dominik Kuhlen
+ * Based on lnbp21 driver
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, U=
SA.
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ *
+ *
+ * the project's page is at http://www.linuxtv.org
+ */
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+#include "dvb_frontend.h"
+#include "lnbp22.h"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+
+#define dprintk(lvl, arg...) if (debug >=3D (lvl)) printk(arg)
+
+struct lnbp22 {
+	u8		    config[4];
+	struct i2c_adapter *i2c;
+};
+
+static int lnbp22_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t vo=
ltage)
+{
+	struct lnbp22 *lnbp22 =3D (struct lnbp22 *)fe->sec_priv;
+	struct i2c_msg msg =3D {
+		.addr =3D 0x08,
+		.flags =3D 0,
+		.buf =3D (char *)&lnbp22->config,
+		.len =3D sizeof(lnbp22->config),
+	};
+
+	dprintk(1, "%s: %d (18V=3D%d 13V=3D%d)\n", __func__, voltage,
+	       SEC_VOLTAGE_18, SEC_VOLTAGE_13);
+
+	lnbp22->config[3] =3D 0x60; /* Power down */
+	switch (voltage) {
+	case SEC_VOLTAGE_OFF:
+		break;
+	case SEC_VOLTAGE_13:
+		lnbp22->config[3] |=3D LNBP22_EN;
+		break;
+	case SEC_VOLTAGE_18:
+		lnbp22->config[3] |=3D (LNBP22_EN | LNBP22_VSEL);
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	dprintk(1, "%s: 0x%02x)\n", __func__, lnbp22->config[3]);
+	return (i2c_transfer(lnbp22->i2c, &msg, 1) =3D=3D 1) ? 0 : -EIO;
+}
+
+static int lnbp22_enable_high_lnb_voltage(struct dvb_frontend *fe, long ar=
g)
+{
+	struct lnbp22 *lnbp22 =3D (struct lnbp22 *) fe->sec_priv;
+	struct i2c_msg msg =3D {
+		.addr =3D 0x08,
+		.flags =3D 0,
+		.buf =3D (char *)&lnbp22->config,
+		.len =3D sizeof(lnbp22->config),
+	};
+
+	dprintk(1, "%s: %d\n", __func__, (int)arg);
+	if (arg)
+		lnbp22->config[3] |=3D LNBP22_LLC;
+	else
+		lnbp22->config[3] &=3D ~LNBP22_LLC;
+
+	return (i2c_transfer(lnbp22->i2c, &msg, 1) =3D=3D 1) ? 0 : -EIO;
+}
+
+static void lnbp22_release(struct dvb_frontend *fe)
+{
+	dprintk(1, "%s\n", __func__);
+	/* LNBP power off */
+	lnbp22_set_voltage(fe, SEC_VOLTAGE_OFF);
+
+	/* free data */
+	kfree(fe->sec_priv);
+	fe->sec_priv =3D NULL;
+}
+
+struct dvb_frontend *lnbp22_attach(struct dvb_frontend *fe,
+					struct i2c_adapter *i2c)
+{
+	struct lnbp22 *lnbp22 =3D kmalloc(sizeof(struct lnbp22), GFP_KERNEL);
+	if (!lnbp22)
+		return NULL;
+
+	/* default configuration */
+	lnbp22->config[0] =3D 0x00; /* ? */
+	lnbp22->config[1] =3D 0x28; /* ? */
+	lnbp22->config[2] =3D 0x48; /* ? */
+	lnbp22->config[3] =3D 0x60; /* Power down */
+	lnbp22->i2c =3D i2c;
+	fe->sec_priv =3D lnbp22;
+
+	/* detect if it is present or not */
+	if (lnbp22_set_voltage(fe, SEC_VOLTAGE_OFF)) {
+		dprintk(0, "%s LNBP22 not found\n", __func__);
+		kfree(lnbp22);
+		fe->sec_priv =3D NULL;
+		return NULL;
+	}
+
+	/* install release callback */
+	fe->ops.release_sec =3D lnbp22_release;
+
+	/* override frontend ops */
+	fe->ops.set_voltage =3D lnbp22_set_voltage;
+	fe->ops.enable_high_lnb_voltage =3D lnbp22_enable_high_lnb_voltage;
+
+	return fe;
+}
+EXPORT_SYMBOL(lnbp22_attach);
+
+MODULE_DESCRIPTION("Driver for lnb supply and control ic lnbp22");
+MODULE_AUTHOR("Dominik Kuhlen");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/lnbp22.h b/drivers/media/dvb/front=
ends/lnbp22.h
new file mode 100644
index 0000000..63e2dec
=2D-- /dev/null
+++ b/drivers/media/dvb/frontends/lnbp22.h
@@ -0,0 +1,57 @@
+/*
+ * lnbp22.h - driver for lnb supply and control ic lnbp22
+ *
+ * Copyright (C) 2006 Dominik Kuhlen
+ * Based on lnbp21.h
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, U=
SA.
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ *
+ *
+ * the project's page is at http://www.linuxtv.org
+ */
+
+#ifndef _LNBP22_H
+#define _LNBP22_H
+
+/* Enable */
+#define LNBP22_EN	  0x10
+/* Voltage selection */
+#define LNBP22_VSEL	0x02
+/* Plus 1 Volt Bit */
+#define LNBP22_LLC	0x01
+
+#include <linux/dvb/frontend.h>
+
+#if defined(CONFIG_DVB_LNBP22) || \
+		(defined(CONFIG_DVB_LNBP22_MODULE) && defined(MODULE))
+/*
+ * override_set and override_clear control which system register bits (abo=
ve)
+ * to always set & clear
+ */
+extern struct dvb_frontend *lnbp22_attach(struct dvb_frontend *fe,
+						struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *lnbp22_attach(struct dvb_frontend *fe,
+						struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_DVB_LNBP22 */
+
+#endif /* _LNBP22_H */
diff --git a/drivers/media/dvb/ttpci/ttpci-eeprom.c b/drivers/media/dvb/ttp=
ci/ttpci-eeprom.c
index 7dd54b3..32d4315 100644
=2D-- a/drivers/media/dvb/ttpci/ttpci-eeprom.c
+++ b/drivers/media/dvb/ttpci/ttpci-eeprom.c
@@ -85,6 +85,35 @@ static int getmac_tt(u8 * decodedMAC, u8 * encodedMAC)
 	return 0;
 }
=20
+int ttpci_eeprom_decode_mac(u8 *decodedMAC, u8 *encodedMAC)
+{
+	u8 xor[20] =3D { 0x72, 0x23, 0x68, 0x19, 0x5c, 0xa8, 0x71, 0x2c,
+		       0x54, 0xd3, 0x7b, 0xf1, 0x9E, 0x23, 0x16, 0xf6,
+		       0x1d, 0x36, 0x64, 0x78};
+	u8 data[20];
+	int i;
+
+	memcpy(data, encodedMAC, 20);
+
+	for (i =3D 0; i < 20; i++)
+		data[i] ^=3D xor[i];
+	for (i =3D 0; i < 10; i++)
+		data[i] =3D ((data[2 * i + 1] << 8) | data[2 * i])
+			>> ((data[2 * i + 1] >> 6) & 3);
+
+	if (check_mac_tt(data))
+		return -ENODEV;
+
+	decodedMAC[0] =3D data[2];
+	decodedMAC[1] =3D data[1];
+	decodedMAC[2] =3D data[0];
+	decodedMAC[3] =3D data[6];
+	decodedMAC[4] =3D data[5];
+	decodedMAC[5] =3D data[4];
+	return 0;
+}
+EXPORT_SYMBOL(ttpci_eeprom_decode_mac);
+
 static int ttpci_eeprom_read_encodedMAC(struct i2c_adapter *adapter, u8 * =
encodedMAC)
 {
 	int ret;
diff --git a/drivers/media/dvb/ttpci/ttpci-eeprom.h b/drivers/media/dvb/ttp=
ci/ttpci-eeprom.h
index e2dc6cf..dcc33d5 100644
=2D-- a/drivers/media/dvb/ttpci/ttpci-eeprom.h
+++ b/drivers/media/dvb/ttpci/ttpci-eeprom.h
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/i2c.h>
=20
+extern int ttpci_eeprom_decode_mac(u8 *decodedMAC, u8 *encodedMAC);
 extern int ttpci_eeprom_parse_mac(struct i2c_adapter *adapter, u8 *propsed=
_mac);
=20
 #endif
=2D-=20
1.7.4.4


--Boundary-00=_XCPfOapUNhZ8Mqv--
