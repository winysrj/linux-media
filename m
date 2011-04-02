Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:35982 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab1DBJmX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 05:42:23 -0400
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v16 06/13] davinci vpbe: Readme text for Dm6446 vpbe
Date: Sat,  2 Apr 2011 15:12:14 +0530
Message-Id: <1301737334-4238-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Please refer to this file for detailed documentation of
davinci vpbe v4l2 driver.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 Documentation/video4linux/README.davinci-vpbe |   93 +++++++++++++++++++++++++
 1 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/README.davinci-vpbe

diff --git a/Documentation/video4linux/README.davinci-vpbe b/Documentation/video4linux/README.davinci-vpbe
new file mode 100644
index 0000000..7a460b0
--- /dev/null
+++ b/Documentation/video4linux/README.davinci-vpbe
@@ -0,0 +1,93 @@
+
+                VPBE V4L2 driver design
+ ======================================================================
+
+ File partitioning
+ -----------------
+ V4L2 display device driver
+         drivers/media/video/davinci/vpbe_display.c
+         drivers/media/video/davinci/vpbe_display.h
+
+ VPBE display controller
+         drivers/media/video/davinci/vpbe.c
+         drivers/media/video/davinci/vpbe.h
+
+ VPBE venc sub device driver
+         drivers/media/video/davinci/vpbe_venc.c
+         drivers/media/video/davinci/vpbe_venc.h
+         drivers/media/video/davinci/vpbe_venc_regs.h
+
+ VPBE osd driver
+         drivers/media/video/davinci/vpbe_osd.c
+         drivers/media/video/davinci/vpbe_osd.h
+         drivers/media/video/davinci/vpbe_osd_regs.h
+
+ Functional partitioning
+ -----------------------
+
+ Consists of the following (in the same order as the list under file
+ partitioning):-
+
+ 1. V4L2 display driver
+    Implements creation of video2 and video3 device nodes and
+    provides v4l2 device interface to manage VID0 and VID1 layers.
+
+ 2. Display controller
+    Loads up VENC, OSD and external encoders such as ths8200. It provides
+    a set of API calls to V4L2 drivers to set the output/standards
+    in the VENC or external sub devices. It also provides
+    a device object to access the services from OSD subdevice
+    using sub device ops. The connection of external encoders to VENC LCD
+    controller port is done at init time based on default output and standard
+    selection or at run time when application change the output through
+    V4L2 IOCTLs.
+
+    When connected to an external encoder, vpbe controller is also responsible
+    for setting up the interface between VENC and external encoders based on
+    board specific settings (specified in board-xxx-evm.c). This allows
+    interfacing external encoders such as ths8200. The setup_if_config()
+    is implemented for this as well as configure_venc() (part of the next patch)
+    API to set timings in VENC for a specific display resolution. As of this
+    patch series, the interconnection and enabling and setting of the external
+    encoders is not present, and would be a part of the next patch series.
+
+ 3. VENC subdevice module
+    Responsible for setting outputs provided through internal DACs and also
+    setting timings at LCD controller port when external encoders are connected
+    at the port or LCD panel timings required. When external encoder/LCD panel
+    is connected, the timings for a specific standard/preset is retrieved from
+    the board specific table and the values are used to set the timings in
+    venc using non-standard timing mode.
+
+    Support LCD Panel displays using the VENC. For example to support a Logic
+    PD display, it requires setting up the LCD controller port with a set of
+    timings for the resolution supported and setting the dot clock. So we could
+    add the available outputs as a board specific entry (i.e add the "LogicPD"
+    output name to board-xxx-evm.c). A table of timings for various LCDs
+    supported can be maintained in the board specific setup file to support
+    various LCD displays.As of this patch a basic driver is present, and this
+    support for external encoders and displays forms a part of the next
+    patch series.
+
+ 4. OSD module
+    OSD module implements all OSD layer management and hardware specific
+    features. The VPBE module interacts with the OSD for enabling and
+    disabling appropriate features of the OSD.
+
+ Current status:-
+
+ A fully functional working version of the V4L2 driver is available. This
+ driver has been tested with NTSC and PAL standards and buffer streaming.
+
+ Following are TBDs.
+
+ vpbe display controller
+    - Add support for external encoders.
+    - add support for selecting external encoder as default at probe time.
+
+ vpbe venc sub device
+    - add timings for supporting ths8200
+    - add support for LogicPD LCD.
+
+ FB drivers
+    - Add support for fbdev drivers.- Ready and part of subsequent patches.
-- 
1.6.2.4

