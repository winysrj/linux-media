Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36450 "EHLO
        mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbcHVPTV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 11:19:21 -0400
Received: by mail-pa0-f53.google.com with SMTP id pp5so38549258pac.3
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 08:18:51 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org,
        markus.heiser@darmarit.de, jani.nikula@linux.intel.com,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v2 2/2] Documentation/sphinx: link dma-buf rsts
Date: Mon, 22 Aug 2016 20:41:45 +0530
Message-Id: <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org>
In-Reply-To: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Include dma-buf sphinx documentation into top level index.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 Documentation/index.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index e0fc72963e87..8d05070122c2 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -14,6 +14,8 @@ Contents:
    :maxdepth: 2
 
    kernel-documentation
+   dma-buf/intro
+   dma-buf/guide
    media/media_uapi
    media/media_kapi
    media/dvb-drivers/index
-- 
2.7.4

