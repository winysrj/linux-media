Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:16797 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753642AbdCTOmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:04 -0400
Subject: [PATCH 18/24] staging/atomisp: add VIDEO_V4L2_SUBDEV_API dependency
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:41:47 +0000
Message-ID: <149002090571.17109.1330628308217103500.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

The driver fails to build if this is disabled, so we need an explicit
Kconfig dependency:

drivers/staging/media/atomisp/pci/atomisp2/./atomisp_cmd.c:6085:48: error: 'struct v4l2_subdev_fh' has no member named 'pad'

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/media/atomisp/pci/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/Kconfig b/drivers/staging/media/atomisp/pci/Kconfig
index e8f6783..a724214 100644
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
