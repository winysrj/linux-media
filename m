Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34844 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756616AbeDFOX2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Douglas Fischer <fischerdouglasc@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, devel@driverdev.osuosl.org,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 00/21]  Fix sparse/smatch errors on non-x86 drivers
Date: Fri,  6 Apr 2018 10:23:01 -0400
Message-Id: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After applying this patch series:

    https://www.mail-archive.com/linux-media@vger.kernel.org/msg128829.html

Which allows to build all drivers with COMPILE_TEST on x86, my scripts
can finally check for errors/warnings on those drivers.

This patch series correct those warnings.

Mauro Carvalho Chehab (21):
  media: davinci_vpfe: remove useless checks from ipipe
  media: dm365_ipipe: remove an unused var
  media: davinci_vpfe: fix vpfe_ipipe_init() error handling
  media: davinci_vpfe: mark __iomem as such
  media: davinci_vpfe: get rid of an unused var at dm365_isif.c
  media: davinci_vpfe: vpfe_video: remove an unused var
  media: davinci_vpfe: don't use kernel-doc markup for simple comments
  media: davinci_vpfe: fix a typo for "default"
  media: davinci_vpfe: cleanup ipipe_[g|s]_config logic
  media: davinci_vpfe: fix __user annotations
  media: si470x: fix __be16 annotations
  media: isif: reorder a statement to match coding style
  media: davinci: fix an inconsistent ident
  media: mmp-driver: add needed __iomem marks to power_regs
  media: vpbe_display: properly handle error case
  media: vpbe_display: get rid of warnings
  media: ispstat: use %p to print the address of a buffer
  media: isppreview: fix __user annotations
  media: fsl-viu: use %p to print pointers
  media: fsl-viu: fix __iomem annotations
  media: omap_vout: fix wrong identing

 drivers/media/platform/davinci/isif.c              |   2 +-
 drivers/media/platform/davinci/vpbe_display.c      |  12 +-
 drivers/media/platform/davinci/vpbe_osd.c          |   5 +-
 drivers/media/platform/fsl-viu.c                   |  43 +++----
 drivers/media/platform/marvell-ccic/mmp-driver.c   |   2 +-
 drivers/media/platform/omap/omap_vout.c            |  15 ++-
 drivers/media/platform/omap3isp/isppreview.c       |   2 +-
 drivers/media/platform/omap3isp/ispstat.c          |   4 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   6 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   | 131 ++++++++++-----------
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |  19 +--
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  14 +--
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |   9 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  13 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |   2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   4 +-
 16 files changed, 121 insertions(+), 162 deletions(-)

-- 
2.14.3
