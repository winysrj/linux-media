Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:45125 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaJYSrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Oct 2014 14:47:25 -0400
Received: by mail-pa0-f48.google.com with SMTP id ey11so2961607pad.7
        for <linux-media@vger.kernel.org>; Sat, 25 Oct 2014 11:47:24 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 25 Oct 2014 11:47:24 -0400
Message-ID: <CAOcJUbx9q1XGUoNW9avqVqi9LQ1hmwe4TM=Op8jLrm4yAKCd8g@mail.gmail.com>
Subject: [GIT PULL] DVB: add support for LG Electronics LGDT3306A ATSC/QAM-B Demodulator
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

We spoke briefly about the lgdt3306a driver.  I've done a lot of
cleanup on this driver, starting with checkpatch.pl complaining:

total: 495 errors, 313 warnings, 2126 lines checked

 ... Now checkpatch.pl reports the following:

total: 5 errors, 51 warnings, 2138 lines checked

consisting of mostly "WARNING: line over 80 characters"

This could use a *little* bit more cleanup, but I think it's clean
enough to be merged now.

The following changes since commit 1ef24960ab78554fe7e8e77d8fc86524fbd60d3c:

  Merge tag 'v3.18-rc1' into patchwork (2014-10-21 08:32:51 -0200)

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/dvb lgdt3306a

for you to fetch changes up to b5bf818584a22a9271c78fc18ca9cd44d36266ec:

  lgdt3306a: more small whitespace cleanups (2014-10-25 10:26:15 -0400)

----------------------------------------------------------------
Fred Richter (1):
      DVB: add support for LG Electronics LGDT3306A ATSC/QAM-B Demodulator

Michael Ira Krufky (9):
      lgdt3306a: clean up whitespace & unneeded brackets
      lgdt3306a: remove unnecessary 'else'
      lgdt3306a: fix WARNING: EXPORT_SYMBOL(foo); should immediately
follow its function/variable
      lgdt3306a: fix ERROR: do not use assignment in if condition
      lgdt3306a: do not add new typedefs
      lgdt3306a: fix ERROR: do not use C99 // comments
      lgdt3306a: fix WARNING: please, no spaces at the start of a line
      lgdt3306a: fix WARNING: 'supress' may be misspelled - perhaps 'suppress'?
      lgdt3306a: more small whitespace cleanups

 drivers/media/dvb-frontends/Kconfig     |    8 +
 drivers/media/dvb-frontends/Makefile    |    1 +
 drivers/media/dvb-frontends/lgdt3306a.c | 2035 ++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/lgdt3306a.h |   82 ++
 4 files changed, 2126 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/lgdt3306a.c
 create mode 100644 drivers/media/dvb-frontends/lgdt3306a.h

Cheers,

Mike
