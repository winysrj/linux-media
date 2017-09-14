Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:54249 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdINLHq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 07:07:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Hans Verkuil <hansverk@cisco.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rcar_drif: fix potential uninitialized variable use
Date: Thu, 14 Sep 2017 13:07:27 +0200
Message-Id: <20170914110733.3592437-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Older compilers like gcc-4.6 may run into a case that returns
an uninitialized variable from rcar_drif_enable_rx() if that
function was ever called with an empty cur_ch_mask:

drivers/media/platform/rcar_drif.c:658:2: error: ‘ret’ may be used uninitialized in this function [-Werror=uninitialized]

Newer compilers don't have that problem as they optimize the
'ret' variable away and just return zero in that case.

This changes the function to return -EINVAL for this particular
failure, to make it consistent across all compiler versions.
In case gcc gets changed to report a warning for it in the
future, it's also a good idea to shut it up now.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82203
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/rcar_drif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index 522364ff0d5d..2c6afd38b78a 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -630,7 +630,7 @@ static int rcar_drif_enable_rx(struct rcar_drif_sdr *sdr)
 {
 	unsigned int i;
 	u32 ctr;
-	int ret;
+	int ret = -EINVAL;
 
 	/*
 	 * When both internal channels are enabled, they can be synchronized
-- 
2.9.0
