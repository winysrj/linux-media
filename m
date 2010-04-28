Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:3685 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab0D1B34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 21:29:56 -0400
Received: by ey-out-2122.google.com with SMTP id d26so1248911eyd.19
        for <linux-media@vger.kernel.org>; Tue, 27 Apr 2010 18:29:55 -0700 (PDT)
Date: Wed, 28 Apr 2010 11:32:43 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Bee Hock Goh <beehock@gmail.com>
Cc: Stefan Ringel <stefan.ringel@arcor.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] tm6000 fix i2c
Message-ID: <20100428113243.26bc7030@glory.loctelecom.ru>
In-Reply-To: <t2v6e8e83e21004262307wfc0b746x22779c4a2ad431ee@mail.gmail.com>
References: <20100423104804.784fb730@glory.loctelecom.ru>
	<4BD1B985.8060703@arcor.de>
	<20100426102514.2c13761e@glory.loctelecom.ru>
	<k2m6e8e83e21004260558sb3695c27o5d061b7bc69198c1@mail.gmail.com>
	<20100427151545.217a5c90@glory.loctelecom.ru>
	<t2v6e8e83e21004262307wfc0b746x22779c4a2ad431ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/xGT9dWxg7Pit41M4dUfctyV"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/xGT9dWxg7Pit41M4dUfctyV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, 27 Apr 2010 14:07:00 +0800
Bee Hock Goh <beehock@gmail.com> wrote:

> wiki is your best friend. :)
>=20
> http://www.linuxtv.org/wiki/index.php/Maintaining_Git_trees
> http://www.linuxtv.org/wiki/index.php/Using_a_git_driver_development_tree

Ok.

This is new version. Made by git.

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/t=
m6000-i2c.c
index 2ab632b..e9b568d 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -47,8 +47,38 @@ MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]=
");
 static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char add=
r,
 				__u8 reg, char *buf, int len)
 {
-	return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR | USB_REC=
IP_DEVICE,
-		REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
+	int rc;
+	unsigned int tsleep;
+	unsigned int i2c_packet_limit =3D 16;
+
+	if (dev->dev_type =3D=3D TM6010)
+		i2c_packet_limit =3D 64;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet =3D %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
+	rc =3D tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+		addr | reg << 8, 0, buf, len);
+
+	if (rc < 0) {
+		/* release mutex */
+		return rc;
+	}
+
+	/* Calculate delay time, 14000us for 64 bytes */
+	tsleep =3D ((len * 200) + 200 + 1000) / 1000;
+	msleep(tsleep);
+
+	/* release mutex */
+	return rc;
 }
=20
 /* Generic read - doesn't work fine with 16bit registers */
@@ -57,7 +87,21 @@ static int tm6000_i2c_recv_regs(struct tm6000_core *dev,=
 unsigned char addr,
 {
 	int rc;
 	u8 b[2];
+	unsigned int i2c_packet_limit =3D 16;
+
+	if (dev->dev_type =3D=3D TM6010)
+		i2c_packet_limit =3D 64;
+
+	if (!buf)
+		return -1;
=20
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet =3D %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
 	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 =3D=3D addr) && (reg=
 % 2 =3D=3D 0)) {
 		/*
 		 * Workaround an I2C bug when reading from zl10353
@@ -74,6 +118,7 @@ static int tm6000_i2c_recv_regs(struct tm6000_core *dev,=
 unsigned char addr,
 			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
 	}
=20
+	/* release mutex */
 	return rc;
 }
