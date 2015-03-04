Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41854 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933662AbbCDHHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 02:07:38 -0500
Received: by pdno5 with SMTP id o5so55107933pdn.8
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2015 23:07:38 -0800 (PST)
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 4 Mar 2015 12:37:16 +0530
Message-ID: <CAO_48GFmfHb=SEW=Ny+Nu8=1m0S9ij=m0hhUpsm2zJu6Y2gkwg@mail.gmail.com>
Subject: [GIT PULL]: dma-buf fixes for 4.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

May I please request you to pull a couple of fixes in dma-buf for 4.0-rc3?


The following changes since commit b942c653ae265abbd31032f3b4f5f857e5c7c723:

  Merge tag 'trace-sh-3.19' of
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
(2015-01-22 06:26:07 +1200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf.git
tags/dma-buf-for-4.0-rc3

for you to fetch changes up to 4eb2440ed60fb5793f7aa6da89b3d517cc59de43:

  reservation: Remove shadowing local variable 'ret' (2015-01-22 16:29:31 +0530)

----------------------------------------------------------------
dma-buf pull request for 4.0-rc3
- minor timeout & other fixes on reservation/fence

----------------------------------------------------------------
Jammy Zhou (2):
      reservation: wait only with non-zero timeout specified (v3)
      dma-buf/fence: don't wait when specified timeout is zero

Michel Dänzer (1):
      reservation: Remove shadowing local variable 'ret'

 drivers/dma-buf/fence.c       | 3 +++
 drivers/dma-buf/reservation.c | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

Thanks, and Best regards,
Sumit.

PS: I am not submitting the cleanup that I submitted in my earlier
pull request that you had to reject due to my stupid copy-paste error;
that one patch and it's fix is in for-next, but it's not, strictly
speaking, a "fix" to qualify for -rc3, hence I'll wait for the next
merge-window to submit it.
