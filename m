Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57618 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762092Ab3DDG26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 02:28:58 -0400
Received: by mail-pb0-f47.google.com with SMTP id rq13so1264227pbb.6
        for <linux-media@vger.kernel.org>; Wed, 03 Apr 2013 23:28:58 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v3 0/2] dma-buf: Add support for debugfs
Date: Thu,  4 Apr 2013 11:58:31 +0530
Message-Id: <1365056913-25772-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch series adds a much-missed support for debugfs to dma-buf framework.

Based on the feedback received on v1 of this patch series, support is also
added to allow exporters to provide name-strings that will prove useful
while debugging.

Some more magic can be added for more advanced debugging, but we'll leave that
for the time being.

Best regards,
~Sumit.

---
changes since v2: (based on review comments from Laurent Pinchart)
 - reordered functions to avoid forward declaration
 - added __exitcall for dma_buf_deinit()

changes since v1:
 - added patch to replace dma_buf_export() with dma_buf_export_named(), per
    suggestion from Daniel Vetter.
 - fixes on init and warnings as reported and corrected by Dave Airlie.
 - added locking while walking attachment list - reported by Daniel Vetter.

Sumit Semwal (2):
  dma-buf: replace dma_buf_export() with dma_buf_export_named()
  dma-buf: Add debugfs support

 Documentation/dma-buf-sharing.txt |   13 ++-
 drivers/base/dma-buf.c            |  170 ++++++++++++++++++++++++++++++++++++-
 include/linux/dma-buf.h           |   16 +++-
 3 files changed, 190 insertions(+), 9 deletions(-)

-- 
1.7.10.4

