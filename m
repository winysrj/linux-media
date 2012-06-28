Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59335 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2F1V30 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 17:29:26 -0400
Received: by pbbrp8 with SMTP id rp8so3558258pbb.19
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 14:29:26 -0700 (PDT)
Message-ID: <4FECCCB4.9000402@gmail.com>
Date: Thu, 28 Jun 2012 14:29:24 -0700
From: Mack Stanley <mcs1937@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH 1/1] Add support for newer PCTV 800i cards with s5h1411 demodulators
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Testing is needed on older (aka Pinnacle) PCTV 800i cards with S5H1409
demodulators
to check that current support for them isn't broken by this patch.

Signed-off-by: Mack Stanley <mcs1937@gmail.com>
---
 drivers/media/video/cx88/cx88-dvb.c |   40
++++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-dvb.c
b/drivers/media/video/cx88/cx88-dvb.c
index 003937c..6d49672 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -501,7 +501,7 @@ static const struct cx24123_config
kworld_dvbs_100_config = {
        .lnb_polarity  = 1,
 };

-static const struct s5h1409_config pinnacle_pctv_hd_800i_config = {
+static const struct s5h1409_config pinnacle_pctv_hd_800i_s5h1409_config = {
        .demod_address = 0x32 >> 1,
        .output_mode   = S5H1409_PARALLEL_OUTPUT,
        .gpio          = S5H1409_GPIO_ON,
@@ -509,7 +509,7 @@ static const struct s5h1409_config
pinnacle_pctv_hd_800i_config = {
        .inversion     = S5H1409_INVERSION_OFF,
        .status_mode   = S5H1409_DEMODLOCKING,
        .mpeg_timing   = S5H1409_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK,
-};
+};

 static const struct s5h1409_config dvico_hdtv5_pci_nano_config = {
        .demod_address = 0x32 >> 1,
@@ -556,6 +556,16 @@ static const struct s5h1411_config
dvico_fusionhdtv7_config = {
        .status_mode   = S5H1411_DEMODLOCKING
 };

+static const struct s5h1411_config pinnacle_pctv_hd_800i_s5h1411_config = {
+       .output_mode   = S5H1411_PARALLEL_OUTPUT,
+       .gpio          = S5H1411_GPIO_ON,
+       .mpeg_timing   = S5H1411_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK,
+       .qam_if        = S5H1411_IF_44000,
+       .vsb_if        = S5H1411_IF_44000,
+       .inversion     = S5H1411_INVERSION_OFF,
+       .status_mode   = S5H1411_DEMODLOCKING
+};
+
 static const struct xc5000_config dvico_fusionhdtv7_tuner_config = {
        .i2c_address    = 0xc2 >> 1,
        .if_khz         = 5380,
@@ -1297,16 +1307,22 @@ static int dvb_register(struct cx8802_dev *dev)
                }
                break;
        case CX88_BOARD_PINNACLE_PCTV_HD_800i:
-               fe0->dvb.frontend = dvb_attach(s5h1409_attach,
-                                             
&pinnacle_pctv_hd_800i_config,
-                                              &core->i2c_adap);
-               if (fe0->dvb.frontend != NULL) {
-                       if (!dvb_attach(xc5000_attach, fe0->dvb.frontend,
-                                       &core->i2c_adap,
-                                      
&pinnacle_pctv_hd_800i_tuner_config))
-                               goto frontend_detach;
-               }
-               break;
+               /* Try s5h1409 chip first */
+               fe0->dvb.frontend = dvb_attach(s5h1409_attach,
+                                      
&pinnacle_pctv_hd_800i_s5h1409_config,
+                                       &core->i2c_adap);
+               /* Otherwise, try s5h1411 */
+               if (fe0->dvb.frontend == NULL)
+                       fe0->dvb.frontend = dvb_attach(s5h1411_attach,
+                                      
&pinnacle_pctv_hd_800i_s5h1411_config,
+                                       &core->i2c_adap);
+               if (fe0->dvb.frontend != NULL) {
+                       if (!dvb_attach(xc5000_attach, fe0->dvb.frontend,
+                                       &core->i2c_adap,
+                                      
&pinnacle_pctv_hd_800i_tuner_config))
+                               goto frontend_detach;
+               }
+               break;
        case CX88_BOARD_DVICO_FUSIONHDTV_5_PCI_NANO:
                fe0->dvb.frontend = dvb_attach(s5h1409_attach,
                                               
&dvico_hdtv5_pci_nano_config,
--
1.7.7.6


