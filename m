Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:51229 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaDKWvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 18:51:03 -0400
Date: Fri, 11 Apr 2014 19:50:55 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.15-rc1] media fixes
Message-id: <20140411195055.29fa1b26@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a series of bug fix patches for v3.15-rc1. Most are just driver fixes.
There are some changes at remote controller core level, fixing some 
definitions on a new API added for Kernel v3.15.

It also adds the missing include at include/uapi/linux/v4l2-common.h, 
to allow its compilation on userspace, as pointed by you.

Thanks,
Mauro

The following changes since commit 463b21fb27509061b3e97fb4fa69f26d089ddaf4:

  Merge branch 'topic/exynos' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2014-04-05 13:10:00 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 32654fba2fdb417390efb1af29f1b5693bc91397:

  [media] gpsca: remove the risk of a division by zero (2014-04-08 11:01:12 -0300)

----------------------------------------------------------------
Antti Palosaari (5):
      [media] msi001: fix possible integer overflow
      [media] msi3101: remove unused variable assignment
      [media] msi3101: check I/O return values on stop streaming
      [media] xc2028: add missing break to switch
      [media] rtl28xxu: remove duplicate ID 0458:707f Genius TVGo DVB-T03

Archit Taneja (9):
      [media] v4l: ti-vpe: Make sure in job_ready that we have the needed number of dst_bufs
      [media] v4l: ti-vpe: Use video_device_release_empty
      [media] v4l: ti-vpe: Allow usage of smaller images
      [media] v4l: ti-vpe: report correct capabilities in querycap
      [media] v4l: ti-vpe: Use correct bus_info name for the device in querycap
      [media] v4l: ti-vpe: Fix initial configuration queue data
      [media] v4l: ti-vpe: zero out reserved fields in try_fmt
      [media] v4l: ti-vpe: Set correct field parameter for output and capture buffers
      [media] v4l: ti-vpe: retain v4l2_buffer flags for captured buffers

Benjamin Larsson (1):
      [media] r820t: fix size and init values

David Härdeman (3):
      [media] rc-core: do not change 32bit NEC scancode format for now
      [media] rc-core: split dev->s_filter
      [media] rc-core: remove generic scancode filter

Malcolm Priestley (1):
      [media] m88rs2000: fix sparse static warnings

Mauro Carvalho Chehab (3):
      [media] v4l2-common: fix warning when used on userpace
      [media] stk1160: warrant a NUL terminated string
      [media] gpsca: remove the risk of a division by zero

Paul Bolle (1):
      [media] drx-j: use customise option correctly

Shuah Khan (1):
      [media] lgdt3305: include sleep functionality in lgdt3304_ops

 drivers/media/dvb-frontends/drx39xyj/Kconfig |  2 +-
 drivers/media/dvb-frontends/lgdt3305.c       |  1 +
 drivers/media/dvb-frontends/m88rs2000.c      |  8 +--
 drivers/media/platform/ti-vpe/vpe.c          | 45 +++++++++----
 drivers/media/rc/img-ir/img-ir-hw.c          | 15 ++++-
 drivers/media/rc/img-ir/img-ir-nec.c         | 27 ++++----
 drivers/media/rc/ir-nec-decoder.c            |  5 +-
 drivers/media/rc/keymaps/rc-tivo.c           | 86 ++++++++++++------------
 drivers/media/rc/rc-main.c                   | 98 ++++++++++++++++++----------
 drivers/media/tuners/r820t.c                 |  3 +-
 drivers/media/tuners/tuner-xc2028.c          |  1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c      |  2 -
 drivers/media/usb/gspca/jpeg.h               |  4 +-
 drivers/media/usb/stk1160/stk1160-ac97.c     |  2 +-
 drivers/staging/media/msi3101/msi001.c       |  2 +-
 drivers/staging/media/msi3101/sdr-msi3101.c  | 15 +++--
 include/media/rc-core.h                      |  8 ++-
 include/uapi/linux/v4l2-common.h             |  2 +
 18 files changed, 200 insertions(+), 126 deletions(-)



-- 

Regards,
Mauro
