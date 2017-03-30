Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56865 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934773AbdC3ULp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 16:11:45 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Noam Camus <noamca@mellanox.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 8/9] kernel-api.rst: fix some complex tags at lib/bitmap.c
Date: Thu, 30 Mar 2017 17:11:35 -0300
Message-Id: <60c8e341c2a1840d059c4d655974ccb2f3d19f4b.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following issues:

./lib/bitmap.c:869: WARNING: Definition list ends without a blank line; unexpected unindent.
./lib/bitmap.c:876: WARNING: Inline emphasis start-string without end-string.
./lib/bitmap.c:508: ERROR: Unexpected indentation.

And make sure that a table and a footnote will use the right tags.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 lib/bitmap.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 0b66f0e5eb6b..08c6ef3a2b6f 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -502,11 +502,11 @@ EXPORT_SYMBOL(bitmap_print_to_pagebuf);
  * Syntax: range:used_size/group_size
  * Example: 0-1023:2/256 ==> 0,1,256,257,512,513,768,769
  *
- * Returns 0 on success, -errno on invalid input strings.
- * Error values:
- *    %-EINVAL: second number in range smaller than first
- *    %-EINVAL: invalid character in string
- *    %-ERANGE: bit number specified too large for mask
+ * Returns: 0 on success, -errno on invalid input strings. Error values:
+ *
+ *   - ``-EINVAL``: second number in range smaller than first
+ *   - ``-EINVAL``: invalid character in string
+ *   - ``-ERANGE``: bit number specified too large for mask
  */
 static int __bitmap_parselist(const char *buf, unsigned int buflen,
 		int is_user, unsigned long *maskp,
@@ -864,14 +864,16 @@ EXPORT_SYMBOL(bitmap_bitremap);
  *  11 was set in @orig had no affect on @dst.
  *
  * Example [2] for bitmap_fold() + bitmap_onto():
- *  Let's say @relmap has these ten bits set:
+ *  Let's say @relmap has these ten bits set::
+ *
  *		40 41 42 43 45 48 53 61 74 95
+ *
  *  (for the curious, that's 40 plus the first ten terms of the
  *  Fibonacci sequence.)
  *
  *  Further lets say we use the following code, invoking
  *  bitmap_fold() then bitmap_onto, as suggested above to
- *  avoid the possibility of an empty @dst result:
+ *  avoid the possibility of an empty @dst result::
  *
  *	unsigned long *tmp;	// a temporary bitmap's bits
  *
@@ -882,22 +884,26 @@ EXPORT_SYMBOL(bitmap_bitremap);
  *  various @orig's.  I list the zero-based positions of each set bit.
  *  The tmp column shows the intermediate result, as computed by
  *  using bitmap_fold() to fold the @orig bitmap modulo ten
- *  (the weight of @relmap).
+ *  (the weight of @relmap):
  *
+ *      =============== ============== =================
  *      @orig           tmp            @dst
  *      0                0             40
  *      1                1             41
  *      9                9             95
- *      10               0             40 (*)
+ *      10               0             40 [#f1]_
  *      1 3 5 7          1 3 5 7       41 43 48 61
  *      0 1 2 3 4        0 1 2 3 4     40 41 42 43 45
  *      0 9 18 27        0 9 8 7       40 61 74 95
  *      0 10 20 30       0             40
  *      0 11 22 33       0 1 2 3       40 41 42 43
  *      0 12 24 36       0 2 4 6       40 42 45 53
- *      78 102 211       1 2 8         41 42 74 (*)
+ *      78 102 211       1 2 8         41 42 74 [#f1]_
+ *      =============== ============== =================
  *
- * (*) For these marked lines, if we hadn't first done bitmap_fold()
+ * .. [#f1]
+ *
+ *     For these marked lines, if we hadn't first done bitmap_fold()
  *     into tmp, then the @dst result would have been empty.
  *
  * If either of @orig or @relmap is empty (no set bits), then @dst
-- 
2.9.3
