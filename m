Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:53896 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932616AbcILPcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 11:32:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Duggan <aduggan@synaptics.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Nick Dyer <nick@shmanahar.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [media] Input: synaptics-rmi4: disallow impossible configuration
Date: Mon, 12 Sep 2016 17:30:33 +0200
Message-Id: <20160912153105.3035940-2-arnd@arndb.de>
In-Reply-To: <20160912153105.3035940-1-arnd@arndb.de>
References: <20160912153105.3035940-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The newly added debug mode for the synaptics-rmi4 driver relies on
the v4l2 interface and vb2_vmalloc, but those might be configured
as loadable modules when the driver itself is built-in, resulting
in a link failure:

drivers/input/rmi4/rmi_core.o: In function `rmi_f54_remove':
rmi_f54.c:(.text.rmi_f54_remove+0x14): undefined reference to `video_unregister_device'
rmi_f54.c:(.text.rmi_f54_remove+0x20): undefined reference to `v4l2_device_unregister'
drivers/input/rmi4/rmi_core.o: In function `rmi_f54_vidioc_s_input':
rmi_f54.c:(.text.rmi_f54_vidioc_s_input+0x10): undefined reference to `video_devdata'
drivers/input/rmi4/rmi_core.o: In function `rmi_f54_vidioc_g_input':
rmi_f54.c:(.text.rmi_f54_vidioc_g_input+0x10): undefined reference to `video_devdata'
drivers/input/rmi4/rmi_core.o: In function `rmi_f54_vidioc_fmt':
rmi_f54.c:(.text.rmi_f54_vidioc_fmt+0x10): undefined reference to `video_devdata'
drivers/input/rmi4/rmi_core.o: In function `rmi_f54_vidioc_enum_input':
rmi_f54.c:(.text.rmi_f54_vidioc_enum_input+0x10): undefined reference to `video_devdata'
drivers/input/rmi4/rmi_core.o: In function `rmi_f54_vidioc_querycap':
...

The best workaround I could come up with is to disallow the debug
mode unless it's actually possible to call it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 3a762dbd5347 ("[media] Input: synaptics-rmi4 - add support for F54 diagnostics")
---
 drivers/input/rmi4/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
index f3418b65eb41..4c8a55857e00 100644
--- a/drivers/input/rmi4/Kconfig
+++ b/drivers/input/rmi4/Kconfig
@@ -65,7 +65,7 @@ config RMI4_F30
 config RMI4_F54
 	bool "RMI4 Function 54 (Analog diagnostics)"
 	depends on RMI4_CORE
-	depends on VIDEO_V4L2
+	depends on VIDEO_V4L2=y || (RMI4_CORE=m && VIDEO_V4L2=m)
 	select VIDEOBUF2_VMALLOC
 	help
 	  Say Y here if you want to add support for RMI4 function 54
-- 
2.9.0

