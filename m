Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47494 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389022AbeHGOkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 10:40:52 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Buesch <m@bues.ch>
Subject: [PATCH 3/3] media: xc4000: get rid of uneeded casts
Date: Tue,  7 Aug 2018 08:26:42 -0400
Message-Id: <cd16a8870253c57c858a16bf38708f50228cd95a.1533644783.git.mchehab+samsung@kernel.org>
In-Reply-To: <7fbc03c87b03ffb9128fe67bcbca6f1c6cc96c5c.1533644783.git.mchehab+samsung@kernel.org>
References: <7fbc03c87b03ffb9128fe67bcbca6f1c6cc96c5c.1533644783.git.mchehab+samsung@kernel.org>
In-Reply-To: <7fbc03c87b03ffb9128fe67bcbca6f1c6cc96c5c.1533644783.git.mchehab+samsung@kernel.org>
References: <7fbc03c87b03ffb9128fe67bcbca6f1c6cc96c5c.1533644783.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of doing casts, use %zd to print sizes, in order to make
smatch happier:
	drivers/media/tuners/xc4000.c:818 xc4000_fwupload() warn: argument 4 to %d specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/tuners/xc4000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index 76b3f37f24a8..eb6d65dae748 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -815,9 +815,9 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 		p += sizeof(size);
 
 		if (!size || size > endp - p) {
-			printk(KERN_ERR "Firmware type (%x), id %llx is corrupted (size=%d, expected %d)\n",
+			printk(KERN_ERR "Firmware type (%x), id %llx is corrupted (size=%zd, expected %d)\n",
 			       type, (unsigned long long)id,
-			       (unsigned)(endp - p), size);
+			       endp - p, size);
 			goto corrupt;
 		}
 
-- 
2.17.1
