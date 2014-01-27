Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1955 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaA0Oer (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jan 2014 09:34:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com
Subject: [RFCv3 PATCH 00/22] Add support for complex controls
Date: Mon, 27 Jan 2014 15:34:02 +0100
Message-Id: <1390833264-8503-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for complex controls (aka 'Properties') to
the control framework. It is the first part of a larger patch series that
adds support for configuration stores, motion detection matrix controls and
support for 'Multiple Selections'.

This patch series is based on this RFC:

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/71822

A more complete patch series (including configuration store support and the
motion detection work) can be found here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/propapi-doc

This patch series is a revision of RFCv2:

http://www.spinics.net/lists/linux-media/msg71828.html

Changes since RFCv2 are:

- incorporated Sylwester's comments
- split up patch [20/21] into two: one for the codingstyle fixes in the example
  code, one for the actual DocBook additions.
- fixed a bug in patch 6 that broke the old-style VIDIOC_QUERYCTRL. Also made
  the code in v4l2_query_ext_ctrl() that sets the mask/match variables more
  readable. If I had to think about my own code, then what are the chances others
  will understand it? :-)
- dropped the support for setting/getting partial matrices. That's too ambiguous
  at the moment, and we can always add that later if necessary.

The API changes required to support complex controls are minimal:

- A new V4L2_CTRL_FLAG_HIDDEN has been added: any control with this flag (and
  complex controls will always have this flag) will never be shown by control
  panel GUIs. The only way to discover them is to pass the new _FLAG_NEXT_HIDDEN
  flag to QUERYCTRL.

- A new VIDIOC_QUERY_EXT_CTRL ioctl has been added: needed to get the number of elements
  stored in the control (rows by columns) and the size in byte of each element.
  As a bonus feature a unit string has also been added as this has been requested
  in the past. In addition min/max/step/def values are now 64-bit.

- A new 'p' field is added to struct v4l2_ext_control to set/get complex values.

- A helper flag V4L2_CTRL_FLAG_IS_PTR has been added to tell apps whether the
  'value' or 'value64' fields of the v4l2_ext_control struct can be used (bit
  is cleared) or if the 'p' pointer can be used (bit it set).

Once everyone agrees with this API extension I will make a next version of this
patch series that adds the Motion Detection support for the solo6x10 and go7007
drivers that can now use the new matrix controls. That way actual drivers will
start using this (and it will allow me to move those drivers out of staging).

Regards,

        Hans


