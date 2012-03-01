Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46826 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519Ab2CAPW1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 10:22:27 -0500
Received: by wejx9 with SMTP id x9so424594wej.19
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2012 07:22:26 -0800 (PST)
MIME-Version: 1.0
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 0/3] [RFC] kernel cpu access support for dma_buf
Date: Thu,  1 Mar 2012 16:35:58 +0100
Message-Id: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This series here implements an interface to enable cpu access from the kernel
context to dma_buf objects. The main design goal of this interface proposal is
to enable buffer objects that reside in highmem.

Comments, flames, ideas and questions highly welcome. Althouhg I might be a bit
slow in responding - I'm on conferences and vacation the next 2 weeks.

Cheers, Daniel

Daniel Vetter (3):
  dma-buf: don't hold the mutex around map/unmap calls
  dma-buf: add support for kernel cpu access
  dma_buf: Add documentation for the new cpu access support

 Documentation/dma-buf-sharing.txt |  102 +++++++++++++++++++++++++++++-
 drivers/base/dma-buf.c            |  124 +++++++++++++++++++++++++++++++++++-
 include/linux/dma-buf.h           |   62 ++++++++++++++++++-
 3 files changed, 280 insertions(+), 8 deletions(-)

-- 
1.7.7.5

