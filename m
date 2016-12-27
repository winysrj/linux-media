Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36163 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751865AbcL0Uuo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 15:50:44 -0500
Date: Tue, 27 Dec 2016 20:49:57 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4l-utils] ir updates
Message-ID: <20161227204957.GB18181@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some minor fixes for ir-ctl and one for ir-keytable.

Thanks,
Sean

The following changes since commit f6ecbc90656815d91dc6ba90aac0ad8193a14b38:

  v4l-utils: sync with latest kernel (2016-11-30 10:33:44 +0100)

are available in the git repository at:

  git://linuxtv.org/syoung/v4l-utils.git ir-fixes

for you to fetch changes up to df9cc492fd2a51e19a15cc6249ed2e27f76d937a:

  ir-ctl: `strndupa' undefined with --disable-nls (2016-12-27 11:31:13 +0000)

----------------------------------------------------------------
Greg Whiteley (1):
      ir-ctl: `strndupa' undefined with --disable-nls

Sean Young (6):
      ir-ctl: fix rc5x encoding
      ir-ctl: 0 is valid scancode
      ir-ctl: improve scancode validation
      ir-keytable: "-p all" or "-p mce-kdb" does not work
      ir-ctl: rename rc5x to rc5x_20
      ir-ctl: rc5 command 6th bit missing

 utils/ir-ctl/ir-ctl.1.in  |  7 ++++---
 utils/ir-ctl/ir-ctl.c     |  7 ++++---
 utils/ir-ctl/ir-encode.c  | 29 ++++++++++++++++++++++++-----
 utils/ir-ctl/ir-encode.h  |  3 ++-
 utils/keytable/keytable.c |  2 +-
 5 files changed, 35 insertions(+), 13 deletions(-)
