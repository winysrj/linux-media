Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:55501 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab2EFKPP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 May 2012 06:15:15 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH v2 2/3] Input: move drivers/input/fixp-arith.h to include/linux
Date: Sun,  6 May 2012 12:14:57 +0200
Message-Id: <1336299298-17517-3-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
References: <20120505102614.31395c2979f0b7aac0c8a107@studenti.unina.it>
 <1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move drivers/input/fixp-arith.h to include/linux so that the functions
defined there can be used by other subsystems, for instance some video
devices ISPs can control the output HUE value by setting registers for
sin(HUE) and cos(HUE).

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Changes since version 1:
  
  - Just added the Acked-by: Dmitry to the commit message

 drivers/input/ff-memless.c |    3 +-
 drivers/input/fixp-arith.h |   87 --------------------------------------------
 include/linux/fixp-arith.h |   87 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 89 deletions(-)
 delete mode 100644 drivers/input/fixp-arith.h
 create mode 100644 include/linux/fixp-arith.h

diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index 117a59a..5f55885 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -31,8 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
-
-#include "fixp-arith.h"
+#include <linux/fixp-arith.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Anssi Hannula <anssi.hannula@gmail.com>");
diff --git a/drivers/input/fixp-arith.h b/drivers/input/fixp-arith.h
deleted file mode 100644
index 3089d73..0000000
--- a/drivers/input/fixp-arith.h
+++ /dev/null
@@ -1,87 +0,0 @@
-#ifndef _FIXP_ARITH_H
-#define _FIXP_ARITH_H
-
-/*
- * Simplistic fixed-point arithmetics.
- * Hmm, I'm probably duplicating some code :(
- *
- * Copyright (c) 2002 Johann Deneux
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * Should you need to contact me, the author, you can do so by
- * e-mail - mail your message to <johann.deneux@gmail.com>
- */
-
-#include <linux/types.h>
-
-/* The type representing fixed-point values */
-typedef s16 fixp_t;
-
-#define FRAC_N 8
-#define FRAC_MASK ((1<<FRAC_N)-1)
-
-/* Not to be used directly. Use fixp_{cos,sin} */
-static const fixp_t cos_table[46] = {
-	0x0100,	0x00FF,	0x00FF,	0x00FE,	0x00FD,	0x00FC,	0x00FA,	0x00F8,
-	0x00F6,	0x00F3,	0x00F0,	0x00ED,	0x00E9,	0x00E6,	0x00E2,	0x00DD,
-	0x00D9,	0x00D4,	0x00CF,	0x00C9,	0x00C4,	0x00BE,	0x00B8,	0x00B1,
-	0x00AB,	0x00A4,	0x009D,	0x0096,	0x008F,	0x0087,	0x0080,	0x0078,
-	0x0070,	0x0068,	0x005F,	0x0057,	0x004F,	0x0046,	0x003D,	0x0035,
-	0x002C,	0x0023,	0x001A,	0x0011,	0x0008, 0x0000
-};
-
-
-/* a: 123 -> 123.0 */
-static inline fixp_t fixp_new(s16 a)
-{
-	return a<<FRAC_N;
-}
-
-/* a: 0xFFFF -> -1.0
-      0x8000 -> 1.0
-      0x0000 -> 0.0
-*/
-static inline fixp_t fixp_new16(s16 a)
-{
-	return ((s32)a)>>(16-FRAC_N);
-}
-
-static inline fixp_t fixp_cos(unsigned int degrees)
-{
-	int quadrant = (degrees / 90) & 3;
-	unsigned int i = degrees % 90;
-
-	if (quadrant == 1 || quadrant == 3)
-		i = 90 - i;
-
-	i >>= 1;
-
-	return (quadrant == 1 || quadrant == 2)? -cos_table[i] : cos_table[i];
-}
-
-static inline fixp_t fixp_sin(unsigned int degrees)
-{
-	return -fixp_cos(degrees + 90);
-}
-
-static inline fixp_t fixp_mult(fixp_t a, fixp_t b)
-{
-	return ((s32)(a*b))>>FRAC_N;
-}
-
-#endif
diff --git a/include/linux/fixp-arith.h b/include/linux/fixp-arith.h
new file mode 100644
index 0000000..3089d73
--- /dev/null
+++ b/include/linux/fixp-arith.h
@@ -0,0 +1,87 @@
+#ifndef _FIXP_ARITH_H
+#define _FIXP_ARITH_H
+
+/*
+ * Simplistic fixed-point arithmetics.
+ * Hmm, I'm probably duplicating some code :(
+ *
+ * Copyright (c) 2002 Johann Deneux
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Should you need to contact me, the author, you can do so by
+ * e-mail - mail your message to <johann.deneux@gmail.com>
+ */
+
+#include <linux/types.h>
+
+/* The type representing fixed-point values */
+typedef s16 fixp_t;
+
+#define FRAC_N 8
+#define FRAC_MASK ((1<<FRAC_N)-1)
+
+/* Not to be used directly. Use fixp_{cos,sin} */
+static const fixp_t cos_table[46] = {
+	0x0100,	0x00FF,	0x00FF,	0x00FE,	0x00FD,	0x00FC,	0x00FA,	0x00F8,
+	0x00F6,	0x00F3,	0x00F0,	0x00ED,	0x00E9,	0x00E6,	0x00E2,	0x00DD,
+	0x00D9,	0x00D4,	0x00CF,	0x00C9,	0x00C4,	0x00BE,	0x00B8,	0x00B1,
+	0x00AB,	0x00A4,	0x009D,	0x0096,	0x008F,	0x0087,	0x0080,	0x0078,
+	0x0070,	0x0068,	0x005F,	0x0057,	0x004F,	0x0046,	0x003D,	0x0035,
+	0x002C,	0x0023,	0x001A,	0x0011,	0x0008, 0x0000
+};
+
+
+/* a: 123 -> 123.0 */
+static inline fixp_t fixp_new(s16 a)
+{
+	return a<<FRAC_N;
+}
+
+/* a: 0xFFFF -> -1.0
+      0x8000 -> 1.0
+      0x0000 -> 0.0
+*/
+static inline fixp_t fixp_new16(s16 a)
+{
+	return ((s32)a)>>(16-FRAC_N);
+}
+
+static inline fixp_t fixp_cos(unsigned int degrees)
+{
+	int quadrant = (degrees / 90) & 3;
+	unsigned int i = degrees % 90;
+
+	if (quadrant == 1 || quadrant == 3)
+		i = 90 - i;
+
+	i >>= 1;
+
+	return (quadrant == 1 || quadrant == 2)? -cos_table[i] : cos_table[i];
+}
+
+static inline fixp_t fixp_sin(unsigned int degrees)
+{
+	return -fixp_cos(degrees + 90);
+}
+
+static inline fixp_t fixp_mult(fixp_t a, fixp_t b)
+{
+	return ((s32)(a*b))>>FRAC_N;
+}
+
+#endif
-- 
1.7.10

