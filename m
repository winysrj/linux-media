Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6KFFgse002852
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 11:15:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6KFFSAg008201
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 11:15:29 -0400
Date: Sun, 20 Jul 2008 10:59:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080720105905.4f4755ae@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.27] V4L/DVB updates
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:
   - Several fixes and improvements at drivers and at V4L2 core;
   - A new videobuf core driver that allows the usage of DMA contiguous memory 
     transfers;
   - New drivers: Anysee, Sensoray 2255, gspca, sms1xxx.

With gspca (and uvc, committed on 2.6.26), Linux will now support most webcams 
available at the market. The previous version of gspca were V4L1 only. The 
committed version has being ported to V4L2. It also works fine with V4L1 
userspace apps, especially if used together with the new V4L2 userspace 
library, available at http://linuxtv.org/hg/v4l-dvb, under v4l2-apps/lib dir.

This series includes 47416 line insersions! Most of those are due to gspca 
driver. This is a very big driver, and it has been split into smaller drivers. 
Due to its big size, I couldn't find time to do a carefully look on it (I did a 
quick overview on it, and checked for V4L2 API compliance). So, instead of 
having it waiting forever for my spare time to review this important driver, 
I've decided to send it upstream, since we have very good janitors that will 
help us on reviewing it ;)

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.cx23885         |    1 +
 Documentation/video4linux/CARDLIST.em28xx          |    5 +-
 Documentation/video4linux/CARDLIST.saa7134         |    8 +-
 Documentation/video4linux/cx18.txt                 |   36 +-
 Documentation/video4linux/gspca.txt                |  243 +
 drivers/media/Kconfig                              |    5 +-
 drivers/media/common/ir-functions.c                |   26 +-
 drivers/media/common/saa7146_core.c                |    4 +-
 drivers/media/common/saa7146_hlp.c                 |    2 +-
 drivers/media/common/saa7146_i2c.c                 |   34 +-
 drivers/media/common/saa7146_video.c               |    4 +-
 drivers/media/common/tuners/Kconfig                |    1 +
 drivers/media/common/tuners/tda18271-maps.c        |    2 +-
 drivers/media/common/tuners/tuner-xc2028.c         |   25 +-
 drivers/media/common/tuners/xc5000.c               |    7 +
 drivers/media/dvb/Kconfig                          |    1 +
 drivers/media/dvb/Makefile                         |    2 +-
 drivers/media/dvb/bt8xx/bt878.h                    |    2 +-
 drivers/media/dvb/dvb-core/demux.h                 |    2 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |    2 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c        |    8 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |   17 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |    2 +-
 drivers/media/dvb/dvb-core/dvb_ringbuffer.c        |   78 +-
 drivers/media/dvb/dvb-core/dvb_ringbuffer.h        |   12 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |   15 +
 drivers/media/dvb/dvb-usb/Makefile                 |    3 +
 drivers/media/dvb/dvb-usb/anysee.c                 |  553 ++
 drivers/media/dvb/dvb-usb/anysee.h                 |  304 +
 drivers/media/dvb/dvb-usb/au6610.c                 |   83 +-
 drivers/media/dvb/dvb-usb/au6610.h                 |   22 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |  146 +-
 drivers/media/dvb/dvb-usb/cxusb.h                  |    3 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |    7 +-
 drivers/media/dvb/dvb-usb/dvb-usb-i2c.c            |    4 -
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    8 +
 drivers/media/dvb/dvb-usb/gl861.c                  |   38 +-
 drivers/media/dvb/dvb-usb/gl861.h                  |    2 +-
 drivers/media/dvb/frontends/au8522.c               |    1 -
 drivers/media/dvb/frontends/dvb-pll.c              |   47 +
 drivers/media/dvb/frontends/dvb-pll.h              |    1 +
 drivers/media/dvb/frontends/lgdt330x.c             |   24 +-
 drivers/media/dvb/frontends/s5h1409.c              |    1 -
 drivers/media/dvb/frontends/s5h1411.c              |    1 -
 drivers/media/dvb/frontends/tda10023.c             |  197 +-
 drivers/media/dvb/frontends/tda1002x.h             |   41 +-
 drivers/media/dvb/pluto2/pluto2.c                  |    2 +-
 drivers/media/dvb/siano/Kconfig                    |   26 +
 drivers/media/dvb/siano/Makefile                   |    8 +
 drivers/media/dvb/siano/sms-cards.c                |  102 +
 drivers/media/dvb/siano/sms-cards.h                |   45 +
 drivers/media/dvb/siano/smscoreapi.c               | 1251 ++++
 drivers/media/dvb/siano/smscoreapi.h               |  434 ++
 drivers/media/dvb/siano/smsdvb.c                   |  449 ++
 drivers/media/dvb/siano/smsusb.c                   |  459 ++
 drivers/media/dvb/ttpci/Kconfig                    |    2 +
 drivers/media/dvb/ttpci/Makefile                   |    7 +-
 drivers/media/dvb/ttpci/av7110.c                   |   47 +-
 drivers/media/dvb/ttpci/av7110.h                   |    1 -
 drivers/media/dvb/ttpci/av7110_av.c                |    2 +-
 drivers/media/dvb/ttpci/av7110_ca.c                |    2 +-
 drivers/media/dvb/ttpci/av7110_hw.h                |    3 -
 drivers/media/dvb/ttpci/budget-av.c                |   12 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   24 +
 drivers/media/dvb/ttpci/budget-core.c              |    4 -
 drivers/media/dvb/ttpci/budget-patch.c             |   44 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |   22 +-
 drivers/media/radio/radio-si470x.c                 |  483 +-
 drivers/media/video/Kconfig                        |  105 +-
 drivers/media/video/Makefile                       |    5 +
 drivers/media/video/bt819.c                        |    2 +-
 drivers/media/video/bt8xx/bt832.c                  |    1 -
 drivers/media/video/bt8xx/bttv-driver.c            |   51 +-
 drivers/media/video/bt8xx/bttv-i2c.c               |   49 +-
 drivers/media/video/bt8xx/bttv-vbi.c               |    6 +-
 drivers/media/video/bt8xx/bttv.h                   |    1 -
 drivers/media/video/bt8xx/bttvp.h                  |    9 +-
 drivers/media/video/cafe_ccic.c                    |   18 +-
 drivers/media/video/compat_ioctl32.c               |    1 +
 drivers/media/video/cs5345.c                       |    1 -
 drivers/media/video/cs53l32a.c                     |    2 -
 drivers/media/video/cx18/cx18-audio.c              |   15 +-
 drivers/media/video/cx18/cx18-av-audio.c           |   12 +-
 drivers/media/video/cx18/cx18-av-core.c            |  225 +-
 drivers/media/video/cx18/cx18-av-core.h            |   16 +-
 drivers/media/video/cx18/cx18-av-firmware.c        |   72 +-
 drivers/media/video/cx18/cx18-av-vbi.c             |  152 +-
 drivers/media/video/cx18/cx18-cards.c              |   89 +-
 drivers/media/video/cx18/cx18-cards.h              |    9 +
 drivers/media/video/cx18/cx18-controls.c           |  216 +-
 drivers/media/video/cx18/cx18-controls.h           |    7 +-
 drivers/media/video/cx18/cx18-driver.c             |   21 +-
 drivers/media/video/cx18/cx18-driver.h             |    7 +-
 drivers/media/video/cx18/cx18-firmware.c           |   10 +-
 drivers/media/video/cx18/cx18-gpio.c               |   90 +-
 drivers/media/video/cx18/cx18-gpio.h               |    2 +
 drivers/media/video/cx18/cx18-i2c.c                |   25 +-
 drivers/media/video/cx18/cx18-ioctl.c              | 1179 ++--
 drivers/media/video/cx18/cx18-ioctl.h              |    6 +-
 drivers/media/video/cx18/cx18-mailbox.c            |    1 +
 drivers/media/video/cx18/cx18-streams.c            |   12 +-
 drivers/media/video/cx18/cx23418.h                 |    5 +
 drivers/media/video/cx2341x.c                      |  180 +-
 drivers/media/video/cx23885/Kconfig                |    2 +
 drivers/media/video/cx23885/cx23885-417.c          |  701 +-
 drivers/media/video/cx23885/cx23885-cards.c        |   13 +
 drivers/media/video/cx23885/cx23885-core.c         |   10 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |   42 +
 drivers/media/video/cx23885/cx23885-video.c        |   24 +-
 drivers/media/video/cx23885/cx23885.h              |    1 +
 drivers/media/video/cx25840/cx25840-core.c         |  158 +-
 drivers/media/video/cx25840/cx25840-core.h         |    3 +-
 drivers/media/video/cx25840/cx25840-vbi.c          |  152 +-
 drivers/media/video/cx88/cx88-alsa.c               |    1 -
 drivers/media/video/cx88/cx88-blackbird.c          |   19 +-
 drivers/media/video/cx88/cx88-i2c.c                |    1 -
 drivers/media/video/cx88/cx88-video.c              |   24 +-
 drivers/media/video/cx88/cx88-vp3054-i2c.c         |    1 -
 drivers/media/video/em28xx/em28xx-cards.c          |   74 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |   25 +
 drivers/media/video/em28xx/em28xx-i2c.c            |    1 -
 drivers/media/video/em28xx/em28xx-input.c          |   87 +
 drivers/media/video/em28xx/em28xx-video.c          |   32 +-
 drivers/media/video/em28xx/em28xx.h                |   12 +
 drivers/media/video/gspca/Kconfig                  |   13 +
 drivers/media/video/gspca/Makefile                 |   29 +
 drivers/media/video/gspca/conex.c                  | 1051 +++
 drivers/media/video/gspca/etoms.c                  |  956 +++
 drivers/media/video/gspca/gspca.c                  | 1905 +++++
 drivers/media/video/gspca/gspca.h                  |  176 +
 drivers/media/video/gspca/jpeg.h                   |  301 +
 drivers/media/video/gspca/mars.c                   |  464 ++
 drivers/media/video/gspca/ov519.c                  | 2186 ++++++
 drivers/media/video/gspca/pac207.c                 |  622 ++
 drivers/media/video/gspca/pac7311.c                |  760 ++
 drivers/media/video/gspca/sonixb.c                 | 1477 ++++
 drivers/media/video/gspca/sonixj.c                 | 1671 +++++
 drivers/media/video/gspca/spca500.c                | 1216 ++++
 drivers/media/video/gspca/spca501.c                | 2229 ++++++
 drivers/media/video/gspca/spca505.c                |  951 +++
 drivers/media/video/gspca/spca506.c                |  847 +++
 drivers/media/video/gspca/spca508.c                | 1791 +++++
 drivers/media/video/gspca/spca561.c                | 1052 +++
 drivers/media/video/gspca/stk014.c                 |  592 ++
 drivers/media/video/gspca/sunplus.c                | 1677 +++++
 drivers/media/video/gspca/t613.c                   | 1038 +++
 drivers/media/video/gspca/tv8532.c                 |  670 ++
 drivers/media/video/gspca/vc032x.c                 | 1818 +++++
 drivers/media/video/gspca/zc3xx-reg.h              |  261 +
 drivers/media/video/gspca/zc3xx.c                  | 7623 ++++++++++++++++++++
 drivers/media/video/ir-kbd-i2c.c                   |   82 -
 drivers/media/video/ivtv/ivtv-cards.c              |   75 +-
 drivers/media/video/ivtv/ivtv-cards.h              |    3 +-
 drivers/media/video/ivtv/ivtv-controls.c           |  225 +-
 drivers/media/video/ivtv/ivtv-controls.h           |    6 +-
 drivers/media/video/ivtv/ivtv-driver.c             |   19 +-
 drivers/media/video/ivtv/ivtv-driver.h             |    1 -
 drivers/media/video/ivtv/ivtv-fileops.c            |   25 +-
 drivers/media/video/ivtv/ivtv-gpio.c               |   11 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    6 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              | 2184 +++---
 drivers/media/video/ivtv/ivtv-ioctl.h              |    9 +-
 drivers/media/video/ivtv/ivtv-streams.c            |    3 +-
 drivers/media/video/ivtv/ivtvfb.c                  |   86 +
 drivers/media/video/m52790.c                       |    1 -
 drivers/media/video/meye.c                         |   18 +-
 drivers/media/video/msp3400-driver.c               |    3 +-
 drivers/media/video/msp3400-kthreads.c             |    1 -
 drivers/media/video/mt9v022.c                      |    1 -
 drivers/media/video/ov7670.c                       |   28 +-
 drivers/media/video/ovcamchip/ovcamchip_core.c     |    1 -
 drivers/media/video/pvrusb2/pvrusb2-audio.c        |    1 -
 drivers/media/video/pvrusb2/pvrusb2-audio.h        |    1 -
 drivers/media/video/pvrusb2/pvrusb2-context.c      |    1 -
 drivers/media/video/pvrusb2/pvrusb2-context.h      |    1 -
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c         |    1 -
 drivers/media/video/pvrusb2/pvrusb2-ctrl.h         |    1 -
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c  |    1 -
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.h  |    1 -
 drivers/media/video/pvrusb2/pvrusb2-debug.h        |    1 -
 drivers/media/video/pvrusb2/pvrusb2-debugifc.c     |    1 -
 drivers/media/video/pvrusb2/pvrusb2-debugifc.h     |    1 -
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |   11 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.h      |    1 -
 drivers/media/video/pvrusb2/pvrusb2-eeprom.c       |    1 -
 drivers/media/video/pvrusb2/pvrusb2-eeprom.h       |    1 -
 drivers/media/video/pvrusb2/pvrusb2-encoder.c      |    1 -
 drivers/media/video/pvrusb2/pvrusb2-encoder.h      |    1 -
 drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h      |    1 -
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    1 -
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   75 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |    1 -
 .../media/video/pvrusb2/pvrusb2-i2c-chips-v4l2.c   |    1 -
 drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.c |    1 -
 drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.h |    1 -
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |    1 -
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.h     |    1 -
 drivers/media/video/pvrusb2/pvrusb2-io.c           |    1 -
 drivers/media/video/pvrusb2/pvrusb2-io.h           |    1 -
 drivers/media/video/pvrusb2/pvrusb2-ioread.c       |    1 -
 drivers/media/video/pvrusb2/pvrusb2-ioread.h       |    1 -
 drivers/media/video/pvrusb2/pvrusb2-main.c         |    1 -
 drivers/media/video/pvrusb2/pvrusb2-std.c          |    1 -
 drivers/media/video/pvrusb2/pvrusb2-std.h          |    1 -
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |  461 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.h        |    1 -
 drivers/media/video/pvrusb2/pvrusb2-tuner.c        |    1 -
 drivers/media/video/pvrusb2/pvrusb2-tuner.h        |    1 -
 drivers/media/video/pvrusb2/pvrusb2-util.h         |    1 -
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    1 -
 drivers/media/video/pvrusb2/pvrusb2-v4l2.h         |    1 -
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.c    |    1 -
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.h    |    1 -
 drivers/media/video/pvrusb2/pvrusb2-wm8775.c       |    1 -
 drivers/media/video/pvrusb2/pvrusb2-wm8775.h       |    1 -
 drivers/media/video/pvrusb2/pvrusb2.h              |    1 -
 drivers/media/video/pwc/pwc-ctrl.c                 |    2 -
 drivers/media/video/pwc/pwc-ioctl.h                |    1 -
 drivers/media/video/pxa_camera.c                   |   27 +-
 drivers/media/video/s2255drv.c                     | 2495 +++++++
 drivers/media/video/saa5246a.c                     |    1 +
 drivers/media/video/saa5249.c                      |    1 +
 drivers/media/video/saa6588.c                      |    1 -
 drivers/media/video/saa7115.c                      |    4 +-
 drivers/media/video/saa711x.c                      |  584 --
 drivers/media/video/saa7127.c                      |   43 +-
 drivers/media/video/saa7134/saa6752hs.c            |  105 +-
 drivers/media/video/saa7134/saa7134-alsa.c         |    4 -
 drivers/media/video/saa7134/saa7134-cards.c        |  181 +-
 drivers/media/video/saa7134/saa7134-core.c         |    1 -
 drivers/media/video/saa7134/saa7134-dvb.c          |   10 +
 drivers/media/video/saa7134/saa7134-empress.c      |   86 +-
 drivers/media/video/saa7134/saa7134-i2c.c          |    2 +
 drivers/media/video/saa7134/saa7134-input.c        |   81 +
 drivers/media/video/saa7134/saa7134-reg.h          |    1 +
 drivers/media/video/saa7134/saa7134-tvaudio.c      |   35 +-
 drivers/media/video/saa7134/saa7134-video.c        |   82 +-
 drivers/media/video/saa7134/saa7134.h              |    6 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |  657 ++
 drivers/media/video/sn9c102/sn9c102_devtable.h     |    2 -
 drivers/media/video/soc_camera.c                   |   64 +-
 drivers/media/video/soc_camera_platform.c          |  198 +
 drivers/media/video/stk-webcam.c                   |   18 +-
 drivers/media/video/tcm825x.c                      |    6 +
 drivers/media/video/tcm825x.h                      |    1 +
 drivers/media/video/tda7432.c                      |    1 +
 drivers/media/video/tda9840.c                      |    1 +
 drivers/media/video/tda9875.c                      |    2 +-
 drivers/media/video/tea6415c.c                     |    1 +
 drivers/media/video/tea6420.c                      |    1 +
 drivers/media/video/tlv320aic23b.c                 |    1 -
 drivers/media/video/tuner-core.c                   |    1 -
 drivers/media/video/tvaudio.c                      |   13 -
 drivers/media/video/usbvision/usbvision-core.c     |    4 -
 drivers/media/video/usbvision/usbvision-i2c.c      |    5 -
 drivers/media/video/usbvision/usbvision-video.c    |   30 +-
 drivers/media/video/uvc/Kconfig                    |   17 +
 drivers/media/video/uvc/uvc_ctrl.c                 |    1 +
 drivers/media/video/uvc/uvc_driver.c               |   31 +-
 drivers/media/video/uvc/uvc_queue.c                |    1 +
 drivers/media/video/uvc/uvc_status.c               |   20 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |    3 +-
 drivers/media/video/uvc/uvc_video.c                |  117 +-
 drivers/media/video/uvc/uvcvideo.h                 |    3 +
 drivers/media/video/videobuf-dma-contig.c          |  418 ++
 drivers/media/video/videobuf-dma-sg.c              |    8 +-
 drivers/media/video/videobuf-dvb.c                 |    2 -
 drivers/media/video/videobuf-vmalloc.c             |    2 +-
 drivers/media/video/videodev.c                     |  735 ++-
 drivers/media/video/vivi.c                         |   37 +-
 drivers/media/video/vp27smpx.c                     |    1 -
 drivers/media/video/wm8739.c                       |    1 -
 drivers/media/video/wm8775.c                       |    2 -
 drivers/media/video/zoran_card.c                   |   34 +-
 drivers/media/video/zoran_driver.c                 |    5 +-
 drivers/media/video/zr364xx.c                      |   16 +-
 include/linux/i2c-id.h                             |    8 -
 include/linux/videodev2.h                          |   14 +
 include/media/cx2341x.h                            |    7 +-
 include/media/ir-kbd-i2c.h                         |    3 -
 include/media/pwc-ioctl.h                          |    3 +-
 include/media/saa7146.h                            |    4 +-
 include/media/sh_mobile_ceu.h                      |   12 +
 include/media/soc_camera.h                         |   16 +-
 include/media/soc_camera_platform.h                |   15 +
 include/media/v4l2-dev.h                           |   83 +-
 include/media/v4l2-i2c-drv-legacy.h                |    1 -
 include/media/videobuf-dma-contig.h                |   32 +
 include/media/videobuf-dma-sg.h                    |    2 +-
 include/media/videobuf-vmalloc.h                   |    2 +-
 290 files changed, 47416 insertions(+), 5196 deletions(-)
 create mode 100644 Documentation/video4linux/gspca.txt
 create mode 100644 drivers/media/dvb/dvb-usb/anysee.c
 create mode 100644 drivers/media/dvb/dvb-usb/anysee.h
 create mode 100644 drivers/media/dvb/siano/Kconfig
 create mode 100644 drivers/media/dvb/siano/Makefile
 create mode 100644 drivers/media/dvb/siano/sms-cards.c
 create mode 100644 drivers/media/dvb/siano/sms-cards.h
 create mode 100644 drivers/media/dvb/siano/smscoreapi.c
 create mode 100644 drivers/media/dvb/siano/smscoreapi.h
 create mode 100644 drivers/media/dvb/siano/smsdvb.c
 create mode 100644 drivers/media/dvb/siano/smsusb.c
 create mode 100644 drivers/media/video/gspca/Kconfig
 create mode 100644 drivers/media/video/gspca/Makefile
 create mode 100644 drivers/media/video/gspca/conex.c
 create mode 100644 drivers/media/video/gspca/etoms.c
 create mode 100644 drivers/media/video/gspca/gspca.c
 create mode 100644 drivers/media/video/gspca/gspca.h
 create mode 100644 drivers/media/video/gspca/jpeg.h
 create mode 100644 drivers/media/video/gspca/mars.c
 create mode 100644 drivers/media/video/gspca/ov519.c
 create mode 100644 drivers/media/video/gspca/pac207.c
 create mode 100644 drivers/media/video/gspca/pac7311.c
 create mode 100644 drivers/media/video/gspca/sonixb.c
 create mode 100644 drivers/media/video/gspca/sonixj.c
 create mode 100644 drivers/media/video/gspca/spca500.c
 create mode 100644 drivers/media/video/gspca/spca501.c
 create mode 100644 drivers/media/video/gspca/spca505.c
 create mode 100644 drivers/media/video/gspca/spca506.c
 create mode 100644 drivers/media/video/gspca/spca508.c
 create mode 100644 drivers/media/video/gspca/spca561.c
 create mode 100644 drivers/media/video/gspca/stk014.c
 create mode 100644 drivers/media/video/gspca/sunplus.c
 create mode 100644 drivers/media/video/gspca/t613.c
 create mode 100644 drivers/media/video/gspca/tv8532.c
 create mode 100644 drivers/media/video/gspca/vc032x.c
 create mode 100644 drivers/media/video/gspca/zc3xx-reg.h
 create mode 100644 drivers/media/video/gspca/zc3xx.c
 create mode 100644 drivers/media/video/s2255drv.c
 delete mode 100644 drivers/media/video/saa711x.c
 create mode 100644 drivers/media/video/sh_mobile_ceu_camera.c
 create mode 100644 drivers/media/video/soc_camera_platform.c
 create mode 100644 drivers/media/video/uvc/Kconfig
 create mode 100644 drivers/media/video/videobuf-dma-contig.c
 create mode 100644 include/media/sh_mobile_ceu.h
 create mode 100644 include/media/soc_camera_platform.h
 create mode 100644 include/media/videobuf-dma-contig.h

