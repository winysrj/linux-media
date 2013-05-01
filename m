Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50576 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3EAMlR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 May 2013 08:41:17 -0400
Received: by mail-oa0-f43.google.com with SMTP id k7so1390980oag.2
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 05:41:17 -0700 (PDT)
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 1 May 2013 18:10:56 +0530
Message-ID: <CAO_48GGBRwXuSoWuCr1eHhjGFmkzoC4Ji8osv+frjO1em8odfQ@mail.gmail.com>
Subject: [GIT PULL]: dma-buf updates for 3.10
To: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	linux-media@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Vetter <daniel@ffwll.ch>,
	Arnd Bergmann <arnd@arndb.de>, Dave Airlie <airlied@linux.ie>,
	Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

The 3.10 pull request for dma-buf framework updates: small one, could
you please pull?

Thanks and best regards,
~Sumit.


The following changes since commit 5f56886521d6ddd3648777fae44d82382dd8c87f:

  Merge branch 'akpm' (incoming from Andrew) (2013-04-30 17:37:43 -0700)

are available in the git repository at:


  git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
tags/tag-for-linus-3.10

for you to fetch changes up to b89e35636bc75b72d15a1af6d49798802aff77d5:

  dma-buf: Add debugfs support (2013-05-01 16:36:22 +0530)

----------------------------------------------------------------
3.10 dma-buf updates
  Added debugfs support to dma-buf.
----------------------------------------------------------------
Sumit Semwal (2):
      dma-buf: replace dma_buf_export() with dma_buf_export_named()
      dma-buf: Add debugfs support

 Documentation/dma-buf-sharing.txt |  13 ++-
 drivers/base/dma-buf.c            | 169 +++++++++++++++++++++++++++++++++++++-
 include/linux/dma-buf.h           |  16 +++-
 3 files changed, 189 insertions(+), 9 deletions(-)
