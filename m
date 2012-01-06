Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030200Ab2AFKis (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 05:38:48 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q06Aclnn031253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 6 Jan 2012 05:38:47 -0500
Received: from shalem.localdomain (vpn1-5-31.ams2.redhat.com [10.36.5.31])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q06Ack8J016443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 6 Jan 2012 05:38:47 -0500
Message-ID: <4F06CF7A.3010909@redhat.com>
Date: Fri, 06 Jan 2012 11:39:54 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.3] gspca: fixes and new driver, pwc: large cleanup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro (et all),

Please pull from my tree for various gspca fixes, a new gspca sub driver and
some major pwc driver cleanups, removing a lot of old driver specific API,
per feature-removal-schedule.txt.

The following changes since commit 6cb393c82255c448a92754f2a2a6b715bd9418dc:

   [media] drxk_hard: fix locking issues when changing the delsys (2012-01-05 16:44:10 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git media-for_v3.3

Hans de Goede (17):
       gspca: Fix falling back to lower isoc alt settings
       gspca_sonixb: Fix exposure control min/max value for coarse expo sensors
       gspca_pac7302: Add usb-id for 145f:013c
       gscpa_ov519: Fix the bandwidth calc for enabling compression
       gscpa_t613: Add support for the camera button
       pwc: Use v4l2-device and v4l2-fh
       pwc: Properly mark device_hint as unused in all probe error paths
       pwc: Make auto white balance speed and delay available as v4l2 controls
       pwc: Rework locking
       pwc: Read new preset values when changing awb control to a preset
       pwc: Remove driver specific sysfs interface
       pwc: Remove driver specific use of pixfmt.priv in the pwc driver
       pwc: Remove dead snapshot code
       pwc: Remove driver specific ioctls
       pwc: Remove software emulation of arbritary resolutions
       pwc: Get rid of compression module parameter
       pwc: Properly fill all fields on try_fmt

Theodore Kilgore (1):
       gspca: Add jl2005bcd sub driver

  Documentation/DocBook/media/v4l/pixfmt.xml |    5 +
  Documentation/feature-removal-schedule.txt |   35 --
  Documentation/video4linux/gspca.txt        |    1 +
  drivers/media/video/gspca/Kconfig          |   10 +
  drivers/media/video/gspca/Makefile         |    2 +
  drivers/media/video/gspca/gspca.c          |    2 +-
  drivers/media/video/gspca/jl2005bcd.c      |  554 +++++++++++++++++++++
  drivers/media/video/gspca/ov519.c          |    4 +-
  drivers/media/video/gspca/pac7302.c        |    1 +
  drivers/media/video/gspca/sonixb.c         |   15 +-
  drivers/media/video/gspca/t613.c           |   25 +
  drivers/media/video/pwc/pwc-ctrl.c         |  723 ++--------------------------
  drivers/media/video/pwc/pwc-dec23.c        |  288 ++----------
  drivers/media/video/pwc/pwc-dec23.h        |    5 +-
  drivers/media/video/pwc/pwc-if.c           |  297 ++++--------
  drivers/media/video/pwc/pwc-kiara.h        |    2 +-
  drivers/media/video/pwc/pwc-misc.c         |   87 +---
  drivers/media/video/pwc/pwc-timon.h        |    2 +-
  drivers/media/video/pwc/pwc-uncompress.c   |   46 +--
  drivers/media/video/pwc/pwc-v4l.c          |  258 +++++-----
  drivers/media/video/pwc/pwc.h              |   66 ++--
  include/linux/videodev2.h                  |    1 +
  include/media/pwc-ioctl.h                  |  323 -------------
  23 files changed, 997 insertions(+), 1755 deletions(-)
  create mode 100644 drivers/media/video/gspca/jl2005bcd.c
  delete mode 100644 include/media/pwc-ioctl.h

Thanks & Regards,

Hans
