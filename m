Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab3DUTAt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 15:00:49 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3LJ0nxG016328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 21 Apr 2013 15:00:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv3 00/10] Add SDR at V4L2 API
Date: Sun, 21 Apr 2013 16:00:29 -0300
Message-Id: <1366570839-662-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a version 3 of the V4L2 API bits to support Software Digital
Radio (SDR).

Changes from version 2:

	- Patches got better described and named;
	- Merged all SDR analog TV into just one field;
	- Documented what parts of the [RFC v2013-04-11] SDR API
	  REQUIREMENT SPECIFICATION are being addressed on the
	  patches that touch on the V4L2 external API.

With regards to the [RFC v2013-04-11] SDR requirements spec[1], v3
implements:

	- operation mode inquire (Rx/Tx)
		- implemented via VIDIOC_QUERYCAP;
		- get/set doesn't make sense, as different devnodes
		  are used for RX and TX;
	- sampling resolution
		- implemented via VIDIOC_ENUM_FMT/VIDIOC_G_FMT/VIDIOC_S_FMT.
	- sampling rate
		- get/set - implemented via VIDIOC_G_TUNER/VIDIOC_S_TUNER.
		- inquire HW - TODO (planning is to also use the same
		  ioctl's for it);
		- It may make sense to move it out of TUNER ioctl, as
		  this is actually ADC/DAC settings. For the initial
		  tests, I'll likely use as is, but IMO, the beter is to
		  split it out of VIDIOC_G_TUNER/VIDIOC_S_TUNER.
	- inversion
		- TODO. If needed, probably will use VIDIOC_G_TUNER.
	- RF frequency
		- implemented using VIDIOC_S_FREQUENCY/VIDIOC_G_FREQUENCY
		- scale: 62.5 Hz.
		- TODO: add a lower scale, for very low freqs.
	- IF frequency
		- implemented via VIDIOC_G_TUNER/VIDIOC_S_TUNER.
	- tuner lock (frequency synthesizer / PLL)
		- TODO. May eventually use tuner->strength
	- tuner gains
		- TODO (V4L2 controls).
	- enable/disable auto gain
		- TODO (V4L2 controls).
	- tuner filters
		- TODO (V4L2 controls).
	- pass RF standard to tuner?
		- Partially implemented. It doesn't pass V4L2 analog TV
		  types yet.
		- TODO: add VIDIOC_S_STD support for SDR radio
	- antenna switch
		- implemented via VIDIOC_G_TUNER/VIDIOC_S_TUNER.
	- external LNA
		- TODO (maybe there's already a V4L2 control for it)
	- device locking between multiple APIs
		- TODO (well, there are resource locking already between
		 	DVB and V4L at driver level)

[1] http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/63323

TODO:
	- check if VB2 require changes (might require trivial ones, due
	  to the new buffer type);

	- add a SDR driver testing the new features - likely a cx88 driver,
but as cx88 doesn't use VB2, I might use some other driver. The advantage
of using cx88 is that it has 2 ADC, one baseband and another IF that can
be used at the same time, 8-bits or 10-bits and up to ~35 MHz of
sampling rate.

Mauro Carvalho Chehab (10):
  [media] Add initial SDR support at V4L2 API
  [media] videodev2.h: Remove the unused old V4L1 buffer types
  [media] V4L2 api: Add a buffer capture type for SDR
  [media] V4L2 sdr API: Add fields for VIDIOC_[G|S]_TUNER
  [media] v4l2-ioctl: Add tuner ioctl support for SDR radio type
  [media] tuner-core: consider SDR as radio
  [media] tuner-core: add SDR support for g_tuner
  [media] tuner-core: store tuner ranges at tuner struct
  [media] tuner-core: add support to get the tuner frequency range
  [media] tuner-core: add support for SDR set_tuner

 Documentation/DocBook/media/v4l/common.xml         |  35 +++
 Documentation/DocBook/media/v4l/dev-capture.xml    |  26 +-
 Documentation/DocBook/media/v4l/io.xml             |   6 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |  41 +++
 Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |  30 ++-
 .../DocBook/media/v4l/vidioc-querycap.xml          |   7 +
 drivers/media/dvb-core/dvb_frontend.h              |   2 +
 drivers/media/tuners/tuner-xc2028.c                |   2 +
 drivers/media/v4l2-core/tuner-core.c               | 297 ++++++++++++++-------
 drivers/media/v4l2-core/v4l2-dev.c                 |   3 +
 drivers/media/v4l2-core/v4l2-ioctl.c               | 121 +++++++--
 include/media/v4l2-dev.h                           |   3 +-
 include/media/v4l2-ioctl.h                         |   8 +
 include/uapi/linux/videodev2.h                     |  79 ++++--
 15 files changed, 503 insertions(+), 158 deletions(-)

-- 
1.8.1.4

