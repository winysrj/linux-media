Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:48420 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754623Ab2FJBo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 21:44:56 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH 5/9] tvaudio: don't use thread for TA8874Z
Date: Sun, 10 Jun 2012 03:43:54 +0200
Message-Id: <1339292638-12205-6-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <20120609214100.GA1598@minime.bse>
References: <20120609214100.GA1598@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Judging from the data sheet it will automatically switch to the next
best audio mode in accordance with the V4L2 tuner audio matrix.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/media/video/tvaudio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index fc37587..0e77d49 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -1597,7 +1597,6 @@ static struct CHIPDESC chiplist[] = {
 		.addr_lo    = I2C_ADDR_TDA9840 >> 1,
 		.addr_hi    = I2C_ADDR_TDA9840 >> 1,
 		.registers  = 2,
-		.flags      = CHIP_NEED_CHECKMODE,
 
 		/* callbacks */
 		.getmode    = ta8874z_getmode,
-- 
1.7.0.5

