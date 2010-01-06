Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:59105 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab0AFRa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2010 12:30:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: video/tuner-core, fix memory leak
Date: Wed,  6 Jan 2010 17:47:55 +0100
Message-Id: <1262796476-17737-1-git-send-email-jslaby@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stanse found a memory leak in tuner_probe. t is not
freed/assigned on all paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/tuner-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 5b3eaa1..c4dab6c 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1078,6 +1078,7 @@ static int tuner_probe(struct i2c_client *client,
 
 				goto register_client;
 			}
+			kfree(t);
 			return -ENODEV;
 		case 0x42:
 		case 0x43:
-- 
1.6.5.7

