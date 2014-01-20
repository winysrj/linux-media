Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1824 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaATMqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 07:46:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com
Subject: [RFCv2 PATCH 00/21] Add support for complex controls
Date: Mon, 20 Jan 2014 13:45:53 +0100
Message-Id: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
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

This patch series is a revision of this series:

http://www.spinics.net/lists/linux-media/msg71281.html

Changes since RFCv1 are:

- dropped configuration store support for now (there is no driver at the moment
  that needs it).
- dropped the term 'property', instead call it a 'control with a complex type'
  or 'complex control' for short.
- added DocBook documentation.

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

There is one open item: if a complex control is a matrix, then it is possible
to set only the first N elements of that matrix (starting at the first row).
Currently the API will initialize the remaining elements to their default
value. The idea was that if you have an array of, say, selection
rectangles, then if you just set the first one the others will be automatically
zeroed (i.e. set to unused). Without that you would be forced to set the whole
array unless you are certain that they are already zeroed.

It also has the advantage that when you set a control you know that all elements
are set, even if you don't specify them all.

Should I support the ability to set only the first N elements of a matrix at all?

I see three options:

1) allow getting/setting only the first N elements and (when setting) initialize
   the remaining elements to their default value.
2) allow getting/setting only the first N elements and leave the remaining
   elements to their old value.
3) always set the full matrix.

I am actually leaning towards 3 as that is the only unambiguous option. If there
is a good use case in the future support for 1 or 2 can always be added later.

Once everyone agrees with this API extension I will make a third version of this
patch series that adds the Motion Detection support for the solo6x10 and go7007
drivers that can now use the new matrix controls. That way actual drivers will
start using this (and it will allow me to move those drivers out of staging).

Regards,

	Hans

