Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m84NoZOf029401
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 19:50:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m84NoM1f013001
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 19:50:22 -0400
Date: Thu, 4 Sep 2008 20:49:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080904204954.4a32485b@mchehab.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.27] V4L/DVB fixes
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
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git fixes

This time, it took a long period since my last pull. Due to that, 
there are 97 patches pending. This is due to some review I did on my 
git scripts, and a job change.

Most of the patches are trivial ones. The big changes happens on gspca 
driver that is new for 2.6.27, fixing support for several webcams.

A briefing of the patch series:

   - improvements and fixes at au8522/au0828 (new driver);
   - gspca: several important fixes, and a few models added;
   - Some fixes at V4L core;
   - ivtv: some fixes on closed caption;
   - miropcm20 radio were removed. It weren't being building for a 
     long time (1,5 years ago it were removed on Kconfig);
   - cx18: Queue handling were changed to prevend OOPS;
   - several other fixes at the drivers.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.au0828      |    1 +
 Documentation/video4linux/gspca.txt            |   29 +-
 drivers/media/common/saa7146_video.c           |    4 +-
 drivers/media/common/tuners/mt2131.c           |    2 +-
 drivers/media/common/tuners/mt2131.h           |    2 +-
 drivers/media/common/tuners/mt2131_priv.h      |    2 +-
 drivers/media/common/tuners/mxl5005s.c         |    4 +-
 drivers/media/common/tuners/mxl5005s.h         |    2 +-
 drivers/media/common/tuners/tuner-simple.c     |   33 +-
 drivers/media/common/tuners/xc5000.c           |    2 +-
 drivers/media/common/tuners/xc5000.h           |    2 +-
 drivers/media/common/tuners/xc5000_priv.h      |    2 +-
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c      |    3 +-
 drivers/media/dvb/b2c2/flexcop-i2c.c           |   12 +-
 drivers/media/dvb/bt8xx/dst.c                  |    4 +-
 drivers/media/dvb/dvb-core/dmxdev.c            |    1 -
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c    |    4 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c      |    8 +-
 drivers/media/dvb/dvb-usb/cxusb.c              |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c    |    9 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h        |    1 +
 drivers/media/dvb/frontends/au8522.c           |   47 +-
 drivers/media/dvb/frontends/au8522.h           |   11 +-
 drivers/media/dvb/frontends/cx22702.c          |    2 +-
 drivers/media/dvb/frontends/cx22702.h          |    2 +-
 drivers/media/dvb/frontends/cx24123.c          |    6 +-
 drivers/media/dvb/frontends/cx24123.h          |    2 +-
 drivers/media/dvb/frontends/s5h1409.c          |    3 +-
 drivers/media/dvb/frontends/s5h1409.h          |    2 +-
 drivers/media/dvb/frontends/s5h1411.c          |    3 +-
 drivers/media/dvb/frontends/s5h1411.h          |    2 +-
 drivers/media/dvb/frontends/s5h1420.c          |    3 +-
 drivers/media/dvb/frontends/tda10048.c         |    4 +-
 drivers/media/dvb/frontends/tda10048.h         |    2 +-
 drivers/media/dvb/siano/sms-cards.c            |    2 +-
 drivers/media/dvb/siano/sms-cards.h            |    2 +-
 drivers/media/dvb/siano/smscoreapi.c           |    2 +-
 drivers/media/dvb/siano/smscoreapi.h           |    2 +-
 drivers/media/dvb/siano/smsdvb.c               |    2 +-
 drivers/media/dvb/siano/smsusb.c               |    2 +-
 drivers/media/dvb/ttpci/budget-patch.c         |    3 +-
 drivers/media/dvb/ttpci/budget.c               |    3 +-
 drivers/media/radio/Makefile                   |    4 -
 drivers/media/radio/dsbr100.c                  |    2 +-
 drivers/media/radio/miropcm20-radio.c          |  266 ------
 drivers/media/radio/miropcm20-rds-core.c       |  211 -----
 drivers/media/radio/miropcm20-rds-core.h       |   19 -
 drivers/media/radio/miropcm20-rds.c            |  136 ---
 drivers/media/radio/radio-aimslab.c            |    3 +-
 drivers/media/radio/radio-aztech.c             |    3 +-
 drivers/media/radio/radio-cadet.c              |    2 +-
 drivers/media/radio/radio-gemtek-pci.c         |    2 +-
 drivers/media/radio/radio-gemtek.c             |    3 +-
 drivers/media/radio/radio-maestro.c            |    3 +-
 drivers/media/radio/radio-maxiradio.c          |   28 +-
 drivers/media/radio/radio-rtrack2.c            |    3 +-
 drivers/media/radio/radio-sf16fmi.c            |    2 +-
 drivers/media/radio/radio-si470x.c             |    4 +-
 drivers/media/radio/radio-terratec.c           |    3 +-
 drivers/media/radio/radio-trust.c              |    3 +-
 drivers/media/radio/radio-zoltrix.c            |    3 +-
 drivers/media/video/Makefile                   |    4 +-
 drivers/media/video/au0828/Kconfig             |    1 +
 drivers/media/video/au0828/au0828-cards.c      |    9 +-
 drivers/media/video/au0828/au0828-cards.h      |    3 +-
 drivers/media/video/au0828/au0828-core.c       |    4 +-
 drivers/media/video/au0828/au0828-dvb.c        |   25 +-
 drivers/media/video/au0828/au0828-i2c.c        |    2 +-
 drivers/media/video/au0828/au0828-reg.h        |    2 +-
 drivers/media/video/au0828/au0828.h            |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c         |   73 +-
 drivers/media/video/bt8xx/bttv-driver.c        |    1 -
 drivers/media/video/bt8xx/bttv-risc.c          |    3 +-
 drivers/media/video/bt8xx/bttvp.h              |    5 +
 drivers/media/video/btcx-risc.c                |    4 +-
 drivers/media/video/btcx-risc.h                |    2 +-
 drivers/media/video/bw-qcam.c                  |    3 +-
 drivers/media/video/c-qcam.c                   |    3 +-
 drivers/media/video/cpia.c                     |    2 +-
 drivers/media/video/cpia2/cpia2_v4l.c          |    4 +-
 drivers/media/video/cx18/cx18-av-firmware.c    |   16 +-
 drivers/media/video/cx18/cx18-driver.c         |    6 +-
 drivers/media/video/cx18/cx18-dvb.c            |    2 +-
 drivers/media/video/cx18/cx18-dvb.h            |    2 +-
 drivers/media/video/cx18/cx18-irq.c            |    2 +-
 drivers/media/video/cx18/cx18-queue.c          |  129 +--
 drivers/media/video/cx18/cx18-queue.h          |    2 +-
 drivers/media/video/cx23885/cx23885-417.c      |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c    |    2 +-
 drivers/media/video/cx23885/cx23885-core.c     |    4 +-
 drivers/media/video/cx23885/cx23885-dvb.c      |    2 +-
 drivers/media/video/cx23885/cx23885-i2c.c      |    2 +-
 drivers/media/video/cx23885/cx23885-reg.h      |    2 +-
 drivers/media/video/cx23885/cx23885-vbi.c      |    2 +-
 drivers/media/video/cx23885/cx23885-video.c    |    4 +-
 drivers/media/video/cx23885/cx23885.h          |    2 +-
 drivers/media/video/cx25840/cx25840-core.c     |    2 +-
 drivers/media/video/et61x251/et61x251_core.c   |    1 +
 drivers/media/video/gspca/conex.c              |   28 +-
 drivers/media/video/gspca/etoms.c              |   30 +-
 drivers/media/video/gspca/gspca.c              |  119 ++-
 drivers/media/video/gspca/gspca.h              |   21 +-
 drivers/media/video/gspca/mars.c               |   41 +-
 drivers/media/video/gspca/ov519.c              | 1167 ++++++++++++------------
 drivers/media/video/gspca/pac207.c             |   87 +--
 drivers/media/video/gspca/pac7311.c            | 1110 +++++++++++++++--------
 drivers/media/video/gspca/pac_common.h         |   60 ++
 drivers/media/video/gspca/sonixb.c             |  594 +++++++------
 drivers/media/video/gspca/sonixj.c             |  539 ++++++++----
 drivers/media/video/gspca/spca500.c            |   20 +-
 drivers/media/video/gspca/spca501.c            |   16 +-
 drivers/media/video/gspca/spca505.c            |   16 +-
 drivers/media/video/gspca/spca506.c            |   20 +-
 drivers/media/video/gspca/spca508.c            |   21 +-
 drivers/media/video/gspca/spca561.c            |  727 ++++++++++------
 drivers/media/video/gspca/stk014.c             |   20 +-
 drivers/media/video/gspca/sunplus.c            |  167 ++--
 drivers/media/video/gspca/t613.c               |   41 +-
 drivers/media/video/gspca/tv8532.c             |   20 +-
 drivers/media/video/gspca/vc032x.c             |   31 +-
 drivers/media/video/gspca/zc3xx.c              |   85 +-
 drivers/media/video/ivtv/ivtv-driver.c         |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h         |    1 +
 drivers/media/video/ivtv/ivtv-irq.c            |   29 +-
 drivers/media/video/ivtv/ivtv-queue.h          |    2 +-
 drivers/media/video/ivtv/ivtv-streams.c        |    2 +-
 drivers/media/video/ivtv/ivtv-vbi.c            |    4 +-
 drivers/media/video/ivtv/ivtv-version.h        |    2 +-
 drivers/media/video/ks0127.c                   |   31 +-
 drivers/media/video/meye.c                     |    2 +-
 drivers/media/video/mxb.c                      |   12 +-
 drivers/media/video/ov511.c                    |   14 +-
 drivers/media/video/pms.c                      |   13 +
 drivers/media/video/pwc/pwc-ctrl.c             |   18 +-
 drivers/media/video/saa7115.c                  |    5 +-
 drivers/media/video/se401.c                    |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c     |    1 +
 drivers/media/video/sn9c102/sn9c102_devtable.h |   21 +-
 drivers/media/video/stv680.c                   |    2 +-
 drivers/media/video/usbvideo/ibmcam.c          |    6 +-
 drivers/media/video/usbvideo/vicam.c           |    2 +-
 drivers/media/video/v4l2-dev.c                 |    5 +-
 drivers/media/video/v4l2-ioctl.c               |    4 +-
 drivers/media/video/vivi.c                     |   52 +-
 drivers/media/video/w9966.c                    |    2 +-
 drivers/media/video/zc0301/zc0301_core.c       |    1 +
 drivers/media/video/zc0301/zc0301_sensor.h     |   19 -
 include/linux/videodev2.h                      |    2 +
 148 files changed, 3360 insertions(+), 3148 deletions(-)
 delete mode 100644 drivers/media/radio/miropcm20-radio.c
 delete mode 100644 drivers/media/radio/miropcm20-rds-core.c
 delete mode 100644 drivers/media/radio/miropcm20-rds-core.h
 delete mode 100644 drivers/media/radio/miropcm20-rds.c
 create mode 100644 drivers/media/video/gspca/pac_common.h

