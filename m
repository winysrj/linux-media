Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:52776 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752262AbdCBTNm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 14:13:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: kasan-dev@googlegroups.com
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 23/26] mtd: cfi: reduce stack size with KASAN
Date: Thu,  2 Mar 2017 17:38:31 +0100
Message-Id: <20170302163834.2273519-24-arnd@arndb.de>
In-Reply-To: <20170302163834.2273519-1-arnd@arndb.de>
References: <20170302163834.2273519-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_KASAN is used, we consume a lot of extra stack space:

drivers/mtd/chips/cfi_cmdset_0020.c: In function 'do_write_buffer':
drivers/mtd/chips/cfi_cmdset_0020.c:603:1: error: the frame size of 2080 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
drivers/mtd/chips/cfi_cmdset_0020.c: In function 'cfi_staa_erase_varsize':
drivers/mtd/chips/cfi_cmdset_0020.c:972:1: error: the frame size of 1936 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
drivers/mtd/chips/cfi_cmdset_0001.c: In function 'do_write_buffer':
drivers/mtd/chips/cfi_cmdset_0001.c:1841:1: error: the frame size of 1776 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

This marks some functions as noinline_for_kasan to keep reduce the
overall stack size.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/mtd/chips/cfi_cmdset_0020.c | 8 ++++----
 include/linux/mtd/map.h             | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0020.c b/drivers/mtd/chips/cfi_cmdset_0020.c
index 94d3eb42c4d5..8a21e030829c 100644
--- a/drivers/mtd/chips/cfi_cmdset_0020.c
+++ b/drivers/mtd/chips/cfi_cmdset_0020.c
@@ -244,7 +244,7 @@ static struct mtd_info *cfi_staa_setup(struct map_info *map)
 }
 
 
-static inline int do_read_onechip(struct map_info *map, struct flchip *chip, loff_t adr, size_t len, u_char *buf)
+static noinline_for_kasan int do_read_onechip(struct map_info *map, struct flchip *chip, loff_t adr, size_t len, u_char *buf)
 {
 	map_word status, status_OK;
 	unsigned long timeo;
@@ -728,7 +728,7 @@ cfi_staa_writev(struct mtd_info *mtd, const struct kvec *vecs,
 }
 
 
-static inline int do_erase_oneblock(struct map_info *map, struct flchip *chip, unsigned long adr)
+static noinline_for_kasan int do_erase_oneblock(struct map_info *map, struct flchip *chip, unsigned long adr)
 {
 	struct cfi_private *cfi = map->fldrv_priv;
 	map_word status, status_OK;
@@ -1029,7 +1029,7 @@ static void cfi_staa_sync (struct mtd_info *mtd)
 	}
 }
 
-static inline int do_lock_oneblock(struct map_info *map, struct flchip *chip, unsigned long adr)
+static noinline_for_kasan int do_lock_oneblock(struct map_info *map, struct flchip *chip, unsigned long adr)
 {
 	struct cfi_private *cfi = map->fldrv_priv;
 	map_word status, status_OK;
@@ -1175,7 +1175,7 @@ static int cfi_staa_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 	}
 	return 0;
 }
-static inline int do_unlock_oneblock(struct map_info *map, struct flchip *chip, unsigned long adr)
+static noinline_for_kasan int do_unlock_oneblock(struct map_info *map, struct flchip *chip, unsigned long adr)
 {
 	struct cfi_private *cfi = map->fldrv_priv;
 	map_word status, status_OK;
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 3aa56e3104bb..8c2e241f45c7 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -316,7 +316,7 @@ static inline map_word map_word_or(struct map_info *map, map_word val1, map_word
 	return r;
 }
 
-static inline int map_word_andequal(struct map_info *map, map_word val1, map_word val2, map_word val3)
+static noinline_for_kasan int map_word_andequal(struct map_info *map, map_word val1, map_word val2, map_word val3)
 {
 	int i;
 
@@ -328,7 +328,7 @@ static inline int map_word_andequal(struct map_info *map, map_word val1, map_wor
 	return 1;
 }
 
-static inline int map_word_bitsset(struct map_info *map, map_word val1, map_word val2)
+static noinline_for_kasan int map_word_bitsset(struct map_info *map, map_word val1, map_word val2)
 {
 	int i;
 
@@ -362,7 +362,7 @@ static inline map_word map_word_load(struct map_info *map, const void *ptr)
 	return r;
 }
 
-static inline map_word map_word_load_partial(struct map_info *map, map_word orig, const unsigned char *buf, int start, int len)
+static noinline_for_kasan map_word map_word_load_partial(struct map_info *map, map_word orig, const unsigned char *buf, int start, int len)
 {
 	int i;
 
@@ -392,7 +392,7 @@ static inline map_word map_word_load_partial(struct map_info *map, map_word orig
 #define MAP_FF_LIMIT 8
 #endif
 
-static inline map_word map_word_ff(struct map_info *map)
+static noinline_for_kasan map_word map_word_ff(struct map_info *map)
 {
 	map_word r;
 	int i;
-- 
2.9.0
