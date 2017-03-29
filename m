Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:33221 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752582AbdC2QnS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 12:43:18 -0400
Received: by mail-wr0-f177.google.com with SMTP id w43so23158318wrb.0
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 09:43:17 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 00/13] stv0367/ddbridge: support CTv6/FlexCT hardware
Date: Wed, 29 Mar 2017 18:43:00 +0200
Message-Id: <20170329164313.14636-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Third iteration of the DD CineCTv6/FlexCT support patches with mostly
all things cleaned up that popped up so far. Obsoletes V1 and V2 series.

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

A note on the i2c_gatectrl flag: In the meantime (since v1) I got
clarification why this is needed (reception issues), so I'd prefer to
not diverge from that behaviour to not cause issues for anyone.

Checkpatch complains about some minor style issues, however the patches
were cleaned up beforehand and - where it still complains - match the
rest of the code style throughout the respective files.

In patches where code parts have been picked from other places, proper
credits to the original author is given and permissions where granted
beforehand.

Resulting STV0367/DD support was successfully tested with TVHeadend
and VDR setups by some users, with -C and -T combinations and two+four
port tuner setups (CTv6 with and without attached CT modules). I even
received some more very positive results on this since posting V1.

Apologizes if anything regarding the patch submission is/went wrong,
as this is my first time contribution to OSS via patch emails.

I'd appreciate any comments or even reviews on this to see if the way
the device support is done is acceptable at all, and how to proceed with
this. Having this as part of the 4.12 merge window would ofc be great.

Changes from v2 to v3:
 - refactored tda18212 ping in ddbridge which now even works, added
   i2c_read_regs for this (which is also required in another series)
   and wrapped i2c_read_reg to this
 - missing curly braces added as complained by the kbuild test bot
 - read_status() moved before get_frontend() for further signal stats
   readout (another series)
 - removed superfluous chip_id readout
 - added missing kfree(cab_state) to error cleanup in ddb_attach()
 - "invalid symbol rate" message changed from pr_err to printk to
   match the rest of the file

Changes from v1 to v2:
 - tda18212 modification/hack removed and implemented into ddbridge
   where it shouldn't harm but still is needed due to HW quirks
 - symbolrate_min/max added to dvb_frontend_ops
 - updated commit message body of the i2c_gatectrl flag patch (1/12) so
   it is more clear why this is needed and relevant, updated commit
   message body of 12/12 (ddbridge patch) aswell

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
  [media] ddbridge: add i2c_read_regs()
  [media] ddbridge: support STV0367-based cards and modules

 drivers/media/dvb-frontends/stv0367.c      | 1168 ++++++++++---------------
 drivers/media/dvb-frontends/stv0367.h      |   13 +
 drivers/media/dvb-frontends/stv0367_defs.h | 1301 ++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/stv0367_regs.h |    4 -
 drivers/media/pci/ddbridge/Kconfig         |    3 +
 drivers/media/pci/ddbridge/ddbridge-core.c |  168 +++-
 drivers/media/pci/ddbridge/ddbridge.h      |    1 +
 7 files changed, 1943 insertions(+), 715 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/stv0367_defs.h

-- 
2.10.2
