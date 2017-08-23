Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38709 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754136AbdHWQKG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 12:10:06 -0400
Received: by mail-wr0-f195.google.com with SMTP id k10so340954wre.5
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 09:10:06 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 0/5] last-minute misc ddbridge related changed
Date: Wed, 23 Aug 2017 18:09:57 +0200
Message-Id: <20170823161002.25459-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This small series improves on a few things related to the recently merged
ddbridge driver update:

stv0910:
  * add an explanation for the mutex_lock needs in gate_ctrl() and release
    the lock in case of I2C ctrl errors
  * announce 100Ksyms/s as minimum symbol rate
ddbridge:
  * fix the teardown and deregistration order wrt the i2c_client usage
  * fix most warnings reported by sparse (sparse still reports four
    spinlock/context warnings, that code will be kept as-is - there
    won't be locking problems since the checked pointers won't suddenly
    vanish)
staging/cxd2099:
  * disable buffer mode by default and make that controllable by a module
    parameter (suggested, requested and tested by Jasmin, modparm switch
    done by me)

Please pull these patches in for the 4.14 merge window, together with the
two ([1], [2]) remaining ones on patchwork - thank you very much!

[1] https://patchwork.linuxtv.org/patch/43350/
[2] https://patchwork.linuxtv.org/patch/43202/

Daniel Scheller (5):
  [media] dvb-frontends/stv0910: release lock on gate_ctrl() failure
  [media] ddbridge: fix teardown/deregistration order in
    ddb_input_detach()
  [media] ddbridge: fix sparse warnings
  [media] staging/cxd2099: Add module parameter for buffer mode
  [media] dvb-frontends/stv0910: change minsymrate to 100Ksyms/s

 drivers/media/dvb-frontends/stv0910.c      | 27 +++++++++++++++++-----
 drivers/media/pci/ddbridge/ddbridge-core.c | 37 +++++++++++++++---------------
 drivers/media/pci/ddbridge/ddbridge-io.h   | 12 +++++-----
 drivers/staging/media/cxd2099/cxd2099.c    | 21 +++++++++--------
 4 files changed, 57 insertions(+), 40 deletions(-)

-- 
2.13.0
