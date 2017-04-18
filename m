Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35564 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756203AbdDRS1c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 14:27:32 -0400
Received: by mail-qk0-f176.google.com with SMTP id f133so1183540qke.2
        for <linux-media@vger.kernel.org>; Tue, 18 Apr 2017 11:27:27 -0700 (PDT)
From: Laura Abbott <labbott@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laura Abbott <labbott@redhat.com>, romlem@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCHv4 02/12] cma: Introduce cma_for_each_area
Date: Tue, 18 Apr 2017 11:27:04 -0700
Message-Id: <1492540034-5466-3-git-send-email-labbott@redhat.com>
In-Reply-To: <1492540034-5466-1-git-send-email-labbott@redhat.com>
References: <1492540034-5466-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Frameworks (e.g. Ion) may want to iterate over each possible CMA area to
allow for enumeration. Introduce a function to allow a callback.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 include/linux/cma.h |  2 ++
 mm/cma.c            | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index d41d1f8..3e8fbf5 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -34,4 +34,6 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 extern struct page *cma_alloc(struct cma *cma, size_t count, unsigned int align,
 			      gfp_t gfp_mask);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned int count);
+
+extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
 #endif
diff --git a/mm/cma.c b/mm/cma.c
index 43c1b2c..978b4a1 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -504,3 +504,17 @@ bool cma_release(struct cma *cma, const struct page *pages, unsigned int count)
 
 	return true;
 }
+
+int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
+{
+	int i;
+
+	for (i = 0; i < cma_area_count; i++) {
+		int ret = it(&cma_areas[i], data);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
-- 
2.7.4
