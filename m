Return-path: <linux-media-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:34284 "EHLO
        www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752828AbdICMad (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 08:30:33 -0400
Subject: [PATCH 5/10] [media] lgdt3306a: Use ARRAY_SIZE macro
From: Thomas Meyer <thomas@m3y3r.de>
To: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1504439110050-1380074870-5-diffsplit-thomas@m3y3r.de>
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

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index c9b1eb38444e..724e9aac0f11 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -19,6 +19,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <asm/div64.h>
+#include <linux/kernel.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_math.h"
 #include "lgdt3306a.h"
@@ -2072,7 +2073,7 @@ static const short regtab[] = {
 	0x30aa, /* MPEGLOCK */
 };
 
-#define numDumpRegs (sizeof(regtab)/sizeof(regtab[0]))
+#define numDumpRegs (ARRAY_SIZE(regtab))
 static u8 regval1[numDumpRegs] = {0, };
 static u8 regval2[numDumpRegs] = {0, };
 
