Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:59960 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2LRCQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 21:16:16 -0500
Received: by mail-la0-f53.google.com with SMTP id w12so64490lag.12
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2012 18:16:14 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Dec 2012 21:16:14 -0500
Message-ID: <CAOcJUbw3Z+TTvURsOSKS0qaYY2mV3_9H5HCE2JH6vjX=QSDaDw@mail.gmail.com>
Subject: [PULL] dvb-frontends: use %*ph[N] to dump small buffers
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please apply the following to update status in patchwork along with
the following merge request...

pwclient update -s 'superseded' 15687
pwclient update -s 'changes requested' 15688

I am marking 15687 as superseded because I broke the patch into two
separate patches.  (see merge request below)
15688 causes new build warnings, so I've asked Andy to resubmit.

Please merge:

The following changes since commit 5b7d8de7d2328f7b25fe4645eafee7e48f9b7df3:

  [media] au0828: break au0828_card_setup() down into smaller
functions (2012-12-17 14:34:27 -0200)

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/tuners frontends

for you to fetch changes up to 34c87fa2214d134c0028c97d7aab3dd769bb3bf0:

  ix2505v: use %*ph[N] to dump small buffers (2012-12-17 20:12:29 -0500)

----------------------------------------------------------------
Andy Shevchenko (2):
      or51211: use %*ph[N] to dump small buffers
      ix2505v: use %*ph[N] to dump small buffers

 drivers/media/dvb-frontends/ix2505v.c |    2 +-
 drivers/media/dvb-frontends/or51211.c |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

Cheers,

Mike
