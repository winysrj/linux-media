Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33215 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaKGMvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 07:51:51 -0500
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id D8C342A002F
	for <linux-media@vger.kernel.org>; Fri,  7 Nov 2014 13:51:46 +0100 (CET)
Message-ID: <545CC052.9090104@xs4all.nl>
Date: Fri, 07 Nov 2014 13:51:30 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] Various fixes and improvements.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:

  [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19e

for you to fetch changes up to a66997d1b637fb110a50e5d770a6aa13630b560c:

  media: davinci: vpbe: missing clk_put (2014-11-07 13:37:33 +0100)

----------------------------------------------------------------
Andrey Utkin (4):
      solo6x10: clean up properly in stop_streaming
      solo6x10: free DMA allocation when releasing encoder
      solo6x10: bind start & stop of encoded frames processing thread to device (de)init
      solo6x10: don't turn off/on encoder interrupt in processing loop

Hans Verkuil (1):
      vivid: add test array controls

Joe Perches (1):
      cx25840/cx18: Use standard ordering of mask and shift

Prabhakar Lad (1):
      media: davinci: vpbe: add support for VIDIOC_CREATE_BUFS

Sudip Mukherjee (1):
      media: davinci: vpbe: missing clk_put

sensoray-dev (1):
      s2255drv: fix spinlock issue

 drivers/media/i2c/cx25840/cx25840-core.c       | 12 ++++++------
 drivers/media/pci/cx18/cx18-av-core.c          | 16 ++++++++--------
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 28 ++++++++++++++++++----------
 drivers/media/platform/davinci/vpbe.c          |  1 +
 drivers/media/platform/davinci/vpbe_display.c  | 10 +++++++---
 drivers/media/platform/vivid/vivid-ctrls.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/media/usb/s2255/s2255drv.c             | 22 ++++++++++------------
 include/media/davinci/vpbe_display.h           |  2 --
 8 files changed, 92 insertions(+), 41 deletions(-)
