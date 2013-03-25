Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:61089 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3CYLVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 07:21:07 -0400
Received: by mail-da0-f42.google.com with SMTP id n15so3175085dad.29
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 04:21:07 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v2 0/2] dma-buf: Add support for debugfs
Date: Mon, 25 Mar 2013 16:50:44 +0530
Message-Id: <1364210447-8125-1-git-send-email-sumit.semwal@linaro.org>
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


Sumit Semwal (2):
  dma-buf: replace dma_buf_export() with dma_buf_export_named()
  dma-buf: Add debugfs support

 Documentation/dma-buf-sharing.txt |   13 ++-
 drivers/base/dma-buf.c            |  173 ++++++++++++++++++++++++++++++++++++-
 include/linux/dma-buf.h           |   16 +++-
 3 files changed, 193 insertions(+), 9 deletions(-)

-- 
1.7.10.4

