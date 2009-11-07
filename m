Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42374 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbZKGVvE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:51:04 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:51:06 +0000
Message-ID: <1257630666.15927.421.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 27/75] bttv: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/bt8xx/bttv-cards.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 12279f6..000b970 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -3820,6 +3820,8 @@ static int __devinit pvr_boot(struct bttv *btv)
 	return rc;
 }
 
+MODULE_FIRMWARE("hcwamc.rbf");
+
 /* ----------------------------------------------------------------------- */
 /* some osprey specific stuff                                              */
 
-- 
1.6.5.2



