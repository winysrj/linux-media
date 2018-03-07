Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34353 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754684AbeCGTXz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 14:23:55 -0500
Received: by mail-wr0-f196.google.com with SMTP id o8so3340966wra.1
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 11:23:54 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 0/4] misc cxd2099/Kconfig/ddbridge/ngene improvements
Date: Wed,  7 Mar 2018 20:23:46 +0100
Message-Id: <20180307192350.930-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This series improves this:

* The cxd2099 Kconfig block is improved to be more complete and to match
  those of the other drivers
* The sp2 CI driver is moved down to the new CI EN50221 subsection in the
  Kconfig of the dvb-frontends/ subdir
* Both ddbridge's and ngene's I2C client handling is cleaned up to make
  use of the new dvb_module_*() I2C handling helpers.

Daniel Scheller (4):
  [media] dvb-frontends/cxd2099: Kconfig additions
  [media] dvb-frontends/Kconfig: move the SP2 driver to the CI section
  [media] ddbridge: use common DVB I2C client handling helpers
  [media] ngene: use common DVB I2C client handling helpers

 drivers/media/dvb-frontends/Kconfig        | 18 +++++++------
 drivers/media/pci/ddbridge/ddbridge-ci.c   | 33 +++++------------------
 drivers/media/pci/ddbridge/ddbridge-core.c | 37 ++++++-------------------
 drivers/media/pci/ngene/ngene-cards.c      | 25 ++++-------------
 drivers/media/pci/ngene/ngene-core.c       | 43 +++++++-----------------------
 5 files changed, 40 insertions(+), 116 deletions(-)

-- 
2.16.1
