Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36075 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbbHUJ3v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 05:29:51 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/8] Support getting default values from any control
Date: Fri, 21 Aug 2015 11:29:38 +0200
Message-Id: <1440149386-19783-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Integer controls provide a way to get their default/initial value, but
any other control (p_u32, p_u8.....) provide no other way to get the
initial value than unloading the module and loading it back.

*What is the actual problem?
I have a custom control with WIDTH integer values. Every value
represents the calibrated FPN (fixed pattern noise) correction value for that
column
-Application A changes the FPN correction value
-Application B wants to restore the calibrated value but it cant :(

*What is the proposed solution?

(Kudos to Hans Verkuil!!!)

The key change is in struct v4l2_ext_controls where the __u32 ctrl_class field
is changed to:

        union {
                __u32 ctrl_class;
                __u32 which;
        };

And two new defines are added:

#define V4L2_CTRL_WHICH_CUR_VAL        0
#define V4L2_CTRL_WHICH_DEF_VAL        0x0f000000

The 'which' field tells you which controls are get/set/tried.

V4L2_CTRL_WHICH_CUR_VAL: the current value of the controls
V4L2_CTRL_WHICH_DEF_VAL: the default value of the controls
V4L2_CTRL_CLASS_*: the current value of the controls belonging to the specified class.
        Note: this is deprecated usage and is only there for backwards compatibility.
        Which is also why I don't think there is a need to add V4L2_CTRL_WHICH_
        aliases for these defines.


I have posted a copy of my working tree to

https://github.com/ribalda/linux/tree/which_def

Changelog v1 (compared to v5 of New ioct VIDIOC_G_DEF_EXT_CTRLS):

Suggested by Hans Verkuil <hverkuil@xs4all.nl>

Replace ioctl implementation with a new union on the struct v4l2_ext_controls
THANKS!

Ricardo Ribalda Delgado (8):
  videodev2.h: Fix typo in comment
  videodev2.h: Extend struct v4l2_ext_controls
  media/v4l2-core: struct struct v4l2_ext_controls param which
  usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
  media/usb/pvrusb2: Support for V4L2_CTRL_WHICH_DEF_VAL
  media/pci/saa7164-encoder Support for V4L2_CTRL_WHICH_DEF_VAL
  media/pci/saa7164-vbi Support for V4L2_CTRL_WHICH_DEF_VAL
  Docbook: media: Document changes on struct v4l2_ext_controls

 Documentation/DocBook/media/v4l/v4l2.xml           |  9 ++++
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 14 ++++++
 drivers/media/pci/saa7164/saa7164-encoder.c        | 55 ++++++++++++---------
 drivers/media/pci/saa7164/saa7164-vbi.c            | 57 +++++++++++++---------
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           | 17 ++++++-
 drivers/media/usb/uvc/uvc_v4l2.c                   | 14 +++++-
 drivers/media/v4l2-core/v4l2-ctrls.c               | 35 +++++++++++--
 include/uapi/linux/videodev2.h                     |  9 +++-
 8 files changed, 153 insertions(+), 57 deletions(-)

-- 
2.5.0

