Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65007 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1H2M00 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 08:26:26 -0400
Received: by gwaa12 with SMTP id a12so4724566gwa.19
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 05:26:25 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Aug 2011 08:26:25 -0400
Message-ID: <CAOcJUbx2LS2_XJC4DKoKLv9XXY5GwrTic1sh68J6q2qC3h2bkQ@mail.gmail.com>
Subject: [GIT PULL FOR 3.2] dvb-usb: add ATSC support for the Hauppauge WinTV-Aero-M
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Please pull from the aero-m branch of my mxl111sf tree to add ATSC
support for the Hauppauge WinTV-Aero-M:

The following changes since commit c9f88aa976b79a26561fb7754a1e0e00ff7626fe:
  Jose Alberto Reguero (1):
        [media] ttusb2: add support for the dvb-t part of CT-3650 v3

are available in the git repository at:

  http://git.linuxtv.org/mkrufky/mxl111sf.git aero-m

Michael Krufky (2):
      dvb-usb: add ATSC support for the Hauppauge WinTV-Aero-M
      mxl111sf: Change adapter FE pointer as array of FE pointers.

 drivers/media/dvb/dvb-usb/Kconfig          |    8 +
 drivers/media/dvb/dvb-usb/Makefile         |    4 +
 drivers/media/dvb/dvb-usb/mxl111sf-gpio.c  |  763 +++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/mxl111sf-gpio.h  |   56 ++
 drivers/media/dvb/dvb-usb/mxl111sf-i2c.c   |  851 +++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/mxl111sf-i2c.h   |   35 ++
 drivers/media/dvb/dvb-usb/mxl111sf-phy.c   |  342 +++++++++++
 drivers/media/dvb/dvb-usb/mxl111sf-phy.h   |   53 ++
 drivers/media/dvb/dvb-usb/mxl111sf-reg.h   |  179 ++++++
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c |  476 ++++++++++++++++
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.h |   89 +++
 drivers/media/dvb/dvb-usb/mxl111sf.c       |  854 ++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/mxl111sf.h       |  158 +++++
 13 files changed, 3868 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-gpio.c
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-gpio.h
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-i2c.c
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-i2c.h
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-phy.c
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-phy.h
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-reg.h
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf.c
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf.h

Thanks & regards,

Michael Krufky
