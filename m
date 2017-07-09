Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:33029 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752630AbdGITmt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:49 -0400
Received: by mail-wr0-f175.google.com with SMTP id r103so112092284wrb.0
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:48 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 0/4] MxL5xx demodulator-tuner driver, DD MaxS8 support
Date: Sun,  9 Jul 2017 21:42:42 +0200
Message-Id: <20170709194246.10334-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Target: 4.14 seems unrealistic, so: 4.14+

Hard-dependency on the STV0910/STV6111 driver+DD support series and the DD
driver bump.

This adds a driver for the MaxLinear MxL5xx tuner-demodulator series (a
DVB-S/S2/DSS demodulator-tuner combo frontend) as being found on Digital
Devices MaxS8 4/8 tunerport cards.

These patches conclude the tuner hardware support for all Digital Devices
hardware as of dddvb-0.9.29 and gets mainline on par with the vendor
driver.

Cleanup notes:

The driver was in no way submittable in it's original form: It had some
very scary construct in that #define's carried multiple function para-
meters (comma-separated things), which were passed to another #define,
which then in turn referenced a function, like this pseudocode:

  #define REGDEF1     0x1234,2,3
  #define FNCALL      real_fn(othervar,regdef)
  function real_fn(var,reg,var1,var2,val)

  real_fn(state,REGDEF1,1);

Not only checkpatch didn't like this, but it looked heavily confusing.
During cleanup, all of this obfuscation was expanded. Also, _defs.h
carried all of the enums and structs as typedef's. All of this has been
cleaned, together with the usual CamelCase things, whitespace and so on,
results: 55 "line len > 80 chars" in _defs.h and _regs.h (which I'd like
to keep to retain readability), everything else clean. Everything else
(e.g. overall code design) should be ok, but this should be judged by
reviewers.

The resulting driver has been tested and works fine.

The glue code in ddbridge was added into a new object ddbridge-maxs8 to
keep -core clean. It was added mostly as-is, and a little fixup commit
is put ontop. LNB control is done by the bridge card in case of these
cards, so that lives in the bridge driver (and is the majority of the
additional object).

Thanks in advance for reviewing this.

Daniel Scheller (4):
  [media] dvb-frontends: MaxLinear MxL5xx DVB-S/S2 tuner-demodulator
    driver
  [media] ddbridge: support MaxLinear MXL5xx based cards (MaxS4/8)
  [media] ddbridge: fix buffer overflow in max_set_input_unlocked()
  [media] MAINTAINERS: add entry for mxl5xx

 MAINTAINERS                                 |    8 +
 drivers/media/dvb-frontends/Kconfig         |    9 +
 drivers/media/dvb-frontends/Makefile        |    1 +
 drivers/media/dvb-frontends/mxl5xx.c        | 1873 +++++++++++++++++++++++++++
 drivers/media/dvb-frontends/mxl5xx.h        |   41 +
 drivers/media/dvb-frontends/mxl5xx_defs.h   |  731 +++++++++++
 drivers/media/dvb-frontends/mxl5xx_regs.h   |  367 ++++++
 drivers/media/pci/ddbridge/Kconfig          |    2 +
 drivers/media/pci/ddbridge/Makefile         |    2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c  |   67 +-
 drivers/media/pci/ddbridge/ddbridge-hw.c    |   12 +
 drivers/media/pci/ddbridge/ddbridge-hw.h    |    4 +
 drivers/media/pci/ddbridge/ddbridge-main.c  |    1 +
 drivers/media/pci/ddbridge/ddbridge-maxs8.c |  444 +++++++
 drivers/media/pci/ddbridge/ddbridge-maxs8.h |   29 +
 drivers/media/pci/ddbridge/ddbridge-regs.h  |   21 +
 drivers/media/pci/ddbridge/ddbridge.h       |   11 +
 17 files changed, 3619 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/mxl5xx.c
 create mode 100644 drivers/media/dvb-frontends/mxl5xx.h
 create mode 100644 drivers/media/dvb-frontends/mxl5xx_defs.h
 create mode 100644 drivers/media/dvb-frontends/mxl5xx_regs.h
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-maxs8.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-maxs8.h

-- 
2.13.0
