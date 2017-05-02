Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50741 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750848AbdEBLj3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 May 2017 07:39:29 -0400
Date: Tue, 2 May 2017 12:39:27 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.12] RC bugfixes
Message-ID: <20170502113927.GA25047@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull these two fixes. One is for a repeat regression which was
introduced in v4.11, another is for the lirc_buffer being freed on
lirc_unregister even though a user can still have an fd open (this
fix depends on "74c839b [media] lirc: use refcounting for lirc devices",
so it's not for stable).

Thanks,
Sean

The following changes since commit 3622d3e77ecef090b5111e3c5423313f11711dfa:

  [media] ov2640: print error if devm_*_optional*() fails (2017-04-25 07:08:21 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.12d

for you to fetch changes up to 5a285b2dd0c3d36ee2ca6b17826f643c6b4415fc:

  [media] ir-lirc-codec: let lirc_dev handle the lirc_buffer (2017-05-01 15:56:05 +0100)

----------------------------------------------------------------
David Härdeman (2):
      [media] rc-core: fix input repeat handling
      [media] ir-lirc-codec: let lirc_dev handle the lirc_buffer

 drivers/media/rc/ir-lirc-codec.c | 25 +++++++------------------
 drivers/media/rc/lirc_dev.c      | 13 ++++++++++++-
 drivers/media/rc/rc-main.c       | 20 ++++++++++----------
 3 files changed, 29 insertions(+), 29 deletions(-)
