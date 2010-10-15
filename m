Return-path: <mchehab@pedra>
Received: from chybek.jannau.net ([83.169.20.219]:44239 "EHLO
	chybek.jannau.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab0JONor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 09:44:47 -0400
Date: Fri, 15 Oct 2010 15:36:07 +0200
From: Janne Grunau <j@jannau.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: [PULL] hdpvr changes for 2.6.37
Message-ID: <20101015133607.GA7891@aniel.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

please pull 

git://git.jannau.net/linux hdpvr-v2.6.37

for following hdpvr changes.

thanks,
Janne

Alan Young (4):
      V4L/DVB: hdpvr: remove unnecessary sleep in hdpvr_config_call
      V4L/DVB: hdpvr: remove unecessary sleep in buffer drain loop
      V4L/DVB: hdpvr: print firmware date
      V4L/DVB: hdpvr: decrease URB timeout to 90ms

James M McLaren (1):
      V4L/DVB: hdpvr: Add missing URB_NO_TRANSFER_DMA_MAP flag

Janne Grunau (4):
      V4L/DVB: hdpvr: add two known to work firmware versions
      V4L/DVB: hdpvr: use AC3 as default audio codec for SPDIF
      V4L/DVB: hdpvr: fix audio input setting for pre AC3 firmwares
      V4L/DVB: hdpvr: add usb product id 0x4903

 drivers/media/video/hdpvr/hdpvr-control.c |    5 +---
 drivers/media/video/hdpvr/hdpvr-core.c    |   36 +++++++++++++++++++---------
 drivers/media/video/hdpvr/hdpvr-video.c   |    5 +--
 drivers/media/video/hdpvr/hdpvr.h         |    7 ++++-
 4 files changed, 32 insertions(+), 21 deletions(-)
