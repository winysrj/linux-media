Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49593 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934778AbdC3ULp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 16:11:45 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6/9] kernel-api.rst: fix output of the vsnprintf() documentation
Date: Thu, 30 Mar 2017 17:11:33 -0300
Message-Id: <6994c1cfc9ecdf0116fd89269930ae6deb34a805.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsnprintf() kernel-doc comment uses % character with a special
meaning other than escaping a constant. As ReST already defines
``literal`` as an escape sequence, let's make kernel-doc handle it,
and use it at lib/vsprintf.c.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 lib/vsprintf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index e3bf4e0f10b5..176641cc549d 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1954,13 +1954,13 @@ set_precision(struct printf_spec *spec, int prec)
  * This function generally follows C99 vsnprintf, but has some
  * extensions and a few limitations:
  *
- * %n is unsupported
- * %p* is handled by pointer()
+ *  - ``%n`` is unsupported
+ *  - ``%p*`` is handled by pointer()
  *
  * See pointer() or Documentation/printk-formats.txt for more
  * extensive description.
  *
- * ** Please update the documentation in both places when making changes **
+ * **Please update the documentation in both places when making changes**
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
-- 
2.9.3
