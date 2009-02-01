Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZBANnZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2009 08:43:25 -0500
Date: Sun, 1 Feb 2009 11:42:57 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org
Subject: Re: cx88-dvb broken since 2.6.29-rc1
Message-ID: <20090201114257.19d5df1f@pedra.chehab.org>
In-Reply-To: <20090201142927.57f0d5b4@hyperion.delvare>
References: <20090129221012.685c239e@hyperion.delvare>
	<20090129192431.46adf0c9@caramujo.chehab.org>
	<20090201142927.57f0d5b4@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 1 Feb 2009 14:29:27 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> Hi Mauro,
> 
> On Thu, 29 Jan 2009 19:24:31 -0200, Mauro Carvalho Chehab wrote:
> > On Thu, 29 Jan 2009 22:10:12 +0100
> > Jean Delvare <khali@linux-fr.org> wrote:
> > 
> > > Hi folks,
> > > 
> > > I have a CX88-based DVB-T adapter which worked fine up to 2.6.28 but is
> > > broken since 2.6.29-rc1 (and not fixed as off 2.6.29-rc3). The problem
> > > is that /dev/dvb isn't created. Presumably the root cause is the
> > > following in the kernel logs as the driver is loaded:
> > 
> > I have already a pull request almost ready that will fix this issue. I'll
> > likely send it today or tomorrow.
> 
> Did it happen? I've just tested kernel 2.6.29-rc3-git3 and the problem
> is still present.

I just sent today a pull request with this fix included:

