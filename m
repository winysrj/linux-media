Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35177 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751181AbdH0Kfg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 06:35:36 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, sean@mess.org,
        jasmin@anw.at
Subject: [PATCH V2 0/1] build: gpio-ir-tx for 3.13
Date: Sun, 27 Aug 2017 12:35:23 +0200
Message-Id: <1503830124-3634-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Changes to V1:
 Moved IR_GPIO_TX from 4.10.0 to 3.13.0 instead of adding it.

Kernel 3.17 introduces GPIOD_OUT_LOW/HIGH. gpio-ir-tx requires this
definitions. This patch adds the API calls prior to 3.17 to be used
by gpio-ir-tx.
With that gpio-ir-tx can be compiled back to Kernel 3.13.
I tested the compilation (not the functionality!) on 4.4, 3.13 and
3.4.

@Sean: Please check if the code in v3.16_gpio-ir-tx.patch looks
feasible for you (can't test this here). If not, we will drop this
patch and simply disable gpio-ir-tx for Kernels older than 3.17.

Jasmin Jessich (1):
  build: gpio-ir-tx backport

 backports/backports.txt          |  1 +
 backports/v3.16_gpio-ir-tx.patch | 25 +++++++++++++++++++++++++
 v4l/versions.txt                 |  2 +-
 3 files changed, 27 insertions(+), 1 deletion(-)
 create mode 100644 backports/v3.16_gpio-ir-tx.patch

-- 
2.7.4