Adrian Bunk (3):
      V4L/DVB (8678): Remove the dead CONFIG_RADIO_MIROPCM20{,_RDS} code
      V4L/DVB (8842): vivi_release(): fix use-after-free
      V4L/DVB (8843): tda10048_firmware_upload(): fix a memory leak

Alexander Beregalov (1):
      V4L/DVB (8681): v4l2-ioctl.c: fix warning

Andy Walls (2):
      V4L/DVB (8701): cx18: Add missing lock for when the irq handler manipulates the queues
      V4L/DVB (8769): cx18: Simplify queue flush logic to prevent oops in cx18_flush_queues()

Hans Verkuil (7):
      V4L/DVB (8629): v4l2-ioctl: do not try to handle private V4L1 ioctls
      V4L/DVB (8633): ivtv: update ivtv version number
      V4L/DVB (8648): ivtv: improve CC support
      V4L/DVB (8757): v4l-dvb: fix a bunch of sparse warnings
      V4L/DVB (8778): radio: fix incorrect video_register_device result check
      V4L/DVB (8779): v4l: fix more incorrect video_register_device result checks
      V4L/DVB (8790): saa7115: call i2c_set_clientdata only when state != NULL

Hans de Goede (21):
      V4L/DVB (8667): gspca: Bad probe of Z-Star/Vimicro webcams with pas106 sensor.
      V4L/DVB (8720): gspca: V4L2_CAP_SENSOR_UPSIDE_DOWN added as a cap for some webcams.
      V4L/DVB (8809): gspca: Revert commit 9a9335776548d01525141c6e8f0c12e86bbde982
      V4L/DVB (8812): gspca: Do pac73xx webcams work.
      V4L/DVB (8813): gspca: Adjust SOF detection for pac73xx.
      V4L/DVB (8815): gspca: Fix problems with disabled controls.
      V4L/DVB (8816): gspca: Set disabled ctrls and fix a register pb with ovxxxx in sonixb.
      V4L/DVB (8817): gspca: LED and proble changes in sonixb.
      V4L/DVB (8825): gspca: More controls for pac73xx and new webcam 093a:2624.
      V4L/DVB (8827): gspca: Stop pac7302 autogain oscillation.
      V4L/DVB (8830): gspca: Move some probe code to the new init function.
      V4L/DVB (8831): gspca: Resolve webcam conflicts between some drivers.
      V4L/DVB (8833): gspca: Cleanup the sonixb code.
      V4L/DVB (8834): gspca: Have a bigger buffer for sn9c10x compressed images.
      V4L/DVB (8835): gspca: Same pixfmt as the sn9c102 driver and raw Bayer added in sonixb.
      V4L/DVB (8868): gspca: Support for vga modes with sif sensors in sonixb.
      V4L/DVB (8869): gspca: Move the Sonix webcams with TAS5110C1B from sn9c102 to gspca.
      V4L/DVB (8870): gspca: Fix dark room problem with sonixb.
      V4L/DVB (8873): gspca: Bad image offset with rev012a of spca561 and adjust exposure.
      V4L/DVB (8874): gspca: Adjust hstart for sn9c103/ov7630 and update usb-id's.
      V4L/DVB (8880): PATCH: Fix parents on some webcam drivers

