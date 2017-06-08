Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36210 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbdFHKFM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 06:05:12 -0400
Received: by mail-pf0-f178.google.com with SMTP id x63so15546083pff.3
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 03:05:12 -0700 (PDT)
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
Subject: [PATCH 0/3] ngene: Replace semaphores with mutexes
Date: Thu,  8 Jun 2017 15:34:55 +0530
Message-Id: <1496916298-5909-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are a set of patches which removes semaphores from ngene.
These are part of a bigger effort to eliminate unwanted semaphores
from the linux kernel.

Binoy Jayan (3):
  media: ngene: Replace semaphore cmd_mutex with mutex
  media: ngene: Replace semaphore stream_mutex with mutex
  media: ngene: Replace semaphore i2c_switch_mutex with mutex

 drivers/media/pci/ngene/ngene-core.c | 28 ++++++++++++++--------------
 drivers/media/pci/ngene/ngene-i2c.c  |  6 +++---
 drivers/media/pci/ngene/ngene.h      |  6 +++---
 3 files changed, 20 insertions(+), 20 deletions(-)

-- 
Binoy Jayan
