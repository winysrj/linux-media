Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:7377 "EHLO
	mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965869AbbFJQc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 12:32:59 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1 linux-next] saa6588: use swap() in saa6588_i2c_poll()
Date: Wed, 10 Jun 2015 18:32:50 +0200
Message-Id: <1433953970-24388-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/i2c/saa6588.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/i2c/saa6588.c b/drivers/media/i2c/saa6588.c
index 2960b5a..2240e0a 100644
--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -301,9 +301,7 @@ static void saa6588_i2c_poll(struct saa6588 *s)
 	   first and the last of the 3 bytes block.
 	 */
 
-	tmp = tmpbuf[2];
-	tmpbuf[2] = tmpbuf[0];
-	tmpbuf[0] = tmp;
+	swap(tmpbuf[2], tmpbuf[0]);
 
 	/* Map 'Invalid block E' to 'Invalid Block' */
 	if (blocknum == 6)
-- 
2.4.2

