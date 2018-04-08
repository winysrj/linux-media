Return-path: <linux-media-owner@vger.kernel.org>
Received: from [31.36.214.240] ([31.36.214.240]:39078 "EHLO
        val.bonstra.fr.eu.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752295AbeDHVVG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 17:21:06 -0400
From: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
Subject: [PATCH v2 0/6] usbtv: Add SECAM support and fix color encoding selection
Date: Sun,  8 Apr 2018 23:11:55 +0200
Message-Id: <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
In-Reply-To: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
References: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds SECAM support to the usbtv driver, while
also attempting to mimic the Windows driver's behavior
regarding color encoding selection.

I made USB captures of the device as it is set up by the Windows driver,
for all the supported video standards. The analog source used is the
composite output of a video card, which is configured to output a signal
using the same standard as the one configured for the capture, when that
is possible. This enabled me to find new values for the 0x016f register
that I had missed in the v1, as well as test my patches.
Unfortunately, I did not have a SECAM source for the tests, so they were
limited to setting the standard to SECAM for a PAL source, and making
sure the output was the same between the Windows and the Linux driver.

The capture adapter used for the tests is a QSonic VG-310, with USB ID
1b71:3002. The Windows driver used as reference is EasyCap driver
version 2.1.1.2 (2011-06-08).

The changes since the v1 are:
- the output resolution is selected independently of the color encoding.
  For instance, PAL-M, while using a PAL-like color encoding, has the
  same resolution as NTSC-M, so the NTSC resolution will be used in that
  case
- conversely, the color encoding is configured independently of the
  resolution
- PAL and NTSC variants have a different value for register 0x016f
- the norm value set by the user is no longer overwritten by the driver
  with a generic value when selecting the output resolution, so specific
  standards (e.g. NTSC-443) can actually be selected
- minor cosmetic changes

Hugo Grostabussiat (6):
  usbtv: Use same decoder sequence as Windows driver
  usbtv: Add SECAM support
  usbtv: Use V4L2 defines to select capture resolution
  usbtv: Keep norm parameter specific
  usbtv: Enforce standard for color decoding
  usbtv: Use the constant for supported standards

 drivers/media/usb/usbtv/usbtv-video.c | 115 ++++++++++++++++++++++----
 drivers/media/usb/usbtv/usbtv.h       |   2 +-
 2 files changed, 100 insertions(+), 17 deletions(-)

-- 
2.17.0
