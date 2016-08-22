Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35033 "EHLO
        mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755058AbcHVPVT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 11:21:19 -0400
Received: by mail-pa0-f52.google.com with SMTP id hb8so20057829pac.2
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 08:21:19 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org,
        markus.heiser@darmarit.de, jani.nikula@linux.intel.com,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v2 0/2] doc: dma-buf: sphinx conversion
Date: Mon, 22 Aug 2016 20:41:43 +0530
Message-Id: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert dma-buf documentation over to sphinx.

While at that, convert dma-buf-sharing.txt as well, and make it the
dma-buf API guide.

There is no content change yet; only format conversion and creation of
some hyperlinks.

v2: Address review comments from Jonathan Corbet and Markus Heiser.

Sumit Semwal (2):
  Documentation: move dma-buf documentation to rst
  Documentation/sphinx: link dma-buf rsts

 Documentation/DocBook/device-drivers.tmpl |  41 ---
 Documentation/dma-buf-sharing.txt         | 482 ----------------------------
 Documentation/dma-buf/guide.rst           | 507 ++++++++++++++++++++++++++++++
 Documentation/dma-buf/intro.rst           |  82 +++++
 Documentation/index.rst                   |   2 +
 MAINTAINERS                               |   2 +-
 6 files changed, 592 insertions(+), 524 deletions(-)
 delete mode 100644 Documentation/dma-buf-sharing.txt
 create mode 100644 Documentation/dma-buf/guide.rst
 create mode 100644 Documentation/dma-buf/intro.rst

-- 
2.7.4

