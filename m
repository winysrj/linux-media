Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab2KUR2V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 12:28:21 -0500
Date: Wed, 21 Nov 2012 15:28:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Linux Media ML <linux-media@vger.kernel.org>
Subject: Fw: [PATCH] [media] ivtv: ivtv-driver: Replace 'flush_work_sync()'
Message-ID: <20121121152809.51c780a6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

I'm understanding that you'll be reviewing this patch. So, I'm marking it as
under_review at patchwork.

Thanks,
Mauro

Forwarded message:

Date: Wed, 24 Oct 2012 10:14:16 -0200
From: Fabio Estevam <festevam@gmail.com>
To: awalls@md.metrocast.net
Cc: mchehab@infradead.org, linux-media@vger.kernel.org, tj@kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] ivtv: ivtv-driver: Replace 'flush_work_sync()'


From: Fabio Estevam <fabio.estevam@freescale.com>

Since commit 43829731d (workqueue: deprecate flush[_delayed]_work_sync()),
flush_work() should be used instead of flush_work_sync().

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/pci/ivtv/ivtv-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 74e9a50..5d0a5df 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -304,7 +304,7 @@ static void request_modules(struct ivtv *dev)
 
 static void flush_request_modules(struct ivtv *dev)
 {
-	flush_work_sync(&dev->request_module_wk);
+	flush_work(&dev->request_module_wk);
 }
 #else
 #define request_modules(dev)
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Regards,
Mauro
