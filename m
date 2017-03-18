Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36402 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdCRBEF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 21:04:05 -0400
Received: by mail-qk0-f174.google.com with SMTP id 1so77337096qkl.3
        for <linux-media@vger.kernel.org>; Fri, 17 Mar 2017 18:02:29 -0700 (PDT)
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
        linux-mm@kvack.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC PATCHv2 21/21] staging: android: ion: Set query return value
Date: Fri, 17 Mar 2017 17:54:53 -0700
Message-Id: <1489798493-16600-22-git-send-email-labbott@redhat.com>
In-Reply-To: <1489798493-16600-1-git-send-email-labbott@redhat.com>
References: <1489798493-16600-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This never got set in the ioctl. Properly set a return value of 0 on
success.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/ion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 64c652b..8bd90ce 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -498,6 +498,7 @@ int ion_query_heaps(struct ion_heap_query *query)
 	}
 
 	query->cnt = cnt;
+	ret = 0;
 out:
 	up_read(&dev->lock);
 	return ret;
-- 
2.7.4
