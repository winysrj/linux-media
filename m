Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40204 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2HCRwp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 13:52:45 -0400
Received: by ghrr11 with SMTP id r11so1137724ghr.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 10:52:45 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] em28xx: Fix height setting on non-progressive captures
Date: Fri,  3 Aug 2012 14:52:32 -0300
Message-Id: <1344016352-20302-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was introduced on commit c2a6b54a9:
"em28xx: fix: don't do image interlacing on webcams"
It is a known bug that has already been reported several times
and confirmed by Mauro.
Tested by compilation only.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Hi,

I have no idea why this hasn't been fixed before.

See this mail for Mauro's confirmation
http://www.digipedia.pl/usenet/thread/18550/7691/#post7685
where he requested a patch on reporter. 

I guess the patch never came in.

Regards,
Ezequiel.
---
 drivers/media/video/em28xx/em28xx-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index de2cb20..6daa861 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -786,7 +786,7 @@ int em28xx_resolution_set(struct em28xx *dev)
 		dev->vbi_height = 18;
 
 	if (!dev->progressive)
-		height >>= norm_maxh(dev);
+		height = height / 2;
 
 	em28xx_set_outfmt(dev);
 
-- 
1.7.4.4

