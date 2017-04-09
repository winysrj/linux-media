Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34762 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752198AbdDIBes (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:34:48 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] [media] ivtv: use setup_timer
Date: Sun,  9 Apr 2017 09:34:01 +0800
Message-Id: <04fad03e4691fdbc040f62cd0545b5a5b662eab8.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/pci/ivtv/ivtv-driver.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index a71a03e..e8fa99b 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -770,9 +770,8 @@ static int ivtv_init_struct1(struct ivtv *itv)
 	init_waitqueue_head(&itv->event_waitq);
 	init_waitqueue_head(&itv->vsync_waitq);
 	init_waitqueue_head(&itv->dma_waitq);
-	init_timer(&itv->dma_timer);
-	itv->dma_timer.function = ivtv_unfinished_dma;
-	itv->dma_timer.data = (unsigned long)itv;
+	setup_timer(&itv->dma_timer, ivtv_unfinished_dma,
+		    (unsigned long)itv);
 
 	itv->cur_dma_stream = -1;
 	itv->cur_pio_stream = -1;
-- 
2.9.3
