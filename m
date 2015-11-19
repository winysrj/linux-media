Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743AbbKSNsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 08:48:02 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] smsir.h: remove a now duplicated definition (IR_DEFAULT_TIMEOUT)
Date: Thu, 19 Nov 2015 11:47:53 -0200
Message-Id: <850c8a7d68a761b5f11d5b443b5ece185e8068f4.1447940858.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This macro is now part of the core. Remove from Siano driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smsir.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/common/siano/smsir.h b/drivers/media/common/siano/smsir.h
index fc8b7925c532..d9abd96ef48b 100644
--- a/drivers/media/common/siano/smsir.h
+++ b/drivers/media/common/siano/smsir.h
@@ -30,8 +30,6 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include <linux/input.h>
 #include <media/rc-core.h>
 
-#define IR_DEFAULT_TIMEOUT		100
-
 struct smscore_device_t;
 
 struct ir_t {
-- 
2.5.0

