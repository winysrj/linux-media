Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab3BULht (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Feb 2013 06:37:49 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1LBbnw4032761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Feb 2013 06:37:49 -0500
Received: from localhost.localdomain (dhcp131-167.brq.redhat.com [10.34.131.167])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r1LBblUV013955
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 21 Feb 2013 06:37:49 -0500
Message-ID: <512607D0.4090302@redhat.com>
Date: Thu, 21 Feb 2013 12:41:04 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.10] gspca convert the last drivers over to the control-framework
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my gspca tree for a set of patches converting the last drivers
over to the control framework, as well as a patch getting rid of gspca's own
debug log-level magic, replacing it with v4l2_dbg instead.

The following changes since commit ed72d37a33fdf43dc47787fe220532cdec9da528:

   [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) (2013-02-13 18:05:29 -0200)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.10

for you to fetch changes up to e12706688cec26c07149941a44bb47a3c85df0f4:

   gspca: Remove gspca-specific debug magic (2013-02-21 12:07:05 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
       gspca_sonixj: Convert to the control framework
       gspca_sonixb: Remove querymenu function (dead code)

Hans de Goede (4):
       gscpa_gl860: Convert to the control framework
       gscpa_m5602: Convert to the control framework
       gscpa: Remove autogain_functions.h
       gspca: Remove old control code now that all drivers are converted

Theodore Kilgore (1):
       gspca: Remove gspca-specific debug magic

  drivers/media/usb/gspca/autogain_functions.h     | 183 --------
  drivers/media/usb/gspca/benq.c                   |   2 +-
  drivers/media/usb/gspca/conex.c                  |  12 +-
  drivers/media/usb/gspca/cpia1.c                  |  33 +-
  drivers/media/usb/gspca/etoms.c                  |  10 +-
  drivers/media/usb/gspca/gl860/gl860.c            | 224 ++++-----
  drivers/media/usb/gspca/gspca.c                  | 229 +---------
  drivers/media/usb/gspca/gspca.h                  |  62 +--
  drivers/media/usb/gspca/jeilinj.c                |   2 +-
  drivers/media/usb/gspca/konica.c                 |  28 +-
  drivers/media/usb/gspca/m5602/m5602_bridge.h     |  27 +-
  drivers/media/usb/gspca/m5602/m5602_core.c       |  22 +-
  drivers/media/usb/gspca/m5602/m5602_mt9m111.c    | 404 +++++-----------
  drivers/media/usb/gspca/m5602/m5602_mt9m111.h    |   2 +
  drivers/media/usb/gspca/m5602/m5602_ov7660.c     | 308 +++----------
  drivers/media/usb/gspca/m5602/m5602_ov7660.h     |   3 +
  drivers/media/usb/gspca/m5602/m5602_ov9650.c     | 469 +++++--------------
  drivers/media/usb/gspca/m5602/m5602_ov9650.h     |   2 +
  drivers/media/usb/gspca/m5602/m5602_po1030.c     | 471 +++++--------------
  drivers/media/usb/gspca/m5602/m5602_po1030.h     |   2 +
  drivers/media/usb/gspca/m5602/m5602_s5k4aa.c     | 352 ++++----------
  drivers/media/usb/gspca/m5602/m5602_s5k4aa.h     |   2 +
  drivers/media/usb/gspca/m5602/m5602_s5k83a.c     | 291 +++---------
  drivers/media/usb/gspca/m5602/m5602_s5k83a.h     |   9 +-
  drivers/media/usb/gspca/m5602/m5602_sensor.h     |   3 +
  drivers/media/usb/gspca/mr97310a.c               |   8 +-
  drivers/media/usb/gspca/ov519.c                  |  81 ++--
  drivers/media/usb/gspca/ov534.c                  |   2 +-
  drivers/media/usb/gspca/pac207.c                 |   2 +-
  drivers/media/usb/gspca/pac7302.c                |   7 +-
  drivers/media/usb/gspca/pac7311.c                |   5 +-
  drivers/media/usb/gspca/pac_common.h             |   2 +-
  drivers/media/usb/gspca/sn9c2028.c               |   4 +-
  drivers/media/usb/gspca/sonixb.c                 |  22 -
  drivers/media/usb/gspca/sonixj.c                 | 556 +++++++----------------
  drivers/media/usb/gspca/spca1528.c               |   4 +-
  drivers/media/usb/gspca/spca500.c                |  36 +-
  drivers/media/usb/gspca/spca501.c                |  44 +-
  drivers/media/usb/gspca/spca505.c                |  42 +-
  drivers/media/usb/gspca/spca508.c                |  41 +-
  drivers/media/usb/gspca/spca561.c                |  70 ++-
  drivers/media/usb/gspca/sq905.c                  |   2 +-
  drivers/media/usb/gspca/sq905c.c                 |   6 +-
  drivers/media/usb/gspca/sq930x.c                 |   4 +-
  drivers/media/usb/gspca/stv0680.c                |  14 +-
  drivers/media/usb/gspca/stv06xx/stv06xx.c        |  17 +-
  drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c   |   8 +-
  drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c |  14 +-
  drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c |   2 +
  drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c |  10 +-
  drivers/media/usb/gspca/sunplus.c                |  27 +-
  drivers/media/usb/gspca/vc032x.c                 |   9 +-
  drivers/media/usb/gspca/w996Xcf.c                |   5 +-
  drivers/media/usb/gspca/zc3xx.c                  |   3 +-
  54 files changed, 1219 insertions(+), 2980 deletions(-)
  delete mode 100644 drivers/media/usb/gspca/autogain_functions.h

Thanks,

Hans
