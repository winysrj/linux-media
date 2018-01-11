Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36380 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754112AbeAKKZr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 05:25:47 -0500
Date: Thu, 11 Jan 2018 18:25:13 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: [linux-next:master 6051/9035]
 drivers/media/common/videobuf/videobuf2-core.o:(__jump_table+0x10):
 undefined reference to `__tracepoint_vb2_buf_queue'
Message-ID: <201801111810.RRkvEnSJ%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   b4464bcab38d3f7fe995a7cb960eeac6889bec08
commit: 03fbdb2fc2b8bb27b0ee0534fd3e9c57cdc3854a [6051/9035] media: move videobuf2 to drivers/media/common
config: x86_64-randconfig-s5-01110339
compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
reproduce:
        git checkout 03fbdb2fc2b8bb27b0ee0534fd3e9c57cdc3854a
        make ARCH=x86_64  randconfig
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
