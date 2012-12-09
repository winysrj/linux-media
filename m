Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934051Ab2LIPSC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 10:18:02 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qB9FI1NY002578
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 9 Dec 2012 10:18:02 -0500
Received: from shalem.localdomain (vpn1-6-45.ams2.redhat.com [10.36.6.45])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qB9FI0Db005418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 9 Dec 2012 10:18:01 -0500
Message-ID: <50C4AC30.1060006@redhat.com>
Date: Sun, 09 Dec 2012 16:20:16 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.8] Various USB webcam fixes <resend>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<resend of the same mail from 29 November, as it seems to have been missed>

Hi Mauro,

Please pull from my tree for some assorted USB webcam fixes for 3.8

The following changes since commit d8658bca2e5696df2b6c69bc5538f8fe54e4a01e:

   [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check (2012-11-28 10:54:46 -0200)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.8

for you to fetch changes up to 325b64b6cb9090c1bc7cda5444f84b2c00acf926:

   Documentation/media: Remove docs for obsoleted and removed v4l1 drivers (2012-11-29 11:29:48 +0100)

----------------------------------------------------------------
Hans de Goede (3):
       gspca-pac207: Add a led_invert module parameter
       stk-webcam: Add an upside down dmi table, and add the Asus G1 to it
       Documentation/media: Remove docs for obsoleted and removed v4l1 drivers

Jean-François Moine (1):
       gspca - stv06xx: Fix a regression with the bridge/sensor vv6410

  Documentation/video4linux/et61x251.txt           | 315 ----------------
  Documentation/video4linux/ibmcam.txt             | 323 ----------------
  Documentation/video4linux/m5602.txt              |  12 -
  Documentation/video4linux/ov511.txt              | 288 --------------
  Documentation/video4linux/se401.txt              |  54 ---
  Documentation/video4linux/stv680.txt             |  53 ---
  Documentation/video4linux/w9968cf.txt            | 458 -----------------------
  Documentation/video4linux/zc0301.txt             | 270 -------------
  drivers/media/usb/gspca/pac207.c                 |  32 +-
  drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c |   4 +
  drivers/media/usb/stkwebcam/stk-webcam.c         |  56 ++-
  11 files changed, 76 insertions(+), 1789 deletions(-)
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
