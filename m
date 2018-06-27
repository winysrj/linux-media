Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58839 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbeF0Lj4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 07:39:56 -0400
Date: Wed, 27 Jun 2018 12:39:55 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.18] meson-ir produces too many warnings
Message-ID: <20180627113954.xa7csnrrsigzj7ps@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The meson-ir drivers produces a lot of errors since v4.18. Simply make
this dev_warn_once().

Thanks,
Sean

The following changes since commit e88f5e9ebd54bdf75c9833e3d9add7c2c0d39b0b:

  media: uvcvideo: Prevent setting unavailable flags (2018-06-05 08:53:17 -0400)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.18e

for you to fetch changes up to 97983eed9c07ffd94429527a5e41facde4811fbc:

  media: rc: be less noisy when driver misbehaves (2018-06-27 10:51:42 +0100)

----------------------------------------------------------------
Sean Young (1):
      media: rc: be less noisy when driver misbehaves

 drivers/media/rc/rc-ir-raw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
