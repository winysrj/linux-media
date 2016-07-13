Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbcGMToh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 15:44:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	stephen hemminger <stephen@networkplumber.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roopa Prabhu <roopa@cumulusnetworks.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Alexandre Bounine <alexandre.bounine@idt.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mike Frysinger <vapier@gentoo.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Pablo Neira <pablo@netfilter.org>
Subject: [PATCH] uapi: export lirc.h header
Date: Wed, 13 Jul 2016 16:43:52 -0300
Message-Id: <320c765d32bfc82c582e336d52ffe1026c73c644.1468439021.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This header contains the userspace API for lirc.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/uapi/linux/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 8bdae34d1f9a..ec10cfef166a 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -245,6 +245,7 @@ endif
 header-y += hw_breakpoint.h
 header-y += l2tp.h
 header-y += libc-compat.h
+header-y += lirc.h
 header-y += limits.h
 header-y += llc.h
 header-y += loop.h
-- 
2.7.4

