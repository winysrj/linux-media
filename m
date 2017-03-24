Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55896
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935083AbdCXKht (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 06:37:49 -0400
Date: Fri, 24 Mar 2017 07:37:41 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.11-rc4] media fixes
Message-ID: <20170324073741.5a557911@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.11-3

for a series of fixes:
   - dvb-usb-firmware: don't do DMA on stack
   - coda/imx-vdoa: platform_driver should not be const
   - bdisp: Clean up file handle in open() error path
   - exynos-gsc: Do not swap cb/cr for semi planar formats

Thanks!
Mauro


The following changes since commit 8c71fff434e5ecf5ff27bd61db1bc9ac4c2b2a1b:

  [media] v4l: vsp1: Adapt vsp1_du_setup_lif() interface to use a structure (2017-03-07 13:34:11 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.11-3

for you to fetch changes up to 24a47426066c8ba16a4db1b20a41d63187281195:

  [media] exynos-gsc: Do not swap cb/cr for semi planar formats (2017-03-22 09:50:07 -0300)

----------------------------------------------------------------
media fixes for v4.11-rc4

----------------------------------------------------------------
Arnd Bergmann (1):
      [media] coda/imx-vdoa: platform_driver should not be const

Shailendra Verma (1):
      [media] bdisp: Clean up file handle in open() error path

Stefan Brüns (1):
      [media] dvb-usb-firmware: don't do DMA on stack

Thibault Saunier (1):
      [media] exynos-gsc: Do not swap cb/cr for semi planar formats

 drivers/media/platform/coda/imx-vdoa.c        |  2 +-
 drivers/media/platform/exynos-gsc/gsc-core.c  |  2 --
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c |  2 +-
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c  | 22 ++++++++++++----------
 4 files changed, 14 insertions(+), 14 deletions(-)
