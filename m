Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:59663 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdGNJbQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:31:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/14] SFI: fix tautological-compare warning
Date: Fri, 14 Jul 2017 11:30:12 +0200
Message-Id: <20170714093021.1341005-1-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With ccache in combination with gcc-6, we get a harmless warning for the sfi subsystem,
as ccache only sees the preprocessed source:

drivers/sfi/sfi_core.c: In function ‘sfi_map_table’:
drivers/sfi/sfi_core.c:175:53: error: self-comparison always evaluates to true [-Werror=tautological-compare]

Using an inline function to do the comparison tells the compiler what is
going on even for preprocessed files, and avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/sfi/sfi_core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index 296db7a69c27..a8f2313a2613 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -71,9 +71,12 @@
 
 #include "sfi_core.h"
 
-#define ON_SAME_PAGE(addr1, addr2) \
-	(((unsigned long)(addr1) & PAGE_MASK) == \
-	((unsigned long)(addr2) & PAGE_MASK))
+static inline bool on_same_page(unsigned long addr1, unsigned long addr2)
+{
+	return (addr1 & PAGE_MASK) == (addr2 & PAGE_MASK);
+}
+
+#define ON_SAME_PAGE(addr1, addr2) on_same_page((unsigned long)addr1, (unsigned long)addr2)
 #define TABLE_ON_PAGE(page, table, size) (ON_SAME_PAGE(page, table) && \
 				ON_SAME_PAGE(page, table + size))
 
-- 
2.9.0
