Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: Steven Toth <stoth@linuxtv.org>
Date: Sun, 14 Sep 2008 03:10:45 +0300
References: <E1KdnPr-0002YP-SF@www.linuxtv.org>
	<200809140119.38052.liplianin@tut.by>
	<48CC3F3B.3050600@linuxtv.org>
In-Reply-To: <48CC3F3B.3050600@linuxtv.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FaFzIiM7MKLNU7t"
Message-Id: <200809140310.45830.liplianin@tut.by>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] S2API: Add support for DvbWorld 2004 DVB-S2
	PCI card
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

--Boundary-00=_FaFzIiM7MKLNU7t
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 14 September 2008 01:31:23 Steven To=
th =CE=C1=D0=C9=D3=C1=CC(=C1):
> Igor M. Liplianin wrote:
> > =F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 13 September 2008 23:39:46 Steve=
n Toth =CE=C1=D0=C9=D3=C1=CC(=C1):
> >> Igor M. Liplianin wrote:
> >>> The patch adds support for SDMC DM1105 PCI chip. There is a lot of
> >>> cards based on it, like DvbWorld 2002 DVB-S , 2004 DVB-S2
> >>> Source code prepaired to and already tested with cards, which have
> >>> si2109, stv0288, cx24116 demods.  Currently enabled only stv0299, as
> >>> other demods are not in a v4l-dvb main tree, but I will submit
> >>> corresponded patches (si2109, stv0288) next time.
> >>
> >> Igor,
> >>
> >> Cool.
> >>
> >> Master repo does not have cx24116 support so it probably cannot be
> >> merged. Do you need me to merge this into the s2api tree?
> >
> > Steve,
> >
> > It would be great !
> > Patch is ready to s2api tree.
> >
> > So I must prepair next patch, which enables DvbWorld 2004 DVB-S2.
>
> Merged, thanks Igor.
>
> I also have a large cx24116.c patch from Darron pending, I need his
> sign-off. Hopefully this will go into the tree tonight also.
>
Steven,

Send you patch to support for DvbWorld 2004 DVB-S2 PCI card.

Igor

--Boundary-00=_FaFzIiM7MKLNU7t
Content-Type: text/x-diff;
  charset="koi8-r";
  name="8881.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8881.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1221350219 -10800
# Node ID db58ae2b2a1bfe8482b33b8b0b467ce1dbb8dd72
# Parent  1588831f0053100fb0464428516bef9f27748aa5
Add support for DvbWorld 2004 DVB-S2 PCI adapter

From: Igor M. Liplianin <liplianin@me.by>

Add support for DvbWorld 2004 DVB-S2 PCI adapter.
The card contains dm1105 PCI chip and cx24116 demodulator

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 1588831f0053 -r db58ae2b2a1b linux/drivers/media/dvb/Kconfig
--- a/linux/drivers/media/dvb/Kconfig	Sat Sep 13 16:10:53 2008 +0300
+++ b/linux/drivers/media/dvb/Kconfig	Sun Sep 14 02:56:59 2008 +0300
@@ -36,7 +36,7 @@
 source "drivers/media/dvb/pluto2/Kconfig"
 
 comment "Supported SDMC DM1105 Adapters"
-        depends on DVB_CORE && PCI && I2C
+	depends on DVB_CORE && PCI && I2C
 source "drivers/media/dvb/dm1105/Kconfig"
 
 comment "Supported DVB Frontends"
diff -r 1588831f0053 -r db58ae2b2a1b linux/drivers/media/dvb/dm1105/Kconfig
--- a/linux/drivers/media/dvb/dm1105/Kconfig	Sat Sep 13 16:10:53 2008 +0300
+++ b/linux/drivers/media/dvb/dm1105/Kconfig	Sun Sep 14 02:56:59 2008 +0300
@@ -1,14 +1,15 @@
 config DVB_DM1105
-        tristate "SDMC DM1105 based PCI cards"
-        depends on DVB_CORE && PCI && I2C
+	tristate "SDMC DM1105 based PCI cards"
+	depends on DVB_CORE && PCI && I2C
 	select DVB_PLL if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-        help
-          Support for cards based on the SDMC DM1105 PCI chip like
-          DvbWorld 2002
+	select DVB_CX24116 if !DVB_FE_CUSTOMISE
+	help
+	  Support for cards based on the SDMC DM1105 PCI chip like
+	  DvbWorld 2002
 
-          Since these cards have no MPEG decoder onboard, they transmit
-          only compressed MPEG data over the PCI bus, so you need
-          an external software decoder to watch TV on your computer.
+	  Since these cards have no MPEG decoder onboard, they transmit
+	  only compressed MPEG data over the PCI bus, so you need
+	  an external software decoder to watch TV on your computer.
 
-          Say Y or M if you own such a device and want to use it.
+	  Say Y or M if you own such a device and want to use it.
diff -r 1588831f0053 -r db58ae2b2a1b linux/drivers/media/dvb/dm1105/dm1105.c
--- a/linux/drivers/media/dvb/dm1105/dm1105.c	Sat Sep 13 16:10:53 2008 +0300
+++ b/linux/drivers/media/dvb/dm1105/dm1105.c	Sun Sep 14 02:56:59 2008 +0300
@@ -41,8 +41,8 @@
 #include "stv0299.h"
 /*#include "stv0288.h"
  *#include "si21xx.h"
- *#include "stb6000.h"
- *#include "cx24116.h"*/
+ *#include "stb6000.h"*/
+#include "cx24116.h"
 #include "z0194a.h"
 
 /* ----------------------------------------------- */
@@ -613,11 +613,11 @@
 	.min_delay_ms = 100,
 
 };
+#endif /* keep */
 
 static struct cx24116_config serit_sp2633_config = {
 	.demod_address = 0x55,
 };
-#endif /* keep */
 
 static int __devinit frontend_init(struct dm1105dvb *dm1105dvb)
 {
@@ -659,15 +659,11 @@
 #endif /* keep */
 		break;
 	case PCI_DEVICE_ID_DW2004:
-#if 0 /* keep */
 		dm1105dvb->fe = dvb_attach(
 			cx24116_attach, &serit_sp2633_config,
 			&dm1105dvb->i2c_adap);
 		if (dm1105dvb->fe)
 			dm1105dvb->fe->ops.set_voltage = dm1105dvb_set_voltage;
-#else /* keep */
-		dev_err(&dm1105dvb->pdev->dev, "needs cx24116 module\n");
-#endif /* keep */
 		break;
 	}
 

--Boundary-00=_FaFzIiM7MKLNU7t
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_FaFzIiM7MKLNU7t--
