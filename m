Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6431 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753947AbcIKPCW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 11:02:22 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] constify dvb_tuner_ops structures
Date: Sun, 11 Sep 2016 16:44:11 +0200
Message-Id: <1473605054-9002-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Constify dvb_tuner_ops structures

---

 drivers/media/dvb-frontends/ascot2e.c         |    2 +-
 drivers/media/dvb-frontends/dvb-pll.c         |    2 +-
 drivers/media/dvb-frontends/helene.c          |    4 ++--
 drivers/media/dvb-frontends/horus3a.c         |    2 +-
 drivers/media/dvb-frontends/ix2505v.c         |    2 +-
 drivers/media/dvb-frontends/stb6000.c         |    2 +-
 drivers/media/dvb-frontends/stb6100.c         |    2 +-
 drivers/media/dvb-frontends/stv6110.c         |    2 +-
 drivers/media/dvb-frontends/stv6110x.c        |    2 +-
 drivers/media/dvb-frontends/tda18271c2dd.c    |    2 +-
 drivers/media/dvb-frontends/tda665x.c         |    2 +-
 drivers/media/dvb-frontends/tda8261.c         |    2 +-
 drivers/media/dvb-frontends/tda826x.c         |    2 +-
 drivers/media/dvb-frontends/ts2020.c          |    2 +-
 drivers/media/dvb-frontends/tua6100.c         |    2 +-
 drivers/media/dvb-frontends/zl10036.c         |    2 +-
 drivers/media/dvb-frontends/zl10039.c         |    2 +-
 drivers/media/tuners/mt2063.c                 |    2 +-
 drivers/media/tuners/mt20xx.c                 |    4 ++--
 drivers/media/tuners/mxl5007t.c               |    2 +-
 drivers/media/tuners/tda827x.c                |    4 ++--
 drivers/media/tuners/tea5761.c                |    2 +-
 drivers/media/tuners/tea5767.c                |    2 +-
 drivers/media/tuners/tuner-simple.c           |    2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |    2 +-
 25 files changed, 28 insertions(+), 28 deletions(-)
