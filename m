Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.telros.ru ([83.136.244.21]:61459 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab2HVGnU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 02:43:20 -0400
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, volokh@telros.ru
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 06/10] staging: media: go7007: tw2804 ADC power control
Date: Wed, 22 Aug 2012 14:45:15 +0400
Message-Id: <1345632319-23224-6-git-send-email-volokh84@gmail.com>
In-Reply-To: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

switch off all ADC (max 4) with first init,
we control it then start/stop grabbing frame

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/wis-tw2804.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
index 7bd3058..34cf6b6 100644
--- a/drivers/staging/media/go7007/wis-tw2804.c
+++ b/drivers/staging/media/go7007/wis-tw2804.c
@@ -44,6 +44,7 @@ static u8 global_registers[] = {
 	0x3d, 0x80,
 	0x3e, 0x82,
 	0x3f, 0x82,
+	0x78, 0x0f,
 	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
 };
 
-- 
1.7.7.6

