Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53577 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbbK3U10 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com
Subject: [PATCH 00/11] cx23885: cleanups, add ViewCast 260e/460e support
Date: Mon, 30 Nov 2015 21:27:10 +0100
Message-Id: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

A friend asked me to help getting his ViewCast 460e to work. Little did I
know...

Kernel Labs did work on this card lots of kernel version ago, but after
integrating that work it still didn't function properly.

After digging deeper it turned out that there were a lot of register
differences between the cx23888 and the cx2388x/cx25840/cx231xx devices
that were not correctly handled. Also issues with format/cropcap/std handling
in cx25840 and cx23885 caused problems.

This patch series makes the ViewCast 460e work. Tested with a ViewCast 460e,
cx25840-based board (ivtv), cx231xx board and cx23885 board.

This patch series also adds the new cs3308 driver, used by the ViewCast
and written by Kernel Labs.

And it fixes broken pixelaspect ratio reporting by cx231xx and ivtv/cx18
which I discovered while digging into that topic for the cx23885.

Regards,

	Hans

Hans Verkuil (11):
  cx23885: fix format/crop handling
  cx231xx: fix NTSC cropcap, add missing cropcap for 417
  ivtv/cx18: fix inverted pixel aspect ratio
  cx25840: fix VBI support for cx23888
  cx25840: more cx23888 register address changes
  cx25840: relax a Vsrc check
  cx25840: fix cx25840_s_stream for cx2388x and cx231xx
  cx25840: initialize the standard to NTSC_M
  cs3308: add new 8-channel volume control driver
  cx23885: add support for ViewCast 260e and 460e.
  cx23885: video instead of vbi register used

 MAINTAINERS                               |   9 ++
 drivers/media/i2c/Kconfig                 |  10 +++
 drivers/media/i2c/Makefile                |   1 +
 drivers/media/i2c/cs3308.c                | 138 ++++++++++++++++++++++++++++++
 drivers/media/i2c/cx25840/cx25840-core.c  | 115 +++++++++++++------------
 drivers/media/i2c/cx25840/cx25840-core.h  |   1 +
 drivers/media/i2c/cx25840/cx25840-vbi.c   |  32 +++++--
 drivers/media/pci/cx18/cx18-ioctl.c       |   4 +-
 drivers/media/pci/cx23885/Kconfig         |   1 +
 drivers/media/pci/cx23885/cx23885-cards.c | 114 ++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885-core.c  |  10 +++
 drivers/media/pci/cx23885/cx23885-i2c.c   |   2 +
 drivers/media/pci/cx23885/cx23885-vbi.c   |   3 +-
 drivers/media/pci/cx23885/cx23885-video.c |  43 +++++++++-
 drivers/media/pci/cx23885/cx23885.h       |   7 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c       |   8 +-
 drivers/media/usb/cx231xx/cx231xx-417.c   |  22 +++++
 drivers/media/usb/cx231xx/cx231xx-video.c |   5 +-
 18 files changed, 444 insertions(+), 81 deletions(-)
 create mode 100644 drivers/media/i2c/cs3308.c

-- 
2.6.2

