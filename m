Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10500 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab0JRJvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 05:51:40 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LAH008LOCQ2RE@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Oct 2010 10:51:38 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LAH0078ACQ26X@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Oct 2010 10:51:38 +0100 (BST)
Date: Mon, 18 Oct 2010 11:51:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] SR030PC30: Avoid use of uninitialized variables
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1287395495-1337-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fix the following compilation warnings:

drivers/media/video/sr030pc30.c: In function ‘cam_i2c_write’:
drivers/media/video/sr030pc30.c:356: warning: ‘ret’ may be used uninitialized in this function
drivers/media/video/sr030pc30.c: In function ‘sr030pc30_set_params’:
drivers/media/video/sr030pc30.c:345: warning: ‘ret’ may be used uninitialized in this function
drivers/media/video/sr030pc30.c:328: note: ‘ret’ was declared here

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
Unfortunately I could not reproduce all the warnings in various build configurations,
this patch fixes the only issue I was able to find.
---
 drivers/media/video/sr030pc30.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
index ec8d875..c9dc67a 100644
--- a/drivers/media/video/sr030pc30.c
+++ b/drivers/media/video/sr030pc30.c
@@ -326,7 +326,7 @@ static inline struct sr030pc30_info *to_sr030pc30(struct v4l2_subdev *sd)
 static inline int set_i2c_page(struct sr030pc30_info *info,
 			       struct i2c_client *client, unsigned int reg)
 {
-	int ret;
+	int ret = 0;
 	u32 page = reg >> 8 & 0xFF;
 
 	if (info->i2c_reg_page != page && (reg & 0xFF) != 0x03) {
-- 
1.7.3.1

