Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab3HTOll (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 10:41:41 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7KEffYe030819
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 20 Aug 2013 10:41:41 -0400
Received: from shalem.localdomain (vpn1-5-160.ams2.redhat.com [10.36.5.160])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r7KEfdbH019811
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 20 Aug 2013 10:41:40 -0400
Message-ID: <52138023.2090205@redhat.com>
Date: Tue, 20 Aug 2013 16:41:39 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL for 3.12] New gspca webcam driver + misc fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my gspca tree for a new webcam driver + misc fixes.

The following changes since commit bfd22c490bc74f9603ea90c37823036660a313e2:

   v4l2-common: warning fix (W=1): add a missed function prototype (2013-08-18 10:18:30 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.12

for you to fetch changes up to b5ad203a7dc1546a20e615504621adcb0124a9b4:

   introduce gspca-stk1135: Syntek STK1135 driver (2013-08-20 15:35:16 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
       gspca: fix dev_open() error path

Antonio Ospite (1):
       gspca-ov534: don't call sd_start() from sd_init()

Hans de Goede (1):
       radio-si470x-usb: Remove software version check

Ondrej Zary (1):
       introduce gspca-stk1135: Syntek STK1135 driver

  drivers/media/radio/si470x/radio-si470x-usb.c |  11 -
  drivers/media/usb/gspca/Kconfig               |   9 +
  drivers/media/usb/gspca/Makefile              |   2 +
  drivers/media/usb/gspca/gspca.c               |   6 +-
  drivers/media/usb/gspca/ov534.c               |   3 +-
  drivers/media/usb/gspca/stk1135.c             | 685 ++++++++++++++++++++++++++
  drivers/media/usb/gspca/stk1135.h             |  57 +++
  7 files changed, 759 insertions(+), 14 deletions(-)
  create mode 100644 drivers/media/usb/gspca/stk1135.c
  create mode 100644 drivers/media/usb/gspca/stk1135.h

Thanks & Regards,

Hans
