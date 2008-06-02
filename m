Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <plr.vincent@gmail.com>) id 1K36Pd-0005VG-LH
	for linux-dvb@linuxtv.org; Mon, 02 Jun 2008 11:33:10 +0200
Received: by fg-out-1718.google.com with SMTP id e21so742840fga.25
	for <linux-dvb@linuxtv.org>; Mon, 02 Jun 2008 02:33:05 -0700 (PDT)
From: Vincent Pelletier <plr.vincent@gmail.com>
To: linux-dvb@linuxtv.org
Date: Mon, 2 Jun 2008 11:33:00 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806021133.01194.plr.vincent@gmail.com>
Subject: [linux-dvb] [PATCH] WinFast DTV2000 H: add support for missing
	analog inputs
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

# HG changeset patch
# User plr.vincent@gmail.com
# Date 1212398724 -7200
# Node ID 78a011dfba127b593b6d01ea6a0010fcc29c94ad
# Parent  398b07fdfe79ff66a8c1bf2874de424ce29b9c78
WinFast DTV2000 H: add support for missing analog inputs

From: Vincent Pelletier <plr.vincent@gmail.com>

Add support for the following inputs:
 - radio tuner
 - composite 1 & 2 (only 1 is physicaly available, but composite 2 is also
   advertised by windows driver)
 - svideo

Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>

diff -r 398b07fdfe79 -r 78a011dfba12 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c       Wed May 28 17:55:13 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c       Mon Jun 02 11:25:24 2008 +0200
@@ -1297,7 +1297,35 @@
                        .gpio1  = 0x00008203,
                        .gpio2  = 0x00017304,
                        .gpio3  = 0x02000000,
+               },{
+                       .type   = CX88_VMUX_COMPOSITE1,
+                       .vmux   = 1,
+                       .gpio0  = 0x0001D701,
+                       .gpio1  = 0x0000B207,
+                       .gpio2  = 0x0001D701,
+                       .gpio3  = 0x02000000,
+               },{
+                       .type   = CX88_VMUX_COMPOSITE2,
+                       .vmux   = 2,
+                       .gpio0  = 0x0001D503,
+                       .gpio1  = 0x0000B207,
+                       .gpio2  = 0x0001D503,
+                       .gpio3  = 0x02000000,
+               },{
+                       .type   = CX88_VMUX_SVIDEO,
+                       .vmux   = 3,
+                       .gpio0  = 0x0001D701,
+                       .gpio1  = 0x0000B207,
+                       .gpio2  = 0x0001D701,
+                       .gpio3  = 0x02000000,
                }},
+               .radio = {
+                        .type  = CX88_RADIO,
+                        .gpio0 = 0x00015702,
+                        .gpio1 = 0x0000F207,
+                        .gpio2 = 0x00015702,
+                        .gpio3 = 0x02000000,
+               },
                .mpeg           = CX88_MPEG_DVB,
        },
        [CX88_BOARD_GENIATECH_DVBS] = {

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
