Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50123
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbcHDKiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2016 06:38:04 -0400
Date: Thu, 4 Aug 2016 07:11:03 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.8-rc1] removal of media DocBook and some fixups
Message-ID: <20160804071103.1b8126dc@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.8-5

For:
  - Removal of the media DocBook;
  - videobuf2: Fix an allocation regression;
  - A few fixes related to the CEC drivers.

You may expect a trivial conflict at Documentation/DocBook/Makefile,
due to the removal of the gpu.tmpl.

Thanks!
Mauro


The following changes since commit ff9a082fda424257976f08fce942609f358015e0:

  Merge tag 'media/v4.8-4' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2016-07-27 14:58:31 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.8-5

for you to fetch changes up to 292eaf50c7df4ae2ae8aaa9e1ce3f1240a353ee8:

  [media] cec: fix off-by-one memset (2016-07-28 20:16:35 -0300)

----------------------------------------------------------------
media updates for v4.8-rc1

----------------------------------------------------------------
Arnd Bergmann (1):
      [media] staging: add MEDIA_SUPPORT dependency

Hans Verkuil (4):
      [media] adv7511: fix VIC autodetect
      [media] vim2m: copy the other colorspace-related fields as well
      [media] vivid: don't handle CEC_MSG_SET_STREAM_PATH
      [media] cec: fix off-by-one memset

Mauro Carvalho Chehab (1):
      doc-rst: Remove the media docbook

Steve Longerbeam (1):
      [media] media: adv7180: Fix broken interrupt register access

