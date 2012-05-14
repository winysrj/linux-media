Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59216 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab2ENWKM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 18:10:12 -0400
Received: by vbbff1 with SMTP id ff1so5378807vbb.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:10:11 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 14 May 2012 18:10:11 -0400
Message-ID: <CAOcJUbz+_dF6whqRrVaQQdMHt+_NzK9kqOW_zAFQQ0zJBHXYFQ@mail.gmail.com>
Subject: [PULL PATCH 00/11] ATSC-MH driver support for the Hauppauge WinTV Aero-m
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

After our discussion in IRC today, I made the additional changes that
you requested, along with better patch descriptions, and the "stats"
bits have been disabled / removed.  Please merge.  (patch bomb
follows)

The following changes since commit 296da3cd14db9eb5606924962b2956c9c656dbb0:

  [media] pwc: poll(): Check that the device has not beem claimed for
streaming already (2012-03-27 11:42:04 -0300)

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/mxl111sf atscmh_aero-m_for_v3.5

for you to fetch changes up to 9196bebd70ae388ecc35656c48879376730dd7c4:

  DVB: remove "stats" property bits from ATSC-MH API property
additions (2012-05-14 17:54:34 -0400)

----------------------------------------------------------------
Michael Krufky (11):
      linux-dvb v5 API support for ATSC-MH
      DocBook: document new DTV Properties for ATSC-MH delivery system
      increment DVB API to version 5.6 for ATSC-MH frontend control
      mxl111sf-tuner: tune SYS_ATSCMH just like SYS_ATSC
      DVB: add support for the LG2160 ATSC-MH demodulator
      lg2160: update internal api interfaces and enable build
      dvb-demux: add functionality to send raw payload to the dvr device
      dvb-usb: add support for dvb-usb-adapters that deliver raw payload
      dvb-usb: increase MAX_NO_OF_FE_PER_ADAP from 2 to 3
      mxl111sf: add ATSC-MH support
      DVB: remove "stats" property bits from ATSC-MH API property additions

 Documentation/DocBook/media/dvb/dvbproperty.xml |  160 +++
 drivers/media/dvb/dvb-core/dvb_demux.c          |   10 +
 drivers/media/dvb/dvb-core/dvb_demux.h          |    2 +
 drivers/media/dvb/dvb-core/dvb_frontend.c       |   80 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h       |   18 +
 drivers/media/dvb/dvb-usb/Kconfig               |    1 +
 drivers/media/dvb/dvb-usb/dvb-usb-urb.c         |   12 +
 drivers/media/dvb/dvb-usb/dvb-usb.h             |    3 +-
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c      |    1 +
 drivers/media/dvb/dvb-usb/mxl111sf.c            |  871 +++++++++++++-
 drivers/media/dvb/frontends/Kconfig             |    8 +
 drivers/media/dvb/frontends/Makefile            |    1 +
 drivers/media/dvb/frontends/lg2160.c            | 1468 +++++++++++++++++++++++
 drivers/media/dvb/frontends/lg2160.h            |   84 ++
 include/linux/dvb/frontend.h                    |   51 +-
 include/linux/dvb/version.h                     |    2 +-
 16 files changed, 2721 insertions(+), 51 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/lg2160.c
 create mode 100644 drivers/media/dvb/frontends/lg2160.h
