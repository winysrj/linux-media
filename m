Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57294 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755854AbcIFMBx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 08:01:53 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 9173A60093
        for <linux-media@vger.kernel.org>; Tue,  6 Sep 2016 15:01:44 +0300 (EEST)
Date: Tue, 6 Sep 2016 15:01:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.9] Raw bayer media bus codes and fixes, raw bayer
 pixelformat cleanups
Message-ID: <20160906120113.GA3236@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are cleanups for the raw bayer pixelformats and new media bus codes for
the 14 and 16 bits per sample variants. The smiapp driver uses the newly
added formats.

Please pull.


The following changes since commit e62c30e76829d46bf11d170fd81b735f13a014ac:

  [media] smiapp: Remove set_xclk() callback from hwconfig (2016-09-05 15:53:20 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git packed12

for you to fetch changes up to 903dc2ce0604199f2984640e2ffff29e82397434:

  smiapp: Add support for 14 and 16 bits per sample depths (2016-09-06 14:46:36 +0300)

----------------------------------------------------------------
Jouni Ukkonen (1):
      media: Add 1X14 14-bit raw bayer media bus code definitions

Sakari Ailus (7):
      doc-rst: Correct the ordering of LSBs of the 10-bit raw packed formats
      doc-rst: Fix number of zeroed high order bits in 12-bit raw format defs
      doc-rst: Clean up raw bayer pixel format definitions
      doc-rst: Unify documentation of the 8-bit bayer formats
      doc-rst: 16-bit BGGR is always 16 bits
      media: Add 1X16 16-bit raw bayer media bus code definitions
      smiapp: Add support for 14 and 16 bits per sample depths

 Documentation/media/uapi/v4l/pixfmt-rgb.rst      |   3 -
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst  |   5 -
 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst   |  77 ----
 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst   |  80 ----
 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst   |  80 ----
 Documentation/media/uapi/v4l/pixfmt-srggb10.rst  |  15 +-
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst |  24 +-
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst  |   5 +-
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst   |  38 +-
 Documentation/media/uapi/v4l/subdev-formats.rst  | 546 ++++++++++++++++++++++-
 drivers/media/i2c/smiapp/smiapp-core.c           |   8 +
 drivers/media/i2c/smiapp/smiapp.h                |   2 +-
 include/uapi/linux/media-bus-format.h            |  10 +-
 13 files changed, 606 insertions(+), 287 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
