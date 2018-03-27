Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:46324 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbeC0RId (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 13:08:33 -0400
Received: by mail-pl0-f67.google.com with SMTP id f5-v6so14471158plj.13
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 10:08:33 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 0/4] dvb: pt3 etc.: SPDX License Identifier
Date: Wed, 28 Mar 2018 02:08:18 +0900
Message-Id: <20180327170822.21921-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

use SPDX License Identifier in the drivers that I wrote initially.

Akihiro Tsukada (4):
  dvb-frontends/tc90522: use SPDX License Identifier
  dvb/pci/pt3: use SPDX License Identifier
  tuners/mxl301rf: use SPDX License Identifier
  tuners/qm1d1c0042: use SPDX License Identifier

 drivers/media/dvb-frontends/tc90522.c | 11 +----------
 drivers/media/dvb-frontends/tc90522.h | 11 +----------
 drivers/media/pci/pt3/pt3.c           | 11 +----------
 drivers/media/pci/pt3/pt3.h           | 11 +----------
 drivers/media/pci/pt3/pt3_dma.c       | 11 +----------
 drivers/media/pci/pt3/pt3_i2c.c       | 11 +----------
 drivers/media/tuners/mxl301rf.c       | 11 +----------
 drivers/media/tuners/mxl301rf.h       | 11 +----------
 drivers/media/tuners/qm1d1c0042.c     | 11 +----------
 drivers/media/tuners/qm1d1c0042.h     | 11 +----------
 10 files changed, 10 insertions(+), 100 deletions(-)

-- 
2.16.3
