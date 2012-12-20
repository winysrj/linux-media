Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:63533 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2LTHVL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Dec 2012 02:21:11 -0500
Received: by mail-vc0-f179.google.com with SMTP id p1so3304720vcq.24
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2012 23:21:10 -0800 (PST)
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 20 Dec 2012 12:22:29 +0530
Message-ID: <CAO_48GEePPaGtEsSZR+e1TDULqSmoHe5S0=+wHu8A=hYj9hMMA@mail.gmail.com>
Subject: [GIT PULL]: dma-buf updates for 3.8
To: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	linux-media@vger.kernel.org
Cc: Jesse Barker <jesse.barker@linaro.org>, akpm@linux-foundation.org,
	Daniel Vetter <daniel@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
	Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

A fairly small dma-buf pull request for 3.8 - only 2 patches. Could
you please pull?

Thanks!
~Sumit.

The following changes since commit f01af9f85855e38fbd601e033a8eac204cc4cc1c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
(2012-12-19 20:31:02 -0800)

are available in the git repository at:


  git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
tags/tag-for-linus-3.8

for you to fetch changes up to ada65c74059f8c104f1b467c126205471634c435:

  dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER (2012-12-20
12:05:06 +0530)

----------------------------------------------------------------
3.8: dma-buf minor updates

----------------------------------------------------------------
Maarten Lankhorst (1):
      dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER

Rob Clark (1):
      dma-buf: might_sleep() in dma_buf_unmap_attachment()

 drivers/base/dma-buf.c  |    2 +
 include/linux/dma-buf.h |   99 -----------------------------------------------
 2 files changed, 2 insertions(+), 99 deletions(-)
