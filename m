Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:60898 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdGNJ13 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:27:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH, RESEND 01/14] ide: avoid warning for timings calculation
Date: Fri, 14 Jul 2017 11:25:13 +0200
Message-Id: <20170714092540.1217397-2-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc-7 warns about the result of a constant multiplication used as
a boolean:

drivers/ide/ide-timings.c: In function 'ide_timing_quantize':
drivers/ide/ide-timings.c:112:24: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
  q->setup   = EZ(t->setup   * 1000,  T);

This slightly rearranges the macro to simplify the code and avoid
the warning at the same time.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/ide/ide-timings.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ide/ide-timings.c b/drivers/ide/ide-timings.c
index 0e05f75934c9..1858e3ce3993 100644
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -104,19 +104,19 @@ u16 ide_pio_cycle_time(ide_drive_t *drive, u8 pio)
 EXPORT_SYMBOL_GPL(ide_pio_cycle_time);
 
 #define ENOUGH(v, unit)		(((v) - 1) / (unit) + 1)
-#define EZ(v, unit)		((v) ? ENOUGH(v, unit) : 0)
+#define EZ(v, unit)		((v) ? ENOUGH((v) * 1000, unit) : 0)
 
 static void ide_timing_quantize(struct ide_timing *t, struct ide_timing *q,
 				int T, int UT)
 {
-	q->setup   = EZ(t->setup   * 1000,  T);
-	q->act8b   = EZ(t->act8b   * 1000,  T);
-	q->rec8b   = EZ(t->rec8b   * 1000,  T);
-	q->cyc8b   = EZ(t->cyc8b   * 1000,  T);
-	q->active  = EZ(t->active  * 1000,  T);
-	q->recover = EZ(t->recover * 1000,  T);
-	q->cycle   = EZ(t->cycle   * 1000,  T);
-	q->udma    = EZ(t->udma    * 1000, UT);
+	q->setup   = EZ(t->setup,   T);
+	q->act8b   = EZ(t->act8b,   T);
+	q->rec8b   = EZ(t->rec8b,   T);
+	q->cyc8b   = EZ(t->cyc8b,   T);
+	q->active  = EZ(t->active,  T);
+	q->recover = EZ(t->recover, T);
+	q->cycle   = EZ(t->cycle,   T);
+	q->udma    = EZ(t->udma,    UT);
 }
 
 void ide_timing_merge(struct ide_timing *a, struct ide_timing *b,
-- 
2.9.0
