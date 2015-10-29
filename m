Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33854 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbbJ2KKh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 06:10:37 -0400
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
Subject: [PATCH v2 0/6] Support getting default values from any control
Date: Thu, 29 Oct 2015 11:10:26 +0100
Message-Id: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com>
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


I have posted a copy of my working tree to:

https://github.com/ribalda/linux/tree/which_def_v5



Changelog v2 (compared to Support getting default values from any control

Rebase to latest version
Remove saa7164-* patches (Hans already ported them to v4l2-ctrl)
Update doc dates

Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>:

Fixes for the uvc implementation (error in lock handling) (Thanks!)


Changelog v1 (compared to v5 of New ioct VIDIOC_G_DEF_EXT_CTRLS):

Suggested by Hans Verkuil <hverkuil@xs4all.nl>:

Replace ioctl implementation with a new union on the struct v4l2_ext_controls
THANKS!

Ricardo Ribalda Delgado (6):
  videodev2.h: Extend struct v4l2_ext_controls
  media/core: Replace ctrl_class with which
  media/v4l2-core: struct struct v4l2_ext_controls param which
  usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
  media/usb/pvrusb2: Support for V4L2_CTRL_WHICH_DEF_VAL
  Docbook: media: Document changes on struct v4l2_ext_controls

 Documentation/DocBook/media/v4l/v4l2.xml           | 10 ++++
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 28 +++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           | 16 ++++++-
 drivers/media/usb/uvc/uvc_v4l2.c                   | 20 ++++++++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  6 +--
 drivers/media/v4l2-core/v4l2-ctrls.c               | 54 ++++++++++++++++------
 drivers/media/v4l2-core/v4l2-ioctl.c               | 14 +++---
 include/uapi/linux/videodev2.h                     | 12 ++++-
 10 files changed, 131 insertions(+), 33 deletions(-)

-- 
2.6.1

