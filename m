Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39029 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751836AbdKNLPe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Nov 2017 06:15:34 -0500
Received: by mail-wm0-f68.google.com with SMTP id l8so15059021wmg.4
        for <linux-media@vger.kernel.org>; Tue, 14 Nov 2017 03:15:34 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org,
        =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
Subject: [PATCH] dvb_local_open(): strdup fname before calling dvb_fe_open_fname()
Date: Tue, 14 Nov 2017 12:15:26 +0100
Message-Id: <20171114111526.5500-1-funman@videolan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Issue spotted by valgrind:

==5290== Invalid free() / delete / delete[] / realloc()
==5290==    at 0x4C30D3B: free (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==5290==    by 0x4E54401: free_dvb_dev (dvb-dev.c:49)
==5290==    by 0x4E5449A: dvb_dev_free_devices (dvb-dev.c:94)
==5290==    by 0x4E547BA: dvb_dev_free (dvb-dev.c:121)
==5290==    by 0x10881A: main (leak.c:26)
==5290==  Address 0x5e55910 is 0 bytes inside a block of size 28 free'd
==5290==    at 0x4C30D3B: free (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==5290==    by 0x4E56504: dvb_v5_free (dvb-fe.c:85)
==5290==    by 0x4E547B2: dvb_dev_free (dvb-dev.c:119)
==5290==    by 0x10881A: main (leak.c:26)
==5290==  Block was alloc'd at
==5290==    at 0x4C2FB0F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==5290==    by 0x5119C39: strdup (strdup.c:42)
==5290==    by 0x4E55B42: handle_device_change (dvb-dev-local.c:137)
==5290==    by 0x4E561DA: dvb_local_find (dvb-dev-local.c:323)
==5290==    by 0x10880E: main (leak.c:10)

Signed-off-by: Rafaël Carré <funman@videolan.org>
---
 lib/libdvbv5/dvb-dev-local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libdvbv5/dvb-dev-local.c b/lib/libdvbv5/dvb-dev-local.c
index 920e81fb..b50b61b4 100644
--- a/lib/libdvbv5/dvb-dev-local.c
+++ b/lib/libdvbv5/dvb-dev-local.c
@@ -440,7 +440,7 @@ static struct dvb_open_descriptor
 		 */
 		flags &= ~O_NONBLOCK;
 
-		ret = dvb_fe_open_fname(parms, dev->path, flags);
+		ret = dvb_fe_open_fname(parms, strdup(dev->path), flags);
 		if (ret) {
 			free(open_dev);
 			return NULL;
-- 
2.14.1
