Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:35003 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3JBLR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 07:17:28 -0400
Received: by mail-qa0-f41.google.com with SMTP id ii20so4244891qab.14
        for <linux-media@vger.kernel.org>; Wed, 02 Oct 2013 04:17:27 -0700 (PDT)
Date: Wed, 2 Oct 2013 07:17:15 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL] git://linuxtv.org/mkrufky/dvb frontends
Message-ID: <20131002071715.4cdcb843@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
ffee921033e64edf8579a3b21c7f15d1a6c3ef71:

  Merge tag 'v3.12-rc2' into patchwork (2013-09-24 08:17:44 -0300)

are available in the git repository at:


  git://linuxtv.org/mkrufky/dvb frontends

for you to fetch changes up to ed94e614c82b4d41d92c82052e915d99614d8b5c:

  dib9000: fix typo in spelling the word empty (2013-09-30 12:24:48
  -0400)

----------------------------------------------------------------
Andreas Matthies (1):
      tda10071: change firmware download condition

Christoph Jaeger (1):
      drxd_hard: remove unused SIZEOF_ARRAY

Kees Cook (1):
      dib9000: fix potential format string leak

Michael Krufky (1):
      dib9000: fix typo in spelling the word empty

Peter Senna Tschudin (1):
      fc001[23]: Change variable type to bool

 drivers/media/dvb-frontends/dib9000.c   | 4 ++--
 drivers/media/dvb-frontends/drxd_hard.c | 4 ----
 drivers/media/dvb-frontends/tda10071.c  | 9 +--------
 drivers/media/tuners/fc0012.c           | 2 +-
 drivers/media/tuners/fc0013.c           | 2 +-
 5 files changed, 5 insertions(+), 16 deletions(-)

Cheers,

Mike
