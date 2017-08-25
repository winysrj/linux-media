Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49397
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754464AbdHYJkO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 05:40:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        mjpeg-users@lists.sourceforge.net, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Ian King <colin.king@canonical.com>,
        Jonathan Sims <jonathan.625266@earthlink.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antti Palosaari <crope@iki.fi>,
        Andy Walls <awalls@md.metrocast.net>,
        Anton Sviridenko <anton@corp.bluecherry.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Mike Isely <isely@pobox.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        linux-usb@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Antoine Jacquet <royale@zerezo.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Joe Perches <joe@perches.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 0/3] document types of hardware control for V4L2
Date: Fri, 25 Aug 2017 06:40:04 -0300
Message-Id: <cover.1503653839.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2010, we introduced a new way to control complex V4L2 devices used
on embedded systems, but this was never documented, nor it is possible
for an userspace applicatin to detect the kind of control a device supports.

This series fill the gap.

Mauro Carvalho Chehab (3):
  media: open.rst: document devnode-centric and mc-centric types
  media: videodev2: add a flag for vdev-centric devices
  media: add V4L2_CAP_VDEV_CENTERED flag on vdev-centric drivers

 Documentation/media/uapi/v4l/open.rst            | 56 ++++++++++++++++++++++++
 Documentation/media/uapi/v4l/vidioc-querycap.rst |  4 ++
 drivers/media/pci/bt8xx/bttv-driver.c            |  4 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c           |  3 +-
 drivers/media/pci/cx18/cx18-ioctl.c              |  4 +-
 drivers/media/pci/cx23885/cx23885-417.c          |  2 +-
 drivers/media/pci/cx23885/cx23885-video.c        |  3 +-
 drivers/media/pci/cx25821/cx25821-video.c        |  6 ++-
 drivers/media/pci/cx88/cx88-video.c              |  3 +-
 drivers/media/pci/dt3155/dt3155.c                |  3 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c              |  5 ++-
 drivers/media/pci/meye/meye.c                    |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c        |  3 +-
 drivers/media/pci/saa7164/saa7164-encoder.c      |  3 +-
 drivers/media/pci/saa7164/saa7164-vbi.c          |  3 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c   |  3 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c       |  3 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c          |  3 +-
 drivers/media/pci/tw5864/tw5864-video.c          |  2 +-
 drivers/media/pci/tw68/tw68-video.c              |  3 +-
 drivers/media/pci/tw686x/tw686x-video.c          |  2 +-
 drivers/media/pci/zoran/zoran_driver.c           |  3 +-
 drivers/media/platform/rcar_drif.c               |  3 +-
 drivers/media/platform/vivid/vivid-core.c        |  2 +-
 drivers/media/usb/airspy/airspy.c                |  3 +-
 drivers/media/usb/au0828/au0828-video.c          |  3 +-
 drivers/media/usb/cpia2/cpia2_v4l.c              |  5 ++-
 drivers/media/usb/cx231xx/cx231xx-video.c        |  5 ++-
 drivers/media/usb/em28xx/em28xx-video.c          | 11 +++--
 drivers/media/usb/go7007/go7007-v4l2.c           |  2 +-
 drivers/media/usb/gspca/gspca.c                  |  3 +-
 drivers/media/usb/hackrf/hackrf.c                |  8 ++--
 drivers/media/usb/hdpvr/hdpvr-video.c            |  2 +-
 drivers/media/usb/msi2500/msi2500.c              |  3 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c         |  6 ++-
 drivers/media/usb/pwc/pwc-v4l.c                  |  2 +-
 drivers/media/usb/s2255/s2255drv.c               |  2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c          |  3 +-
 drivers/media/usb/stkwebcam/stk-webcam.c         |  3 +-
 drivers/media/usb/tm6000/tm6000-video.c          |  5 ++-
 drivers/media/usb/usbtv/usbtv-video.c            |  2 +-
 drivers/media/usb/usbvision/usbvision-video.c    |  5 ++-
 drivers/media/usb/uvc/uvc_v4l2.c                 |  8 ++--
 drivers/media/usb/zr364xx/zr364xx.c              |  5 ++-
 include/uapi/linux/videodev2.h                   |  2 +
 45 files changed, 158 insertions(+), 58 deletions(-)

-- 
2.13.3