Henrik Kretzschmar (2):
      V4L/DVB (8682): V4L: fix return value of register video func
      V4L/DVB (8750): V4L: check inval in video_register_device_index()

Jean Delvare (1):
      V4L/DVB (8837): dvb: fix I2C adapters name size

Jean-Francois Moine (41):
      V4L/DVB (8660): gspca: Simplify the scan of URB packets in pac7311.
      V4L/DVB (8661): gspca: Bug in the previous changeset about pac7311.
      V4L/DVB (8663): gspca: Webcam 0c45:6128 added in sonixj.
      V4L/DVB (8664): gspca: The bridge/sensor of the webcam 093a:2621 is a PAC 7302.
      V4L/DVB (8665): gspca: Fix the 640x480 resolution of the webcam 093a:2621.
      V4L/DVB (8666): gspca: Bad scanning of frames in pac7311.
      V4L/DVB (8668): gspca: Conflict GSPCA / ET61X251 for the webcam 102c:6251.
      V4L/DVB (8669): gspca: Add white balance control for spca561 rev 012A.
      V4L/DVB (8671): gspca: Remove the unused field 'dev_name' of the device structure.
      V4L/DVB (8672): gspca: Big rewrite of spca561.
      V4L/DVB (8673): gspca: Bad frame scanning again and bad init in pac7311.
      V4L/DVB (8674): gspca: Webcam 0c45:612e added in sonixj.
      V4L/DVB (8675): gspca: Pixmap PJPG (Pixart 73xx JPEG) added, generated by pac7311.
      V4L/DVB (8703): gspca: Do controls work for spca561 revision 12a.
      V4L/DVB (8705): gspca: Adjust some control limits in spca561.
      V4L/DVB (8706): Make contrast and brightness work for pac7302.
      V4L/DVB (8707): gspca: Colors, hflip and vflip controls added for pac7302.
      V4L/DVB (8709): gspca: Fix initialization and controls of sn9x110 - ov7630.
      V4L/DVB (8710): gspca: Bad color control in sonixj.
      V4L/DVB (8711): gspca: Bad controls and quantization table of pac7311.
      V4L/DVB (8712): gspca: Bad start of sonixj webcams since changeset a8779025e7e8.
      V4L/DVB (8713): gspca: Bad color control again in sonixj.
      V4L/DVB (8714): gspca: Bad start of sn9c110 and sensor om6802.
      V4L/DVB (8715): gspca: Change the name of some webcam in the gspca doc.
      V4L/DVB (8716): gspca: Bad start of sn9c110 and sensor ov7630.
      V4L/DVB (8717): gspca: Frame buffer too small for small resolutions (sonixj and t613).
      V4L/DVB (8718): gspca: suspend/resume added.
      V4L/DVB (8719): gspca: Have VIDIOC_QUERYCTRL more compliant to the spec.
      V4L/DVB (8810): gspca: Compile error when CONFIG_PM not defined.
      V4L/DVB (8814): gspca: Set DISABLED the disabled controls at query control time.
      V4L/DVB (8818): gspca: Reinitialize the device on resume.
      V4L/DVB (8819): gspca: Initialize the ov519 at open time and source cleanup.
      V4L/DVB (8820): gspca: Change initialization and gamma of zc3xx - pas106.
      V4L/DVB (8822): gspca: Change some subdriver functions for suspend/resume.
      V4L/DVB (8823): gspca: H and V flips work for ov7670 only in ov519.
      V4L/DVB (8824): gspca: Too much code removed in the suspend/resume changeset.
      V4L/DVB (8826): gspca: Webcam Labtec 2200 (093a:2626) added in pac7311.
      V4L/DVB (8828): gspca: Set the clock at the end of initialization in sonixj.
      V4L/DVB (8829): gspca: Have a clean kmalloc-ated buffer for USB exchanges.
      V4L/DVB (8832): gspca: Bad pixelformat of vc0321 webcams.
      V4L/DVB (8872): gspca: Bad image format and offset with rev072a of spca561.

