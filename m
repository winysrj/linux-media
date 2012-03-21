Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965023Ab2CUG4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 02:56:37 -0400
Subject: [PATCH 05/16] mm/drivers: use vm_flags_t for vma flags
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-mm@kvack.org,
	Arve =?utf-8?b?SGrDuG5uZXbDpWc=?= <arve@android.com>,
	John Stultz <john.stultz@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Date: Wed, 21 Mar 2012 10:56:33 +0400
Message-ID: <20120321065633.13852.11903.stgit@zurg>
In-Reply-To: <20120321065140.13852.52315.stgit@zurg>
References: <20120321065140.13852.52315.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: "Arve Hjønnevåg" <arve@android.com>
---
 drivers/media/video/omap3isp/ispqueue.h |    2 +-
 drivers/staging/android/ashmem.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispqueue.h b/drivers/media/video/omap3isp/ispqueue.h
index 92c5a12..908dfd7 100644
--- a/drivers/media/video/omap3isp/ispqueue.h
+++ b/drivers/media/video/omap3isp/ispqueue.h
@@ -90,7 +90,7 @@ struct isp_video_buffer {
 	void *vaddr;
 
 	/* For userspace buffers. */
-	unsigned long vm_flags;
+	vm_flags_t vm_flags;
 	unsigned long offset;
 	unsigned int npages;
 	struct page **pages;
diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 9f1f27e..4511420 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -269,7 +269,7 @@ out:
 	return ret;
 }
 
-static inline unsigned long calc_vm_may_flags(unsigned long prot)
+static inline vm_flags_t calc_vm_may_flags(unsigned long prot)
 {
 	return _calc_vm_trans(prot, PROT_READ,  VM_MAYREAD) |
 	       _calc_vm_trans(prot, PROT_WRITE, VM_MAYWRITE) |

