Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:25486 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaHTNm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 09:42:58 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Grant Likely <grant.likely@linaro.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Michal Simek <monstr@monstr.eu>
Subject: [PATCH/RFC v5 1/2] of: add of_node_ncmp wrapper
Date: Wed, 20 Aug 2014 15:42:42 +0200
Message-id: <1408542163-32764-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1408542163-32764-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542163-32764-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The wrapper for strnicmp is required for checking whether a node has
expected prefix.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/sparc/include/asm/prom.h |    1 +
 include/linux/of.h            |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index d955c8d..272f87a 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -30,6 +30,7 @@
 #define of_compat_cmp(s1, s2, l)	strncmp((s1), (s2), (l))
 #define of_prop_cmp(s1, s2)		strcasecmp((s1), (s2))
 #define of_node_cmp(s1, s2)		strcmp((s1), (s2))
+#define of_node_ncmp(s1, s2, n)		strnicmp((s1), (s2), (n))
 
 struct of_irq_controller {
 	unsigned int	(*irq_build)(struct device_node *, unsigned int, void *);
diff --git a/include/linux/of.h b/include/linux/of.h
index 6c4363b..b1e11ba 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -197,6 +197,7 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 #define of_compat_cmp(s1, s2, l)	strcasecmp((s1), (s2))
 #define of_prop_cmp(s1, s2)		strcmp((s1), (s2))
 #define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
+#define of_node_ncmp(s1, s2, n)		strnicmp((s1), (s2), (n))
 #endif
 
 /* flag descriptions */
-- 
1.7.9.5

