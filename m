Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:50448 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753393AbdCTJdE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 05:33:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/9] staging/atomisp: add VIDEO_V4L2_SUBDEV_API dependency
Date: Mon, 20 Mar 2017 10:32:21 +0100
Message-Id: <20170320093225.1180723-5-arnd@arndb.de>
In-Reply-To: <20170320093225.1180723-1-arnd@arndb.de>
References: <20170320093225.1180723-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver fails to build if this is disabled, so we need an explicit
Kconfig dependency:

drivers/staging/media/atomisp/pci/atomisp2/./atomisp_cmd.c:6085:48: error: 'struct v4l2_subdev_fh' has no member named 'pad'

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/atomisp/pci/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/Kconfig b/drivers/staging/media/atomisp/pci/Kconfig
index e8f67835d03d..a72421431c7a 100644
--- a/drivers/staging/media/atomisp/pci/Kconfig
+++ b/drivers/staging/media/atomisp/pci/Kconfig
@@ -4,7 +4,7 @@
 
 config VIDEO_ATOMISP
        tristate "Intel Atom Image Signal Processor Driver"
-       depends on VIDEO_V4L2
+       depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
        select VIDEOBUF_VMALLOC
         ---help---
           Say Y here if your platform supports Intel Atom SoC
-- 
2.9.0
