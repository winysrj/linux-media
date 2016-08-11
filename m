Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34137 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbcHKKsb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 06:48:31 -0400
Received: by mail-pf0-f172.google.com with SMTP id p64so25773989pfb.1
        for <linux-media@vger.kernel.org>; Thu, 11 Aug 2016 03:48:31 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFC 4/4] Documentation/sphinx: link dma-buf rsts
Date: Thu, 11 Aug 2016 16:18:00 +0530
Message-Id: <1470912480-32304-5-git-send-email-sumit.semwal@linaro.org>
In-Reply-To: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
References: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Include dma-buf sphinx documentation into top level index.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 Documentation/index.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 43c722f15292..2fe8e82d7d8c 100644
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

