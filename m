Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1870 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab1EWLPe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:15:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.41] Add bitmask controls
Date: Mon, 23 May 2011 13:15:29 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231315.29328.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

These patches for 2.6.41 add support for bitmask controls, needed for the
upcoming Flash API and HDMI API.

Sakari, can you give your ack as well?

The patch is the same as the original one posted April 4, except for a small
change in the control logging based on feedback from Laurent and the new
DocBook documentation.

Regards,

	Hans

The following changes since commit 87cf028f3aa1ed51fe29c36df548aa714dc7438f:

  [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked (2011-05-21 11:10:28 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git core3

Hans Verkuil (3):
      v4l2-ctrls: add new bitmask control type.
      vivi: add bitmask test control.
      DocBook: document V4L2_CTRL_TYPE_BITMASK.

 Documentation/DocBook/v4l/compat.xml           |    8 ++++++++
 Documentation/DocBook/v4l/v4l2.xml             |    9 ++++++++-
 Documentation/DocBook/v4l/vidioc-queryctrl.xml |   12 +++++++++++-
 drivers/media/video/v4l2-common.c              |    3 +++
 drivers/media/video/v4l2-ctrls.c               |   17 ++++++++++++++++-
 drivers/media/video/vivi.c                     |   18 ++++++++++++++++--
 include/linux/videodev2.h                      |    1 +
 7 files changed, 63 insertions(+), 5 deletions(-)
