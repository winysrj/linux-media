Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52109 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751623AbdFIJOY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 05:14:24 -0400
Date: Fri, 9 Jun 2017 10:14:22 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.13] RC fixes
Message-ID: <20170609091422.GA10442@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is the fixed sir_ir mod param change and a change to remove an
unnecessary rc_dev member. This could not be merged earlier due to
conflicts with late v4.12 fixes.

Thanks
Sean

The following changes since commit 47f910f0e0deb880c2114811f7ea1ec115a19ee4:

  [media] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev (2017-06-08 16:55:25 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.13c

for you to fetch changes up to 7d70c42f1d73c31594bb12b4df576858b5850b40:

  [media] rc-core: cleanup rc_register_device pt2 (2017-06-09 08:53:06 +0100)

----------------------------------------------------------------
David Härdeman (2):
      [media] rc-core: cleanup rc_register_device
      [media] rc-core: cleanup rc_register_device pt2

Sean Young (1):
      [media] sir_ir: annotate hardware config module parameters

 drivers/media/rc/rc-core-priv.h |   2 +
 drivers/media/rc/rc-ir-raw.c    |  36 ++++++----
 drivers/media/rc/rc-main.c      | 142 ++++++++++++++++------------------------
 drivers/media/rc/sir_ir.c       |   4 +-
 include/media/rc-core.h         |   2 -
 5 files changed, 86 insertions(+), 100 deletions(-)
