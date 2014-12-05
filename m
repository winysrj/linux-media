Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54188 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaLEK4C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 05:56:02 -0500
Received: by mail-pa0-f46.google.com with SMTP id lj1so494480pab.5
        for <linux-media@vger.kernel.org>; Fri, 05 Dec 2014 02:56:01 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 0/5] ports to dvb-core i2c template code
Date: Fri,  5 Dec 2014 19:55:35 +0900
Message-Id: <1417776940-16381-1-git-send-email-tskd08@gmail.com>
In-Reply-To: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

These patches are example ports of earth-pt3 (adapter),
tc90522 (demod), qm1d1c0042,mxl301rf (tuners) drivers
using the i2c template code in dvb-core.

Akihiro Tsukada (5):
  dvb: qm1d1c0042: use dvb-core i2c binding model template
  dvb: mxl301rf: use dvb-core i2c binding model template
  dvb: tc90522: use dvb-core i2c binding model template
  dvb: tc90522: remove a redundant state variable
  dvb: pci/pt3: use dvb-core i2c binding model template

 drivers/media/dvb-frontends/tc90522.c | 145 ++++++++++++++--------------------
 drivers/media/dvb-frontends/tc90522.h |   8 +-
 drivers/media/pci/pt3/pt3.c           |  89 +++++++--------------
 drivers/media/pci/pt3/pt3.h           |  12 +--
 drivers/media/tuners/mxl301rf.c       |  50 +++---------
 drivers/media/tuners/mxl301rf.h       |   2 +-
 drivers/media/tuners/qm1d1c0042.c     |  61 +++++---------
 drivers/media/tuners/qm1d1c0042.h     |   2 -
 8 files changed, 131 insertions(+), 238 deletions(-)

-- 
2.1.3

