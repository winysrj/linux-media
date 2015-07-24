Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47917 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbbGXIMs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 04:12:48 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0B4B52A00AA
	for <linux-media@vger.kernel.org>; Fri, 24 Jul 2015 10:11:36 +0200 (CEST)
Message-ID: <55B1F337.6030604@xs4all.nl>
Date: Fri, 24 Jul 2015 10:11:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] usbvision/zoran/fsl-viu: convert to the control
 framework
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've cleaned up some old patch series of mine that convert the usbvision, zoran
and fsl-viu drivers to the control framework.

I have tested the zoran and usbvision drivers, the fsl-viu driver has been tested
back in 2013: http://www.spinics.net/lists/linux-media/msg61898.html

I said these patch series were old :-)

Note that the usbvision driver is in a pretty bad state, but let's get this patch
series in and I'll see if I can continue cleaning it up.

The best thing for this driver would be to convert it to vb2 as I don't think
the current streaming code (not even using vb1!) is salvageable.

After this patch series is merged only three drivers remain that do not use the
control framework: uvc, pvrusb2 and saa7164. Next up will be saa7164 since that
one shouldn't be too difficult to convert. The other two are very difficult to
do, but converting pvrusb2 would be really, really nice since I could get rid
of the last legacy control ops in the subdev drivers.

Regards,

	Hans

The following changes since commit 4dc102b2f53d63207fa12a6ad49c7b6448bc3301:

  [media] dvb_core: Replace memset with eth_zero_addr (2015-07-22 13:32:21 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git convertctrl

for you to fetch changes up to 6c37fa7df8e46e296a51833dcfb705dde61558e6:

  bt819/saa7110/vpx3220: remove legacy control ops (2015-07-24 09:58:44 +0200)

----------------------------------------------------------------
Hans Verkuil (22):
      usbvision: remove power_on_at_open and timed power off
      usbvision: convert to the control framework
      usbvision: return valid error in usbvision_register_video()
      usbvision: remove g/s_audio and for radio remove enum/g/s_input
      usbvision: the radio device node has wrong caps
      usbvision: frequency fixes.
      usbvision: set field and colorspace.
      usbvision: fix locking error
      usbvision: fix DMA from stack warnings.
      usbvision: fix standards for S-Video/Composite inputs.
      usbvision: move init code to probe()
      fsl-viu: convert to the control framework.
      fsl-viu: fill in bus_info in vidioc_querycap.
      fsl-viu: fill in colorspace, always set field to interlaced.
      fsl-viu: add control event support.
      fsl-viu: small fixes.
      fsl-viu: drop format names
      zoran: remove unnecessary memset
      zoran: remove unused read/write functions
      zoran: use standard core lock
      zoran: convert to the control framework and to v4l2_fh
      bt819/saa7110/vpx3220: remove legacy control ops

 drivers/media/i2c/bt819.c                     |  11 ---
 drivers/media/i2c/saa7110.c                   |  11 ---
 drivers/media/i2c/vpx3220.c                   |   7 --
 drivers/media/pci/zoran/zoran.h               |   7 +-
 drivers/media/pci/zoran/zoran_card.c          |  11 ++-
 drivers/media/pci/zoran/zoran_driver.c        | 344 ++++++++++++++++--------------------------------------------------------------
 drivers/media/platform/fsl-viu.c              | 160 ++++++++++--------------------------
 drivers/media/usb/usbvision/usbvision-core.c  |  71 +++-------------
 drivers/media/usb/usbvision/usbvision-i2c.c   |   2 +-
 drivers/media/usb/usbvision/usbvision-video.c | 246 ++++++++++++++++++++------------------------------------
 drivers/media/usb/usbvision/usbvision.h       |  10 +--
 11 files changed, 226 insertions(+), 654 deletions(-)
