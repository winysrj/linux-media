Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:8493 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756569AbdJRCuf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 22:50:35 -0400
From: Jiancheng Xue <xuejiancheng@hisilicon.com>
To: <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <shawn.guo@linaro.org>, <hermit.wangheming@hisilicon.com>,
        Jiancheng Xue <xuejiancheng@hisilicon.com>
Subject: [PATCH 0/2] [media] rc/keymaps: add support for two RCs of hisilicon boards.
Date: Wed, 18 Oct 2017 06:54:55 -0400
Message-ID: <1508324097-5514-1-git-send-email-xuejiancheng@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for two remote controllers of hisilicon boards.

Younian Wang (2):
  [media] rc/keymaps: add support for RC of hisilicon TV demo boards
  [media] rc/keymaps: add support for RC of hisilicon poplar board

 drivers/media/rc/keymaps/Makefile          |  2 +
 drivers/media/rc/keymaps/rc-hisi-poplar.c  | 58 +++++++++++++++++++++++++
 drivers/media/rc/keymaps/rc-hisi-tv-demo.c | 70 ++++++++++++++++++++++++++++++
 3 files changed, 130 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-hisi-poplar.c
 create mode 100644 drivers/media/rc/keymaps/rc-hisi-tv-demo.c

-- 
2.7.4
