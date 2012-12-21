Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2LUO1D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 09:27:03 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBLER1fH015455
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 21 Dec 2012 09:27:02 -0500
Received: from shalem.localdomain (vpn1-7-232.ams2.redhat.com [10.36.7.232])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id qBLER0Ka017753
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 21 Dec 2012 09:27:01 -0500
Message-ID: <50D47243.6070107@redhat.com>
Date: Fri, 21 Dec 2012 15:29:23 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT-PULL fixes for 3.8] Various USB webcam fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Note this pullreq superceeds my previous pullreq.

Please pull from my tree for some assorted USB webcam fixes for 3.8

The following changes since commit 49cc629df16f2a15917800a8579bd9c25c41b634:

   [media] MAINTAINERS: add si470x-usb+common and si470x-i2c entries (2012-12-11 18:16:13 -0200)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.8

for you to fetch changes up to 4fcbd77b664f9acd540ec410a255a963b039fa21:

   gspca_sonixj: Add a small delay after i2c_w1 (2012-12-21 15:19:19 +0100)

----------------------------------------------------------------
Erik Andrén (1):
       gspca_stv06xx: Disable flip controls for vv6410 sensor

Hans de Goede (6):
       gspca-pac207: Add a led_invert module parameter
       stk-webcam: Add an upside down dmi table, and add the Asus G1 to it
       Documentation/media: Remove docs for obsoleted and removed v4l1 drivers
       gspca_t613: Fix compiling with GSPCA_DEBUG defined
       gspca_sonixb: Properly wait between i2c writes
       gspca_sonixj: Add a small delay after i2c_w1

Jacob Schloss (1):
       gspca_kinect: add Kinect for Windows USB id

Jean-François Moine (1):
       gspca - stv06xx: Fix a regression with the bridge/sensor vv6410

Sachin Kamat (1):
       gspca: Use module_usb_driver macro

  Documentation/video4linux/et61x251.txt           | 315 ----------------
  Documentation/video4linux/ibmcam.txt             | 323 ----------------
  Documentation/video4linux/m5602.txt              |  12 -
  Documentation/video4linux/ov511.txt              | 288 --------------
  Documentation/video4linux/se401.txt              |  54 ---
  Documentation/video4linux/stv680.txt             |  53 ---
  Documentation/video4linux/w9968cf.txt            | 458 -----------------------
  Documentation/video4linux/zc0301.txt             | 270 -------------
  drivers/media/usb/gspca/jl2005bcd.c              |  18 +-
  drivers/media/usb/gspca/kinect.c                 |   1 +
  drivers/media/usb/gspca/pac207.c                 |  32 +-
  drivers/media/usb/gspca/sonixb.c                 |  13 +-
  drivers/media/usb/gspca/sonixj.c                 |   1 +
  drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c |  17 +-
  drivers/media/usb/gspca/t613.c                   |   2 +-
  drivers/media/usb/stkwebcam/stk-webcam.c         |  56 ++-
  16 files changed, 96 insertions(+), 1817 deletions(-)
  delete mode 100644 Documentation/video4linux/et61x251.txt
  delete mode 100644 Documentation/video4linux/ibmcam.txt
  delete mode 100644 Documentation/video4linux/m5602.txt
  delete mode 100644 Documentation/video4linux/ov511.txt
  delete mode 100644 Documentation/video4linux/se401.txt
  delete mode 100644 Documentation/video4linux/stv680.txt
  delete mode 100644 Documentation/video4linux/w9968cf.txt
  delete mode 100644 Documentation/video4linux/zc0301.txt

Thanks & Regards,

Hans
