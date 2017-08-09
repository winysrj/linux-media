Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41898 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752199AbdHIH5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 03:57:22 -0400
Date: Wed, 9 Aug 2017 10:57:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: alan@linux.intel.com
Subject: [GIT PULL for 4.14] Atomisp cleanups
Message-ID: <20170809075719.bcwhkumaqjhh3dc7@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a usual bunch of atomisp cleanups.

Please pull.


The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

  media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

  https://linuxtv.org/git/sailus/media_tree.git atomisp

for you to fetch changes up to c06f41fb60389ef7bc59ee58ed07bab444fd5455:

  staging: media: atomisp: constify video_subdev structures (2017-08-08 15:55:05 +0300)

----------------------------------------------------------------
Geliang Tang (1):
      staging: media: atomisp: use kvmalloc/kvzalloc

Julia Lawall (2):
      staging: media: atomisp: constify videobuf_queue_ops structures
      staging: media: atomisp: constify video_subdev structures

Rene Hickersberger (1):
      staging: media: atomisp: i2c: gc0310: fixed brace coding style issue

Stephen Brennan (1):
      staging: media: atomisp: remove trailing whitespace

 drivers/staging/media/atomisp/i2c/ap1302.c         |  2 +-
 drivers/staging/media/atomisp/i2c/gc0310.c         |  3 +--
 drivers/staging/media/atomisp/i2c/mt9m114.c        |  2 +-
 drivers/staging/media/atomisp/i2c/ov2680.c         | 17 ++++++------
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 31 +---------------------
 .../media/atomisp/pci/atomisp2/atomisp_cmd.h       |  2 --
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |  4 +--
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |  4 +--
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |  2 --
 9 files changed, 16 insertions(+), 51 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
