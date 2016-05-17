Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:19182 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702AbcEQOy3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 10:54:29 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Antti Palosaari <crope@iki.fi>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] [media] mn88473: fix typo
Date: Tue, 17 May 2016 16:38:41 +0200
Message-Id: <1463495926-13728-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1463495926-13728-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1463495926-13728-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

firmare -> firmware

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/dvb-frontends/mn88473.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index 6c5d5921..8f7b68f 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -330,7 +330,7 @@ static int mn88473_init(struct dvb_frontend *fe)
 	/* Request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, name, &client->dev);
 	if (ret) {
-		dev_err(&client->dev, "firmare file '%s' not found\n", name);
+		dev_err(&client->dev, "firmware file '%s' not found\n", name);
 		goto err;
 	}
 

