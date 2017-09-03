Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50958
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752897AbdICCfO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Masanari Iida <standby24x7@gmail.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        Hans Verkuil <hansverk@cisco.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sean Young <sean@mess.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Aviv Greenberg <aviv.d.greenberg@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 00/12] media documentation ReST fixes
Date: Sat,  2 Sep 2017 23:34:52 -0300
Message-Id: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series contain media documentation ReST fixes, mostly related to
table parsing and the corresponding PDF output (tested with Sphinx 1.4).

It also contains a few documentation trivial improvements, from a
few minor issues I noticed when reading the PDF output text on some
places.

Probably the most important one is a regression that was causing the
media book build to return an error, introduced by changeset
70b074df4ed1 ("media: fix pdf build with Spinx 1.6"). 

My plan is to merge this patch series soon via the media tree, 
and send it upstream during this merge window.

Markus, 

Perhaps you could take a look on it. It is related to the usage of cspan
and the corresponding PDF output.

Mauro Carvalho Chehab (12):
  media: v4l uAPI: add descriptions for arguments to all ioctls
  media: vidioc-querycap: use a more realistic value for KERNEL_VERSION
  media: vidioc-g-tuner.rst: Fix table number of cols
  media: v4l uAPI docs: adjust some tables for PDF output
  media: docs: fix PDF build with Sphinx 1.4
  media: rc-sysfs-nodes.rst: better use literals
  media: mc uapi: adjust some table sizes for PDF output
  media: cec uapi: Adjust table sizes for PDF output
  media: docs: don't show ToC for each part on PDF output
  media: v4l2-event.rst: adjust table to fit on PDF output
  media: em28xx-cardlist.rst: update to reflect last changes
  media: docs-rst: cardlists: change their format to flat-tables

 Documentation/media/cec-drivers/index.rst          |   4 +-
 Documentation/media/dvb-drivers/index.rst          |   4 +-
 Documentation/media/kapi/v4l2-event.rst            |   2 +
 Documentation/media/media_kapi.rst                 |   4 +-
 Documentation/media/media_uapi.rst                 |   4 +-
 Documentation/media/uapi/cec/cec-api.rst           |   5 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |   7 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |   9 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |   2 +
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |   2 +
 Documentation/media/uapi/dvb/dvbapi.rst            |   4 +-
 .../media/uapi/mediactl/media-controller.rst       |   4 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst      |   2 +-
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |   2 +-
 Documentation/media/uapi/mediactl/media-types.rst  |   2 +-
 Documentation/media/uapi/rc/rc-sysfs-nodes.rst     |  10 +-
 Documentation/media/uapi/rc/remote_controllers.rst |   4 +-
 Documentation/media/uapi/v4l/colorspaces-defs.rst  |   2 +
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst |   6 +-
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst |   3 +-
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst   |   2 +-
 .../media/uapi/v4l/v4l2-selection-targets.rst      |   2 +-
 Documentation/media/uapi/v4l/v4l2.rst              |   4 +-
 .../media/uapi/v4l/vidioc-create-bufs.rst          |   1 +
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |   1 +
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |   1 +
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |   1 +
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   1 +
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |   1 +
 .../media/uapi/v4l/vidioc-encoder-cmd.rst          |   2 +-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |   1 +
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   1 +
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |   5 +-
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |   4 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |   1 +
 Documentation/media/uapi/v4l/vidioc-enumaudio.rst  |   1 +
 .../media/uapi/v4l/vidioc-enumaudioout.rst         |   1 +
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |   1 +
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |   1 +
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |   1 +
 Documentation/media/uapi/v4l/vidioc-expbuf.rst     |   1 +
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    |   1 +
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |   1 +
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |   1 +
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst     |   1 +
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |   1 +
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     |   1 +
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |   1 +
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |   1 +
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |   1 +
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |   1 +
 .../media/uapi/v4l/vidioc-g-frequency.rst          |   1 +
 Documentation/media/uapi/v4l/vidioc-g-input.rst    |   1 +
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |   1 +
 .../media/uapi/v4l/vidioc-g-modulator.rst          |   1 +
 Documentation/media/uapi/v4l/vidioc-g-output.rst   |   1 +
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |   1 +
 Documentation/media/uapi/v4l/vidioc-g-priority.rst |   2 +-
 .../media/uapi/v4l/vidioc-g-selection.rst          |   5 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |   1 +
 Documentation/media/uapi/v4l/vidioc-g-std.rst      |   1 +
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |  10 +-
 Documentation/media/uapi/v4l/vidioc-overlay.rst    |   1 +
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |   1 +
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |   1 +
 .../media/uapi/v4l/vidioc-query-dv-timings.rst     |   1 +
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |   1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |   8 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |   2 +
 Documentation/media/uapi/v4l/vidioc-querystd.rst   |   1 +
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |   2 +-
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |   1 +
 Documentation/media/uapi/v4l/vidioc-streamon.rst   |   2 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |   1 +
 .../uapi/v4l/vidioc-subdev-enum-frame-size.rst     |   1 +
 .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst      |   1 +
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |   1 +
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |   1 +
 .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    |   1 +
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |   1 +
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |   5 +-
 .../media/v4l-drivers/au0828-cardlist.rst          |  44 +-
 Documentation/media/v4l-drivers/bttv-cardlist.rst  | 849 +++++++++++++----
 .../media/v4l-drivers/cx23885-cardlist.rst         | 304 +++++--
 Documentation/media/v4l-drivers/cx88-cardlist.rst  | 469 ++++++++--
 .../media/v4l-drivers/em28xx-cardlist.rst          | 523 ++++++++---
 Documentation/media/v4l-drivers/index.rst          |   4 +-
 Documentation/media/v4l-drivers/ivtv-cardlist.rst  | 169 +++-
 .../media/v4l-drivers/saa7134-cardlist.rst         | 999 ++++++++++++++++-----
 .../media/v4l-drivers/saa7164-cardlist.rst         |  84 +-
 .../media/v4l-drivers/tm6000-cardlist.rst          |  99 +-
 .../media/v4l-drivers/usbvision-cardlist.rst       | 349 +++++--
 92 files changed, 3240 insertions(+), 837 deletions(-)

-- 
2.13.5
