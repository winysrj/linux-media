Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:56547 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751142AbdKJQqg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 11:46:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] vivid: print time in y2038-safe way
Date: Fri, 10 Nov 2017 17:46:17 +0100
Message-Id: <20171110164628.3763522-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

time_to_tm() takes a time_t value that overflows in 2038 on 32-bit
systems. time64_to_tm() doesn't have this problem, so let's use that in
combination with ktime_get_real_seconds() to read a 64-bit time
value.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/vivid/vivid-rds-gen.c | 2 +-
 drivers/media/platform/vivid/vivid-vbi-gen.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-rds-gen.c b/drivers/media/platform/vivid/vivid-rds-gen.c
index 53c7777dc001..996e35e28d37 100644
--- a/drivers/media/platform/vivid/vivid-rds-gen.c
+++ b/drivers/media/platform/vivid/vivid-rds-gen.c
@@ -103,7 +103,7 @@ void vivid_rds_generate(struct vivid_rds_gen *rds)
 			 * EN 50067:1998 to convert a UTC date to an RDS Modified
 			 * Julian Day.
 			 */
-			time_to_tm(get_seconds(), 0, &tm);
+			time64_to_tm(ktime_get_real_seconds(), 0, &tm);
 			l = tm.tm_mon <= 1;
 			date = 14956 + tm.tm_mday + ((tm.tm_year - l) * 1461) / 4 +
 				((tm.tm_mon + 2 + l * 12) * 306001) / 10000;
diff --git a/drivers/media/platform/vivid/vivid-vbi-gen.c b/drivers/media/platform/vivid/vivid-vbi-gen.c
index a2159de83d0b..02c79d7cedab 100644
--- a/drivers/media/platform/vivid/vivid-vbi-gen.c
+++ b/drivers/media/platform/vivid/vivid-vbi-gen.c
@@ -190,7 +190,7 @@ static void vivid_vbi_gen_set_time_of_day(u8 *packet)
 	struct tm tm;
 	u8 checksum, i;
 
-	time_to_tm(get_seconds(), 0, &tm);
+	time64_to_tm(ktime_get_real_seconds(), 0, &tm);
 	packet[0] = calc_parity(0x07);
 	packet[1] = calc_parity(0x01);
 	packet[2] = calc_parity(0x40 | tm.tm_min);
-- 
2.9.0
