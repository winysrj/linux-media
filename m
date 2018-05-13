Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:39996 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751104AbeEMLF3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 07:05:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/3] cpia2/zr364xx/usbvision: move to staging
Date: Sun, 13 May 2018 13:05:22 +0200
Message-Id: <20180513110525.20062-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since we're going to deprecate the zoran driver (and remove it in a
year), I thought that this is a good time to look at some other
drivers that 1) do not use the proper frameworks (vb2!) and 2) are
for ancient hardware for which there are easily available working
alternatives.

This patch series proposes to move the following drivers to staging:

- cpia2: used in old USB microscopes. The last real change was in
  April 2012 by me.

- zr364xx: used in (very!) old digital cameras. The last real change
  was in June 2012 by me.

- usbvision: old TV capture device. Never worked very well. The last
  changes where for a bug report in end 2015/early 2016 and many
  fixed/improvements from me in July 2015.

The cpia2 and usbvision have their own streaming implementation,
the zr364xx uses vb1.

I don't think it is likely that anyone is willing to convert these
drivers to vb2.

Regards,

	Hans

Hans Verkuil (3):
  cpia2: move to staging in preparation for removal
  zr364xx: move to staging in preparation for removal
  usbvision: move to staging in preparation for removal

 MAINTAINERS                                                 | 4 ++--
 drivers/media/usb/Kconfig                                   | 3 ---
 drivers/media/usb/Makefile                                  | 4 +---
 drivers/staging/media/Kconfig                               | 6 ++++++
 drivers/staging/media/Makefile                              | 3 +++
 drivers/{media/usb => staging/media}/cpia2/Kconfig          | 2 +-
 drivers/{media/usb => staging/media}/cpia2/Makefile         | 0
 drivers/staging/media/cpia2/TODO                            | 4 ++++
 drivers/{media/usb => staging/media}/cpia2/cpia2.h          | 0
 drivers/{media/usb => staging/media}/cpia2/cpia2_core.c     | 0
 .../{media/usb => staging/media}/cpia2/cpia2_registers.h    | 0
 drivers/{media/usb => staging/media}/cpia2/cpia2_usb.c      | 0
 drivers/{media/usb => staging/media}/cpia2/cpia2_v4l.c      | 0
 drivers/{media/usb => staging/media}/usbvision/Kconfig      | 2 +-
 drivers/{media/usb => staging/media}/usbvision/Makefile     | 0
 drivers/staging/media/usbvision/TODO                        | 4 ++++
 .../usb => staging/media}/usbvision/usbvision-cards.c       | 0
 .../usb => staging/media}/usbvision/usbvision-cards.h       | 0
 .../{media/usb => staging/media}/usbvision/usbvision-core.c | 0
 .../{media/usb => staging/media}/usbvision/usbvision-i2c.c  | 0
 .../usb => staging/media}/usbvision/usbvision-video.c       | 0
 drivers/{media/usb => staging/media}/usbvision/usbvision.h  | 0
 drivers/{media/usb => staging/media}/zr364xx/Kconfig        | 0
 drivers/{media/usb => staging/media}/zr364xx/Makefile       | 0
 drivers/staging/media/zr364xx/TODO                          | 4 ++++
 drivers/{media/usb => staging/media}/zr364xx/zr364xx.c      | 0
 26 files changed, 26 insertions(+), 10 deletions(-)
 rename drivers/{media/usb => staging/media}/cpia2/Kconfig (87%)
 rename drivers/{media/usb => staging/media}/cpia2/Makefile (100%)
 create mode 100644 drivers/staging/media/cpia2/TODO
 rename drivers/{media/usb => staging/media}/cpia2/cpia2.h (100%)
 rename drivers/{media/usb => staging/media}/cpia2/cpia2_core.c (100%)
 rename drivers/{media/usb => staging/media}/cpia2/cpia2_registers.h (100%)
 rename drivers/{media/usb => staging/media}/cpia2/cpia2_usb.c (100%)
 rename drivers/{media/usb => staging/media}/cpia2/cpia2_v4l.c (100%)
 rename drivers/{media/usb => staging/media}/usbvision/Kconfig (82%)
 rename drivers/{media/usb => staging/media}/usbvision/Makefile (100%)
 create mode 100644 drivers/staging/media/usbvision/TODO
 rename drivers/{media/usb => staging/media}/usbvision/usbvision-cards.c (100%)
 rename drivers/{media/usb => staging/media}/usbvision/usbvision-cards.h (100%)
 rename drivers/{media/usb => staging/media}/usbvision/usbvision-core.c (100%)
 rename drivers/{media/usb => staging/media}/usbvision/usbvision-i2c.c (100%)
 rename drivers/{media/usb => staging/media}/usbvision/usbvision-video.c (100%)
 rename drivers/{media/usb => staging/media}/usbvision/usbvision.h (100%)
 rename drivers/{media/usb => staging/media}/zr364xx/Kconfig (100%)
 rename drivers/{media/usb => staging/media}/zr364xx/Makefile (100%)
 create mode 100644 drivers/staging/media/zr364xx/TODO
 rename drivers/{media/usb => staging/media}/zr364xx/zr364xx.c (100%)

-- 
2.17.0
