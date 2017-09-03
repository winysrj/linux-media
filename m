Return-path: <linux-media-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:34291 "EHLO
        www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752874AbdICMae (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 08:30:34 -0400
Subject: [PATCH 10/10] staging/atomisp: Use ARRAY_SIZE macro
From: Thomas Meyer <thomas@m3y3r.de>
To: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1504439110051-615566240-10-diffsplit-thomas@m3y3r.de>
References: <1504439110050-939061377-0-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1504439110050-939061377-0-diffsplit-thomas@m3y3r.de>
Date: Sun, 03 Sep 2017 14:19:31 +0200
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use ARRAY_SIZE macro, rather than explicitly coding some variant of it
yourself.
Found with: find -type f -name "*.c" -o -name "*.h" | xargs perl -p -i -e
's/\bsizeof\s*\(\s*(\w+)\s*\)\s*\ /\s*sizeof\s*\(\s*\1\s*\[\s*0\s*\]\s*\)
/ARRAY_SIZE(\1)/g' and manual check/verification.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c
index a7c6bba7e094..11d3995ba0db 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c
@@ -29,6 +29,7 @@ more details.
 #endif
 
 #include "system_global.h"
+#include <linux/kernel.h>
 
 #ifdef USE_INPUT_SYSTEM_VERSION_2
 
@@ -487,7 +488,7 @@ static void ifmtr_set_if_blocking_mode(
 {
 	int i;
 	bool block[] = { false, false, false, false };
-	assert(N_INPUT_FORMATTER_ID <= (sizeof(block) / sizeof(block[0])));
+	assert(N_INPUT_FORMATTER_ID <= (ARRAY_SIZE(block)));
 
 #if !defined(IS_ISP_2400_SYSTEM)
 #error "ifmtr_set_if_blocking_mode: ISP_SYSTEM must be one of {IS_ISP_2400_SYSTEM}"