=20
@@ -84,8 +129,37 @@ static int tm6000_i2c_recv_regs(struct tm6000_core *dev=
, unsigned char addr,
 static int tm6000_i2c_recv_regs16(struct tm6000_core *dev, unsigned char a=
ddr,
 				  __u16 reg, char *buf, int len)
 {
-	return tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECI=
P_DEVICE,
-		REQ_14_SET_GET_I2C_WR2_RDN, addr, reg, buf, len);
+	int rc;
+	unsigned char ureg;
+
+	if (!buf || len !=3D 2)
+		return -1;
+
+	/* capture mutex */
+	if (dev->dev_type =3D=3D TM6010){
+		ureg =3D reg & 0xFF;
+		rc =3D tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+			addr | (reg & 0xFF00), 0, &ureg, 1);
+
+		if (rc < 0) {
+			/* release mutex */
+			return rc;
+		}
+
+		msleep(1400 / 1000);
+		rc =3D tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
+			reg, 0, buf, len);
+	}
+	else {
+		rc =3D tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_14_SET_GET_I2C_WR2_RDN,
+			addr, reg, buf, len);
+	}
+
+	/* release mutex */
+	return rc;
 }
=20
 static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


>=20
> On Tue, Apr 27, 2010 at 1:15 PM, Dmitri Belimov <d.belimov@gmail.com>
> wrote:
> > On Mon, 26 Apr 2010 20:58:24 +0800
> > Bee Hock Goh <beehock@gmail.com> wrote:
> >
> >> thanks. This is work fine on my tm5600.
> >
> > Good news.
> >
> >> btw, can you use the git tree? There is some codes update from
> >> Stefan there for the tm6000-i2c that is still not sync with hg.
> >
> > no problemm. Give me access and URL.
> >
> > With my best regards, Dmitry.
> >
> >> On Mon, Apr 26, 2010 at 8:25 AM, Dmitri Belimov
> >> <d.belimov@gmail.com> wrote:
> >> > Hi
> >> >
> >> > Rework last I2C patch.
> >> > Set correct limit for I2C packet.
> >> > Use different method for the tm5600/tm6000 and tm6010 to read
> >> > word.
> >> >
> >> > Try this patch.
> >> >
> >> > diff -r 7c0b887911cf linux/drivers/staging/tm6000/tm6000-i2c.c
> >> > --- a/linux/drivers/staging/tm6000/tm6000-i2c.c Mon Apr 05
> >> > 22:56:43 2010 -0400 +++
> >> > b/linux/drivers/staging/tm6000/tm6000-i2c.c Mon Apr 26 04:15:56
> >> > 2010 +1000 @@ -24,6 +24,7 @@ #include <linux/kernel.h>
> >> > =C2=A0#include <linux/usb.h>
> >> > =C2=A0#include <linux/i2c.h>
> >> > +#include <linux/delay.h>
> >> >
> >> > =C2=A0#include "compat.h"
> >> > =C2=A0#include "tm6000.h"
> >> > @@ -45,11 +46,49 @@
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0printk(KERN_DEBUG "%s at %s: " fmt, \
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0dev->name, __FUNCTION__ , ##args); } while
> >> > (0)
> >> >
> >> > +static void tm6000_i2c_reset(struct tm6000_core *dev)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> >> > TM6000_GPIO_CLK, 0);
> >> > + =C2=A0 =C2=A0 =C2=A0 msleep(15);
> >> > + =C2=A0 =C2=A0 =C2=A0 tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> >> > TM6000_GPIO_CLK, 1);
> >> > + =C2=A0 =C2=A0 =C2=A0 msleep(15);
> >> > +}
> >> > +
> >> > =C2=A0static int tm6000_i2c_send_regs(struct tm6000_core *dev,
> >> > unsigned char addr, __u8 reg, char *buf, int len)
> >> > =C2=A0{
> >> > - =C2=A0 =C2=A0 =C2=A0 return tm6000_read_write_usb(dev, USB_DIR_OUT=
 |
> >> > USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 REQ_16_SET_GET_I2=
C_WR1_RDN, addr | reg << 8, 0,
> >> > buf, len);
> >> > + =C2=A0 =C2=A0 =C2=A0 int rc;
> >> > + =C2=A0 =C2=A0 =C2=A0 unsigned int tsleep;
> >> > + =C2=A0 =C2=A0 =C2=A0 unsigned int i2c_packet_limit =3D 16;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (dev->dev_type =3D=3D TM6010)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i2c_packet_limit =
=3D 64;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (!buf)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (len < 1 || len > i2c_packet_limit){
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("Incorrect=
 lenght of i2c packet =3D %d,
> >> > limit set to %d\n",
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 len, i2c_packet_limit);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* capture mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_read_write_usb(dev, USB_DIR_OUT=
 |
> >> > USB_TYPE_VENDOR |
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 USB_RECIP_DEVICE,=
 REQ_16_SET_GET_I2C_WR1_RDN,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 addr | reg << 8, =
0, buf, len);
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (rc < 0) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* release mutex =
*/
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* Calculate delay time, 14000us for 64 bytes=
 */
> >> > + =C2=A0 =C2=A0 =C2=A0 tsleep =3D ((len * 200) + 200 + 1000) / 1000;
> >> > + =C2=A0 =C2=A0 =C2=A0 msleep(tsleep);
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* release mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 return rc;
> >> > =C2=A0}
> >> >
> >> > =C2=A0/* Generic read - doesn't work fine with 16bit registers */
> >> > @@ -58,23 +97,41 @@
> >> > =C2=A0{
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 b[2];
> >> > + =C2=A0 =C2=A0 =C2=A0 unsigned int i2c_packet_limit =3D 16;
> >> >
> >> > - =C2=A0 =C2=A0 =C2=A0 if ((dev->caps.has_zl10353) && (dev->demod_ad=
dr << 1 =3D=3D
> >> > addr) && (reg % 2 =3D=3D 0)) {
> >> > + =C2=A0 =C2=A0 =C2=A0 if (dev->dev_type =3D=3D TM6010)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i2c_packet_limit =
=3D 64;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (!buf)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (len < 1 || len > i2c_packet_limit){
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("Incorrect=
 lenght of i2c packet =3D %d,
> >> > limit set to %d\n",
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 len, i2c_packet_limit);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* capture mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 if ((dev->caps.has_zl10353) && (dev->demod_ad=
dr << 1 =3D=3D
> >> > addr)
> >> > + =C2=A0 =C2=A0 =C2=A0 && (reg % 2 =3D=3D 0)) {
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Workaround=
 an I2C bug when reading from zl10353
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reg -=3D 1;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0len +=3D 1;
> >> >
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_rea=
d_write_usb(dev, USB_DIR_IN |
> >> > USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 REQ_16_SET_GET_I2C_WR1_RDN, addr | reg <<
> >> > 8, 0, b, len);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_rea=
d_write_usb(dev, USB_DIR_IN |
> >> > USB_TYPE_VENDOR |
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 USB_RECIP_DEVICE,=
 REQ_16_SET_GET_I2C_WR1_RDN,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 addr | reg << 8, =
0, b, len);
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*buf =3D b[1];
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_rea=
d_write_usb(dev, USB_DIR_IN |
> >> > USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 REQ_16_SET_GET_I2C_WR1_RDN, addr | reg <<
> >> > 8, 0, buf, len);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_rea=
d_write_usb(dev, USB_DIR_IN |
> >> > USB_TYPE_VENDOR |
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 USB_RECIP_DEVICE,=
 REQ_16_SET_GET_I2C_WR1_RDN,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 addr | reg << 8, =
0, buf, len);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >> >
> >> > + =C2=A0 =C2=A0 =C2=A0 /* release mutex */
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> >> > =C2=A0}
> >> >
> >> > @@ -85,8 +142,137 @@
> >> > =C2=A0static int tm6000_i2c_recv_regs16(struct tm6000_core *dev,
> >> > unsigned char addr, __u16 reg, char *buf, int len)
> >> > =C2=A0{
> >> > - =C2=A0 =C2=A0 =C2=A0 return tm6000_read_write_usb(dev, USB_DIR_IN |
> >> > USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 REQ_14_SET_GET_I2=
C_WR2_RDN, addr, reg, buf, len);
> >> > + =C2=A0 =C2=A0 =C2=A0 int rc;
> >> > + =C2=A0 =C2=A0 =C2=A0 unsigned char ureg;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (!buf || len !=3D 2)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* capture mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 if (dev->dev_type =3D=3D TM6010){
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ureg =3D reg & 0x=
FF;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_rea=
d_write_usb(dev, USB_DIR_OUT |
> >> > USB_TYPE_VENDOR |
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 USB_RECIP_DEVICE,
> >> > REQ_16_SET_GET_I2C_WR1_RDN,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 addr | (reg & 0xFF00), 0, &ureg, 1);
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc < 0) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* release mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return rc;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 msleep(1400 / 100=
0);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_rea=
d_write_usb(dev, USB_DIR_IN |
> >> > USB_TYPE_VENDOR |
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 USB_RECIP_DEVICE,
> >> > REQ_35_AFTEK_TUNER_READ,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 reg, 0, buf, len);
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > + =C2=A0 =C2=A0 =C2=A0 else {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_rea=
d_write_usb(dev, USB_DIR_IN |
> >> > USB_TYPE_VENDOR |
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 USB_RECIP_DEVICE,
> >> > REQ_14_SET_GET_I2C_WR2_RDN,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 addr, reg, buf, len);
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* release mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 return rc;
> >> > +}
> >> > +
> >> > +static int tm6000_i2c_read_sequence(struct tm6000_core *dev,
> >> > unsigned char addr,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __u16 reg, char *buf, int len)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 int rc;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (dev->dev_type !=3D TM6010)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (!buf)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (len < 1 || len > 64){
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("Incorrect=
 lenght of i2c packet =3D %d,
> >> > limit set to 64\n",
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 len);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* capture mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_read_write_usb(dev, USB_DIR_IN |
> >> > USB_TYPE_VENDOR |
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 USB_RECIP_DEVICE,=
 REQ_35_AFTEK_TUNER_READ,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reg, 0, buf, len);
> >> > + =C2=A0 =C2=A0 =C2=A0 /* release mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 return rc;
> >> > +}
> >> > +
> >> > +static int tm6000_i2c_write_sequence(struct tm6000_core *dev,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char addr, __u16 reg,
> >> > char *buf,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int len)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 int rc;
> >> > + =C2=A0 =C2=A0 =C2=A0 unsigned int tsleep;
> >> > + =C2=A0 =C2=A0 =C2=A0 unsigned int i2c_packet_limit =3D 16;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (dev->dev_type =3D=3D TM6010)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i2c_packet_limit =
=3D 64;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (!buf)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (len < 1 || len > i2c_packet_limit){
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("Incorrect=
 lenght of i2c packet =3D %d,
> >> > limit set to %d\n",
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 len, i2c_packet_limit);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* capture mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_read_write_usb(dev, USB_DIR_OUT=
 |
> >> > USB_TYPE_VENDOR |
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 USB_RECIP_DEVICE,=
 REQ_16_SET_GET_I2C_WR1_RDN,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 addr | reg << 8, =
0, buf+1, len-1);
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (rc < 0) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* release mutex =
*/
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* Calculate delay time, 13800us for 64 bytes=
 */
> >> > + =C2=A0 =C2=A0 =C2=A0 tsleep =3D ((len * 200) + 1000) / 1000;
> >> > + =C2=A0 =C2=A0 =C2=A0 msleep(tsleep);
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* release mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 return rc;
> >> > +}
> >> > +
> >> > +static int tm6000_i2c_write_uni(struct tm6000_core *dev,
> >> > unsigned char addr,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __u16 reg, char *buf, int len)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 int rc;
> >> > + =C2=A0 =C2=A0 =C2=A0 unsigned int tsleep;
> >> > + =C2=A0 =C2=A0 =C2=A0 unsigned int i2c_packet_limit =3D 16;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (dev->dev_type =3D=3D TM6010)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i2c_packet_limit =
=3D 64;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (!buf)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (len < 1 || len > i2c_packet_limit){
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("Incorrect=
 lenght of i2c packet =3D %d,
> >> > limit set to %d\n",
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 len, i2c_packet_limit);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* capture mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 rc =3D tm6000_read_write_usb(dev, USB_DIR_OUT=
 |
> >> > USB_TYPE_VENDOR |
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 USB_RECIP_DEVICE,=
 REQ_30_I2C_WRITE,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 addr | reg << 8, =
0, buf+1, len-1);
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (rc < 0) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* release mutex =
*/
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* Calculate delay time, 14800us for 64 bytes=
 */
> >> > + =C2=A0 =C2=A0 =C2=A0 tsleep =3D ((len * 200) + 1000 + 1000) / 1000;
> >> > + =C2=A0 =C2=A0 =C2=A0 msleep(tsleep);
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 /* release mutex */
> >> > + =C2=A0 =C2=A0 =C2=A0 return rc;
> >> > =C2=A0}
> >> >
> >> > =C2=A0static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
> >> >
> >> >
> >> > With my best regards, Dmitry.
> >

With my best regards, Dmitry.

--MP_/xGT9dWxg7Pit41M4dUfctyV
Content-Type: text/x-patch; name=tm6000_i2c.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_i2c.patch

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 2ab632b..e9b568d 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -47,8 +47,38 @@ MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
 				__u8 reg, char *buf, int len)
 {
-	return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-		REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
+	int rc;
+	unsigned int tsleep;
+	unsigned int i2c_packet_limit = 16;
+
+	if (dev->dev_type == TM6010)
+		i2c_packet_limit = 64;
+
+	if (!buf)
+		return -1;
+
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet = %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+		addr | reg << 8, 0, buf, len);
+
+	if (rc < 0) {
+		/* release mutex */
+		return rc;
+	}
+
+	/* Calculate delay time, 14000us for 64 bytes */
+	tsleep = ((len * 200) + 200 + 1000) / 1000;
+	msleep(tsleep);
+
+	/* release mutex */
+	return rc;
 }
 
 /* Generic read - doesn't work fine with 16bit registers */
@@ -57,7 +87,21 @@ static int tm6000_i2c_recv_regs(struct tm6000_core *dev, unsigned char addr,
 {
 	int rc;
 	u8 b[2];
+	unsigned int i2c_packet_limit = 16;
+
+	if (dev->dev_type == TM6010)
+		i2c_packet_limit = 64;
+
+	if (!buf)
+		return -1;
 
+	if (len < 1 || len > i2c_packet_limit){
+		printk("Incorrect lenght of i2c packet = %d, limit set to %d\n",
+			len, i2c_packet_limit);
+		return -1;
+	}
+
+	/* capture mutex */
 	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr) && (reg % 2 == 0)) {
 		/*
 		 * Workaround an I2C bug when reading from zl10353
@@ -74,6 +118,7 @@ static int tm6000_i2c_recv_regs(struct tm6000_core *dev, unsigned char addr,
 			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
 	}
 
+	/* release mutex */
 	return rc;
 }
 
@@ -84,8 +129,37 @@ static int tm6000_i2c_recv_regs(struct tm6000_core *dev, unsigned char addr,
 static int tm6000_i2c_recv_regs16(struct tm6000_core *dev, unsigned char addr,
 				  __u16 reg, char *buf, int len)
 {
-	return tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-		REQ_14_SET_GET_I2C_WR2_RDN, addr, reg, buf, len);
+	int rc;
+	unsigned char ureg;
+
+	if (!buf || len != 2)
+		return -1;
+
+	/* capture mutex */
+	if (dev->dev_type == TM6010){
+		ureg = reg & 0xFF;
+		rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
+			addr | (reg & 0xFF00), 0, &ureg, 1);
+
+		if (rc < 0) {
+			/* release mutex */
+			return rc;
+		}
+
+		msleep(1400 / 1000);
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
+			reg, 0, buf, len);
+	}
+	else {
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+			USB_RECIP_DEVICE, REQ_14_SET_GET_I2C_WR2_RDN,
+			addr, reg, buf, len);
+	}
+
+	/* release mutex */
+	return rc;
 }
 
 static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/xGT9dWxg7Pit41M4dUfctyV--
