Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37681 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751671AbdHRKWD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 06:22:03 -0400
Date: Fri, 18 Aug 2017 11:22:02 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v4l-utils] rc fixes
Message-ID: <20170818102201.ufwhxhxlxlbxggdz@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are just fixes to ir-keytable and ir-ctl. Please let me know if you
have any ideas for improving them.

Thanks,

Sean

 
The following changes since commit 16c3764b636d647a8b41bc34d34722678220a9ff:

  cec-ctl: refactor: split the monitor code off into its own function (2017-08-01 09:04:51 +0200)

are available in the git repository at:

  git://linuxtv.org/syoung/v4l-utils.git rc-fixes

for you to fetch changes up to e7ce5d47962a2d1d41cd0d48f8c4d35c316e0bf5:

  ir-keytable: "ir-keytable -s rc1" should only describe rc1, not all (2017-08-18 10:15:56 +0100)

----------------------------------------------------------------
Sean Young (7):
      ir-keytable: do not fail at the first transmit-only device
      ir-ctl: "ir-ctl -S rc6_mce:0x800f0410" does not work on 32-bit
      ir-ctl: lirc resolution is in microseconds
      ir-ctl: report LIRCCODE drivers even if we don't supported them
      ir-keytable: null deref if kernel compiled without CONFIG_INPUT_EVDEV
      ir-keytable: ensure udev rule fires on rc input device
      ir-keytable: "ir-keytable -s rc1" should only describe rc1, not all

 utils/ir-ctl/ir-ctl.c            |  8 ++++++--
 utils/keytable/70-infrared.rules |  2 +-
 utils/keytable/keytable.c        | 19 ++++++++++---------
 3 files changed, 17 insertions(+), 12 deletions(-)
