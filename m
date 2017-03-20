Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:38039 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753624AbdCTOmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:04 -0400
Subject: [PATCH 13/24] staging: media: atomisp: add missing dependencies in
 Kconfig
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:41:02 +0000
Message-ID: <149002085761.17109.14764971776082989991.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>

Two dependencies were missing to build atomisp drivers:

_ MEDIA_CONTROLLER: to use the entity field of v4l2_subdev structure. Since
every atomisp driver needs MEDIA_CONTROLLER has a dependency, let's add it
to INTEL_ATOMISP

_ EFI: to use efivar_entry_get:
drivers/built-in.o: In function `gmin_get_config_var':
(.text+0xe062b): undefined reference to `efivar_entry_get'

Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/media/atomisp/Kconfig            |    2 +-
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index f7d8a84..28615aa 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig INTEL_ATOMISP
         bool "Enable support to Intel MIPI camera drivers"
-        depends on X86
+        depends on X86 && EFI && MEDIA_CONTROLLER
         help
           Enable support for the Intel ISP2 camera interfaces and MIPI
           sensor drivers.
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/Kconfig b/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
index 3954b8c..9fb1bff 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_OV5693
        tristate "Omnivision ov5693 sensor support"
-       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+       depends on I2C && VIDEO_V4L2
        ---help---
          This is a Video4Linux2 sensor-level driver for the Micron
          ov5693 5 Mpixel camera.
