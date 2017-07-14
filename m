Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:62117 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753492AbdGNJ3T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:29:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Pratyush Anand <panand@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 07/14] proc/kcore: hide a harmless warning
Date: Fri, 14 Jul 2017 11:25:19 +0200
Message-Id: <20170714092540.1217397-8-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc warns when MODULES_VADDR/END is defined to the same value as
VMALLOC_START/VMALLOC_END, e.g. on x86-32:

fs/proc/kcore.c: In function ‘add_modules_range’:
fs/proc/kcore.c:622:161: error: self-comparison always evaluates to false [-Werror=tautological-compare]
  if (/*MODULES_VADDR != VMALLOC_START && */MODULES_END != VMALLOC_END) {

The code is correct as it is required for most other configurations.
The best workaround I found for shutting up that warning is to make
it a little more complex by adding a temporary variable. The compiler
will still optimize away the code as it finds the two to be identical,
but it no longer warns because it doesn't condider the comparison
"tautological" any more.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/proc/kcore.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 45629f4b5402..c503ad657c46 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -620,12 +620,14 @@ static void __init proc_kcore_text_init(void)
 /*
  * MODULES_VADDR has no intersection with VMALLOC_ADDR.
  */
-struct kcore_list kcore_modules;
+static struct kcore_list kcore_modules;
 static void __init add_modules_range(void)
 {
-	if (MODULES_VADDR != VMALLOC_START && MODULES_END != VMALLOC_END) {
-		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
-			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
+	void *start = (void *)MODULES_VADDR;
+	size_t len = MODULES_END - MODULES_VADDR;
+
+	if (start != (void *)VMALLOC_START && len != VMALLOC_END - VMALLOC_START) {
+		kclist_add(&kcore_modules, start, len, KCORE_VMALLOC);
 	}
 }
 #else
-- 
2.9.0
