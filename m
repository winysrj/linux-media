Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:41155 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbZG2WWb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 18:22:31 -0400
Received: by ewy10 with SMTP id 10so342031ewy.37
        for <linux-media@vger.kernel.org>; Wed, 29 Jul 2009 15:22:30 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Subject: Re: TBS 8920 still fails to initialize - cx24116_readreg error
Date: Thu, 30 Jul 2009 01:22:21 +0300
Cc: Mark Zimmerman <markzimm@frii.com>
References: <20090724023315.GA96337@io.frii.com> <200907272050.20827.liplianin@me.by> <20090728012154.GA99886@io.frii.com>
In-Reply-To: <20090728012154.GA99886@io.frii.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_euMcKbfXSwhDCAm"
Message-Id: <200907300122.22215.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_euMcKbfXSwhDCAm
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 28 =C9=C0=CC=D1 2009 04:21:54 Mark Zimmerman wrote:
> On Mon, Jul 27, 2009 at 08:50:20PM +0300, Igor M. Liplianin wrote:
> > On 27 ???? 2009 04:43:16 Mark Zimmerman wrote:
> > > On Sun, Jul 26, 2009 at 03:29:13PM +0300, Igor M. Liplianin wrote:
> > > > On 25 ???? 2009 05:22:06 Mark Zimmerman wrote:
> > > > > On Fri, Jul 24, 2009 at 07:06:11PM +0300, Igor M. Liplianin wrote:
> > > > > > On 24 ???? 2009 05:33:15 Mark Zimmerman wrote:
> > > > > > > Greetings:
> > > > > > >
> > > > > > > Using current current v4l-dvb drivers, I get the following in
> > > > > > > the dmesg:
> > > > > > >
> > > > > > > cx88[1]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2
> > > > > > > [card=3D72] cx88[1]/2: cx2388x based DVB/ATSC card
> > > > > > > cx8802_alloc_frontends() allocating 1 frontend(s)
> > > > > > > cx24116_readreg: reg=3D0xff (error=3D-6)
> > > > > > > cx24116_readreg: reg=3D0xfe (error=3D-6)
> > > > > > > Invalid probe, probably not a CX24116 device
> > > > > > > cx88[1]/2: frontend initialization failed
> > > > > > > cx88[1]/2: dvb_register failed (err =3D -22)
> > > > > > > cx88[1]/2: cx8802 probe failed, err =3D -22
> > > > > > >
> > > > > > > Does this mean that one of the chips on this card is different
> > > > > > > than expected? How can I gather useful information about this?
> > > > > >
Please try attached patch against recent v4l-dvb.
It does matter to set explicitly gpio0 value in cx88_board structure for TB=
S 8920 card.

Igor



--Boundary-00=_euMcKbfXSwhDCAm
Content-Type: text/x-patch;
  charset="KOI8-R";
  name="12346.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="12346.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1248905908 -10800
# Node ID d2dee95e2da26a145cca2d081be86793cc9b07ea
# Parent  ee6cf88cb5d3faf861289fce0ef0385846adcc7c
fix TBS 8920 card support

diff -r ee6cf88cb5d3 -r d2dee95e2da2 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Wed Jul 29 01:42:02 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Thu Jul 30 01:18:28 2009 +0300
@@ -1941,7 +1941,8 @@
 		.radio_addr     = ADDR_UNSET,
 		.input          = {{
 			.type   = CX88_VMUX_DVB,
-			.vmux   = 1,
+			.vmux   = 0,
+			.gpio0  = 0x8080,
 		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
@@ -3187,7 +3188,11 @@
 	case  CX88_BOARD_PROF_6200:
 	case  CX88_BOARD_PROF_7300:
 	case  CX88_BOARD_SATTRADE_ST4200:
+		cx_write(MO_GP0_IO, 0x8000);
+		msleep(100);
 		cx_write(MO_SRST_IO, 0);
+		msleep(10);
+		cx_write(MO_GP0_IO, 0x8080);
 		msleep(100);
 		cx_write(MO_SRST_IO, 1);
 		msleep(100);
diff -r ee6cf88cb5d3 -r d2dee95e2da2 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Wed Jul 29 01:42:02 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Thu Jul 30 01:18:28 2009 +0300
@@ -425,17 +425,16 @@
 	struct cx8802_dev *dev= fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
+	cx_set(MO_GP0_IO, 0x6040);
 	switch (voltage) {
 		case SEC_VOLTAGE_13:
-			printk("LNB Voltage SEC_VOLTAGE_13\n");
-			cx_write(MO_GP0_IO, 0x00006040);
+			cx_clear(MO_GP0_IO, 0x20);
 			break;
 		case SEC_VOLTAGE_18:
-			printk("LNB Voltage SEC_VOLTAGE_18\n");
-			cx_write(MO_GP0_IO, 0x00006060);
+			cx_set(MO_GP0_IO, 0x20);
 			break;
 		case SEC_VOLTAGE_OFF:
-			printk("LNB Voltage SEC_VOLTAGE_off\n");
+			cx_clear(MO_GP0_IO, 0x20);
 			break;
 	}
 

--Boundary-00=_euMcKbfXSwhDCAm--
