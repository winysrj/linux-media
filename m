Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53286
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752183AbdHZJ2h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 05:28:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jouni Ukkonen <jouni.ukkonen@intel.com>,
        SeongJae Park <sj38.park@gmail.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Evgeni Raikhel <evgeni.raikhel@intel.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Pavel Machek <pavel@ucw.cz>,
        Archit Taneja <architt@codeaurora.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Aviv Greenberg <aviv.d.greenberg@intel.com>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Subject: [PATCH 0/4] Fix problems on building documentation with Sphinx 1.6
Date: Sat, 26 Aug 2017 06:28:24 -0300
Message-Id: <cover.1503739177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx 1.6 changed the way tables are produced, adding some new
macros before tables that do vertical alignments. This is incompatible
with adjustbox, used by the media book, causing build to fail.

This series fix such issues and make the layout on Sphinx 1.6 acceptable.

The first patch in this series is just a minor fix: it adjust the top and
bottom margins to 1 inch, for newer Sphinx versions, just like on
Spinx 1.4;

The second patch gets rid of adjustbox at the media book and 
adjust its tables to better fit on the output layout, making it
compatible with Sphinx 1.6;

The third patch updates sphinx.rst to remove the restriction for
Sphinx 1.6.

The final patch is just a cleanup patch: it removes adjustbox dependency
from LaTeX output and stop requiring it when checking for
build system dependencies. It should only be applied after
patch 2 is merged.

Jon,

IMHO, the best is if I apply patch 2 on my trees. Please apply
patches 1 and 3 on your tree.

Patch 4 can only be applied after  patch 2 gets merged, but it
is just a cleanup patch that can be applied any time later.

Mauro Carvalho Chehab (4):
  docs-rst: fix verbatim font size on tables
  media: fix pdf build with Spinx 1.6
  sphinx.rst: Allow Sphinx version 1.6 at the docs
  docs-rst: don't require adjustbox anymore

 Documentation/conf.py                              |   5 +-
 Documentation/doc-guide/sphinx.rst                 |   4 +-
 Documentation/media/uapi/v4l/dev-meta.rst          |   2 +
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |  23 ++-
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
 23 files changed, 204 insertions(+), 175 deletions(-)

-- 
2.13.3
