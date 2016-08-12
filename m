Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52324 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbcHLLJd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 07:09:33 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Add new pixelformats
Message-ID: <5d87f61b-ba1d-0a9e-5e0d-fdc7a8f840c4@xs4all.nl>
Date: Fri, 12 Aug 2016 13:09:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes for existing pixelformat descriptions and new pixelformats.

See the cover letter of the patch series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg100998.html

I agree with Sakari's reasoning: these are standard formats that many newer
devices support. I also like that the list of Bayer formats is now more
systematic and covers all (?) common formats.

Regards,

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git newpixfmts

for you to fetch changes up to 2feb1e8a20a88bcd0aa4e2b46cabcc51241f37b8:

  doc-rst: Add 16-bit raw bayer pixel format definitions (2016-08-12 13:02:48 +0200)

----------------------------------------------------------------
Jouni Ukkonen (1):
      media: Add 1X14 14-bit raw bayer media bus code definitions

Sakari Ailus (10):
      doc-rst: Correct the ordering of LSBs of the 10-bit raw packed formats
      doc-rst: Fix number of zeroed high order bits in 12-bit raw format defs
      doc-rst: Clean up raw bayer pixel format definitions
      doc-rst: Unify documentation of the 8-bit bayer formats
      v4l: Add packed Bayer raw12 pixel formats
      doc-rst: Add 14-bit raw bayer pixel format definitions
      doc-rst: Add packed Bayer raw14 pixel formats
      media: Add 1X16 16-bit raw bayer media bus code definitions
      doc-rst: 16-bit BGGR is always 16 bits
      doc-rst: Add 16-bit raw bayer pixel format definitions

 Documentation/media/uapi/v4l/pixfmt-rgb.rst                          |   8 +-
 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst                       |  81 -----
 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst                       |  81 -----
 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst                       |  81 -----
 Documentation/media/uapi/v4l/pixfmt-srggb10.rst                      |  15 +-
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst                     |  24 +-
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst                      |   5 +-
 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst                     | 107 ++++++
 Documentation/media/uapi/v4l/pixfmt-srggb14.rst                      | 122 +++++++
 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst                     | 127 +++++++
 .../media/uapi/v4l/{pixfmt-sbggr16.rst => pixfmt-srggb16.rst}        |  32 +-
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst                       |  41 ++-
 Documentation/media/uapi/v4l/subdev-formats.rst                      | 546 ++++++++++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-ioctl.c                                 |  21 +-
 include/uapi/linux/media-bus-format.h                                |  10 +-
 include/uapi/linux/videodev2.h                                       |  17 +
 16 files changed, 1012 insertions(+), 306 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb14.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
 rename Documentation/media/uapi/v4l/{pixfmt-sbggr16.rst => pixfmt-srggb16.rst} (55%)