Adrian Bunk (1):
      V4L/DVB (7882): pvrusb2: make code static

Akinobu Mita (1):
      V4L/DVB (8251): ttusb: use simple_read_from_buffer()()

Al Viro (10):
      V4L/DVB (8126): net endianness fix
      V4L/DVB (8128): saa7146: ->cpu_addr and friends are little-endian
      V4L/DVB (8129): pluto_set_dma_addr() fix
      V4L/DVB (8130): split dvb_ringbuffer dual-use functions
      V4L/DVB (8131): dmx_write: memcpy from user-supplied pointer
      V4L/DVB (8132): bt8xx endianness annotations and fixes
      V4L/DVB (8133): cx23885 endianness fixes
      V4L/DVB (8134): zoran annotations and fixes
      V4L/DVB (8135): WRITE_RPS1() converts to le32 itself
      V4L/DVB (8136): xc2028 unaligned access fixes

Andoni Zubimendi (6):
      V4L/DVB (8205): gspca: Size of frame header adjusted according to sn9c10x in sonixb.
      V4L/DVB (8349): gspca: SN9C103 OV7630 fixes in sonixb.
      V4L/DVB (8353): gspca: 640x480 for bridge sn9c103 / sensor ov7630.
      V4L/DVB (8360): gspca: Bad initialization of sn9c103 - ov7630.
      V4L/DVB (8361): gspca: Bad check of i2c write to sn9c10x.
      V4L/DVB (8367): gspca: Light frequency filter / exposure / clean-up for sn9c103 ov7630.

