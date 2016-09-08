Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44277 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941159AbcIHPZU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Sep 2016 11:25:20 -0400
Date: Thu, 8 Sep 2016 17:25:16 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [media] cec: fix Kconfig help text
Message-ID: <20160908172516.211694b8@endymion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MEDIA_CEC is no longer a tristate option, so the user can't actually
choose M. Whether the code is built-in or built as a module is
decided somewhere else. 

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 5bb2399a4fe4 ("[media] cec: fix Kconfig dependency problems")
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/cec/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

--- linux-4.8-rc5.orig/drivers/staging/media/cec/Kconfig	2016-09-04 23:31:46.000000000 +0200
+++ linux-4.8-rc5/drivers/staging/media/cec/Kconfig	2016-09-08 17:20:03.048392694 +0200
@@ -5,9 +5,6 @@ config MEDIA_CEC
 	---help---
 	  Enable the CEC API.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called cec.
-
 config MEDIA_CEC_DEBUG
 	bool "CEC debugfs interface (EXPERIMENTAL)"
 	depends on MEDIA_CEC && DEBUG_FS


-- 
Jean Delvare
SUSE L3 Support
