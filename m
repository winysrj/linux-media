Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55880 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752488AbeCWNba (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 09:31:30 -0400
Date: Fri, 23 Mar 2018 10:31:24 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.16-rc7] media fixes
Message-ID: <20180323103124.6b4ba803@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.16-4


For 3 fixes:
      - dvb: fix a Kconfig typo on a help text
      - tegra-cec: reset rx_buf_cnt when start bit detected
      - rc: lirc does not use LIRC_CAN_SEND_SCANCODE feature

Thanks!
Mauro

-

The following changes since commit 7dbdd16a79a9d27d7dca0a49029fc8966dcfecc5:

  media: vb2: Makefile: place vb2-trace together with vb2-core (2018-02-26 11:39:04 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.16-4

for you to fetch changes up to 2c27476e398bfd9fa2572ff80a0de16f0becc900:

  media: dvb: fix a Kconfig typo (2018-03-05 07:57:41 -0500)

----------------------------------------------------------------
media fixes for v4.16-rc7

----------------------------------------------------------------
Hans Verkuil (1):
      media: tegra-cec: reset rx_buf_cnt when start bit detected

Michael Ira Krufky (1):
      media: dvb: fix a Kconfig typo

Sean Young (1):
      media: rc: lirc does not use LIRC_CAN_SEND_SCANCODE feature

 drivers/media/Kconfig                        |  2 +-
 drivers/media/platform/tegra-cec/tegra_cec.c | 17 +++++++----------
 include/uapi/linux/lirc.h                    |  1 -
 3 files changed, 8 insertions(+), 12 deletions(-)
