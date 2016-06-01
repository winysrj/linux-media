Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36933 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbcFAGHO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2016 02:07:14 -0400
Received: by mail-wm0-f54.google.com with SMTP id z87so14391948wmh.0
        for <linux-media@vger.kernel.org>; Tue, 31 May 2016 23:07:14 -0700 (PDT)
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 1 Jun 2016 11:36:53 +0530
Message-ID: <CAO_48GEPozg6yajkqtXDtbOT_r=8Ve3g5o1xkRRVPhaBmTfbxA@mail.gmail.com>
Subject: [GIT PULL]: minor dma-buf updates for 4.7
To: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

A tiny pull request with mostly cosmetic changes in dma-buf for 4.7;
may I request you to please pull?


The following changes since commit 852f42a69b93dc71507adedeed876d57b8c2c2fa:

  Merge branch 'uuid' (lib/uuid fixes from Andy) (2016-05-30 15:27:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf.git
tags/dma-buf-for-4.7

for you to fetch changes up to b02da6f8236148009c22167cd7013d5ce04a2d37:

  dma-buf: use vma_pages() (2016-05-31 22:17:05 +0530)

----------------------------------------------------------------
Minor dma-buf updates for 4.7:
- use of vma_pages instead of explicit computation.
- DocBook and headerdoc updates for dma-buf.

----------------------------------------------------------------
Luis de Bethencourt (1):
      fence: add missing descriptions for fence

Muhammad Falak R Wani (1):
      dma-buf: use vma_pages()

Rob Clark (3):
      dma-buf: headerdoc fixes
      reservation: add headerdoc comments
      doc: update/fixup dma-buf related DocBook

 Documentation/DocBook/device-drivers.tmpl | 36 ++++++++++++++--
 drivers/dma-buf/dma-buf.c                 |  7 +--
 drivers/dma-buf/reservation.c             | 72 +++++++++++++++++++++++++++++--
 include/linux/dma-buf.h                   | 13 ++++--
 include/linux/fence.h                     |  2 +
 include/linux/reservation.h               | 53 +++++++++++++++++++++++
 6 files changed, 169 insertions(+), 14 deletions(-)

Thanks and best regards,
Sumit.
