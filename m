Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Sun, 5 Oct 2008 15:31:38 +0300
References: <200810051526.19653.liplianin@tut.by>
In-Reply-To: <200810051526.19653.liplianin@tut.by>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_qOL6IelS0/uSjAD"
Message-Id: <200810051531.38731.liplianin@tut.by>
Cc: Steven Toth <stoth@hauppauge.com>
Subject: Re: [linux-dvb] [PATCH] S2API Allow custom inittab for ST STV0288
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

--Boundary-00=_qOL6IelS0/uSjAD
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 5 October 2008 15:26:19 Igor M. Lipl=
ianin =CE=C1=D0=C9=D3=C1=CC(=C1):
> Steve,
>
> Allow custom inittab for ST STV0288 demodulator,
> as it is needed for DvbWorld USB card.
>
> Igor

Exuse me, wrong attachement.=20
Real patch to allow custom inittab for ST STV0288 demodulator.

=2D-=20
Igor M. Liplianin

--Boundary-00=_qOL6IelS0/uSjAD
Content-Type: text/x-diff;
  charset="koi8-r";
  name="9075.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="9075.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1223207538 -10800
# Node ID 8dc74aaea8b20dea5b42c32873984c2c28a8ab6e
# Parent  ecd33495acbd3a621180309ebde0d8e3476d8985
Allow custom inittab for ST STV0288 demodulator.

From: Igor M. Liplianin <liplianin@me.by>

Allow custom inittab for ST STV0288 demodulator,
as it is needed for DvbWorld USB card.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r ecd33495acbd -r 8dc74aaea8b2 linux/drivers/media/dvb/frontends/stv0288.c
--- a/linux/drivers/media/dvb/frontends/stv0288.c	Thu Oct 02 17:33:19 2008 +0300
+++ b/linux/drivers/media/dvb/frontends/stv0288.c	Sun Oct 05 14:52:18 2008 +0300
@@ -328,16 +328,28 @@
 {
 	struct stv0288_state *state = fe->demodulator_priv;
 	int i;
+	u8 reg;
+	u8 val;
 
 	dprintk("stv0288: init chip\n");
 	stv0288_writeregI(state, 0x41, 0x04);
 	msleep(50);
 
-	for (i = 0; !(stv0288_inittab[i] == 0xff &&
+	/* we have default inittab */
+	if (state->config->inittab == NULL) {
+		for (i = 0; !(stv0288_inittab[i] == 0xff &&
 				stv0288_inittab[i + 1] == 0xff); i += 2)
-		stv0288_writeregI(state, stv0288_inittab[i],
-						stv0288_inittab[i + 1]);
-
+			stv0288_writeregI(state, stv0288_inittab[i],
+					stv0288_inittab[i + 1]);
+	} else {
+		for (i = 0; ; i += 2)  {
+			reg = state->config->inittab[i];
+			val = state->config->inittab[i+1];
+			if (reg == 0xff && val == 0xff)
+				break;
+			stv0288_writeregI(state, reg, val);
+		}
+	}
 	return 0;
 }
 
diff -r ecd33495acbd -r 8dc74aaea8b2 linux/drivers/media/dvb/frontends/stv0288.h
--- a/linux/drivers/media/dvb/frontends/stv0288.h	Thu Oct 02 17:33:19 2008 +0300
+++ b/linux/drivers/media/dvb/frontends/stv0288.h	Sun Oct 05 14:52:18 2008 +0300
@@ -34,6 +34,8 @@
 	/* the demodulator's i2c address */
 	u8 demod_address;
 
+	u8* inittab;
+
 	/* minimum delay before retuning */
 	int min_delay_ms;
 

--Boundary-00=_qOL6IelS0/uSjAD
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_qOL6IelS0/uSjAD--
