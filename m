Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41841
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753658AbdHWI5F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 04:57:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 0/4] Fix problems with PDF output with Sphinx 1.6
Date: Wed, 23 Aug 2017 05:56:53 -0300
Message-Id: <cover.1503477995.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series have a few patches that fix Sphinx 1.6 builds. I've sent two of
those patches before, individually, but it was not clear who should merge it.
So, I ended by splitting the first patch into two ones: one touching just at
the media book, and the last one touching Sphinx documentation and build
system.

When compared to version 1, the frist patch fix troubles on some additional
tables. Now, all V4L2 tables look OK when built with Sphinx 1.6.

Patch 2 fixes a bad behavior: if a verbatim block is added inside a table, the
font is changed to \small. That works fine if the table's font is normal, but, if
the font is smaller, it would print a too large font. I applied the fix only to one
table where the effect was really bad and caused line wrapping, but perhaps 
it would need on some other tables as well.

Patch 3 is the same as the one previously sent.

All those patches are based on both media and docs patches for -next and
are available on this git tree:

    https://git.linuxtv.org/mchehab/experimental.git/log/?h=sphinx_install_v4

IMHO, the best would be to merge the first two patches via the media tree,
and the two last ones via docs tree.

Jon, would that work for you?

Mauro Carvalho Chehab (4):
  media: fix pdf build with Spinx 1.6
  media: dev-sliced-vbi.rst: fix verbatim font size on a table
  docs-rst: pdf: use same vertical margin on all Sphinx versions
  docs-rst: Allow Sphinx version 1.6

 Documentation/conf.py                              |   5 +-
 Documentation/doc-guide/sphinx.rst                 |   4 +-
 Documentation/media/uapi/v4l/dev-meta.rst          |   2 +
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |  24 ++-
 Documentation/media/uapi/v4l/dev-subdev.rst        |   6 +-
 Documentation/media/uapi/v4l/extended-controls.rst |   6 +-
 Documentation/media/uapi/v4l/pixfmt-inzi.rst       |   7 +-
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst |  30 ++--
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst | 186 +++++++++++----------
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst |  50 +++---
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst   |   7 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    |  17 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   2 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |   2 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |   2 +
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |   9 +-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |   4 +-
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |   2 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |   2 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |   6 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |   4 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |   2 +-
 scripts/sphinx-pre-install                         |   1 -
 23 files changed, 206 insertions(+), 174 deletions(-)

-- 
2.13.3