Andrew Morton (1):
      V4L/DVB (8256): uvc/uvc_v4l2.c: suppress uninitialized var warning

Andy Walls (6):
      V4L/DVB (8082): cx18: convert to video_ioctl2()
      V4L/DVB (8114): cx18: Improve Raptor card audio input routing defintions
      V4L/DVB (8188): cx18: Add missing reset recovery delay in cx18-i2c.c
      V4L/DVB (8189): cx18: Use correct GPIO pin for resetting Xceive 3028 tuner on Yuan MPC718
      V4L/DVB (8331): cx18: Add locking for struct cx18 GPIO state variables
      V4L/DVB (8332): cx18: Suport external reset of the Z8F0811 IR controller on HVR-1600 for lirc

Antti Palosaari (10):
      V4L/DVB (7912): TDA10023: make few parameters configurable
      V4L/DVB (7913): DVB-PLL: add Samsung DTOS403IH102A tuner
      V4L/DVB (7914): Anysee: driver for Anysee DVB-T/C receiver
      V4L/DVB (7950): AU6610: coding style fixes
      V4L/DVB (7951): AU6610: remove useless identify_state
      V4L/DVB (7952): AU6610: various cosmetic changes
      V4L/DVB (8014): gl861: coding style fixes
      V4L/DVB (8030): TDA10023: make TS output mode configurable
      V4L/DVB (8031): Anysee: support for Anysee E30C Plus rev 0.4
      V4L/DVB (8032): Anysee: fix Kconfig

