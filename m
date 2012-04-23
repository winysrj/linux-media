Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:13045 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2DWLsx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:48:53 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: [RFC PATCH 0/8] Fix compiler warnings
Date: Mon, 23 Apr 2012 13:38:18 +0200
Message-Id: <1335181106-19342-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

The daily build is full of compiler warnings, almost all of them are trivial
to fix.

These eight patches fix the majority of them. Please review if it affects one
of your drivers.

A daily build is only really useful if the number of warnings is low, otherwise
one can't see the forest through the trees and potentially important warnings
are missed. Hence this effort of mine.

Regards,

	Hans

Hans Verkuil (8):
dw2102: fix compile warnings
cx231xx: fix compiler warnings
ivtv/cx18: fix compiler warnings
cx25821: fix compiler warnings.
v4l: fix compiler warnings.
v4l: fix compiler warnings.
v4l/dvb: fix compiler warnings.
v4l/dvb: fix compiler warnings

drivers/media/dvb/bt8xx/dst_ca.c                   |    2 -
drivers/media/dvb/dvb-usb/dw2102.c                 |   76 +++++------
drivers/media/dvb/dvb-usb/lmedm04.c                |    3 +-                                                           
drivers/media/dvb/frontends/af9013.c               |   13 +-                                                           
drivers/media/dvb/frontends/cx24110.c              |    7 +-                                                           
drivers/media/dvb/frontends/dib9000.c              |    3 +-                                                           
drivers/media/dvb/frontends/drxk_hard.c            |    9 +-                                                           
drivers/media/dvb/frontends/it913x-fe.c            |   26 ++--                                                         
drivers/media/dvb/frontends/lgs8gxx.c              |    3 +-                                                           
drivers/media/dvb/frontends/m88rs2000.c            |    3 +-                                                           
drivers/media/dvb/frontends/stb0899_drv.c          |    8 +-                                                           
drivers/media/dvb/frontends/stb6100.c              |    3 +-                                                           
drivers/media/dvb/frontends/stv0297.c              |    2 -                                                            
drivers/media/dvb/frontends/stv0900_sw.c           |    2 -                                                            
drivers/media/dvb/frontends/stv090x.c              |    2 -                                                            
drivers/media/dvb/frontends/zl10353.c              |    3 +-                                                           
drivers/media/dvb/mantis/hopper_cards.c            |    3 +-                                                           
drivers/media/dvb/mantis/mantis_cards.c            |    3 +-                                                           
drivers/media/dvb/mantis/mantis_dma.c              |    4 -                                                            
drivers/media/dvb/mantis/mantis_evm.c              |    3 +-                                                           
drivers/media/dvb/siano/smssdio.c                  |    4 +-                                                           
drivers/media/rc/ir-sanyo-decoder.c                |    4 +-                                                           
drivers/media/rc/mceusb.c                          |    4 +-                                                           
drivers/media/video/adv7343.c                      |    4 +-                                                           
drivers/media/video/au0828/au0828-video.c          |    4 +-                                                           
drivers/media/video/c-qcam.c                       |    3 +-
drivers/media/video/cx18/cx18-alsa-main.c          |    1 +
drivers/media/video/cx18/cx18-alsa-pcm.c           |   10 +-
drivers/media/video/cx18/cx18-mailbox.c            |    6 +-
drivers/media/video/cx18/cx18-streams.c            |    3 -
drivers/media/video/cx231xx/cx231xx-417.c          |   16 ++-
drivers/media/video/cx231xx/cx231xx-audio.c        |   17 ++-
drivers/media/video/cx231xx/cx231xx-avcore.c       |  144 +++++++++-----------
drivers/media/video/cx231xx/cx231xx-core.c         |   76 +++++------
drivers/media/video/cx231xx/cx231xx-vbi.c          |    6 +-
drivers/media/video/cx231xx/cx231xx-video.c        |   16 ---
drivers/media/video/cx23885/cx23888-ir.c           |    4 +-
drivers/media/video/cx25821/cx25821-alsa.c         |    2 -
.../media/video/cx25821/cx25821-audio-upstream.c   |    3 +-
drivers/media/video/cx25821/cx25821-core.c         |   14 +-
drivers/media/video/cx25821/cx25821-i2c.c          |    3 +-
drivers/media/video/cx25821/cx25821-medusa-video.c |   13 +-
.../video/cx25821/cx25821-video-upstream-ch2.c     |    3 +-
.../media/video/cx25821/cx25821-video-upstream.c   |    3 +-
drivers/media/video/cx25821/cx25821-video.c        |   25 +---
drivers/media/video/cx25821/cx25821-video.h        |    2 -
drivers/media/video/cx25840/cx25840-ir.c           |    6 +-
drivers/media/video/em28xx/em28xx-audio.c          |    9 +-
drivers/media/video/et61x251/et61x251_core.c       |   11 +-
drivers/media/video/hdpvr/hdpvr-control.c          |    2 +
drivers/media/video/hdpvr/hdpvr-video.c            |    2 +-
drivers/media/video/ivtv/ivtv-ioctl.c              |    3 -
drivers/media/video/ivtv/ivtvfb.c                  |    2 +
drivers/media/video/pms.c                          |    4 +-
drivers/media/video/s2255drv.c                     |    4 -
drivers/media/video/saa7134/saa7134-video.c        |    2 +-
drivers/media/video/sn9c102/sn9c102_core.c         |    4 +-
drivers/media/video/tm6000/tm6000-input.c          |    3 +-
drivers/media/video/tm6000/tm6000-stds.c           |    2 -
drivers/media/video/tm6000/tm6000-video.c          |    9 +-
drivers/media/video/tvp5150.c                      |    7 -
drivers/media/video/tvp7002.c                      |    3 -
drivers/media/video/usbvision/usbvision-core.c     |   12 +-
drivers/media/video/videobuf-dvb.c                 |    3 +-
drivers/media/video/zoran/zoran_device.c           |    2 -
drivers/media/video/zr364xx.c                      |    2 -
drivers/staging/media/go7007/go7007-v4l2.c         |    2 -
67 files changed, 245 insertions(+), 417 deletions(-)

