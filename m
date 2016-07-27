Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59397 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbcG0Jcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2016 05:32:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michal Marek <mmarek@suse.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Ben Hutchings <ben@decadent.org.uk>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] doc-rst: Remove the media docbook
Date: Wed, 27 Jul 2016 06:32:31 -0300
Message-Id: <4fb2b55b3d3215b2f6c649417d749f8f27b2df77.1469611833.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all media documentation was converted to Sphinx, we
should get rid of the old DocBook one, as we don't want people
to submit patches against the old stuff.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

Jon,

This patch should be applied after Linus handle my media documentation
pull request. Do you prefer to send the patch yourself, or if I do it?

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
 Documentation/Makefile.sphinx                      |    1 -
 Makefile                                           |    2 +-
 227 files changed, 3 insertions(+), 62418 deletions(-)
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

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 01bab5014a4a..2bfd664b5e35 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -16,11 +16,9 @@ DOCBOOKS := z8530book.xml device-drivers.xml \
 	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
 	    80211.xml debugobjects.xml sh.xml regulator.xml \
 	    alsa-driver-api.xml writing-an-alsa-driver.xml \
-	    tracepoint.xml gpu.xml media_api.xml w1.xml \
+	    tracepoint.xml gpu.xml w1.xml \
 	    writing_musb_glue_layer.xml crypto-API.xml iio.xml
 
-include Documentation/DocBook/media/Makefile
-
 ###
 # The build process is as follows (targets):
 #              (xmldocs) [by docproc]
@@ -49,7 +47,6 @@ pdfdocs: $(PDF)
 HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
 htmldocs: $(HTML)
 	$(call cmd,build_main_index)
-	$(call install_media_images)
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
 mandocs: $(MAN)
@@ -219,9 +216,6 @@ silent_gen_xml = :
 
 else
 
-# Needed, due to cleanmediadocs
-include Documentation/DocBook/media/Makefile
-
 htmldocs:
 pdfdocs:
 psdocs:
@@ -269,7 +263,7 @@ clean-files := $(DOCBOOKS) \
 
 clean-dirs := $(patsubst %.xml,%,$(DOCBOOKS)) man
 
-cleandocs: cleanmediadocs
+cleandocs:
 	$(Q)rm -f $(call objectify, $(clean-files))
 	$(Q)rm -rf $(call objectify, $(clean-dirs))
 
