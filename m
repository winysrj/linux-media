Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org, Steven Toth <stoth@hauppauge.com>,
	Steven Toth <stoth@linuxtv.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>
Date: Thu, 25 Sep 2008 05:30:37 +0300
References: <48CA0355.6080903@linuxtv.org>
	<200809170037.59770.liplianin@tut.by>
	<200809232201.06863.liplianin@tut.by>
In-Reply-To: <200809232201.06863.liplianin@tut.by>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Ofv2IvsKAP7IZ8i"
Message-Id: <200809250530.38075.liplianin@tut.by>
Subject: [linux-dvb] [PATCH] S2API - Kconfig dependency fixes for cards with
	stv0288 and si21xx.
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

--Boundary-00=_Ofv2IvsKAP7IZ8i
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Patches for Kconfig dependencies for cards with stv0288 and si21xx.

Thanks to Patrick for paying attention.

Igor

--Boundary-00=_Ofv2IvsKAP7IZ8i
Content-Type: text/x-diff;
  charset="koi8-r";
  name="8897.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8897.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1222307333 -10800
# Node ID 8de73c0adc5dee549fd7f9d34f80a2ee40ae347e
# Parent  70b18ec9535dc884fb0e9ff9456aa4f79df14921
Kconfig correction for USB card modification with SI2109/2110 demodulator.

From: Igor M. Liplianin <liplianin@me.by>

Kconfig correction for USB card modification with SI2109/2110 demodulator.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 70b18ec9535d -r 8de73c0adc5d linux/drivers/media/dvb/dvb-usb/Kconfig
--- a/linux/drivers/media/dvb/dvb-usb/Kconfig	Tue Sep 23 21:43:57 2008 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/Kconfig	Thu Sep 25 04:48:53 2008 +0300
@@ -252,6 +252,7 @@
 	select DVB_PLL if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
+	select DVB_SI21XX if !DVB_FE_CUSTOMISE
 	help
 	  Say Y here to support the DvbWorld DVB-S/S2 USB2.0 receivers
 	  and the TeVii S650.

--Boundary-00=_Ofv2IvsKAP7IZ8i
Content-Type: text/x-diff;
  charset="koi8-r";
  name="8898.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8898.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1222309107 -10800
# Node ID 5a8329f6c66c8c9a8852245f473ca577a92c602f
# Parent  8de73c0adc5dee549fd7f9d34f80a2ee40ae347e
Kconfig dependency fix for DW2002 card with ST STV0288 demodulator.

From: Igor M. Liplianin <liplianin@me.by>

Kconfig dependency fix for DW2002 card with ST STV0288 demodulator.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 8de73c0adc5d -r 5a8329f6c66c linux/drivers/media/dvb/dm1105/Kconfig
--- a/linux/drivers/media/dvb/dm1105/Kconfig	Thu Sep 25 04:48:53 2008 +0300
+++ b/linux/drivers/media/dvb/dm1105/Kconfig	Thu Sep 25 05:18:27 2008 +0300
@@ -3,6 +3,8 @@
 	depends on DVB_CORE && PCI && I2C
 	select DVB_PLL if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
+	select DVB_STV0288 if !DVB_FE_CUSTOMISE
+	select DVB_STB6000 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
 	help

--Boundary-00=_Ofv2IvsKAP7IZ8i
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_Ofv2IvsKAP7IZ8i--
