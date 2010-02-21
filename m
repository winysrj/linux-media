Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61649 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0BUTlP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 14:41:15 -0500
Received: by bwz1 with SMTP id 1so1188707bwz.21
        for <linux-media@vger.kernel.org>; Sun, 21 Feb 2010 11:41:14 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 21 Feb 2010 14:41:13 -0500
Message-ID: <55a3e0ce1002211141v7b48b532y9f88c7fffae9615d@mail.gmail.com>
Subject: [GIT PATCHES FOR 2.6.34] - vpfe capture support on DM365
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I have removed the IOCTL handling and also dropped a patch that is
related to ioctl handling relative to last pull request. This is based
on our discussion since then.

The following changes since commit d142708594fd5a0828371b31721a8289800d015a:
  Mauro Carvalho Chehab (1):
        V4L/DVB: tuner-xc2028: Fix demod breakage for XC3028L

are available in the git repository at:

  git://linuxtv.org/mkaricheri/vpfe-vpbe-video.git for_upstream_02_21

Murali Karicheri (5):
      DaVinci - Adding platform & board changes for vpfe capture on DM365
      V4L - vpfe capture - header files for ISIF driver
      V4L - vpfe capture - source for ISIF driver on DM365
      V4L - vpfe capture - vpss driver enhancements for DM365
      V4L - vpfe capture - build environment for isif driver

 arch/arm/mach-davinci/board-dm365-evm.c    |   71 ++
 arch/arm/mach-davinci/dm365.c              |  102 +++-
 arch/arm/mach-davinci/include/mach/dm365.h |    2 +
 drivers/media/video/Kconfig                |   14 +-
 drivers/media/video/davinci/Makefile       |    1 +
 drivers/media/video/davinci/isif.c         | 1172 ++++++++++++++++++++++++++++
 drivers/media/video/davinci/isif_regs.h    |  269 +++++++
 drivers/media/video/davinci/vpss.c         |  289 ++++++--
 include/media/davinci/isif.h               |  531 +++++++++++++
 include/media/davinci/vpss.h               |   41 +-
 10 files changed, 2435 insertions(+), 57 deletions(-)
 create mode 100644 drivers/media/video/davinci/isif.c
 create mode 100644 drivers/media/video/davinci/isif_regs.h
 create mode 100644 include/media/davinci/isif.h

-- 
Murali Karicheri
mkaricheri@gmail.com
