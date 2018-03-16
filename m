Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35679 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbeCPNUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 09:20:53 -0400
Received: by mail-wm0-f41.google.com with SMTP id 5so3037521wmh.0
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2018 06:20:53 -0700 (PDT)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: RFC: unpinned DMA-buf exporting v2
Date: Fri, 16 Mar 2018 14:20:44 +0100
Message-Id: <20180316132049.1748-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

since I've got positive feedback from Daniel I continued working on this approach.

A few issues are still open:
1. Daniel suggested that I make the invalidate_mappings callback a parameter of dma_buf_attach().

This approach unfortunately won't work because when the attachment is created the importer is not necessarily ready to handle invalidation events.

E.g. in the amdgpu example we first need to setup the imported GEM/TMM objects and install that in the attachment.

My solution is to introduce a separate function to grab the locks and set the callback, this function could then be used to pin the buffer later on if that turns out to be necessary after all.

2. With my example setup this currently results in a ping/pong situation because the exporter prefers a VRAM placement while the importer prefers a GTT placement.

This results in quite a performance drop, but can be fixed by a simple mesa patch which allows shred BOs to be placed in both VRAM and GTT.

Question is what should we do in the meantime? Accept the performance drop or only allow unpinned sharing with new Mesa?

Please review and comment,
Christian.
