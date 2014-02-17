Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:57419 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaBQNGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 08:06:41 -0500
Received: by mail-oa0-f51.google.com with SMTP id h16so17711583oag.10
        for <linux-media@vger.kernel.org>; Mon, 17 Feb 2014 05:06:40 -0800 (PST)
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 17 Feb 2014 18:36:18 +0530
Message-ID: <CAO_48GGdNgSAyw2d9OdvbuK8DATPYYtJvuFwnDJmPTqX7XNvow@mail.gmail.com>
Subject: [GIT PULL]: dma-buf updates for 3.14
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

Here's another tiny pull request for dma-buf framework updates; just
some debugfs output updates. (There's another patch related to
dma-buf, but it'll get upstreamed via Greg-kh's pull request).

Could you please pull?

The following changes since commit 45f7fdc2ffb9d5af4dab593843e89da70d1259e3:

  Merge branch 'merge' of
git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2014-02-11
22:28:47 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf.git
tags/dma-buf-for-3.14

for you to fetch changes up to c0b00a525c127d0055c1df6283300e17f601a1a1:

  dma-buf: update debugfs output (2014-02-13 10:08:52 +0530)

----------------------------------------------------------------
Small dma-buf pull request for 3.14

----------------------------------------------------------------
Sumit Semwal (1):
      dma-buf: update debugfs output

 drivers/base/dma-buf.c  | 25 ++++++++++++-------------
 include/linux/dma-buf.h |  2 +-
 2 files changed, 13 insertions(+), 14 deletions(-)
