Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:8997 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752916AbdJSLlL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 07:41:11 -0400
From: Jiancheng Xue <xuejiancheng@hisilicon.com>
To: <mchehab@kernel.org>
CC: <sean@mess.org>, <hverkuil@xs4all.nl>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <shawn.guo@linaro.org>, <hermit.wangheming@hisilicon.com>,
        <xuejiancheng@hisilicon.com>
Subject: [PATCH v2 0/2] [media] rc/keymaps: add support for two RCs of hisilicon boards.
Date: Thu, 19 Oct 2017 15:43:28 -0400
Message-ID: <1508442210-43958-1-git-send-email-xuejiancheng@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for two remote controllers of hisilicon boards.

ChangeLog:
v2:
Supplement copyright statements for source files.

Younian Wang (2):
  [media] rc/keymaps: add support for RC of hisilicon TV demo boards
  [media] rc/keymaps: add support for RC of hisilicon poplar board

 drivers/media/rc/keymaps/Makefile          |  2 +
 drivers/media/rc/keymaps/rc-hisi-poplar.c  | 69 +++++++++++++++++++++++++
 drivers/media/rc/keymaps/rc-hisi-tv-demo.c | 81 ++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-hisi-poplar.c
 create mode 100644 drivers/media/rc/keymaps/rc-hisi-tv-demo.c

-- 
2.7.4