Brandon Philips (1):
      V4L/DVB (8389): videodev: simplify get_index()

Carl Karsten (1):
      V4L/DVB (8023): vivi: announce that it is registered as /dev/video%d

Christophe Jaillet (1):
      V4L/DVB (8252): buf-dma-sg.c: avoid clearing memory twice

Dan Taylor (1):
      V4L/DVB (8117): saa7134: Avermedia A16D composite input

Daniel Drake (1):
      V4L/DVB (8318): OV7670: don't reject unsupported settings

Daniel Gimpelevich (2):
      V4L/DVB (8124): Add LifeVideo To-Go Cardbus PCI ID
      V4L/DVB (8147): cxusb: add initial support for AVerTVHD Volar

David Howells (1):
      V4L/DVB (8249): Fix pointer cast warnings in the ivtv framebuffer driver

Dean Anderson (2):
      V4L/DVB (8125): This driver adds support for the Sensoray 2255 devices.
      V4L/DVB (8317): Sensoray 2255 V4l driver checkpatch fixes

Devin Heitmueller (3):
      V4L/DVB (7992): Add support for Pinnacle PCTV HD Pro stick (the older variant 2304:0227)
      V4L/DVB (8006): em28xx: Split HVR900 into two separate entries
      V4L/DVB (8123): Add support for em2860 based PointNix Intra-Oral Camera

