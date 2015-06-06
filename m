Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35745 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbbFFWa0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2015 18:30:26 -0400
Received: by qkhq76 with SMTP id q76so58963382qkh.2
        for <linux-media@vger.kernel.org>; Sat, 06 Jun 2015 15:30:25 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: dale.hamel@srvthe.net, michael@stegemann.it,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH v2 0/2] stk1160: Frame scaling and "de-verbosification"
Date: Sat,  6 Jun 2015 19:26:56 -0300
Message-Id: <1433629618-1833-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've removed the driver verbosity and fixed the frame scale implementation.
In addition to the usual mplayer/vlc/qv4l2, it's tested with v4l2-compliance
on 4.1-rc4.

v4l2-compliance passes:
Total: 111, Succeeded: 111, Failed: 0, Warnings: 5

v4l2-compliance -s shows some failures, but AFAICS it's not the
driver's fault as the failing ioclt are handled by generic
implementations (vb2_ioctl_reqbufs):

	test MMAP: FAIL
		VIDIOC_QUERYCAP returned 0 (Success)
		VIDIOC_QUERY_EXT_CTRL returned 0 (Success)
		VIDIOC_TRY_EXT_CTRLS returned 0 (Success)
		VIDIOC_QUERYCTRL returned 0 (Success)
		VIDIOC_G_SELECTION returned -1 (Inappropriate ioctl for device)
		VIDIOC_REQBUFS returned -1 (Device or resource busy)
		fail: v4l2-test-buffers.cpp(976): ret != EINVAL
	test USERPTR: FAIL
		VIDIOC_QUERYCAP returned 0 (Success)
		VIDIOC_QUERY_EXT_CTRL returned 0 (Success)
		VIDIOC_TRY_EXT_CTRLS returned 0 (Success)
		VIDIOC_QUERYCTRL returned 0 (Success)
		VIDIOC_G_SELECTION returned -1 (Inappropriate ioctl for device)
		VIDIOC_REQBUFS returned -1 (Invalid argument)
	test DMABUF: OK (Not Supported)
		VIDIOC_QUERYCAP returned 0 (Success)
		VIDIOC_QUERY_EXT_CTRL returned 0 (Success)
		VIDIOC_TRY_EXT_CTRLS returned 0 (Success)
		VIDIOC_QUERYCTRL returned 0 (Success)
		VIDIOC_G_SELECTION returned -1 (Inappropriate ioctl for device)

Total: 115, Succeeded: 113, Failed: 2, Warnings: 5

Thanks,

Ezequiel Garcia (2):
  stk1160: Reduce driver verbosity
  stk1160: Add frame scaling support

 drivers/media/usb/stk1160/stk1160-core.c |   5 +-
 drivers/media/usb/stk1160/stk1160-reg.h  |  34 ++++++
 drivers/media/usb/stk1160/stk1160-v4l.c  | 203 +++++++++++++++++++++++++------
 drivers/media/usb/stk1160/stk1160.h      |   1 -
 4 files changed, 202 insertions(+), 41 deletions(-)

-- 
2.3.3

