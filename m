Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:41584 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752179AbdKZNAU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Nov 2017 08:00:20 -0500
Received: by mail-wm0-f65.google.com with SMTP id b189so29295758wmd.0
        for <linux-media@vger.kernel.org>; Sun, 26 Nov 2017 05:00:20 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, rascobie@slingshot.co.nz, jasmin@anw.at
Subject: [PATCH 7/7] [media] dvb-frontends/stv0910: remove unneeded dvb_math.h include
Date: Sun, 26 Nov 2017 14:00:09 +0100
Message-Id: <20171126130009.6798-8-d.scheller.oss@gmail.com>
In-Reply-To: <20171126130009.6798-1-d.scheller.oss@gmail.com>
References: <20171126130009.6798-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Since nothing from dvb_math.h is used, remove the unneeded include.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index de8702fcffbd..618d70683559 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -24,7 +24,6 @@
 #include <linux/i2c.h>
 #include <asm/div64.h>
 
-#include "dvb_math.h"
 #include "dvb_frontend.h"
 #include "stv0910.h"
 #include "stv0910_regs.h"
-- 
2.13.6