Vincent StehlÃ© (1):
      [media] vb2: Fix allocation size of dma_parms

 Documentation/DocBook/Makefile                     |   10 +-
 Documentation/DocBook/media/.gitignore             |    1 -
 Documentation/DocBook/media/Makefile               |  427 --
 Documentation/DocBook/media/bayer.png.b64          |  171 -
 Documentation/DocBook/media/constraints.png.b64    |   59 -
 Documentation/DocBook/media/crop.gif.b64           |  105 -
 Documentation/DocBook/media/dvb/.gitignore         |    1 -
 Documentation/DocBook/media/dvb/audio.xml          | 1314 -----
 Documentation/DocBook/media/dvb/ca.xml             |  582 ---
 Documentation/DocBook/media/dvb/demux.xml          | 1162 -----
 Documentation/DocBook/media/dvb/dvbapi.xml         |  156 -
 Documentation/DocBook/media/dvb/dvbproperty.xml    | 1680 ------
 Documentation/DocBook/media/dvb/dvbstb.pdf         |  Bin 1881 -> 0 bytes
 Documentation/DocBook/media/dvb/examples.xml       |  367 --
 .../media/dvb/fe-diseqc-recv-slave-reply.xml       |   78 -
 .../DocBook/media/dvb/fe-diseqc-reset-overload.xml |   51 -
 .../DocBook/media/dvb/fe-diseqc-send-burst.xml     |   89 -
 .../media/dvb/fe-diseqc-send-master-cmd.xml        |   72 -
 .../media/dvb/fe-enable-high-lnb-voltage.xml       |   61 -
 Documentation/DocBook/media/dvb/fe-get-info.xml    |  266 -
 .../DocBook/media/dvb/fe-get-property.xml          |   81 -
 Documentation/DocBook/media/dvb/fe-read-status.xml |  107 -
 .../media/dvb/fe-set-frontend-tune-mode.xml        |   64 -
 Documentation/DocBook/media/dvb/fe-set-tone.xml    |   91 -
 Documentation/DocBook/media/dvb/fe-set-voltage.xml |   69 -
 Documentation/DocBook/media/dvb/frontend.xml       |  269 -
 .../DocBook/media/dvb/frontend_legacy_api.xml      |  654 ---
 Documentation/DocBook/media/dvb/intro.xml          |  211 -
 Documentation/DocBook/media/dvb/net.xml            |  238 -
 Documentation/DocBook/media/dvb/video.xml          | 1968 -------
 Documentation/DocBook/media/dvbstb.png.b64         |  398 --
 Documentation/DocBook/media/fieldseq_bt.gif.b64    |  447 --
 Documentation/DocBook/media/fieldseq_tb.gif.b64    |  445 --
 Documentation/DocBook/media/nv12mt.gif.b64         |   37 -
 Documentation/DocBook/media/nv12mt_example.gif.b64 |  121 -
 Documentation/DocBook/media/pipeline.png.b64       |  213 -
 Documentation/DocBook/media/selection.png.b64      |  206 -
 .../DocBook/media/typical_media_device.svg         |   28 -
 Documentation/DocBook/media/v4l/.gitignore         |    1 -
 Documentation/DocBook/media/v4l/biblio.xml         |  381 --
 Documentation/DocBook/media/v4l/capture.c.xml      |  659 ---
 Documentation/DocBook/media/v4l/cec-api.xml        |   75 -
 Documentation/DocBook/media/v4l/cec-func-close.xml |   64 -
 Documentation/DocBook/media/v4l/cec-func-ioctl.xml |   78 -
 Documentation/DocBook/media/v4l/cec-func-open.xml  |  104 -
 Documentation/DocBook/media/v4l/cec-func-poll.xml  |   94 -
 .../DocBook/media/v4l/cec-ioc-adap-g-caps.xml      |  151 -
 .../DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml |  329 --
 .../DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml |   86 -
 .../DocBook/media/v4l/cec-ioc-dqevent.xml          |  202 -
 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml |  255 -
 .../DocBook/media/v4l/cec-ioc-receive.xml          |  274 -
 Documentation/DocBook/media/v4l/common.xml         | 1102 ----
 Documentation/DocBook/media/v4l/compat.xml         | 2723 ----------
 Documentation/DocBook/media/v4l/controls.xml       | 5505 --------------------
 Documentation/DocBook/media/v4l/crop.pdf           |  Bin 5846 -> 0 bytes
 Documentation/DocBook/media/v4l/dev-capture.xml    |  110 -
 Documentation/DocBook/media/v4l/dev-codec.xml      |   27 -
 Documentation/DocBook/media/v4l/dev-effect.xml     |   17 -
 Documentation/DocBook/media/v4l/dev-event.xml      |   43 -
 Documentation/DocBook/media/v4l/dev-osd.xml        |  149 -
 Documentation/DocBook/media/v4l/dev-output.xml     |  106 -
 Documentation/DocBook/media/v4l/dev-overlay.xml    |  368 --
 Documentation/DocBook/media/v4l/dev-radio.xml      |   49 -
 Documentation/DocBook/media/v4l/dev-raw-vbi.xml    |  345 --
 Documentation/DocBook/media/v4l/dev-rds.xml        |  196 -
 Documentation/DocBook/media/v4l/dev-sdr.xml        |  126 -
 Documentation/DocBook/media/v4l/dev-sliced-vbi.xml |  706 ---
 Documentation/DocBook/media/v4l/dev-subdev.xml     |  478 --
 Documentation/DocBook/media/v4l/dev-teletext.xml   |   29 -
 Documentation/DocBook/media/v4l/driver.xml         |  200 -
 Documentation/DocBook/media/v4l/fdl-appendix.xml   |  671 ---
 Documentation/DocBook/media/v4l/fieldseq_bt.pdf    |  Bin 9185 -> 0 bytes
 Documentation/DocBook/media/v4l/fieldseq_tb.pdf    |  Bin 9173 -> 0 bytes
 Documentation/DocBook/media/v4l/func-close.xml     |   62 -
 Documentation/DocBook/media/v4l/func-ioctl.xml     |   71 -
 Documentation/DocBook/media/v4l/func-mmap.xml      |  183 -
 Documentation/DocBook/media/v4l/func-munmap.xml    |   76 -
 Documentation/DocBook/media/v4l/func-open.xml      |  113 -
 Documentation/DocBook/media/v4l/func-poll.xml      |  142 -
 Documentation/DocBook/media/v4l/func-read.xml      |  181 -
 Documentation/DocBook/media/v4l/func-select.xml    |  130 -
 Documentation/DocBook/media/v4l/func-write.xml     |  128 -
 Documentation/DocBook/media/v4l/gen-errors.xml     |   77 -
 Documentation/DocBook/media/v4l/io.xml             | 1545 ------
 Documentation/DocBook/media/v4l/keytable.c.xml     |  172 -
 Documentation/DocBook/media/v4l/libv4l.xml         |  160 -
 .../DocBook/media/v4l/lirc_device_interface.xml    |  255 -
 .../DocBook/media/v4l/media-controller.xml         |  105 -
 .../DocBook/media/v4l/media-func-close.xml         |   59 -
 .../DocBook/media/v4l/media-func-ioctl.xml         |   73 -
 .../DocBook/media/v4l/media-func-open.xml          |   94 -
 .../DocBook/media/v4l/media-ioc-device-info.xml    |  132 -
 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |  180 -
 .../DocBook/media/v4l/media-ioc-enum-links.xml     |  160 -
 .../DocBook/media/v4l/media-ioc-g-topology.xml     |  391 --
 .../DocBook/media/v4l/media-ioc-setup-link.xml     |   84 -
 Documentation/DocBook/media/v4l/media-types.xml    |  379 --
 Documentation/DocBook/media/v4l/pipeline.pdf       |  Bin 20276 -> 0 bytes
 Documentation/DocBook/media/v4l/pixfmt-grey.xml    |   62 -
 Documentation/DocBook/media/v4l/pixfmt-m420.xml    |  139 -
 Documentation/DocBook/media/v4l/pixfmt-nv12.xml    |  143 -
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml   |  153 -
 Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml  |   66 -
 Documentation/DocBook/media/v4l/pixfmt-nv16.xml    |  166 -
 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml   |  170 -
 Documentation/DocBook/media/v4l/pixfmt-nv24.xml    |  121 -
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |  937 ----
 .../DocBook/media/v4l/pixfmt-packed-yuv.xml        |  236 -
 Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml |   83 -
 Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml  |   67 -
 .../DocBook/media/v4l/pixfmt-sdr-cs08.xml          |   44 -
 .../DocBook/media/v4l/pixfmt-sdr-cs14le.xml        |   47 -
 .../DocBook/media/v4l/pixfmt-sdr-cu08.xml          |   44 -
 .../DocBook/media/v4l/pixfmt-sdr-cu16le.xml        |   46 -
 .../DocBook/media/v4l/pixfmt-sdr-ru12le.xml        |   40 -
 Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml  |   67 -
 Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml  |   67 -
 Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |   90 -
 .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 -
 .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |   28 -
 .../DocBook/media/v4l/pixfmt-srggb10p.xml          |   99 -
 Documentation/DocBook/media/v4l/pixfmt-srggb12.xml |   90 -
 Documentation/DocBook/media/v4l/pixfmt-srggb8.xml  |   67 -
 Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 -
 Documentation/DocBook/media/v4l/pixfmt-uyvy.xml    |  120 -
 Documentation/DocBook/media/v4l/pixfmt-vyuy.xml    |  120 -
 Documentation/DocBook/media/v4l/pixfmt-y10.xml     |   79 -
 Documentation/DocBook/media/v4l/pixfmt-y10b.xml    |   43 -
 Documentation/DocBook/media/v4l/pixfmt-y12.xml     |   79 -
 Documentation/DocBook/media/v4l/pixfmt-y12i.xml    |   49 -
 Documentation/DocBook/media/v4l/pixfmt-y16-be.xml  |   81 -
 Documentation/DocBook/media/v4l/pixfmt-y16.xml     |   81 -
 Documentation/DocBook/media/v4l/pixfmt-y41p.xml    |  149 -
 Documentation/DocBook/media/v4l/pixfmt-y8i.xml     |   80 -
 Documentation/DocBook/media/v4l/pixfmt-yuv410.xml  |  133 -
 Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml |  147 -
 Documentation/DocBook/media/v4l/pixfmt-yuv420.xml  |  149 -
 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |  162 -
 Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml |  166 -
 Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml |  153 -
 Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml |  177 -
 Documentation/DocBook/media/v4l/pixfmt-yuyv.xml    |  120 -
 Documentation/DocBook/media/v4l/pixfmt-yvyu.xml    |  120 -
 Documentation/DocBook/media/v4l/pixfmt-z16.xml     |   81 -
 Documentation/DocBook/media/v4l/pixfmt.xml         | 2003 -------
 Documentation/DocBook/media/v4l/planar-apis.xml    |   62 -
 .../DocBook/media/v4l/remote_controllers.xml       |  320 --
 Documentation/DocBook/media/v4l/selection-api.xml  |  317 --
 .../DocBook/media/v4l/selections-common.xml        |  180 -
 Documentation/DocBook/media/v4l/subdev-formats.xml | 4040 --------------
 .../media/v4l/subdev-image-processing-crop.dia     |  614 ---
 .../media/v4l/subdev-image-processing-crop.svg     |   63 -
 .../media/v4l/subdev-image-processing-full.dia     | 1588 ------
 .../media/v4l/subdev-image-processing-full.svg     |  163 -
 ...ubdev-image-processing-scaling-multi-source.dia | 1152 ----
 ...ubdev-image-processing-scaling-multi-source.svg |  116 -
 Documentation/DocBook/media/v4l/v4l2.xml           |  728 ---
 Documentation/DocBook/media/v4l/v4l2grab.c.xml     |  164 -
 Documentation/DocBook/media/v4l/vbi_525.pdf        |  Bin 3395 -> 0 bytes
 Documentation/DocBook/media/v4l/vbi_625.pdf        |  Bin 3683 -> 0 bytes
 Documentation/DocBook/media/v4l/vbi_hsync.pdf      |  Bin 7405 -> 0 bytes
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |  158 -
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml |  166 -
 .../DocBook/media/v4l/vidioc-dbg-g-chip-info.xml   |  207 -
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml    |  227 -
 .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |  259 -
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |  471 --
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |  210 -
 .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |  197 -
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |  128 -
 .../DocBook/media/v4l/vidioc-enum-fmt.xml          |  159 -
 .../media/v4l/vidioc-enum-frameintervals.xml       |  260 -
 .../DocBook/media/v4l/vidioc-enum-framesizes.xml   |  265 -
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml   |  175 -
 .../DocBook/media/v4l/vidioc-enumaudio.xml         |   76 -
 .../DocBook/media/v4l/vidioc-enumaudioout.xml      |   79 -
 .../DocBook/media/v4l/vidioc-enuminput.xml         |  316 --
 .../DocBook/media/v4l/vidioc-enumoutput.xml        |  201 -
 Documentation/DocBook/media/v4l/vidioc-enumstd.xml |  389 --
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml  |  205 -
 Documentation/DocBook/media/v4l/vidioc-g-audio.xml |  172 -
 .../DocBook/media/v4l/vidioc-g-audioout.xml        |  138 -
 Documentation/DocBook/media/v4l/vidioc-g-crop.xml  |  129 -
 Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml  |  133 -
 .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |  343 --
 Documentation/DocBook/media/v4l/vidioc-g-edid.xml  |  173 -
 .../DocBook/media/v4l/vidioc-g-enc-index.xml       |  189 -
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |  456 --
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml  |  459 --
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |  204 -
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |  148 -
 Documentation/DocBook/media/v4l/vidioc-g-input.xml |   83 -
 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |  175 -
 .../DocBook/media/v4l/vidioc-g-modulator.xml       |  252 -
 .../DocBook/media/v4l/vidioc-g-output.xml          |   85 -
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml  |  314 --
 .../DocBook/media/v4l/vidioc-g-priority.xml        |  135 -
 .../DocBook/media/v4l/vidioc-g-selection.xml       |  233 -
 .../DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml  |  255 -
 Documentation/DocBook/media/v4l/vidioc-g-std.xml   |   98 -
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |  594 ---
 .../DocBook/media/v4l/vidioc-log-status.xml        |   41 -
 Documentation/DocBook/media/v4l/vidioc-overlay.xml |   74 -
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   88 -
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |  202 -
 .../DocBook/media/v4l/vidioc-query-dv-timings.xml  |  115 -
 .../DocBook/media/v4l/vidioc-querybuf.xml          |  106 -
 .../DocBook/media/v4l/vidioc-querycap.xml          |  350 --
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |  661 ---
 .../DocBook/media/v4l/vidioc-querystd.xml          |   85 -
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |  137 -
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |  188 -
 .../DocBook/media/v4l/vidioc-streamon.xml          |  136 -
 .../v4l/vidioc-subdev-enum-frame-interval.xml      |  151 -
 .../media/v4l/vidioc-subdev-enum-frame-size.xml    |  153 -
 .../media/v4l/vidioc-subdev-enum-mbus-code.xml     |  118 -
 .../DocBook/media/v4l/vidioc-subdev-g-crop.xml     |  158 -
 .../DocBook/media/v4l/vidioc-subdev-g-fmt.xml      |  177 -
 .../media/v4l/vidioc-subdev-g-frame-interval.xml   |  135 -
 .../media/v4l/vidioc-subdev-g-selection.xml        |  159 -
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  130 -
 Documentation/DocBook/media/vbi_525.gif.b64        |   84 -
 Documentation/DocBook/media/vbi_625.gif.b64        |   90 -
 Documentation/DocBook/media/vbi_hsync.gif.b64      |   43 -
 Documentation/DocBook/media_api.tmpl               |  121 -
 Documentation/Makefile.sphinx                      |    1 -
 Makefile                                           |    2 +-
 drivers/media/i2c/adv7180.c                        |   18 +-
 drivers/media/i2c/adv7511.c                        |   24 +-
 drivers/media/platform/vim2m.c                     |   15 +-
 drivers/media/platform/vivid/vivid-cec.c           |   10 -
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |    2 +-
 drivers/staging/media/Kconfig                      |    2 +-
 drivers/staging/media/cec/cec-adap.c               |    2 +-
 235 files changed, 49 insertions(+), 62566 deletions(-)
 delete mode 100644 Documentation/DocBook/media/.gitignore
 delete mode 100644 Documentation/DocBook/media/Makefile
 delete mode 100644 Documentation/DocBook/media/bayer.png.b64
 delete mode 100644 Documentation/DocBook/media/constraints.png.b64
 delete mode 100644 Documentation/DocBook/media/crop.gif.b64
 delete mode 100644 Documentation/DocBook/media/dvb/.gitignore
 delete mode 100644 Documentation/DocBook/media/dvb/audio.xml
 delete mode 100644 Documentation/DocBook/media/dvb/ca.xml
 delete mode 100644 Documentation/DocBook/media/dvb/demux.xml
 delete mode 100644 Documentation/DocBook/media/dvb/dvbapi.xml
 delete mode 100644 Documentation/DocBook/media/dvb/dvbproperty.xml
 delete mode 100644 Documentation/DocBook/media/dvb/dvbstb.pdf
 delete mode 100644 Documentation/DocBook/media/dvb/examples.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-reset-overload.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-get-info.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-get-property.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-read-status.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-set-tone.xml
 delete mode 100644 Documentation/DocBook/media/dvb/fe-set-voltage.xml
 delete mode 100644 Documentation/DocBook/media/dvb/frontend.xml
 delete mode 100644 Documentation/DocBook/media/dvb/frontend_legacy_api.xml
 delete mode 100644 Documentation/DocBook/media/dvb/intro.xml
 delete mode 100644 Documentation/DocBook/media/dvb/net.xml
 delete mode 100644 Documentation/DocBook/media/dvb/video.xml
 delete mode 100644 Documentation/DocBook/media/dvbstb.png.b64
 delete mode 100644 Documentation/DocBook/media/fieldseq_bt.gif.b64
 delete mode 100644 Documentation/DocBook/media/fieldseq_tb.gif.b64
 delete mode 100644 Documentation/DocBook/media/nv12mt.gif.b64
 delete mode 100644 Documentation/DocBook/media/nv12mt_example.gif.b64
 delete mode 100644 Documentation/DocBook/media/pipeline.png.b64
 delete mode 100644 Documentation/DocBook/media/selection.png.b64
 delete mode 100644 Documentation/DocBook/media/typical_media_device.svg
 delete mode 100644 Documentation/DocBook/media/v4l/.gitignore
 delete mode 100644 Documentation/DocBook/media/v4l/biblio.xml
 delete mode 100644 Documentation/DocBook/media/v4l/capture.c.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-api.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-func-close.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-func-ioctl.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-func-open.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-func-poll.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
 delete mode 100644 Documentation/DocBook/media/v4l/cec-ioc-receive.xml
 delete mode 100644 Documentation/DocBook/media/v4l/common.xml
 delete mode 100644 Documentation/DocBook/media/v4l/compat.xml
 delete mode 100644 Documentation/DocBook/media/v4l/controls.xml
 delete mode 100644 Documentation/DocBook/media/v4l/crop.pdf
 delete mode 100644 Documentation/DocBook/media/v4l/dev-capture.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-codec.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-effect.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-event.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-osd.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-output.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-overlay.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-radio.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-raw-vbi.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-rds.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-sdr.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-subdev.xml
 delete mode 100644 Documentation/DocBook/media/v4l/dev-teletext.xml
 delete mode 100644 Documentation/DocBook/media/v4l/driver.xml
 delete mode 100644 Documentation/DocBook/media/v4l/fdl-appendix.xml
 delete mode 100644 Documentation/DocBook/media/v4l/fieldseq_bt.pdf
 delete mode 100644 Documentation/DocBook/media/v4l/fieldseq_tb.pdf
 delete mode 100644 Documentation/DocBook/media/v4l/func-close.xml
 delete mode 100644 Documentation/DocBook/media/v4l/func-ioctl.xml
 delete mode 100644 Documentation/DocBook/media/v4l/func-mmap.xml
 delete mode 100644 Documentation/DocBook/media/v4l/func-munmap.xml
 delete mode 100644 Documentation/DocBook/media/v4l/func-open.xml
 delete mode 100644 Documentation/DocBook/media/v4l/func-poll.xml
 delete mode 100644 Documentation/DocBook/media/v4l/func-read.xml
 delete mode 100644 Documentation/DocBook/media/v4l/func-select.xml
 delete mode 100644 Documentation/DocBook/media/v4l/func-write.xml
 delete mode 100644 Documentation/DocBook/media/v4l/gen-errors.xml
 delete mode 100644 Documentation/DocBook/media/v4l/io.xml
 delete mode 100644 Documentation/DocBook/media/v4l/keytable.c.xml
 delete mode 100644 Documentation/DocBook/media/v4l/libv4l.xml
 delete mode 100644 Documentation/DocBook/media/v4l/lirc_device_interface.xml
 delete mode 100644 Documentation/DocBook/media/v4l/media-controller.xml
 delete mode 100644 Documentation/DocBook/media/v4l/media-func-close.xml
 delete mode 100644 Documentation/DocBook/media/v4l/media-func-ioctl.xml
 delete mode 100644 Documentation/DocBook/media/v4l/media-func-open.xml
 delete mode 100644 Documentation/DocBook/media/v4l/media-ioc-device-info.xml
 delete mode 100644 Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
 delete mode 100644 Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
 delete mode 100644 Documentation/DocBook/media/v4l/media-ioc-g-topology.xml
 delete mode 100644 Documentation/DocBook/media/v4l/media-ioc-setup-link.xml
 delete mode 100644 Documentation/DocBook/media/v4l/media-types.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pipeline.pdf
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-grey.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-m420.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv12.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv16.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv24.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-packed-yuv.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb8.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-uyvy.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-vyuy.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-y10.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-y10b.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-y12.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-y12i.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-y16-be.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-y16.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-y41p.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-y8i.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv410.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv420.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuyv.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvyu.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt-z16.xml
 delete mode 100644 Documentation/DocBook/media/v4l/pixfmt.xml
 delete mode 100644 Documentation/DocBook/media/v4l/planar-apis.xml
 delete mode 100644 Documentation/DocBook/media/v4l/remote_controllers.xml
 delete mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
 delete mode 100644 Documentation/DocBook/media/v4l/selections-common.xml
 delete mode 100644 Documentation/DocBook/media/v4l/subdev-formats.xml
 delete mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
 delete mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg
 delete mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.dia
 delete mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
 delete mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
 delete mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg
 delete mode 100644 Documentation/DocBook/media/v4l/v4l2.xml
 delete mode 100644 Documentation/DocBook/media/v4l/v4l2grab.c.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vbi_525.pdf
 delete mode 100644 Documentation/DocBook/media/v4l/vbi_625.pdf
 delete mode 100644 Documentation/DocBook/media/v4l/vbi_hsync.pdf
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-cropcap.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-dqevent.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enumaudio.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enumaudioout.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enuminput.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enumstd.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-expbuf.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-audio.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-audioout.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-crop.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-edid.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-input.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-output.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-parm.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-priority.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-std.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-log-status.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-overlay.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-qbuf.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-querybuf.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-querycap.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-querystd.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-streamon.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-crop.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-frame-interval.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
 delete mode 100644 Documentation/DocBook/media/vbi_525.gif.b64
 delete mode 100644 Documentation/DocBook/media/vbi_625.gif.b64
 delete mode 100644 Documentation/DocBook/media/vbi_hsync.gif.b64
 delete mode 100644 Documentation/DocBook/media_api.tmpl

