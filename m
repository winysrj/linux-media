Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33495 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbbFZOPR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 10:15:17 -0400
Received: by igtg8 with SMTP id g8so2062169igt.0
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2015 07:15:16 -0700 (PDT)
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Fri, 26 Jun 2015 19:44:56 +0530
Message-ID: <CAO_48GGTitYKgPJVouZf4YNDn3rh4BkGLnPqfb2ufpxSdz27_w@mail.gmail.com>
Subject: [GIT PULL]: dma-buf changes for 4.2
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

Very small pull request on dma-buf for 4.2 merge window. May I request
you to please pull?


The following changes since commit 5ebe6afaf0057ac3eaeb98defd5456894b446d22:

  Linux 4.1-rc2 (2015-05-03 19:22:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf.git
tags/dma-buf-for-4.2

for you to fetch changes up to 5136629dc5a19701746abd7c8ad98ce0b84dda1d:

  dma-buf: Minor coding style fixes (2015-05-21 11:29:59 +0530)

----------------------------------------------------------------
Minor changes for 4.2
- add ref-counting for kernel modules as exporters
- minor code style fixes

----------------------------------------------------------------
Jagan Teki (1):
      dma-buf: Minor coding style fixes

Sumit Semwal (1):
      dma-buf: add ref counting for module as exporter

 drivers/dma-buf/dma-buf.c     | 19 ++++++++++++++++---
 drivers/dma-buf/reservation.c |  9 ++++++---
 drivers/dma-buf/seqno-fence.c |  8 +++++++-
 include/linux/dma-buf.h       | 10 ++++++++--
 4 files changed, 37 insertions(+), 9 deletions(-)

Thanks and best regards,
Sumit.
