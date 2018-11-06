Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56738 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387480AbeKFTkJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 14:40:09 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH] davinci_vpfe: add a missing break
Date: Tue,  6 Nov 2018 05:15:33 -0500
Message-Id: <a08b85a2263d742edcd50d371712eaf11fbccd64.1541499323.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by gcc:

drivers/staging/media/davinci_vpfe/dm365_ipipeif.c: In function 'ipipeif_hw_setup':
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:298:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
   switch (isif_port_if) {
   ^~~~~~
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:314:2: note: here
  case IPIPEIF_SDRAM_YUV:
  ^~~~

There is a missing break for the raw format.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index a53231b08d30..975272bcf8ca 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -310,6 +310,7 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
 			ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG2);
 			break;
 		}
+		break;
 
 	case IPIPEIF_SDRAM_YUV:
 		/* Set clock divider */
-- 
2.19.1
