Return-path: <linux-media-owner@vger.kernel.org>
Received: from nautilus.laiva.org ([62.142.120.74]:53200 "EHLO
	nautilus.laiva.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbaHVQ5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 12:57:51 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] MAINTAINERS: add sp2 entry
Date: Fri, 22 Aug 2014 19:50:42 +0300
Message-Id: <1408726242-23337-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a maintainer for the new CIMaX SP2 driver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cdf24c..6139b66 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8451,6 +8451,14 @@ F:	include/sound/dmaengine_pcm.h
 F:	sound/core/pcm_dmaengine.c
 F:	sound/soc/soc-generic-dmaengine-pcm.c
 
+SP2 MEDIA DRIVER
+M:	Olli Salonen <olli.salonen@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+S:	Maintained
+F:	drivers/media/dvb-frontends/sp2*
+
 SPARC + UltraSPARC (sparc/sparc64)
 M:	"David S. Miller" <davem@davemloft.net>
 L:	sparclinux@vger.kernel.org
-- 
1.7.0.4

