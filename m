Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <vincent.labie75@gmail.com>) id 1Ot59V-0006Y5-HP
	for linux-dvb@linuxtv.org; Tue, 07 Sep 2010 22:52:26 +0200
Received: from smtp1-g21.free.fr ([212.27.42.1])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Ot59U-0005Wz-2t; Tue, 07 Sep 2010 22:52:25 +0200
Received: from grimmy.home.org (unknown [82.230.61.207])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 544479400AF
	for <linux-dvb@linuxtv.org>; Tue,  7 Sep 2010 22:52:18 +0200 (CEST)
To: linux-dvb@linuxtv.org
From: Vincent Labie <vincent.labie75@gmail.com>
Date: Tue, 7 Sep 2010 22:52:16 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_BYqhMHtCmQdcA0x"
Message-Id: <201009072252.17004.vincent.labie75@gmail.com>
Subject: [linux-dvb] [PATCH] DVB-T NOVA-T USB stick Kernel oops patch
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_BYqhMHtCmQdcA0x
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

Hi,

During this summer, I tried to run a Hauppauge NOVA-T USB stick which used to work previously.
I tried with the Fedora13 default 2.6.33.x kernel v4l-dvb drivers and with the latest v4l-dvb cvs drivers with the same kernel oops result.

I appears that the issue come from a unaligned shared struct between the dib7000m and dib7000p driver, both struct beeing used by shared functions.
The patch to solve this issue is attached to this message (the solution is to put dismatching fields at the end of the struct).

Could someone with cvs access include this small patch in the v4l-dvb kernel and devel tree?

Thank you,
Vincent Labie



--Boundary-00=_BYqhMHtCmQdcA0x
Content-Type: text/x-patch;
  charset="utf-8";
  name="v4l-dvb-c9cb8918dcb2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="v4l-dvb-c9cb8918dcb2.diff"

diff -Naur v4l-dvb-c9cb8918dcb2.orig/linux/drivers/media/dvb/frontends/dib7000m.h v4l-dvb-c9cb8918dcb2/linux/drivers/media/dvb/frontends/dib7000m.h
--- v4l-dvb-c9cb8918dcb2.orig/linux/drivers/media/dvb/frontends/dib7000m.h	2010-06-01 17:47:42.000000000 +0200
+++ v4l-dvb-c9cb8918dcb2/linux/drivers/media/dvb/frontends/dib7000m.h	2010-08-09 00:00:34.000000000 +0200
@@ -3,17 +3,15 @@
 
 #include "dibx000_common.h"
 
+	/* 100808 VLabie: Must match the dib7000p.h struct */
 struct dib7000m_config {
-	u8 dvbt_mode;
 	u8 output_mpeg2_in_188_bytes;
 	u8 hostbus_diversity;
 	u8 tuner_is_baseband;
-	u8 mobile_mode;
 	int (*update_lna) (struct dvb_frontend *, u16 agc_global);
 
 	u8 agc_config_count;
 	struct dibx000_agc_config *agc;
-
 	struct dibx000_bandwidth_config *bw;
 
 #define DIB7000M_GPIO_DEFAULT_DIRECTIONS 0xffff
@@ -31,9 +29,11 @@
 
 	u8 quartz_direct;
 
-	u8 input_clk_is_div_2;
-
 	int (*agc_control) (struct dvb_frontend *, u8 before);
+
+	u8 input_clk_is_div_2;
+	u8 mobile_mode;
+	u8 dvbt_mode;
 };
 
 #define DEFAULT_DIB7000M_I2C_ADDRESS 18
diff -Naur v4l-dvb-c9cb8918dcb2.orig/linux/drivers/media/dvb/frontends/dib7000p.h v4l-dvb-c9cb8918dcb2/linux/drivers/media/dvb/frontends/dib7000p.h
--- v4l-dvb-c9cb8918dcb2.orig/linux/drivers/media/dvb/frontends/dib7000p.h	2010-06-01 17:47:42.000000000 +0200
+++ v4l-dvb-c9cb8918dcb2/linux/drivers/media/dvb/frontends/dib7000p.h	2010-08-09 00:00:18.000000000 +0200
@@ -3,6 +3,7 @@
 
 #include "dibx000_common.h"
 
+	/* 100808 VLabie: Must match the dib7000m.h struct */
 struct dib7000p_config {
 	u8 output_mpeg2_in_188_bytes;
 	u8 hostbus_diversity;
@@ -28,11 +29,11 @@
 
 	u8 quartz_direct;
 
-	u8 spur_protect;
-
 	int (*agc_control) (struct dvb_frontend *, u8 before);
 
+	u8 spur_protect;
 	u8 output_mode;
+	u8 pad;
 };
 
 #define DEFAULT_DIB7000P_I2C_ADDRESS 18

--Boundary-00=_BYqhMHtCmQdcA0x
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_BYqhMHtCmQdcA0x--
