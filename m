Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:63044 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753471AbdGNJ3T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:29:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org,
        Bill Metzenthen <billm@melbpc.org.au>, x86@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 04/14] x86: math-emu: avoid -Wint-in-bool-context warning
Date: Fri, 14 Jul 2017 11:25:16 +0200
Message-Id: <20170714092540.1217397-5-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The setsign() macro gets called with an integer argument in a
few places, leading to a harmless warning in gcc-7:

arch/x86/math-emu/reg_add_sub.c: In function 'FPU_add':
arch/x86/math-emu/reg_add_sub.c:80:48: error: ?: using integer constants in boolean context [-Werror=int-in-bool-context]

This turns the integer into a boolean expression by comparing it
to zero.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/math-emu/fpu_emu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/math-emu/fpu_emu.h b/arch/x86/math-emu/fpu_emu.h
index afbc4d805d66..c9c320dccca1 100644
--- a/arch/x86/math-emu/fpu_emu.h
+++ b/arch/x86/math-emu/fpu_emu.h
@@ -157,7 +157,7 @@ extern u_char const data_sizes_16[32];
 
 #define signbyte(a) (((u_char *)(a))[9])
 #define getsign(a) (signbyte(a) & 0x80)
-#define setsign(a,b) { if (b) signbyte(a) |= 0x80; else signbyte(a) &= 0x7f; }
+#define setsign(a,b) { if ((b) != 0) signbyte(a) |= 0x80; else signbyte(a) &= 0x7f; }
 #define copysign(a,b) { if (getsign(a)) signbyte(b) |= 0x80; \
                         else signbyte(b) &= 0x7f; }
 #define changesign(a) { signbyte(a) ^= 0x80; }
-- 
2.9.0
