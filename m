Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50524
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932347AbdA0KSQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 05:18:16 -0500
Date: Fri, 27 Jan 2017 07:54:56 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.10-rc6] media fixes
Message-ID: <20170127075456.13af6d93@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.10-2

For some fixes for -rc6:
  - fix a regression on tvp5150 causing failures at input selection
    and image glitches;
  - CEC was moved out of staging for v4.10. Fix some bugs on it while
    not too late;
  - fix a regression on pctv452e caused by VM stack changes;
  - fix suspend issued with smiapp;
  - fix a regression on cobalt driver;
  - fix some warnings and Kconfig issues with some random configs.

The following changes since commit 65390ea01ce678379da32b01f39fcfac4903f256:

  Merge branch 'patchwork' into v4l_for_linus (2016-12-15 08:38:35 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.10-2

for you to fetch changes up to 0e0694ff1a7791274946b7f51bae692da0001a08:

  Merge branch 'patchwork' into v4l_for_linus (2016-12-26 14:09:28 -0200)

----------------------------------------------------------------
media fixes for v4.10-rc6

----------------------------------------------------------------
Arnd Bergmann (2):
      [media] dvb: avoid warning in dvb_net
      [media] s5k4ecgx: select CRC32 helper

Christoph Hellwig (1):
      [media] media/cobalt: use pci_irq_allocate_vectors

Hans Verkuil (7):
      [media] cec: fix report_current_latency
      [media] cec: when canceling a message, don't overwrite old status info
      [media] cec: CEC_MSG_GIVE_FEATURES should abort for CEC version < 2
      [media] cec: update log_addr[] before finishing configuration
      [media] cec: replace cec_report_features by cec_fill_msg_report_features
      [media] cec: move cec_report_phys_addr into cec_config_thread_func
      [media] cec: fix race between configuring and unconfiguring

Laurent Pinchart (3):
      [media] v4l: tvp5150: Reset device at probe time, not in get/set format handlers
      [media] v4l: tvp5150: Fix comment regarding output pin muxing
      [media] v4l: tvp5150: Don't override output pinmuxing at stream on/off time

Mauro Carvalho Chehab (1):
      Merge branch 'patchwork' into v4l_for_linus

Max Kellermann (1):
      [media] pctv452e: move buffer to heap, no mutex

Sakari Ailus (2):
      [media] smiapp: Implement power-on and power-off sequences without runtime PM
      [media] smiapp: Make suspend and resume functions __maybe_unused

 drivers/media/cec/cec-adap.c             | 103 ++++++++++++------------
 drivers/media/dvb-core/dvb_net.c         |  15 ++--
 drivers/media/i2c/Kconfig                |   1 +
 drivers/media/i2c/smiapp/smiapp-core.c   |  33 +++-----
 drivers/media/i2c/tvp5150.c              |  56 ++++++++-----
 drivers/media/i2c/tvp5150_reg.h          |   9 +++
 drivers/media/pci/cobalt/cobalt-driver.c |   8 +-
 drivers/media/pci/cobalt/cobalt-driver.h |   2 -
 drivers/media/usb/dvb-usb/pctv452e.c     | 133 +++++++++++++++++--------------
 include/uapi/linux/cec-funcs.h           |  10 ++-
 10 files changed, 195 insertions(+), 175 deletions(-)

