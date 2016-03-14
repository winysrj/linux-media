Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:55729 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbcCNWlK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 18:41:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Benoit Parrot <bparrot@ti.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] [media] am437x-vfpe: fix typo in vpfe_get_app_input_index
Date: Mon, 14 Mar 2016 23:40:08 +0100
Message-Id: <1457995225-1199991-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1457995225-1199991-1-git-send-email-arnd@arndb.de>
References: <1457995225-1199991-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc-6 points out an obviously silly comparison in vpfe_get_app_input_index():

drivers/media/platform/am437x/am437x-vpfe.c: In function 'vpfe_get_app_input_index':
drivers/media/platform/am437x/am437x-vpfe.c:1709:27: warning: self-comparison always evaluats to true [-Wtautological-compare]
       client->adapter->nr == client->adapter->nr) {
                           ^~

This was introduced in a slighly incorrect conversion, and it's
clear that the comparison was meant to compare the iterator
to the current subdev instead, as we do in the line above.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: d37232390fd4 ("[media] media: am437x-vpfe: match the OF node/i2c addr instead of name")
---
 drivers/media/platform/am437x/am437x-vpfe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index de32e3a3d4d1..e6a7bff4650c 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1706,7 +1706,7 @@ static int vpfe_get_app_input_index(struct vpfe_device *vpfe,
 		sdinfo = &cfg->sub_devs[i];
 		client = v4l2_get_subdevdata(sdinfo->sd);
 		if (client->addr == curr_client->addr &&
-		    client->adapter->nr == client->adapter->nr) {
+		    client->adapter->nr == curr_client->adapter->nr) {
 			if (vpfe->current_input >= 1)
 				return -1;
 			*app_input_index = j + vpfe->current_input;
-- 
2.7.0

