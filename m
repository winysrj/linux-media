Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:42369 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751209AbeFVOLH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 10:11:07 -0400
Received: by mail-wr0-f172.google.com with SMTP id w10-v6so6855963wrk.9
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2018 07:11:07 -0700 (PDT)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: daniel@ffwll.ch, sumit.semwal@linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org
Subject: First step towards unpinned DMA-buf operation.
Date: Fri, 22 Jun 2018 16:10:59 +0200
Message-Id: <20180622141103.1787-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[As requested by Daniel cross posting to intel-gfx as well].

This set is the first step towards allowing to use a DMA-buf without actually pinning the underlying resources. This in turn the the ground work for PCIe P2P operations as well as quite a bunch of other use cases.

The idea is that we build the support for unpinned operation around the already present reservation lock in the DMA-buf object. For this we now grab the reservation object lock while mapping and unmapping DMA-bufs.

The down side is that all implementations as well as users of DMA-buf needs to be audited to make sure that we don't run into double locking or lock inversions.

So please test and/or comment and report back how badly lockdep complains :)

Thanks,
Christian.
