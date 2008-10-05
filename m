Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
To: linux-dvb@linuxtv.org, Steven Toth <stoth@linuxtv.org>,
	Steven Toth <stoth@hauppauge.com>
From: "Igor M. Liplianin" <liplianin@tut.by>
Date: Sun, 5 Oct 2008 15:26:19 +0300
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rJL6I2z0Fzw/yji"
Message-Id: <200810051526.19653.liplianin@tut.by>
Subject: [linux-dvb] [PATCH] S2API Allow custom inittab for ST STV0288
	demodulator.
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

--Boundary-00=_rJL6I2z0Fzw/yji
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Steve,

Allow custom inittab for ST STV0288 demodulator,
as it is needed for DvbWorld USB card.

Igor

--Boundary-00=_rJL6I2z0Fzw/yji
Content-Type: text/x-diff;
  charset="koi8-r";
  name="9036.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="9036.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1222957999 -10800
# Node ID 63aceadbc87a5ae27c68c5e5698b327757aaf5f5
# Parent  c6088a57a2714ba67a6e7c88d449d05d60053e91
Makefile fix for ST STV0288 demodulator.

From: Igor M. Liplianin <liplianin@me.by>

Makefile fix for ST STV0288 demodulator.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r c6088a57a271 -r 63aceadbc87a linux/drivers/media/dvb/frontends/Makefile
--- a/linux/drivers/media/dvb/frontends/Makefile	Thu Sep 25 23:29:49 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/Makefile	Thu Oct 02 17:33:19 2008 +0300
@@ -53,5 +53,5 @@
 obj-$(CONFIG_DVB_AF9013) += af9013.o
 obj-$(CONFIG_DVB_CX24116) += cx24116.o
 obj-$(CONFIG_DVB_SI21XX) += si21xx.o
-obj-$(CONFIG_DVB_STV0299) += stv0288.o
+obj-$(CONFIG_DVB_STV0288) += stv0288.o
 obj-$(CONFIG_DVB_STB6000) += stb6000.o

--Boundary-00=_rJL6I2z0Fzw/yji
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_rJL6I2z0Fzw/yji--