Dmitri Belimov (1):
      V4L/DVB (7976): I2S on for MPEG of saa7134_empress

Dmitry Belimov (2):
      V4L/DVB (8019): New for I2S on for MPEG of saa7134_empress
      V4L/DVB (8021): Beholder's cards description

Douglas Schilling Landgraf (2):
      V4L/DVB (8120): cx23885-417: Replace cx23885_do_ioctl to use video_ioctl2
      V4L/DVB (8184): spca508: Add Clone Digital Webcam 11043

Hans Verkuil (47):
      V4L/DVB (7926): ivtv: add support for the Buffalo PC-MV5L/PCI card.
      V4L/DVB (7927): ivtv: simplify gpio initialization for XCeive tuners.
      V4L/DVB (7946): videodev: small fixes for VIDIOC_G_FREQUENCY and VIDIOC_G_FMT
      V4L/DVB (7947): videodev: add vidioc_g_std callback.
      V4L/DVB (7948): videodev: add missing vidioc_try_fmt_sliced_vbi_output and VIDIOC_ENUMOUTPUT handling
      V4L/DVB (7949): videodev: renamed the vidioc_*_fmt_* callbacks
      V4L/DVB (7988): soc_camera: missed fmt callback conversion.
      V4L/DVB (8079): ivtv: Convert to video_ioctl2.
      V4L/DVB (8080): ivtv: make sure all v4l2_format fields are filled in
      V4L/DVB (8081): ivtv: remove obsolete arrays.
      V4L/DVB (8083): videodev: zero fields for ENCODER_CMD and VIDIOC_G_SLICED_VBI_CAP
      V4L/DVB (8084): ivtv/cx18: remove unnecessary memsets & KERNEL_VERSION tests
      V4L/DVB (8085): ivtv: fill in all v4l2_framebuffer fields in VIDIOC_G/S_FBUF
      V4L/DVB (8086): ivtv/cx18: fix video_temporal_filter handling
      V4L/DVB (8087): cx18: make sure all v4l2_format fields are filled in
      V4L/DVB (8091): cx18: show GPIO pins when VIDIOC_LOG_STATUS is called.
      V4L/DVB (8093): cx18: fix prefix typo
      V4L/DVB (8103): videodev: fix/improve ioctl debugging
      V4L/DVB (8104): cx18/ivtv: ioctl debugging improvements
      V4L/DVB (8105): cx2341x: add TS capability
      V4L/DVB (8106): ivtv/cx18: improve tuner std check in card definitions.
      V4L/DVB (8107): cx18: improve support for the Raptor board.
      V4L/DVB (8111): ivtv/cx18: fix compile error when CONFIG_VIDEO_ADV_DEBUG is not defined.
      V4L/DVB (8112): videodev: improve extended control support in video_ioctl2()
      V4L/DVB (8113): ivtv/cx18: remove s/g_ctrl, now all controls are handled through s/g_ext_ctrl
      V4L/DVB (8116): videodev: allow PRIVATE_BASE controls when called through VIDIOC_G/S_CTRL.
      V4L/DVB (8151): saa7134-empress: fix MPEG control support
      V4L/DVB (8162): cx18: fix PAL/SECAM support
      V4L/DVB (8164): cx18/ivtv: choose a better initial TV standard for cards without eeprom.
      V4L/DVB (8165): cx18: fix v4l-cx23418-dig.fw firmware load.
      V4L/DVB (8167): cx18: set correct audio inputs for tuner and line-in 2.
      V4L/DVB (8168a): cx18: Update cx18 documentation.
      V4L/DVB (8168): cx18: Upgrade to newer firmware & update cx18 documentation.
      V4L/DVB (8169): cx18: enable TS support
      V4L/DVB (8171): ivtv: put back full device name, people relied on it in udev rules.
      V4L/DVB (8173): saa711x.c: remove obsolete file.
      v4l-dvb: remove legacy checks to allow support for kernels < 2.6.10
      V4L/DVB (8376): cx25840: move cx25840_vbi_setup to core.c and rename to cx25840_std_setup
      V4L/DVB (8377): ivtv/cx18: ensure the default control values are correct
      V4L/DVB (8378): cx18: move cx18_av_vbi_setup to av-core.c and rename to cx18_av_std_setup
      V4L/DVB (8380): saa7115: use saa7115_auto instead of saa711x as the autodetect driver name.
      V4L/DVB (8381): ov7670: fix compile warnings
      V4L/DVB (8387): Some cosmetic changes
      V4L/DVB (8390): videodev: add comment and remove magic number.
      V4L/DVB (8410): sh_mobile_ceu_camera: fix 64-bit compiler warnings
      V4L/DVB (8411): videobuf-dma-contig.c: fix 64-bit build for pre-2.6.24 kernels
      V4L/DVB (8414): videodev/cx18: fix get_index bug and error-handling lock-ups