From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-media@vger.linuxtv.org
Subject: [GIT PATCHES for 2.6.29] V4L/DVB fixes
Date: Sun, 1 Feb 2009 11:06:47 -0200
Organization: Red Hat

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For several driver fixes:
   - em28xx: fix some race conditions, several audio fixes, some 
	     memory leaks, and fix the  support for Kworld 330U;
   - uvcvideo: updates copyright, fix GET_DEF detection and prints UVC 
	       version number in a coherent way;
   - cx88: Fix DVB support;
   - zoran: fix udev detection and uses the standard PCI detection 
	    methods;
   - removed unused #include <version.h>'s on drivers;
   - tvp514x: Don't write after line end;
   - en50221: implement proper locking;
   - tveeprom: Properly initialize tuner type (BZ#11367);
   - Documentation: Fix a bug on the example v4lgrab.c;
   - stb0899: Fix 'stb0899_get_srate' defined but not used warning;
   - saa7127: fix broken S-Video with saa7129;
   - cx23885: Fix Oops for mixed install of analog and digital only cards;
   - saa7134: Prevent Oops due to stale IRQ status when enabling interrupts;
   - v4l2-device: fix buggy macro;
   - v4l2 core: Fix obvious swapped names in v4l2_subdev logic;
   - v4l-dvb: fix a bunch of compile warnings;
   - cx25840: fix regression: fw not loaded on first use;
   - budget.c driver: Kernel oops: "BUG: unable to handle kernel paging request at ffffffff
   - saa7146: fix unbalanced mutex_lock/unlock;
   - af9015: fix second FE and fix init for sticks already plugged;
   - cx25840: ignore TUNER_SET_CONFIG in the command callback.
   - radio-mr800: fix radio->muted and radio->stereo
   - gspca - main: Fix memory leak when USB disconnection while streaming;
   - ivtv: fix memory leak;
   - saa7134-alsa: saa7130 doesn't support digital audio;
   - s5h1409: Perform s5h1409 soft reset after tuning.

Cheers,
Mauro.

---

 Documentation/video4linux/v4lgrab.c           |   25 +-
 drivers/media/common/saa7146_video.c          |    1 +
 drivers/media/common/tuners/mxl5007t.c        |    2 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c   |   24 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.h   |    6 +-
 drivers/media/dvb/dvb-usb/af9005-fe.c         |    2 +-
 drivers/media/dvb/dvb-usb/af9015.c            |   30 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c   |   18 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h       |    2 +
 drivers/media/dvb/frontends/drx397xD.c        |    2 +-
 drivers/media/dvb/frontends/s5h1409.c         |    7 +-
 drivers/media/dvb/frontends/stb0899_algo.c    |    3 +
 drivers/media/dvb/ttpci/budget.c              |    1 +
 drivers/media/dvb/ttusb-dec/ttusb_dec.c       |    2 +-
 drivers/media/radio/radio-mr800.c             |   12 +-
 drivers/media/video/cs5345.c                  |    1 -
 drivers/media/video/cx23885/cx23885-417.c     |    3 +-
 drivers/media/video/cx23885/cx23885-video.c   |    5 +-
 drivers/media/video/cx25840/cx25840-core.c    |    8 +
 drivers/media/video/cx88/cx88-dvb.c           |   72 ++--
 drivers/media/video/cx88/cx88.h               |    2 +-
 drivers/media/video/em28xx/em28xx-audio.c     |   14 +-
 drivers/media/video/em28xx/em28xx-cards.c     |   32 +-
 drivers/media/video/em28xx/em28xx-core.c      |   20 +-
 drivers/media/video/em28xx/em28xx-dvb.c       |   20 +-
 drivers/media/video/em28xx/em28xx-video.c     |   45 +-
 drivers/media/video/em28xx/em28xx.h           |   21 +-
 drivers/media/video/gspca/gspca.c             |    4 +-
 drivers/media/video/ivtv/ivtv-driver.c        |    4 +-
 drivers/media/video/pwc/pwc-if.c              |    1 -
 drivers/media/video/saa7127.c                 |   52 ++-
 drivers/media/video/saa7134/saa7134-alsa.c    |    6 +-
 drivers/media/video/saa7134/saa7134-core.c    |    4 +
 drivers/media/video/saa717x.c                 |    1 -
 drivers/media/video/tda9875.c                 |    2 +-
 drivers/media/video/tveeprom.c                |    3 +
 drivers/media/video/tvp514x.c                 |    2 +-
 drivers/media/video/upd64031a.c               |    1 -
 drivers/media/video/upd64083.c                |    1 -
 drivers/media/video/usbvision/usbvision-i2c.c |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c            |    7 +-
 drivers/media/video/uvc/uvc_driver.c          |   55 +--
 drivers/media/video/uvc/uvc_isight.c          |    2 +
 drivers/media/video/uvc/uvc_queue.c           |   31 +-
 drivers/media/video/uvc/uvc_status.c          |    3 +-
 drivers/media/video/uvc/uvc_v4l2.c            |   10 +-
 drivers/media/video/uvc/uvc_video.c           |   31 +-
 drivers/media/video/uvc/uvcvideo.h            |  232 +++++-----
 drivers/media/video/v4l2-subdev.c             |    4 +-
 drivers/media/video/zoran/zoran.h             |   12 +-
 drivers/media/video/zoran/zoran_card.c        |  620 ++++++++++++-------------
 drivers/media/video/zoran/zoran_card.h        |    2 -
 drivers/media/video/zoran/zoran_driver.c      |  105 ++---
 include/media/v4l2-device.h                   |    8 +-
 54 files changed, 854 insertions(+), 731 deletions(-)

Alexey Klimov (1):
      V4L/DVB (10317): radio-mr800: fix radio->muted and radio->stereo

Andy Walls (3):
      V4L/DVB (10218): cx23885: Fix Oops for mixed install of analog and digital only cards
      V4L/DVB (10219): saa7134: Prevent Oops due to stale IRQ status when enabling interrupts
      V4L/DVB (10229): cx88-dvb: Fix order of frontend allocations

Antti Palosaari (2):
      V4L/DVB (10287): af9015: fix second FE
      V4L/DVB (10288): af9015: bug fix: stick does not work always when plugged

Devin Heitmueller (2):
      V4L/DVB (10261): em28xx: fix kernel panic on audio shutdown
      V4L/DVB (10411): s5h1409: Perform s5h1409 soft reset after tuning

Hans Verkuil (8):
      V4L/DVB (10214): Fix 'stb0899_get_srate' defined but not used warning
      V4L/DVB (10230): v4l2-device: fix buggy macro
      V4L/DVB (10243): em28xx: fix compile warning
      V4L/DVB (10248): v4l-dvb: fix a bunch of compile warnings.
      V4L/DVB (10250): cx25840: fix regression: fw not loaded on first use
      V4L/DVB (10270): saa7146: fix unbalanced mutex_lock/unlock
      V4L/DVB (10314): cx25840: ignore TUNER_SET_CONFIG in the command callback.
      V4L/DVB (10229): ivtv: fix memory leak

Huang Weiyi (1):
      V4L/DVB (10193): removed unused #include <version.h>'s

Jean-Francois Moine (1):
      V4L/DVB (10385): gspca - main: Fix memory leak when USB disconnection while streaming.

Laurent Pinchart (3):
      V4L/DVB (10197): uvcvideo: Whitespace and comments cleanup, copyright updates.
      V4L/DVB (10198): uvcvideo: Print the UVC version number in binary-coded decimal.
      V4L/DVB (10199): uvcvideo: Fix GET_DEF failure detection.

Martin Dauskardt (1):
      V4L/DVB (10216): saa7127: fix broken S-Video with saa7129

Matthias Dahl (1):
      V4L/DVB (9054): implement proper locking in the dvb ca en50221 driver

Mauro Carvalho Chehab (6):
      V4L/DVB (10192): em28xx: fix input selection
      V4L/DVB (10201): Fixes cx88 compilation bug
      V4L/DVB (10208): zoran: Re-adds udev entry removed by changeset 60b4bde4
      V4L/DVB (10209): tveeprom: Properly initialize tuner type (BZ#11367)
      V4L/DVB (10228): em28xx: fix audio output PCM IN selection
      V4L/DVB (10403): saa7134-alsa: saa7130 doesn't support digital audio

Mike Isely (1):
      V4L/DVB (10240): Fix obvious swapped names in v4l2_subdev logic

Nicolas Fournier (1):
      V4L/DVB (10233): [PATCH] Terratec Cinergy DT XS Diversity new USB ID (0ccd:0081)

Robert Krakora (4):
      V4L/DVB (10254): em28xx: Fix audio URB transfer buffer race condition
      V4L/DVB (10256): em28xx: Fix for KWorld 330U AC97
      V4L/DVB (10257): em28xx: Fix for KWorld 330U Board
      V4L/DVB (10325): em28xx: Fix for fail to submit URB with IRQs and Pre-emption Disabled

Sebastian Andrzej Siewior (1):
      V4L/DVB (10202): [PATCH] v4l/tvp514x: Don't write after line end

Simon Harrison (1):
      V4L/DVB (10210): Fix a bug on v4lgrab.c

Tony Broad (1):
      V4L/DVB (10265): budget.c driver: Kernel oops: "BUG: unable to handle kernel paging request at ffffffff

Trent Piepho (6):
      V4L/DVB (10212): Convert to be a pci driver
      V4L/DVB (10222): zoran: Better syntax for initializing array module params
      V4L/DVB (10223): zoran: Remove global device array
      V4L/DVB (10224): zoran: Use pci device table to get card type
      V4L/DVB (10225): zoran: Remove zr36057_adr field
      V4L/DVB (10226): zoran: Get rid of extra module ref count

Yusuf Altin (1):
      V4L/DVB (10195): [PATCH] add Terratec Cinergy T Express to dibcom driver

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

.




Cheers,
Mauro
