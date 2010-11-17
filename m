Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:48236 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933839Ab0KQOc0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 09:32:26 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: mchehab@redhat.com, hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v16 0/2] *** SUBJECT HERE ***
Date: Wed, 17 Nov 2010 15:41:59 +0200
Message-Id: <1290001321-6732-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello all,

This the sixteenth version of the patch set.

On Tue, 2010-11-16 at 12:19 -0200, ext Mauro Carvalho Chehab wrote:
> 
> The proper way is to add the core stuff to drivers/media/radio, adding just
> the mfd glue at drivers/mfd.

Now I've moved basically all of the stuff to the drivers/media/radio...

> I also want mfd's maintainer ack of the mfd patch.

Sending this also to Samuel Ortiz...

Cheers,
Matti

Matti J. Aaltonen (2):
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  V4L2: WL1273 FM Radio: TI WL1273 FM radio driver

 drivers/media/radio/Kconfig        |   16 +
 drivers/media/radio/Makefile       |    1 +
 drivers/media/radio/radio-wl1273.c | 2347 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |    6 +
 drivers/mfd/Makefile               |    1 +
 drivers/mfd/wl1273-core.c          |  154 +++
 include/linux/mfd/wl1273-core.h    |  298 +++++
 7 files changed, 2823 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h

