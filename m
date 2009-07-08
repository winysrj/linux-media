Return-path: <linux-media-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:53202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758987AbZGHQEw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jul 2009 12:04:52 -0400
Subject: [PATCH 32/44] includecheck fix: drivers/video, vgacon.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Martin Mares <mj@ucw.cz>, mchehab@infradead.org,
	linux-media@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
	LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:10:24 +0530
Message-Id: <1247067624.4382.88.camel@ht.satnam>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


fix the following 'make includecheck' warning:

  drivers/video/console/vgacon.c: linux/slab.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/video/console/vgacon.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 59d7d5e..74e96cf 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -180,7 +180,6 @@ static inline void vga_set_mem_top(struct vc_data *c)
 }
 
 #ifdef CONFIG_VGACON_SOFT_SCROLLBACK
-#include <linux/slab.h>
 /* software scrollback */
 static void *vgacon_scrollback;
 static int vgacon_scrollback_tail;
-- 
1.6.0.6



