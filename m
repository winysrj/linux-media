Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42223 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752150AbdFUIIe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 04:08:34 -0400
From: Johannes Thumshirn <jthumshirn@suse.de>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH RESEND 4/7] [media] cx25821: use MEDIA_REVISION instead of KERNEL_VERSION
Date: Wed, 21 Jun 2017 10:08:09 +0200
Message-Id: <20170621080812.6817-5-jthumshirn@suse.de>
In-Reply-To: <20170621080812.6817-1-jthumshirn@suse.de>
References: <20170621080812.6817-1-jthumshirn@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use MEDIA_REVISION instead of KERNEL_VERSION to encode the
CX25821_VERSION_CODE.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/media/pci/cx25821/cx25821.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 0f20e89b0cde..7fea6b07cf19 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -41,7 +41,7 @@
 #include <linux/version.h>
 #include <linux/mutex.h>
 
-#define CX25821_VERSION_CODE KERNEL_VERSION(0, 0, 106)
+#define CX25821_VERSION_CODE MEDIA_REVISION(0, 0, 106)
 
 #define UNSET (-1U)
 #define NO_SYNC_LINE (-1U)
-- 
2.12.3