Hans de Goede (19):
      V4L/DVB (8153): Subdriver pac207 added and minor changes.
      V4L/DVB (8191): gspca: Make CONFIG_VIDEO_ADV_DEBUG actually work.
      V4L/DVB (8192): Try to fix a reg_w() bug
      V4L/DVB (8194): gspca: Fix the format of the low resolution mode of spca561.
      V4L/DVB (8196): gspca: Correct sizeimage in vidioc_s/try/g_fmt_cap
      V4L/DVB (8197): gspca: pac207 frames no more decoded in the subdriver.
      V4L/DVB (8198): gspca: Frame decoding errors when PAC207 in full daylight.
      V4L/DVB (8202): gspca: PAC207 frames may be not compressed.
      V4L/DVB (8348): gspca: Add auto gain/exposure to sonixb and tas5110 / ov6650 sensors.
      V4L/DVB (8354): gspca: Better gain for bridge sn9c10x - sensor ov6650.
      V4L/DVB (8356): gspca: 352x288 mode fix and source clean-up for Sonix bridges.
      V4L/DVB (8357): gspca: Perfect exposure for sn9c10x, sensor ov6650.
      V4L/DVB (8362): gspca: Bad offset of the brightness sum in sn9c103 packets.
      V4L/DVB (8363): gspca: Bad image size with spca501.
      V4L/DVB (8364): gspca: Support of powerline frequency for ov6650.
      V4L/DVB (8366): gspca: Better code for ov6650 and ov7630.
      V4L/DVB (8372): gspca: Small ov6650 fixes.
      V4L/DVB (8373): gspca: Hue, saturation and contrast controls added for sn9c10x ovxxxx.
      V4L/DVB (8374): gspca: No conflict of 0c45:6011 with the sn9c102 driver.

Harvey Harrison (2):
      V4L/DVB (7586): radio: use get/put_unaligned_* helpers
      V4L/DVB (8199): gspca: Compile warnings about NULL ptr.

Hermann Pitton (1):
      V4L/DVB (8319): saa7134: Add support for analog only ASUSTeK P7131

Huang Weiyi (1):
      V4L/DVB (8095): zoran_driver.c: Removed duplicated include

Ian Armstrong (3):
      V4L/DVB (7886): ivtvfb: Use DMA for write()
      V4L/DVB (8088): ivtv: yuv decoder lock fix
      V4L/DVB (8090): ivtv: yuv decoder lock fix (2)

Jean Delvare (8):
      V4L/DVB (7924): ivtv/cx18: snprintf fixes
      V4L/DVB (8046): zoran: i2c structure templates clean-up
      V4L/DVB (8047): bt8xx: i2c structure templates clean-up
      V4L/DVB (8245): ovcamchip: Delete stray I2C bus ID
      V4L/DVB (8246): tvaudio: Stop I2C driver ID abuse
      V4L/DVB (8315): zr36067: Delete dead code
      V4L/DVB (8316): bt819: Fix a debug message
      V4L/DVB (8379): saa7127: Make device detection optional

