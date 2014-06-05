Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35495 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaFEHIZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 03:08:25 -0400
Received: by mail-pb0-f48.google.com with SMTP id rr13so701314pbb.7
        for <linux-media@vger.kernel.org>; Thu, 05 Jun 2014 00:08:25 -0700 (PDT)
Date: Thu, 5 Jun 2014 17:07:48 +1000
From: Vitaly Osipov <vitaly.osipov@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: omap4iss: copy paste error in iss_get_clocks
Message-ID: <20140605070748.GA651@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It makes more sense to return PTR_ERR(iss->iss_ctrlclk) here. The
current code looks like an oversight in pasting the block just above
this one.

Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>
---
 drivers/staging/media/omap4iss/iss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 2e422dd..4a9e444 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1029,7 +1029,7 @@ static int iss_get_clocks(struct iss_device *iss)
 	if (IS_ERR(iss->iss_ctrlclk)) {
 		dev_err(iss->dev, "Unable to get iss_ctrlclk clock info\n");
 		iss_put_clocks(iss);
-		return PTR_ERR(iss->iss_fck);
+		return PTR_ERR(iss->iss_ctrlclk);
 	}
 
 	return 0;
-- 
1.9.1

