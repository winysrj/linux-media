Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64110 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbbAGNVA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 08:21:00 -0500
Received: by mail-pd0-f179.google.com with SMTP id fp1so4626651pdb.10
        for <linux-media@vger.kernel.org>; Wed, 07 Jan 2015 05:21:00 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 0/4] modify earth-pt3 and its dependees to use i2c template
Date: Wed,  7 Jan 2015 22:20:40 +0900
Message-Id: <1420636844-32553-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch series depends on the previous patch:
"[PATCH v2]dvb-core: add template code for i2c binding model"
<1420635900-32221-1-git-send-email-tskd08@gmail.com>

The adapter(earth-pt3), its demod (tc90522) and tuners (mxl301rf, qm1d1c0042)
are ported to dvb-core i2c template.

Akihiro Tsukada (4):
  dvb: qm1d1c0042: use dvb-core i2c binding model template
  dvb: mxl301rf: use dvb-core i2c binding model template
  dvb: tc90522: use dvb-core i2c binding model template
  dvb: earth-pt3: use dvb-core i2c binding model template

 drivers/media/dvb-frontends/tc90522.c | 143 ++++++++++++++--------------------
 drivers/media/dvb-frontends/tc90522.h |   8 +-
 drivers/media/pci/pt3/pt3.c           |  89 +++++++--------------
 drivers/media/pci/pt3/pt3.h           |  12 +--
 drivers/media/tuners/mxl301rf.c       |  50 ++++--------
 drivers/media/tuners/mxl301rf.h       |   2 +-
 drivers/media/tuners/qm1d1c0042.c     |  60 +++++---------
 drivers/media/tuners/qm1d1c0042.h     |   2 -
 8 files changed, 129 insertions(+), 237 deletions(-)

-- 
2.2.1