Jean-Francois Moine (21):
      V4L/DVB (8152): Initial release of gspca with only one driver.
      V4L/DVB (8154): Fix protection problems in the main driver.
      V4L/DVB (8156): Many bug fixes, zc3xx added.
      V4L/DVB (8157): gspca: all subdrivers
      V4L/DVB (8158): gspca: minor changes
      V4L/DVB (8180): Source cleanup - compile error with VIDEO_ADV_DEBUG.
      V4L/DVB (8181): gspca: read() did not work (loop in kernel, timeout...)
      V4L/DVB (8193): gspca: Input buffer may be changed on reg write.
      V4L/DVB (8195): gspca: Input buffer overwritten in spca561 + cleanup code.
      V4L/DVB (8201): gspca: v4l2_pix_format in each subdriver.
      V4L/DVB (8204): gspca: Cleanup code.
      V4L/DVB (8231): gspca: Do not declare the webcams declared by other drivers.
      V4L/DVB (8232): gspca: Change the USERPTR mechanism.
      V4L/DVB (8346): gspca: Bad pixel format of bridge VC0321.
      V4L/DVB (8350): gspca: Conform to v4l2 spec and mutex unlock fix.
      V4L/DVB (8352): gspca: Buffers for USB exchanges cannot be in the stack.
      V4L/DVB (8358): gspca: Better initialization of sn9c120 - ov7660.
      V4L/DVB (8369): gspca: Bad initialization of sn9c102 ov7630.
      V4L/DVB (8370): gspca: Webcam 0461:0821 added.
      V4L/DVB (8371): gspca: Webcam 08ca:2050 added.
      V4L/DVB (8415): gspca: Infinite loop in i2c_w() of etoms.

Laurent Pinchart (7):
      V4L/DVB (8207): uvcvideo: Fix a buffer overflow in format descriptor parsing
      V4L/DVB (8208): uvcvideo: Use GFP_NOIO when allocating memory during resume
      V4L/DVB (8209): uvcvideo: Don't free URB buffers on suspend.
      V4L/DVB (8234): uvcvideo: Make input device support optional
      V4L/DVB (8235): uvcvideo : Add support for Medion Akoya Mini E1210 integrated webcam
      V4L/DVB (8254): uvcvideo : Add support for Asus F9GS integrated webcam
      V4L/DVB (8257): uvcvideo: Fix possible AB-BA deadlock with videodev_lock and open_mutex

Magnus Damm (6):
      V4L/DVB (8338): soc_camera: Move spinlocks
      V4L/DVB (8339): soc_camera: Add 16-bit bus width support
      V4L/DVB (8340): videobuf: Fix gather spelling
      V4L/DVB (8341): videobuf: Add physically contiguous queue code V3
      V4L/DVB (8342): sh_mobile_ceu_camera: Add SuperH Mobile CEU driver V3
      V4L/DVB (8343): soc_camera_platform: Add SoC Camera Platform driver

Massimo Piccioni (1):
      V4L/DVB (8244): saa7134: add support for AVerMedia M103

Mauro Carvalho Chehab (17):
      V4L/DVB (8024): vivi: rename MODULE_NAME macro to VIVI_MODULE_NAME to avoid namespace conflicts
      V4L/DVB (8050): Add register get/set debug ioctls to saa7134
      V4L/DVB (8051): ttpci/Kconfig: Technotrend budget C-1501 needs tda10023
      V4L/DVB (8059): Add missing select for MEDIA_TUNER_TDA827X
      V4L/DVB (8065): Add missing selects at dvb-usb/Kconfig
      V4L/DVB (8110): bttv: allow debug ioctl's
      V4L/DVB (8142): ttpci: tda827x.h is at drivers/media/common
      V4L/DVB (8143): Fix compilation for mt9v022
      V4L/DVB (8161): gspca: Fix compilation
      V4L/DVB (8253): gspca: fix warnings on x86_64
      V4L/DVB (8359): gspca: Adds register aliases for zc03xx registers
      V4L/DVB (8392): media/Kconfig: Convert V4L1_COMPAT select into "depends on"
      V4L/DVB (8393): media/video: Fix depencencies for VIDEOBUF
      V4L/DVB (8394): ir-common: CodingStyle fix: move EXPORT_SYMBOL_GPL to their proper places
      V4L/DVB (8395): saa7134: Fix Kbuild dependency of ir-kbd-i2c
      V4L/DVB (8396): video: Fix Kbuild dependency for VIDEO_IR_I2C
      V4L/DVB (8397): video: convert select VIDEO_ZORAN_ZR36060 into depends on

