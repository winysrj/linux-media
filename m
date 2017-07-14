Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:62343 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753535AbdGNJ13 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:27:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        linux-media@vger.kernel.org, akpm@linux-foundation.org,
        dri-devel@lists.freedesktop.org, Arnd Bergmann <arnd@arndb.de>,
        Adam Manzanares <adam.manzanares@wdc.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH, RESEND 02/14] ata: avoid gcc-7 warning in ata_timing_quantize
Date: Fri, 14 Jul 2017 11:25:14 +0200
Message-Id: <20170714092540.1217397-3-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc-7 warns about the result of a constant multiplication used as
a boolean:

drivers/ata/libata-core.c: In function 'ata_timing_quantize':
drivers/ata/libata-core.c:3164:30: warning: '*' in boolean context, suggest '&&' instead [-Wint-in-bool-context]

This slightly rearranges the macro to simplify the code and avoid
the warning at the same time.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/ata/libata-core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fa7dd4394c02..450059dd06ba 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3231,19 +3231,19 @@ static const struct ata_timing ata_timing[] = {
 };
 
 #define ENOUGH(v, unit)		(((v)-1)/(unit)+1)
-#define EZ(v, unit)		((v)?ENOUGH(v, unit):0)
+#define EZ(v, unit)		((v)?ENOUGH(((v) * 1000), unit):0)
 
 static void ata_timing_quantize(const struct ata_timing *t, struct ata_timing *q, int T, int UT)
 {
-	q->setup	= EZ(t->setup      * 1000,  T);
-	q->act8b	= EZ(t->act8b      * 1000,  T);
-	q->rec8b	= EZ(t->rec8b      * 1000,  T);
-	q->cyc8b	= EZ(t->cyc8b      * 1000,  T);
-	q->active	= EZ(t->active     * 1000,  T);
-	q->recover	= EZ(t->recover    * 1000,  T);
-	q->dmack_hold	= EZ(t->dmack_hold * 1000,  T);
-	q->cycle	= EZ(t->cycle      * 1000,  T);
-	q->udma		= EZ(t->udma       * 1000, UT);
+	q->setup	= EZ(t->setup,       T);
+	q->act8b	= EZ(t->act8b,       T);
+	q->rec8b	= EZ(t->rec8b,       T);
+	q->cyc8b	= EZ(t->cyc8b,       T);
+	q->active	= EZ(t->active,      T);
+	q->recover	= EZ(t->recover,     T);
+	q->dmack_hold	= EZ(t->dmack_hold,  T);
+	q->cycle	= EZ(t->cycle,       T);
+	q->udma		= EZ(t->udma,       UT);
 }
 
 void ata_timing_merge(const struct ata_timing *a, const struct ata_timing *b,
-- 
2.9.0
