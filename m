Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36185 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030407AbeFSSvW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:51:22 -0400
Received: by mail-wm0-f68.google.com with SMTP id v131-v6so2331700wma.1
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:51:21 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, jasmin@anw.at,
        rjkm@metzlerbros.de, mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/3] cxd2099: cleanup licensing
Date: Tue, 19 Jun 2018 20:51:16 +0200
Message-Id: <20180619185119.24548-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Upstream committed a change to the dddvb driver package ([1]) that makes
things clear everything is licensed under the terms of the GPLv2-only.
So, apply the MODULE_LICENSE change to cxd2099 and, as things are sorted
now, apply SPDX license identifiers (and fix two spurious whitespaces).

Split from the series that touches all other Digital Devices drivers
since Jasmin is the maintainer for the cxd2099 driver.

Ralph/Manfred: Although all license related things should be clear by
now, please be so kind and send Acks (or complaints, if any) on these
patches so we can finally get rid of any mismatches in the in-kernel
drivers.

[1] https://github.com/DigitalDevices/dddvb/commit/3db30defab4bd5429f6563b084a215b83da01ea0

Daniel Scheller (3):
  [media] dvb-frontends/cxd2099: fix MODULE_LICENSE to 'GPL v2'
  [media] dvb-frontends/cxd2099: add SPDX license identifier
  [media] dvb-frontends/cxd2099: fix boilerplate whitespace

 drivers/media/dvb-frontends/cxd2099.c | 5 +++--
 drivers/media/dvb-frontends/cxd2099.h | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.16.4
