Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:37978 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932656AbeCITLs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 14:11:48 -0500
Received: by mail-wr0-f174.google.com with SMTP id n7so9999609wrn.5
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2018 11:11:47 -0800 (PST)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Cc: sumit.semwal@linaro.org
Subject: RFC: unpinned DMA-buf exporting
Date: Fri,  9 Mar 2018 20:11:40 +0100
Message-Id: <20180309191144.1817-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This set of patches adds an option invalidate_mappings callback to each DMA-buf attachment which can be filled in by the importer.

This callback allows the exporter to provided the DMA-buf content without pinning it. The reservation objects lock acts as synchronization point for buffer moves and creating mappings.

This set includes an implementation for amdgpu which should be rather easily portable to other DRM drivers.

Please comment,
Christian.
