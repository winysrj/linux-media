Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:40368 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbdICMPw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 08:15:52 -0400
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] staging/atomisp: fix header guards
Date: Sun,  3 Sep 2017 14:05:26 +0200
Message-Id: <20170903120526.20043-1-nicolas.iooss_linux@m4x.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Files input_formatter_subsystem_defs.h begin with:

    #ifndef _if_subsystem_defs_h
    #define _if_subsystem_defs_h__

and end with:

    #endif /* _if_subsystem_defs_h__ */

The intent seems to have been to use _if_subsystem_defs_h__ everywhere
but two underscores are missing in the initial #ifndef.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 .../css2400/css_2400_system/hrt/input_formatter_subsystem_defs.h        | 2 +-
 .../css2400/css_2401_csi2p_system/hrt/input_formatter_subsystem_defs.h  | 2 +-
 .../css2400/css_2401_system/hrt/input_formatter_subsystem_defs.h        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/input_formatter_subsystem_defs.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/input_formatter_subsystem_defs.h
index 16bfe1d80bc9..7766f78cd123 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/input_formatter_subsystem_defs.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/input_formatter_subsystem_defs.h
@@ -12,7 +12,7 @@
  * more details.
  */
 
-#ifndef _if_subsystem_defs_h
+#ifndef _if_subsystem_defs_h__
 #define _if_subsystem_defs_h__
 
 #define HIVE_IFMT_GP_REGS_INPUT_SWITCH_LUT_REG_0            0
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/input_formatter_subsystem_defs.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/input_formatter_subsystem_defs.h
index 16bfe1d80bc9..7766f78cd123 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/input_formatter_subsystem_defs.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/input_formatter_subsystem_defs.h
@@ -12,7 +12,7 @@
  * more details.
  */
 
-#ifndef _if_subsystem_defs_h
+#ifndef _if_subsystem_defs_h__
 #define _if_subsystem_defs_h__
 
 #define HIVE_IFMT_GP_REGS_INPUT_SWITCH_LUT_REG_0            0
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hrt/input_formatter_subsystem_defs.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hrt/input_formatter_subsystem_defs.h
index 16bfe1d80bc9..7766f78cd123 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hrt/input_formatter_subsystem_defs.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hrt/input_formatter_subsystem_defs.h
@@ -12,7 +12,7 @@
  * more details.
  */
 
-#ifndef _if_subsystem_defs_h
+#ifndef _if_subsystem_defs_h__
 #define _if_subsystem_defs_h__
 
 #define HIVE_IFMT_GP_REGS_INPUT_SWITCH_LUT_REG_0            0
-- 
2.14.1
