Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50632 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbeKFUUc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 15:20:32 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>, devel@driverdev.osuosl.org
Subject: [PATCH] media: dm365_ipipeif: better annotate a fall though
Date: Tue,  6 Nov 2018 05:55:51 -0500
Message-Id: <6d03257da95f7d8db273496733a9e9871936bcff.1541501746.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Shut up this warning:

	drivers/staging/media/davinci_vpfe/dm365_ipipeif.c: In function 'ipipeif_hw_setup':
	drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:298:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
	   switch (isif_port_if) {
	   ^~~~~~
	drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:314:2: note: here
	  case IPIPEIF_SDRAM_YUV:
	  ^~~~

By annotating a fall though case at the right place.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index a53231b08d30..e3425bf082ae 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -310,6 +310,7 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
 			ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG2);
 			break;
 		}
+		/* fall through */
 
 	case IPIPEIF_SDRAM_YUV:
 		/* Set clock divider */
-- 
2.19.1
