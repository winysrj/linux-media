Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41654 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031017AbbD1XEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:04:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/13] bcm3510: fix indentation
Date: Tue, 28 Apr 2015 20:04:25 -0300
Message-Id: <46d511514df4152d90e27aa738d9e51c713fec66.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/bcm3510.c:688 bcm3510_reset() warn: inconsistent indenting
drivers/media/dvb-frontends/bcm3510.c:711 bcm3510_clear_reset() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index 638c7aa0fb7e..23bfd00d42db 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -685,7 +685,7 @@ static int bcm3510_reset(struct bcm3510_state *st)
 	if ((ret = bcm3510_writeB(st,0xa0,v)) < 0)
 		return ret;
 
-    t = jiffies + 3*HZ;
+	t = jiffies + 3*HZ;
 	while (time_before(jiffies, t)) {
 		msleep(10);
 		if ((ret = bcm3510_readB(st,0xa2,&v)) < 0)
@@ -708,7 +708,7 @@ static int bcm3510_clear_reset(struct bcm3510_state *st)
 	if ((ret = bcm3510_writeB(st,0xa0,v)) < 0)
 		return ret;
 
-    t = jiffies + 3*HZ;
+	t = jiffies + 3*HZ;
 	while (time_before(jiffies, t)) {
 		msleep(10);
 		if ((ret = bcm3510_readB(st,0xa2,&v)) < 0)
-- 
2.1.0

