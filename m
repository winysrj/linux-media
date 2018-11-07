Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51193 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbeKHBHZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 20:07:25 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH] keytable: fix BPF protocol compilation on mips
Date: Wed,  7 Nov 2018 15:36:31 +0000
Message-Id: <20181107153631.15908-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clang -idirafter /usr/local/include -idirafter
+/usr/lib/llvm-6.0/lib/clang/6.0.1/include -idirafter
+/usr/include/mips64el-linux-gnuabi64 -idirafter /usr/include
+-I../../../include -target bpf -O2 -c grundig.c
> In file included from grundig.c:5:
> In file included from ../../../include/linux/lirc.h:10:
> In file included from /usr/include/linux/types.h:9:
> In file included from /usr/include/linux/posix_types.h:36:
> In file included from
+/usr/include/mips64el-linux-gnuabi64/asm/posix_types.h:13:
> /usr/include/mips64el-linux-gnuabi64/asm/sgidefs.h:19:2: error: Use a Linux
+compiler or give up.
> #error Use a Linux compiler or give up.

This requires __linux__ to be defined.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/bpf_protocols/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/keytable/bpf_protocols/Makefile.am b/utils/keytable/bpf_protocols/Makefile.am
index 8887b897..ba79742c 100644
--- a/utils/keytable/bpf_protocols/Makefile.am
+++ b/utils/keytable/bpf_protocols/Makefile.am
@@ -8,7 +8,7 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
         | sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
 
 %.o: %.c bpf_helpers.h
-	$(CLANG) $(CLANG_SYS_INCLUDES) -I$(top_srcdir)/include -target bpf -O2 -c $<
+	$(CLANG) $(CLANG_SYS_INCLUDES) -D__linux__ -I$(top_srcdir)/include -target bpf -O2 -c $<
 
 PROTOCOLS = grundig.o pulse_distance.o pulse_length.o rc_mm.o manchester.o
 
-- 
2.17.2
