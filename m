Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:39042 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932916AbcL0SDO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 13:03:14 -0500
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>,
        stable@vger.kernel.org
Subject: [PATCH] [media] am437x-vpfe: always assign bpp variable
Date: Tue, 27 Dec 2016 19:02:36 +0100
Message-Id: <20161227180236.11150-1-nicolas.iooss_linux@m4x.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In vpfe_s_fmt(), when the sensor format and the requested format were
the same, bpp was assigned to vpfe->bpp without being initialized first.

Grab the bpp value that is currently used by using __vpfe_get_format()
instead of its wrapper, vpfe_try_fmt().

This use of uninitialized variable has been found by compiling the
kernel with clang.

Fixes: 417d2e507edc ("[media] media: platform: add VPFE capture driver
support for AM437X")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/media/platform/am437x/am437x-vpfe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index b33b9e35e60e..05489a401c5c 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1576,7 +1576,7 @@ static int vpfe_s_fmt(struct file *file, void *priv,
 		return -EBUSY;
 	}
 
-	ret = vpfe_try_fmt(file, priv, &format);
+	ret = __vpfe_get_format(vpfe, &format, &bpp);
 	if (ret)
 		return ret;
 
-- 
2.11.0

