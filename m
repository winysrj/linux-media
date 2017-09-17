Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38103 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbdIQVmV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 17:42:21 -0400
Message-ID: <59BEEC39.2030609@googlemail.com>
Date: Sun, 17 Sep 2017 22:42:17 +0100
From: Nigel Kettlewell <nigel.kettlewell@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Support HVR-1200 analog video as a clone of HVR-1500. Tested,
 composite and s-video inputs.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I propose the following patch to support Hauppauge HVR-1200 analog 
video, nothing more than a clone of HVR-1500. Patch based on Linux 4.9 
commit 69973b830859bc6529a7a0468ba0d80ee5117826

I have tested composite and S-Video inputs.

With the change, HVR-1200 devices have a /dev/video<n> entry which is 
accessible in the normal way.

Let me know if you need anything more.

Nigel Kettlewell



---
  drivers/media/pci/cx23885/cx23885-cards.c | 24 ++++++++++++++++++++++++
  1 file changed, 24 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c 
b/drivers/media/pci/cx23885/cx23885-cards.c
index 99ba8d6..5be38f1 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -195,7 +195,30 @@ struct cx23885_board cx23885_boards[] = {
         },
         [CX23885_BOARD_HAUPPAUGE_HVR1200] = {
                 .name           = "Hauppauge WinTV-HVR1200",
+               .porta          = CX23885_ANALOG_VIDEO,
                 .portc          = CX23885_MPEG_DVB,
+               .tuner_type     = TUNER_XC2028,
+               .tuner_addr     = 0x61, /* 0xc2 >> 1 */
+               .input          = {{
+                       .type   = CX23885_VMUX_TELEVISION,
+                       .vmux   =       CX25840_VIN7_CH3 |
+                                       CX25840_VIN5_CH2 |
+                                       CX25840_VIN2_CH1,
+                       .gpio0  = 0,
+               }, {
+                       .type   = CX23885_VMUX_COMPOSITE1,
+                       .vmux   =       CX25840_VIN7_CH3 |
+                                       CX25840_VIN4_CH2 |
+                                       CX25840_VIN6_CH1,
+                       .gpio0  = 0,
+               }, {
+                       .type   = CX23885_VMUX_SVIDEO,
+                       .vmux   =       CX25840_VIN7_CH3 |
+                                       CX25840_VIN4_CH2 |
+                                       CX25840_VIN8_CH1 |
+                                       CX25840_SVIDEO_ON,
+                       .gpio0  = 0,
+               } },
         },
         [CX23885_BOARD_HAUPPAUGE_HVR1700] = {
                 .name           = "Hauppauge WinTV-HVR1700",
@@ -2262,6 +2285,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
         case CX23885_BOARD_HAUPPAUGE_HVR1290:
         case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
         case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
+       case CX23885_BOARD_HAUPPAUGE_HVR1200:
         case CX23885_BOARD_HAUPPAUGE_HVR1500:
         case CX23885_BOARD_MPX885:
         case CX23885_BOARD_MYGICA_X8507:
--
2.9.4
