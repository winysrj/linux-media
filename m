Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35512 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaJZLrc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 07:47:32 -0400
Received: by mail-pa0-f41.google.com with SMTP id rd3so3730804pab.14
        for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 04:47:31 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 5/7] v4l-utils/libdvbv5: add gconv module for the text translation of ISDB-S/T.
Date: Sun, 26 Oct 2014 20:46:21 +0900
Message-Id: <1414323983-15996-6-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

---
 lib/Makefile.am             |   5 +-
 lib/gconv/arib-std-b24.c    | 775 +++++++++++++++++++++++++++++++++++++++++
 lib/gconv/en300-468-tab00.c | 564 ++++++++++++++++++++++++++++++
 lib/gconv/gconv-modules     |   7 +
 lib/gconv/gconv.map         |   8 +
 lib/gconv/iconv/loop.c      | 523 ++++++++++++++++++++++++++++
 lib/gconv/iconv/skeleton.c  | 829 ++++++++++++++++++++++++++++++++++++++++++++
 lib/gconv/jisx0213.h        | 102 ++++++
 8 files changed, 2811 insertions(+), 2 deletions(-)
 create mode 100644 lib/gconv/arib-std-b24.c
 create mode 100644 lib/gconv/en300-468-tab00.c
 create mode 100644 lib/gconv/gconv-modules
 create mode 100644 lib/gconv/gconv.map
 create mode 100644 lib/gconv/iconv/loop.c
 create mode 100644 lib/gconv/iconv/skeleton.c
 create mode 100644 lib/gconv/jisx0213.h

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 3a0e19c..b21103b 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -7,5 +7,6 @@ SUBDIRS = \
 
 if LINUX_OS
 SUBDIRS += \
