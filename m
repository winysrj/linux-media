Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab2HONsZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:25 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FDmP1b019191
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 09:48:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/12] [media] rename most media/video pci drivers to media/pci
Date: Wed, 15 Aug 2012 10:48:12 -0300
Message-Id: <1345038500-28734-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345038500-28734-1-git-send-email-mchehab@redhat.com>
References: <502AC079.50902@gmail.com>
 <1345038500-28734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename all PCI drivers with their own directory under
drivers/media/video into drivers/media/pci and update the
building system.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/Kconfig                          | 50 ++++++++++------------
 drivers/media/pci/Makefile                         | 11 ++++-
 drivers/media/{video => pci}/cx18/Kconfig          |  0
 drivers/media/{video => pci}/cx18/Makefile         |  0
 drivers/media/{video => pci}/cx18/cx18-alsa-main.c |  0
 .../media/{video => pci}/cx18/cx18-alsa-mixer.c    |  0
 .../media/{video => pci}/cx18/cx18-alsa-mixer.h    |  0
 drivers/media/{video => pci}/cx18/cx18-alsa-pcm.c  |  0
 drivers/media/{video => pci}/cx18/cx18-alsa-pcm.h  |  0
 drivers/media/{video => pci}/cx18/cx18-alsa.h      |  0
 drivers/media/{video => pci}/cx18/cx18-audio.c     |  0
 drivers/media/{video => pci}/cx18/cx18-audio.h     |  0
 drivers/media/{video => pci}/cx18/cx18-av-audio.c  |  0
 drivers/media/{video => pci}/cx18/cx18-av-core.c   |  0
 drivers/media/{video => pci}/cx18/cx18-av-core.h   |  0
 .../media/{video => pci}/cx18/cx18-av-firmware.c   |  0
 drivers/media/{video => pci}/cx18/cx18-av-vbi.c    |  0
 drivers/media/{video => pci}/cx18/cx18-cards.c     |  0
 drivers/media/{video => pci}/cx18/cx18-cards.h     |  0
 drivers/media/{video => pci}/cx18/cx18-controls.c  |  0
 drivers/media/{video => pci}/cx18/cx18-controls.h  |  0
 drivers/media/{video => pci}/cx18/cx18-driver.c    |  0
 drivers/media/{video => pci}/cx18/cx18-driver.h    |  0
 drivers/media/{video => pci}/cx18/cx18-dvb.c       |  0
 drivers/media/{video => pci}/cx18/cx18-dvb.h       |  0
 drivers/media/{video => pci}/cx18/cx18-fileops.c   |  0
 drivers/media/{video => pci}/cx18/cx18-fileops.h   |  0
 drivers/media/{video => pci}/cx18/cx18-firmware.c  |  0
 drivers/media/{video => pci}/cx18/cx18-firmware.h  |  0
 drivers/media/{video => pci}/cx18/cx18-gpio.c      |  0
 drivers/media/{video => pci}/cx18/cx18-gpio.h      |  0
 drivers/media/{video => pci}/cx18/cx18-i2c.c       |  0
 drivers/media/{video => pci}/cx18/cx18-i2c.h       |  0
 drivers/media/{video => pci}/cx18/cx18-io.c        |  0
 drivers/media/{video => pci}/cx18/cx18-io.h        |  0
 drivers/media/{video => pci}/cx18/cx18-ioctl.c     |  0
 drivers/media/{video => pci}/cx18/cx18-ioctl.h     |  0
 drivers/media/{video => pci}/cx18/cx18-irq.c       |  0
 drivers/media/{video => pci}/cx18/cx18-irq.h       |  0
 drivers/media/{video => pci}/cx18/cx18-mailbox.c   |  0
 drivers/media/{video => pci}/cx18/cx18-mailbox.h   |  0
 drivers/media/{video => pci}/cx18/cx18-queue.c     |  0
 drivers/media/{video => pci}/cx18/cx18-queue.h     |  0
 drivers/media/{video => pci}/cx18/cx18-scb.c       |  0
 drivers/media/{video => pci}/cx18/cx18-scb.h       |  0
 drivers/media/{video => pci}/cx18/cx18-streams.c   |  0
 drivers/media/{video => pci}/cx18/cx18-streams.h   |  0
 drivers/media/{video => pci}/cx18/cx18-vbi.c       |  0
 drivers/media/{video => pci}/cx18/cx18-vbi.h       |  0
 drivers/media/{video => pci}/cx18/cx18-version.h   |  0
 drivers/media/{video => pci}/cx18/cx18-video.c     |  0
 drivers/media/{video => pci}/cx18/cx18-video.h     |  0
 drivers/media/{video => pci}/cx18/cx23418.h        |  0
 drivers/media/{video => pci}/cx23885/Kconfig       |  0
 drivers/media/{video => pci}/cx23885/Makefile      |  0
 drivers/media/{video => pci}/cx23885/altera-ci.c   |  0
 drivers/media/{video => pci}/cx23885/altera-ci.h   |  0
 drivers/media/{video => pci}/cx23885/cimax2.c      |  0
 drivers/media/{video => pci}/cx23885/cimax2.h      |  0
 drivers/media/{video => pci}/cx23885/cx23885-417.c |  0
 .../media/{video => pci}/cx23885/cx23885-alsa.c    |  0
 drivers/media/{video => pci}/cx23885/cx23885-av.c  |  0
 drivers/media/{video => pci}/cx23885/cx23885-av.h  |  0
 .../media/{video => pci}/cx23885/cx23885-cards.c   |  0
 .../media/{video => pci}/cx23885/cx23885-core.c    |  0
 drivers/media/{video => pci}/cx23885/cx23885-dvb.c |  0
 .../media/{video => pci}/cx23885/cx23885-f300.c    |  0
 .../media/{video => pci}/cx23885/cx23885-f300.h    |  0
 drivers/media/{video => pci}/cx23885/cx23885-i2c.c |  0
 .../media/{video => pci}/cx23885/cx23885-input.c   |  0
 .../media/{video => pci}/cx23885/cx23885-input.h   |  0
 .../media/{video => pci}/cx23885/cx23885-ioctl.c   |  0
 .../media/{video => pci}/cx23885/cx23885-ioctl.h   |  0
 drivers/media/{video => pci}/cx23885/cx23885-ir.c  |  0
 drivers/media/{video => pci}/cx23885/cx23885-ir.h  |  0
 drivers/media/{video => pci}/cx23885/cx23885-reg.h |  0
 drivers/media/{video => pci}/cx23885/cx23885-vbi.c |  0
 .../media/{video => pci}/cx23885/cx23885-video.c   |  0
 drivers/media/{video => pci}/cx23885/cx23885.h     |  0
 drivers/media/{video => pci}/cx23885/cx23888-ir.c  |  0
 drivers/media/{video => pci}/cx23885/cx23888-ir.h  |  0
 .../media/{video => pci}/cx23885/netup-eeprom.c    |  0
 .../media/{video => pci}/cx23885/netup-eeprom.h    |  0
 drivers/media/{video => pci}/cx23885/netup-init.c  |  0
 drivers/media/{video => pci}/cx23885/netup-init.h  |  0
 drivers/media/{video => pci}/cx25821/Kconfig       |  0
 drivers/media/{video => pci}/cx25821/Makefile      |  0
 .../media/{video => pci}/cx25821/cx25821-alsa.c    |  0
 .../cx25821/cx25821-audio-upstream.c               |  0
 .../cx25821/cx25821-audio-upstream.h               |  0
 .../media/{video => pci}/cx25821/cx25821-audio.h   |  0
 .../{video => pci}/cx25821/cx25821-biffuncs.h      |  0
 .../media/{video => pci}/cx25821/cx25821-cards.c   |  0
 .../media/{video => pci}/cx25821/cx25821-core.c    |  0
 .../media/{video => pci}/cx25821/cx25821-gpio.c    |  0
 drivers/media/{video => pci}/cx25821/cx25821-i2c.c |  0
 .../cx25821/cx25821-medusa-defines.h               |  0
 .../{video => pci}/cx25821/cx25821-medusa-reg.h    |  0
 .../{video => pci}/cx25821/cx25821-medusa-video.c  |  0
 .../{video => pci}/cx25821/cx25821-medusa-video.h  |  0
 drivers/media/{video => pci}/cx25821/cx25821-reg.h |  0
 .../media/{video => pci}/cx25821/cx25821-sram.h    |  0
 .../cx25821/cx25821-video-upstream-ch2.c           |  0
 .../cx25821/cx25821-video-upstream-ch2.h           |  0
 .../cx25821/cx25821-video-upstream.c               |  0
 .../cx25821/cx25821-video-upstream.h               |  0
 .../media/{video => pci}/cx25821/cx25821-video.c   |  0
 .../media/{video => pci}/cx25821/cx25821-video.h   |  0
 drivers/media/{video => pci}/cx25821/cx25821.h     |  0
 drivers/media/{video => pci}/cx88/Kconfig          |  0
 drivers/media/{video => pci}/cx88/Makefile         |  0
 drivers/media/{video => pci}/cx88/cx88-alsa.c      |  0
 drivers/media/{video => pci}/cx88/cx88-blackbird.c |  0
 drivers/media/{video => pci}/cx88/cx88-cards.c     |  0
 drivers/media/{video => pci}/cx88/cx88-core.c      |  0
 drivers/media/{video => pci}/cx88/cx88-dsp.c       |  0
 drivers/media/{video => pci}/cx88/cx88-dvb.c       |  0
 drivers/media/{video => pci}/cx88/cx88-i2c.c       |  0
 drivers/media/{video => pci}/cx88/cx88-input.c     |  0
 drivers/media/{video => pci}/cx88/cx88-mpeg.c      |  0
 drivers/media/{video => pci}/cx88/cx88-reg.h       |  0
 drivers/media/{video => pci}/cx88/cx88-tvaudio.c   |  0
 drivers/media/{video => pci}/cx88/cx88-vbi.c       |  0
 drivers/media/{video => pci}/cx88/cx88-video.c     |  0
 .../media/{video => pci}/cx88/cx88-vp3054-i2c.c    |  0
 .../media/{video => pci}/cx88/cx88-vp3054-i2c.h    |  0
 drivers/media/{video => pci}/cx88/cx88.h           |  0
 drivers/media/{video => pci}/ivtv/Kconfig          |  0
 drivers/media/{video => pci}/ivtv/Makefile         |  0
 drivers/media/{video => pci}/ivtv/ivtv-cards.c     |  0
 drivers/media/{video => pci}/ivtv/ivtv-cards.h     |  0
 drivers/media/{video => pci}/ivtv/ivtv-controls.c  |  0
 drivers/media/{video => pci}/ivtv/ivtv-controls.h  |  0
 drivers/media/{video => pci}/ivtv/ivtv-driver.c    |  0
 drivers/media/{video => pci}/ivtv/ivtv-driver.h    |  0
 drivers/media/{video => pci}/ivtv/ivtv-fileops.c   |  0
 drivers/media/{video => pci}/ivtv/ivtv-fileops.h   |  0
 drivers/media/{video => pci}/ivtv/ivtv-firmware.c  |  0
 drivers/media/{video => pci}/ivtv/ivtv-firmware.h  |  0
 drivers/media/{video => pci}/ivtv/ivtv-gpio.c      |  0
 drivers/media/{video => pci}/ivtv/ivtv-gpio.h      |  0
 drivers/media/{video => pci}/ivtv/ivtv-i2c.c       |  0
 drivers/media/{video => pci}/ivtv/ivtv-i2c.h       |  0
 drivers/media/{video => pci}/ivtv/ivtv-ioctl.c     |  0
 drivers/media/{video => pci}/ivtv/ivtv-ioctl.h     |  0
 drivers/media/{video => pci}/ivtv/ivtv-irq.c       |  0
 drivers/media/{video => pci}/ivtv/ivtv-irq.h       |  0
 drivers/media/{video => pci}/ivtv/ivtv-mailbox.c   |  0
 drivers/media/{video => pci}/ivtv/ivtv-mailbox.h   |  0
 drivers/media/{video => pci}/ivtv/ivtv-queue.c     |  0
 drivers/media/{video => pci}/ivtv/ivtv-queue.h     |  0
 drivers/media/{video => pci}/ivtv/ivtv-routing.c   |  0
 drivers/media/{video => pci}/ivtv/ivtv-routing.h   |  0
 drivers/media/{video => pci}/ivtv/ivtv-streams.c   |  0
 drivers/media/{video => pci}/ivtv/ivtv-streams.h   |  0
 drivers/media/{video => pci}/ivtv/ivtv-udma.c      |  0
 drivers/media/{video => pci}/ivtv/ivtv-udma.h      |  0
 drivers/media/{video => pci}/ivtv/ivtv-vbi.c       |  0
 drivers/media/{video => pci}/ivtv/ivtv-vbi.h       |  0
 drivers/media/{video => pci}/ivtv/ivtv-version.h   |  0
 drivers/media/{video => pci}/ivtv/ivtv-yuv.c       |  0
 drivers/media/{video => pci}/ivtv/ivtv-yuv.h       |  0
 drivers/media/{video => pci}/ivtv/ivtvfb.c         |  0
 drivers/media/{video => pci}/saa7134/Kconfig       |  0
 drivers/media/{video => pci}/saa7134/Makefile      |  0
 drivers/media/{video => pci}/saa7134/saa6752hs.c   |  0
 .../media/{video => pci}/saa7134/saa7134-alsa.c    |  0
 .../media/{video => pci}/saa7134/saa7134-cards.c   |  0
 .../media/{video => pci}/saa7134/saa7134-core.c    |  0
 drivers/media/{video => pci}/saa7134/saa7134-dvb.c |  0
 .../media/{video => pci}/saa7134/saa7134-empress.c |  0
 drivers/media/{video => pci}/saa7134/saa7134-i2c.c |  0
 .../media/{video => pci}/saa7134/saa7134-input.c   |  0
 drivers/media/{video => pci}/saa7134/saa7134-reg.h |  0
 drivers/media/{video => pci}/saa7134/saa7134-ts.c  |  0
 .../media/{video => pci}/saa7134/saa7134-tvaudio.c |  0
 drivers/media/{video => pci}/saa7134/saa7134-vbi.c |  0
 .../media/{video => pci}/saa7134/saa7134-video.c   |  0
 drivers/media/{video => pci}/saa7134/saa7134.h     |  0
 drivers/media/{video => pci}/saa7164/Kconfig       |  0
 drivers/media/{video => pci}/saa7164/Makefile      |  0
 drivers/media/{video => pci}/saa7164/saa7164-api.c |  0
 .../media/{video => pci}/saa7164/saa7164-buffer.c  |  0
 drivers/media/{video => pci}/saa7164/saa7164-bus.c |  0
 .../media/{video => pci}/saa7164/saa7164-cards.c   |  0
 drivers/media/{video => pci}/saa7164/saa7164-cmd.c |  0
 .../media/{video => pci}/saa7164/saa7164-core.c    |  0
 drivers/media/{video => pci}/saa7164/saa7164-dvb.c |  0
 .../media/{video => pci}/saa7164/saa7164-encoder.c |  0
 drivers/media/{video => pci}/saa7164/saa7164-fw.c  |  0
 drivers/media/{video => pci}/saa7164/saa7164-i2c.c |  0
 drivers/media/{video => pci}/saa7164/saa7164-reg.h |  0
 .../media/{video => pci}/saa7164/saa7164-types.h   |  0
 drivers/media/{video => pci}/saa7164/saa7164-vbi.c |  0
 drivers/media/{video => pci}/saa7164/saa7164.h     |  0
 drivers/media/{video => pci}/zoran/Kconfig         |  0
 drivers/media/{video => pci}/zoran/Makefile        |  0
 drivers/media/{video => pci}/zoran/videocodec.c    |  0
 drivers/media/{video => pci}/zoran/videocodec.h    |  0
 drivers/media/{video => pci}/zoran/zoran.h         |  0
 drivers/media/{video => pci}/zoran/zoran_card.c    |  0
 drivers/media/{video => pci}/zoran/zoran_card.h    |  0
 drivers/media/{video => pci}/zoran/zoran_device.c  |  0
 drivers/media/{video => pci}/zoran/zoran_device.h  |  0
 drivers/media/{video => pci}/zoran/zoran_driver.c  |  0
 drivers/media/{video => pci}/zoran/zoran_procfs.c  |  0
 drivers/media/{video => pci}/zoran/zoran_procfs.h  |  0
 drivers/media/{video => pci}/zoran/zr36016.c       |  0
 drivers/media/{video => pci}/zoran/zr36016.h       |  0
 drivers/media/{video => pci}/zoran/zr36050.c       |  0
 drivers/media/{video => pci}/zoran/zr36050.h       |  0
 drivers/media/{video => pci}/zoran/zr36057.h       |  0
 drivers/media/{video => pci}/zoran/zr36060.c       |  0
 drivers/media/{video => pci}/zoran/zr36060.h       |  0
 drivers/media/video/Kconfig                        | 15 -------
 drivers/media/video/Makefile                       | 10 -----
 216 files changed, 33 insertions(+), 53 deletions(-)
 rename drivers/media/{video => pci}/cx18/Kconfig (100%)
 rename drivers/media/{video => pci}/cx18/Makefile (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa-main.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa-mixer.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa-mixer.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa-pcm.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa-pcm.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-audio.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-audio.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-av-audio.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-av-core.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-av-core.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-av-firmware.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-av-vbi.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-cards.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-cards.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-controls.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-controls.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-driver.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-driver.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-dvb.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-dvb.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-fileops.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-fileops.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-firmware.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-firmware.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-gpio.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-gpio.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-i2c.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-i2c.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-io.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-io.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-ioctl.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-ioctl.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-irq.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-irq.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-mailbox.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-mailbox.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-queue.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-queue.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-scb.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-scb.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-streams.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-streams.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-vbi.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-vbi.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-version.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-video.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-video.h (100%)
 rename drivers/media/{video => pci}/cx18/cx23418.h (100%)
 rename drivers/media/{video => pci}/cx23885/Kconfig (100%)
 rename drivers/media/{video => pci}/cx23885/Makefile (100%)
 rename drivers/media/{video => pci}/cx23885/altera-ci.c (100%)
 rename drivers/media/{video => pci}/cx23885/altera-ci.h (100%)
 rename drivers/media/{video => pci}/cx23885/cimax2.c (100%)
 rename drivers/media/{video => pci}/cx23885/cimax2.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-417.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-alsa.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-av.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-av.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-cards.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-core.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-dvb.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-f300.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-f300.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-i2c.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-input.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-input.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-ioctl.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-ioctl.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-ir.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-ir.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-reg.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-vbi.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-video.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23888-ir.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23888-ir.h (100%)
 rename drivers/media/{video => pci}/cx23885/netup-eeprom.c (100%)
 rename drivers/media/{video => pci}/cx23885/netup-eeprom.h (100%)
 rename drivers/media/{video => pci}/cx23885/netup-init.c (100%)
 rename drivers/media/{video => pci}/cx23885/netup-init.h (100%)
 rename drivers/media/{video => pci}/cx25821/Kconfig (100%)
 rename drivers/media/{video => pci}/cx25821/Makefile (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-alsa.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-audio-upstream.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-audio-upstream.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-audio.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-biffuncs.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-cards.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-core.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-gpio.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-i2c.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-medusa-defines.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-medusa-reg.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-medusa-video.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-medusa-video.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-reg.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-sram.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video-upstream-ch2.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video-upstream-ch2.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video-upstream.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video-upstream.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821.h (100%)
 rename drivers/media/{video => pci}/cx88/Kconfig (100%)
 rename drivers/media/{video => pci}/cx88/Makefile (100%)
 rename drivers/media/{video => pci}/cx88/cx88-alsa.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-blackbird.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-cards.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-core.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-dsp.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-dvb.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-i2c.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-input.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-mpeg.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-reg.h (100%)
 rename drivers/media/{video => pci}/cx88/cx88-tvaudio.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-vbi.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-video.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-vp3054-i2c.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-vp3054-i2c.h (100%)
 rename drivers/media/{video => pci}/cx88/cx88.h (100%)
 rename drivers/media/{video => pci}/ivtv/Kconfig (100%)
 rename drivers/media/{video => pci}/ivtv/Makefile (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-cards.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-cards.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-controls.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-controls.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-driver.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-driver.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-fileops.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-fileops.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-firmware.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-firmware.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-gpio.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-gpio.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-i2c.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-i2c.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-ioctl.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-ioctl.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-irq.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-irq.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-mailbox.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-mailbox.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-queue.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-queue.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-routing.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-routing.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-streams.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-streams.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-udma.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-udma.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-vbi.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-vbi.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-version.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-yuv.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-yuv.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtvfb.c (100%)
 rename drivers/media/{video => pci}/saa7134/Kconfig (100%)
 rename drivers/media/{video => pci}/saa7134/Makefile (100%)
 rename drivers/media/{video => pci}/saa7134/saa6752hs.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-alsa.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-cards.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-core.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-dvb.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-empress.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-i2c.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-input.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-reg.h (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-ts.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-tvaudio.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-vbi.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-video.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134.h (100%)
 rename drivers/media/{video => pci}/saa7164/Kconfig (100%)
 rename drivers/media/{video => pci}/saa7164/Makefile (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-api.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-buffer.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-bus.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-cards.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-cmd.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-core.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-dvb.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-encoder.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-fw.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-i2c.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-reg.h (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-types.h (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-vbi.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164.h (100%)
 rename drivers/media/{video => pci}/zoran/Kconfig (100%)
 rename drivers/media/{video => pci}/zoran/Makefile (100%)
 rename drivers/media/{video => pci}/zoran/videocodec.c (100%)
 rename drivers/media/{video => pci}/zoran/videocodec.h (100%)
 rename drivers/media/{video => pci}/zoran/zoran.h (100%)
 rename drivers/media/{video => pci}/zoran/zoran_card.c (100%)
 rename drivers/media/{video => pci}/zoran/zoran_card.h (100%)
 rename drivers/media/{video => pci}/zoran/zoran_device.c (100%)
 rename drivers/media/{video => pci}/zoran/zoran_device.h (100%)
 rename drivers/media/{video => pci}/zoran/zoran_driver.c (100%)
 rename drivers/media/{video => pci}/zoran/zoran_procfs.c (100%)
 rename drivers/media/{video => pci}/zoran/zoran_procfs.h (100%)
 rename drivers/media/{video => pci}/zoran/zr36016.c (100%)
 rename drivers/media/{video => pci}/zoran/zr36016.h (100%)
 rename drivers/media/{video => pci}/zoran/zr36050.c (100%)
 rename drivers/media/{video => pci}/zoran/zr36050.h (100%)
 rename drivers/media/{video => pci}/zoran/zr36057.h (100%)
 rename drivers/media/{video => pci}/zoran/zr36060.c (100%)
 rename drivers/media/{video => pci}/zoran/zr36060.h (100%)

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index b16529b..b69cb12 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -2,40 +2,36 @@
 # DVB device configuration
 #
 
-menuconfig DVB_CAPTURE_DRIVERS
-	bool "DVB/ATSC PCI adapters"
-	depends on DVB_CORE
-	default y
-	---help---
-	  Say Y to select Digital TV adapters
-
-if DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C
+menu "Media PCI Adapters"
+	visible if PCI && MEDIA_SUPPORT
+
+if MEDIA_ANALOG_TV_SUPPORT
+	comment "Media capture/analog TV support"
+source "drivers/media/pci/ivtv/Kconfig"
+source "drivers/media/pci/zoran/Kconfig"
+endif
+
+if MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
+	comment "Media capture/analog/hybrid TV support"
+source "drivers/media/pci/cx18/Kconfig"
+source "drivers/media/pci/cx23885/Kconfig"
+source "drivers/media/pci/cx25821/Kconfig"
+source "drivers/media/pci/cx88/Kconfig"
+source "drivers/media/pci/bt8xx/Kconfig"
+source "drivers/media/pci/saa7134/Kconfig"
+source "drivers/media/pci/saa7164/Kconfig"
+endif
 
-comment "Supported SAA7146 based PCI Adapters"
+if MEDIA_DIGITAL_TV_SUPPORT
+	comment "Media digital TV PCI Adapters"
 source "drivers/media/pci/ttpci/Kconfig"
-
-comment "Supported FlexCopII (B2C2) PCI Adapters"
 source "drivers/media/pci/b2c2/Kconfig"
-
-comment "Supported BT878 Adapters"
-source "drivers/media/pci/bt8xx/Kconfig"
-
-comment "Supported Pluto2 Adapters"
 source "drivers/media/pci/pluto2/Kconfig"
-
-comment "Supported SDMC DM1105 Adapters"
 source "drivers/media/pci/dm1105/Kconfig"
-
-comment "Supported Earthsoft PT1 Adapters"
 source "drivers/media/pci/pt1/Kconfig"
-
-comment "Supported Mantis Adapters"
 source "drivers/media/pci/mantis/Kconfig"
-
-comment "Supported nGene Adapters"
 source "drivers/media/pci/ngene/Kconfig"
-
-comment "Supported ddbridge ('Octopus') Adapters"
 source "drivers/media/pci/ddbridge/Kconfig"
+endif
 
-endif # DVB_CAPTURE_DRIVERS
+endmenu
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 1d44fbd..d47c222 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -4,7 +4,6 @@
 
 obj-y        :=	ttpci/		\
 		b2c2/		\
-		bt8xx/		\
 		pluto2/		\
 		dm1105/		\
 		pt1/		\
@@ -12,3 +11,13 @@ obj-y        :=	ttpci/		\
 		ngene/		\
 		ddbridge/	\
 		b2c2/
+
+obj-$(CONFIG_VIDEO_IVTV) += ivtv/
+obj-$(CONFIG_VIDEO_ZORAN) += zoran/
+obj-$(CONFIG_VIDEO_CX18) += cx18/
+obj-$(CONFIG_VIDEO_CX23885) += cx23885/
+obj-$(CONFIG_VIDEO_CX25821) += cx25821/
+obj-$(CONFIG_VIDEO_CX88) += cx88/
+obj-$(CONFIG_VIDEO_BT848) += bt8xx/
+obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
+obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
diff --git a/drivers/media/video/cx18/Kconfig b/drivers/media/pci/cx18/Kconfig
similarity index 100%
rename from drivers/media/video/cx18/Kconfig
rename to drivers/media/pci/cx18/Kconfig
diff --git a/drivers/media/video/cx18/Makefile b/drivers/media/pci/cx18/Makefile
similarity index 100%
rename from drivers/media/video/cx18/Makefile
rename to drivers/media/pci/cx18/Makefile
diff --git a/drivers/media/video/cx18/cx18-alsa-main.c b/drivers/media/pci/cx18/cx18-alsa-main.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-alsa-main.c
rename to drivers/media/pci/cx18/cx18-alsa-main.c
diff --git a/drivers/media/video/cx18/cx18-alsa-mixer.c b/drivers/media/pci/cx18/cx18-alsa-mixer.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-alsa-mixer.c
rename to drivers/media/pci/cx18/cx18-alsa-mixer.c
diff --git a/drivers/media/video/cx18/cx18-alsa-mixer.h b/drivers/media/pci/cx18/cx18-alsa-mixer.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-alsa-mixer.h
rename to drivers/media/pci/cx18/cx18-alsa-mixer.h
diff --git a/drivers/media/video/cx18/cx18-alsa-pcm.c b/drivers/media/pci/cx18/cx18-alsa-pcm.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-alsa-pcm.c
rename to drivers/media/pci/cx18/cx18-alsa-pcm.c
diff --git a/drivers/media/video/cx18/cx18-alsa-pcm.h b/drivers/media/pci/cx18/cx18-alsa-pcm.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-alsa-pcm.h
rename to drivers/media/pci/cx18/cx18-alsa-pcm.h
diff --git a/drivers/media/video/cx18/cx18-alsa.h b/drivers/media/pci/cx18/cx18-alsa.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-alsa.h
rename to drivers/media/pci/cx18/cx18-alsa.h
diff --git a/drivers/media/video/cx18/cx18-audio.c b/drivers/media/pci/cx18/cx18-audio.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-audio.c
rename to drivers/media/pci/cx18/cx18-audio.c
diff --git a/drivers/media/video/cx18/cx18-audio.h b/drivers/media/pci/cx18/cx18-audio.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-audio.h
rename to drivers/media/pci/cx18/cx18-audio.h
diff --git a/drivers/media/video/cx18/cx18-av-audio.c b/drivers/media/pci/cx18/cx18-av-audio.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-av-audio.c
rename to drivers/media/pci/cx18/cx18-av-audio.c
diff --git a/drivers/media/video/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-av-core.c
rename to drivers/media/pci/cx18/cx18-av-core.c
diff --git a/drivers/media/video/cx18/cx18-av-core.h b/drivers/media/pci/cx18/cx18-av-core.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-av-core.h
rename to drivers/media/pci/cx18/cx18-av-core.h
diff --git a/drivers/media/video/cx18/cx18-av-firmware.c b/drivers/media/pci/cx18/cx18-av-firmware.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-av-firmware.c
rename to drivers/media/pci/cx18/cx18-av-firmware.c
diff --git a/drivers/media/video/cx18/cx18-av-vbi.c b/drivers/media/pci/cx18/cx18-av-vbi.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-av-vbi.c
rename to drivers/media/pci/cx18/cx18-av-vbi.c
diff --git a/drivers/media/video/cx18/cx18-cards.c b/drivers/media/pci/cx18/cx18-cards.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-cards.c
rename to drivers/media/pci/cx18/cx18-cards.c
diff --git a/drivers/media/video/cx18/cx18-cards.h b/drivers/media/pci/cx18/cx18-cards.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-cards.h
rename to drivers/media/pci/cx18/cx18-cards.h
diff --git a/drivers/media/video/cx18/cx18-controls.c b/drivers/media/pci/cx18/cx18-controls.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-controls.c
rename to drivers/media/pci/cx18/cx18-controls.c
diff --git a/drivers/media/video/cx18/cx18-controls.h b/drivers/media/pci/cx18/cx18-controls.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-controls.h
rename to drivers/media/pci/cx18/cx18-controls.h
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-driver.c
rename to drivers/media/pci/cx18/cx18-driver.c
diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/pci/cx18/cx18-driver.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-driver.h
rename to drivers/media/pci/cx18/cx18-driver.h
diff --git a/drivers/media/video/cx18/cx18-dvb.c b/drivers/media/pci/cx18/cx18-dvb.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-dvb.c
rename to drivers/media/pci/cx18/cx18-dvb.c
diff --git a/drivers/media/video/cx18/cx18-dvb.h b/drivers/media/pci/cx18/cx18-dvb.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-dvb.h
rename to drivers/media/pci/cx18/cx18-dvb.h
diff --git a/drivers/media/video/cx18/cx18-fileops.c b/drivers/media/pci/cx18/cx18-fileops.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-fileops.c
rename to drivers/media/pci/cx18/cx18-fileops.c
diff --git a/drivers/media/video/cx18/cx18-fileops.h b/drivers/media/pci/cx18/cx18-fileops.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-fileops.h
rename to drivers/media/pci/cx18/cx18-fileops.h
diff --git a/drivers/media/video/cx18/cx18-firmware.c b/drivers/media/pci/cx18/cx18-firmware.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-firmware.c
rename to drivers/media/pci/cx18/cx18-firmware.c
diff --git a/drivers/media/video/cx18/cx18-firmware.h b/drivers/media/pci/cx18/cx18-firmware.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-firmware.h
rename to drivers/media/pci/cx18/cx18-firmware.h
diff --git a/drivers/media/video/cx18/cx18-gpio.c b/drivers/media/pci/cx18/cx18-gpio.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-gpio.c
rename to drivers/media/pci/cx18/cx18-gpio.c
diff --git a/drivers/media/video/cx18/cx18-gpio.h b/drivers/media/pci/cx18/cx18-gpio.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-gpio.h
rename to drivers/media/pci/cx18/cx18-gpio.h
diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-i2c.c
rename to drivers/media/pci/cx18/cx18-i2c.c
diff --git a/drivers/media/video/cx18/cx18-i2c.h b/drivers/media/pci/cx18/cx18-i2c.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-i2c.h
rename to drivers/media/pci/cx18/cx18-i2c.h
diff --git a/drivers/media/video/cx18/cx18-io.c b/drivers/media/pci/cx18/cx18-io.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-io.c
rename to drivers/media/pci/cx18/cx18-io.c
diff --git a/drivers/media/video/cx18/cx18-io.h b/drivers/media/pci/cx18/cx18-io.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-io.h
rename to drivers/media/pci/cx18/cx18-io.h
diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-ioctl.c
rename to drivers/media/pci/cx18/cx18-ioctl.c
diff --git a/drivers/media/video/cx18/cx18-ioctl.h b/drivers/media/pci/cx18/cx18-ioctl.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-ioctl.h
rename to drivers/media/pci/cx18/cx18-ioctl.h
diff --git a/drivers/media/video/cx18/cx18-irq.c b/drivers/media/pci/cx18/cx18-irq.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-irq.c
rename to drivers/media/pci/cx18/cx18-irq.c
diff --git a/drivers/media/video/cx18/cx18-irq.h b/drivers/media/pci/cx18/cx18-irq.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-irq.h
rename to drivers/media/pci/cx18/cx18-irq.h
diff --git a/drivers/media/video/cx18/cx18-mailbox.c b/drivers/media/pci/cx18/cx18-mailbox.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-mailbox.c
rename to drivers/media/pci/cx18/cx18-mailbox.c
diff --git a/drivers/media/video/cx18/cx18-mailbox.h b/drivers/media/pci/cx18/cx18-mailbox.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-mailbox.h
rename to drivers/media/pci/cx18/cx18-mailbox.h
diff --git a/drivers/media/video/cx18/cx18-queue.c b/drivers/media/pci/cx18/cx18-queue.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-queue.c
rename to drivers/media/pci/cx18/cx18-queue.c
diff --git a/drivers/media/video/cx18/cx18-queue.h b/drivers/media/pci/cx18/cx18-queue.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-queue.h
rename to drivers/media/pci/cx18/cx18-queue.h
diff --git a/drivers/media/video/cx18/cx18-scb.c b/drivers/media/pci/cx18/cx18-scb.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-scb.c
rename to drivers/media/pci/cx18/cx18-scb.c
diff --git a/drivers/media/video/cx18/cx18-scb.h b/drivers/media/pci/cx18/cx18-scb.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-scb.h
rename to drivers/media/pci/cx18/cx18-scb.h
diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-streams.c
rename to drivers/media/pci/cx18/cx18-streams.c
diff --git a/drivers/media/video/cx18/cx18-streams.h b/drivers/media/pci/cx18/cx18-streams.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-streams.h
rename to drivers/media/pci/cx18/cx18-streams.h
diff --git a/drivers/media/video/cx18/cx18-vbi.c b/drivers/media/pci/cx18/cx18-vbi.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-vbi.c
rename to drivers/media/pci/cx18/cx18-vbi.c
diff --git a/drivers/media/video/cx18/cx18-vbi.h b/drivers/media/pci/cx18/cx18-vbi.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-vbi.h
rename to drivers/media/pci/cx18/cx18-vbi.h
diff --git a/drivers/media/video/cx18/cx18-version.h b/drivers/media/pci/cx18/cx18-version.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-version.h
rename to drivers/media/pci/cx18/cx18-version.h
diff --git a/drivers/media/video/cx18/cx18-video.c b/drivers/media/pci/cx18/cx18-video.c
similarity index 100%
rename from drivers/media/video/cx18/cx18-video.c
rename to drivers/media/pci/cx18/cx18-video.c
diff --git a/drivers/media/video/cx18/cx18-video.h b/drivers/media/pci/cx18/cx18-video.h
similarity index 100%
rename from drivers/media/video/cx18/cx18-video.h
rename to drivers/media/pci/cx18/cx18-video.h
diff --git a/drivers/media/video/cx18/cx23418.h b/drivers/media/pci/cx18/cx23418.h
similarity index 100%
rename from drivers/media/video/cx18/cx23418.h
rename to drivers/media/pci/cx18/cx23418.h
diff --git a/drivers/media/video/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
similarity index 100%
rename from drivers/media/video/cx23885/Kconfig
rename to drivers/media/pci/cx23885/Kconfig
diff --git a/drivers/media/video/cx23885/Makefile b/drivers/media/pci/cx23885/Makefile
similarity index 100%
rename from drivers/media/video/cx23885/Makefile
rename to drivers/media/pci/cx23885/Makefile
diff --git a/drivers/media/video/cx23885/altera-ci.c b/drivers/media/pci/cx23885/altera-ci.c
similarity index 100%
rename from drivers/media/video/cx23885/altera-ci.c
rename to drivers/media/pci/cx23885/altera-ci.c
diff --git a/drivers/media/video/cx23885/altera-ci.h b/drivers/media/pci/cx23885/altera-ci.h
similarity index 100%
rename from drivers/media/video/cx23885/altera-ci.h
rename to drivers/media/pci/cx23885/altera-ci.h
diff --git a/drivers/media/video/cx23885/cimax2.c b/drivers/media/pci/cx23885/cimax2.c
similarity index 100%
rename from drivers/media/video/cx23885/cimax2.c
rename to drivers/media/pci/cx23885/cimax2.c
diff --git a/drivers/media/video/cx23885/cimax2.h b/drivers/media/pci/cx23885/cimax2.h
similarity index 100%
rename from drivers/media/video/cx23885/cimax2.h
rename to drivers/media/pci/cx23885/cimax2.h
diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-417.c
rename to drivers/media/pci/cx23885/cx23885-417.c
diff --git a/drivers/media/video/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-alsa.c
rename to drivers/media/pci/cx23885/cx23885-alsa.c
diff --git a/drivers/media/video/cx23885/cx23885-av.c b/drivers/media/pci/cx23885/cx23885-av.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-av.c
rename to drivers/media/pci/cx23885/cx23885-av.c
diff --git a/drivers/media/video/cx23885/cx23885-av.h b/drivers/media/pci/cx23885/cx23885-av.h
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-av.h
rename to drivers/media/pci/cx23885/cx23885-av.h
diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-cards.c
rename to drivers/media/pci/cx23885/cx23885-cards.c
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-core.c
rename to drivers/media/pci/cx23885/cx23885-core.c
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-dvb.c
rename to drivers/media/pci/cx23885/cx23885-dvb.c
diff --git a/drivers/media/video/cx23885/cx23885-f300.c b/drivers/media/pci/cx23885/cx23885-f300.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-f300.c
rename to drivers/media/pci/cx23885/cx23885-f300.c
diff --git a/drivers/media/video/cx23885/cx23885-f300.h b/drivers/media/pci/cx23885/cx23885-f300.h
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-f300.h
rename to drivers/media/pci/cx23885/cx23885-f300.h
diff --git a/drivers/media/video/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-i2c.c
rename to drivers/media/pci/cx23885/cx23885-i2c.c
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-input.c
rename to drivers/media/pci/cx23885/cx23885-input.c
diff --git a/drivers/media/video/cx23885/cx23885-input.h b/drivers/media/pci/cx23885/cx23885-input.h
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-input.h
rename to drivers/media/pci/cx23885/cx23885-input.h
diff --git a/drivers/media/video/cx23885/cx23885-ioctl.c b/drivers/media/pci/cx23885/cx23885-ioctl.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-ioctl.c
rename to drivers/media/pci/cx23885/cx23885-ioctl.c
diff --git a/drivers/media/video/cx23885/cx23885-ioctl.h b/drivers/media/pci/cx23885/cx23885-ioctl.h
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-ioctl.h
rename to drivers/media/pci/cx23885/cx23885-ioctl.h
diff --git a/drivers/media/video/cx23885/cx23885-ir.c b/drivers/media/pci/cx23885/cx23885-ir.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-ir.c
rename to drivers/media/pci/cx23885/cx23885-ir.c
diff --git a/drivers/media/video/cx23885/cx23885-ir.h b/drivers/media/pci/cx23885/cx23885-ir.h
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-ir.h
rename to drivers/media/pci/cx23885/cx23885-ir.h
diff --git a/drivers/media/video/cx23885/cx23885-reg.h b/drivers/media/pci/cx23885/cx23885-reg.h
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-reg.h
rename to drivers/media/pci/cx23885/cx23885-reg.h
diff --git a/drivers/media/video/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-vbi.c
rename to drivers/media/pci/cx23885/cx23885-vbi.c
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23885-video.c
rename to drivers/media/pci/cx23885/cx23885-video.c
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
similarity index 100%
rename from drivers/media/video/cx23885/cx23885.h
rename to drivers/media/pci/cx23885/cx23885.h
diff --git a/drivers/media/video/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
similarity index 100%
rename from drivers/media/video/cx23885/cx23888-ir.c
rename to drivers/media/pci/cx23885/cx23888-ir.c
diff --git a/drivers/media/video/cx23885/cx23888-ir.h b/drivers/media/pci/cx23885/cx23888-ir.h
similarity index 100%
rename from drivers/media/video/cx23885/cx23888-ir.h
rename to drivers/media/pci/cx23885/cx23888-ir.h
diff --git a/drivers/media/video/cx23885/netup-eeprom.c b/drivers/media/pci/cx23885/netup-eeprom.c
similarity index 100%
rename from drivers/media/video/cx23885/netup-eeprom.c
rename to drivers/media/pci/cx23885/netup-eeprom.c
diff --git a/drivers/media/video/cx23885/netup-eeprom.h b/drivers/media/pci/cx23885/netup-eeprom.h
similarity index 100%
rename from drivers/media/video/cx23885/netup-eeprom.h
rename to drivers/media/pci/cx23885/netup-eeprom.h
diff --git a/drivers/media/video/cx23885/netup-init.c b/drivers/media/pci/cx23885/netup-init.c
similarity index 100%
rename from drivers/media/video/cx23885/netup-init.c
rename to drivers/media/pci/cx23885/netup-init.c
diff --git a/drivers/media/video/cx23885/netup-init.h b/drivers/media/pci/cx23885/netup-init.h
similarity index 100%
rename from drivers/media/video/cx23885/netup-init.h
rename to drivers/media/pci/cx23885/netup-init.h
diff --git a/drivers/media/video/cx25821/Kconfig b/drivers/media/pci/cx25821/Kconfig
similarity index 100%
rename from drivers/media/video/cx25821/Kconfig
rename to drivers/media/pci/cx25821/Kconfig
diff --git a/drivers/media/video/cx25821/Makefile b/drivers/media/pci/cx25821/Makefile
similarity index 100%
rename from drivers/media/video/cx25821/Makefile
rename to drivers/media/pci/cx25821/Makefile
diff --git a/drivers/media/video/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-alsa.c
rename to drivers/media/pci/cx25821/cx25821-alsa.c
diff --git a/drivers/media/video/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-audio-upstream.c
rename to drivers/media/pci/cx25821/cx25821-audio-upstream.c
diff --git a/drivers/media/video/cx25821/cx25821-audio-upstream.h b/drivers/media/pci/cx25821/cx25821-audio-upstream.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-audio-upstream.h
rename to drivers/media/pci/cx25821/cx25821-audio-upstream.h
diff --git a/drivers/media/video/cx25821/cx25821-audio.h b/drivers/media/pci/cx25821/cx25821-audio.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-audio.h
rename to drivers/media/pci/cx25821/cx25821-audio.h
diff --git a/drivers/media/video/cx25821/cx25821-biffuncs.h b/drivers/media/pci/cx25821/cx25821-biffuncs.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-biffuncs.h
rename to drivers/media/pci/cx25821/cx25821-biffuncs.h
diff --git a/drivers/media/video/cx25821/cx25821-cards.c b/drivers/media/pci/cx25821/cx25821-cards.c
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-cards.c
rename to drivers/media/pci/cx25821/cx25821-cards.c
diff --git a/drivers/media/video/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-core.c
rename to drivers/media/pci/cx25821/cx25821-core.c
diff --git a/drivers/media/video/cx25821/cx25821-gpio.c b/drivers/media/pci/cx25821/cx25821-gpio.c
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-gpio.c
rename to drivers/media/pci/cx25821/cx25821-gpio.c
diff --git a/drivers/media/video/cx25821/cx25821-i2c.c b/drivers/media/pci/cx25821/cx25821-i2c.c
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-i2c.c
rename to drivers/media/pci/cx25821/cx25821-i2c.c
diff --git a/drivers/media/video/cx25821/cx25821-medusa-defines.h b/drivers/media/pci/cx25821/cx25821-medusa-defines.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-medusa-defines.h
rename to drivers/media/pci/cx25821/cx25821-medusa-defines.h
diff --git a/drivers/media/video/cx25821/cx25821-medusa-reg.h b/drivers/media/pci/cx25821/cx25821-medusa-reg.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-medusa-reg.h
rename to drivers/media/pci/cx25821/cx25821-medusa-reg.h
diff --git a/drivers/media/video/cx25821/cx25821-medusa-video.c b/drivers/media/pci/cx25821/cx25821-medusa-video.c
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-medusa-video.c
rename to drivers/media/pci/cx25821/cx25821-medusa-video.c
diff --git a/drivers/media/video/cx25821/cx25821-medusa-video.h b/drivers/media/pci/cx25821/cx25821-medusa-video.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-medusa-video.h
rename to drivers/media/pci/cx25821/cx25821-medusa-video.h
diff --git a/drivers/media/video/cx25821/cx25821-reg.h b/drivers/media/pci/cx25821/cx25821-reg.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-reg.h
rename to drivers/media/pci/cx25821/cx25821-reg.h
diff --git a/drivers/media/video/cx25821/cx25821-sram.h b/drivers/media/pci/cx25821/cx25821-sram.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-sram.h
rename to drivers/media/pci/cx25821/cx25821-sram.h
diff --git a/drivers/media/video/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-video-upstream-ch2.c
rename to drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
diff --git a/drivers/media/video/cx25821/cx25821-video-upstream-ch2.h b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-video-upstream-ch2.h
rename to drivers/media/pci/cx25821/cx25821-video-upstream-ch2.h
diff --git a/drivers/media/video/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-video-upstream.c
rename to drivers/media/pci/cx25821/cx25821-video-upstream.c
diff --git a/drivers/media/video/cx25821/cx25821-video-upstream.h b/drivers/media/pci/cx25821/cx25821-video-upstream.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-video-upstream.h
rename to drivers/media/pci/cx25821/cx25821-video-upstream.h
diff --git a/drivers/media/video/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-video.c
rename to drivers/media/pci/cx25821/cx25821-video.c
diff --git a/drivers/media/video/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821-video.h
rename to drivers/media/pci/cx25821/cx25821-video.h
diff --git a/drivers/media/video/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
similarity index 100%
rename from drivers/media/video/cx25821/cx25821.h
rename to drivers/media/pci/cx25821/cx25821.h
diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/pci/cx88/Kconfig
similarity index 100%
rename from drivers/media/video/cx88/Kconfig
rename to drivers/media/pci/cx88/Kconfig
diff --git a/drivers/media/video/cx88/Makefile b/drivers/media/pci/cx88/Makefile
similarity index 100%
rename from drivers/media/video/cx88/Makefile
rename to drivers/media/pci/cx88/Makefile
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-alsa.c
rename to drivers/media/pci/cx88/cx88-alsa.c
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-blackbird.c
rename to drivers/media/pci/cx88/cx88-blackbird.c
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-cards.c
rename to drivers/media/pci/cx88/cx88-cards.c
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-core.c
rename to drivers/media/pci/cx88/cx88-core.c
diff --git a/drivers/media/video/cx88/cx88-dsp.c b/drivers/media/pci/cx88/cx88-dsp.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-dsp.c
rename to drivers/media/pci/cx88/cx88-dsp.c
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-dvb.c
rename to drivers/media/pci/cx88/cx88-dvb.c
diff --git a/drivers/media/video/cx88/cx88-i2c.c b/drivers/media/pci/cx88/cx88-i2c.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-i2c.c
rename to drivers/media/pci/cx88/cx88-i2c.c
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-input.c
rename to drivers/media/pci/cx88/cx88-input.c
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-mpeg.c
rename to drivers/media/pci/cx88/cx88-mpeg.c
diff --git a/drivers/media/video/cx88/cx88-reg.h b/drivers/media/pci/cx88/cx88-reg.h
similarity index 100%
rename from drivers/media/video/cx88/cx88-reg.h
rename to drivers/media/pci/cx88/cx88-reg.h
diff --git a/drivers/media/video/cx88/cx88-tvaudio.c b/drivers/media/pci/cx88/cx88-tvaudio.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-tvaudio.c
rename to drivers/media/pci/cx88/cx88-tvaudio.c
diff --git a/drivers/media/video/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-vbi.c
rename to drivers/media/pci/cx88/cx88-vbi.c
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-video.c
rename to drivers/media/pci/cx88/cx88-video.c
diff --git a/drivers/media/video/cx88/cx88-vp3054-i2c.c b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
similarity index 100%
rename from drivers/media/video/cx88/cx88-vp3054-i2c.c
rename to drivers/media/pci/cx88/cx88-vp3054-i2c.c
diff --git a/drivers/media/video/cx88/cx88-vp3054-i2c.h b/drivers/media/pci/cx88/cx88-vp3054-i2c.h
similarity index 100%
rename from drivers/media/video/cx88/cx88-vp3054-i2c.h
rename to drivers/media/pci/cx88/cx88-vp3054-i2c.h
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
similarity index 100%
rename from drivers/media/video/cx88/cx88.h
rename to drivers/media/pci/cx88/cx88.h
diff --git a/drivers/media/video/ivtv/Kconfig b/drivers/media/pci/ivtv/Kconfig
similarity index 100%
rename from drivers/media/video/ivtv/Kconfig
rename to drivers/media/pci/ivtv/Kconfig
diff --git a/drivers/media/video/ivtv/Makefile b/drivers/media/pci/ivtv/Makefile
similarity index 100%
rename from drivers/media/video/ivtv/Makefile
rename to drivers/media/pci/ivtv/Makefile
diff --git a/drivers/media/video/ivtv/ivtv-cards.c b/drivers/media/pci/ivtv/ivtv-cards.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-cards.c
rename to drivers/media/pci/ivtv/ivtv-cards.c
diff --git a/drivers/media/video/ivtv/ivtv-cards.h b/drivers/media/pci/ivtv/ivtv-cards.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-cards.h
rename to drivers/media/pci/ivtv/ivtv-cards.h
diff --git a/drivers/media/video/ivtv/ivtv-controls.c b/drivers/media/pci/ivtv/ivtv-controls.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-controls.c
rename to drivers/media/pci/ivtv/ivtv-controls.c
diff --git a/drivers/media/video/ivtv/ivtv-controls.h b/drivers/media/pci/ivtv/ivtv-controls.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-controls.h
rename to drivers/media/pci/ivtv/ivtv-controls.h
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-driver.c
rename to drivers/media/pci/ivtv/ivtv-driver.c
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-driver.h
rename to drivers/media/pci/ivtv/ivtv-driver.h
diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/pci/ivtv/ivtv-fileops.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-fileops.c
rename to drivers/media/pci/ivtv/ivtv-fileops.c
diff --git a/drivers/media/video/ivtv/ivtv-fileops.h b/drivers/media/pci/ivtv/ivtv-fileops.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-fileops.h
rename to drivers/media/pci/ivtv/ivtv-fileops.h
diff --git a/drivers/media/video/ivtv/ivtv-firmware.c b/drivers/media/pci/ivtv/ivtv-firmware.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-firmware.c
rename to drivers/media/pci/ivtv/ivtv-firmware.c
diff --git a/drivers/media/video/ivtv/ivtv-firmware.h b/drivers/media/pci/ivtv/ivtv-firmware.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-firmware.h
rename to drivers/media/pci/ivtv/ivtv-firmware.h
diff --git a/drivers/media/video/ivtv/ivtv-gpio.c b/drivers/media/pci/ivtv/ivtv-gpio.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-gpio.c
rename to drivers/media/pci/ivtv/ivtv-gpio.c
diff --git a/drivers/media/video/ivtv/ivtv-gpio.h b/drivers/media/pci/ivtv/ivtv-gpio.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-gpio.h
rename to drivers/media/pci/ivtv/ivtv-gpio.h
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-i2c.c
rename to drivers/media/pci/ivtv/ivtv-i2c.c
diff --git a/drivers/media/video/ivtv/ivtv-i2c.h b/drivers/media/pci/ivtv/ivtv-i2c.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-i2c.h
rename to drivers/media/pci/ivtv/ivtv-i2c.h
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-ioctl.c
rename to drivers/media/pci/ivtv/ivtv-ioctl.c
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.h b/drivers/media/pci/ivtv/ivtv-ioctl.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-ioctl.h
rename to drivers/media/pci/ivtv/ivtv-ioctl.h
diff --git a/drivers/media/video/ivtv/ivtv-irq.c b/drivers/media/pci/ivtv/ivtv-irq.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-irq.c
rename to drivers/media/pci/ivtv/ivtv-irq.c
diff --git a/drivers/media/video/ivtv/ivtv-irq.h b/drivers/media/pci/ivtv/ivtv-irq.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-irq.h
rename to drivers/media/pci/ivtv/ivtv-irq.h
diff --git a/drivers/media/video/ivtv/ivtv-mailbox.c b/drivers/media/pci/ivtv/ivtv-mailbox.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-mailbox.c
rename to drivers/media/pci/ivtv/ivtv-mailbox.c
diff --git a/drivers/media/video/ivtv/ivtv-mailbox.h b/drivers/media/pci/ivtv/ivtv-mailbox.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-mailbox.h
rename to drivers/media/pci/ivtv/ivtv-mailbox.h
diff --git a/drivers/media/video/ivtv/ivtv-queue.c b/drivers/media/pci/ivtv/ivtv-queue.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-queue.c
rename to drivers/media/pci/ivtv/ivtv-queue.c
diff --git a/drivers/media/video/ivtv/ivtv-queue.h b/drivers/media/pci/ivtv/ivtv-queue.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-queue.h
rename to drivers/media/pci/ivtv/ivtv-queue.h
diff --git a/drivers/media/video/ivtv/ivtv-routing.c b/drivers/media/pci/ivtv/ivtv-routing.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-routing.c
rename to drivers/media/pci/ivtv/ivtv-routing.c
diff --git a/drivers/media/video/ivtv/ivtv-routing.h b/drivers/media/pci/ivtv/ivtv-routing.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-routing.h
rename to drivers/media/pci/ivtv/ivtv-routing.h
diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/pci/ivtv/ivtv-streams.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-streams.c
rename to drivers/media/pci/ivtv/ivtv-streams.c
diff --git a/drivers/media/video/ivtv/ivtv-streams.h b/drivers/media/pci/ivtv/ivtv-streams.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-streams.h
rename to drivers/media/pci/ivtv/ivtv-streams.h
diff --git a/drivers/media/video/ivtv/ivtv-udma.c b/drivers/media/pci/ivtv/ivtv-udma.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-udma.c
rename to drivers/media/pci/ivtv/ivtv-udma.c
diff --git a/drivers/media/video/ivtv/ivtv-udma.h b/drivers/media/pci/ivtv/ivtv-udma.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-udma.h
rename to drivers/media/pci/ivtv/ivtv-udma.h
diff --git a/drivers/media/video/ivtv/ivtv-vbi.c b/drivers/media/pci/ivtv/ivtv-vbi.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-vbi.c
rename to drivers/media/pci/ivtv/ivtv-vbi.c
diff --git a/drivers/media/video/ivtv/ivtv-vbi.h b/drivers/media/pci/ivtv/ivtv-vbi.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-vbi.h
rename to drivers/media/pci/ivtv/ivtv-vbi.h
diff --git a/drivers/media/video/ivtv/ivtv-version.h b/drivers/media/pci/ivtv/ivtv-version.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-version.h
rename to drivers/media/pci/ivtv/ivtv-version.h
diff --git a/drivers/media/video/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-yuv.c
rename to drivers/media/pci/ivtv/ivtv-yuv.c
diff --git a/drivers/media/video/ivtv/ivtv-yuv.h b/drivers/media/pci/ivtv/ivtv-yuv.h
similarity index 100%
rename from drivers/media/video/ivtv/ivtv-yuv.h
rename to drivers/media/pci/ivtv/ivtv-yuv.h
diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
similarity index 100%
rename from drivers/media/video/ivtv/ivtvfb.c
rename to drivers/media/pci/ivtv/ivtvfb.c
diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/pci/saa7134/Kconfig
similarity index 100%
rename from drivers/media/video/saa7134/Kconfig
rename to drivers/media/pci/saa7134/Kconfig
diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/pci/saa7134/Makefile
similarity index 100%
rename from drivers/media/video/saa7134/Makefile
rename to drivers/media/pci/saa7134/Makefile
diff --git a/drivers/media/video/saa7134/saa6752hs.c b/drivers/media/pci/saa7134/saa6752hs.c
similarity index 100%
rename from drivers/media/video/saa7134/saa6752hs.c
rename to drivers/media/pci/saa7134/saa6752hs.c
diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-alsa.c
rename to drivers/media/pci/saa7134/saa7134-alsa.c
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-cards.c
rename to drivers/media/pci/saa7134/saa7134-cards.c
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-core.c
rename to drivers/media/pci/saa7134/saa7134-core.c
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-dvb.c
rename to drivers/media/pci/saa7134/saa7134-dvb.c
diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-empress.c
rename to drivers/media/pci/saa7134/saa7134-empress.c
diff --git a/drivers/media/video/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-i2c.c
rename to drivers/media/pci/saa7134/saa7134-i2c.c
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-input.c
rename to drivers/media/pci/saa7134/saa7134-input.c
diff --git a/drivers/media/video/saa7134/saa7134-reg.h b/drivers/media/pci/saa7134/saa7134-reg.h
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-reg.h
rename to drivers/media/pci/saa7134/saa7134-reg.h
diff --git a/drivers/media/video/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-ts.c
rename to drivers/media/pci/saa7134/saa7134-ts.c
diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-tvaudio.c
rename to drivers/media/pci/saa7134/saa7134-tvaudio.c
diff --git a/drivers/media/video/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-vbi.c
rename to drivers/media/pci/saa7134/saa7134-vbi.c
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
similarity index 100%
rename from drivers/media/video/saa7134/saa7134-video.c
rename to drivers/media/pci/saa7134/saa7134-video.c
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
similarity index 100%
rename from drivers/media/video/saa7134/saa7134.h
rename to drivers/media/pci/saa7134/saa7134.h
diff --git a/drivers/media/video/saa7164/Kconfig b/drivers/media/pci/saa7164/Kconfig
similarity index 100%
rename from drivers/media/video/saa7164/Kconfig
rename to drivers/media/pci/saa7164/Kconfig
diff --git a/drivers/media/video/saa7164/Makefile b/drivers/media/pci/saa7164/Makefile
similarity index 100%
rename from drivers/media/video/saa7164/Makefile
rename to drivers/media/pci/saa7164/Makefile
diff --git a/drivers/media/video/saa7164/saa7164-api.c b/drivers/media/pci/saa7164/saa7164-api.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-api.c
rename to drivers/media/pci/saa7164/saa7164-api.c
diff --git a/drivers/media/video/saa7164/saa7164-buffer.c b/drivers/media/pci/saa7164/saa7164-buffer.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-buffer.c
rename to drivers/media/pci/saa7164/saa7164-buffer.c
diff --git a/drivers/media/video/saa7164/saa7164-bus.c b/drivers/media/pci/saa7164/saa7164-bus.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-bus.c
rename to drivers/media/pci/saa7164/saa7164-bus.c
diff --git a/drivers/media/video/saa7164/saa7164-cards.c b/drivers/media/pci/saa7164/saa7164-cards.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-cards.c
rename to drivers/media/pci/saa7164/saa7164-cards.c
diff --git a/drivers/media/video/saa7164/saa7164-cmd.c b/drivers/media/pci/saa7164/saa7164-cmd.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-cmd.c
rename to drivers/media/pci/saa7164/saa7164-cmd.c
diff --git a/drivers/media/video/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-core.c
rename to drivers/media/pci/saa7164/saa7164-core.c
diff --git a/drivers/media/video/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-dvb.c
rename to drivers/media/pci/saa7164/saa7164-dvb.c
diff --git a/drivers/media/video/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-encoder.c
rename to drivers/media/pci/saa7164/saa7164-encoder.c
diff --git a/drivers/media/video/saa7164/saa7164-fw.c b/drivers/media/pci/saa7164/saa7164-fw.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-fw.c
rename to drivers/media/pci/saa7164/saa7164-fw.c
diff --git a/drivers/media/video/saa7164/saa7164-i2c.c b/drivers/media/pci/saa7164/saa7164-i2c.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-i2c.c
rename to drivers/media/pci/saa7164/saa7164-i2c.c
diff --git a/drivers/media/video/saa7164/saa7164-reg.h b/drivers/media/pci/saa7164/saa7164-reg.h
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-reg.h
rename to drivers/media/pci/saa7164/saa7164-reg.h
diff --git a/drivers/media/video/saa7164/saa7164-types.h b/drivers/media/pci/saa7164/saa7164-types.h
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-types.h
rename to drivers/media/pci/saa7164/saa7164-types.h
diff --git a/drivers/media/video/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
similarity index 100%
rename from drivers/media/video/saa7164/saa7164-vbi.c
rename to drivers/media/pci/saa7164/saa7164-vbi.c
diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
similarity index 100%
rename from drivers/media/video/saa7164/saa7164.h
rename to drivers/media/pci/saa7164/saa7164.h
diff --git a/drivers/media/video/zoran/Kconfig b/drivers/media/pci/zoran/Kconfig
similarity index 100%
rename from drivers/media/video/zoran/Kconfig
rename to drivers/media/pci/zoran/Kconfig
diff --git a/drivers/media/video/zoran/Makefile b/drivers/media/pci/zoran/Makefile
similarity index 100%
rename from drivers/media/video/zoran/Makefile
rename to drivers/media/pci/zoran/Makefile
diff --git a/drivers/media/video/zoran/videocodec.c b/drivers/media/pci/zoran/videocodec.c
similarity index 100%
rename from drivers/media/video/zoran/videocodec.c
rename to drivers/media/pci/zoran/videocodec.c
diff --git a/drivers/media/video/zoran/videocodec.h b/drivers/media/pci/zoran/videocodec.h
similarity index 100%
rename from drivers/media/video/zoran/videocodec.h
rename to drivers/media/pci/zoran/videocodec.h
diff --git a/drivers/media/video/zoran/zoran.h b/drivers/media/pci/zoran/zoran.h
similarity index 100%
rename from drivers/media/video/zoran/zoran.h
rename to drivers/media/pci/zoran/zoran.h
diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
similarity index 100%
rename from drivers/media/video/zoran/zoran_card.c
rename to drivers/media/pci/zoran/zoran_card.c
diff --git a/drivers/media/video/zoran/zoran_card.h b/drivers/media/pci/zoran/zoran_card.h
similarity index 100%
rename from drivers/media/video/zoran/zoran_card.h
rename to drivers/media/pci/zoran/zoran_card.h
diff --git a/drivers/media/video/zoran/zoran_device.c b/drivers/media/pci/zoran/zoran_device.c
similarity index 100%
rename from drivers/media/video/zoran/zoran_device.c
rename to drivers/media/pci/zoran/zoran_device.c
diff --git a/drivers/media/video/zoran/zoran_device.h b/drivers/media/pci/zoran/zoran_device.h
similarity index 100%
rename from drivers/media/video/zoran/zoran_device.h
rename to drivers/media/pci/zoran/zoran_device.h
diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
similarity index 100%
rename from drivers/media/video/zoran/zoran_driver.c
rename to drivers/media/pci/zoran/zoran_driver.c
diff --git a/drivers/media/video/zoran/zoran_procfs.c b/drivers/media/pci/zoran/zoran_procfs.c
similarity index 100%
rename from drivers/media/video/zoran/zoran_procfs.c
rename to drivers/media/pci/zoran/zoran_procfs.c
diff --git a/drivers/media/video/zoran/zoran_procfs.h b/drivers/media/pci/zoran/zoran_procfs.h
similarity index 100%
rename from drivers/media/video/zoran/zoran_procfs.h
rename to drivers/media/pci/zoran/zoran_procfs.h
diff --git a/drivers/media/video/zoran/zr36016.c b/drivers/media/pci/zoran/zr36016.c
similarity index 100%
rename from drivers/media/video/zoran/zr36016.c
rename to drivers/media/pci/zoran/zr36016.c
diff --git a/drivers/media/video/zoran/zr36016.h b/drivers/media/pci/zoran/zr36016.h
similarity index 100%
rename from drivers/media/video/zoran/zr36016.h
rename to drivers/media/pci/zoran/zr36016.h
diff --git a/drivers/media/video/zoran/zr36050.c b/drivers/media/pci/zoran/zr36050.c
similarity index 100%
rename from drivers/media/video/zoran/zr36050.c
rename to drivers/media/pci/zoran/zr36050.c
diff --git a/drivers/media/video/zoran/zr36050.h b/drivers/media/pci/zoran/zr36050.h
similarity index 100%
rename from drivers/media/video/zoran/zr36050.h
rename to drivers/media/pci/zoran/zr36050.h
diff --git a/drivers/media/video/zoran/zr36057.h b/drivers/media/pci/zoran/zr36057.h
similarity index 100%
rename from drivers/media/video/zoran/zr36057.h
rename to drivers/media/pci/zoran/zr36057.h
diff --git a/drivers/media/video/zoran/zr36060.c b/drivers/media/pci/zoran/zr36060.c
similarity index 100%
rename from drivers/media/video/zoran/zr36060.c
rename to drivers/media/pci/zoran/zr36060.c
diff --git a/drivers/media/video/zoran/zr36060.h b/drivers/media/pci/zoran/zr36060.h
similarity index 100%
rename from drivers/media/video/zoran/zr36060.h
rename to drivers/media/pci/zoran/zr36060.h
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f3d4228..a837194 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -619,14 +619,6 @@ menuconfig V4L_PCI_DRIVERS
 
 if V4L_PCI_DRIVERS
 
-source "drivers/media/video/cx18/Kconfig"
-
-source "drivers/media/video/cx23885/Kconfig"
-
-source "drivers/media/video/cx25821/Kconfig"
-
-source "drivers/media/video/cx88/Kconfig"
-
 config VIDEO_HEXIUM_GEMINI
 	tristate "Hexium Gemini frame grabber"
 	depends on PCI && VIDEO_V4L2 && I2C
@@ -650,8 +642,6 @@ config VIDEO_HEXIUM_ORION
 	  To compile this driver as a module, choose M here: the
 	  module will be called hexium_orion.
 
-source "drivers/media/video/ivtv/Kconfig"
-
 config VIDEO_MEYE
 	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
 	depends on PCI && SONY_LAPTOP && VIDEO_V4L2
@@ -682,11 +672,6 @@ config VIDEO_MXB
 	  To compile this driver as a module, choose M here: the
 	  module will be called mxb.
 
-source "drivers/media/video/saa7134/Kconfig"
-
-source "drivers/media/video/saa7164/Kconfig"
-
-source "drivers/media/video/zoran/Kconfig"
 
 config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index df60ffa..322a159 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -87,16 +87,12 @@ obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 
 # And now the v4l2 drivers:
 
-obj-$(CONFIG_VIDEO_ZORAN) += zoran/
 obj-$(CONFIG_VIDEO_CQCAM) += c-qcam.o
 obj-$(CONFIG_VIDEO_BWQCAM) += bw-qcam.o
 obj-$(CONFIG_VIDEO_W9966) += w9966.o
 obj-$(CONFIG_VIDEO_PMS) += pms.o
 obj-$(CONFIG_VIDEO_VINO) += vino.o
 obj-$(CONFIG_VIDEO_MEYE) += meye.o
-obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
-obj-$(CONFIG_VIDEO_CX88) += cx88/
-obj-$(CONFIG_VIDEO_CX25821) += cx25821/
 obj-$(CONFIG_VIDEO_MXB) += mxb.o
 obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
 obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
@@ -116,13 +112,9 @@ obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
 
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 
-obj-$(CONFIG_VIDEO_IVTV) += ivtv/
-obj-$(CONFIG_VIDEO_CX18) += cx18/
-
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
-obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
 obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
 
@@ -157,8 +149,6 @@ obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
-obj-$(CONFIG_VIDEO_SAA7164)     += saa7164/
-
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 
 obj-y	+= davinci/
-- 
1.7.11.2

