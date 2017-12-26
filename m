Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40567 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751122AbdLZXiD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 18:38:03 -0500
Received: by mail-wr0-f193.google.com with SMTP id p17so11801625wre.7
        for <linux-media@vger.kernel.org>; Tue, 26 Dec 2017 15:38:03 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 0/4] stv0910: upstream changes and PLS support
Date: Wed, 27 Dec 2017 00:37:55 +0100
Message-Id: <20171226233759.16116-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This series basically is meant to fully enable support for physical
layer scrambling which is now supported by the DVB core. Though I
decided to pick up the latest changes to the driver from the dddvb
upstream and bring both drivers in sync. So, along with support for
PLS, these patches apply some cosmetics and cleanups, adds macros to
utilise the field definitions for which the offsets were added
recently, and makes use of them while finally enabling PLS.

Daniel Scheller (4):
  [media] dvb-frontends/stv0910: deduplicate writes in
    enable_puncture_rate()
  [media] dvb-frontends/stv0910: cleanup I2C access functions
  [media] dvb-frontends/stv0910: field and register access helpers
  [media] dvb-frontends/stv0910: cleanup init_search_param() and enable
    PLS

 drivers/media/dvb-frontends/stv0910.c | 195 ++++++++++++++++++----------------
 1 file changed, 103 insertions(+), 92 deletions(-)

-- 
2.13.6