-	libdvbv5
-endif
\ No newline at end of file
+	libdvbv5 \
+	gconv
+endif
diff --git a/lib/gconv/arib-std-b24.c b/lib/gconv/arib-std-b24.c
new file mode 100644
index 0000000..c4ee1e2
--- /dev/null
+++ b/lib/gconv/arib-std-b24.c
@@ -0,0 +1,775 @@
+/* Conversion module for ARIB-STD-B24.
+   Copyright (C) 1998-2014 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Ulrich Drepper <drepper@cygnus.com>, 1998,
+   Bruno Haible <bruno@clisp.org>, 2002,
+   and Akihiro Tsukada <tskd8@gmail.com>
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#include <assert.h>
+#include <dlfcn.h>
+#include <gconv.h>
+#include <stdint.h>
+#include <string.h>
+
+#include "jisx0213.h"
+
+/* Definitions used in the body of the `gconv' function.  */
+#define CHARSET_NAME		"ARIB-STD-B24//"
+#define DEFINE_INIT		1
+#define DEFINE_FINI		1
+#define ONE_DIRECTION		1
+#define FROM_LOOP		from_aribb24_loop
+#define TO_LOOP                 FROM_LOOP
+#define FROM_LOOP_MIN_NEEDED_FROM 1
+#define FROM_LOOP_MAX_NEEDED_FROM 1
+#define FROM_LOOP_MIN_NEEDED_TO 4
+#define FROM_LOOP_MAX_NEEDED_TO (4 * 4)
+#define TO_LOOP_MIN_NEEDED_FROM 4
+#define TO_LOOP_MAX_NEEDED_FROM 4
+#define TO_LOOP_MIN_NEEDED_TO 1
+#define TO_LOOP_MAX_NEEDED_TO 7
+
+#define PREPARE_LOOP \
+  __mbstate_t saved_state;						      \
+  __mbstate_t *statep = data->__statep;                                       \
+  status = __GCONV_OK;
+
+/* Since we might have to reset input pointer we must be able to save
+   and retore the state.  */
+#define SAVE_RESET_STATE(Save) \
+  if (Save)								      \
+    saved_state = *statep;						      \
+  else									      \
+    *statep = saved_state
+
+/* This makes obvious what everybody knows: 0x1b is the Esc character.  */
+#define ESC 0x1b
+/* other control characters */
+#define SS2 0x19
+#define SS3 0x1d
+#define LS0 0x0f
+#define LS1 0x0e
+
+#define LS2 0x6e
+#define LS3 0x6f
+#define LS1R 0x7e
+#define LS2R 0x7d
+#define LS3R 0x7c
+
+#define LF 0x0a
+#define CR 0x0d
+#define BEL 0x07
+#define BS 0x08
+#define COL 0x90
+#define CDC 0x92
+#define MACRO_CTRL 0x95
+#define CSI 0x9b
+#define TIME 0x9d
+
+/* code sets */
+enum g_set
+{
+  KANJI_set = '\x42',         /* 2Byte set */
+  ASCII_set = '\x40',
+  ASCII_x_set = '\x4a',
+  HIRAGANA_set = '\x30',
+  KATAKANA_set = '\x31',
+  MOSAIC_A_set = '\x32',
+  MOSAIC_B_set = '\x33',
+  MOSAIC_C_set = '\x34',
+  MOSAIC_D_set = '\x35',
+  PROP_ASCII_set = '\x36',
+  PROP_HIRA_set = '\x37',
+  PROP_KATA_set = '\x38',
+  JIS0201_KATA_set = '\x49',
+  JISX0213_1_set = '\x39',    /* 2Byte set */
+  JISX0213_2_set = '\x3a',    /* 2Byte set */
+  EXTRA_SYMBOLS_set = '\x3b', /* 2Byte set */
+
+  DRCS0_set = 0x40 | 0x80,    /* 2Byte set */
+  DRCS1_set = 0x41 | 0x80,
+  DRCS15_set = 0x4f | 0x80,
+  MACRO_set = 0x70 | 0x80,    
+};
+
+
+/* First define the conversion function from ARIB-STD-B24 to UCS-4.  */
+
+enum mode_e
+{
+  NORMAL,
+  ESCAPE,
+  G_SEL_1B,
+  G_SEL_MB,
+  CTRL_SEQ,
+  DESIGNATE_MB,
+  DRCS_SEL_1B,
+  DRCS_SEL_MB,
+  MB_2ND,
+};
+
+/*
+ * __GCONV_INPUT_INCOMPLETE is never used in this conversion, thus
+ * we can re-use mbstate_t.__value and .__count:3 for the other purpose.
+ */
+struct state_from {
+  /* __count */
+  uint8_t cnt:3;	/* for use in skelton.c. always 0 */
+  uint8_t pad0:1;
+  uint8_t gl:2;		/* idx of the G-set invoked into GL */
+  uint8_t gr:2;		/*  ... to GR */
+  uint8_t ss:2;		/* SS state. 0: no shift, 2:SS2, 3:SS3 */
+  uint8_t gidx:2;	/* currently designated G-set */
+  uint8_t mode:4;	/* current input mode. see below. */
+  uint8_t skip;		/* [CTRL_SEQ] # of char to skip */
+  uint8_t prev;		/* previously input char [in MB_2ND] or,*/
+			/* input char to wait for. [CTRL_SEQ (.skip == 0)] */
+
+  /* __value */
+  uint8_t g[4];		/* code set for G0..G3 */
+} __attribute__((packed));
+
+static const struct state_from def_state_from = {
+  .cnt = 0,
+  .gl = 0,
+  .gr = 2,
+  .ss = 0,
+  .gidx = 0,
+  .mode = NORMAL,
+  .skip = 0,
+  .prev = '\0',
+  .g[0] = KANJI_set,
+  .g[1] = ASCII_set,
+  .g[2] = HIRAGANA_set,
+  .g[3] = KATAKANA_set,
+};
+
+#define EXTRA_LOOP_DECLS	, __mbstate_t *statep
+#define EXTRA_LOOP_ARGS		, statep
+
+#define INIT_PARAMS \
+  struct state_from st = *((struct state_from *)statep);\
+  if (st.g[0] == 0)\
+    st = def_state_from;\
+
+#define UPDATE_PARAMS		*statep = *((__mbstate_t *)&st)
+
+#define LOOP_NEED_FLAGS
+
+#define MIN_NEEDED_INPUT	FROM_LOOP_MIN_NEEDED_FROM
+#define MAX_NEEDED_INPUT	FROM_LOOP_MAX_NEEDED_FROM
+#define MIN_NEEDED_OUTPUT	FROM_LOOP_MIN_NEEDED_TO
+#define MAX_NEEDED_OUTPUT	FROM_LOOP_MAX_NEEDED_TO
+#define LOOPFCT			FROM_LOOP
+
+/* tables and functions used in BODY */
+
+static const uint16_t kata_punc[] = {
+  0x30fd, 0x30fe, 0x30fc, 0x3002, 0x300c, 0x300d, 0x3001, 0x30fb
+};
+
+static const uint16_t hira_punc[] = {
+  0x309d, 0x309e
+};
+
+static const uint16_t nonspacing_symbol[] = {
+  0x0301, 0x0300, 0x0308, 0x0302, 0x0304, 0x0332
+};
+
+static const uint32_t extra_kanji[] = {
+  /* row 85 */
+  /* col 0..15 */
+  0, 0x3402, 0x20158, 0x4efd, 0x4eff, 0x4f9a, 0x4fc9, 0x509c,
+  0x511e, 0x51bc, 0x351f, 0x5307, 0x5361, 0x536c, 0x8a79, 0x20bb7,
+  /* col. 16..31 */
+  0x544d, 0x5496, 0x549c, 0x54a9, 0x550e, 0x554a, 0x5672, 0x56e4,
+  0x5733, 0x5734, 0xfa10, 0x5880, 0x59e4, 0x5a23, 0x5a55, 0x5bec,
+  /* col. 32..47 */
+  0xfa11, 0x37e2, 0x5eac, 0x5f34, 0x5f45, 0x5fb7, 0x6017, 0xfa6b,
+  0x6130, 0x6624, 0x66c8, 0x66d9, 0x66fa, 0x66fb, 0x6852, 0x9fc4,
+  /* col. 48..63 */
+  0x6911, 0x693b, 0x6a45, 0x6a91, 0x6adb, 0x233cc, 0x233fe, 0x235c4,
+  0x6bf1, 0x6ce0, 0x6d2e, 0xfa45, 0x6dbf, 0x6dca, 0x6df8, 0xfa46,
+  /* col. 64..79 */
+  0x6f5e, 0x6ff9, 0x7064, 0xfa6c, 0x242ee, 0x7147, 0x71c1, 0x7200,
+  0x739f, 0x73a8, 0x73c9, 0x73d6, 0x741b, 0x7421, 0xfa4a, 0x7426,
+  /* col. 80..96 */
+  0x742a, 0x742c, 0x7439, 0x744b, 0x3eda, 0x7575, 0x7581, 0x7772,
+  0x4093, 0x78c8, 0x78e0, 0x7947, 0x79ae, 0x9fc6, 0x4103, 0,
+
+  /* row 86 */
+  /* col 0..15 */
+  0, 0x9fc5, 0x79da, 0x7a1e, 0x7b7f, 0x7c31, 0x4264, 0x7d8b,
+  0x7fa1, 0x8118, 0x813a, 0xfa6d, 0x82ae, 0x845b, 0x84dc, 0x84ec,
+  /* col. 16..31 */
+  0x8559, 0x85ce, 0x8755, 0x87ec, 0x880b, 0x88f5, 0x89d2, 0x8af6,
+  0x8dce, 0x8fbb, 0x8ff6, 0x90dd, 0x9127, 0x912d, 0x91b2, 0x9233,
+  /* col. 32..43 */
+  0x9288, 0x9321, 0x9348, 0x9592, 0x96de, 0x9903, 0x9940, 0x9ad9,
+  0x9bd6, 0x9dd7, 0x9eb4, 0x9eb5
+};
+
+static const uint32_t extra_symbols[5][96] = {
+  /* row 90 */
+  {
+    /* col 0..15 */
+    0, 0x26cc, 0x26cd, 0x26ce, 0x26cf, 0x26d0, 0x26d1, 0,
+    0x26d2, 0x26d5, 0x26d3, 0x26d4, 0, 0, 0, 0,
+    /* col 16..31 */
+    0x1f17f, 0x1f18a, 0, 0, 0x26d6, 0x26d7, 0x26d8, 0x26d9,
+    0x26da, 0x26db, 0x26dc, 0x26dd, 0x26de, 0x26df, 0x26e0, 0x26e1,
+    /* col 32..47 */
+    0x26e2, 0x3248, 0x3249, 0x324a, 0x324b, 0x324c, 0x324d, 0x324e,
+    0x324f, 0, 0, 0, 0x2491, 0x2492, 0x2493,
+    /* col 48..63 */
+    0x1f14a, 0x1f14c, 0x1f13F, 0x1f146, 0x1f14b, 0x1f221, 0x1f21e, 0x1f218,
+    0x32ff, 0x1f142, 0x1f213, 0x1f21c, 0x1f22d, 0x1f14d, 0x1f131, 0x1f13d,
+    /* col 64..79 */
+    0x2b1b, 0x2b24, 0x1f21d, 0x1f214, 0x1f228, 0x1f22a, 0x1f226, 0x26bf,
+    0x1f217, 0x1f220, 0x1f215, 0x1f227, 0x1f216, 0x1f22c, 0x1f22b, 0x1f22e,
+    /* col 80..95 */
+    0x1f21b, 0x1f21a, 0x1f14e, 0x3299, 0x1f200, 0, 0, 0,
+    0, 0, 0, 0, 0, 0, 0, 0
+  },
+  /* row 91 */
+  {
+    /* col 0..15 */
+    0, 0x26e3, 0x26e4, 0x26e5, 0x26e6, 0x26e7, 0x2613, 0x328b,
+    0x3012, 0x26e8, 0x3246, 0x3245, 0x26e9, 0x0fd6, 0x26ea, 0x26eb,
+    /* col 16..31 */
+    0x26ec, 0x2668, 0x26ed, 0x26ee, 0x26ef, 0x2693, 0x2708, 0x26f0,
+    0x26f1, 0x26f2, 0x26f3, 0x26f4, 0x26f5, 0x1f157, 0x24b9, 0x24c8,
+    /* col 32..47 */
+    0x26f6, 0x1f15f, 0x1f18b, 0x1f18d, 0x1f18c, 0x1f179, 0x26f7, 0x26f8,
+    0x26f9, 0x26fa, 0x1f17b, 0x260e, 0x26fb, 0x26fc, 0x26fd, 0x26fe,
+    /* col 48..63 */
+    0x1f17c, 0x26ff,
+  },
+  /* row 92 */
+  {
+    /* col 0..15 */
+    0, 0x27a1, 0x2b05, 0x2b06, 0x2b07, 0x2b2f, 0x2b2e, 0x5e74,
+    0x6708, 0x65e5, 0x5186, 0x33a1, 0x33a5, 0x339d, 0x33a0, 0x33a4,
+    /* col 16..31 */
+    0x1f100, 0x2488, 0x2489, 0x248a, 0x248b, 0x248c, 0x248d, 0x248e,
+    0x248f, 0x2490, 0, 0, 0, 0, 0, 0,
+    /* col 32..47 */
+    0x1f101, 0x1f102, 0x1f103, 0x1f104, 0x1f105, 0x1f106, 0x1f107, 0x1f108,
+    0x1f109, 0x1f10a, 0x3233, 0x3236, 0x3232, 0x3231, 0x3239, 0x3244,
+    /* col 48..63 */
+    0x25b6, 0x25c0, 0x3016, 0x3017, 0x27d0, 0x00b2, 0x00b3, 0x1f12d,
+    0, 0, 0, 0, 0, 0, 0, 0,
+    /* col 64..79 */
+    0, 0, 0, 0, 0, 0, 0, 0,
+    0, 0, 0, 0, 0, 0, 0, 0,
+    /* col 80..95 */
+    0, 0, 0, 0, 0, 0, 0x1f12c, 0x1f12b,
+    0x3247, 0x1f14f, 0x1f229, 0x213b, 0, 0, 0, 0
+  },
+  /* row 93 */
+  {
+    /* col 0..15 */
+    0, 0x322a, 0x322b, 0x322c, 0x322d, 0x322e, 0x322f, 0x3230,
+    0x3237, 0x337e, 0x337d, 0x337c, 0x337b, 0x2116, 0x2121, 0x3036,
+    /* col 16..31 */
+    0x26be, 0x1f246, 0x1f240, 0x1f241, 0x1f243, 0x1f247, 0x1f244, 0x1f248,
+    0x1f142, 0x1f245, 0x1f12a, 0x1f223, 0x1f225, 0x1f210, 0x1f213, 0x1f211,
+    /* col 32..47 */
+    0x1f230, 0x1f21f, 0x1f212, 0x1f219, 0x1f224, 0x1f22f, 0x1f222, 0x2113,
+    0x338f, 0x3390, 0x33ca, 0x339e, 0x33a2, 0x3371, 0, 0,
+    /* col 48..63 */
+    0x00bd, 0x2189, 0x2153, 0x2154, 0x00bc, 0x00be, 0x2155, 0x2156,
+    0x2157, 0x2158, 0x2159, 0x215a, 0x2150, 0x215b, 0x2151, 0x2152,
+    /* col 64..79 */
+    0x2600, 0x2601, 0x2602, 0x26c4, 0x2616, 0x2617, 0x26c9, 0x26ca,
+    0x2666, 0x2665, 0x2663, 0x2660, 0x26cb, 0x2a00, 0x203c, 0x2049,
+    /* col 80..95 */
+    0x26c5, 0x2614, 0x26c6, 0x2603, 0x26c7, 0x26a1, 0x26c8, 0,
+    0x269e, 0x269f, 0x266c, 0x260e, 0, 0, 0, 0
+  },
+  /* row 94 */
+  {
+    /* col 0..15 */
+    0, 0x2160, 0x2161, 0x2162, 0x2163, 0x2164, 0x2165, 0x2166,
+    0x2167, 0x2168, 0x2169, 0x216a, 0x216b, 0x2470, 0x2471, 0x2472,
+    /* col 16..31 */
+    0x2473, 0x2474, 0x2475, 0x2476, 0x2477, 0x2478, 0x2479, 0x247a,
+    0x247b, 0x247c, 0x247d, 0x247e, 0x247f, 0x3251, 0x3252, 0x3253,
+    /* col 32..47 */
+    0x3254, 0x1f110, 0x1f111, 0x1f112, 0x1f113, 0x1f114, 0x1f115, 0x1f116,
+    0x1f117, 0x1f118, 0x1f119, 0x1f11a, 0x1f11b, 0x1f11c, 0x1f11d, 0x1f11e,
+    /* col 48..63 */
+    0x1f11f, 0x1f120, 0x1f121, 0x1f122, 0x1f123, 0x1f124, 0x1f125, 0x1f126,
+    0x1f127, 0x1f128, 0x1f129, 0x3255, 0x3256, 0x3257, 0x3258, 0x3259,
+    /* col 64..79 */
+    0x325a, 0x2460, 0x2461, 0x2462, 0x2463, 0x2464, 0x2465, 0x2466,
+    0x2467, 0x2468, 0x2469, 0x246a, 0x246b, 0x246c, 0x246d, 0x246e,
+    /* col 80..95 */
+    0x246f, 0x2776, 0x2777, 0x2778, 0x2779, 0x277a, 0x277b, 0x277c,
+    0x277d, 0x277e, 0x277f, 0x24eb, 0x24ec, 0x325b, 0, 0
+  },
+};
+
+struct mchar_entry {
+  uint32_t len;
+  uint32_t to[4];
+};
+
+/* list of transliterations. (combinations) */
+/* "10.", "11.", "12." */
+static const struct mchar_entry ext_sym_nums[] = {
+  {.len = 3, .to = { 0x0031, 0x0030, 0x002e }},
+  {.len = 3, .to = { 0x0031, 0x0031, 0x002e }},
+  {.len = 3, .to = { 0x0031, 0x0032, 0x002e }},
+};
+
+/* small KANJI. map to original sized version */
+static const struct mchar_entry ext_sym_smallk[] = {
+  {.len = 1, .to = { 0x6c0f }},
+  {.len = 1, .to = { 0x526f }},
+  {.len = 1, .to = { 0x5143 }},
+  {.len = 1, .to = { 0x6545 }},
+  {.len = 1, .to = { 0x52ed }},
+  {.len = 1, .to = { 0x65b0 }},
+};
+
+/* music instruments */
+static const struct mchar_entry ext_sym_music[] = {
+  {.len = 4, .to = { 0x0028, 0x0076, 0x006e, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x006f, 0x0062, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x0063, 0x0062, 0x0029 }},
+  {.len = 3, .to = { 0x0028, 0x0063, 0x0065 }},
+  {.len = 3, .to = { 0x006d, 0x0062, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x0068, 0x0070, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x0062, 0x0072, 0x0029 }},
+  {.len = 3, .to = { 0x0028, 0x0070, 0x0029 }},
+
+  {.len = 3, .to = { 0x0028, 0x0073, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x006d, 0x0073, 0x0029 }},
+  {.len = 3, .to = { 0x0028, 0x0074, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x0062, 0x0073, 0x0029 }},
+  {.len = 3, .to = { 0x0028, 0x0062, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x0074, 0x0062, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x0076, 0x0070, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x0064, 0x0073, 0x0029 }},
+
+  {.len = 4, .to = { 0x0028, 0x0061, 0x0067, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x0065, 0x0067, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x0076, 0x006f, 0x0029 }},
+  {.len = 4, .to = { 0x0028, 0x0066, 0x006c, 0x0029 }},
+  {.len = 3, .to = { 0x0028, 0x006b, 0x0065 }},
+  {.len = 2, .to = { 0x0079, 0x0029 }},
+  {.len = 3, .to = { 0x0028, 0x0073, 0x0061 }},
+  {.len = 2, .to = { 0x0078, 0x0029 }},
+
+  {.len = 3, .to = { 0x0028, 0x0073, 0x0079 }},
+  {.len = 2, .to = { 0x006e, 0x0029 }},
+  {.len = 3, .to = { 0x0028, 0x006f, 0x0072 }},
+  {.len = 2, .to = { 0x0067, 0x0029 }},
+  {.len = 3, .to = { 0x0028, 0x0070, 0x0065 }},
+  {.len = 2, .to = { 0x0072, 0x0029 }},
+};
+
+
+int b24_char_conv(int set, unsigned char c1, unsigned char c2, uint32_t *out)
+{
+  int len;
+  uint32_t ch;
+
+  if (set > DRCS0_set && set <= DRCS15_set)
+    set = DRCS0_set;
+
+  switch (set) {
+  case ASCII_set:
+  case ASCII_x_set:
+  case PROP_ASCII_set:
+    if (c1 == 0x7e)
+      *out = 0x203e;
+    else if (c1 == 0x5c)
+      *out = 0xa5;
+    else
+      *out = c1;
+    return 1;
+
+  case KATAKANA_set:
+  case PROP_KATA_set:
+    if (c1 <= 0x76)
+      *out = 0x3080 + c1;
+    else
+      *out = kata_punc[c1 - 0x77];
+    return 1;
+
+  case HIRAGANA_set:
+  case PROP_HIRA_set:
+    if (c1 <= 0x73)
+      *out = 0x3020 + c1;
+    else if (c1 == 0x77 || c1 == 0x78)
+      *out = hira_punc[c1 - 0x77];
+    else if (c1 >= 0x79)
+      *out = kata_punc[c1 - 0x77];
+    else
+      return 0;
+    return 1;
+
+  case JIS0201_KATA_set:
+    if (c1 > 0x5f)
+      return 0;
+    *out = 0xff40 + c1;
+    return 1;
+
+  case EXTRA_SYMBOLS_set:
+    if (c1 == 0x75 || (c1 == 0x76 && (c2 - 0x20) <=43)) {
+      *out = extra_kanji[(c1 - 0x75) * 96 + (c2 - 0x20)];
+      return 1;
+    }
+    /* fall through */
+  case KANJI_set:
+    /* check extra symbols */
+    if (c1 >= 0x7a && c1 <= 0x7e) {
+      const struct mchar_entry *entry;
+
+      c1 -= 0x20;
+      c2 -= 0x20;
+      if (c1 == 0x5a && c2 >= 0x2d && c2 <= 0x2f)
+        entry = &ext_sym_nums[c2 - 0x2d];
+      else if (c1 == 0x5c && c2 >= 0x1a && c2 <= 0x1f)
+        entry = &ext_sym_smallk[c2 - 0x1a];
+      else if (c1 == 0x5c && c2 >= 0x38 && c2 <= 0x55)
+        entry = &ext_sym_music[c2 - 0x38];
+      else
+        entry = NULL;
+
+      if (entry) {
+        int i;
+
+        for (i = 0; i < entry->len; i++)
+          out[i] = entry->to[i];
+        return i;
+      }
+
+     *out = extra_symbols[c1 - 0x5a][c2];
+      if (*out == 0)
+        return 0;
+
+      return 1;
+    }
+    if (set == EXTRA_SYMBOLS_set)
+      return 0;
+
+    /* non-JISX0213 modification. (combining chars) */
+    if (c1 == 0x22 && c2 == 0x7e) {
+      *out = 0x20dd;
+      return 1;
+    } else if (c1 == 0x21 && c2 >= 0x2d && c2 <= 0x32) {
+      *out = nonspacing_symbol[c2 - 0x2d];
+      return 1;
+    }
+    /* fall through */
+  case JISX0213_1_set:
+  case JISX0213_2_set:
+    len = 1;
+    ch = jisx0213_to_ucs4(c1 | (set == JISX0213_2_set ? 0x0200 : 0x0100), c2);
+    if (ch == 0)
+      return 0;
+    if (ch < 0x80) {
+      len = 2;
+      out[0] = __jisx0213_to_ucs_combining[ch - 1][0];
+      out[1] = __jisx0213_to_ucs_combining[ch - 1][1];
+    } else
+      *out = ch;
+    return len;
+
+  case MOSAIC_A_set:
+  case MOSAIC_B_set:
+  case MOSAIC_C_set:
+  case MOSAIC_D_set:
+  case DRCS0_set:
+  case MACRO_set:
+    *out = __UNKNOWN_10646_CHAR;
+    return 1;
+
+  default:
+    break;
+  }
+
+  return 0;
+}
+
+#define BODY \
+  {									      \
+    uint32_t ch = *inptr;						      \
+									      \
+    if (ch == 0) {\
+      st.mode = NORMAL;\
+      ++ inptr;\
+      continue;\
+    }\
+    if (__glibc_unlikely (st.mode == CTRL_SEQ)) {\
+      if (st.skip) {\
+        --st.skip;\
+        if (st.skip == 0)\
+          st.mode = NORMAL;\
+        if (ch < 0x40 || ch > 0x7f)\
+          STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      } else if (st.prev == MACRO_CTRL) {\
+        if (ch == MACRO_CTRL) \
+          st.skip = 1;\
+        else if (ch == LF || ch == CR) {\
+          st = def_state_from;\
+          put32(outptr, ch);\
+          outptr += 4;\
+        }\
+      } else if (st.prev == CSI && (ch == 0x5b || ch == 0x5c || ch == 0x6f))\
+        st.mode = NORMAL;\
+      else if (st.prev == TIME || st.prev == CSI) {\
+        if (ch == 0x20 || (st.prev == TIME && ch == 0x28))\
+          st.skip = 1;\
+        else if (!((st.prev == TIME && ch == 0x29) ||\
+                      ch == 0x3b || (ch >= 0x30 && ch <= 0x39))) {\
+          st.mode = NORMAL;\
+          STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+        }\
+      } else if (st.prev == COL || st.prev == CDC) {\
+        if (ch == 0x20) \
+          st.skip = 1;\
+        else {\
+          st.mode = NORMAL;\
+          if (ch < 0x40 || ch > 0x7f)\
+            STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+        }\
+      }\
+      ++ inptr;\
+      continue;\
+    }\
+									      \
+    if (__glibc_unlikely (ch == LF || ch == CR)) {\
+      st = def_state_from;\
+      put32(outptr, ch);\
+      outptr += 4;\
+      ++ inptr;\
+      continue;\
+    }\
+									      \
+    if (__glibc_unlikely (st.mode == ESCAPE)) {\
+      if (ch == LS2 || ch == LS3) {\
+        st.mode = NORMAL;\
+        st.gl = (ch == LS2) ? 2 : 3;\
+        st.ss = 0;\
+      } else if (ch == LS1R || ch == LS2R || ch == LS3R) {\
+        st.mode = NORMAL;\
+        st.gr = (ch == LS1R) ? 1 : (ch == LS2R) ? 2 : 3;\
+        st.ss = 0;\
+      } else if (ch == 0x24) \
+        st.mode = DESIGNATE_MB;\
+      else if (ch >= 0x28 && ch <= 0x2b) {\
+        st.mode = G_SEL_1B;\
+        st.gidx = ch - 0x28;\
+      } else {\
+        st.mode = NORMAL;\
+        STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      }\
+      ++ inptr;\
+      continue;\
+    }\
+									      \
+    if (__glibc_unlikely (st.mode == DESIGNATE_MB)) {\
+      if (ch == KANJI_set || ch == JISX0213_1_set || ch == JISX0213_2_set ||\
+          ch == EXTRA_SYMBOLS_set) {\
+        st.mode = NORMAL;\
+        st.g[0] = ch;\
+      } else if (ch >= 0x28 && ch <= 0x2b) {\
+        st.mode = G_SEL_MB;\
+        st.gidx = ch - 0x28;\
+      } else {\
+        st.mode = NORMAL;\
+        STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      }\
+      ++ inptr;\
+      continue;\
+    }\
+									      \
+    if (__glibc_unlikely (st.mode == G_SEL_1B)) {\
+      if (ch == ASCII_set || ch == ASCII_x_set || ch == JIS0201_KATA_set ||\
+          (ch >= 0x30 && ch <= 0x38)) {\
+        st.g[st.gidx] = ch;\
+        st.mode = NORMAL;\
+      } else if (ch == 0x20)\
+        st.mode = DRCS_SEL_1B;\
+      else {\
+        st.mode = NORMAL;\
+        STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      }\
+      ++ inptr;\
+      continue;\
+    }\
+									      \
+    if (__glibc_unlikely (st.mode == G_SEL_MB)) {\
+      if (ch == KANJI_set || ch == JISX0213_1_set || ch == JISX0213_2_set ||\
+          ch == EXTRA_SYMBOLS_set) {\
+        st.g[st.gidx] = ch;\
+        st.mode = NORMAL;\
+      } else if (ch == 0x20)\
+        st.mode = DRCS_SEL_MB;\
+      else {\
+        st.mode = NORMAL;\
+        STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      }\
+      ++ inptr;\
+      continue;\
+    }\
+									      \
+    if (__glibc_unlikely (st.mode == DRCS_SEL_1B)) {\
+      st.mode = NORMAL;\
+      if (ch == 0x70 || (ch >= 0x41 && ch <= 0x4f))\
+        st.g[st.gidx] = ch | 0x80;\
+      else \
+        STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      ++ inptr;\
+      continue;\
+    }\
+									      \
+    if (__glibc_unlikely (st.mode == DRCS_SEL_MB)) {\
+      st.mode = NORMAL;\
+      if (ch == 0x40)\
+        st.g[st.gidx] = ch | 0x80;\
+      else \
+        STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      ++ inptr;\
+      continue;\
+    }\
+									      \
+    if (st.mode == MB_2ND) {\
+      int gidx;\
+      int i, len;\
+      uint32_t out[MAX_NEEDED_OUTPUT];\
+									      \
+      gidx = (st.ss) ? st.ss : (ch & 0x80) ? st.gr : st.gl;\
+      st.mode = NORMAL;\
+      st.ss = 0;\
+      if (__glibc_unlikely (!(ch & 0x60))) /* C0/C1 */\
+          STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      if (__glibc_unlikely (st.ss > 0 && (ch & 0x80)))\
+          STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      if (__glibc_unlikely ((st.prev & 0x80) != (ch & 0x80)))\
+          STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      len = b24_char_conv(st.g[gidx], (st.prev & 0x7f), (ch & 0x7f), out);\
+      if (len == 0)\
+        STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+      if (outptr + 4 * len > outend) {\
+        result = __GCONV_FULL_OUTPUT;\
+	break;\
+      }\
+      for (i = 0; i < len; i++) {\
+        if (irreversible &&\
+              __builtin_expect (out[i] == __UNKNOWN_10646_CHAR, 0))\
+          ++ *irreversible;\
+        put32(outptr, out[i]);\
+        outptr += 4;\
+      }\
+      ++ inptr;\
+      continue;\
+    }\
+									      \
+    if (st.mode == NORMAL) {\
+      int gidx, set;\
+									      \
+      if (__glibc_unlikely (!(ch & 0x60))) { /* C0/C1 */\
+        if (ch == ESC)\
+          st.mode = ESCAPE;\
+        else if (ch == SS2)\
+          st.ss = 2;\
+        else if (ch == SS3)\
+          st.ss = 3;\
+        else if (ch == LS0) {\
+          st.ss = 0;\
+          st.gl = 0;\
+        } else if (ch == LS1) {\
+          st.ss = 0;\
+          st.gl = 1;\
+        } else if (ch == BEL || ch == BS) {\
+          st.ss = 0;\
+          put32(outptr, ch);\
+          outptr += 4;\
+        } else if (ch == 0x09 || ch == 0x0b || ch == 0x0c || ch == 0x18 ||\
+                   ch == 0x1e || ch == 0x1f || (ch >= 0x80 && ch <= 0x8a) ||\
+                   ch == 0x99 || ch == 0x9a) {\
+          /* do nothing. just skip */\
+        } else if (ch == 0x16 || ch == 0x8b || ch == 0x91 || ch == 0x93 ||\
+                 ch == 0x94 || ch == 0x97 || ch == 0x98) {\
+          st.mode = CTRL_SEQ;\
+          st.skip = 1;\
+        } else if (ch == 0x1c) {\
+          st.mode = CTRL_SEQ;\
+          st.skip = 2;\
+        } else if (ch == COL || ch == CDC || ch == MACRO_CTRL ||\
+                   ch == CSI ||ch == TIME) {\
+          st.mode = CTRL_SEQ;\
+          st.skip = 0;\
+          st.prev = ch;\
+        } else \
+          STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+									      \
+        ++ inptr;\
+        continue;\
+      }\
+									      \
+      if (__glibc_unlikely ((ch & 0x7f) == 0x20 || ch == 0x7f)) {\
+        st.ss = 0;\
+        put32(outptr, ch);\
+        outptr += 4;\
+        ++ inptr;\
+        continue;\
+      }\
+      if (__glibc_unlikely (ch == 0xff)) {\
+        st.ss = 0;\
+        put32(outptr, __UNKNOWN_10646_CHAR);\
+        if (irreversible)\
+          ++ *irreversible;\
+        outptr += 4;\
+        ++ inptr;\
+        continue;\
+      }\
+									      \
+      if (__glibc_unlikely (st.ss > 0 && (ch & 0x80)))\
+	STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+									      \
+      gidx = (st.ss) ? st.ss : (ch & 0x80) ? st.gr : st.gl;\
+      set = st.g[gidx];\
+      if (set == DRCS0_set || set == KANJI_set || set == JISX0213_1_set ||\
+          set == JISX0213_2_set || set == EXTRA_SYMBOLS_set) {\
+        st.mode = MB_2ND;\
+        st.prev = ch;\
+      } else {\
+        uint32_t out;\
+									      \
+        st.ss = 0;\
+        if (b24_char_conv(set, (ch & 0x7f), 0, &out) == 0)\
+          STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+        if (out == __UNKNOWN_10646_CHAR && irreversible)\
+          ++ *irreversible;\
+        put32(outptr, out);\
+        outptr += 4;\
+      }\
+      ++ inptr;\
+      continue;\
+    }\
+ }
+#include <iconv/loop.c>
+
+
+/* Now define the toplevel functions.  */
+#include <iconv/skeleton.c>
diff --git a/lib/gconv/en300-468-tab00.c b/lib/gconv/en300-468-tab00.c
new file mode 100644
index 0000000..e1417f8
--- /dev/null
+++ b/lib/gconv/en300-468-tab00.c
@@ -0,0 +1,564 @@
+/* Generic conversion to and from ETSI EN300-468 Table00.
+   Copyright (C) 1997-2014 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Ulrich Drepper <drepper@cygnus.com>, 1997.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#include <dlfcn.h>
+#include <stdint.h>
+
+/* EN300-468 Table00 := ISO_6937 + eurosign at 0xa4 */
+
+static const uint32_t to_ucs4[256] =
+{
+  /* 0x00 */ 0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0006, 0x0007,
+  /* 0x08 */ 0x0008, 0x0009, 0x000a, 0x000b, 0x000c, 0x000d, 0x000e, 0x000f,
+  /* 0x10 */ 0x0010, 0x0011, 0x0012, 0x0013, 0x0014, 0x0015, 0x0016, 0x0017,
+  /* 0x18 */ 0x0018, 0x0019, 0x001a, 0x001b, 0x001c, 0x001d, 0x001e, 0x001f,
+  /* 0x20 */ 0x0020, 0x0021, 0x0022, 0x0023, 0x0024, 0x0025, 0x0026, 0x0027,
+  /* 0x28 */ 0x0028, 0x0029, 0x002a, 0x002b, 0x002c, 0x002d, 0x002e, 0x002f,
+  /* 0x30 */ 0x0030, 0x0031, 0x0032, 0x0033, 0x0034, 0x0035, 0x0036, 0x0037,
+  /* 0x38 */ 0x0038, 0x0039, 0x003a, 0x003b, 0x003c, 0x003d, 0x003e, 0x003f,
+  /* 0x40 */ 0x0040, 0x0041, 0x0042, 0x0043, 0x0044, 0x0045, 0x0046, 0x0047,
+  /* 0x48 */ 0x0048, 0x0049, 0x004a, 0x004b, 0x004c, 0x004d, 0x004e, 0x004f,
+  /* 0x50 */ 0x0050, 0x0051, 0x0052, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057,
+  /* 0x58 */ 0x0058, 0x0059, 0x005a, 0x005b, 0x005c, 0x005d, 0x005e, 0x005f,
+  /* 0x60 */ 0x0060, 0x0061, 0x0062, 0x0063, 0x0064, 0x0065, 0x0066, 0x0067,
+  /* 0x68 */ 0x0068, 0x0069, 0x006a, 0x006b, 0x006c, 0x006d, 0x006e, 0x006f,
+  /* 0x70 */ 0x0070, 0x0071, 0x0072, 0x0073, 0x0074, 0x0075, 0x0076, 0x0077,
+  /* 0x78 */ 0x0078, 0x0079, 0x007a, 0x007b, 0x007c, 0x007d, 0x007e, 0x007f,
+  /* 0x80 */ 0x0080, 0x0081, 0x0082, 0x0083, 0x0084, 0x0085, 0x0086, 0x0087,
+  /* 0x88 */ 0x0088, 0x0089, 0x008a, 0x008b, 0x008c, 0x008d, 0x008e, 0x008f,
+  /* 0x90 */ 0x0090, 0x0091, 0x0092, 0x0093, 0x0094, 0x0095, 0x0096, 0x0097,
+  /* 0x98 */ 0x0098, 0x0099, 0x009a, 0x009b, 0x009c, 0x009d, 0x009e, 0x009f,
+  /* 0xa0 */ 0x00a0, 0x00a1, 0x00a2, 0x00a3, 0x20ac, 0x00a5, 0x0000, 0x00a7,
+  /* 0xa8 */ 0x00a4, 0x2018, 0x201c, 0x00ab, 0x2190, 0x2191, 0x2192, 0x2193,
+  /* 0xb0 */ 0x00b0, 0x00b1, 0x00b2, 0x00b3, 0x00d7, 0x00b5, 0x00b6, 0x00b7,
+  /* 0xb8 */ 0x00f7, 0x2019, 0x201d, 0x00bb, 0x00bc, 0x00bd, 0x00be, 0x00bf,
+  /* 0xc0 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+  /* 0xc8 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+  /* 0xd0 */ 0x2014, 0x00b9, 0x00ae, 0x00a9, 0x2122, 0x266a, 0x00ac, 0x00a6,
+  /* 0xd8 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x215b, 0x215c, 0x215d, 0x215e,
+  /* 0xe0 */ 0x2126, 0x00c6, 0x00d0, 0x00aa, 0x0126, 0x0000, 0x0132, 0x013f,
+  /* 0xe8 */ 0x0141, 0x00d8, 0x0152, 0x00ba, 0x00de, 0x0166, 0x014a, 0x0149,
+  /* 0xf0 */ 0x0138, 0x00e6, 0x0111, 0x00f0, 0x0127, 0x0131, 0x0133, 0x0140,
+  /* 0xf8 */ 0x0142, 0x00f8, 0x0153, 0x00df, 0x00fe, 0x0167, 0x014b, 0x00ad
+};
+
+/* The outer array range runs from 0xc1 to 0xcf, the inner range from 0x20
+   to 0x7f.  */
+static const uint32_t to_ucs4_comb[15][96] =
+{
+  /* 0xc1 */
+  {
+    /* 0x20 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x00c0, 0x0000, 0x0000, 0x0000, 0x00c8, 0x0000, 0x0000,
+    /* 0x48 */ 0x0000, 0x00cc, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x00d2,
+    /* 0x50 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x00d9, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x00e0, 0x0000, 0x0000, 0x0000, 0x00e8, 0x0000, 0x0000,
+    /* 0x68 */ 0x0000, 0x00ec, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x00f2,
+    /* 0x70 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x00f9, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xc2 */
+  {
+    /* 0x20 */ 0x00b4, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x00c1, 0x0000, 0x0106, 0x0000, 0x00c9, 0x0000, 0x0000,
+    /* 0x48 */ 0x0000, 0x00cd, 0x0000, 0x0000, 0x0139, 0x0000, 0x0143, 0x00d3,
+    /* 0x50 */ 0x0000, 0x0000, 0x0154, 0x015a, 0x0000, 0x00da, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x00dd, 0x0179, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x00e1, 0x0000, 0x0107, 0x0000, 0x00e9, 0x0000, 0x0000,
+    /* 0x68 */ 0x0000, 0x00ed, 0x0000, 0x0000, 0x013a, 0x0000, 0x0144, 0x00f3,
+    /* 0x70 */ 0x0000, 0x0000, 0x0155, 0x015b, 0x0000, 0x00fa, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x00fd, 0x017a, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xc3 */
+  {
+    /* 0x20 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x00c2, 0x0000, 0x0108, 0x0000, 0x00ca, 0x0000, 0x011c,
+    /* 0x48 */ 0x0124, 0x00ce, 0x0134, 0x0000, 0x0000, 0x0000, 0x0000, 0x00d4,
+    /* 0x50 */ 0x0000, 0x0000, 0x0000, 0x015c, 0x0000, 0x00db, 0x0000, 0x0174,
+    /* 0x58 */ 0x0000, 0x0176, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x00e2, 0x0000, 0x0109, 0x0000, 0x00ea, 0x0000, 0x011d,
+    /* 0x68 */ 0x0125, 0x00ee, 0x0135, 0x0000, 0x0000, 0x0000, 0x0000, 0x00f4,
+    /* 0x70 */ 0x0000, 0x0000, 0x0000, 0x015d, 0x0000, 0x00fb, 0x0000, 0x0175,
+    /* 0x78 */ 0x0000, 0x0177, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xc4 */
+  {
+    /* 0x20 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x00c3, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x48 */ 0x0000, 0x0128, 0x0000, 0x0000, 0x0000, 0x0000, 0x00d1, 0x00d5,
+    /* 0x50 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0168, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x00e3, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x68 */ 0x0000, 0x0129, 0x0000, 0x0000, 0x0000, 0x0000, 0x00f1, 0x00f5,
+    /* 0x70 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0169, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xc5 */
+  {
+    /* 0x20 */ 0x00af, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x0100, 0x0000, 0x0000, 0x0000, 0x0112, 0x0000, 0x0000,
+    /* 0x48 */ 0x0000, 0x012a, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x014c,
+    /* 0x50 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x016a, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x0101, 0x0000, 0x0000, 0x0000, 0x0113, 0x0000, 0x0000,
+    /* 0x68 */ 0x0000, 0x012b, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x014d,
+    /* 0x70 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x016b, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xc6 */
+  {
+    /* 0x20 */ 0x02d8, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x0102, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x011e,
+    /* 0x48 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x50 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x016c, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x0103, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x011f,
+    /* 0x68 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x70 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x016d, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xc7 */
+  {
+    /* 0x20 */ 0x02d9, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x0000, 0x0000, 0x010a, 0x0000, 0x0116, 0x0000, 0x0120,
+    /* 0x48 */ 0x0000, 0x0130, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x50 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0000, 0x017b, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x0000, 0x0000, 0x010b, 0x0000, 0x0117, 0x0000, 0x0121,
+    /* 0x68 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x70 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x0000, 0x017c, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xc8 */
+  {
+    /* 0x20 */ 0x00a8, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x00c4, 0x0000, 0x0000, 0x0000, 0x00cb, 0x0000, 0x0000,
+    /* 0x48 */ 0x0000, 0x00cf, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x00d6,
+    /* 0x50 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x00dc, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0178, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x00e4, 0x0000, 0x0000, 0x0000, 0x00eb, 0x0000, 0x0000,
+    /* 0x68 */ 0x0000, 0x00ef, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x00f6,
+    /* 0x70 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x00fc, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x00ff, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xc9 */
+  {
+    0x0000,
+  },
+  /* 0xca */
+  {
+    /* 0x20 */ 0x02da, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x00c5, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x48 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x50 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x016e, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x00e5, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x68 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x70 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x016f, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xcb */
+  {
+    /* 0x20 */ 0x00b8, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x0000, 0x0000, 0x00c7, 0x0000, 0x0000, 0x0000, 0x0122,
+    /* 0x48 */ 0x0000, 0x0000, 0x0000, 0x0136, 0x013b, 0x0000, 0x0145, 0x0000,
+    /* 0x50 */ 0x0000, 0x0000, 0x0156, 0x015e, 0x0162, 0x0000, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x0000, 0x0000, 0x00e7, 0x0000, 0x0000, 0x0000, 0x0123,
+    /* 0x68 */ 0x0000, 0x0000, 0x0000, 0x0137, 0x013c, 0x0000, 0x0146, 0x0000,
+    /* 0x70 */ 0x0000, 0x0000, 0x0157, 0x015f, 0x0163, 0x0000, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xcc */
+  {
+    0x0000,
+  },
+  /* 0xcd */
+  {
+    /* 0x20 */ 0x02dd, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x48 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0150,
+    /* 0x50 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0170, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x68 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0151,
+    /* 0x70 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0171, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xce */
+  {
+    /* 0x20 */ 0x02db, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x0104, 0x0000, 0x0000, 0x0000, 0x0118, 0x0000, 0x0000,
+    /* 0x48 */ 0x0000, 0x012e, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x50 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0172, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x0105, 0x0000, 0x0000, 0x0000, 0x0119, 0x0000, 0x0000,
+    /* 0x68 */ 0x0000, 0x012f, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x70 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0173, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  },
+  /* 0xcf */
+  {
+    /* 0x20 */ 0x02c7, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x28 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x30 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x38 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x40 */ 0x0000, 0x0000, 0x0000, 0x010c, 0x010e, 0x011a, 0x0000, 0x0000,
+    /* 0x48 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x013d, 0x0000, 0x0147, 0x0000,
+    /* 0x50 */ 0x0000, 0x0000, 0x0158, 0x0160, 0x0164, 0x0000, 0x0000, 0x0000,
+    /* 0x58 */ 0x0000, 0x0000, 0x017d, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+    /* 0x60 */ 0x0000, 0x0000, 0x0000, 0x010d, 0x010f, 0x011b, 0x0000, 0x0000,
+    /* 0x68 */ 0x0000, 0x0000, 0x0000, 0x0000, 0x013e, 0x0000, 0x0148, 0x0000,
+    /* 0x70 */ 0x0000, 0x0000, 0x0159, 0x0161, 0x0165, 0x0000, 0x0000, 0x0000,
+    /* 0x78 */ 0x0000, 0x0000, 0x017e, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
+  }
+};
+
+
+static const char from_ucs4[][2] =
+{
+  /* 0x0000 */ "\x00\x00", "\x01\x00", "\x02\x00", "\x03\x00", "\x04\x00",
+  /* 0x0005 */ "\x05\x00", "\x06\x00", "\x07\x00", "\x08\x00", "\x09\x00",
+  /* 0x000a */ "\x0a\x00", "\x0b\x00", "\x0c\x00", "\x0d\x00", "\x0e\x00",
+  /* 0x000f */ "\x0f\x00", "\x10\x00", "\x11\x00", "\x12\x00", "\x13\x00",
+  /* 0x0014 */ "\x14\x00", "\x15\x00", "\x16\x00", "\x17\x00", "\x18\x00",
+  /* 0x0019 */ "\x19\x00", "\x1a\x00", "\x1b\x00", "\x1c\x00", "\x1d\x00",
+  /* 0x001e */ "\x1e\x00", "\x1f\x00", "\x20\x00", "\x21\x00", "\x22\x00",
+  /* 0x0023 */ "\x23\x00", "\x24\x00", "\x25\x00", "\x26\x00", "\x27\x00",
+  /* 0x0028 */ "\x28\x00", "\x29\x00", "\x2a\x00", "\x2b\x00", "\x2c\x00",
+  /* 0x002d */ "\x2d\x00", "\x2e\x00", "\x2f\x00", "\x30\x00", "\x31\x00",
+  /* 0x0032 */ "\x32\x00", "\x33\x00", "\x34\x00", "\x35\x00", "\x36\x00",
+  /* 0x0037 */ "\x37\x00", "\x38\x00", "\x39\x00", "\x3a\x00", "\x3b\x00",
+  /* 0x003c */ "\x3c\x00", "\x3d\x00", "\x3e\x00", "\x3f\x00", "\x40\x00",
+  /* 0x0041 */ "\x41\x00", "\x42\x00", "\x43\x00", "\x44\x00", "\x45\x00",
+  /* 0x0046 */ "\x46\x00", "\x47\x00", "\x48\x00", "\x49\x00", "\x4a\x00",
+  /* 0x004b */ "\x4b\x00", "\x4c\x00", "\x4d\x00", "\x4e\x00", "\x4f\x00",
+  /* 0x0050 */ "\x50\x00", "\x51\x00", "\x52\x00", "\x53\x00", "\x54\x00",
+  /* 0x0055 */ "\x55\x00", "\x56\x00", "\x57\x00", "\x58\x00", "\x59\x00",
+  /* 0x005a */ "\x5a\x00", "\x5b\x00", "\x5c\x00", "\x5d\x00", "\x5e\x00",
+  /* 0x005f */ "\x5f\x00", "\x60\x00", "\x61\x00", "\x62\x00", "\x63\x00",
+  /* 0x0064 */ "\x64\x00", "\x65\x00", "\x66\x00", "\x67\x00", "\x68\x00",
+  /* 0x0069 */ "\x69\x00", "\x6a\x00", "\x6b\x00", "\x6c\x00", "\x6d\x00",
+  /* 0x006e */ "\x6e\x00", "\x6f\x00", "\x70\x00", "\x71\x00", "\x72\x00",
+  /* 0x0073 */ "\x73\x00", "\x74\x00", "\x75\x00", "\x76\x00", "\x77\x00",
+  /* 0x0078 */ "\x78\x00", "\x79\x00", "\x7a\x00", "\x7b\x00", "\x7c\x00",
+  /* 0x007d */ "\x7d\x00", "\x7e\x00", "\x7f\x00", "\x80\x00", "\x81\x00",
+  /* 0x0082 */ "\x82\x00", "\x83\x00", "\x84\x00", "\x85\x00", "\x86\x00",
+  /* 0x0087 */ "\x87\x00", "\x88\x00", "\x89\x00", "\x8a\x00", "\x8b\x00",
+  /* 0x008c */ "\x8c\x00", "\x8d\x00", "\x8e\x00", "\x8f\x00", "\x90\x00",
+  /* 0x0091 */ "\x91\x00", "\x92\x00", "\x93\x00", "\x94\x00", "\x95\x00",
+  /* 0x0096 */ "\x96\x00", "\x97\x00", "\x98\x00", "\x99\x00", "\x9a\x00",
+  /* 0x009b */ "\x9b\x00", "\x9c\x00", "\x9d\x00", "\x9e\x00", "\x9f\x00",
+  /* 0x00a0 */ "\xa0\x00", "\xa1\x00", "\xa2\x00", "\xa3\x00", "\xa8\x00",
+  /* 0x00a5 */ "\xa5\x00", "\xd7\x00", "\xa7\x00", "\xc8\x20", "\xd3\x00",
+  /* 0x00aa */ "\xe3\x00", "\xab\x00", "\xd6\x00", "\xff\x00", "\xd2\x00",
+  /* 0x00af */ "\xc5\x20", "\xb0\x00", "\xb1\x00", "\xb2\x00", "\xb3\x00",
+  /* 0x00b4 */ "\xc2\x20", "\xb5\x00", "\xb6\x00", "\xb7\x00", "\xcb\x20",
+  /* 0x00b9 */ "\xd1\x00", "\xeb\x00", "\xbb\x00", "\xbc\x00", "\xbd\x00",
+  /* 0x00be */ "\xbe\x00", "\xbf\x00", "\xc1\x41", "\xc2\x41", "\xc3\x41",
+  /* 0x00c3 */ "\xc4\x41", "\xc8\x41", "\xca\x41", "\xe1\x00", "\xcb\x43",
+  /* 0x00c8 */ "\xc1\x45", "\xc2\x45", "\xc3\x45", "\xc8\x45", "\xc1\x49",
+  /* 0x00cd */ "\xc2\x49", "\xc3\x49", "\xc8\x49", "\xe2\x00", "\xc4\x4e",
+  /* 0x00d2 */ "\xc1\x4f", "\xc2\x4f", "\xc3\x4f", "\xc4\x4f", "\xc8\x4f",
+  /* 0x00d7 */ "\xb4\x00", "\xe9\x00", "\xc1\x55", "\xc2\x55", "\xc3\x55",
+  /* 0x00dc */ "\xc8\x55", "\xc2\x59", "\xec\x00", "\xfb\x00", "\xc1\x61",
+  /* 0x00e1 */ "\xc2\x61", "\xc3\x61", "\xc4\x61", "\xc8\x61", "\xca\x61",
+  /* 0x00e6 */ "\xf1\x00", "\xcb\x63", "\xc1\x65", "\xc2\x65", "\xc3\x65",
+  /* 0x00eb */ "\xc8\x65", "\xc1\x69", "\xc2\x69", "\xc3\x69", "\xc8\x69",
+  /* 0x00f0 */ "\xf3\x00", "\xc4\x6e", "\xc1\x6f", "\xc2\x6f", "\xc3\x6f",
+  /* 0x00f5 */ "\xc4\x6f", "\xc8\x6f", "\xb8\x00", "\xf9\x00", "\xc1\x75",
+  /* 0x00fa */ "\xc2\x75", "\xc3\x75", "\xc8\x75", "\xc2\x79", "\xfc\x00",
+  /* 0x00ff */ "\xc8\x79", "\xc5\x41", "\xc5\x61", "\xc6\x41", "\xc6\x61",
+  /* 0x0104 */ "\xce\x41", "\xce\x61", "\xc2\x43", "\xc2\x63", "\xc3\x43",
+  /* 0x0109 */ "\xc3\x63", "\xc7\x43", "\xc7\x63", "\xcf\x43", "\xcf\x63",
+  /* 0x010e */ "\xcf\x44", "\xcf\x64", "\x00\x00", "\xf2\x00", "\xc5\x45",
+  /* 0x0113 */ "\xc5\x65", "\x00\x00", "\x00\x00", "\xc7\x45", "\xc7\x65",
+  /* 0x0118 */ "\xce\x45", "\xce\x65", "\xcf\x45", "\xcf\x65", "\xc3\x47",
+  /* 0x011d */ "\xc3\x67", "\xc6\x47", "\xc6\x67", "\xc7\x47", "\xc7\x67",
+  /* 0x0122 */ "\xcb\x47", "\xcb\x67", "\xc3\x48", "\xc3\x68", "\xe4\x00",
+  /* 0x0127 */ "\xf4\x00", "\xc4\x49", "\xc4\x69", "\xc5\x49", "\xc5\x69",
+  /* 0x012c */ "\x00\x00", "\x00\x00", "\xce\x49", "\xce\x69", "\xc7\x49",
+  /* 0x0131 */ "\xf5\x00", "\xe6\x00", "\xf6\x00", "\xc3\x4a", "\xc3\x6a",
+  /* 0x0136 */ "\xcb\x4b", "\xcb\x6b", "\xf0\x00", "\xc2\x4c", "\xc2\x6c",
+  /* 0x013b */ "\xcb\x4c", "\xcb\x6c", "\xcf\x4c", "\xcf\x6c", "\xe7\x00",
+  /* 0x0140 */ "\xf7\x00", "\xe8\x00", "\xf8\x00", "\xc2\x4e", "\xc2\x6e",
+  /* 0x0145 */ "\xcb\x4e", "\xcb\x6e", "\xcf\x4e", "\xcf\x6e", "\xef\x00",
+  /* 0x014a */ "\xee\x00", "\xfe\x00", "\xc5\x4f", "\xc5\x6f", "\x00\x00",
+  /* 0x014f */ "\x00\x00", "\xcd\x4f", "\xcd\x6f", "\xea\x00", "\xfa\x00",
+  /* 0x0154 */ "\xc2\x52", "\xc2\x72", "\xcb\x52", "\xcb\x72", "\xcf\x52",
+  /* 0x0159 */ "\xcf\x72", "\xc2\x53", "\xc2\x73", "\xc3\x53", "\xc3\x73",
+  /* 0x015e */ "\xcb\x53", "\xcb\x73", "\xcf\x53", "\xcf\x73", "\xcb\x54",
+  /* 0x0163 */ "\xcb\x74", "\xcf\x54", "\xcf\x74", "\xed\x00", "\xfd\x00",
+  /* 0x0168 */ "\xc4\x55", "\xc4\x75", "\xc5\x55", "\xc5\x75", "\xc6\x55",
+  /* 0x016d */ "\xc6\x75", "\xca\x55", "\xca\x75", "\xcd\x55", "\xcd\x75",
+  /* 0x0172 */ "\xce\x55", "\xce\x75", "\xc3\x57", "\xc3\x77", "\xc3\x59",
+  /* 0x0177 */ "\xc3\x79", "\xc8\x59", "\xc2\x5a", "\xc2\x7a", "\xc7\x5a",
+  /* 0x017c */ "\xc7\x7a", "\xcf\x5a", "\xcf\x7a"
+/*
+   This table does not cover the following positions:
+
+     0x02c7    "\xcf\x20",
+     ...
+     0x02d8    "\xc6\x20", "\xc7\x20", "\xca\x20", "\xce\x20", "\x00\x00",
+     0x02dd    "\xcd\x20",
+     ...
+     0x2014    "\xd0\x00", "\x00\x00", "\x00\x00", "\x00\x00", "\xa9\x00",
+     0x2019    "\xb9\x00", "\x00\x00", "\x00\x00", "\xaa\x00", "\xba\x00",
+     0x201e    "\x00\x00", "\x00\x00", "\x00\x00", "\x00\x00", "\xd4\x00",
+     0x20ac    "\xa4\x00",
+     0x2123    "\x00\x00", "\x00\x00", "\x00\x00", "\xe0\x00", "\x00\x00",
+     ...
+     0x215b    "\xdc\x00", "\xdd\x00", "\xde\x00"
+     ...
+     0x2190    "\xac\x00", "\xad\x00", "\xae\x00", "\xaf\x00",
+     ...
+     0x266a    "\xd5\x00"
+
+   These would blow up the table and are therefore handled specially in
+   the code.
+*/
+};
+
+
+/* Definitions used in the body of the `gconv' function.  */
+#define CHARSET_NAME		"ISO_6937//"
+#define FROM_LOOP		from_iso6937
+#define TO_LOOP			to_iso6937
+#define DEFINE_INIT		1
+#define DEFINE_FINI		1
+#define MIN_NEEDED_FROM		1
+#define MAX_NEEDED_FROM		2
+#define MIN_NEEDED_TO		4
+#define ONE_DIRECTION		0
+
+
+/* First define the conversion function from ISO 6937 to UCS4.  */
+#define MIN_NEEDED_INPUT	MIN_NEEDED_FROM
+#define MAX_NEEDED_INPUT	MAX_NEEDED_FROM
+#define MIN_NEEDED_OUTPUT	MIN_NEEDED_TO
+#define LOOPFCT			FROM_LOOP
+#define BODY \
+  {									      \
+    uint32_t ch = *inptr;						      \
+									      \
+    if (__builtin_expect (ch >= 0xc1, 0) && ch <= 0xcf)			      \
+      {									      \
+	/* Composed character.  First test whether the next byte	      \
+	   is also available.  */					      \
+	int ch2;							      \
+									      \
+	if (__glibc_unlikely (inptr + 1 >= inend))			      \
+	  {								      \
+	    /* The second character is not available.  Store the	      \
+	       intermediate result.  */					      \
+	    result = __GCONV_INCOMPLETE_INPUT;				      \
+	    break;							      \
+	  }								      \
+									      \
+	ch2 = inptr[1];							      \
+									      \
+	if (__builtin_expect (ch2 < 0x20, 0)				      \
+	    || __builtin_expect (ch2 >= 0x80, 0))			      \
+	  {								      \
+	    /* This is illegal.  */					      \
+	    STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+	  }								      \
+									      \
+	ch = to_ucs4_comb[ch - 0xc1][ch2 - 0x20];			      \
+									      \
+	if (__glibc_unlikely (ch == 0))					      \
+	  {								      \
+	    /* Illegal character.  */					      \
+	    STANDARD_FROM_LOOP_ERR_HANDLER (2);				      \
+	  }								      \
+									      \
+	inptr += 2;							      \
+      }									      \
+    else								      \
+      {									      \
+	ch = to_ucs4[ch];						      \
+									      \
+	if (__builtin_expect (ch == 0, 0) && *inptr != '\0')		      \
+	  {								      \
+	    /* This is an illegal character.  */			      \
+	    STANDARD_FROM_LOOP_ERR_HANDLER (1);				      \
+	  }								      \
+	++inptr;							      \
+      }									      \
+									      \
+    put32 (outptr, ch);							      \
+    outptr += 4;							      \
+  }
+#define LOOP_NEED_FLAGS
+#define ONEBYTE_BODY \
+  {									      \
+    uint32_t ch = to_ucs4[c];						      \
+    if (ch == 0 && c != '\0')						      \
+      return WEOF;							      \
+    return ch;								      \
+  }
+#include <iconv/loop.c>
+
+
+/* Next, define the other direction.  */
+#define MIN_NEEDED_INPUT	MIN_NEEDED_TO
+#define MIN_NEEDED_OUTPUT	MIN_NEEDED_FROM
+#define MAX_NEEDED_OUTPUT	MAX_NEEDED_FROM
+#define LOOPFCT			TO_LOOP
+#define BODY \
+  {									      \
+    char tmp[2];							      \
+    uint32_t ch = get32 (inptr);					      \
+    const char *cp;							      \
+									      \
+    if (__builtin_expect (ch >= sizeof (from_ucs4) / sizeof (from_ucs4[0]),   \
+			  0))						      \
+      {									      \
+	int fail = 0;							      \
+	switch (ch)							      \
+	  {								      \
+	  case 0x2c7:							      \
+	    cp = "\xcf\x20";						      \
+	    break;							      \
+	  case 0x2d8 ... 0x2db:						      \
+	  case 0x2dd:							      \
+	    {								      \
+	      static const char map[6] = "\xc6\xc7\xca\xce\x00\xcd";	      \
+									      \
+	      tmp[0] = map[ch - 0x2d8];					      \
+	      tmp[1] = ' ';						      \
+	      cp = tmp;							      \
+	    }								      \
+	    break;							      \
+	  case 0x2014:							      \
+	    cp = "\xd0";						      \
+	    break;							      \
+	  case 0x2018:							      \
+	    cp = "\xa9";						      \
+	    break;							      \
+	  case 0x2019:							      \
+	    cp = "\xb9";						      \
+	    break;							      \
+	  case 0x201c:							      \
+	    cp = "\xaa";						      \
+	    break;							      \
+	  case 0x201d:							      \
+	    cp = "\xba";						      \
+	    break;							      \
+	  case 0x2122:							      \
+	    cp = "\xd4";						      \
+	    break;							      \
+	  case 0x2126:							      \
+	    cp = "\xe0";						      \
+	    break;							      \
+	  case 0x215b ... 0x215e:					      \
+	    tmp[0] = 0xdc + (ch - 0x215b);				      \
+	    tmp[1] = '\0';						      \
+	    cp = tmp;							      \
+	    break;							      \
+	  case 0x2190 ... 0x2193:					      \
+	    tmp[0] = 0xac + (ch - 0x2190);				      \
+	    tmp[1] = '\0';						      \
+	    cp = tmp;							      \
+	    break;							      \
+	  case 0x20ac:							      \
+	    cp = "\xa4";						      \
+	    break;							      \
+	  case 0x266a:							      \
+	    cp = "\xd5";						      \
+	    break;							      \
+	  default:							      \
+	    UNICODE_TAG_HANDLER (ch, 4);				      \
+	    cp = NULL;							      \
+	    fail = 1;							      \
+	  }								      \
+									      \
+	if (__glibc_unlikely (fail))					      \
+	  {								      \
+	    /* Illegal characters.  */					      \
+	    STANDARD_TO_LOOP_ERR_HANDLER (4);				      \
+	  }								      \
+      }									      \
+    else if (__builtin_expect (from_ucs4[ch][0] == '\0', 0) && ch != 0)	      \
+      {									      \
+	/* Illegal characters.  */					      \
+	STANDARD_TO_LOOP_ERR_HANDLER (4);				      \
+      }									      \
+    else								      \
+      cp = from_ucs4[ch];						      \
+									      \
+    *outptr++ = cp[0];							      \
+    /* Now test for a possible second byte and write this if possible.  */    \
+    if (cp[1] != '\0')							      \
+      {									      \
+	if (__glibc_unlikely (outptr >= outend))			      \
+	  {								      \
+	    /* The result does not fit into the buffer.  */		      \
+	    --outptr;							      \
+	    result = __GCONV_FULL_OUTPUT;				      \
+	    break;							      \
+	  }								      \
+	*outptr++ = cp[1];						      \
+      }									      \
+									      \
+    inptr += 4;								      \
+  }
+#define LOOP_NEED_FLAGS
+#include <iconv/loop.c>
+
+
+/* Now define the toplevel functions.  */
+#include <iconv/skeleton.c>
diff --git a/lib/gconv/gconv-modules b/lib/gconv/gconv-modules
new file mode 100644
index 0000000..c6ebbed
--- /dev/null
+++ b/lib/gconv/gconv-modules
@@ -0,0 +1,7 @@
+#	from			to			module		cost
+alias	ARIB-B24//		ARIB-STD-B24//
+module	ARIB-STD-B24//		INTERNAL		ARIB-STD-B24	1
+
+#	from			to			module		cost
+module	EN300-468-TAB00//	INTERNAL		EN300-468-TAB00 1
+module	INTERNAL		EN300-468-TAB00//	EN300-468-TAB00 1
diff --git a/lib/gconv/gconv.map b/lib/gconv/gconv.map
new file mode 100644
index 0000000..874208c
--- /dev/null
+++ b/lib/gconv/gconv.map
@@ -0,0 +1,8 @@
+{
+global:
+  gconv;
+  gconv_end;
+  gconv_init;
+local:
+  *;
+};
diff --git a/lib/gconv/iconv/loop.c b/lib/gconv/iconv/loop.c
new file mode 100644
index 0000000..a480c0c
--- /dev/null
+++ b/lib/gconv/iconv/loop.c
@@ -0,0 +1,523 @@
+/* Conversion loop frame work.
+   Copyright (C) 1998-2014 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Ulrich Drepper <drepper@cygnus.com>, 1998.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+/* This file provides a frame for the reader loop in all conversion modules.
+   The actual code must (of course) be provided in the actual module source
+   code but certain actions can be written down generically, with some
+   customization options which are these:
+
+     MIN_NEEDED_INPUT	minimal number of input bytes needed for the next
+			conversion.
+     MIN_NEEDED_OUTPUT	minimal number of bytes produced by the next round
+			of conversion.
+
+     MAX_NEEDED_INPUT	you guess it, this is the maximal number of input
+			bytes needed.  It defaults to MIN_NEEDED_INPUT
+     MAX_NEEDED_OUTPUT	likewise for output bytes.
+
+     LOOPFCT		name of the function created.  If not specified
+			the name is `loop' but this prevents the use
+			of multiple functions in the same file.
+
+     BODY		this is supposed to expand to the body of the loop.
+			The user must provide this.
+
+     EXTRA_LOOP_DECLS	extra arguments passed from conversion loop call.
+
+     INIT_PARAMS	code to define and initialize variables from params.
+     UPDATE_PARAMS	code to store result in params.
+
+     ONEBYTE_BODY	body of the specialized conversion function for a
+			single byte from the current character set to INTERNAL.
+*/
+
+#include <assert.h>
+#include <endian.h>
+#include <gconv.h>
+#include <stdint.h>
+#include <string.h>
+#include <wchar.h>
+#include <sys/param.h>		/* For MIN.  */
+#define __need_size_t
+#include <stddef.h>
+
+
+/* We have to provide support for machines which are not able to handled
+   unaligned memory accesses.  Some of the character encodings have
+   representations with a fixed width of 2 or 4 bytes.  But if we cannot
+   access unaligned memory we still have to read byte-wise.  */
+#undef FCTNAME2
+#if _STRING_ARCH_unaligned || !defined DEFINE_UNALIGNED
+/* We can handle unaligned memory access.  */
+# define get16(addr) *((const uint16_t *) (addr))
+# define get32(addr) *((const uint32_t *) (addr))
+
+/* We need no special support for writing values either.  */
+# define put16(addr, val) *((uint16_t *) (addr)) = (val)
+# define put32(addr, val) *((uint32_t *) (addr)) = (val)
+
+# define FCTNAME2(name) name
+#else
+/* Distinguish between big endian and little endian.  */
+# if __BYTE_ORDER == __LITTLE_ENDIAN
+#  define get16(addr) \
+     (((const unsigned char *) (addr))[1] << 8				      \
+      | ((const unsigned char *) (addr))[0])
+#  define get32(addr) \
+     (((((const unsigned char *) (addr))[3] << 8			      \
+	| ((const unsigned char *) (addr))[2]) << 8			      \
+       | ((const unsigned char *) (addr))[1]) << 8			      \
+      | ((const unsigned char *) (addr))[0])
+
+#  define put16(addr, val) \
+     ({ uint16_t __val = (val);						      \
+	((unsigned char *) (addr))[0] = __val;				      \
+	((unsigned char *) (addr))[1] = __val >> 8;			      \
+	(void) 0; })
+#  define put32(addr, val) \
+     ({ uint32_t __val = (val);						      \
+	((unsigned char *) (addr))[0] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[1] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[2] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[3] = __val;				      \
+	(void) 0; })
+# else
+#  define get16(addr) \
+     (((const unsigned char *) (addr))[0] << 8				      \
+      | ((const unsigned char *) (addr))[1])
+#  define get32(addr) \
+     (((((const unsigned char *) (addr))[0] << 8			      \
+	| ((const unsigned char *) (addr))[1]) << 8			      \
+       | ((const unsigned char *) (addr))[2]) << 8			      \
+      | ((const unsigned char *) (addr))[3])
+
+#  define put16(addr, val) \
+     ({ uint16_t __val = (val);						      \
+	((unsigned char *) (addr))[1] = __val;				      \
+	((unsigned char *) (addr))[0] = __val >> 8;			      \
+	(void) 0; })
+#  define put32(addr, val) \
+     ({ uint32_t __val = (val);						      \
+	((unsigned char *) (addr))[3] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[2] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[1] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[0] = __val;				      \
+	(void) 0; })
+# endif
+
+# define FCTNAME2(name) name##_unaligned
+#endif
+#define FCTNAME(name) FCTNAME2(name)
+
+
+/* We need at least one byte for the next round.  */
+#ifndef MIN_NEEDED_INPUT
+# error "MIN_NEEDED_INPUT definition missing"
+#elif MIN_NEEDED_INPUT < 1
+# error "MIN_NEEDED_INPUT must be >= 1"
+#endif
+
+/* Let's see how many bytes we produce.  */
+#ifndef MAX_NEEDED_INPUT
+# define MAX_NEEDED_INPUT	MIN_NEEDED_INPUT
+#endif
+
+/* We produce at least one byte in the next round.  */
+#ifndef MIN_NEEDED_OUTPUT
+# error "MIN_NEEDED_OUTPUT definition missing"
+#elif MIN_NEEDED_OUTPUT < 1
+# error "MIN_NEEDED_OUTPUT must be >= 1"
+#endif
+
+/* Let's see how many bytes we produce.  */
+#ifndef MAX_NEEDED_OUTPUT
+# define MAX_NEEDED_OUTPUT	MIN_NEEDED_OUTPUT
+#endif
+
+/* Default name for the function.  */
+#ifndef LOOPFCT
+# define LOOPFCT		loop
+#endif
+
+/* Make sure we have a loop body.  */
+#ifndef BODY
+# error "Definition of BODY missing for function" LOOPFCT
+#endif
+
+
+/* If no arguments have to passed to the loop function define the macro
+   as empty.  */
+#ifndef EXTRA_LOOP_DECLS
+# define EXTRA_LOOP_DECLS
+#endif
+
+/* Allow using UPDATE_PARAMS in macros where #ifdef UPDATE_PARAMS test
+   isn't possible.  */
+#ifndef UPDATE_PARAMS
+# define UPDATE_PARAMS do { } while (0)
+#endif
+#ifndef REINIT_PARAMS
+# define REINIT_PARAMS do { } while (0)
+#endif
+
+
+/* To make it easier for the writers of the modules, we define a macro
+   to test whether we have to ignore errors.  */
+#define ignore_errors_p() \
+  (irreversible != NULL && (flags & __GCONV_IGNORE_ERRORS))
+
+
+/* Error handling for the FROM_LOOP direction, with ignoring of errors.
+   Note that we cannot use the do while (0) trick since `break' and
+   `continue' must reach certain points.  */
+#define STANDARD_FROM_LOOP_ERR_HANDLER(Incr) \
+  {									      \
+    result = __GCONV_ILLEGAL_INPUT;					      \
+									      \
+    if (! ignore_errors_p ())						      \
+      break;								      \
+									      \
+    /* We ignore the invalid input byte sequence.  */			      \
+    inptr += (Incr);							      \
+    ++*irreversible;							      \
+    /* But we keep result == __GCONV_ILLEGAL_INPUT, because of the constraint \
+       that "iconv -c" must give the same exitcode as "iconv".  */	      \
+    continue;								      \
+  }
+
+/* Error handling for the TO_LOOP direction, with use of transliteration/
+   transcription functions and ignoring of errors.  Note that we cannot use
+   the do while (0) trick since `break' and `continue' must reach certain
+   points.  */
+#define STANDARD_TO_LOOP_ERR_HANDLER(Incr) \
+  {									      \
+    struct __gconv_trans_data *trans;					      \
+									      \
+    result = __GCONV_ILLEGAL_INPUT;					      \
+									      \
+    if (irreversible == NULL)						      \
+      /* This means we are in call from __gconv_transliterate.  In this	      \
+	 case we are not doing any error recovery outself.  */		      \
+      break;								      \
+									      \
+    /* If needed, flush any conversion state, so that __gconv_transliterate   \
+       starts with current shift state.  */				      \
+    UPDATE_PARAMS;							      \
+									      \
+    /* First try the transliteration methods.  */			      \
+    for (trans = step_data->__trans; trans != NULL; trans = trans->__next)    \
+      {									      \
+	result = DL_CALL_FCT (trans->__trans_fct,			      \
+			      (step, step_data, trans->__data, *inptrp,	      \
+			       &inptr, inend, &outptr, irreversible));	      \
+	if (result != __GCONV_ILLEGAL_INPUT)				      \
+	  break;							      \
+      }									      \
+									      \
+    REINIT_PARAMS;							      \
+									      \
+    /* If any of them recognized the input continue with the loop.  */	      \
+    if (result != __GCONV_ILLEGAL_INPUT)				      \
+      {									      \
+	if (__glibc_unlikely (result == __GCONV_FULL_OUTPUT))		      \
+	  break;							      \
+									      \
+	continue;							      \
+      }									      \
+									      \
+    /* Next see whether we have to ignore the error.  If not, stop.  */	      \
+    if (! ignore_errors_p ())						      \
+      break;								      \
+									      \
+    /* When we come here it means we ignore the character.  */		      \
+    ++*irreversible;							      \
+    inptr += Incr;							      \
+    /* But we keep result == __GCONV_ILLEGAL_INPUT, because of the constraint \
+       that "iconv -c" must give the same exitcode as "iconv".  */	      \
+    continue;								      \
+  }
+
+
+/* Handling of Unicode 3.1 TAG characters.  Unicode recommends
+   "If language codes are not relevant to the particular processing
+    operation, then they should be ignored."  This macro is usually
+   called right before  STANDARD_TO_LOOP_ERR_HANDLER (Incr).  */
+#define UNICODE_TAG_HANDLER(Character, Incr) \
+  {									      \
+    /* TAG characters are those in the range U+E0000..U+E007F.  */	      \
+    if (((Character) >> 7) == (0xe0000 >> 7))				      \
+      {									      \
+	inptr += Incr;							      \
+	continue;							      \
+      }									      \
+  }
+
+
+/* The function returns the status, as defined in gconv.h.  */
+static inline int
+__attribute ((always_inline))
+FCTNAME (LOOPFCT) (struct __gconv_step *step,
+		   struct __gconv_step_data *step_data,
+		   const unsigned char **inptrp, const unsigned char *inend,
+		   unsigned char **outptrp, const unsigned char *outend,
+		   size_t *irreversible EXTRA_LOOP_DECLS)
+{
+#ifdef LOOP_NEED_STATE
+  mbstate_t *state = step_data->__statep;
+#endif
+#ifdef LOOP_NEED_FLAGS
+  int flags = step_data->__flags;
+#endif
+#ifdef LOOP_NEED_DATA
+  void *data = step->__data;
+#endif
+  int result = __GCONV_EMPTY_INPUT;
+  const unsigned char *inptr = *inptrp;
+  unsigned char *outptr = *outptrp;
+
+#ifdef INIT_PARAMS
+  INIT_PARAMS;
+#endif
+
+  while (inptr != inend)
+    {
+      /* `if' cases for MIN_NEEDED_OUTPUT ==/!= 1 is made to help the
+	 compiler generating better code.  They will be optimized away
+	 since MIN_NEEDED_OUTPUT is always a constant.  */
+      if (MIN_NEEDED_INPUT > 1
+	  && __builtin_expect (inptr + MIN_NEEDED_INPUT > inend, 0))
+	{
+	  /* We don't have enough input for another complete input
+	     character.  */
+	  result = __GCONV_INCOMPLETE_INPUT;
+	  break;
+	}
+      if ((MIN_NEEDED_OUTPUT != 1
+	   && __builtin_expect (outptr + MIN_NEEDED_OUTPUT > outend, 0))
+	  || (MIN_NEEDED_OUTPUT == 1
+	      && __builtin_expect (outptr >= outend, 0)))
+	{
+	  /* Overflow in the output buffer.  */
+	  result = __GCONV_FULL_OUTPUT;
+	  break;
+	}
+
+      /* Here comes the body the user provides.  It can stop with
+	 RESULT set to GCONV_INCOMPLETE_INPUT (if the size of the
+	 input characters vary in size), GCONV_ILLEGAL_INPUT, or
+	 GCONV_FULL_OUTPUT (if the output characters vary in size).  */
+      BODY
+    }
+
+  /* Update the pointers pointed to by the parameters.  */
+  *inptrp = inptr;
+  *outptrp = outptr;
+  UPDATE_PARAMS;
+
+  return result;
+}
+
+
+/* Include the file a second time to define the function to handle
+   unaligned access.  */
+#if !defined DEFINE_UNALIGNED && !_STRING_ARCH_unaligned \
+    && MIN_NEEDED_INPUT != 1 && MAX_NEEDED_INPUT % MIN_NEEDED_INPUT == 0 \
+    && MIN_NEEDED_OUTPUT != 1 && MAX_NEEDED_OUTPUT % MIN_NEEDED_OUTPUT == 0
+# undef get16
+# undef get32
+# undef put16
+# undef put32
+# undef unaligned
+
+# define DEFINE_UNALIGNED
+# include "loop.c"
+# undef DEFINE_UNALIGNED
+#else
+# if MAX_NEEDED_INPUT > 1
+#  define SINGLE(fct) SINGLE2 (fct)
+#  define SINGLE2(fct) fct##_single
+static inline int
+__attribute ((always_inline))
+SINGLE(LOOPFCT) (struct __gconv_step *step,
+		 struct __gconv_step_data *step_data,
+		 const unsigned char **inptrp, const unsigned char *inend,
+		 unsigned char **outptrp, unsigned char *outend,
+		 size_t *irreversible EXTRA_LOOP_DECLS)
+{
+  mbstate_t *state = step_data->__statep;
+#  ifdef LOOP_NEED_FLAGS
+  int flags = step_data->__flags;
+#  endif
+#  ifdef LOOP_NEED_DATA
+  void *data = step->__data;
+#  endif
+  int result = __GCONV_OK;
+  unsigned char bytebuf[MAX_NEEDED_INPUT];
+  const unsigned char *inptr = *inptrp;
+  unsigned char *outptr = *outptrp;
+  size_t inlen;
+
+#  ifdef INIT_PARAMS
+  INIT_PARAMS;
+#  endif
+
+#  ifdef UNPACK_BYTES
+  UNPACK_BYTES
+#  else
+  /* Add the bytes from the state to the input buffer.  */
+  assert ((state->__count & 7) <= sizeof (state->__value));
+  for (inlen = 0; inlen < (size_t) (state->__count & 7); ++inlen)
+    bytebuf[inlen] = state->__value.__wchb[inlen];
+#  endif
+
+  /* Are there enough bytes in the input buffer?  */
+  if (MIN_NEEDED_INPUT > 1
+      && __builtin_expect (inptr + (MIN_NEEDED_INPUT - inlen) > inend, 0))
+    {
+      *inptrp = inend;
+#  ifdef STORE_REST
+      while (inptr < inend)
+	bytebuf[inlen++] = *inptr++;
+
+      inptr = bytebuf;
+      inptrp = &inptr;
+      inend = &bytebuf[inlen];
+
+      STORE_REST
+#  else
+      /* We don't have enough input for another complete input
+	 character.  */
+      while (inptr < inend)
+	state->__value.__wchb[inlen++] = *inptr++;
+#  endif
+
+      return __GCONV_INCOMPLETE_INPUT;
+    }
+
+  /* Enough space in output buffer.  */
+  if ((MIN_NEEDED_OUTPUT != 1 && outptr + MIN_NEEDED_OUTPUT > outend)
+      || (MIN_NEEDED_OUTPUT == 1 && outptr >= outend))
+    /* Overflow in the output buffer.  */
+    return __GCONV_FULL_OUTPUT;
+
+  /*  Now add characters from the normal input buffer.  */
+  do
+    bytebuf[inlen++] = *inptr++;
+  while (inlen < MAX_NEEDED_INPUT && inptr < inend);
+
+  inptr = bytebuf;
+  inend = &bytebuf[inlen];
+
+  do
+    {
+      BODY
+    }
+  while (0);
+
+  /* Now we either have produced an output character and consumed all the
+     bytes from the state and at least one more, or the character is still
+     incomplete, or we have some other error (like illegal input character,
+     no space in output buffer).  */
+  if (__glibc_likely (inptr != bytebuf))
+    {
+      /* We found a new character.  */
+      assert (inptr - bytebuf > (state->__count & 7));
+
+      *inptrp += inptr - bytebuf - (state->__count & 7);
+      *outptrp = outptr;
+
+      result = __GCONV_OK;
+
+      /* Clear the state buffer.  */
+#  ifdef CLEAR_STATE
+      CLEAR_STATE;
+#  else
+      state->__count &= ~7;
+#  endif
+    }
+  else if (result == __GCONV_INCOMPLETE_INPUT)
+    {
+      /* This can only happen if we have less than MAX_NEEDED_INPUT bytes
+	 available.  */
+      assert (inend != &bytebuf[MAX_NEEDED_INPUT]);
+
+      *inptrp += inend - bytebuf - (state->__count & 7);
+#  ifdef STORE_REST
+      inptrp = &inptr;
+
+      STORE_REST
+#  else
+      /* We don't have enough input for another complete input
+	 character.  */
+      assert (inend - inptr > (state->__count & ~7));
+      assert (inend - inptr <= sizeof (state->__value));
+      state->__count = (state->__count & ~7) | (inend - inptr);
+      inlen = 0;
+      while (inptr < inend)
+	state->__value.__wchb[inlen++] = *inptr++;
+#  endif
+    }
+
+  return result;
+}
+#  undef SINGLE
+#  undef SINGLE2
+# endif
+
+
+# ifdef ONEBYTE_BODY
+/* Define the shortcut function for btowc.  */
+static wint_t
+gconv_btowc (struct __gconv_step *step, unsigned char c)
+  ONEBYTE_BODY
+#  define FROM_ONEBYTE gconv_btowc
+# endif
+
+#endif
+
+/* We remove the macro definitions so that we can include this file again
+   for the definition of another function.  */
+#undef MIN_NEEDED_INPUT
+#undef MAX_NEEDED_INPUT
+#undef MIN_NEEDED_OUTPUT
+#undef MAX_NEEDED_OUTPUT
+#undef LOOPFCT
+#undef BODY
+#undef LOOPFCT
+#undef EXTRA_LOOP_DECLS
+#undef INIT_PARAMS
+#undef UPDATE_PARAMS
+#undef REINIT_PARAMS
+#undef ONEBYTE_BODY
+#undef UNPACK_BYTES
+#undef CLEAR_STATE
+#undef LOOP_NEED_STATE
+#undef LOOP_NEED_FLAGS
+#undef LOOP_NEED_DATA
+#undef get16
+#undef get32
+#undef put16
+#undef put32
+#undef unaligned
diff --git a/lib/gconv/iconv/skeleton.c b/lib/gconv/iconv/skeleton.c
new file mode 100644
index 0000000..e64a414
--- /dev/null
+++ b/lib/gconv/iconv/skeleton.c
@@ -0,0 +1,829 @@
+/* Skeleton for a conversion module.
+   Copyright (C) 1998-2014 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Ulrich Drepper <drepper@cygnus.com>, 1998.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+/* This file can be included to provide definitions of several things
+   many modules have in common.  It can be customized using the following
+   macros:
+
+     DEFINE_INIT	define the default initializer.  This requires the
+			following symbol to be defined.
+
+     CHARSET_NAME	string with official name of the coded character
+			set (in all-caps)
+
+     DEFINE_FINI	define the default destructor function.
+
+     MIN_NEEDED_FROM	minimal number of bytes needed for the from-charset.
+     MIN_NEEDED_TO	likewise for the to-charset.
+
+     MAX_NEEDED_FROM	maximal number of bytes needed for the from-charset.
+			This macro is optional, it defaults to MIN_NEEDED_FROM.
+     MAX_NEEDED_TO	likewise for the to-charset.
+
+     FROM_LOOP_MIN_NEEDED_FROM
+     FROM_LOOP_MAX_NEEDED_FROM
+			minimal/maximal number of bytes needed on input
+			of one round through the FROM_LOOP.  Defaults
+			to MIN_NEEDED_FROM and MAX_NEEDED_FROM, respectively.
+     FROM_LOOP_MIN_NEEDED_TO
+     FROM_LOOP_MAX_NEEDED_TO
+			minimal/maximal number of bytes needed on output
+			of one round through the FROM_LOOP.  Defaults
+			to MIN_NEEDED_TO and MAX_NEEDED_TO, respectively.
+     TO_LOOP_MIN_NEEDED_FROM
+     TO_LOOP_MAX_NEEDED_FROM
+			minimal/maximal number of bytes needed on input
+			of one round through the TO_LOOP.  Defaults
+			to MIN_NEEDED_TO and MAX_NEEDED_TO, respectively.
+     TO_LOOP_MIN_NEEDED_TO
+     TO_LOOP_MAX_NEEDED_TO
+			minimal/maximal number of bytes needed on output
+			of one round through the TO_LOOP.  Defaults
+			to MIN_NEEDED_FROM and MAX_NEEDED_FROM, respectively.
+
+     FROM_DIRECTION	this macro is supposed to return a value != 0
+			if we convert from the current character set,
+			otherwise it return 0.
+
+     EMIT_SHIFT_TO_INIT	this symbol is optional.  If it is defined it
+			defines some code which writes out a sequence
+			of bytes which bring the current state into
+			the initial state.
+
+     FROM_LOOP		name of the function implementing the conversion
+			from the current character set.
+     TO_LOOP		likewise for the other direction
+
+     ONE_DIRECTION	optional.  If defined to 1, only one conversion
+			direction is defined instead of two.  In this
+			case, FROM_DIRECTION should be defined to 1, and
+			FROM_LOOP and TO_LOOP should have the same value.
+
+     SAVE_RESET_STATE	in case of an error we must reset the state for
+			the rerun so this macro must be defined for
+			stateful encodings.  It takes an argument which
+			is nonzero when saving.
+
+     RESET_INPUT_BUFFER	If the input character sets allow this the macro
+			can be defined to reset the input buffer pointers
+			to cover only those characters up to the error.
+
+     FUNCTION_NAME	if not set the conversion function is named `gconv'.
+
+     PREPARE_LOOP	optional code preparing the conversion loop.  Can
+			contain variable definitions.
+     END_LOOP		also optional, may be used to store information
+
+     EXTRA_LOOP_ARGS	optional macro specifying extra arguments passed
+			to loop function.
+
+     STORE_REST		optional, needed only when MAX_NEEDED_FROM > 4.
+			This macro stores the seen but unconverted input bytes
+			in the state.
+
+     FROM_ONEBYTE	optional.  If defined, should be the name of a
+			specialized conversion function for a single byte
+			from the current character set to INTERNAL.  This
+			function has prototype
+			   wint_t
+			   FROM_ONEBYTE (struct __gconv_step *, unsigned char);
+			and does a special conversion:
+			- The input is a single byte.
+			- The output is a single uint32_t.
+			- The state before the conversion is the initial state;
+			  the state after the conversion is irrelevant.
+			- No transliteration.
+			- __invocation_counter = 0.
+			- __internal_use = 1.
+			- do_flush = 0.
+
+   Modules can use mbstate_t to store conversion state as follows:
+
+   * Bits 2..0 of '__count' contain the number of lookahead input bytes
+     stored in __value.__wchb.  Always zero if the converter never
+     returns __GCONV_INCOMPLETE_INPUT.
+
+   * Bits 31..3 of '__count' are module dependent shift state.
+
+   * __value: When STORE_REST/UNPACK_BYTES aren't defined and when the
+     converter has returned __GCONV_INCOMPLETE_INPUT, this contains
+     at most 4 lookahead bytes. Converters with an mb_cur_max > 4
+     (currently only UTF-8) must find a way to store their state
+     in __value.__wch and define STORE_REST/UNPACK_BYTES appropriately.
+
+   When __value contains lookahead, __count must not be zero, because
+   the converter is not in the initial state then, and mbsinit() --
+   defined as a (__count == 0) test -- must reflect this.
+ */
+
+#include <assert.h>
+#include <gconv.h>
+#include <string.h>
+#define __need_size_t
+#define __need_NULL
+#include <stddef.h>
+
+#ifndef STATIC_GCONV
+# include <dlfcn.h>
+#endif
+
+/* #include <sysdep.h> */
+#include <stdint.h>
+
+#ifndef DL_CALL_FCT
+# define DL_CALL_FCT(fct, args) fct args
+#endif
+
+/* The direction objects.  */
+#if DEFINE_INIT
+# ifndef FROM_DIRECTION
+#  define FROM_DIRECTION_VAL NULL
+#  define TO_DIRECTION_VAL ((void *) ~((uintptr_t) 0))
+#  define FROM_DIRECTION (step->__data == FROM_DIRECTION_VAL)
+# endif
+#else
+# ifndef FROM_DIRECTION
+#  error "FROM_DIRECTION must be provided if non-default init is used"
+# endif
+#endif
+
+/* How many bytes are needed at most for the from-charset.  */
+#ifndef MAX_NEEDED_FROM
+# define MAX_NEEDED_FROM	MIN_NEEDED_FROM
+#endif
+
+/* Same for the to-charset.  */
+#ifndef MAX_NEEDED_TO
+# define MAX_NEEDED_TO		MIN_NEEDED_TO
+#endif
+
+/* Defaults for the per-direction min/max constants.  */
+#ifndef FROM_LOOP_MIN_NEEDED_FROM
+# define FROM_LOOP_MIN_NEEDED_FROM	MIN_NEEDED_FROM
+#endif
+#ifndef FROM_LOOP_MAX_NEEDED_FROM
+# define FROM_LOOP_MAX_NEEDED_FROM	MAX_NEEDED_FROM
+#endif
+#ifndef FROM_LOOP_MIN_NEEDED_TO
+# define FROM_LOOP_MIN_NEEDED_TO	MIN_NEEDED_TO
+#endif
+#ifndef FROM_LOOP_MAX_NEEDED_TO
+# define FROM_LOOP_MAX_NEEDED_TO	MAX_NEEDED_TO
+#endif
+#ifndef TO_LOOP_MIN_NEEDED_FROM
+# define TO_LOOP_MIN_NEEDED_FROM	MIN_NEEDED_TO
+#endif
+#ifndef TO_LOOP_MAX_NEEDED_FROM
+# define TO_LOOP_MAX_NEEDED_FROM	MAX_NEEDED_TO
+#endif
+#ifndef TO_LOOP_MIN_NEEDED_TO
+# define TO_LOOP_MIN_NEEDED_TO		MIN_NEEDED_FROM
+#endif
+#ifndef TO_LOOP_MAX_NEEDED_TO
+# define TO_LOOP_MAX_NEEDED_TO		MAX_NEEDED_FROM
+#endif
+
+
+/* Define macros which can access unaligned buffers.  These macros are
+   supposed to be used only in code outside the inner loops.  For the inner
+   loops we have other definitions which allow optimized access.  */
+#if _STRING_ARCH_unaligned
+/* We can handle unaligned memory access.  */
+# define get16u(addr) *((const uint16_t *) (addr))
+# define get32u(addr) *((const uint32_t *) (addr))
+
+/* We need no special support for writing values either.  */
+# define put16u(addr, val) *((uint16_t *) (addr)) = (val)
+# define put32u(addr, val) *((uint32_t *) (addr)) = (val)
+#else
+/* Distinguish between big endian and little endian.  */
+# if __BYTE_ORDER == __LITTLE_ENDIAN
+#  define get16u(addr) \
+     (((const unsigned char *) (addr))[1] << 8				      \
+      | ((const unsigned char *) (addr))[0])
+#  define get32u(addr) \
+     (((((const unsigned char *) (addr))[3] << 8			      \
+	| ((const unsigned char *) (addr))[2]) << 8			      \
+       | ((const unsigned char *) (addr))[1]) << 8			      \
+      | ((const unsigned char *) (addr))[0])
+
+#  define put16u(addr, val) \
+     ({ uint16_t __val = (val);						      \
+	((unsigned char *) (addr))[0] = __val;				      \
+	((unsigned char *) (addr))[1] = __val >> 8;			      \
+	(void) 0; })
+#  define put32u(addr, val) \
+     ({ uint32_t __val = (val);						      \
+	((unsigned char *) (addr))[0] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[1] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[2] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[3] = __val;				      \
+	(void) 0; })
+# else
+#  define get16u(addr) \
+     (((const unsigned char *) (addr))[0] << 8				      \
+      | ((const unsigned char *) (addr))[1])
+#  define get32u(addr) \
+     (((((const unsigned char *) (addr))[0] << 8			      \
+	| ((const unsigned char *) (addr))[1]) << 8			      \
+       | ((const unsigned char *) (addr))[2]) << 8			      \
+      | ((const unsigned char *) (addr))[3])
+
+#  define put16u(addr, val) \
+     ({ uint16_t __val = (val);						      \
+	((unsigned char *) (addr))[1] = __val;				      \
+	((unsigned char *) (addr))[0] = __val >> 8;			      \
+	(void) 0; })
+#  define put32u(addr, val) \
+     ({ uint32_t __val = (val);						      \
+	((unsigned char *) (addr))[3] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[2] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[1] = __val;				      \
+	__val >>= 8;							      \
+	((unsigned char *) (addr))[0] = __val;				      \
+	(void) 0; })
+# endif
+#endif
+
+
+/* For conversions from a fixed width character set to another fixed width
+   character set we can define RESET_INPUT_BUFFER in a very fast way.  */
+#if !defined RESET_INPUT_BUFFER && !defined SAVE_RESET_STATE
+# if FROM_LOOP_MIN_NEEDED_FROM == FROM_LOOP_MAX_NEEDED_FROM \
+     && FROM_LOOP_MIN_NEEDED_TO == FROM_LOOP_MAX_NEEDED_TO \
+     && TO_LOOP_MIN_NEEDED_FROM == TO_LOOP_MAX_NEEDED_FROM \
+     && TO_LOOP_MIN_NEEDED_TO == TO_LOOP_MAX_NEEDED_TO
+/* We have to use these `if's here since the compiler cannot know that
+   (outbuf - outerr) is always divisible by FROM/TO_LOOP_MIN_NEEDED_TO.
+   The ?:1 avoids division by zero warnings that gcc 3.2 emits even for
+   obviously unreachable code.  */
+#  define RESET_INPUT_BUFFER \
+  if (FROM_DIRECTION)							      \
+    {									      \
+      if (FROM_LOOP_MIN_NEEDED_FROM % FROM_LOOP_MIN_NEEDED_TO == 0)	      \
+	*inptrp -= (outbuf - outerr)					      \
+		   * (FROM_LOOP_MIN_NEEDED_FROM / FROM_LOOP_MIN_NEEDED_TO);   \
+      else if (FROM_LOOP_MIN_NEEDED_TO % FROM_LOOP_MIN_NEEDED_FROM == 0)      \
+	*inptrp -= (outbuf - outerr)					      \
+		   / (FROM_LOOP_MIN_NEEDED_TO / FROM_LOOP_MIN_NEEDED_FROM     \
+		      ? : 1);						      \
+      else								      \
+	*inptrp -= ((outbuf - outerr) / FROM_LOOP_MIN_NEEDED_TO)	      \
+		   * FROM_LOOP_MIN_NEEDED_FROM;				      \
+    }									      \
+  else									      \
+    {									      \
+      if (TO_LOOP_MIN_NEEDED_FROM % TO_LOOP_MIN_NEEDED_TO == 0)		      \
+	*inptrp -= (outbuf - outerr)					      \
+		   * (TO_LOOP_MIN_NEEDED_FROM / TO_LOOP_MIN_NEEDED_TO);	      \
+      else if (TO_LOOP_MIN_NEEDED_TO % TO_LOOP_MIN_NEEDED_FROM == 0)	      \
+	*inptrp -= (outbuf - outerr)					      \
+		   / (TO_LOOP_MIN_NEEDED_TO / TO_LOOP_MIN_NEEDED_FROM ? : 1); \
+      else								      \
+	*inptrp -= ((outbuf - outerr) / TO_LOOP_MIN_NEEDED_TO)		      \
+		   * TO_LOOP_MIN_NEEDED_FROM;				      \
+    }
+# endif
+#endif
+
+
+/* The default init function.  It simply matches the name and initializes
+   the step data to point to one of the objects above.  */
+#if DEFINE_INIT
+# ifndef CHARSET_NAME
+#  error "CHARSET_NAME not defined"
+# endif
+
+extern int gconv_init (struct __gconv_step *step);
+int
+gconv_init (struct __gconv_step *step)
+{
+  /* Determine which direction.  */
+  if (strcmp (step->__from_name, CHARSET_NAME) == 0)
+    {
+      step->__data = FROM_DIRECTION_VAL;
+
+      step->__min_needed_from = FROM_LOOP_MIN_NEEDED_FROM;
+      step->__max_needed_from = FROM_LOOP_MAX_NEEDED_FROM;
+      step->__min_needed_to = FROM_LOOP_MIN_NEEDED_TO;
+      step->__max_needed_to = FROM_LOOP_MAX_NEEDED_TO;
+
+#ifdef FROM_ONEBYTE
+      step->__btowc_fct = FROM_ONEBYTE;
+#endif
+    }
+  else if (__builtin_expect (strcmp (step->__to_name, CHARSET_NAME), 0) == 0)
+    {
+      step->__data = TO_DIRECTION_VAL;
+
+      step->__min_needed_from = TO_LOOP_MIN_NEEDED_FROM;
+      step->__max_needed_from = TO_LOOP_MAX_NEEDED_FROM;
+      step->__min_needed_to = TO_LOOP_MIN_NEEDED_TO;
+      step->__max_needed_to = TO_LOOP_MAX_NEEDED_TO;
+    }
+  else
+    return __GCONV_NOCONV;
+
+#ifdef SAVE_RESET_STATE
+  step->__stateful = 1;
+#else
+  step->__stateful = 0;
+#endif
+
+  return __GCONV_OK;
+}
+#endif
+
+
+/* The default destructor function does nothing in the moment and so
+   we don't define it at all.  But we still provide the macro just in
+   case we need it some day.  */
+#if DEFINE_FINI
+#endif
+
+
+/* If no arguments have to passed to the loop function define the macro
+   as empty.  */
+#ifndef EXTRA_LOOP_ARGS
+# define EXTRA_LOOP_ARGS
+#endif
+
+
+/* This is the actual conversion function.  */
+#ifndef FUNCTION_NAME
+# define FUNCTION_NAME	gconv
+#endif
+
+/* The macros are used to access the function to convert single characters.  */
+#define SINGLE(fct) SINGLE2 (fct)
+#define SINGLE2(fct) fct##_single
+
+
+extern int FUNCTION_NAME (struct __gconv_step *step,
+			  struct __gconv_step_data *data,
+			  const unsigned char **inptrp,
+			  const unsigned char *inend,
+			  unsigned char **outbufstart, size_t *irreversible,
+			  int do_flush, int consume_incomplete);
+int
+FUNCTION_NAME (struct __gconv_step *step, struct __gconv_step_data *data,
+	       const unsigned char **inptrp, const unsigned char *inend,
+	       unsigned char **outbufstart, size_t *irreversible, int do_flush,
+	       int consume_incomplete)
+{
+  struct __gconv_step *next_step = step + 1;
+  struct __gconv_step_data *next_data = data + 1;
+  __gconv_fct fct = NULL;
+  int status;
+
+  if ((data->__flags & __GCONV_IS_LAST) == 0)
+    {
+      fct = next_step->__fct;
+#ifdef PTR_DEMANGLE
+      if (next_step->__shlib_handle != NULL)
+	PTR_DEMANGLE (fct);
+#endif
+    }
+
+  /* If the function is called with no input this means we have to reset
+     to the initial state.  The possibly partly converted input is
+     dropped.  */
+  if (__glibc_unlikely (do_flush))
+    {
+      /* This should never happen during error handling.  */
+      assert (outbufstart == NULL);
+
+      status = __GCONV_OK;
+
+#ifdef EMIT_SHIFT_TO_INIT
+      if (do_flush == 1)
+	{
+	  /* We preserve the initial values of the pointer variables.  */
+	  unsigned char *outbuf = data->__outbuf;
+	  unsigned char *outstart = outbuf;
+	  unsigned char *outend = data->__outbufend;
+
+# ifdef PREPARE_LOOP
+	  PREPARE_LOOP
+# endif
+
+# ifdef SAVE_RESET_STATE
+	  SAVE_RESET_STATE (1);
+# endif
+
+	  /* Emit the escape sequence to reset the state.  */
+	  EMIT_SHIFT_TO_INIT;
+
+	  /* Call the steps down the chain if there are any but only if we
+	     successfully emitted the escape sequence.  This should only
+	     fail if the output buffer is full.  If the input is invalid
+	     it should be discarded since the user wants to start from a
+	     clean state.  */
+	  if (status == __GCONV_OK)
+	    {
+	      if (data->__flags & __GCONV_IS_LAST)
+		/* Store information about how many bytes are available.  */
+		data->__outbuf = outbuf;
+	      else
+		{
+		  /* Write out all output which was produced.  */
+		  if (outbuf > outstart)
+		    {
+		      const unsigned char *outerr = outstart;
+		      int result;
+
+		      result = DL_CALL_FCT (fct, (next_step, next_data,
+						  &outerr, outbuf, NULL,
+						  irreversible, 0,
+						  consume_incomplete));
+
+		      if (result != __GCONV_EMPTY_INPUT)
+			{
+			  if (__glibc_unlikely (outerr != outbuf))
+			    {
+			      /* We have a problem.  Undo the conversion.  */
+			      outbuf = outstart;
+
+			      /* Restore the state.  */
+# ifdef SAVE_RESET_STATE
+			      SAVE_RESET_STATE (0);
+# endif
+			    }
+
+			  /* Change the status.  */
+			  status = result;
+			}
+		    }
+
+		  if (status == __GCONV_OK)
+		    /* Now flush the remaining steps.  */
+		    status = DL_CALL_FCT (fct, (next_step, next_data, NULL,
+						NULL, NULL, irreversible, 1,
+						consume_incomplete));
+		}
+	    }
+	}
+      else
+#endif
+	{
+	  /* Clear the state object.  There might be bytes in there from
+	     previous calls with CONSUME_INCOMPLETE == 1.  But don't emit
+	     escape sequences.  */
+	  memset (data->__statep, '\0', sizeof (*data->__statep));
+
+	  if (! (data->__flags & __GCONV_IS_LAST))
+	    /* Now flush the remaining steps.  */
+	    status = DL_CALL_FCT (fct, (next_step, next_data, NULL, NULL,
+					NULL, irreversible, do_flush,
+					consume_incomplete));
+	}
+    }
+  else
+    {
+      /* We preserve the initial values of the pointer variables.  */
+      const unsigned char *inptr = *inptrp;
+      unsigned char *outbuf = (__builtin_expect (outbufstart == NULL, 1)
+			       ? data->__outbuf : *outbufstart);
+      unsigned char *outend = data->__outbufend;
+      unsigned char *outstart;
+      /* This variable is used to count the number of characters we
+	 actually converted.  */
+      size_t lirreversible = 0;
+      size_t *lirreversiblep = irreversible ? &lirreversible : NULL;
+
+      /* The following assumes that encodings, which have a variable length
+	 what might unalign a buffer even though it is an aligned in the
+	 beginning, either don't have the minimal number of bytes as a divisor
+	 of the maximum length or have a minimum length of 1.  This is true
+	 for all known and supported encodings.
+	 We use && instead of || to combine the subexpression for the FROM
+	 encoding and for the TO encoding, because usually one of them is
+	 INTERNAL, for which the subexpression evaluates to 1, but INTERNAL
+	 buffers are always aligned correctly.  */
+#define POSSIBLY_UNALIGNED \
+  (!_STRING_ARCH_unaligned					              \
+   && (((FROM_LOOP_MIN_NEEDED_FROM != 1					      \
+	 && FROM_LOOP_MAX_NEEDED_FROM % FROM_LOOP_MIN_NEEDED_FROM == 0)	      \
+	&& (FROM_LOOP_MIN_NEEDED_TO != 1				      \
+	    && FROM_LOOP_MAX_NEEDED_TO % FROM_LOOP_MIN_NEEDED_TO == 0))	      \
+       || ((TO_LOOP_MIN_NEEDED_FROM != 1				      \
+	    && TO_LOOP_MAX_NEEDED_FROM % TO_LOOP_MIN_NEEDED_FROM == 0)	      \
+	   && (TO_LOOP_MIN_NEEDED_TO != 1				      \
+	       && TO_LOOP_MAX_NEEDED_TO % TO_LOOP_MIN_NEEDED_TO == 0))))
+#if POSSIBLY_UNALIGNED
+      int unaligned;
+# define GEN_unaligned(name) GEN_unaligned2 (name)
+# define GEN_unaligned2(name) name##_unaligned
+#else
+# define unaligned 0
+#endif
+
+#ifdef PREPARE_LOOP
+      PREPARE_LOOP
+#endif
+
+#if FROM_LOOP_MAX_NEEDED_FROM > 1 || TO_LOOP_MAX_NEEDED_FROM > 1
+      /* If the function is used to implement the mb*towc*() or wc*tomb*()
+	 functions we must test whether any bytes from the last call are
+	 stored in the `state' object.  */
+      if (((FROM_LOOP_MAX_NEEDED_FROM > 1 && TO_LOOP_MAX_NEEDED_FROM > 1)
+	   || (FROM_LOOP_MAX_NEEDED_FROM > 1 && FROM_DIRECTION)
+	   || (TO_LOOP_MAX_NEEDED_FROM > 1 && !FROM_DIRECTION))
+	  && consume_incomplete && (data->__statep->__count & 7) != 0)
+	{
+	  /* Yep, we have some bytes left over.  Process them now.
+	     But this must not happen while we are called from an
+	     error handler.  */
+	  assert (outbufstart == NULL);
+
+# if FROM_LOOP_MAX_NEEDED_FROM > 1
+	  if (TO_LOOP_MAX_NEEDED_FROM == 1 || FROM_DIRECTION)
+	    status = SINGLE(FROM_LOOP) (step, data, inptrp, inend, &outbuf,
+					outend, lirreversiblep
+					EXTRA_LOOP_ARGS);
+# endif
+# if !ONE_DIRECTION
+#  if FROM_LOOP_MAX_NEEDED_FROM > 1 && TO_LOOP_MAX_NEEDED_FROM > 1
+	  else
+#  endif
+#  if TO_LOOP_MAX_NEEDED_FROM > 1
+	    status = SINGLE(TO_LOOP) (step, data, inptrp, inend, &outbuf,
+				      outend, lirreversiblep EXTRA_LOOP_ARGS);
+#  endif
+# endif
+
+	  if (__builtin_expect (status, __GCONV_OK) != __GCONV_OK)
+	    return status;
+	}
+#endif
+
+#if POSSIBLY_UNALIGNED
+      unaligned =
+	((FROM_DIRECTION
+	  && ((uintptr_t) inptr % FROM_LOOP_MIN_NEEDED_FROM != 0
+	      || ((data->__flags & __GCONV_IS_LAST)
+		  && (uintptr_t) outbuf % FROM_LOOP_MIN_NEEDED_TO != 0)))
+	 || (!FROM_DIRECTION
+	     && (((data->__flags & __GCONV_IS_LAST)
+		  && (uintptr_t) outbuf % TO_LOOP_MIN_NEEDED_TO != 0)
+		 || (uintptr_t) inptr % TO_LOOP_MIN_NEEDED_FROM != 0)));
+#endif
+
+      while (1)
+	{
+	  struct __gconv_trans_data *trans;
+
+	  /* Remember the start value for this round.  */
+	  inptr = *inptrp;
+	  /* The outbuf buffer is empty.  */
+	  outstart = outbuf;
+
+#ifdef SAVE_RESET_STATE
+	  SAVE_RESET_STATE (1);
+#endif
+
+	  if (__glibc_likely (!unaligned))
+	    {
+	      if (FROM_DIRECTION)
+		/* Run the conversion loop.  */
+		status = FROM_LOOP (step, data, inptrp, inend, &outbuf, outend,
+				    lirreversiblep EXTRA_LOOP_ARGS);
+	      else
+		/* Run the conversion loop.  */
+		status = TO_LOOP (step, data, inptrp, inend, &outbuf, outend,
+				  lirreversiblep EXTRA_LOOP_ARGS);
+	    }
+#if POSSIBLY_UNALIGNED
+	  else
+	    {
+	      if (FROM_DIRECTION)
+		/* Run the conversion loop.  */
+		status = GEN_unaligned (FROM_LOOP) (step, data, inptrp, inend,
+						    &outbuf, outend,
+						    lirreversiblep
+						    EXTRA_LOOP_ARGS);
+	      else
+		/* Run the conversion loop.  */
+		status = GEN_unaligned (TO_LOOP) (step, data, inptrp, inend,
+						  &outbuf, outend,
+						  lirreversiblep
+						  EXTRA_LOOP_ARGS);
+	    }
+#endif
+
+	  /* If we were called as part of an error handling module we
+	     don't do anything else here.  */
+	  if (__glibc_unlikely (outbufstart != NULL))
+	    {
+	      *outbufstart = outbuf;
+	      return status;
+	    }
+
+	  /* Give the transliteration module the chance to store the
+	     original text and the result in case it needs a context.  */
+	  for (trans = data->__trans; trans != NULL; trans = trans->__next)
+	    if (trans->__trans_context_fct != NULL)
+	      DL_CALL_FCT (trans->__trans_context_fct,
+			   (trans->__data, inptr, *inptrp, outstart, outbuf));
+
+	  /* We finished one use of the loops.  */
+	  ++data->__invocation_counter;
+
+	  /* If this is the last step leave the loop, there is nothing
+	     we can do.  */
+	  if (__glibc_unlikely (data->__flags & __GCONV_IS_LAST))
+	    {
+	      /* Store information about how many bytes are available.  */
+	      data->__outbuf = outbuf;
+
+	      /* Remember how many non-identical characters we
+		 converted in an irreversible way.  */
+	      *irreversible += lirreversible;
+
+	      break;
+	    }
+
+	  /* Write out all output which was produced.  */
+	  if (__glibc_likely (outbuf > outstart))
+	    {
+	      const unsigned char *outerr = data->__outbuf;
+	      int result;
+
+	      result = DL_CALL_FCT (fct, (next_step, next_data, &outerr,
+					  outbuf, NULL, irreversible, 0,
+					  consume_incomplete));
+
+	      if (result != __GCONV_EMPTY_INPUT)
+		{
+		  if (__glibc_unlikely (outerr != outbuf))
+		    {
+#ifdef RESET_INPUT_BUFFER
+		      RESET_INPUT_BUFFER;
+#else
+		      /* We have a problem in one of the functions below.
+			 Undo the conversion upto the error point.  */
+		      size_t nstatus;
+
+		      /* Reload the pointers.  */
+		      *inptrp = inptr;
+		      outbuf = outstart;
+
+		      /* Restore the state.  */
+# ifdef SAVE_RESET_STATE
+		      SAVE_RESET_STATE (0);
+# endif
+
+		      if (__glibc_likely (!unaligned))
+			{
+			  if (FROM_DIRECTION)
+			    /* Run the conversion loop.  */
+			    nstatus = FROM_LOOP (step, data, inptrp, inend,
+						 &outbuf, outerr,
+						 lirreversiblep
+						 EXTRA_LOOP_ARGS);
+			  else
+			    /* Run the conversion loop.  */
+			    nstatus = TO_LOOP (step, data, inptrp, inend,
+					       &outbuf, outerr,
+					       lirreversiblep
+					       EXTRA_LOOP_ARGS);
+			}
+# if POSSIBLY_UNALIGNED
+		      else
+			{
+			  if (FROM_DIRECTION)
+			    /* Run the conversion loop.  */
+			    nstatus = GEN_unaligned (FROM_LOOP) (step, data,
+								 inptrp, inend,
+								 &outbuf,
+								 outerr,
+								 lirreversiblep
+								 EXTRA_LOOP_ARGS);
+			  else
+			    /* Run the conversion loop.  */
+			    nstatus = GEN_unaligned (TO_LOOP) (step, data,
+							       inptrp, inend,
+							       &outbuf, outerr,
+							       lirreversiblep
+							       EXTRA_LOOP_ARGS);
+			}
+# endif
+
+		      /* We must run out of output buffer space in this
+			 rerun.  */
+		      assert (outbuf == outerr);
+		      assert (nstatus == __GCONV_FULL_OUTPUT);
+
+		      /* If we haven't consumed a single byte decrement
+			 the invocation counter.  */
+		      if (__glibc_unlikely (outbuf == outstart))
+			--data->__invocation_counter;
+#endif	/* reset input buffer */
+		    }
+
+		  /* Change the status.  */
+		  status = result;
+		}
+	      else
+		/* All the output is consumed, we can make another run
+		   if everything was ok.  */
+		if (status == __GCONV_FULL_OUTPUT)
+		  {
+		    status = __GCONV_OK;
+		    outbuf = data->__outbuf;
+		  }
+	    }
+
+	  if (status != __GCONV_OK)
+	    break;
+
+	  /* Reset the output buffer pointer for the next round.  */
+	  outbuf = data->__outbuf;
+	}
+
+#ifdef END_LOOP
+      END_LOOP
+#endif
+
+      /* If we are supposed to consume all character store now all of the
+	 remaining characters in the `state' object.  */
+#if FROM_LOOP_MAX_NEEDED_FROM > 1 || TO_LOOP_MAX_NEEDED_FROM > 1
+      if (((FROM_LOOP_MAX_NEEDED_FROM > 1 && TO_LOOP_MAX_NEEDED_FROM > 1)
+	   || (FROM_LOOP_MAX_NEEDED_FROM > 1 && FROM_DIRECTION)
+	   || (TO_LOOP_MAX_NEEDED_FROM > 1 && !FROM_DIRECTION))
+	  && __builtin_expect (consume_incomplete, 0)
+	  && status == __GCONV_INCOMPLETE_INPUT)
+	{
+# ifdef STORE_REST
+	  mbstate_t *state = data->__statep;
+
+	  STORE_REST
+# else
+	  /* Make sure the remaining bytes fit into the state objects
+	     buffer.  */
+	  assert (inend - *inptrp < 4);
+
+	  size_t cnt;
+	  for (cnt = 0; *inptrp < inend; ++cnt)
+	    data->__statep->__value.__wchb[cnt] = *(*inptrp)++;
+	  data->__statep->__count &= ~7;
+	  data->__statep->__count |= cnt;
+# endif
+	}
+#endif
+#undef unaligned
+#undef POSSIBLY_UNALIGNED
+    }
+
+  return status;
+}
+
+#undef DEFINE_INIT
+#undef CHARSET_NAME
+#undef DEFINE_FINI
+#undef MIN_NEEDED_FROM
+#undef MIN_NEEDED_TO
+#undef MAX_NEEDED_FROM
+#undef MAX_NEEDED_TO
+#undef FROM_LOOP_MIN_NEEDED_FROM
+#undef FROM_LOOP_MAX_NEEDED_FROM
+#undef FROM_LOOP_MIN_NEEDED_TO
+#undef FROM_LOOP_MAX_NEEDED_TO
+#undef TO_LOOP_MIN_NEEDED_FROM
+#undef TO_LOOP_MAX_NEEDED_FROM
+#undef TO_LOOP_MIN_NEEDED_TO
+#undef TO_LOOP_MAX_NEEDED_TO
+#undef FROM_DIRECTION
+#undef EMIT_SHIFT_TO_INIT
+#undef FROM_LOOP
+#undef TO_LOOP
+#undef ONE_DIRECTION
+#undef SAVE_RESET_STATE
+#undef RESET_INPUT_BUFFER
+#undef FUNCTION_NAME
+#undef PREPARE_LOOP
+#undef END_LOOP
+#undef EXTRA_LOOP_ARGS
+#undef STORE_REST
+#undef FROM_ONEBYTE
diff --git a/lib/gconv/jisx0213.h b/lib/gconv/jisx0213.h
new file mode 100644
index 0000000..5874997
--- /dev/null
+++ b/lib/gconv/jisx0213.h
@@ -0,0 +1,102 @@
+/* Functions for JISX0213 conversion.
+   Copyright (C) 2002-2014 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Bruno Haible <bruno@clisp.org>, 2002.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _JISX0213_H
+#define _JISX0213_H	1
+
+#include <stdint.h>
+
+extern const uint16_t __jisx0213_to_ucs_combining[][2];
+extern const uint16_t __jisx0213_to_ucs_main[120 * 94];
+extern const uint32_t __jisx0213_to_ucs_pagestart[];
+extern const int16_t __jisx0213_from_ucs_level1[2715];
+extern const uint16_t __jisx0213_from_ucs_level2[];
+
+#define NELEMS(arr) (sizeof (arr) / sizeof (arr[0]))
+
+static inline uint32_t
+__attribute ((always_inline))
+jisx0213_to_ucs4 (unsigned int row, unsigned int col)
+{
+  uint32_t val;
+
+  if (row >= 0x121 && row <= 0x17e)
+    row -= 289;
+  else if (row == 0x221)
+    row -= 451;
+  else if (row >= 0x223 && row <= 0x225)
+    row -= 452;
+  else if (row == 0x228)
+    row -= 454;
+  else if (row >= 0x22c && row <= 0x22f)
+    row -= 457;
+  else if (row >= 0x26e && row <= 0x27e)
+    row -= 519;
+  else
+    return 0x0000;
+
+  if (col >= 0x21 && col <= 0x7e)
+    col -= 0x21;
+  else
+    return 0x0000;
+
+  val = __jisx0213_to_ucs_main[row * 94 + col];
+  val = __jisx0213_to_ucs_pagestart[val >> 8] + (val & 0xff);
+  if (val == 0xfffd)
+    val = 0x0000;
+  return val;
+}
+
+static inline uint16_t
+__attribute ((always_inline))
+ucs4_to_jisx0213 (uint32_t ucs)
+{
+  if (ucs < NELEMS (__jisx0213_from_ucs_level1) << 6)
+    {
+      int index1 = __jisx0213_from_ucs_level1[ucs >> 6];
+      if (index1 >= 0)
+	return __jisx0213_from_ucs_level2[(index1 << 6) + (ucs & 0x3f)];
+    }
+  return 0x0000;
+}
+
+static inline int
+__attribute ((always_inline))
+jisx0213_added_in_2004_p (uint16_t val)
+{
+  /* From JISX 0213:2000 to JISX 0213:2004, 10 characters were added to
+     plane 1, and plane 2 was left unchanged.  See ISO-IR-233.  */
+  switch (val >> 8)
+    {
+    case 0x2e:
+      return val == 0x2e21;
+    case 0x2f:
+      return val == 0x2f7e;
+    case 0x4f:
+      return val == 0x4f54 || val == 0x4f7e;
+    case 0x74:
+      return val == 0x7427;
+    case 0x7e:
+      return val >= 0x7e7a && val <= 0x7e7e;
+    default:
+      return 0;
+    }
+}
+
+#endif /* _JISX0213_H */
-- 
2.1.2

