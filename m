Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.105.134]:54537 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760559Ab0JGNQo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 09:16:44 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v12 0/3] TI WL1273 FM Radio driver...
Date: Thu,  7 Oct 2010 16:16:10 +0300
Message-Id: <1286457373-1742-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Mauro, Hans and others.

I haven't gotten any comments to the latest patch set. The audio part
of the driver has already been accepted so I'm now trying to apply a
similar approach as with the codec. I've abstracted out the physical
control layer from the driver, it could use I2c or UART but the driver
now has only read and write calls (and a couple of other calls). Also
the driver doesn't export anything and it doesn't expose the FM radio
bands it uses internally to the outsize world.

Cheers,
Matti


Matti J. Aaltonen (3):
  V4L2: Add seek spacing and RDS CAP bits.
  V4L2: WL1273 FM Radio: Controls for the FM radio.
  Documentation: v4l: Add hw_seek spacing and two TUNER_RDS_CAP flags.

 Documentation/DocBook/v4l/dev-rds.xml              |   10 +-
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +-
 drivers/media/radio/Kconfig                        |   16 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-wl1273.c                 | 1848 ++++++++++++++++++++
 include/linux/videodev2.h                          |    5 +-
 6 files changed, 1886 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c

