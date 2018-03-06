Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51962 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbeCFQjS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 11:39:18 -0500
Received: by mail-wm0-f68.google.com with SMTP id h21so24020757wmd.1
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2018 08:39:17 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 0/4] cxd2099 series fixup
Date: Tue,  6 Mar 2018 17:39:09 +0100
Message-Id: <20180306163913.1519-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

These are the missing bits from the cxd2099 that went MIA during the
merge of the series.

Please pull - ngene driver requires the ngene patch for all I2C clients
to work (including the tda18212 that's now used since the merge of the
other ngene series) and ddbridge can't make use of the cxd2099 driver
at all right now.

Daniel Scheller (3):
  [media] ddbridge: adapt cxd2099 attach to new i2c_client way
  [media] ngene: add I2C_FUNC_I2C to the I2C interface functionality
  [media] dvb-frontends/cxd2099: remove remainders from old attach way

Jasmin Jessich (1):
  [media] MAINTAINERS: add entry for cxd2099

 MAINTAINERS                              |  8 +++++
 drivers/media/dvb-frontends/cxd2099.h    | 10 ------
 drivers/media/pci/ddbridge/ddbridge-ci.c | 62 +++++++++++++++++++++++++++++---
 drivers/media/pci/ddbridge/ddbridge.h    |  1 +
 drivers/media/pci/ngene/ngene-i2c.c      |  2 +-
 5 files changed, 67 insertions(+), 16 deletions(-)

-- 
2.16.1
