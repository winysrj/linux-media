Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956AbaDBIlC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Apr 2014 04:41:02 -0400
Message-ID: <533BCD1A.1010307@redhat.com>
Date: Wed, 02 Apr 2014 10:40:58 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Robert Butora <robert.butora.fi@gmail.com>
Subject: [GIT PULL new driver for 3.15] media/usb/gspca: Add support for Scopium
 astro webcam (0547:7303)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my gspca git tree for a new gspca based webcam driver,
since this is a new driver which does not touch anything else, I would
like to see this go into 3.15 .

The following changes since commit a83b93a7480441a47856dc9104bea970e84cda87:

  [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31 08:02:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hgoede/gspca.git media-for_v3.15

for you to fetch changes up to 8ad536cb48ac13174acef9550095539931692d69:

  media/usb/gspca: Add support for Scopium astro webcam (0547:7303) (2014-04-02 10:20:48 +0200)

----------------------------------------------------------------
Robert Butora (1):
      media/usb/gspca: Add support for Scopium astro webcam (0547:7303)

 drivers/media/usb/gspca/Kconfig   |  10 +
 drivers/media/usb/gspca/Makefile  |   2 +
 drivers/media/usb/gspca/dtcs033.c | 434 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 446 insertions(+)
 create mode 100644 drivers/media/usb/gspca/dtcs033.c

Thanks & Regards,

Hans
