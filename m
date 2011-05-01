Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:52413 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755727Ab1EATGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 15:06:05 -0400
Received: from tobias-t61p.localnet (unknown [10.2.3.10])
	by mail.lorenz.priv (Postfix) with ESMTPS id 2AB5114206
	for <linux-media@vger.kernel.org>; Sun,  1 May 2011 21:06:01 +0200 (CEST)
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/6] correct initialization of demphasis
Date: Sun, 1 May 2011 21:01:15 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105012101.15241.tobias.lorenz@gmx.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch corrects the initialization of demphasis.

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
---
 drivers/media/radio/si470x/radio-si470x-common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c 
b/drivers/media/radio/si470x/radio-si470x-common.c
index ac76dfe..f016220 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -357,7 +357,8 @@ int si470x_start(struct si470x_device *radio)
 		goto done;
 
 	/* sysconfig 1 */
-	radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
+	radio->registers[SYSCONFIG1] =
+		(de << 11) & SYSCONFIG1_DE;		/* DE */
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
 		goto done;
-- 
1.7.4.1

