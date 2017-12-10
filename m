Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:55624 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751726AbdLJO2H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Dec 2017 09:28:07 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Revert 41e33085284dd2bc6b6180d8381ff8a509b9d8ba for < 3.19
Date: Sun, 10 Dec 2017 15:28:00 +0100
Message-Id: <1512916080-5938-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

I tried to to define "ktime_get_real_seconds" in "v4l/compat.h", but it is
using static variables from "kernel/time/timekeeping.c". So there is no other
way than reverting 41e33085284dd2bc6b6180d8381ff8a509b9d8ba for Kernels
older than 3.19.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/backports.txt                      |  1 +
 backports/v3.18_ktime_get_real_seconds.patch | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 backports/v3.18_ktime_get_real_seconds.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 2911023..c30ccf0 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -83,6 +83,7 @@ add v3.19_get_user_pages_locked.patch
 
 [3.18.255]
 add v3.18_drop_property_h.patch
+add v3.18_ktime_get_real_seconds.patch
 
 [3.17.255]
 add v3.17_fix_clamp.patch
diff --git a/backports/v3.18_ktime_get_real_seconds.patch b/backports/v3.18_ktime_get_real_seconds.patch
new file mode 100644
index 0000000..97ed081
--- /dev/null
+++ b/backports/v3.18_ktime_get_real_seconds.patch
@@ -0,0 +1,26 @@
+diff --git a/drivers/media/platform/vivid/vivid-rds-gen.c b/drivers/media/platform/vivid/vivid-rds-gen.c
+index 996e35e..53c7777 100644
+--- a/drivers/media/platform/vivid/vivid-rds-gen.c
++++ b/drivers/media/platform/vivid/vivid-rds-gen.c
+@@ -103,7 +103,7 @@ void vivid_rds_generate(struct vivid_rds_gen *rds)
+ 			 * EN 50067:1998 to convert a UTC date to an RDS Modified
+ 			 * Julian Day.
+ 			 */
+-			time64_to_tm(ktime_get_real_seconds(), 0, &tm);
++			time_to_tm(get_seconds(), 0, &tm);
+ 			l = tm.tm_mon <= 1;
+ 			date = 14956 + tm.tm_mday + ((tm.tm_year - l) * 1461) / 4 +
+ 				((tm.tm_mon + 2 + l * 12) * 306001) / 10000;
+diff --git a/drivers/media/platform/vivid/vivid-vbi-gen.c b/drivers/media/platform/vivid/vivid-vbi-gen.c
+index 02c79d7..a2159de 100644
+--- a/drivers/media/platform/vivid/vivid-vbi-gen.c
++++ b/drivers/media/platform/vivid/vivid-vbi-gen.c
+@@ -190,7 +190,7 @@ static void vivid_vbi_gen_set_time_of_day(u8 *packet)
+ 	struct tm tm;
+ 	u8 checksum, i;
+ 
+-	time64_to_tm(ktime_get_real_seconds(), 0, &tm);
++	time_to_tm(get_seconds(), 0, &tm);
+ 	packet[0] = calc_parity(0x07);
+ 	packet[1] = calc_parity(0x01);
+ 	packet[2] = calc_parity(0x40 | tm.tm_min);
-- 
2.7.4
