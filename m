Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:25945 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715AbcEQOy3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 10:54:29 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Antti Palosaari <crope@iki.fi>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] [media] mn88472: fix typo
Date: Tue, 17 May 2016 16:38:42 +0200
Message-Id: <1463495926-13728-4-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1463495926-13728-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1463495926-13728-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

firmare -> firmware

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/media/mn88472/mn88472.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index 7ea749c..5cfa22a 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -312,7 +312,7 @@ static int mn88472_init(struct dvb_frontend *fe)
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, &client->dev);
 	if (ret) {
-		dev_err(&client->dev, "firmare file '%s' not found\n",
+		dev_err(&client->dev, "firmware file '%s' not found\n",
 				fw_file);
 		goto err;
 	}

