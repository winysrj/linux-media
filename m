Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
To: linux-dvb@linuxtv.org, Steven Toth <stoth@linuxtv.org>,
	Steven Toth <stoth@hauppauge.com>
From: "Igor M. Liplianin" <liplianin@tut.by>
Date: Sun, 5 Oct 2008 15:28:57 +0300
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JML6IQ3tQMj1+/s"
Message-Id: <200810051528.57446.liplianin@tut.by>
Subject: [linux-dvb] [PATCH] S2API  Remove NULL pointer in stb6000 driver.
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

--Boundary-00=_JML6IQ3tQMj1+/s
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Steve,

Remove NULL pointer in stb6000 driver,
as it raises error for DvbWorld USB card.

Igor

--Boundary-00=_JML6IQ3tQMj1+/s
Content-Type: text/x-diff;
  charset="koi8-r";
  name="9076.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="9076.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1223207831 -10800
# Node ID 4b968f970a42a266179113bb3280250e42ccd2f3
# Parent  8dc74aaea8b20dea5b42c32873984c2c28a8ab6e
Remove NULL pointer in stb6000 driver.

From: Igor M. Liplianin <liplianin@me.by>

Remove NULL pointer in stb6000 driver,
as it raises error for DvbWorld USB card.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 8dc74aaea8b2 -r 4b968f970a42 linux/drivers/media/dvb/frontends/stb6000.c
--- a/linux/drivers/media/dvb/frontends/stb6000.c	Sun Oct 05 14:52:18 2008 +0300
+++ b/linux/drivers/media/dvb/frontends/stb6000.c	Sun Oct 05 14:57:11 2008 +0300
@@ -202,12 +202,13 @@
 						struct i2c_adapter *i2c)
 {
 	struct stb6000_priv *priv = NULL;
+	u8 b0[] = { 0 };
 	u8 b1[] = { 0, 0 };
 	struct i2c_msg msg[2] = {
 		{
 			.addr = addr,
 			.flags = 0,
-			.buf = NULL,
+			.buf = b0,
 			.len = 0
 		}, {
 			.addr = addr,

--Boundary-00=_JML6IQ3tQMj1+/s
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_JML6IQ3tQMj1+/s--
