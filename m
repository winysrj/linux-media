Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:37651 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434Ab0KPNf2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 08:35:28 -0500
Subject: [GIT PULL REQUEST v2.]  WL1273 FM Radio driver.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: mchehab@redhat.com
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
In-Reply-To: <1289833803.5350.67.camel@masi.mnp.nokia.com>
References: <E1P9THI-0003aa-4H@www.linuxtv.org>
	 <1289833803.5350.67.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 15:35:13 +0200
Message-ID: <1289914513.5350.72.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi.

The radio pull request, now using http protocol.

The following changes since commit
f6614b7bb405a9b35dd28baea989a749492c46b2:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sfrench/cifs-2.6

are available in the git repository at:

  http://git.gitorious.org/wl1273-fm-driver/wl1273-fm-driver.git master

Matti J. Aaltonen (2):
      MFD: WL1273 FM Radio: MFD driver for the FM radio.
      V4L2: WL1273 FM Radio: Controls for the FM radio.

 drivers/media/radio/Kconfig        |   16 +
 drivers/media/radio/Makefile       |    1 +
 drivers/media/radio/radio-wl1273.c | 1841
++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |    6 +
 drivers/mfd/Makefile               |    1 +
 drivers/mfd/wl1273-core.c          |  617 ++++++++++++
 include/linux/mfd/wl1273-core.h    |  330 +++++++
 7 files changed, 2812 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h


B.R.
Matti A.


