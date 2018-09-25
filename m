Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:59192 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727531AbeIYQVe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 12:21:34 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, tfiga@chromium.org, bingbu.cao@intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tian.shu.qiu@intel.com, ricardo.ribalda@gmail.com,
        grundler@chromium.org, ping-chung.chen@intel.com,
        andy.yeh@intel.com, jim.lai@intel.com, helmut.grohne@intenta.de,
        laurent.pinchart@ideasonboard.com, snawrocki@kernel.org
Subject: [PATCH 0/5] Add units to controls
Date: Tue, 25 Sep 2018 13:14:29 +0300
Message-Id: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This set adds a few things to the current control framework in terms of
what kind of information the user space may have on controls. It adds
support for units and prefixes, exponential base as well as information on
whether a control is linear or exponential, to struct v4l2_query_ext_ctrl.

The smiapp driver gains support for the feature. In the near term, some
controls could also be assigned the unit automatically. The pixel rate,
for instance. Fewer driver changes would be needed this way. A driver
could override the value if there's a need to.

I think I'll merge the undefined and no unit cases. Same for the
exponential base actually --- the flag can be removed, too...

Regarding Ricardo's suggestion --- I was thinking of adding a control flag
(yes, there are a few bits available) to tell how to round the value. The
user could use the TRY_EXT_CTRLS IOCTL to figure out the next (or
previous) control value by incrementing the current value and setting the
appropriate flag. This is out of the scope of this set though.

Comments, questions?

Sakari Ailus (5):
  videodev2.h: Use 8 hexadecimals (32 bits) for control flags
  v4l: controls: Add support for exponential bases, prefixes and units
  Documentation: media: Document control exponential bases, units,
    prefixes
  v4l: controls: QUERY_EXT_CTRL support for base, prefix and unit
  smiapp: Set control units

 Documentation/media/uapi/v4l/extended-controls.rst |   2 +
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  | 174 +++++++++++++++++++--
 Documentation/media/videodev2.h.rst.exceptions     |  22 +++
 drivers/media/i2c/smiapp/smiapp-core.c             |  16 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   3 +
 include/media/v4l2-ctrls.h                         |   2 +
 include/uapi/linux/videodev2.h                     |  54 +++++--
 7 files changed, 242 insertions(+), 31 deletions(-)

-- 
2.11.0
