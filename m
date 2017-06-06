Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46477
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751243AbdFFJQd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 05:16:33 -0400
Date: Tue, 6 Jun 2017 06:16:26 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.12-rc5] media fixes
Message-ID: <20170606061626.3df98dc6@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.12-2

For some bug fixes:

- Don't fail build if atomisp has warnings;
- Some CEC Kconfig changes to allow it to be used by DRM without media
  dependencies;
- A race fix at RC initialization code;
- A driver fix at rainshadow-cec.

IMHO, the one that affects most people in this series is a build fix:
if you try to build the Kernel with W=1 or gcc7 and all[yes|mod]config,
build will fail due to -Werror at atomisp makefiles.

The following changes since commit 5ed02dbb497422bf225783f46e6eadd237d23d6b:

  Linux 4.12-rc3 (2017-05-28 17:20:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.12-2

for you to fetch changes up to 963761a0b2e85663ee4a5630f72930885a06598a:

  [media] rc-core: race condition during ir_raw_event_register() (2017-06-04 15:25:38 -0300)

----------------------------------------------------------------
media fixes for v4.12-rc4

----------------------------------------------------------------
Colin Ian King (1):
      [media] rainshadow-cec: ensure exit_loop is intialized

Hans Verkuil (3):
      [media] cec: select CEC_CORE instead of depend on it
      [media] cec: rename MEDIA_CEC_NOTIFIER to CEC_NOTIFIER
      [media] cec: drop MEDIA_CEC_DEBUG

Mauro Carvalho Chehab (1):
      [media] atomisp: don't treat warnings as errors

Sean Young (1):
      [media] rc-core: race condition during ir_raw_event_register()

 drivers/media/Kconfig                               |  6 ++++++
 drivers/media/Makefile                              |  4 ++--
 drivers/media/cec/Kconfig                           | 14 --------------
 drivers/media/cec/Makefile                          |  2 +-
 drivers/media/cec/cec-adap.c                        |  2 +-
 drivers/media/cec/cec-core.c                        |  8 ++++----
 drivers/media/i2c/Kconfig                           |  9 ++++++---
 drivers/media/platform/Kconfig                      | 10 ++++++----
 drivers/media/platform/vivid/Kconfig                |  3 ++-
 drivers/media/rc/rc-ir-raw.c                        | 13 ++++++++-----
 drivers/media/usb/pulse8-cec/Kconfig                |  3 ++-
 drivers/media/usb/rainshadow-cec/Kconfig            |  3 ++-
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c   |  2 +-
 drivers/staging/media/atomisp/i2c/Makefile          |  2 --
 drivers/staging/media/atomisp/i2c/imx/Makefile      |  2 --
 drivers/staging/media/atomisp/i2c/ov5693/Makefile   |  2 --
 drivers/staging/media/atomisp/pci/atomisp2/Makefile |  2 +-
 include/media/cec-notifier.h                        |  2 +-
 include/media/cec.h                                 |  4 ++--
 19 files changed, 45 insertions(+), 48 deletions(-)
