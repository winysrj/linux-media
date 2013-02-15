Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1964 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab3BOKXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 05:23:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.9] stk-webcam: v4l2 compliance fixes
Date: Fri, 15 Feb 2013 11:23:42 +0100
Cc: Arvydas Sidorenko <asido4@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302151123.42156.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request is identical to the RFCv2 patch series posted here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg58580.html

except for the first patch which was replaced by this one:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg58640.html

Many thanks to Arvydas Sidorenko for testing these patches for me!

Regards,

	Hans

The following changes since commit ed72d37a33fdf43dc47787fe220532cdec9da528:

  [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) (2013-02-13 18:05:29 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git stkwebcam

for you to fetch changes up to a842e7e8196e6a85ba1ed05a4b87c47759db7e3b:

  stk-webcam: implement support for count == 0 when calling REQBUFS. (2013-02-15 11:16:58 +0100)

----------------------------------------------------------------
Hans Verkuil (12):
      stk-webcam: add ASUS F3JC to upside-down list.
      stk-webcam: remove bogus STD support.
      stk-webcam: add support for struct v4l2_device.
      stk-webcam: convert to the control framework.
      stk-webcam: don't use private_data, use video_drvdata
      stk-webcam: add support for control events and prio handling.
      stk-webcam: fix querycap and simplify s_input.
      stk-webcam: zero the priv field of v4l2_pix_format.
      stk-webcam: enable core-locking.
      stk-webcam: fix read() handling when reqbufs was already called.
      stk-webcam: s_fmt shouldn't grab ownership.
      stk-webcam: implement support for count == 0 when calling REQBUFS.

 drivers/media/usb/stkwebcam/stk-webcam.c |  309 ++++++++++++++++++++++++++++++++++------------------------------
 drivers/media/usb/stkwebcam/stk-webcam.h |    8 +-
 2 files changed, 172 insertions(+), 145 deletions(-)