Michael Krufky (58):
      V4L/DVB (7883): pvrusb2: make default frequency configurable via modprobe option
      V4L/DVB (7917): au8522.c shouldn't #include "dvb-pll.h"
      V4L/DVB (7920): s5h1409.c shouldn't #include "dvb-pll.h"
      V4L/DVB (7921): s5h1411.c shouldn't #include "dvb-pll.h"
      V4L/DVB (7984): tda18271: update filename in comments
      V4L/DVB (7986): cx23885: add initial support for DViCO FusionHDTV7 Dual Express
      V4L/DVB (8060): Kconfig: MEDIA_TUNER_CUSTOMIZE should be disabled by default
      V4L/DVB (8098): xc5000: add module option to load firmware during driver attach
      V4L/DVB (8146): lgdt330x: add additional FEC control configuration option
      V4L/DVB (8183): cxusb: select MEDIA_TUNER_MXL5005S if !DVB_FE_CUSTOMISE
      V4L/DVB (8186): dib0700: add support for Hauppauge Nova-TD Stick 52009
      V4L/DVB (8236): cx23885: add support for new revision of FusionHDTV7 Dual Express
      V4L/DVB (8258): add support for SMS1010 and SMS1150 based digital television devices
      V4L/DVB (8259): sms1xxx: pass adapter_nr into dvb_register_adapter
      V4L/DVB (8260): sms1xxx: build fixes
      V4L/DVB (8272): sms1xxx: move driver from media/mdtv/ to media/dvb/siano/
      V4L/DVB (8273): sms1xxx: replace __FUNCTION__ with __func__
      V4L/DVB (8274): sms1xxx: build cleanup after driver relocation
      V4L/DVB (8275): sms1xxx: codingstyle cleanup: "foo* bar"/"foo * bar" should be "foo *bar"
      V4L/DVB (8276): sms1xxx: codingstyle cleanup: "(foo*)" should be "(foo *)"
      V4L/DVB (8277): sms1xxx: update latest siano drop to 1.2.17
      V4L/DVB (8278): sms1xxx: more codingstyle cleanups
      V4L/DVB (8279): sms1xxx: #define usb vid:pid's
      V4L/DVB (8280): sms1xxx: more codingstyle cleanups
      V4L/DVB (8281): sms1xxx: remove INT / UINT typedefs
      V4L/DVB (8282): sms1xxx: more codingstyle cleanups
      V4L/DVB (8283): sms1xxx: 80-column cleanups
      V4L/DVB (8284): sms1xxx: fix WARNING: printk() should include KERN_ facility level
      V4L/DVB (8285): sms1xxx: more 80-column cleanups
      V4L/DVB (8286): sms1xxx: remove typedefs
      V4L/DVB (8287): sms1xxx: fix WARNING: unnecessary cast may hide bugs
      V4L/DVB (8288): sms1xxx: more cleanups
      V4L/DVB (8289): sms1xxx: remove #if LINUX_VERSION_CODE checks
      V4L/DVB (8290): sms1xxx: small cleanup
      V4L/DVB (8291): sms1xxx: change default_mode to 4
      V4L/DVB (8292): sms1xxx: add code to allow device-specific functionality
      V4L/DVB (8293): sms1xxx: create printk macros
      V4L/DVB (8294): sms1xxx: move message formatting into printk macros
      V4L/DVB (8295): sms1xxx: add debug module option, to enable debug messages
      V4L/DVB (8296): sms1xxx: always show error messages
      V4L/DVB (8297): sms1xxx: remove old printk macros
      V4L/DVB (8298): sms1xxx: remove redundant __func__ in sms_err macro
      V4L/DVB (8299): sms1xxx: mark functions static
      V4L/DVB (8300): sms1xxx: simplify smsusb_init_device switch..case block
      V4L/DVB (8301): sms1xxx: add capability to define device-specific firmware filenames
      V4L/DVB (8302): sms1xxx: fix Siano board names
      V4L/DVB (8303): sms1xxx: update MODULE_DESCRIPTION
      V4L/DVB (8305): sms1xxx: fix warning: format '%d' expects type 'int', but argument x has type 'size_t'
      V4L/DVB (8306): sms1xxx: log firmware download process by default
      V4L/DVB (8307): sms1xxx: change smsusb_driver.name to sms1xxx
      V4L/DVB (8308): sms1xxx: Provide option to support Siano default usb ids
      V4L/DVB (8309): sms1xxx: fix OOPS on 64 bit kernels due to a bad cast
      V4L/DVB (8310): sms1xxx: remove kmutex_t typedef
      V4L/DVB (8311): sms1xxx: support device-specific firmware filenames on stellar usb1 sticks
      V4L/DVB (8312): sms1xxx: add firmware filenames to board properties for stellar and nova
      V4L/DVB (8313): sms1xxx: add support for Hauppauge WinTV-Nova-T-MiniStick
      V4L/DVB (8322): sms1xxx: fix improper usage of asm/foo.h
      V4L/DVB (8326): sms1xxx: fix missing #include <linux/types.h>

Mike Isely (6):
      V4L/DVB (7936): pvrusb2: Remove svn Id keyword from all sources
      V4L/DVB (7937): pvrusb2: Change several embedded timer constants to defined values
      V4L/DVB (7938): pvrusb2: Increase enforced encoder wait delay to improve reliability
      V4L/DVB (7939): pvrusb2: Remove sysfs interface hackery
      V4L/DVB (8175): pvrusb2: Fix misleading source code comment
      V4L/DVB (8176): pvrusb2: Update video_gop_size

Oliver Endriss (4):
      V4L/DVB (8072): av7110: Removed some obsolete definitions and one unused variable
      V4L/DVB (8076): budget-ci: Support the bundled remote control of the TT DVB-C 1501
      V4L/DVB (8334): tda10023: Fix typo in tda10023_attach dummy routine
      V4L/DVB (8335): dvb-ttpci: Fix build with CONFIG_INPUT_EVDEV=n (Bug #11042)

Paulius Zaleckas (1):
      V4L/DVB (8337): soc_camera: make videobuf independent

Sakari Ailus (1):
      V4L/DVB (7897): TCM825x: Include invertation of image mirroring in configuration

Sigmund Augdal (1):
      V4L/DVB (8049): budget-ci: Add support for Technotrend budget C-1501 dvb-c card

Sri Deevi (1):
      V4L/DVB (8089): cx18: add support for Conexant Raptor PAL/SECAM card

Steven Toth (11):
      V4L/DVB (8261): sms1xxx: remove smsnet.o
      V4L/DVB (8262): sms1xxx: remove smschar.o
      V4L/DVB (8263): sms1xxx: merge ksyms
      V4L/DVB (8264): sms1xxx: remove smstypes.h
      V4L/DVB (8265): sms1xxx: Kconfig / Makefile cleanups
      V4L/DVB (8266): sms1xxx: merge modules
      V4L/DVB (8267): sms1xxx: Makefile cleanup
      V4L/DVB (8268): sms1xxx: usb cleanup
      V4L/DVB (8269): sms1xxx: copyrights
      V4L/DVB (8270): sms1xxx: header include cleanups and unexport symbols
      V4L/DVB (8271): sms1xxx: usbvid table

Tim Farrington (1):
      V4L/DVB (8149): Avermedia E506 composite

Tobias Lorenz (6):
      V4L/DVB (7942): Hardware frequency seek ioctl interface
      V4L/DVB (7993): si470x: move global lock to device structure
      V4L/DVB (7994): si470x: let si470x_get_freq return errno
      V4L/DVB (7995): si470x: a lot of small code cleanups
      V4L/DVB (7996): si470x: afc indication
      V4L/DVB (7997): si470x: hardware frequency seek support

brandon@ifup.org (1):
      V4L/DVB (8078): Introduce "index" attribute for persistent video4linux device nodes

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
