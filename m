Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:60498 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbeBBPUY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Feb 2018 10:20:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>, Sergiy Redko <sergredko@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: atomisp: remove pointless string copy
Date: Fri,  2 Feb 2018 16:19:41 +0100
Message-Id: <20180202152009.843231-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc-8 points out that a string is copied to itself here:

In file included from drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/platform_support.h:25,
                 from drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/memory_access/memory_access.h:48,
                 from drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c:16:
In function 'strncpy',
    inlined from 'ia_css_debug_pipe_graph_dump_stage' at drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h:158:2:
include/linux/string.h:253:9: error: '__builtin_strncpy' source argument is the same as destination [-Werror=restrict]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This removes the bogus code, leaving the behavior otherwise
unchanged.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
index f22d73b56bc6..60395904f89a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
@@ -2858,13 +2858,7 @@ ia_css_debug_pipe_graph_dump_stage(
 			if (l && enable_info[l-1] == ',')
 				enable_info[--l] = '\0';
 
-			if (l <= ENABLE_LINE_MAX_LENGTH) {
-				/* It fits on one line, copy string and init */
-				/* other helper strings with empty string */
-				strcpy_s(enable_info,
-					sizeof(enable_info),
-					ei);
-			} else {
+			if (l > ENABLE_LINE_MAX_LENGTH) {
 				/* Too big for one line, find last comma */
 				p = ENABLE_LINE_MAX_LENGTH;
 				while (ei[p] != ',')
-- 
2.9.0
