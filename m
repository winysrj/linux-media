Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:52186 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751948AbdEHJKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 05:10:17 -0400
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, Gustavo Padovan <gustavo@padovan.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] DMA-buf: Fine-tuning for four function implementations
Message-ID: <3d972fa2-787a-d1f2-ff86-5c05494e00d3@users.sourceforge.net>
Date: Mon, 8 May 2017 11:10:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 8 May 2017 11:05:05 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Combine two function calls into one in dma_buf_debug_show()
  Improve a size determination in dma_buf_attach()
  Adjust a null pointer check in dma_buf_attach()
  Use seq_putc() in two functions

 drivers/dma-buf/dma-buf.c    | 8 +++-----
 drivers/dma-buf/sync_debug.c | 6 +++---
 2 files changed, 6 insertions(+), 8 deletions(-)

-- 
2.12.2
