Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46823 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbbGTNAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:00:48 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5CD642A0095
	for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 14:59:41 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/12] usbvision: convert to control framework
Date: Mon, 20 Jul 2015 14:59:26 +0200
Message-Id: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series converts the usbvision driver to the control framework.
It also fixes a bunch of other bugs, making it a bit more v4l2-compliance
friendly.

This driver still needs a lot of work to make it pass v4l2-compliance, but
this is a start.

Regards,

	Hans

Hans Verkuil (11):
  usbvision: remove power_on_at_open and timed power off
  usbvision: convert to the control framework
  usbvision: return valid error in usbvision_register_video()
  usbvision: remove g/s_audio and for radio remove enum/g/s_input
  usbvision: the radio device node has wrong caps
  usbvision: frequency fixes.
  usbvision: set field and colorspace.
  usbvision: fix locking error
  usbvision: fix DMA from stack warnings.
  usbvision: fix standards for S-Video/Composite inputs.
  usbvision: move init code to probe()

Philipp Zabel (1):
  [media] coda: make NV12 format default

 drivers/media/platform/coda/coda-common.c     |  28 +--
 drivers/media/usb/usbvision/usbvision-core.c  |  71 ++------
 drivers/media/usb/usbvision/usbvision-i2c.c   |   2 +-
 drivers/media/usb/usbvision/usbvision-video.c | 246 +++++++++-----------------
 drivers/media/usb/usbvision/usbvision.h       |  10 +-
 5 files changed, 116 insertions(+), 241 deletions(-)

-- 
2.1.4

