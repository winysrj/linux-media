Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51357 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751646AbdKVSgZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 13:36:25 -0500
Date: Wed, 22 Nov 2017 18:36:24 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.15] RC repeat and DVB fix
Message-ID: <20171122183623.mukjrjkqbpsslyxj@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are two fixes which would be nice to have in v4.15. I am working on
a better rework of the repeat stuff (including moving cec repeats into
rc-core), but it is far too much change for v4.15 or the stable tree.

Thanks,

Sean

The following changes since commit 30b4e122d71cbec2944a5f8b558b88936ee42f10:

  media: rc: sir_ir: detect presence of port (2017-11-15 08:57:34 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.15e

for you to fetch changes up to 27a7a06b95cd0995b81915606e832fafca2c92ed:

  media: rc: partial revert of "media: rc: per-protocol repeat period" (2017-11-22 18:29:33 +0000)

----------------------------------------------------------------
Laurent Caumont (1):
      media: dvb: i2c transfers over usb cannot be done from stack

Sean Young (1):
      media: rc: partial revert of "media: rc: per-protocol repeat period"

 drivers/media/rc/rc-main.c                | 32 +++++++++++++++----------------
 drivers/media/usb/dvb-usb/dibusb-common.c | 16 ++++++++++++++--
 2 files changed, 30 insertions(+), 18 deletions(-)
