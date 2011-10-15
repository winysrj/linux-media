Return-path: <linux-media-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:56256 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1JOVim (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 17:38:42 -0400
Message-ID: <4E99FD60.5090606@intra2net.com>
Date: Sat, 15 Oct 2011 23:38:40 +0200
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: [PATCH resent] Fix logic in sanity check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Detected by "cppcheck".

This time with "Signed-off-by" line.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 drivers/media/video/m5mols/m5mols_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index fb8e4a7..e485e9e 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -333,7 +333,7 @@ int m5mols_mode(struct m5mols_info *info, u8 mode)
 	int ret = -EINVAL;
 	u8 reg;
 
-	if (mode < REG_PARAMETER && mode > REG_CAPTURE)
+	if (mode < REG_PARAMETER || mode > REG_CAPTURE)
 		return ret;
 
 	ret = m5mols_read_u8(sd, SYSTEM_SYSMODE, &reg);
-- 
1.7.6.4

