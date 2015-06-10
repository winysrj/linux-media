Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:7377 "EHLO
	mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965835AbbFJQc4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 12:32:56 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1 linux-next] saa7146: use swap() in sort_and_eliminate()
Date: Wed, 10 Jun 2015 18:32:41 +0200
Message-Id: <1433953962-24268-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/common/saa7146/saa7146_hlp.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_hlp.c b/drivers/media/common/saa7146/saa7146_hlp.c
index be746d1..3dc6a83 100644
--- a/drivers/media/common/saa7146/saa7146_hlp.c
+++ b/drivers/media/common/saa7146/saa7146_hlp.c
@@ -307,7 +307,7 @@ static int calculate_v_scale_registers(struct saa7146_dev *dev, enum v4l2_field
 /* simple bubble-sort algorithm with duplicate elimination */
 static int sort_and_eliminate(u32* values, int* count)
 {
-	int low = 0, high = 0, top = 0, temp = 0;
+	int low = 0, high = 0, top = 0;
 	int cur = 0, next = 0;
 
 	/* sanity checks */
@@ -318,11 +318,8 @@ static int sort_and_eliminate(u32* values, int* count)
 	/* bubble sort the first @count items of the array @values */
 	for( top = *count; top > 0; top--) {
 		for( low = 0, high = 1; high < top; low++, high++) {
-			if( values[low] > values[high] ) {
-				temp = values[low];
-				values[low] = values[high];
-				values[high] = temp;
-			}
+			if( values[low] > values[high] )
+				swap(values[low], values[high]);
 		}
 	}
 
-- 
2.4.2

