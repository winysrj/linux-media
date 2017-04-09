Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36391 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752498AbdDIBfM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:35:12 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Patrice Chotard <patrice.chotard@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] [media] c8sectpfe: use setup_timer
Date: Sun,  9 Apr 2017 09:34:06 +0800
Message-Id: <cad969ccd0b4524d1ecdc1c5ac58e5f2009d0073.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 7652ce2..59280ac 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -865,9 +865,8 @@ static int c8sectpfe_probe(struct platform_device *pdev)
 	}
 
 	/* Setup timer interrupt */
-	init_timer(&fei->timer);
-	fei->timer.function = c8sectpfe_timer_interrupt;
-	fei->timer.data = (unsigned long)fei;
+	setup_timer(&fei->timer, c8sectpfe_timer_interrupt,
+		    (unsigned long)fei);
 
 	mutex_init(&fei->lock);
 
-- 
2.9.3
