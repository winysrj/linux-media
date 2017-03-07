Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32782 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755864AbdCGT12 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 14:27:28 -0500
Received: by mail-wr0-f194.google.com with SMTP id g10so1488756wrg.0
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 11:27:26 -0800 (PST)
Received: from dvbdev.wuest.de (ip-178-201-73-185.hsi08.unitymediagroup.de. [178.201.73.185])
        by smtp.gmail.com with ESMTPSA id m186sm13760369wmd.21.2017.03.07.10.58.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 Mar 2017 10:58:29 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/13] stv0367/ddbridge: support CTv6/FlexCT hardware
Date: Tue,  7 Mar 2017 19:57:14 +0100
Message-Id: <20170307185727.564-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

These patches enhance the functionality of dvb-frontends/stv0367 to work
with Digital Devices hardware driven by the ST STV0367 demodulator chip
and adds probe & attach bits to ddbridge to make use of them, effectively
enabling full support for CineCTv6 PCIe bridges and (older) DuoFlex CT
addon modules.

While the stv0367 code basically works with the DD hardware (e.g. setup
of demodulation works for both -C and -T delivery systems), some bits
(mostly initialisation) have to be done differently. Also, the static
if_khz configuration is not sufficient as the TDA18212 tuner works at
different IF speeds depending on the delivery system and carrier
bandwidth, so functionality is added to read that speed from the tuner.

The most important part is the addition of register default tabs for
the DD boards, the DD demod initialisation code and the automated
operation mode switch (OFDM vs. QAM) to be able to provide both systems
in one DVB frontend. Everything else is provided by the existing code
or the existing code is enhanced where it didn't suffice. So instead
of duplicating the driver, the existing one is reused. Patches are
laid out in a way to add each enhancement in small increments so they
should be fairly easy to review.

A note on the i2c_gatectrl flag: The exact reason why this is neccessary
isn't known, but all C/T demods supported by the official vendorprovided
driver does the mutex_lock thing, so I'd prefer to not diverge from that
behaviour.

Checkpatch complains about some minor style issues, however the patches
were cleaned up beforehand and - where it still complains - match the
rest of the code style throughout the respective files.

In patches where code parts have been picked from other places, proper
credits to the original author is given and permissions where granted
beforehand.

Resulting STV0367/DD support was successfully tested with TVHeadend
and VDR setups by some users, with -C and -T combinations and two+four
port tuner setups (CTv6 with and without attached CT modules).

Apologizes if anything regarding the patch submission is/went wrong,
as this is my first time contribution to OSS via patch emails.

Daniel Scheller (13):
  [media] dvb-frontends/stv0367: add flag to make i2c_gatectrl optional
  [media] dvb-frontends/stv0367: print CPAMP status only if stv_debug is
    enabled
  [media] dvb-frontends/stv0367: refactor defaults table handling
  [media] dvb-frontends/stv0367: move out tables, support multiple tab
    variants
  [media] dvb-frontends/stv0367: make PLLSETUP a function, add 58MHz IC
    speed
  [media] dvb-frontends/stv0367: make full reinit on set_frontend()
    optional
  [media] dvb-frontends/stv0367: support reading if_khz from tuner
    config
  [media] dvb-frontends/stv0367: selectable QAM FEC Lock status register
  [media] dvb-frontends/stv0367: fix symbol rate conditions in
    cab_SetQamSize()
  [media] dvb-frontends/stv0367: add defaults for use w/DD-branded
    devices
  [media] dvb-frontends/stv0367: add Digital Devices compatibility
  [media] tuners/tda18212: add flag for retrying tuner init on failure
  [media] ddbridge: support STV0367-based cards and modules

 drivers/media/dvb-frontends/stv0367.c              | 1167 +++++++-----------
 drivers/media/dvb-frontends/stv0367.h              |   13 +
 drivers/media/dvb-frontends/stv0367_defs.h         | 1301 ++++++++++++++++++++
 drivers/media/dvb-frontends/stv0367_regs.h         |    4 -
 drivers/media/pci/ddbridge/Kconfig                 |    3 +
 drivers/media/pci/ddbridge/ddbridge-core.c         |  127 ++
 drivers/media/pci/ddbridge/ddbridge.h              |    1 +
 .../media/platform/sti/c8sectpfe/c8sectpfe-dvb.c   |    1 +
 drivers/media/tuners/tda18212.c                    |    5 +
 drivers/media/tuners/tda18212.h                    |    7 +
 drivers/media/usb/dvb-usb-v2/anysee.c              |    2 +
 drivers/media/usb/em28xx/em28xx-dvb.c              |    1 +
 12 files changed, 1920 insertions(+), 712 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/stv0367_defs.h

-- 
2.10.2
