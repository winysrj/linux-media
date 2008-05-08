Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m48LUqbu003318
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 17:30:52 -0400
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m48LUejP025748
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 17:30:40 -0400
Received: from smtp5-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 769DA3F62B8
	for <video4linux-list@redhat.com>;
	Thu,  8 May 2008 23:30:39 +0200 (CEST)
Received: from mediacenter.localdomain (lns-bzn-20-82-64-17-49.adsl.proxad.net
	[82.64.17.49])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 045AA3F62AF
	for <video4linux-list@redhat.com>;
	Thu,  8 May 2008 23:30:38 +0200 (CEST)
Message-ID: <482370FD.7000001@users.sourceforge.net>
Date: Thu, 08 May 2008 23:30:37 +0200
From: Andre Auzi <aauzi@users.sourceforge.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: cx88 driver: Help needed to add radio support on Leadtek WINFAST
 DTV 2000 H (version J)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello list,

I've started the task to add support of the board mentionned above.

So far I've got analog TV, Composite and Svideo inputs working OK with 
IR as well.

Unfortunately, my area does not have DVB-T yet, but from the scans I've 
made, I'm confident DVB support is on good tracks.

Nevertheless, I cannot achieve to have the radio input working.

The gpio values were captured with regspy on a working windows installation.

Here are my additions in cx88-cards.c:

diff -r 0a072dd11cd8 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c    Wed May 07 15:42:54 
2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c    Thu May 08 23:07:36 
2008 +0200
@@ -1300,6 +1300,52 @@
         }},
         .mpeg           = CX88_MPEG_DVB,
     },
+    [CX88_BOARD_WINFAST_DTV2000H_VERSION_J] = {
+        /* Radio still in testing */
+        .name           = "WinFast DTV2000 H (version J)",
+        .tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
+        .radio_type     = UNSET,
+        .tuner_addr     = ADDR_UNSET,
+        .radio_addr     = ADDR_UNSET,
+        .tda9887_conf   = TDA9887_PRESENT,
+        .input          = {{
+            .type   = CX88_VMUX_TELEVISION,
+            .vmux   = 0,
+            .gpio0  = 0x00013700,
+            .gpio1  = 0x0000a207,
+            .gpio2  = 0x00013700,
+            .gpio3  = 0x02000000,
+        },{
+            .type   = CX88_VMUX_CABLE,
+            .vmux   = 0,
+            .gpio0  = 0x0001b700,
+            .gpio1  = 0x0000a207,
+            .gpio2  = 0x0001b700,
+            .gpio3  = 0x02000000,
+        },{
+            .type   = CX88_VMUX_COMPOSITE1,
+            .vmux   = 1,
+            .gpio0  = 0x00013701,
+            .gpio1  = 0x0000a207,
+            .gpio2  = 0x00013701,
+            .gpio3  = 0x02000000,
+        },{
+            .type   = CX88_VMUX_SVIDEO,
+            .vmux   = 2,
+            .gpio0  = 0x00013701,
+            .gpio1  = 0x0000a207,
+            .gpio2  = 0x00013701,
+            .gpio3  = 0x02000000,
+        } },
+        .radio = {
+            .type   = CX88_RADIO,
+            .gpio0  = 0x00013702,
+            .gpio1  = 0x0000a207,
+            .gpio2  = 0x00013702,
+            .gpio3  = 0x02000000,
+        },
+    },
     [CX88_BOARD_GENIATECH_DVBS] = {
         .name          = "Geniatech DVB-S",
         .tuner_type    = TUNER_ABSENT,
@@ -1957,6 +2003,10 @@
         .subdevice = 0x665e,
         .card      = CX88_BOARD_WINFAST_DTV2000H,
     },{
+        .subvendor = 0x107d,
+        .subdevice = 0x6f2b,
+        .card      = CX88_BOARD_WINFAST_DTV2000H_VERSION_J,
+    },{
         .subvendor = 0x18ac,
         .subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
         .card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,


Would there be someone in the list with cx88 driver knowledge who 
already achieved this for another board and could hint me on things to 
look for?

I kindof reached the limits of my imagination and would really 
appreciate a help.

So far my modprobe.conf reads:

options tda9887 debug=1
options cx22702 debug=1
options cx88xx i2c_debug=1 i2c_scan=1 audio_debug=1
options cx8800 video_debug=1

and I would join the dmesg output if I did not care to flood the list.

Just let me know if it could help.

Thanks in advance
Andre




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
