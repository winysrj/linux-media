Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:56742 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753552AbdGNJdO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:33:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>,
        Matan Barak <matanb@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH 11/14] IB/uverbs: fix gcc-7 type warning
Date: Fri, 14 Jul 2017 11:31:04 +0200
Message-Id: <20170714093129.1366900-2-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using ccache, we get a harmless warning about the fact that
we use the result of a multiplication as a condition:

drivers/infiniband/core/uverbs_main.c: In function 'ib_uverbs_write':
drivers/infiniband/core/uverbs_main.c:787:40: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/infiniband/core/uverbs_main.c:787:117: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/infiniband/core/uverbs_main.c:790:50: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/infiniband/core/uverbs_main.c:790:151: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]

This changes the macro to explicitly check the number for a positive
length, which avoids the warning.

Fixes: a96e4e2ffe43 ("IB/uverbs: New macro to set pointers to NULL if length is 0 in INIT_UDATA()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/core/uverbs.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 64d494a64daf..364d7de05721 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -55,12 +55,14 @@
 		(udata)->outlen = (olen);				\
 	} while (0)
 
-#define INIT_UDATA_BUF_OR_NULL(udata, ibuf, obuf, ilen, olen)			\
-	do {									\
-		(udata)->inbuf  = (ilen) ? (const void __user *) (ibuf) : NULL;	\
-		(udata)->outbuf = (olen) ? (void __user *) (obuf) : NULL;	\
-		(udata)->inlen  = (ilen);					\
-		(udata)->outlen = (olen);					\
+#define INIT_UDATA_BUF_OR_NULL(udata, ibuf, obuf, ilen, olen)		\
+	do {								\
+		(udata)->inbuf  = (ilen) > 0 ?				\
+				  (const void __user *) (ibuf) : NULL;	\
+		(udata)->outbuf = (olen) > 0 ?				\
+				  (void __user *) (obuf) : NULL;	\
+		(udata)->inlen  = (ilen);				\
+		(udata)->outlen = (olen);				\
 	} while (0)
 
 /*
-- 
2.9.0
