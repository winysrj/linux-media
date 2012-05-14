Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4733 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab2ENNZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 09:25:59 -0400
Received: from alastor.dyndns.org (189.80-203-102.nextgentel.com [80.203.102.189] (may be forged))
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id q4EDPuWs057404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:25:57 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id C4003199C008A
	for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:25:55 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.5] Fix compiler warnings
Date: Mon, 14 May 2012 15:25:55 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205141525.55198.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is the rebased version incorporating your remarks.
Instead of commenting out variables I now put them under #if 0 together with
the relevant piece of 'TODO' code.

Regards,

	Hans

The following changes since commit e89fca923f32de26b69bf4cd604f7b960b161551:

  [media] gspca - ov534: Add Hue control (2012-05-14 09:48:00 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git warnings

for you to fetch changes up to d15edd383368cdd20ad142b1179282385303b56b:

  v4l/dvb: fix compiler warnings. (2012-05-14 15:22:58 +0200)

----------------------------------------------------------------
Hans Verkuil (8):
      dw2102: fix compile warnings
      cx231xx: fix compiler warnings
      ivtv/cx18: fix compiler warnings
      cx25821: fix compiler warnings.
      v4l: fix compiler warnings.
      v4l: fix compiler warnings.
      v4l/dvb: fix compiler warnings
      v4l/dvb: fix compiler warnings.

 drivers/media/dvb/bt8xx/dst_ca.c                         |    2 --
 drivers/media/dvb/dvb-usb/dw2102.c                       |   76 ++++++++++++++++++++++------------------------
 drivers/media/dvb/dvb-usb/lmedm04.c                      |    3 +-
 drivers/media/dvb/frontends/af9013.c                     |   13 ++++----
 drivers/media/dvb/frontends/cx24110.c                    |    7 ++---
 drivers/media/dvb/frontends/dib9000.c                    |    3 +-
 drivers/media/dvb/frontends/drxk_hard.c                  |   14 ++++++---
 drivers/media/dvb/frontends/it913x-fe.c                  |   26 ++++++++--------
 drivers/media/dvb/frontends/lgs8gxx.c                    |    3 +-
 drivers/media/dvb/frontends/m88rs2000.c                  |    3 +-
 drivers/media/dvb/frontends/stb0899_drv.c                |    8 +----
 drivers/media/dvb/frontends/stb6100.c                    |    3 +-
 drivers/media/dvb/frontends/stv0297.c                    |    2 --
 drivers/media/dvb/frontends/stv0900_sw.c                 |    2 --
 drivers/media/dvb/frontends/stv090x.c                    |    2 --
 drivers/media/dvb/frontends/zl10353.c                    |    3 +-
 drivers/media/dvb/mantis/hopper_cards.c                  |    3 +-
 drivers/media/dvb/mantis/mantis_cards.c                  |    3 +-
 drivers/media/dvb/mantis/mantis_dma.c                    |    4 ---
 drivers/media/dvb/mantis/mantis_evm.c                    |    3 +-
 drivers/media/dvb/siano/smssdio.c                        |    4 +--
 drivers/media/rc/ir-sanyo-decoder.c                      |    4 +--
 drivers/media/rc/mceusb.c                                |    3 +-
 drivers/media/video/adv7343.c                            |    4 +--
 drivers/media/video/au0828/au0828-video.c                |    4 +--
 drivers/media/video/c-qcam.c                             |    3 +-
 drivers/media/video/cx18/cx18-alsa-main.c                |    1 +
 drivers/media/video/cx18/cx18-alsa-pcm.c                 |   10 ++-----
 drivers/media/video/cx18/cx18-mailbox.c                  |    6 +---
 drivers/media/video/cx18/cx18-streams.c                  |    3 --
 drivers/media/video/cx231xx/cx231xx-417.c                |   18 ++++++-----
 drivers/media/video/cx231xx/cx231xx-audio.c              |   18 ++++++-----
 drivers/media/video/cx231xx/cx231xx-avcore.c             |  144 ++++++++++++++++++++++++++++++++++++++++------------------------------------------------
 drivers/media/video/cx231xx/cx231xx-core.c               |   76 ++++++++++++++++++++++------------------------
 drivers/media/video/cx231xx/cx231xx-vbi.c                |    6 +---
 drivers/media/video/cx231xx/cx231xx-video.c              |   16 ----------
 drivers/media/video/cx23885/cx23888-ir.c                 |    4 +--
 drivers/media/video/cx25821/cx25821-alsa.c               |    2 --
 drivers/media/video/cx25821/cx25821-audio-upstream.c     |    3 +-
 drivers/media/video/cx25821/cx25821-core.c               |   14 ++-------
 drivers/media/video/cx25821/cx25821-i2c.c                |    3 +-
 drivers/media/video/cx25821/cx25821-medusa-video.c       |   13 ++++----
 drivers/media/video/cx25821/cx25821-video-upstream-ch2.c |    3 +-
 drivers/media/video/cx25821/cx25821-video-upstream.c     |    3 +-
 drivers/media/video/cx25821/cx25821-video.c              |   25 ++--------------
 drivers/media/video/cx25821/cx25821-video.h              |    2 --
 drivers/media/video/cx25840/cx25840-ir.c                 |    6 +---
 drivers/media/video/em28xx/em28xx-audio.c                |   11 ++++---
 drivers/media/video/hdpvr/hdpvr-control.c                |    2 ++
 drivers/media/video/hdpvr/hdpvr-video.c                  |    2 +-
 drivers/media/video/ivtv/ivtv-ioctl.c                    |    3 --
 drivers/media/video/ivtv/ivtvfb.c                        |    2 ++
 drivers/media/video/pms.c                                |    4 +--
 drivers/media/video/s2255drv.c                           |    4 ---
 drivers/media/video/saa7134/saa7134-video.c              |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c               |    4 +--
 drivers/media/video/tm6000/tm6000-input.c                |    3 +-
 drivers/media/video/tm6000/tm6000-stds.c                 |    2 --
 drivers/media/video/tm6000/tm6000-video.c                |    9 +-----
 drivers/media/video/tvp5150.c                            |    7 -----
 drivers/media/video/tvp7002.c                            |    3 --
 drivers/media/video/usbvision/usbvision-core.c           |   12 ++++----
 drivers/media/video/videobuf-dvb.c                       |    3 +-
 drivers/media/video/zoran/zoran_device.c                 |    2 --
 drivers/media/video/zr364xx.c                            |    2 --
 drivers/staging/media/go7007/go7007-v4l2.c               |    2 --
 66 files changed, 252 insertions(+), 408 deletions(-)
