Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:38729 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933409AbdLSJL5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 04:11:57 -0500
Received: by mail-wr0-f196.google.com with SMTP id o2so18120453wro.5
        for <linux-media@vger.kernel.org>; Tue, 19 Dec 2017 01:11:56 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: linux-media@vger.kernel.org
Cc: kierank@obe.tv,
        =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
Subject: [PATCH] Statically linking libdvbv5 must include -ludev
Date: Tue, 19 Dec 2017 10:11:50 +0100
Message-Id: <20171219091150.12761-1-funman@videolan.org>
In-Reply-To: <CAK+ULv4S5BasNqQsfDAybyDyakXfq0PqKAUezuwaf7HNQZU3Lg@mail.gmail.com>
References: <CAK+ULv4S5BasNqQsfDAybyDyakXfq0PqKAUezuwaf7HNQZU3Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Rafaël Carré <funman@videolan.org>
---
 lib/libdvbv5/libdvbv5.pc.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/libdvbv5/libdvbv5.pc.in b/lib/libdvbv5/libdvbv5.pc.in
index 7e3c4f5c..6b5f292d 100644
--- a/lib/libdvbv5/libdvbv5.pc.in
+++ b/lib/libdvbv5/libdvbv5.pc.in
@@ -6,5 +6,6 @@ libdir=@libdir@
 Name: libdvbv5
 Description: DVBv5 utility library
 Version: @PACKAGE_VERSION@
+Requires.private: libudev
 Libs: -L${libdir} -ldvbv5
 Cflags: -I${includedir}
-- 
2.14.1
