Return-path: <mchehab@pedra>
Received: from cantor.suse.de ([195.135.220.2]:44457 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab1DEO7h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:37 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 14/34] media/cx231xx: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:01 +0200
Message-Id: <1302015561-21047-15-git-send-email-mmarek@suse.cz>
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/media/video/cx231xx/cx231xx-avcore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index c53e972..ff5cb50 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -1356,7 +1356,7 @@ void cx231xx_dump_SC_reg(struct cx231xx *dev)
 {
 	u8 value[4] = { 0, 0, 0, 0 };
 	int status = 0;
-	cx231xx_info("cx231xx_dump_SC_reg %s!\n", __TIME__);
+	cx231xx_info("cx231xx_dump_SC_reg!\n");
 
 	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT,
 				 value, 4);
-- 
1.7.4.1

