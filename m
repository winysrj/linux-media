Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:49744 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbdJDNfi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 09:35:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [STABLE-4.13] [media] imx-media-of: avoid uninitialized variable warning
Date: Wed,  4 Oct 2017 15:34:55 +0200
Message-Id: <20171004133507.3539072-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replaces upstream commit 0b2e9e7947e7 ("media: staging/imx: remove
confusing IS_ERR_OR_NULL usage")

We get a harmless warning about a potential uninitialized variable
use in the driver:

drivers/staging/media/imx/imx-media-of.c: In function 'of_parse_subdev':
drivers/staging/media/imx/imx-media-of.c:216:4: warning: 'remote_np' may be used uninitialized in this function [-Wmaybe-uninitialized]

I reworked that code to be easier to understand by gcc in mainline,
but that commit is too large to backport. This is a much simpler
workaround, avoiding the warning by adding a fake initialization
to the variable. The driver was only introduced in linux-4.13,
so the workaround is not needed for earlier stable kernels.

Fixes: e130291212df ("[media] media: Add i.MX media core driver")
Cc: stable@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/imx/imx-media-of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index b026fe66467c..90e7e702a411 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -167,7 +167,7 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
 		of_parse_sensor(imxmd, imxsd, sd_np);
 
 	for (i = 0; i < num_pads; i++) {
-		struct device_node *epnode = NULL, *port, *remote_np;
+		struct device_node *epnode = NULL, *port, *remote_np = NULL;
 		struct imx_media_subdev *remote_imxsd;
 		struct imx_media_pad *pad;
 		int remote_pad;
-- 
2.9.0
