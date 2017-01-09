Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:51440 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936339AbdAIOTT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 09:19:19 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL v2 FOR v4.11] More fixes/enhancements
Message-ID: <a71b717d-9803-ba89-d248-4c8deb255583@xs4all.nl>
Date: Mon, 9 Jan 2017 15:19:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1:

- removed the "v4l2-common: fix aligned value calculation": it was withdrawn and I
  missed that.
- added pvrusb2-io cleanup patches.

Regards,

	Hans

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.11b

for you to fetch changes up to e8338cdfa3ccef452c3a521d447d8f6dce231d03:

  pvrusb2-io: Add some spaces for better code readability (2017-01-09 15:13:11 +0100)

----------------------------------------------------------------
Andrzej Hajda (1):
      v4l: s5c73m3: fix negation operator

Kees Cook (2):
      mtk-vcodec: use designated initializers
      solo6x10: use designated initializers

Kevin Hilman (5):
      davinci: VPIF: fix module loading, init errors
      davinci: vpif_capture: remove hard-coded I2C adapter id
      davinci: vpif_capture: fix start/stop streaming locking
      dt-bindings: add TI VPIF documentation
      davinci: VPIF: add basic support for DT init

Markus Elfring (4):
      v4l2-async: Use kmalloc_array() in v4l2_async_notifier_unregister()
      v4l2-async: Delete an error message for a failed memory allocation in v4l2_async_notifier_unregister()
      pvrusb2-io: Use kmalloc_array() in pvr2_stream_buffer_count()
      pvrusb2-io: Add some spaces for better code readability

Pavel Machek (1):
      mark myself as mainainer for camera on N900

Randy Dunlap (1):
      media: fix dm1105.c build error

Santosh Kumar Singh (5):
      vim2m: Clean up file handle in open() error path.
      zoran: Clean up file handle in open() error path.
      tm6000: Clean up file handle in open() error path.
      ivtv: Clean up file handle in open() error path.
      pvrusb2: Clean up file handle in open() error path.

Shyam Saini (1):
      media: usb: cpia2: Use kmemdup instead of kmalloc and memcpy

Sudip Mukherjee (1):
      bt8xx: fix memory leak

 Documentation/devicetree/bindings/media/ti,da850-vpif.txt |  83 ++++++++++++++++++++++++++++
 MAINTAINERS                                               |   8 +++
 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c                 |   2 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c                       |   1 +
 drivers/media/pci/dm1105/Kconfig                          |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c                    |   1 +
 drivers/media/pci/solo6x10/solo6x10-g723.c                |   2 +-
 drivers/media/pci/zoran/zoran_driver.c                    |   1 +
 drivers/media/platform/davinci/vpif.c                     |  14 ++++-
 drivers/media/platform/davinci/vpif_capture.c             |  24 +++++++--
 drivers/media/platform/davinci/vpif_capture.h             |   2 +-
 drivers/media/platform/davinci/vpif_display.c             |   6 +++
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c     |   8 +--
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c      |   8 +--
 drivers/media/platform/vim2m.c                            |   2 +
 drivers/media/usb/cpia2/cpia2_usb.c                       |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-io.c                    | 123 +++++++++++++++++++++---------------------
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                  |   3 +-
 drivers/media/usb/tm6000/tm6000-video.c                   |   5 +-
 drivers/media/v4l2-core/v4l2-async.c                      |   7 +--
 include/media/davinci/vpif_types.h                        |   1 +
 21 files changed, 218 insertions(+), 89 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif.txt
