Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:38482 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZDAJrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 05:47:51 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id n319lW6V020819
	for <linux-media@vger.kernel.org>; Wed, 1 Apr 2009 12:47:45 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH 0/3] FM Transmitter driver
Date: Wed,  1 Apr 2009 12:43:28 +0300
Message-Id: <1238579011-12435-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro and v4l guys,

This series contains a v4l2 radio driver which
adds support for Silabs si4713 devices. That is
a FM transmitter device.

As you should know, v4l2 does not contain representation
of FM Transmitters (at least that I know). So this driver
was written highly based on FM receivers API, which can
cover most of basic functionality. However, as expected,
there are some properties which were not covered.
For those properties, sysfs nodes were added in order
to get user interactions.

Comments are wellcome.

Eduardo Valentin (3):
  FMTx: si4713: Add files to handle si4713 device
  FMTx: si4713: Add files to add radio interface for si4713
  FMTx: si4713: Add Kconfig and Makefile entries

 drivers/media/radio/Kconfig        |   12 +
 drivers/media/radio/Makefile       |    2 +
 drivers/media/radio/radio-si4713.c |  834 ++++++++++++++
 drivers/media/radio/radio-si4713.h |   32 +
 drivers/media/radio/si4713.c       | 2238 ++++++++++++++++++++++++++++++++++++
 drivers/media/radio/si4713.h       |  294 +++++
 6 files changed, 3412 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-si4713.c
 create mode 100644 drivers/media/radio/radio-si4713.h
 create mode 100644 drivers/media/radio/si4713.c
 create mode 100644 drivers/media/radio/si4713.h