diff --git a/Documentation/DocBook/media/.gitignore b/Documentation/DocBook/media/.gitignore
deleted file mode 100644
index e461c585fde8..000000000000
diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
deleted file mode 100644
index fdc138624800..000000000000
diff --git a/Documentation/DocBook/media/bayer.png.b64 b/Documentation/DocBook/media/bayer.png.b64
deleted file mode 100644
index ccdf2bcda95c..000000000000
diff --git a/Documentation/DocBook/media/constraints.png.b64 b/Documentation/DocBook/media/constraints.png.b64
deleted file mode 100644
index 125b4a94962c..000000000000
diff --git a/Documentation/DocBook/media/crop.gif.b64 b/Documentation/DocBook/media/crop.gif.b64
deleted file mode 100644
index 11d936ae72e8..000000000000
diff --git a/Documentation/DocBook/media/dvb/.gitignore b/Documentation/DocBook/media/dvb/.gitignore
deleted file mode 100644
index d7ec32eafac9..000000000000
diff --git a/Documentation/DocBook/media/dvb/audio.xml b/Documentation/DocBook/media/dvb/audio.xml
deleted file mode 100644
index ea56743ddbe7..000000000000
diff --git a/Documentation/DocBook/media/dvb/ca.xml b/Documentation/DocBook/media/dvb/ca.xml
deleted file mode 100644
index d0b07e763908..000000000000
diff --git a/Documentation/DocBook/media/dvb/demux.xml b/Documentation/DocBook/media/dvb/demux.xml
deleted file mode 100644
index 34f2fb1cd601..000000000000
diff --git a/Documentation/DocBook/media/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
deleted file mode 100644
index 8576481e20ae..000000000000
diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
deleted file mode 100644
index e579ae5088ae..000000000000
diff --git a/Documentation/DocBook/media/dvb/dvbstb.pdf b/Documentation/DocBook/media/dvb/dvbstb.pdf
deleted file mode 100644
index 0fa75d90c3eba1db9d07611ec6d86b4bc22d7a39..0000000000000000000000000000000000000000
diff --git a/Documentation/DocBook/media/dvb/examples.xml b/Documentation/DocBook/media/dvb/examples.xml
deleted file mode 100644
index 837fb3b64b72..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml b/Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml
deleted file mode 100644
index 4595dbfff208..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-reset-overload.xml b/Documentation/DocBook/media/dvb/fe-diseqc-reset-overload.xml
deleted file mode 100644
index c104df77ecd0..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml b/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
deleted file mode 100644
index 9f6a68f32de3..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml b/Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml
deleted file mode 100644
index 38cf313e121b..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml b/Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml
deleted file mode 100644
index c11890b184ad..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-get-info.xml b/Documentation/DocBook/media/dvb/fe-get-info.xml
deleted file mode 100644
index ed0eeb29dd65..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-get-property.xml b/Documentation/DocBook/media/dvb/fe-get-property.xml
deleted file mode 100644
index 53a170ed3bd1..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-read-status.xml b/Documentation/DocBook/media/dvb/fe-read-status.xml
deleted file mode 100644
index bc0dc2a55f19..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml b/Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml
deleted file mode 100644
index 99fa8a015c7a..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-set-tone.xml b/Documentation/DocBook/media/dvb/fe-set-tone.xml
deleted file mode 100644
index 62d44e4ccc39..000000000000
diff --git a/Documentation/DocBook/media/dvb/fe-set-voltage.xml b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
deleted file mode 100644
index c89a6f79b5af..000000000000
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
deleted file mode 100644
index 01210b33c130..000000000000
diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
deleted file mode 100644
index 8fadf3a4ba44..000000000000
diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
deleted file mode 100644
index b5b701f5d8c2..000000000000
diff --git a/Documentation/DocBook/media/dvb/net.xml b/Documentation/DocBook/media/dvb/net.xml
deleted file mode 100644
index da095ed0b75c..000000000000
diff --git a/Documentation/DocBook/media/dvb/video.xml b/Documentation/DocBook/media/dvb/video.xml
deleted file mode 100644
index 71547fcd7ba0..000000000000
diff --git a/Documentation/DocBook/media/dvbstb.png.b64 b/Documentation/DocBook/media/dvbstb.png.b64
deleted file mode 100644
index e8b52fde3d11..000000000000
diff --git a/Documentation/DocBook/media/fieldseq_bt.gif.b64 b/Documentation/DocBook/media/fieldseq_bt.gif.b64
deleted file mode 100644
index b5b557b88158..000000000000
diff --git a/Documentation/DocBook/media/fieldseq_tb.gif.b64 b/Documentation/DocBook/media/fieldseq_tb.gif.b64
deleted file mode 100644
index 7b4c1766b407..000000000000
diff --git a/Documentation/DocBook/media/nv12mt.gif.b64 b/Documentation/DocBook/media/nv12mt.gif.b64
deleted file mode 100644
index 083a7c85d107..000000000000
diff --git a/Documentation/DocBook/media/nv12mt_example.gif.b64 b/Documentation/DocBook/media/nv12mt_example.gif.b64
deleted file mode 100644
index a512078c7f24..000000000000
diff --git a/Documentation/DocBook/media/pipeline.png.b64 b/Documentation/DocBook/media/pipeline.png.b64
deleted file mode 100644
index 97d9ac007473..000000000000
diff --git a/Documentation/DocBook/media/selection.png.b64 b/Documentation/DocBook/media/selection.png.b64
deleted file mode 100644
index 416186558cb2..000000000000
diff --git a/Documentation/DocBook/media/typical_media_device.svg b/Documentation/DocBook/media/typical_media_device.svg
deleted file mode 100644
index f0c82f72c4b6..000000000000
diff --git a/Documentation/DocBook/media/v4l/.gitignore b/Documentation/DocBook/media/v4l/.gitignore
deleted file mode 100644
index d7ec32eafac9..000000000000
diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
deleted file mode 100644
index 87f1d24958aa..000000000000
diff --git a/Documentation/DocBook/media/v4l/capture.c.xml b/Documentation/DocBook/media/v4l/capture.c.xml
deleted file mode 100644
index 22126a991b34..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-api.xml b/Documentation/DocBook/media/v4l/cec-api.xml
deleted file mode 100644
index 7062c1fa4904..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-func-close.xml b/Documentation/DocBook/media/v4l/cec-func-close.xml
deleted file mode 100644
index 0812c8cd9634..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-func-ioctl.xml b/Documentation/DocBook/media/v4l/cec-func-ioctl.xml
deleted file mode 100644
index f92817a2dc80..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-func-open.xml b/Documentation/DocBook/media/v4l/cec-func-open.xml
deleted file mode 100644
index 2edc5555b81a..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-func-poll.xml b/Documentation/DocBook/media/v4l/cec-func-poll.xml
deleted file mode 100644
index 1bddbde0142d..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
deleted file mode 100644
index 3523ef2259b1..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
deleted file mode 100644
index 302b8294f7fc..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
deleted file mode 100644
index d95f1785080c..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml b/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
deleted file mode 100644
index 697dde575cd4..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
deleted file mode 100644
index 26b4282ad134..000000000000
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-receive.xml b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
deleted file mode 100644
index fde9f8678e67..000000000000
diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
deleted file mode 100644
index 8b5e014224d6..000000000000
diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
deleted file mode 100644
index 82fa328abd58..000000000000
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
deleted file mode 100644
index e2e5484d2d9b..000000000000
diff --git a/Documentation/DocBook/media/v4l/crop.pdf b/Documentation/DocBook/media/v4l/crop.pdf
deleted file mode 100644
index c9fb81cd32f34d2b08cb601f3a1575af77e14275..0000000000000000000000000000000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-capture.xml b/Documentation/DocBook/media/v4l/dev-capture.xml
deleted file mode 100644
index e1c5f9406d6a..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-codec.xml b/Documentation/DocBook/media/v4l/dev-codec.xml
deleted file mode 100644
index ff44c16fc080..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-effect.xml b/Documentation/DocBook/media/v4l/dev-effect.xml
deleted file mode 100644
index 2350a67c0710..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-event.xml b/Documentation/DocBook/media/v4l/dev-event.xml
deleted file mode 100644
index 19f4becfae34..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-osd.xml b/Documentation/DocBook/media/v4l/dev-osd.xml
deleted file mode 100644
index 54853329140b..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-output.xml b/Documentation/DocBook/media/v4l/dev-output.xml
deleted file mode 100644
index 9130a3dc7880..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-overlay.xml b/Documentation/DocBook/media/v4l/dev-overlay.xml
deleted file mode 100644
index cc6e0c5c960c..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-radio.xml b/Documentation/DocBook/media/v4l/dev-radio.xml
deleted file mode 100644
index 3e6ac73b36af..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-raw-vbi.xml b/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
deleted file mode 100644
index 78599bbd58f7..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-rds.xml b/Documentation/DocBook/media/v4l/dev-rds.xml
deleted file mode 100644
index be2f33737323..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
deleted file mode 100644
index 6da1157fb5bd..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml b/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
deleted file mode 100644
index 0aec62ed2bf8..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
deleted file mode 100644
index f4bc27af83eb..000000000000
diff --git a/Documentation/DocBook/media/v4l/dev-teletext.xml b/Documentation/DocBook/media/v4l/dev-teletext.xml
deleted file mode 100644
index bd21c64d70f3..000000000000
diff --git a/Documentation/DocBook/media/v4l/driver.xml b/Documentation/DocBook/media/v4l/driver.xml
deleted file mode 100644
index 7c6638bacedb..000000000000
diff --git a/Documentation/DocBook/media/v4l/fdl-appendix.xml b/Documentation/DocBook/media/v4l/fdl-appendix.xml
deleted file mode 100644
index 71299a3897c4..000000000000
diff --git a/Documentation/DocBook/media/v4l/fieldseq_bt.pdf b/Documentation/DocBook/media/v4l/fieldseq_bt.pdf
deleted file mode 100644
index 26598b23f80daf8048fdaa9a83a39a0e8ba12f19..0000000000000000000000000000000000000000
diff --git a/Documentation/DocBook/media/v4l/fieldseq_tb.pdf b/Documentation/DocBook/media/v4l/fieldseq_tb.pdf
deleted file mode 100644
index 4965b22ddb3a85aa27a4e6f98c931323605dd26e..0000000000000000000000000000000000000000
diff --git a/Documentation/DocBook/media/v4l/func-close.xml b/Documentation/DocBook/media/v4l/func-close.xml
deleted file mode 100644
index 232920d2f3c6..000000000000
diff --git a/Documentation/DocBook/media/v4l/func-ioctl.xml b/Documentation/DocBook/media/v4l/func-ioctl.xml
deleted file mode 100644
index 4394184a1a6d..000000000000
diff --git a/Documentation/DocBook/media/v4l/func-mmap.xml b/Documentation/DocBook/media/v4l/func-mmap.xml
deleted file mode 100644
index f31ad71bf301..000000000000
diff --git a/Documentation/DocBook/media/v4l/func-munmap.xml b/Documentation/DocBook/media/v4l/func-munmap.xml
deleted file mode 100644
index 860d49ca54a5..000000000000
diff --git a/Documentation/DocBook/media/v4l/func-open.xml b/Documentation/DocBook/media/v4l/func-open.xml
deleted file mode 100644
index cf64e207c3ee..000000000000
diff --git a/Documentation/DocBook/media/v4l/func-poll.xml b/Documentation/DocBook/media/v4l/func-poll.xml
deleted file mode 100644
index 4c73f115219b..000000000000
diff --git a/Documentation/DocBook/media/v4l/func-read.xml b/Documentation/DocBook/media/v4l/func-read.xml
deleted file mode 100644
index e218bbfbd362..000000000000
diff --git a/Documentation/DocBook/media/v4l/func-select.xml b/Documentation/DocBook/media/v4l/func-select.xml
deleted file mode 100644
index e12a60d9bd85..000000000000
diff --git a/Documentation/DocBook/media/v4l/func-write.xml b/Documentation/DocBook/media/v4l/func-write.xml
deleted file mode 100644
index 575207885726..000000000000
diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
deleted file mode 100644
index 7e29a4e1f696..000000000000
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
deleted file mode 100644
index 21a3dde8f95d..000000000000
diff --git a/Documentation/DocBook/media/v4l/keytable.c.xml b/Documentation/DocBook/media/v4l/keytable.c.xml
deleted file mode 100644
index d53254a3be15..000000000000
diff --git a/Documentation/DocBook/media/v4l/libv4l.xml b/Documentation/DocBook/media/v4l/libv4l.xml
deleted file mode 100644
index d3b71e20003c..000000000000
diff --git a/Documentation/DocBook/media/v4l/lirc_device_interface.xml b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
deleted file mode 100644
index f53ad58027a7..000000000000
diff --git a/Documentation/DocBook/media/v4l/media-controller.xml b/Documentation/DocBook/media/v4l/media-controller.xml
deleted file mode 100644
index 5f2fc07a93d7..000000000000
diff --git a/Documentation/DocBook/media/v4l/media-func-close.xml b/Documentation/DocBook/media/v4l/media-func-close.xml
deleted file mode 100644
index be149c802aeb..000000000000
diff --git a/Documentation/DocBook/media/v4l/media-func-ioctl.xml b/Documentation/DocBook/media/v4l/media-func-ioctl.xml
deleted file mode 100644
index 39478d0fbcaa..000000000000
diff --git a/Documentation/DocBook/media/v4l/media-func-open.xml b/Documentation/DocBook/media/v4l/media-func-open.xml
deleted file mode 100644
index 122374a3e894..000000000000
diff --git a/Documentation/DocBook/media/v4l/media-ioc-device-info.xml b/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
deleted file mode 100644
index b0a21ac300b8..000000000000
diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
deleted file mode 100644
index 0c4f96bfc2de..000000000000
diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
deleted file mode 100644
index 2bbeea9f3e18..000000000000
diff --git a/Documentation/DocBook/media/v4l/media-ioc-g-topology.xml b/Documentation/DocBook/media/v4l/media-ioc-g-topology.xml
deleted file mode 100644
index e0d49fa329f0..000000000000
diff --git a/Documentation/DocBook/media/v4l/media-ioc-setup-link.xml b/Documentation/DocBook/media/v4l/media-ioc-setup-link.xml
deleted file mode 100644
index fc2e522ee65a..000000000000
diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
deleted file mode 100644
index 95aa1f9c836a..000000000000
diff --git a/Documentation/DocBook/media/v4l/pipeline.pdf b/Documentation/DocBook/media/v4l/pipeline.pdf
deleted file mode 100644
index ee3e37f04b6a788e255ce26d1607e77ba2c119a3..0000000000000000000000000000000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-grey.xml b/Documentation/DocBook/media/v4l/pixfmt-grey.xml
deleted file mode 100644
index bee970d3f76d..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-m420.xml b/Documentation/DocBook/media/v4l/pixfmt-m420.xml
deleted file mode 100644
index aadae92c5d04..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
deleted file mode 100644
index 84dd4fd7cb80..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
deleted file mode 100644
index f3a3d459fcdf..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml
deleted file mode 100644
index 8a70a1707b7a..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv16.xml b/Documentation/DocBook/media/v4l/pixfmt-nv16.xml
deleted file mode 100644
index 8ae1f8a810d0..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
deleted file mode 100644
index fb2b5e35d665..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv24.xml b/Documentation/DocBook/media/v4l/pixfmt-nv24.xml
deleted file mode 100644
index fb255f2ca9dd..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
deleted file mode 100644
index b60fb935b91b..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-yuv.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-yuv.xml
deleted file mode 100644
index 33fa5a47a865..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml b/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
deleted file mode 100644
index 6494b05d84a1..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml b/Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml
deleted file mode 100644
index 5eaf2b42d3f7..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml
deleted file mode 100644
index 6118d8f7a20c..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml
deleted file mode 100644
index e4b494ce1369..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
deleted file mode 100644
index 2d80104c178b..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml
deleted file mode 100644
index 26288ffa9071..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml
deleted file mode 100644
index 3df076b99f94..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml b/Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml
deleted file mode 100644
index fee65dca79c5..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml b/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml
deleted file mode 100644
index 7803b8c41b45..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
deleted file mode 100644
index f34d03ebda3a..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
deleted file mode 100644
index d2e5845e57fb..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
deleted file mode 100644
index bde89878c5c5..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
deleted file mode 100644
index a8cc102cde4f..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
deleted file mode 100644
index 0c8e4adf417f..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb8.xml
deleted file mode 100644
index 2570e3be3cf1..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-uv8.xml b/Documentation/DocBook/media/v4l/pixfmt-uv8.xml
deleted file mode 100644
index c507c1f73cd0..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-uyvy.xml b/Documentation/DocBook/media/v4l/pixfmt-uyvy.xml
deleted file mode 100644
index b1f6801a17ff..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-vyuy.xml b/Documentation/DocBook/media/v4l/pixfmt-vyuy.xml
deleted file mode 100644
index 82803408b389..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-y10.xml b/Documentation/DocBook/media/v4l/pixfmt-y10.xml
deleted file mode 100644
index d065043db8d8..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-y10b.xml b/Documentation/DocBook/media/v4l/pixfmt-y10b.xml
deleted file mode 100644
index adb0ad808c93..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-y12.xml b/Documentation/DocBook/media/v4l/pixfmt-y12.xml
deleted file mode 100644
index ff417b858cc9..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-y12i.xml b/Documentation/DocBook/media/v4l/pixfmt-y12i.xml
deleted file mode 100644
index 4a2d1e5f67e4..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-y16-be.xml b/Documentation/DocBook/media/v4l/pixfmt-y16-be.xml
deleted file mode 100644
index cea53e1eaa43..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-y16.xml b/Documentation/DocBook/media/v4l/pixfmt-y16.xml
deleted file mode 100644
index ff4f727d5624..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-y41p.xml b/Documentation/DocBook/media/v4l/pixfmt-y41p.xml
deleted file mode 100644
index 98dcb91d2917..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-y8i.xml b/Documentation/DocBook/media/v4l/pixfmt-y8i.xml
deleted file mode 100644
index 99f389d4c6c8..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv410.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv410.xml
deleted file mode 100644
index 0869dce5f92c..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml
deleted file mode 100644
index 086dc731bf02..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv420.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv420.xml
deleted file mode 100644
index 48649fac1596..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
deleted file mode 100644
index 7d13fe96657d..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
deleted file mode 100644
index dd502802cb75..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml
deleted file mode 100644
index 4ce6463fe0a5..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml
deleted file mode 100644
index 1b7335940bc7..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuyv.xml b/Documentation/DocBook/media/v4l/pixfmt-yuyv.xml
deleted file mode 100644
index 58384092251a..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yvyu.xml b/Documentation/DocBook/media/v4l/pixfmt-yvyu.xml
deleted file mode 100644
index bfffdc76d3da..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt-z16.xml b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
deleted file mode 100644
index 1d9cb1684bd3..000000000000
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
deleted file mode 100644
index 5a08aeea4360..000000000000
diff --git a/Documentation/DocBook/media/v4l/planar-apis.xml b/Documentation/DocBook/media/v4l/planar-apis.xml
deleted file mode 100644
index 878ce2040488..000000000000
diff --git a/Documentation/DocBook/media/v4l/remote_controllers.xml b/Documentation/DocBook/media/v4l/remote_controllers.xml
deleted file mode 100644
index b86844e80257..000000000000
diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
deleted file mode 100644
index b764cba150d1..000000000000
diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
deleted file mode 100644
index d6d56fb6f9c0..000000000000
diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
deleted file mode 100644
index 199c84e3aede..000000000000
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia b/Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
deleted file mode 100644
index e32ba5362e1d..000000000000
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg b/Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg
deleted file mode 100644
index 18b0f5de9ed2..000000000000
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-full.dia b/Documentation/DocBook/media/v4l/subdev-image-processing-full.dia
deleted file mode 100644
index a0d782927840..000000000000
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-full.svg b/Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
deleted file mode 100644
index 3322cf4c0093..000000000000
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia b/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
deleted file mode 100644
index 0cd50a7bda80..000000000000
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg b/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg
deleted file mode 100644
index 2340c0f8bc92..000000000000
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
deleted file mode 100644
index 42e626d6c936..000000000000
diff --git a/Documentation/DocBook/media/v4l/v4l2grab.c.xml b/Documentation/DocBook/media/v4l/v4l2grab.c.xml
deleted file mode 100644
index bed12e40be27..000000000000
diff --git a/Documentation/DocBook/media/v4l/vbi_525.pdf b/Documentation/DocBook/media/v4l/vbi_525.pdf
deleted file mode 100644
index 9e72c25b208db6c7844ed85fe9742324602c0a5c..0000000000000000000000000000000000000000
diff --git a/Documentation/DocBook/media/v4l/vbi_625.pdf b/Documentation/DocBook/media/v4l/vbi_625.pdf
deleted file mode 100644
index 765235e33a4de256a0b3fbf64ffe52946190cac4..0000000000000000000000000000000000000000
diff --git a/Documentation/DocBook/media/v4l/vbi_hsync.pdf b/Documentation/DocBook/media/v4l/vbi_hsync.pdf
deleted file mode 100644
index 200b668189bf1d0761dbcd75f38e43cb4d703a33..0000000000000000000000000000000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
deleted file mode 100644
index 6528e97b8990..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
deleted file mode 100644
index 50cb940cbe5c..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
deleted file mode 100644
index f14a3bb1afaa..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
deleted file mode 100644
index 5877f68a5820..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
deleted file mode 100644
index 73eb5cfe698a..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
deleted file mode 100644
index c9c3c7713832..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
deleted file mode 100644
index ca9ffce9b4c1..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
deleted file mode 100644
index 70a4a08e9404..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
deleted file mode 100644
index 9b3d42018b69..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
deleted file mode 100644
index f8dfeed34fca..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml b/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
deleted file mode 100644
index 7c839ab0afbb..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
deleted file mode 100644
index 9ed68ac8f474..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml b/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
deleted file mode 100644
index a0608abc1ab8..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumaudio.xml b/Documentation/DocBook/media/v4l/vidioc-enumaudio.xml
deleted file mode 100644
index ea816ab2e49e..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumaudioout.xml b/Documentation/DocBook/media/v4l/vidioc-enumaudioout.xml
deleted file mode 100644
index 2e87cedb0d32..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
deleted file mode 100644
index 603fecef9083..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
deleted file mode 100644
index 773fb1258c24..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumstd.xml b/Documentation/DocBook/media/v4l/vidioc-enumstd.xml
deleted file mode 100644
index f18454e91752..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
deleted file mode 100644
index a6558a676ef3..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-audio.xml b/Documentation/DocBook/media/v4l/vidioc-g-audio.xml
deleted file mode 100644
index d7bb9b3738f6..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-audioout.xml b/Documentation/DocBook/media/v4l/vidioc-g-audioout.xml
deleted file mode 100644
index 200a2704a970..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-crop.xml b/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
deleted file mode 100644
index e6c4efb9e8b4..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml b/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
deleted file mode 100644
index ee2820d6ca66..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
deleted file mode 100644
index 06952d7cc770..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-edid.xml b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
deleted file mode 100644
index b7602d30f596..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml b/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
deleted file mode 100644
index be25029a16f1..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
deleted file mode 100644
index eb82f7e7d06b..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml b/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
deleted file mode 100644
index 77607cc19688..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
deleted file mode 100644
index ffcb448251f0..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
deleted file mode 100644
index d1034fb61d15..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-input.xml b/Documentation/DocBook/media/v4l/vidioc-g-input.xml
deleted file mode 100644
index 1d43065090dd..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml b/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
deleted file mode 100644
index 098ff483802e..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
deleted file mode 100644
index 96e17b344c5d..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-output.xml b/Documentation/DocBook/media/v4l/vidioc-g-output.xml
deleted file mode 100644
index 4533068ecb8a..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
deleted file mode 100644
index 721728745407..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-priority.xml b/Documentation/DocBook/media/v4l/vidioc-g-priority.xml
deleted file mode 100644
index 6a81b4fe9538..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
deleted file mode 100644
index 997f4e96f297..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml b/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
deleted file mode 100644
index d05623c55403..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-std.xml b/Documentation/DocBook/media/v4l/vidioc-g-std.xml
deleted file mode 100644
index 4a898417de28..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
deleted file mode 100644
index 459b7e561f3c..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-log-status.xml b/Documentation/DocBook/media/v4l/vidioc-log-status.xml
deleted file mode 100644
index 5ded7d35e27b..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-overlay.xml b/Documentation/DocBook/media/v4l/vidioc-overlay.xml
deleted file mode 100644
index 250a7de1877f..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
deleted file mode 100644
index 7bde698760e4..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
deleted file mode 100644
index 8b98a0e421fc..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
deleted file mode 100644
index d41bf47ee5a2..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-querybuf.xml b/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
deleted file mode 100644
index 50bfcb5e8508..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
deleted file mode 100644
index cd82148dedd7..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
deleted file mode 100644
index 55b7582cf314..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-querystd.xml b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
deleted file mode 100644
index 3ceae35fab03..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
deleted file mode 100644
index 6f529e100ea4..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
deleted file mode 100644
index a5fc4c4880f3..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-streamon.xml b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
deleted file mode 100644
index 89fd7ce964f9..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml
deleted file mode 100644
index 9d0251a27e5f..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml
deleted file mode 100644
index 9b91b8332ba9..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml
deleted file mode 100644
index c67256ada87a..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-crop.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-crop.xml
deleted file mode 100644
index 4cddd788c589..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
deleted file mode 100644
index 781089cba453..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-frame-interval.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-frame-interval.xml
deleted file mode 100644
index 848ec789ddaa..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
deleted file mode 100644
index 8346b2e4a703..000000000000
diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
deleted file mode 100644
index 5fd0ee78f880..000000000000
diff --git a/Documentation/DocBook/media/vbi_525.gif.b64 b/Documentation/DocBook/media/vbi_525.gif.b64
deleted file mode 100644
index d5dcf06f2aef..000000000000
diff --git a/Documentation/DocBook/media/vbi_625.gif.b64 b/Documentation/DocBook/media/vbi_625.gif.b64
deleted file mode 100644
index 831f49a02821..000000000000
diff --git a/Documentation/DocBook/media/vbi_hsync.gif.b64 b/Documentation/DocBook/media/vbi_hsync.gif.b64
deleted file mode 100644
index cdafabed5c11..000000000000
diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index fd565e1f1368..b10b6c598ae2 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -63,7 +63,6 @@ sgmldocs:
 psdocs:
 mandocs:
 installmandocs:
-cleanmediadocs:
 
 cleandocs:
 	$(Q)rm -rf $(BUILDDIR)
diff --git a/Makefile b/Makefile
index 6cd4d62cb1c1..b993c42340d6 100644
--- a/Makefile
+++ b/Makefile
@@ -1416,7 +1416,7 @@ $(help-board-dirs): help-%:
 
 # Documentation targets
 # ---------------------------------------------------------------------------
-DOC_TARGETS := xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs epubdocs cleandocs cleanmediadocs
+DOC_TARGETS := xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs epubdocs cleandocs
 PHONY += $(DOC_TARGETS)
 $(DOC_TARGETS): scripts_basic FORCE
 	$(Q)$(MAKE) $(build)=scripts build_docproc build_check-lc_ctype
-- 
2.7.4


