Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:35037 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbdFMI64 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 04:58:56 -0400
Received: by mail-pg0-f50.google.com with SMTP id k71so57614251pgd.2
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 01:58:56 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Rajendra <rnayak@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cao jin <caoj.fnst@cn.fujitsu.com>, linux-media@vger.kernel.org
Subject: [PATCH v2 0/3] ngene: Replace semaphores with mutexes
Date: Tue, 13 Jun 2017 14:28:47 +0530
Message-Id: <1497344330-13915-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are a set of patches [v2] which removes semaphores from ngene.
These are part of a bigger effort to eliminate unwanted semaphores
from the linux kernel.

v1 --> v2
---------

Moved mutex_[lock/unlock] outside caller for stream_mutex
mutex_lock converted to mutex_destroy in cmd_mutex

Binoy Jayan (3):
  media: ngene: Replace semaphore cmd_mutex with mutex
  media: ngene: Replace semaphore stream_mutex with mutex
  media: ngene: Replace semaphore i2c_switch_mutex with mutex

 drivers/media/pci/ngene/ngene-core.c | 32 ++++++++++++++------------------
 drivers/media/pci/ngene/ngene-i2c.c  |  6 +++---
 drivers/media/pci/ngene/ngene.h      |  6 +++---
 3 files changed, 20 insertions(+), 24 deletions(-)

-- 
Binoy Jayan
