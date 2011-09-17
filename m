Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52455 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1IQSZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 14:25:43 -0400
Received: by iaqq3 with SMTP id q3so3473126iaq.19
        for <linux-media@vger.kernel.org>; Sat, 17 Sep 2011 11:25:43 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 17 Sep 2011 14:25:41 -0400
Message-ID: <CAOcJUbzW=a+JoYc8+oZHDpHvBg0bpsLEOu=6Hv=y3qchmujVuw@mail.gmail.com>
Subject: [PULL] dvb-usb-mfe cleanups
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please pull the following cleanups from my dvb-usb branch into your
for_v3.2 branch.

The following changes since commit 2d04c13a507f5a01daa7422cd52250809573cfdb:
  Michael Krufky (1):
        [media] dvb-usb: improve sanity check of adap->active_fe in
dvb_usb_ctrl_feed

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/mxl111sf.git dvb-usb

Michael Krufky (15):
      mxl111sf: use adap->num_frontends_initialized to determine which
frontend is being attached
      dib0700: fix WARNING: please, no spaces at the start of a line
      dib0700: fix WARNING: suspect code indent for conditional statements
      dib0700: fix ERROR: space required before that '&'
      dib0700: fix ERROR: space required after that ','
      dibusb-common: fix ERROR: space required after that ','
      dibusb-mb: fix ERROR: space required after that ','
      ttusb2: fix ERROR: space required after that ','
      dvb-usb-dvb: ERROR: space required after that ','
      cxusb: fix ERROR: do not use assignment in if condition
      dibusb-common: fix ERROR: do not use assignment in if condition
      dibusb-mb: fix ERROR: do not use assignment in if condition
      digitv: fix ERROR: do not use assignment in if condition
      m920x: fix ERROR: do not use assignment in if condition
      opera1: fix ERROR: do not use assignment in if condition

 drivers/media/dvb/dvb-usb/cxusb.c           |   52 ++++++++++++++++----------
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   23 +++++++-----
 drivers/media/dvb/dvb-usb/dibusb-common.c   |   19 +++++++---
 drivers/media/dvb/dvb-usb/dibusb-mb.c       |    9 +++--
 drivers/media/dvb/dvb-usb/digitv.c          |    9 ++++-
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c     |    7 ++--
 drivers/media/dvb/dvb-usb/m920x.c           |   21 ++++++-----
 drivers/media/dvb/dvb-usb/mxl111sf.c        |   19 ++++++----
 drivers/media/dvb/dvb-usb/opera1.c          |    6 ++--
 drivers/media/dvb/dvb-usb/ttusb2.c          |    2 +-
 10 files changed, 103 insertions(+), 64 deletions(-)

Cheers,

Mike Krufky
