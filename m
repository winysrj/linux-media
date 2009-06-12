Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:31521 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764272AbZFLSva (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 14:51:30 -0400
Message-ID: <4A32A2CE.40002@oracle.com>
Date: Fri, 12 Jun 2009 11:47:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] v4l: expose function outside of ifdef/endif block
References: <20090612185601.be53b034.sfr@canb.auug.org.au>
In-Reply-To: <20090612185601.be53b034.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Move v4l_bound_align_image() outside of an #ifdef CONFIG_I2C block
so that it is always built.  Fixes a build error:

vivi.c:(.text+0x48e26): undefined reference to `v4l_bound_align_image'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/v4l2-common.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-next-20090612.orig/drivers/media/video/v4l2-common.c
+++ linux-next-20090612/drivers/media/video/v4l2-common.c
@@ -915,6 +915,7 @@ const unsigned short *v4l2_i2c_tuner_add
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_tuner_addrs);
+#endif
 
 /* Clamp x to be between min and max, aligned to a multiple of 2^align.  min
  * and max don't have to be aligned, but there must be at least one valid
@@ -986,5 +987,3 @@ void v4l_bound_align_image(u32 *w, unsig
 	}
 }
 EXPORT_SYMBOL_GPL(v4l_bound_align_image);
-
-#endif


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
