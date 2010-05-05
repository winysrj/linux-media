Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39873 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759829Ab0EEPU1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 May 2010 11:20:27 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linuxppc-dev@ozlabs.org
Subject: [PATCH] media/IR: Add missing include file to rc-map.c
Date: Wed, 5 May 2010 17:20:21 +0200
Cc: "David =?iso-8859-1?q?H=E4rdeman?=" <david@hardeman.nu>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-mips@linux-mips.org,
	linux-m68k@lists.linux-m68k.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005051720.22617.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Huewe <peterhuewe@gmx.de>

This patch adds a missing include linux/delay.h to prevent
build failures[1-5]

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20100505

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2571452/
[2] http://kisskb.ellerman.id.au/kisskb/buildresult/2571188/
[3] http://kisskb.ellerman.id.au/kisskb/buildresult/2571479/
[4] http://kisskb.ellerman.id.au/kisskb/buildresult/2571429/
[5] http://kisskb.ellerman.id.au/kisskb/buildresult/2571432/

drivers/media/IR/rc-map.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/IR/rc-map.c b/drivers/media/IR/rc-map.c
index caf6a27..46a8f15 100644
--- a/drivers/media/IR/rc-map.c
+++ b/drivers/media/IR/rc-map.c
@@ -14,6 +14,7 @@
 
 #include <media/ir-core.h>
 #include <linux/spinlock.h>
+#include <linux/delay.h>
 
 /* Used to handle IR raw handler extensions */
 static LIST_HEAD(rc_map_list);
-- 
1.6.4.4

