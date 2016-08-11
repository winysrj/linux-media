Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33657 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbcHKKqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 06:46:37 -0400
Received: by mail-pa0-f51.google.com with SMTP id ti13so25146718pac.0
        for <linux-media@vger.kernel.org>; Thu, 11 Aug 2016 03:46:37 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFC 0/4] doc: dma-buf: sphinx conversion and cleanup 
Date: Thu, 11 Aug 2016 16:15:47 +0530
Message-Id: <1470912351-32081-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert dma-buf documentation over to sphinx; also cleanup to
address sphinx warnings.

While at that, convert dma-buf-sharing.txt as well, and make it the
dma-buf API guide.

There is no content change yet; only format conversion and creation of
some hyperlinks.

Sumit Semwal (4):
  dma-buf/fence: kerneldoc: remove unused struct members
  dma-buf/fence: kerneldoc: remove spurious section header
  Documentation: move dma-buf documentation to rst
  Documentation/sphinx: link dma-buf rsts

 Documentation/DocBook/device-drivers.tmpl |  37 ---
 Documentation/dma-buf/guide.rst           | 503 ++++++++++++++++++++++++++++++
 Documentation/dma-buf/intro.rst           |  76 +++++
 Documentation/index.rst                   |   2 +
 MAINTAINERS                               |   2 +-
 include/linux/fence.h                     |   4 +-
 6 files changed, 583 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/dma-buf/guide.rst
 create mode 100644 Documentation/dma-buf/intro.rst

-- 
2.7.4

