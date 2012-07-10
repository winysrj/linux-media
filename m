Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:48560 "HELO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753274Ab2GJJom (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 05:44:42 -0400
Received: by wibhq12 with SMTP id hq12so2777842wib.5
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 02:44:40 -0700 (PDT)
From: Dror Cohen <dror@liveu.tv>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, nsekhar@ti.com,
	davinci-linux-open-source@linux.davincidsp.com,
	Dror Cohen <dror@liveu.tv>
Subject: [PATCH] media/video: vpif: fixed vpfe->vpif typo
Date: Tue, 10 Jul 2012 12:43:22 +0300
Message-Id: <1341913402-4439-2-git-send-email-dror@liveu.tv>
In-Reply-To: <1341913402-4439-1-git-send-email-dror@liveu.tv>
References: <1341913402-4439-1-git-send-email-dror@liveu.tv>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Dror Cohen <dror@liveu.tv>
---
 drivers/media/video/davinci/vpif_capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 9604695..ce334e2 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -703,7 +703,7 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 }
 
 /**
- * vpfe_mmap : It is used to map kernel space buffers into user spaces
+ * vpif_mmap : It is used to map kernel space buffers into user spaces
  * @filep: file pointer
  * @vma: ptr to vm_area_struct
  */
@@ -812,7 +812,7 @@ static int vpif_open(struct file *filep)
  * vpif_release : function to clean up file close
  * @filep: file pointer
  *
- * This function deletes buffer queue, frees the buffers and the vpfe file
+ * This function deletes buffer queue, frees the buffers and the vpif file
  * handle
  */
 static int vpif_release(struct file *filep)
-- 
1.7.9.5

