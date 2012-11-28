Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60078 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab2K1LEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 06:04:37 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so11846297obb.19
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 03:04:36 -0800 (PST)
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 28 Nov 2012 16:34:16 +0530
Message-ID: <CA+V-a8vSVGy0wqoBtG4RGiMgowVD29ScK3XVoPR2UAKzk8=kMw@mail.gmail.com>
Subject: [GIT PULL FOR v3.8] Mediabus And Pixel format supported by DM365
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Can you please pull the following patches, which add medibus and pixel
format supported by DM365.

Pull request for these patches was sent earlier
(http://patchwork.linuxtv.org/patch/13619/)
but was not accepted because no driver was using them. I have issued a
pull request for
the drivers using this formats http://patchwork.linuxtv.org/patch/15690/ .

Thanks and Regards,
--Prabhakar Lad


The following changes since commit c6c22955f80f2db9614b01fe5a3d1cfcd8b3d848:

  [media] dma-mapping: fix dma_common_get_sgtable() conditional
compilation (2012-11-27 09:42:31 -0200)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git v4l-mbus-fmts

Manjunath Hadli (2):
      media: add new mediabus format enums for dm365
      v4l2: add new pixel formats supported on dm365

 .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +++
 Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 +++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  250 +++++++++++++++++++-
 include/uapi/linux/v4l2-mediabus.h                 |   10 +-
 include/uapi/linux/videodev2.h                     |    8 +
 6 files changed, 358 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
