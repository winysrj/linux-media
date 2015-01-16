Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38791 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbbAPLYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 06:24:50 -0500
Received: by mail-pa0-f44.google.com with SMTP id et14so23759192pad.3
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 03:24:49 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 0/4] modify earth-pt3 and its dependees to use i2c template
Date: Fri, 16 Jan 2015 20:24:36 +0900
Message-Id: <1421407480-9122-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch series depends on the previous patch:
"[PATCH v3]dvb-core: add template code for i2c binding model"

The adapter(earth-pt3), its demod (tc90522) and tuners (mxl301rf, qm1d1c0042)
are ported to dvb-core i2c template.

Changes in v3:
- tc90522,earth-pt3: adapt to i2c template patch v3,
     moved fe_i2c_client from dvb_frontend* to state

Akihiro Tsukada (4):
  dvb: qm1d1c0042: use dvb-core i2c binding model template
  dvb: mxl301rf: use dvb-core i2c binding model template
  dvb: tc90522: use dvb-core i2c binding model template
  dvb: earth-pt3: use dvb-core i2c binding model template

 drivers/media/dvb-frontends/tc90522.c | 64 +++++++++++++-------------
 drivers/media/dvb-frontends/tc90522.h |  8 ++--
 drivers/media/pci/pt3/pt3.c           | 85 +++++++++++------------------------
 drivers/media/pci/pt3/pt3.h           | 11 ++---
 drivers/media/tuners/mxl301rf.c       | 50 ++++++---------------
 drivers/media/tuners/mxl301rf.h       |  2 +-
 drivers/media/tuners/qm1d1c0042.c     | 60 ++++++++-----------------
 drivers/media/tuners/qm1d1c0042.h     |  2 -
 8 files changed, 99 insertions(+), 183 deletions(-)

-- 
2.2.2

