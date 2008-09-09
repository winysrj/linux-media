Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Tue, 9 Sep 2008 17:50:37 +0300
References: <48BF6A09.3020205@linuxtv.org> <48C539D9.4080900@linuxtv.org>
	<200809082334.04511.liplianin@tut.by>
In-Reply-To: <200809082334.04511.liplianin@tut.by>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_+0oxIVi37rwLmyc"
Message-Id: <200809091750.38009.liplianin@tut.by>
Subject: Re: [linux-dvb] [PATCH] S2 - DVBWorld 2104, TeVii S650
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

--Boundary-00=_+0oxIVi37rwLmyc
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 8 September 2008 23:34:04 Igor M. Li=
plianin =CE=C1=D0=C9=D3=C1=CC(=C1):
> Patch for DVBWorld 2104, TeVii S650 cx24116 based cards.

Additionally change Kconfig for DvbWorld cards.

=2D-=20
Igor M. Liplianin

--Boundary-00=_+0oxIVi37rwLmyc
Content-Type: text/x-diff;
  charset="koi8-r";
  name="8865.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8865.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1220970583 -10800
# Node ID 94185acebf5c72f507eaca24d1e77cf9fc9cba9a
# Parent  e002e5deabad4f8993f5ab9aba79a3fd1f154491
Kconfig corrections for DVBWorld 2104 and TeVii S650 USB DVB-S2 cards

From: Igor M. Liplianin <liplianin@me.by>

Change menu item in Kconfig for DVBWorld 2104 and TeVii S650 USB DVB-S2 cards

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r e002e5deabad -r 94185acebf5c linux/drivers/media/dvb/dvb-usb/Kconfig
--- a/linux/drivers/media/dvb/dvb-usb/Kconfig	Mon Sep 08 23:16:40 2008 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/Kconfig	Tue Sep 09 17:29:43 2008 +0300
@@ -247,12 +247,14 @@
 	  Afatech AF9005 based receiver.
 
 config DVB_USB_DW2102
-	tristate "DvbWorld 2102 DVB-S USB2.0 receiver"
+	tristate "DvbWorld DVB-S/S2 USB2.0 support"
 	depends on DVB_USB
+	select DVB_PLL if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
-	select DVB_PLL if !DVB_FE_CUSTOMISE
+	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	help
-	   Say Y here to support the DvbWorld 2102 DVB-S USB2.0 receiver.
+	  Say Y here to support the DvbWorld DVB-S/S2 USB2.0 receivers
+	  and the TeVii S650.
 
 config DVB_USB_ANYSEE
 	tristate "Anysee DVB-T/C USB2.0 support"

--Boundary-00=_+0oxIVi37rwLmyc
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_+0oxIVi37rwLmyc--
