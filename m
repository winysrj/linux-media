Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:37379 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaDFTQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Apr 2014 15:16:13 -0400
Received: by mail-qg0-f41.google.com with SMTP id z60so5427619qgd.0
        for <linux-media@vger.kernel.org>; Sun, 06 Apr 2014 12:16:12 -0700 (PDT)
Date: Sun, 6 Apr 2014 15:16:08 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [GIT PULL] DVB / tuner fixes: git://linuxtv.org/mkrufky/dvb fixes
Message-ID: <20140406151608.48722575@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
a83b93a7480441a47856dc9104bea970e84cda87:

  [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31
  08:02:16 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb fixes

for you to fetch changes up to 45a55dc31e497027b99c8278bcc778a4aff76a2f:

  lgdt3305: include sleep functionality in lgdt3304_ops (2014-04-06
  15:06:52 -0400)

----------------------------------------------------------------
Benjamin Larsson (1):
      r820t: fix size and init values

Malcolm Priestley (1):
      m88rs2000: fix sparse static warnings

Paul Bolle (1):
      drx-j: use customise option correctly

Shuah Khan (1):
      lgdt3305: include sleep functionality in lgdt3304_ops

 drivers/media/dvb-frontends/drx39xyj/Kconfig | 2 +-
 drivers/media/dvb-frontends/lgdt3305.c       | 1 +
 drivers/media/dvb-frontends/m88rs2000.c      | 8 ++++----
 drivers/media/tuners/r820t.c                 | 3 ++-
 4 files changed, 8 insertions(+), 6 deletions(-)
