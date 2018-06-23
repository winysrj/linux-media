Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34537 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbeFWPgT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:19 -0400
Received: by mail-wm0-f66.google.com with SMTP id l15-v6so8645509wmc.1
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:19 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 00/19] dddvb/ddbridge updates as of 2018-06-23
Date: Sat, 23 Jun 2018 17:35:56 +0200
Message-Id: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

A bunch of commits as they appeared in the dddvb upstream GIT as of
2018-06-23, mainly cleanups, cosmetics and code move in preparation for
new MCI card types, plus improvements to the existing SX8 code, ie.
DVBv5 signal statistics.

Also fixes one sparse warning as being reported by Hans' daily media_tree
build in the mxl5xx driver.

Daniel Scheller (19):
  [media] dvb-frontends/mxl5xx: add break to case DVBS2 in
    get_frontend()
  [media] dvb-frontends/stv0910: cast the BER denominator shift exp to
    ULL
  [media] ddbridge: probe for LNBH25 chips before attaching
  [media] ddbridge: evaluate the actual link when setting up the dummy
    tuner
  [media] ddbridge: report I2C bus errors
  [media] ddbridge: remove unused MDIO defines and hwinfo member
  [media] ddbridge: link structure access cosmetics in ddb_port_probe()
  [media] ddbridge: change MCI base ID and define a SX8 ID
  [media] ddbridge/mci: update copyright year in headers
  [media] ddbridge/mci: read and report signal strength and SNR
  [media] ddbridge/mci: rename defines and fix i/q var types
  [media] ddbridge/mci: extend mci_command and mci_result structs
  [media] ddbridge/mci: store mci type and number of ports in the hwinfo
  [media] ddbridge/mci: make ddb_mci_cmd() and ddb_mci_config() public
  [media] ddbridge/mci: split MaxSX8 specific code off to ddbridge-sx8.c
  [media] ddbridge/mci: add more MCI status codes, improve MCI_SUCCESS
    macro
  [media] ddbridge/sx8: disable automatic PLS code search
  [media] ddbridge/sx8: enable modulation selection in set_parameters()
  [media] ddbridge/mci: add SX8 I/Q mode remark and remove DIAG CMD
    defines

 drivers/media/dvb-frontends/mxl5xx.c       |   1 +
 drivers/media/dvb-frontends/stv0910.c      |   4 +-
 drivers/media/pci/ddbridge/Makefile        |   3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c |  45 +--
 drivers/media/pci/ddbridge/ddbridge-hw.c   |   3 +-
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |   5 +-
 drivers/media/pci/ddbridge/ddbridge-max.c  |  18 +-
 drivers/media/pci/ddbridge/ddbridge-max.h  |   2 +-
 drivers/media/pci/ddbridge/ddbridge-mci.c  | 409 ++----------------------
 drivers/media/pci/ddbridge/ddbridge-mci.h  | 192 ++++++++---
 drivers/media/pci/ddbridge/ddbridge-regs.h |   8 -
 drivers/media/pci/ddbridge/ddbridge-sx8.c  | 490 +++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge.h      |  14 +-
 13 files changed, 718 insertions(+), 476 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-sx8.c

-- 
2.16.4
