Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <plr.vincent@gmail.com>) id 1KzATg-0006iC-Ct
	for linux-dvb@linuxtv.org; Sun, 09 Nov 2008 14:37:21 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1816690fga.25
	for <linux-dvb@linuxtv.org>; Sun, 09 Nov 2008 05:37:16 -0800 (PST)
To: linux-dvb@linuxtv.org
From: Vincent Pelletier <plr.vincent@gmail.com>
Date: Sun, 9 Nov 2008 14:37:13 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JeuFJHeWHvgVM4i"
Message-Id: <200811091437.13920.plr.vincent@gmail.com>
Cc: khali@linux-fr.org
Subject: [linux-dvb] [PATCH] WinFast DTV2000 H: add support for missing
	analog inputs
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

--Boundary-00=_JeuFJHeWHvgVM4i
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

WinFast DTV2000 H: add support for missing analog inputs

From: Vincent Pelletier <plr.vincent@gmail.com>

Add support for the following inputs:
 - radio tuner
 - composite 1 & 2 (only 1 is physically available, but composite 2 is also
   advertised by windows driver)
 - svideo

Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>

---

GPIO values retrieved using RegSpy under Windows XP with vendor's driver & 
software.

-- 
Vincent Pelletier

--Boundary-00=_JeuFJHeWHvgVM4i
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="cx88-cards.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cx88-cards.c.diff"

diff -r 46604f47fca1 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Fri Nov 07 15:24:18 2008 -0200
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Sun Nov 09 14:31:26 2008 +0100
@@ -1270,7 +1270,6 @@
 		},
 	},
 	[CX88_BOARD_WINFAST_DTV2000H] = {
-		/* video inputs and radio still in testing */
 		.name           = "WinFast DTV2000 H",
 		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
 		.radio_type     = UNSET,
@@ -1284,7 +1283,35 @@
 			.gpio1  = 0x00008203,
 			.gpio2  = 0x00017304,
 			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x0001d701,
+			.gpio1  = 0x0000b207,
+			.gpio2  = 0x0001d701,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_COMPOSITE2,
+			.vmux   = 2,
+			.gpio0  = 0x0001d503,
+			.gpio1  = 0x0000b207,
+			.gpio2  = 0x0001d503,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 3,
+			.gpio0  = 0x0001d701,
+			.gpio1  = 0x0000b207,
+			.gpio2  = 0x0001d701,
+			.gpio3  = 0x02000000,
 		}},
+		.radio = {
+			 .type  = CX88_RADIO,
+			 .gpio0 = 0x00015702,
+			 .gpio1 = 0x0000f207,
+			 .gpio2 = 0x00015702,
+			 .gpio3 = 0x02000000,
+		},
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_GENIATECH_DVBS] = {

--Boundary-00=_JeuFJHeWHvgVM4i
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_JeuFJHeWHvgVM4i--
