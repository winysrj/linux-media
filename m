Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63773 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2BGFGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 00:06:34 -0500
Received: by vbjk17 with SMTP id k17so4384563vbj.19
        for <linux-media@vger.kernel.org>; Mon, 06 Feb 2012 21:06:33 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 7 Feb 2012 00:06:31 -0500
Message-ID: <CAHAyoxyo3uw3npFmCmYiOE0akPqJt2X_R1MqZJ6Dk7dbPhdFjg@mail.gmail.com>
Subject: [GIT PULL] adding support for Xceive XC5000C tuner... |
 git://linuxtv.org/mkrufky/tuners xc5000
From: Michael Krufky <mkrufky@kernellabs.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steven Toth <stoth@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please review / ack / merge:

The following changes since commit 59b30294e14fa6a370fdd2bc2921cca1f977ef16:
  Mauro Carvalho Chehab (1):
        Merge branch 'v4l_for_linus' into staging/for_v3.4

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners xc5000

Michael Krufky (5):
      xc5000: allow drivers to set desired firmware in xc5000_attach
      xc5000: add XC5000C_DEFAULT_FIRMWARE: dvb-fe-xc5000c-41.024.5-31875.fw
      tuner: add support for Xceive XC5000C
      tveeprom: add support for Xceive XC5000C tuner
      remove unneeded #define's in xc5000.h

 drivers/media/common/tuners/tuner-types.c |    4 ++++
 drivers/media/common/tuners/xc5000.c      |   27 +++++++++++++++++++++------
 drivers/media/common/tuners/xc5000.h      |   13 +++++++++++++
 drivers/media/video/tuner-core.c          |   15 +++++++++++++++
 drivers/media/video/tveeprom.c            |    2 +-
 include/media/tuner.h                     |    1 +
 6 files changed, 55 insertions(+), 7 deletions(-)

Cheers,

Mike
