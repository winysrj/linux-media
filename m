Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38700 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2LQIvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 03:51:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: ispqueue: Fix uninitialized variable compiler warnings
Date: Mon, 17 Dec 2012 09:52:48 +0100
Message-Id: <1355734368-6908-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/omap3isp/ispqueue.c:399:18: warning: 'pa' may be
used uninitialized in this function [-Wuninitialized]

This is a false positive but the compiler has no way to know about it,
so initialize the variable to 0.

drivers/media/platform/omap3isp/ispqueue.c:445:6: warning:
'vm_page_prot' may be used uninitialized in this function
[-Wuninitialized]

This is a false positive and the compiler should know better. Use
uninitialized_var().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 15bf3ea..1388eb7 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -366,7 +366,7 @@ static int isp_video_buffer_prepare_pfnmap(struct isp_video_buffer *buf)
 	unsigned long this_pfn;
 	unsigned long start;
 	unsigned long end;
-	dma_addr_t pa;
+	dma_addr_t pa = 0;
 	int ret = -EFAULT;
 
 	start = buf->vbuf.m.userptr;
@@ -419,7 +419,7 @@ done:
 static int isp_video_buffer_prepare_vm_flags(struct isp_video_buffer *buf)
 {
 	struct vm_area_struct *vma;
-	pgprot_t vm_page_prot;
+	pgprot_t uninitialized_var(vm_page_prot);
 	unsigned long start;
 	unsigned long end;
 	int ret = -EFAULT;
-- 
Regards,

Laurent Pinchart

