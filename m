Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2GGVms (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 17:42:48 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q67LglDO000421
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 7 Jul 2012 17:42:47 -0400
Received: from shalem.localdomain (vpn1-4-94.ams2.redhat.com [10.36.4.94])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q67LgjhS022272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 7 Jul 2012 17:42:46 -0400
Message-ID: <4FF8AD7B.4050000@redhat.com>
Date: Sat, 07 Jul 2012 23:43:23 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL for 3.6] gspca control-framework conversions and radio
 drivers work
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my git tree for:
-A ton of gspca control-framework conversions (mostly done By Hans V, reviewed and tested by me)
-Some radio driver fixes
-2 new drivers for USB radio devices
-2 v4l2-core regression fixes for your current for_v3.6 tree

The following changes since commit b7e386360922a15f943b2fbe8d77a19bb86f2e6f:

   media: Revert "[media] Terratec Cinergy S2 USB HD Rev.2" (2012-07-07 00:19:20 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.6

for you to fetch changes up to 93330babccc2e0777430834435bdd4bb34db3ff6:

   shark2: New driver for the Griffin radioSHARK v2 USB radio receiver (2012-07-07 23:36:44 +0200)

----------------------------------------------------------------
Antonio Ospite (2):
       gspca_kinect: remove traces of the gspca control mechanism
       gspca_ov534: Convert to the control framework

Hans Verkuil (30):
       gspca-conex: convert to the control framework.
       gspca-cpia1: convert to the control framework.
       gspca-etoms: convert to the control framework.
       gspca-jeilinj: convert to the control framework.
       gspca-konica: convert to the control framework.
       gspca-mr97310a: convert to the control framework.
       nw80x: convert to the control framework.
       ov519: convert to the control framework.
       ov534_9: convert to the control framework.
       es401: convert to the control framework.
       spca1528: convert to the control framework.
       spca500: convert to the control framework.
       spca501: convert to the control framework.
       spca505: convert to the control framework.
       spca506: convert to the control framework.
       spca508: convert to the control framework.
       spca561: convert to the control framework.
       sq930x: convert to the control framework.
       stk014: convert to the control framework.
       sunplus: convert to the control framework.
       gspca_t613: convert to the control framework
       tv8532: convert to the control framework.
       vicam: convert to the control framework.
       xirlink_cit: convert to the control framework.
       vc032x: convert to the control framework.
       gspca-topro: convert to the control framework.
       gspca: clear priv field and disable relevant ioctls.
       gspca: always call v4l2_ctrl_handler_setup after start.
       gspca-spca501: remove old function prototypes.
       v4l2-ioctl: Don't assume file->private_data always points to a v4l2_fh

Hans de Goede (24):
       snd_tea575x: Add write_/read_val operations
       snd_tea575x: Add a cannot_mute flag
       radio-shark: New driver for the Griffin radioSHARK USB radio receiver
       radio-si470x: Don't unnecesarily read registers on G_TUNER
       radio-si470x: Always use interrupt to wait for tune/seek completion
       radio-si470x: Lower hardware freq seek signal treshold
       radio-si470x: Lower firmware version requirements
       gspca_pac7302: Convert to the control framework
       gscpa_sonixb: Use usb_err for error handling
       gscpa_sonixb: Convert to the control framework
       gspca_sonixb: Fix OV7630 gain control
       gspca: Remove bogus JPEG quality controls from various sub-drivers
       gspca_benq: Remove empty ctrls array
       gspca: Add reset_resume callback to all sub-drivers
       gspca_konica: Fix init sequence
       gspca_sn9c2028: Remove empty ctrls array
       gscpa_spca561: Add brightness control for rev12a cams
       gspca_stv0680: Remove empty ctrls array
       gspca_t613: Disable CIF resolutions
       gspca_xirlink_cit: Grab backlight compensation control while streaming
       gspca: Don't use video_device_node_name in v4l2_device release handler
       v4l2-ctrls: Teach v4l2-ctrls that V4L2_CID_AUTOBRIGHTNESS is a boolean
       media/video: Add v4l2-common.h to userspace headers
       shark2: New driver for the Griffin radioSHARK v2 USB radio receiver

  Documentation/DocBook/media/v4l/controls.xml     |    5 +
  drivers/hid/hid-core.c                           |    1 +
  drivers/hid/hid-ids.h                            |    1 +
  drivers/media/radio/Kconfig                      |   33 +
  drivers/media/radio/Makefile                     |    4 +
  drivers/media/radio/radio-shark.c                |  376 ++++++++++
  drivers/media/radio/radio-shark2.c               |  348 +++++++++
  drivers/media/radio/radio-tea5777.c              |  489 +++++++++++++
  drivers/media/radio/radio-tea5777.h              |   87 +++
  drivers/media/radio/si470x/radio-si470x-common.c |   68 +-
  drivers/media/radio/si470x/radio-si470x-i2c.c    |    5 +-
  drivers/media/radio/si470x/radio-si470x-usb.c    |   39 +-
  drivers/media/radio/si470x/radio-si470x.h        |    4 +-
  drivers/media/video/gspca/benq.c                 |    7 +-
  drivers/media/video/gspca/conex.c                |  208 ++----
  drivers/media/video/gspca/cpia1.c                |  486 ++++---------
  drivers/media/video/gspca/etoms.c                |  221 ++----
  drivers/media/video/gspca/finepix.c              |    1 +
  drivers/media/video/gspca/gl860/gl860.c          |    1 +
  drivers/media/video/gspca/gspca.c                |   50 +-
  drivers/media/video/gspca/jeilinj.c              |  219 +++---
  drivers/media/video/gspca/jl2005bcd.c            |    3 +-
  drivers/media/video/gspca/kinect.c               |   10 +-
  drivers/media/video/gspca/konica.c               |  289 ++------
  drivers/media/video/gspca/m5602/m5602_core.c     |    1 +
  drivers/media/video/gspca/mars.c                 |   48 +-
  drivers/media/video/gspca/mr97310a.c             |  439 ++++--------
  drivers/media/video/gspca/nw80x.c                |  203 +++---
  drivers/media/video/gspca/ov519.c                |  600 +++++++---------
  drivers/media/video/gspca/ov534.c                |  570 +++++++--------
  drivers/media/video/gspca/ov534_9.c              |  294 +++-----
  drivers/media/video/gspca/pac207.c               |    1 +
  drivers/media/video/gspca/pac7302.c              |  372 ++++------
  drivers/media/video/gspca/pac7311.c              |    1 +
  drivers/media/video/gspca/se401.c                |  184 ++---
  drivers/media/video/gspca/sn9c2028.c             |    7 +-
  drivers/media/video/gspca/sonixb.c               |  622 ++++++++--------
  drivers/media/video/gspca/sonixj.c               |    1 +
  drivers/media/video/gspca/spca1528.c             |  271 ++-----
  drivers/media/video/gspca/spca500.c              |  201 ++----
  drivers/media/video/gspca/spca501.c              |  257 ++-----
  drivers/media/video/gspca/spca505.c              |   77 +-
  drivers/media/video/gspca/spca506.c              |  209 ++----
  drivers/media/video/gspca/spca508.c              |   71 +-
  drivers/media/video/gspca/spca561.c              |  393 +++--------
  drivers/media/video/gspca/sq905.c                |    1 +
  drivers/media/video/gspca/sq905c.c               |    1 +
  drivers/media/video/gspca/sq930x.c               |  110 ++-
  drivers/media/video/gspca/stk014.c               |  188 ++---
  drivers/media/video/gspca/stv0680.c              |    7 +-
  drivers/media/video/gspca/sunplus.c              |  237 ++-----
  drivers/media/video/gspca/t613.c                 |  824 ++++++----------------
  drivers/media/video/gspca/topro.c                |  459 ++++++------
  drivers/media/video/gspca/tv8532.c               |  125 ++--
  drivers/media/video/gspca/vc032x.c               |  694 +++++-------------
  drivers/media/video/gspca/vicam.c                |   68 +-
  drivers/media/video/gspca/w996Xcf.c              |   15 +-
  drivers/media/video/gspca/xirlink_cit.c          |  473 ++++---------
  drivers/media/video/v4l2-ctrls.c                 |    1 +
  drivers/media/video/v4l2-ioctl.c                 |   21 +-
  include/linux/Kbuild                             |    1 +
  include/sound/tea575x-tuner.h                    |    5 +
  sound/i2c/other/tea575x-tuner.c                  |   41 +-
  63 files changed, 4602 insertions(+), 6446 deletions(-)
  create mode 100644 drivers/media/radio/radio-shark.c
  create mode 100644 drivers/media/radio/radio-shark2.c
  create mode 100644 drivers/media/radio/radio-tea5777.c
  create mode 100644 drivers/media/radio/radio-tea5777.h

Regards,

Hans
