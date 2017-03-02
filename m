Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:33507 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdCBVoy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 16:44:54 -0500
Received: by mail-qk0-f171.google.com with SMTP id n127so147092411qkf.0
        for <linux-media@vger.kernel.org>; Thu, 02 Mar 2017 13:44:53 -0800 (PST)
From: Laura Abbott <labbott@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com
Cc: Laura Abbott <labbott@redhat.com>, romlem@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org
Subject: [RFC PATCH 01/12] staging: android: ion: Remove dmap_cnt
Date: Thu,  2 Mar 2017 13:44:33 -0800
Message-Id: <1488491084-17252-2-git-send-email-labbott@redhat.com>
In-Reply-To: <1488491084-17252-1-git-send-email-labbott@redhat.com>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



The reference counting of dma_map calls was removed. Remove the
associated counter field as well.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/ion_priv.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 5b3059c..46d3ff5 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -44,7 +44,6 @@
  * @lock:		protects the buffers cnt fields
  * @kmap_cnt:		number of times the buffer is mapped to the kernel
  * @vaddr:		the kernel mapping if kmap_cnt is not zero
- * @dmap_cnt:		number of times the buffer is mapped for dma
  * @sg_table:		the sg table for the buffer if dmap_cnt is not zero
  * @pages:		flat array of pages in the buffer -- used by fault
  *			handler and only valid for buffers that are faulted in
@@ -70,7 +69,6 @@ struct ion_buffer {
 	struct mutex lock;
 	int kmap_cnt;
 	void *vaddr;
-	int dmap_cnt;
 	struct sg_table *sg_table;
 	struct page **pages;
 	struct list_head vmas;
-- 
2.7.4
