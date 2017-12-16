Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:39628 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756834AbdLPSnv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 13:43:51 -0500
Received: by mail-lf0-f65.google.com with SMTP id m20so639930lfi.6
        for <linux-media@vger.kernel.org>; Sat, 16 Dec 2017 10:43:51 -0800 (PST)
MIME-Version: 1.0
From: Kieran Kunhya <kierank@obe.tv>
Date: Sat, 16 Dec 2017 18:43:49 +0000
Message-ID: <CAK+ULv4S5BasNqQsfDAybyDyakXfq0PqKAUezuwaf7HNQZU3Lg@mail.gmail.com>
Subject: [PATCH] libdvbv5: Add libudev to pkg-config file
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 8ca5f86d480f397f32626250cebab5b63eb79034 Mon Sep 17 00:00:00 2001
From: Kieran Kunhya <kierank@obe.tv>
Date: Sat, 16 Dec 2017 18:40:22 +0000
Subject: [PATCH] libdvbv5: Add libudev to pkg-config file

Signed-off-by: Kieran Kunhya <kierank@obe.tv>
---
 lib/libdvbv5/libdvbv5.pc.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libdvbv5/libdvbv5.pc.in b/lib/libdvbv5/libdvbv5.pc.in
index 7e3c4f5c..04e0edb3 100644
--- a/lib/libdvbv5/libdvbv5.pc.in
+++ b/lib/libdvbv5/libdvbv5.pc.in
@@ -6,5 +6,5 @@ libdir=@libdir@
 Name: libdvbv5
 Description: DVBv5 utility library
 Version: @PACKAGE_VERSION@
-Libs: -L${libdir} -ldvbv5
+Libs: -L${libdir} -ldvbv5 -ludev
 Cflags: -I${includedir}
-- 
2.11.0.windows.1