Li Zefan (1):
      V4L/DVB (8881): gspca: After 'while (retry--) {...}', retry will be -1 but not 0.

Mauro Carvalho Chehab (2):
      V4L/DVB (8749): Fix error code, when camera is not turned on by sonypi
      V4L/DVB (8751): vivi: Fix some issues at vivi register routine

Michael Krufky (8):
      V4L/DVB (8555): au8522: add mechanism to configure IF frequency for vsb and qam
      V4L/DVB (8556): au0828: add support for Hauppauge Woodbury
      V4L/DVB (8598): au8522: clean up function au8522_set_if
      V4L/DVB (8599): au8522: remove if frequency settings from vsb/qam modulation tables
      V4L/DVB (8600): au0828: explicitly set 6 MHz IF frequency in hauppauge_hvr950q_config
      V4L/DVB (8722): sms1xxx: fix typo in license header
      V4L/DVB (8839): dib0700: add comment to identify 35th USB id pair
      V4L/DVB (8840): dib0700: add basic support for Hauppauge Nova-TD-500 (84xxx)

Rene Herman (2):
      V4L/DVB (8727): V4L1: make PMS not autoprobe when builtin.
      V4L/DVB (8728): 1-make-pms-not-autoprobe-when-builtin update

Simon Arlott (1):
      V4L/DVB (8726): link tuner before saa7134

Steven Toth (3):
      V4L/DVB (8803): s5h1409: Enable QAM_AUTO mode
      V4L/DVB (8804): s5h1411: Enable QAM_AUTO mode
      V4L/DVB (8805): Steven Toth email address change

Thierry MERLE (2):
      V4L/DVB (8876): budget: udelay changed to mdelay
      V4L/DVB (8877): b2c2 and bt8xx: udelay to mdelay

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
