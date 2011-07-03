Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab1GCT7a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jul 2011 15:59:30 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p63JxUNY019425
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 3 Jul 2011 15:59:30 -0400
Received: from shalem.localdomain (vpn1-7-37.ams2.redhat.com [10.36.7.37])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p63JxSPn014294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 3 Jul 2011 15:59:29 -0400
Message-ID: <4E10CA67.1030906@redhat.com>
Date: Sun, 03 Jul 2011 22:00:39 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.1] New SE401 driver + major pwc driver cleanup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi All,

I'm happy to present my latest webcam work to you:

I could not just stand by watching the old v4l1 se401 driver
(which has been broken for a long while btw) get removed
from the kernel, without writing a replacement, so I'm
happy to present a new, actually working, gspca based
v4l2 driver for se401 based webcams :)

I've also wanted to do some much needed cleanups to the
pwc driver for a long while. When I finally started with
this I ended up with just replacing large parts with
the new v4l2 framework, so after this patch set pwc
now features:
-videobuf2 for buffer management
-ctrls handled by the control framework, including proper
  setting inactive of foo controls when autofoo is on, etc.
-new v4l2 controls for pan/tilt on models with pan/tilt
  to replace the non standard sysfs interface for this

May I also point your attention to the
feature-removal-schedule commit, which adds a whole bunch
of custom pwc API's / ioctls for removal, since we can
handle this all fine with v4l2. If you think some of
these should not be removed speak up now, or hold
your silence for ever :)

The following changes since commit 0c2ec360f0228bbc0c0eb6f115839d39fbbd9c61:

   [media] v4l2-event.h: add overview documentation to the header (2011-07-01 20:54:03 -0300)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git media-for_v3.1

Hans Verkuil (1):
       [media] v4l2-ctrls.c: add support for V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK

Hans de Goede (22):
       videodev2.h Add SE401 compressed RGB format
       gspca: reset image_len to 0 on LAST_PACKET when discarding frame
       gspca: Add new se401 camera driver
       gspca_sunplus: Fix streaming on logitech quicksmart 420
       gspca: s/strncpy/strlcpy/
       pwc: better usb disconnect handling
       pwc: Remove a bunch of bogus sanity checks / don't return EFAULT wrongly
       pwc: remove __cplusplus guards from private header
       pwc: Replace private buffer management code with videobuf2
       pwc: Fix non CodingStyle compliant 3 space indent in pwc.h
       pwc: Get rid of error_status and unplugged variables
       pwc: Remove some unused PWC_INT_PIPE left overs
       pwc: Make power-saving a per device option
       pwc: Move various initialization to driver load and / or stream start
       pwc: Allow multiple opens
       pwc: properly allocate dma-able memory for ISO buffers
       pwc: Replace control code with v4l2-ctrls framework
       pwc: Allow dqbuf / read to complete while waiting for controls
       pwc: Add v4l2 controls for pan/tilt on Logitech QuickCam Orbit/Sphere
       pwc: Add a bunch of pwc custom API to feature-removal-schedule.txt
       pwc: Enable power-management by default on tested models
       pwc: clean-up header files

  Documentation/DocBook/media/v4l/pixfmt.xml         |    5 +
  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   36 +-
  Documentation/feature-removal-schedule.txt         |   35 +
  drivers/media/video/gspca/Kconfig                  |   10 +
  drivers/media/video/gspca/Makefile                 |    2 +
  drivers/media/video/gspca/gspca.c                  |   11 +-
  drivers/media/video/gspca/se401.c                  |  774 +++++++++++
  drivers/media/video/gspca/se401.h                  |   90 ++
  drivers/media/video/gspca/sunplus.c                |    3 -
  drivers/media/video/gspca/t613.c                   |    2 +-
  drivers/media/video/pwc/Kconfig                    |    1 +
  drivers/media/video/pwc/pwc-ctrl.c                 |  805 ++----------
  drivers/media/video/pwc/pwc-dec1.c                 |   28 +-
  drivers/media/video/pwc/pwc-dec1.h                 |    8 +-
  drivers/media/video/pwc/pwc-dec23.c                |   22 -
  drivers/media/video/pwc/pwc-dec23.h                |   10 -
  drivers/media/video/pwc/pwc-if.c                   | 1399 ++++++--------------
  drivers/media/video/pwc/pwc-ioctl.h                |  322 -----
  drivers/media/video/pwc/pwc-kiara.c                |    1 -
  drivers/media/video/pwc/pwc-misc.c                 |    4 -
  drivers/media/video/pwc/pwc-uncompress.c           |   17 +-
  drivers/media/video/pwc/pwc-uncompress.h           |   40 -
  drivers/media/video/pwc/pwc-v4l.c                  | 1256 +++++++++++--------
  drivers/media/video/pwc/pwc.h                      |  404 +++---
  drivers/media/video/v4l2-ctrls.c                   |    3 +-
  include/linux/videodev2.h                          |    4 +-
  26 files changed, 2473 insertions(+), 2819 deletions(-)
  create mode 100644 drivers/media/video/gspca/se401.c
  create mode 100644 drivers/media/video/gspca/se401.h
  delete mode 100644 drivers/media/video/pwc/pwc-ioctl.h
  delete mode 100644 drivers/media/video/pwc/pwc-uncompress.h

Regards,

Hans
