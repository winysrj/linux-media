Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:51326
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932289AbbE1VLt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:11:49 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Antti Palosaari <crope@iki.fi>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] drivers/media/tuners/e4000.c: drop unneeded goto
Date: Thu, 28 May 2015 23:02:22 +0200
Message-Id: <1432846944-7122-8-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1432846944-7122-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1432846944-7122-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete jump to a label on the next line, when that label is not
used elsewhere.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier l;
@@

-if (...) goto l;
-l:
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/tuners/e4000.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 510239f..50c0f0d 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -103,9 +103,6 @@ static int e4000_sleep(struct dvb_frontend *fe)
 
 	ret = regmap_write(s->regmap, 0x00, 0x00);
 	if (ret)
-		goto err;
-err:
-	if (ret)
 		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
 	return ret;

