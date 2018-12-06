Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD06C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 08:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2A11214DA
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 08:23:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2A11214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbeLFIXG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 03:23:06 -0500
Received: from mga17.intel.com ([192.55.52.151]:30083 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727575AbeLFIXG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 03:23:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2018 00:21:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,321,1539673200"; 
   d="scan'208";a="116458116"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 06 Dec 2018 00:20:53 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gUotw-000GLJ-MT; Thu, 06 Dec 2018 16:20:52 +0800
Date:   Thu, 06 Dec 2018 16:20:25 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc:     linux-media@vger.kernel.org
Subject: [ragnatech:media-tree] BUILD SUCCESS
 3c28b91380dd1183347d32d87d820818031ebecf
Message-ID: <5c08dbc9.tm9HFVWtgA4KXwNc%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

tree/branch: git://git.ragnatech.se/linux  media-tree
branch HEAD: 3c28b91380dd1183347d32d87d820818031ebecf  media: stkwebcam: Bugfix for wrong return values

i386-tinyconfig vmlinux size:

+-----------+-------------------------------------------+---------------------------------------------------------------------------+
|   DELTA   |                  SYMBOL                   |                                  COMMIT                                   |
+-----------+-------------------------------------------+---------------------------------------------------------------------------+
| +32613647 |                                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
| +32613380 |                                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +53 |                                           | d644cca50f36 media: vb2: Allow reqbufs(0) with "in use" MMAP buffers      |
|       +50 |                                           | 5cc7522d8965 media: sun6i: Add support for Allwinner CSI V3s              |
|       +48 |                                           | cd26d1c4d1bc media: vb2: vb2_mmap: move lock up                           |
| -32613531 |                                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
| -32613647 |                                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  +9960603 | arch                                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +9960535 | arch                                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       +48 | arch                                      | cd26d1c4d1bc media: vb2: vb2_mmap: move lock up                           |
|  -9960535 | arch                                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  -9960651 | arch                                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  +9960381 | arch/x86                                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +9960313 | arch/x86                                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       +48 | arch/x86                                  | cd26d1c4d1bc media: vb2: vb2_mmap: move lock up                           |
|  -9960313 | arch/x86                                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  -9960429 | arch/x86                                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  +4901890 | usr                                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|  +4901382 | usr                                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +53 | usr                                       | d644cca50f36 media: vb2: Allow reqbufs(0) with "in use" MMAP buffers      |
|  -4901435 | usr                                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  -4901890 | usr                                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  +4901692 | usr/include                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|  +4901184 | usr/include                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +53 | usr/include                               | d644cca50f36 media: vb2: Allow reqbufs(0) with "in use" MMAP buffers      |
|  -4901237 | usr/include                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  -4901692 | usr/include                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  +4898884 | kernel                                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +4898884 | kernel                                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|  -4898884 | kernel                                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  -4898884 | kernel                                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  +3927099 | arch/x86/boot                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +3927031 | arch/x86/boot                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       +48 | arch/x86/boot                             | cd26d1c4d1bc media: vb2: vb2_mmap: move lock up                           |
|  -3927031 | arch/x86/boot                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  -3927147 | arch/x86/boot                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  +3768356 | usr/include/linux                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|  +3768187 | usr/include/linux                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +53 | usr/include/linux                         | d644cca50f36 media: vb2: Allow reqbufs(0) with "in use" MMAP buffers      |
|  -3768240 | usr/include/linux                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  -3768356 | usr/include/linux                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  +3429940 | arch/x86/kernel                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +3429940 | arch/x86/kernel                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|  -3429940 | arch/x86/kernel                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  -3429940 | arch/x86/kernel                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  +2630649 | mm                                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +2630649 | mm                                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|  -2630649 | mm                                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  -2630649 | mm                                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  +2266195 | arch/x86/boot/compressed                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +2266159 | arch/x86/boot/compressed                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       +36 | arch/x86/boot/compressed                  | cd26d1c4d1bc media: vb2: vb2_mmap: move lock up                           |
|  -2266159 | arch/x86/boot/compressed                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  -2266231 | arch/x86/boot/compressed                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  +2167910 | fs                                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +2167910 | fs                                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|  -2167910 | fs                                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  -2167910 | fs                                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  +2138843 | lib                                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +2138843 | lib                                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|  -2138843 | lib                                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  -2138843 | lib                                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  +1348230 | drivers                                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +1348008 | drivers                                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|  -1348008 | drivers                                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|  -1348230 | drivers                                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +2436 | TOTAL                                     | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|      +794 | TOTAL                                     | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|     +2605 | TEXT                                      | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|      +893 | TEXT                                      | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      -197 | RODATA                                    | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|      -107 | RODATA                                    | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|  +1006102 | drivers/base                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|  +1006102 | drivers/base                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|  -1006102 | drivers/base                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|  -1006102 | drivers/base                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +923735 | kernel/sched                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +923735 | kernel/sched                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -923735 | kernel/sched                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -923735 | kernel/sched                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +858238 | scripts                                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +858238 | scripts                                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -858238 | scripts                                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -858238 | scripts                                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +781005 | arch/x86/mm                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +781005 | arch/x86/mm                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -781005 | arch/x86/mm                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -781005 | arch/x86/mm                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +765370 | arch/x86/events                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +765370 | arch/x86/events                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -765370 | arch/x86/events                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -765370 | arch/x86/events                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +722238 | kernel/time                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +722238 | kernel/time                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -722238 | kernel/time                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -722238 | kernel/time                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +679993 | arch/x86/kernel/cpu                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +679993 | arch/x86/kernel/cpu                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -679993 | arch/x86/kernel/cpu                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -679993 | arch/x86/kernel/cpu                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +559919 | arch/x86/events/intel                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +559919 | arch/x86/events/intel                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -559919 | arch/x86/events/intel                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -559919 | arch/x86/events/intel                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +476339 | scripts/kconfig                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +476339 | scripts/kconfig                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -476339 | scripts/kconfig                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -476339 | scripts/kconfig                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +411913 | kernel/irq                                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +411913 | kernel/irq                                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -411913 | kernel/irq                                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -411913 | kernel/irq                                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +389492 | usr/include/drm                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +389492 | usr/include/drm                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -389492 | usr/include/drm                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -389492 | usr/include/drm                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +386162 | arch/x86/entry                            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +386162 | arch/x86/entry                            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -386162 | arch/x86/entry                            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -386162 | arch/x86/entry                            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +362329 | arch/x86/lib                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +362329 | arch/x86/lib                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -362329 | arch/x86/lib                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -362329 | arch/x86/lib                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +342921 | init                                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +342921 | init                                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -342921 | init                                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -342921 | init                                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +306598 | kernel/events                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +306598 | kernel/events                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -306598 | kernel/events                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -306598 | kernel/events                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +302774 | scripts/mod                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +302774 | scripts/mod                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -302774 | scripts/mod                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -302774 | scripts/mod                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +292702 | arch/x86/kernel/fpu                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +292702 | arch/x86/kernel/fpu                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -292702 | arch/x86/kernel/fpu                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -292702 | arch/x86/kernel/fpu                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +228260 | arch/x86/entry/vdso                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +228260 | arch/x86/entry/vdso                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -228260 | arch/x86/entry/vdso                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -228260 | arch/x86/entry/vdso                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +207761 | usr/include/sound                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   +207422 | usr/include/sound                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   -207422 | usr/include/sound                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -207761 | usr/include/sound                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +203084 | mm/                                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   +199704 | mm/                                       | dafb7f9aef2f v4l2-controls: add a missing include                         |
|   +191280 | mm/                                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +187908 | mm/                                       | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     -2232 | mm/                                       | b9bbbbfef991 media: vicodec: Change variable names                        |
|     -3372 | mm/                                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     -3372 | mm/                                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -187908 | mm/                                       | b03c2fb97adc media: add SECO cec driver                                   |
|   -188704 | mm/                                       | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|   -199712 | mm/                                       | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|   +176939 | kernel/locking                            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +176939 | kernel/locking                            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -176939 | kernel/locking                            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -176939 | kernel/locking                            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +176813 | drivers/char                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +176813 | drivers/char                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -176813 | drivers/char                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -176813 | drivers/char                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +161654 | usr/include/rdma                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +161654 | usr/include/rdma                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -161654 | usr/include/rdma                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -161654 | usr/include/rdma                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +153054 | usr/include/linux/netfilter               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +153054 | usr/include/linux/netfilter               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -153054 | usr/include/linux/netfilter               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -153054 | usr/include/linux/netfilter               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +147998 | kernel/dma                                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +147998 | kernel/dma                                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -147998 | kernel/dma                                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -147998 | kernel/dma                                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +147315 | kernel/rcu                                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +147315 | kernel/rcu                                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -147315 | kernel/rcu                                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -147315 | kernel/rcu                                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +140728 | arch/x86/kernel/cpu/                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +139594 | arch/x86/kernel/cpu/                      | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|    +49300 | arch/x86/kernel/cpu/                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +48062 | arch/x86/kernel/cpu/                      | dafb7f9aef2f v4l2-controls: add a missing include                         |
|    +32000 | arch/x86/kernel/cpu/                      | b9bbbbfef991 media: vicodec: Change variable names                        |
|     -1134 | arch/x86/kernel/cpu/                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     -1134 | arch/x86/kernel/cpu/                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -48166 | arch/x86/kernel/cpu/                      | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|   -139546 | arch/x86/kernel/cpu/                      | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|   -139594 | arch/x86/kernel/cpu/                      | b03c2fb97adc media: add SECO cec driver                                   |
|   +133528 |                                           | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|      +364 |                                           | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|      +152 |                                           | dafb7f9aef2f v4l2-controls: add a missing include                         |
|      +148 |                                           | b03c2fb97adc media: add SECO cec driver                                   |
|      -184 |                                           | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|      -252 |                                           | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|   -132834 |                                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   -133528 |                                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   +132161 | arch/x86/realmode                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +132161 | arch/x86/realmode                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -132161 | arch/x86/realmode                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -132161 | arch/x86/realmode                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +130097 | usr/include/asm                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +130097 | usr/include/asm                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -130097 | usr/include/asm                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -130097 | usr/include/asm                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +122856 | arch/x86/events/amd                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +122856 | arch/x86/events/amd                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -122856 | arch/x86/events/amd                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -122856 | arch/x86/events/amd                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +121864 | usr/include/linux/usb                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +121864 | usr/include/linux/usb                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -121864 | usr/include/linux/usb                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -121864 | usr/include/linux/usb                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +106724 | security                                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|   +106724 | security                                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|   -106724 | security                                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|   -106724 | security                                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|   +100104 | arch/x86/events/intel/                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +99494 | arch/x86/events/intel/                    | dafb7f9aef2f v4l2-controls: add a missing include                         |
|      -602 | arch/x86/events/intel/                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -602 | arch/x86/events/intel/                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -99502 | arch/x86/events/intel/                    | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|    +96545 | usr/include/asm-generic                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +96545 | usr/include/asm-generic                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -96545 | usr/include/asm-generic                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -96545 | usr/include/asm-generic                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +94410 | fs/ramfs                                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +94410 | fs/ramfs                                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -94410 | fs/ramfs                                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -94410 | fs/ramfs                                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +91049 | include                                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    +91000 | include                                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +50 | include                                   | 5cc7522d8965 media: sun6i: Add support for Allwinner CSI V3s              |
|    -91049 | include                                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    -91050 | include                                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +86185 | drivers/rtc                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +86185 | drivers/rtc                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -86185 | drivers/rtc                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -86185 | drivers/rtc                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +83308 | arch/x86/tools                            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +83308 | arch/x86/tools                            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -83308 | arch/x86/tools                            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -83308 | arch/x86/tools                            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +79277 | arch/x86/include                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +79277 | arch/x86/include                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -79277 | arch/x86/include                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -79277 | arch/x86/include                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +79217 | arch/x86/include/generated                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +79217 | arch/x86/include/generated                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -79217 | arch/x86/include/generated                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -79217 | arch/x86/include/generated                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +78296 | kernel/time/                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +77052 | kernel/time/                              | dafb7f9aef2f v4l2-controls: add a missing include                         |
|    +68320 | kernel/time/                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +67236 | kernel/time/                              | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +4972 | kernel/time/                              | b9bbbbfef991 media: vicodec: Change variable names                        |
|     -1084 | kernel/time/                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     -1084 | kernel/time/                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -67236 | kernel/time/                              | b03c2fb97adc media: add SECO cec driver                                   |
|    -67488 | kernel/time/                              | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|    -77212 | kernel/time/                              | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|    +75996 | usr/include/scsi                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +75996 | usr/include/scsi                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -75996 | usr/include/scsi                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -75996 | usr/include/scsi                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +74151 | include/config                            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    +74101 | include/config                            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +50 | include/config                            | 5cc7522d8965 media: sun6i: Add support for Allwinner CSI V3s              |
|    -74151 | include/config                            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -74151 | include/config                            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +67889 | arch/x86/entry/vdso/vdso32                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +67889 | arch/x86/entry/vdso/vdso32                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -67889 | arch/x86/entry/vdso/vdso32                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -67889 | arch/x86/entry/vdso/vdso32                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +67656 | kernel/events/                            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +67190 | kernel/events/                            | dafb7f9aef2f v4l2-controls: add a missing include                         |
|    +53268 | kernel/events/                            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +52906 | kernel/events/                            | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +6928 | kernel/events/                            | b9bbbbfef991 media: vicodec: Change variable names                        |
|      -362 | kernel/events/                            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -362 | kernel/events/                            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -52882 | kernel/events/                            | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|    -52906 | kernel/events/                            | b03c2fb97adc media: add SECO cec driver                                   |
|    -67294 | kernel/events/                            | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|    +67486 | kernel/printk                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +67486 | kernel/printk                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -67486 | kernel/printk                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -67486 | kernel/printk                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +66684 | arch/x86/realmode/rm                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +66684 | arch/x86/realmode/rm                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -66684 | arch/x86/realmode/rm                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -66684 | arch/x86/realmode/rm                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +64050 | usr/include/linux/dvb                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +64050 | usr/include/linux/dvb                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -64050 | usr/include/linux/dvb                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -64050 | usr/include/linux/dvb                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +60908 | kernel/power                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +60908 | kernel/power                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -60908 | kernel/power                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -60908 | kernel/power                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +49780 | arch/x86/kernel/apic                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +49780 | arch/x86/kernel/apic                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -49780 | arch/x86/kernel/apic                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -49780 | arch/x86/kernel/apic                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +48216 | kernel/sched/                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +47214 | kernel/sched/                             | dafb7f9aef2f v4l2-controls: add a missing include                         |
|    +43748 | kernel/sched/                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +42702 | kernel/sched/                             | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +1792 | kernel/sched/                             | b9bbbbfef991 media: vicodec: Change variable names                        |
|      -978 | kernel/sched/                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -978 | kernel/sched/                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -42770 | kernel/sched/                             | b03c2fb97adc media: add SECO cec driver                                   |
|    -43722 | kernel/sched/                             | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|    -47238 | kernel/sched/                             | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|    +47693 | usr/include/scsi/fc                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +47693 | usr/include/scsi/fc                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -47693 | usr/include/scsi/fc                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -47693 | usr/include/scsi/fc                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +46531 | drivers/base/firmware_loader              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +46531 | drivers/base/firmware_loader              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -46531 | drivers/base/firmware_loader              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -46531 | drivers/base/firmware_loader              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +43114 | arch/x86/include/generated/asm            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +43114 | arch/x86/include/generated/asm            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -43114 | arch/x86/include/generated/asm            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -43114 | arch/x86/include/generated/asm            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +40052 | arch/x86/mm/                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +38920 | arch/x86/mm/                              | dafb7f9aef2f v4l2-controls: add a missing include                         |
|    +32084 | arch/x86/mm/                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +30952 | arch/x86/mm/                              | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +7520 | arch/x86/mm/                              | b9bbbbfef991 media: vicodec: Change variable names                        |
|     -1132 | arch/x86/mm/                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     -1132 | arch/x86/mm/                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -30952 | arch/x86/mm/                              | b03c2fb97adc media: add SECO cec driver                                   |
|    -31488 | arch/x86/mm/                              | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|    -38920 | arch/x86/mm/                              | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|    +39656 | init/                                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +39154 | init/                                     | dafb7f9aef2f v4l2-controls: add a missing include                         |
|    +35064 | init/                                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +34562 | init/                                     | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +4640 | init/                                     | b9bbbbfef991 media: vicodec: Change variable names                        |
|      -502 | init/                                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -502 | init/                                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -34562 | init/                                     | b03c2fb97adc media: add SECO cec driver                                   |
|    -34898 | init/                                     | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|    -39154 | init/                                     | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|    +37747 | drivers/clocksource                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +37747 | drivers/clocksource                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -37747 | drivers/clocksource                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -37747 | drivers/clocksource                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +36023 | arch/x86/include/generated/uapi           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +36023 | arch/x86/include/generated/uapi           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -36023 | arch/x86/include/generated/uapi           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -36023 | arch/x86/include/generated/uapi           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +35963 | arch/x86/include/generated/uapi/asm       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +35963 | arch/x86/include/generated/uapi/asm       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -35963 | arch/x86/include/generated/uapi/asm       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -35963 | arch/x86/include/generated/uapi/asm       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +33546 | usr/include/mtd                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +33546 | usr/include/mtd                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -33546 | usr/include/mtd                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -33546 | usr/include/mtd                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +31102 | arch/x86/entry/vsyscall                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +31102 | arch/x86/entry/vsyscall                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -31102 | arch/x86/entry/vsyscall                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -31102 | arch/x86/entry/vsyscall                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +26084 | usr/include/linux/can                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +26084 | usr/include/linux/can                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -26084 | usr/include/linux/can                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -26084 | usr/include/linux/can                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +23424 | usr/include/sound/sof                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    +23085 | usr/include/sound/sof                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    -23085 | usr/include/sound/sof                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -23424 | usr/include/sound/sof                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +23135 | usr/include/linux/netfilter_bridge        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +23135 | usr/include/linux/netfilter_bridge        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -23135 | usr/include/linux/netfilter_bridge        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -23135 | usr/include/linux/netfilter_bridge        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +22196 | arch/x86/kernel/fpu/                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +21674 | arch/x86/kernel/fpu/                      | dafb7f9aef2f v4l2-controls: add a missing include                         |
|    +19540 | arch/x86/kernel/fpu/                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      -482 | arch/x86/kernel/fpu/                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -482 | arch/x86/kernel/fpu/                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -21714 | arch/x86/kernel/fpu/                      | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|    +22068 | kernel/irq/                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +21346 | kernel/irq/                               | dafb7f9aef2f v4l2-controls: add a missing include                         |
|    +18872 | kernel/irq/                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +18166 | kernel/irq/                               | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +1880 | kernel/irq/                               | b9bbbbfef991 media: vicodec: Change variable names                        |
|      -706 | kernel/irq/                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -706 | kernel/irq/                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -18166 | kernel/irq/                               | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|    -18166 | kernel/irq/                               | b03c2fb97adc media: add SECO cec driver                                   |
|    -21362 | kernel/irq/                               | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|    +21784 | usr/include/xen                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +21784 | usr/include/xen                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -21784 | usr/include/xen                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -21784 | usr/include/xen                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +21270 | usr/include/linux/raid                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +21270 | usr/include/linux/raid                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -21270 | usr/include/linux/raid                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -21270 | usr/include/linux/raid                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +19219 | usr/include/linux/netfilter_ipv6          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +19219 | usr/include/linux/netfilter_ipv6          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -19219 | usr/include/linux/netfilter_ipv6          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -19219 | usr/include/linux/netfilter_ipv6          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +18532 | usr/include/linux/genwqe                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +18532 | usr/include/linux/genwqe                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -18532 | usr/include/linux/genwqe                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -18532 | usr/include/linux/genwqe                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +16819 | include/generated                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +16818 | include/generated                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -16818 | include/generated                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    -16819 | include/generated                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +16775 | arch/x86/boot/tools                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +16775 | arch/x86/boot/tools                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -16775 | arch/x86/boot/tools                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -16775 | arch/x86/boot/tools                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +16641 | usr/include/linux/wimax                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +16641 | usr/include/linux/wimax                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -16641 | usr/include/linux/wimax                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -16641 | usr/include/linux/wimax                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +16503 | scripts/basic                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +16503 | scripts/basic                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -16503 | scripts/basic                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -16503 | scripts/basic                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +16461 | usr/include/rdma/hfi                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +16461 | usr/include/rdma/hfi                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -16461 | usr/include/rdma/hfi                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -16461 | usr/include/rdma/hfi                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +14714 | usr/include/linux/android                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +14714 | usr/include/linux/android                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -14714 | usr/include/linux/android                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -14714 | usr/include/linux/android                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +13901 | drivers/media                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +13901 | drivers/media                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -13901 | drivers/media                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -13901 | drivers/media                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +13566 | usr/include/linux/tc_act                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +13566 | usr/include/linux/tc_act                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -13566 | usr/include/linux/tc_act                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -13566 | usr/include/linux/tc_act                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +12355 | usr/include/linux/netfilter_ipv4          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +12355 | usr/include/linux/netfilter_ipv4          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -12355 | usr/include/linux/netfilter_ipv4          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -12355 | usr/include/linux/netfilter_ipv4          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +11443 | usr/include/linux/netfilter/ipset         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|    +11443 | usr/include/linux/netfilter/ipset         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -11443 | usr/include/linux/netfilter/ipset         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    -11443 | usr/include/linux/netfilter/ipset         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +9663 | usr/include/video                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +9663 | usr/include/video                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -9663 | usr/include/video                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -9663 | usr/include/video                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +9550 | usr/include/linux/nfsd                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +9550 | usr/include/linux/nfsd                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -9550 | usr/include/linux/nfsd                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -9550 | usr/include/linux/nfsd                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +7960 | usr/include/linux/byteorder               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +7960 | usr/include/linux/byteorder               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -7960 | usr/include/linux/byteorder               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -7960 | usr/include/linux/byteorder               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +7625 | usr/include/linux/caif                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +7625 | usr/include/linux/caif                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -7625 | usr/include/linux/caif                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -7625 | usr/include/linux/caif                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +7444 | usr/include/linux/netfilter_arp           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +7444 | usr/include/linux/netfilter_arp           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -7444 | usr/include/linux/netfilter_arp           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -7444 | usr/include/linux/netfilter_arp           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +7344 | kernel/printk/                            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +7206 | kernel/printk/                            | dafb7f9aef2f v4l2-controls: add a missing include                         |
|     +6256 | kernel/printk/                            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +6118 | kernel/printk/                            | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|      -138 | kernel/printk/                            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -138 | kernel/printk/                            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -6118 | kernel/printk/                            | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|     -6118 | kernel/printk/                            | b03c2fb97adc media: add SECO cec driver                                   |
|     -7206 | kernel/printk/                            | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|     +7228 | kernel/locking/                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +6798 | kernel/locking/                           | dafb7f9aef2f v4l2-controls: add a missing include                         |
|     +5492 | kernel/locking/                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +5062 | kernel/locking/                           | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +2196 | kernel/locking/                           | b9bbbbfef991 media: vicodec: Change variable names                        |
|      -430 | kernel/locking/                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -430 | kernel/locking/                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -5062 | kernel/locking/                           | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|     -5062 | kernel/locking/                           | b03c2fb97adc media: add SECO cec driver                                   |
|     -6798 | kernel/locking/                           | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|     +6538 | usr/include/misc                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +6538 | usr/include/misc                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -6538 | usr/include/misc                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -6538 | usr/include/misc                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +6332 | kernel/rcu/                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +5986 | kernel/rcu/                               | dafb7f9aef2f v4l2-controls: add a missing include                         |
|     +5604 | kernel/rcu/                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +5258 | kernel/rcu/                               | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|      +936 | kernel/rcu/                               | b9bbbbfef991 media: vicodec: Change variable names                        |
|      -346 | kernel/rcu/                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -346 | kernel/rcu/                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -5258 | kernel/rcu/                               | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|     -5258 | kernel/rcu/                               | b03c2fb97adc media: add SECO cec driver                                   |
|     -5986 | kernel/rcu/                               | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|     +6296 | usr/include/linux/hsi                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +6296 | usr/include/linux/hsi                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -6296 | usr/include/linux/hsi                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -6296 | usr/include/linux/hsi                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +5860 | include/config/have                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +5860 | include/config/have                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -5860 | include/config/have                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -5860 | include/config/have                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +5769 | usr/include/linux/spi                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +5769 | usr/include/linux/spi                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -5769 | usr/include/linux/spi                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -5769 | usr/include/linux/spi                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +5764 | security/                                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +5550 | security/                                 | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +5100 | security/                                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +4886 | security/                                 | dafb7f9aef2f v4l2-controls: add a missing include                         |
|      -214 | security/                                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -214 | security/                                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -772 | security/                                 | b9bbbbfef991 media: vicodec: Change variable names                        |
|     -4886 | security/                                 | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|     -5550 | security/                                 | b03c2fb97adc media: add SECO cec driver                                   |
|     -6082 | security/                                 | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|     +5672 | fs/ramfs/                                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +5462 | fs/ramfs/                                 | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +5244 | fs/ramfs/                                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +5034 | fs/ramfs/                                 | dafb7f9aef2f v4l2-controls: add a missing include                         |
|      -210 | fs/ramfs/                                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -210 | fs/ramfs/                                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -468 | fs/ramfs/                                 | b9bbbbfef991 media: vicodec: Change variable names                        |
|     -5034 | fs/ramfs/                                 | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|     -5462 | fs/ramfs/                                 | b03c2fb97adc media: add SECO cec driver                                   |
|     -5502 | fs/ramfs/                                 | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|     +5540 | kernel/power/                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +5440 | kernel/power/                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +5404 | kernel/power/                             | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +5304 | kernel/power/                             | dafb7f9aef2f v4l2-controls: add a missing include                         |
|       -76 | kernel/power/                             | b9bbbbfef991 media: vicodec: Change variable names                        |
|      -136 | kernel/power/                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -136 | kernel/power/                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -5304 | kernel/power/                             | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|     -5404 | kernel/power/                             | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|     -5404 | kernel/power/                             | b03c2fb97adc media: add SECO cec driver                                   |
|     +5430 | usr/include/linux/isdn                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +5430 | usr/include/linux/isdn                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -5430 | usr/include/linux/isdn                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -5430 | usr/include/linux/isdn                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +5260 | include/config/arch                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +5260 | include/config/arch                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -5260 | include/config/arch                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -5260 | include/config/arch                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +4497 | usr/include/linux/tc_ematch               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +4497 | usr/include/linux/tc_ematch               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -4497 | usr/include/linux/tc_ematch               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -4497 | usr/include/linux/tc_ematch               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +4388 | drivers/media/pci                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +4388 | drivers/media/pci                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -4388 | drivers/media/pci                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -4388 | drivers/media/pci                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +4345 | arch/x86/platform                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +4345 | arch/x86/platform                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -4345 | arch/x86/platform                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -4345 | arch/x86/platform                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +4119 | usr/include/linux/iio                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +4119 | usr/include/linux/iio                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -4119 | usr/include/linux/iio                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -4119 | usr/include/linux/iio                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +3770 | drivers/gpu                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +3770 | drivers/gpu                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -3770 | drivers/gpu                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -3770 | drivers/gpu                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +3397 | usr/include/linux/sched                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +3397 | usr/include/linux/sched                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -3397 | usr/include/linux/sched                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -3397 | usr/include/linux/sched                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +3357 | usr/include/linux/hdlc                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +3357 | usr/include/linux/hdlc                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -3357 | usr/include/linux/hdlc                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -3357 | usr/include/linux/hdlc                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +3261 | drivers/gpu/drm                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +3261 | drivers/gpu/drm                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -3261 | drivers/gpu/drm                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -3261 | drivers/gpu/drm                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +3052 | drivers/rtc/                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +2832 | drivers/rtc/                              | dafb7f9aef2f v4l2-controls: add a missing include                         |
|     +1824 | drivers/rtc/                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1604 | drivers/rtc/                              | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|      +108 | drivers/rtc/                              | b9bbbbfef991 media: vicodec: Change variable names                        |
|      -220 | drivers/rtc/                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -220 | drivers/rtc/                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1604 | drivers/rtc/                              | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|     -1604 | drivers/rtc/                              | b03c2fb97adc media: add SECO cec driver                                   |
|     -2832 | drivers/rtc/                              | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|     +2976 | usr/include/linux/mmc                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +2976 | usr/include/linux/mmc                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -2976 | usr/include/linux/mmc                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -2976 | usr/include/linux/mmc                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +2948 | drivers/media/usb                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +2948 | drivers/media/usb                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -2948 | drivers/media/usb                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -2948 | drivers/media/usb                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +2620 | arch/x86/lib/                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +2116 | arch/x86/lib/                             | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +2116 | arch/x86/lib/                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +1612 | arch/x86/lib/                             | dafb7f9aef2f v4l2-controls: add a missing include                         |
|      -504 | arch/x86/lib/                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -504 | arch/x86/lib/                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -588 | arch/x86/lib/                             | b9bbbbfef991 media: vicodec: Change variable names                        |
|     -1612 | arch/x86/lib/                             | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|     -2116 | arch/x86/lib/                             | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|     -2116 | arch/x86/lib/                             | b03c2fb97adc media: add SECO cec driver                                   |
|     +2512 | drivers/clocksource/                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +2260 | drivers/clocksource/                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +2206 | drivers/clocksource/                      | dafb7f9aef2f v4l2-controls: add a missing include                         |
|     +2122 | drivers/clocksource/                      | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|      +228 | drivers/clocksource/                      | b9bbbbfef991 media: vicodec: Change variable names                        |
|      -138 | drivers/clocksource/                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -138 | drivers/clocksource/                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -2122 | drivers/clocksource/                      | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|     -2122 | drivers/clocksource/                      | b03c2fb97adc media: add SECO cec driver                                   |
|     -2374 | drivers/clocksource/                      | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|     +2411 | drivers/video                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +2411 | drivers/video                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -2411 | drivers/video                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -2411 | drivers/video                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +2373 | drivers/clk                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +2373 | drivers/clk                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -2373 | drivers/clk                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -2373 | drivers/clk                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +2088 | drivers/soc                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +2088 | drivers/soc                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -2088 | drivers/soc                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -2088 | drivers/soc                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1980 | include/config/arch/has                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1980 | include/config/arch/has                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1980 | include/config/arch/has                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1980 | include/config/arch/has                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1935 | usr/include/linux/cifs                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1935 | usr/include/linux/cifs                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1935 | usr/include/linux/cifs                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1935 | usr/include/linux/cifs                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1862 | usr/include/linux/sunrpc                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1862 | usr/include/linux/sunrpc                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1862 | usr/include/linux/sunrpc                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1862 | usr/include/linux/sunrpc                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1861 | drivers/misc                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1861 | drivers/misc                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1861 | drivers/misc                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1861 | drivers/misc                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1860 | drivers/video/fbdev                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1860 | drivers/video/fbdev                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1860 | drivers/video/fbdev                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1860 | drivers/video/fbdev                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1827 | drivers/media/platform                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1827 | drivers/media/platform                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1827 | drivers/media/platform                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1827 | drivers/media/platform                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1785 | drivers/media/common                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1785 | drivers/media/common                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1785 | drivers/media/common                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1785 | drivers/media/common                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1752 | arch/x86/entry/vsyscall/                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     +1612 | arch/x86/entry/vsyscall/                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1606 | arch/x86/entry/vsyscall/                  | dafb7f9aef2f v4l2-controls: add a missing include                         |
|      -146 | arch/x86/entry/vsyscall/                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -146 | arch/x86/entry/vsyscall/                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1606 | arch/x86/entry/vsyscall/                  | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|     +1669 | drivers/firmware                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1669 | drivers/firmware                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1669 | drivers/firmware                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1669 | drivers/firmware                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1500 | include/config/generic                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1500 | include/config/generic                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1500 | include/config/generic                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1500 | include/config/generic                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1281 | drivers/video/fbdev/omap2                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1281 | drivers/video/fbdev/omap2                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1281 | drivers/video/fbdev/omap2                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1281 | drivers/video/fbdev/omap2                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1140 | drivers/video/fbdev/core/                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1132 | drivers/video/fbdev/core/                 | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     -1132 | drivers/video/fbdev/core/                 | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|     -1132 | drivers/video/fbdev/core/                 | b03c2fb97adc media: add SECO cec driver                                   |
|     +1108 | generic_remap_file_range_prep()           | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|     +1067 | drivers/pci                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1067 | drivers/pci                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1067 | drivers/pci                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1067 | drivers/pci                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1020 | drivers/tty                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1020 | drivers/tty                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1020 | drivers/tty                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1020 | drivers/tty                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1012 | drivers/i2c                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1012 | drivers/i2c                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1012 | drivers/i2c                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1012 | drivers/i2c                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|     +1006 | fs/notify                                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     +1006 | fs/notify                                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|     -1006 | fs/notify                                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|     -1006 | fs/notify                                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +976 | net/                                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +968 | net/                                      | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|      -968 | net/                                      | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|      -968 | net/                                      | b03c2fb97adc media: add SECO cec driver                                   |
|      -968 | net/                                      | b9bbbbfef991 media: vicodec: Change variable names                        |
|      +974 | drivers/video/fbdev/omap2/omapfb          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +974 | drivers/video/fbdev/omap2/omapfb          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -974 | drivers/video/fbdev/omap2/omapfb          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -974 | drivers/video/fbdev/omap2/omapfb          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +940 | include/config/have/arch                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +940 | include/config/have/arch                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -940 | include/config/have/arch                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -940 | include/config/have/arch                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +920 | include/config/x86                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +920 | include/config/x86                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -920 | include/config/x86                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -920 | include/config/x86                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +875 | drivers/gpu/drm/omapdrm                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +875 | drivers/gpu/drm/omapdrm                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -875 | drivers/gpu/drm/omapdrm                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -875 | drivers/gpu/drm/omapdrm                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +866 | generic_remap_checks()                    | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|      +750 | drivers/nvme                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +750 | drivers/nvme                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -750 | drivers/nvme                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -750 | drivers/nvme                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +640 | include/config/cc                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +640 | include/config/cc                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -640 | include/config/cc                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -640 | include/config/cc                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +636 | arch/x86/kernel/apic/                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      +636 | arch/x86/kernel/apic/                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +498 | arch/x86/kernel/apic/                     | dafb7f9aef2f v4l2-controls: add a missing include                         |
|      +498 | arch/x86/kernel/apic/                     | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|      -138 | arch/x86/kernel/apic/                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -138 | arch/x86/kernel/apic/                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -498 | arch/x86/kernel/apic/                     | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|      -498 | arch/x86/kernel/apic/                     | b03c2fb97adc media: add SECO cec driver                                   |
|      -498 | arch/x86/kernel/apic/                     | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|      +600 | include/config/arch/want                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +600 | include/config/arch/want                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -600 | include/config/arch/want                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -600 | include/config/arch/want                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +600 | include/config/need                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +600 | include/config/need                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -600 | include/config/need                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -600 | include/config/need                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +559 | drivers/gpu/drm/bridge                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +559 | drivers/gpu/drm/bridge                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -559 | drivers/gpu/drm/bridge                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -559 | drivers/gpu/drm/bridge                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +550 | drivers/media/pci/intel                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +550 | drivers/media/pci/intel                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -550 | drivers/media/pci/intel                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -550 | drivers/media/pci/intel                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +539 | drivers/pci/controller                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +539 | drivers/pci/controller                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -539 | drivers/pci/controller                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -539 | drivers/pci/controller                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +532 | drivers/media/i2c                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +532 | drivers/media/i2c                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -532 | drivers/media/i2c                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -532 | drivers/media/i2c                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +513 | drivers/media/rc                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +513 | drivers/media/rc                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -513 | drivers/media/rc                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -513 | drivers/media/rc                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +512 | drivers/media/mmc                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +512 | drivers/media/mmc                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -512 | drivers/media/mmc                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -512 | drivers/media/mmc                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +500 | include/config/inline                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +500 | include/config/inline                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -500 | include/config/inline                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -500 | include/config/inline                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +497 | drivers/platform                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +497 | drivers/platform                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -497 | drivers/platform                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -497 | drivers/platform                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +497 | drivers/misc/mic                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +497 | drivers/misc/mic                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -497 | drivers/misc/mic                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -497 | drivers/misc/mic                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +462 | drivers/usb                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +462 | drivers/usb                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -462 | drivers/usb                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -462 | drivers/usb                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +462 | drivers/net                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +462 | drivers/net                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -462 | drivers/net                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -462 | drivers/net                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +440 | include/config/default                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +440 | include/config/default                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -440 | include/config/default                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -440 | include/config/default                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +420 | include/config/cpu                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +420 | include/config/cpu                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -420 | include/config/cpu                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -420 | include/config/cpu                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +413 | virt                                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +413 | virt                                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -413 | virt                                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -413 | virt                                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +400 | include/config/need/per                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +400 | include/config/need/per                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -400 | include/config/need/per                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -400 | include/config/need/per                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +380 | include/config/arch/mmap                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +380 | include/config/arch/mmap                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -380 | include/config/arch/mmap                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -380 | include/config/arch/mmap                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +360 | include/config/cpu/sup                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +360 | include/config/cpu/sup                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -360 | include/config/cpu/sup                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -360 | include/config/cpu/sup                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +360 | include/config/have/function              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +360 | include/config/have/function              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -360 | include/config/have/function              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -360 | include/config/have/function              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +340 | include/config/usb                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +340 | include/config/usb                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -340 | include/config/usb                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -340 | include/config/usb                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +340 | include/config/need/per/cpu               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +340 | include/config/need/per/cpu               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -340 | include/config/need/per/cpu               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -340 | include/config/need/per/cpu               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +340 | include/config/cc/has                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +340 | include/config/cc/has                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -340 | include/config/cc/has                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -340 | include/config/cc/has                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +320 | include/config/arch/supports              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +320 | include/config/arch/supports              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -320 | include/config/arch/supports              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -320 | include/config/arch/supports              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +320 | include/config/arch/mmap/rnd              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +320 | include/config/arch/mmap/rnd              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -320 | include/config/arch/mmap/rnd              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -320 | include/config/arch/mmap/rnd              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +307 | drivers/hwtracing                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +307 | drivers/hwtracing                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -307 | drivers/hwtracing                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -307 | drivers/hwtracing                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +300 | include/config/have/perf                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +300 | include/config/have/perf                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -300 | include/config/have/perf                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -300 | include/config/have/perf                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +298 | drivers/gpu/drm/amd                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +298 | drivers/gpu/drm/amd                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -298 | drivers/gpu/drm/amd                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -298 | drivers/gpu/drm/amd                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +292 | drivers/video/fbdev/omap2/omapfb/displays | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +292 | drivers/video/fbdev/omap2/omapfb/displays | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -292 | drivers/video/fbdev/omap2/omapfb/displays | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -292 | drivers/video/fbdev/omap2/omapfb/displays | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +286 | csum_and_copy_to_iter()                   | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|      +226 | csum_and_copy_to_iter()                   | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      +277 | drivers/video/fbdev/omap2/omapfb/dss      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +277 | drivers/video/fbdev/omap2/omapfb/dss      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -277 | drivers/video/fbdev/omap2/omapfb/dss      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -277 | drivers/video/fbdev/omap2/omapfb/dss      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +271 | drivers/media/platform/cros-ec-cec        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +271 | drivers/media/platform/cros-ec-cec        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -271 | drivers/media/platform/cros-ec-cec        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -271 | drivers/media/platform/cros-ec-cec        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +265 | drivers/gpu/drm/omapdrm/displays          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +265 | drivers/gpu/drm/omapdrm/displays          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -265 | drivers/gpu/drm/omapdrm/displays          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -265 | drivers/gpu/drm/omapdrm/displays          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +262 | drivers/gpu/drm/bridge/synopsys           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +262 | drivers/gpu/drm/bridge/synopsys           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -262 | drivers/gpu/drm/bridge/synopsys           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -262 | drivers/gpu/drm/bridge/synopsys           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +260 | include/config/io                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +260 | include/config/io                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -260 | include/config/io                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -260 | include/config/io                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +260 | include/config/modules                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +260 | include/config/modules                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -260 | include/config/modules                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -260 | include/config/modules                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +259 | drivers/media/usb/ttusb-budget            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +259 | drivers/media/usb/ttusb-budget            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -259 | drivers/media/usb/ttusb-budget            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -259 | drivers/media/usb/ttusb-budget            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +259 | drivers/media/platform/davinci            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +259 | drivers/media/platform/davinci            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -259 | drivers/media/platform/davinci            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -259 | drivers/media/platform/davinci            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +259 | drivers/media/pci/netup_unidvb            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +259 | drivers/media/pci/netup_unidvb            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -259 | drivers/media/pci/netup_unidvb            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -259 | drivers/media/pci/netup_unidvb            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +259 | drivers/media/common/videobuf2            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +259 | drivers/media/common/videobuf2            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -259 | drivers/media/common/videobuf2            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -259 | drivers/media/common/videobuf2            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +256 | init.data                                 | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      +256 | drivers/hsi/                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      -256 | drivers/hsi/                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +256 | drivers/media/common/v4l2-tpg             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +256 | drivers/media/common/v4l2-tpg             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -256 | drivers/media/common/v4l2-tpg             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -256 | drivers/media/common/v4l2-tpg             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +256 | arch/x86/platform/intel-quark             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +256 | arch/x86/platform/intel-quark             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -256 | arch/x86/platform/intel-quark             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -256 | arch/x86/platform/intel-quark             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +253 | drivers/media/usb/dvb-usb-v2              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +253 | drivers/media/usb/dvb-usb-v2              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -253 | drivers/media/usb/dvb-usb-v2              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -253 | drivers/media/usb/dvb-usb-v2              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +253 | drivers/media/platform/stm32              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +253 | drivers/media/platform/stm32              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -253 | drivers/media/platform/stm32              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -253 | drivers/media/platform/stm32              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +253 | drivers/media/platform/meson              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +253 | drivers/media/platform/meson              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -253 | drivers/media/platform/meson              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -253 | drivers/media/platform/meson              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +253 | drivers/media/pci/intel/ipu3              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +253 | drivers/media/pci/intel/ipu3              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -253 | drivers/media/pci/intel/ipu3              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -253 | drivers/media/pci/intel/ipu3              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +253 | drivers/media/i2c/soc_camera              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +253 | drivers/media/i2c/soc_camera              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -253 | drivers/media/i2c/soc_camera              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -253 | drivers/media/i2c/soc_camera              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +253 | drivers/media/common/saa7146              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +253 | drivers/media/common/saa7146              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -253 | drivers/media/common/saa7146              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -253 | drivers/media/common/saa7146              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +250 | drivers/media/usb/ttusb-dec               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +250 | drivers/media/usb/ttusb-dec               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -250 | drivers/media/usb/ttusb-dec               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -250 | drivers/media/usb/ttusb-dec               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +250 | drivers/media/usb/stkwebcam               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +250 | drivers/media/usb/stkwebcam               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -250 | drivers/media/usb/stkwebcam               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -250 | drivers/media/usb/stkwebcam               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +250 | drivers/media/platform/omap               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +250 | drivers/media/platform/omap               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -250 | drivers/media/platform/omap               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -250 | drivers/media/platform/omap               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +250 | drivers/gpu/drm/omapdrm/dss               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +250 | drivers/gpu/drm/omapdrm/dss               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -250 | drivers/gpu/drm/omapdrm/dss               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -250 | drivers/gpu/drm/omapdrm/dss               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +250 | arch/x86/platform/intel-mid               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +250 | arch/x86/platform/intel-mid               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -250 | arch/x86/platform/intel-mid               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -250 | arch/x86/platform/intel-mid               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +247 | drivers/pci/controller/dwc                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +247 | drivers/pci/controller/dwc                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -247 | drivers/pci/controller/dwc                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -247 | drivers/pci/controller/dwc                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +247 | drivers/media/pci/ddbridge                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +247 | drivers/media/pci/ddbridge                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -247 | drivers/media/pci/ddbridge                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -247 | drivers/media/pci/ddbridge                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +247 | drivers/media/common/siano                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +247 | drivers/media/common/siano                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -247 | drivers/media/common/siano                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -247 | drivers/media/common/siano                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +247 | drivers/hwtracing/intel_th                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +247 | drivers/hwtracing/intel_th                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -247 | drivers/hwtracing/intel_th                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -247 | drivers/hwtracing/intel_th                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +247 | arch/x86/platform/goldfish                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +247 | arch/x86/platform/goldfish                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -247 | arch/x86/platform/goldfish                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -247 | arch/x86/platform/goldfish                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +244 | drivers/media/usb/zr364xx                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +244 | drivers/media/usb/zr364xx                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -244 | drivers/media/usb/zr364xx                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -244 | drivers/media/usb/zr364xx                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +244 | drivers/media/usb/dvb-usb                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +244 | drivers/media/usb/dvb-usb                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -244 | drivers/media/usb/dvb-usb                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -244 | drivers/media/usb/dvb-usb                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +244 | drivers/media/pci/smipcie                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +244 | drivers/media/pci/smipcie                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -244 | drivers/media/pci/smipcie                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -244 | drivers/media/pci/smipcie                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +244 | drivers/media/pci/saa7146                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +244 | drivers/media/pci/saa7146                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -244 | drivers/media/pci/saa7146                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -244 | drivers/media/pci/saa7146                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +244 | drivers/media/common/b2c2                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +244 | drivers/media/common/b2c2                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -244 | drivers/media/common/b2c2                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -244 | drivers/media/common/b2c2                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +244 | drivers/gpu/drm/hisilicon                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +244 | drivers/gpu/drm/hisilicon                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -244 | drivers/gpu/drm/hisilicon                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -244 | drivers/gpu/drm/hisilicon                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +244 | drivers/firmware/broadcom                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +244 | drivers/firmware/broadcom                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -244 | drivers/firmware/broadcom                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -244 | drivers/firmware/broadcom                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +241 | drivers/video/fbdev/core                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +241 | drivers/video/fbdev/core                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -241 | drivers/video/fbdev/core                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -241 | drivers/video/fbdev/core                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +241 | drivers/media/rc/keymaps                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +241 | drivers/media/rc/keymaps                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -241 | drivers/media/rc/keymaps                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -241 | drivers/media/rc/keymaps                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +241 | drivers/media/pci/pluto2                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +241 | drivers/media/pci/pluto2                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -241 | drivers/media/pci/pluto2                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -241 | drivers/media/pci/pluto2                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +241 | drivers/media/pci/mantis                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +241 | drivers/media/pci/mantis                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -241 | drivers/media/pci/mantis                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -241 | drivers/media/pci/mantis                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +241 | drivers/media/pci/dm1105                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +241 | drivers/media/pci/dm1105                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -241 | drivers/media/pci/dm1105                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -241 | drivers/media/pci/dm1105                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +241 | arch/x86/platform/scx200                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +241 | arch/x86/platform/scx200                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -241 | arch/x86/platform/scx200                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -241 | arch/x86/platform/scx200                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +241 | arch/x86/platform/ts5500                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +241 | arch/x86/platform/ts5500                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -241 | arch/x86/platform/ts5500                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -241 | arch/x86/platform/ts5500                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +241 | arch/x86/platform/ce4100                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +241 | arch/x86/platform/ce4100                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -241 | arch/x86/platform/ce4100                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -241 | arch/x86/platform/ce4100                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +240 | include/config/nr                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +240 | include/config/nr                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -240 | include/config/nr                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -240 | include/config/nr                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +240 | include/config/have/regs                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +240 | include/config/have/regs                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -240 | include/config/have/regs                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -240 | include/config/have/regs                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | drivers/video/backlight                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | drivers/video/backlight                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | drivers/video/backlight                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | drivers/video/backlight                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | drivers/media/usb/s2255                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | drivers/media/usb/s2255                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | drivers/media/usb/s2255                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | drivers/media/usb/s2255                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | drivers/media/usb/siano                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | drivers/media/usb/siano                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | drivers/media/usb/siano                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | drivers/media/usb/siano                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | drivers/media/pci/ttpci                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | drivers/media/pci/ttpci                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | drivers/media/pci/ttpci                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | drivers/media/pci/ttpci                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | drivers/media/pci/ngene                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | drivers/media/pci/ngene                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | drivers/media/pci/ngene                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | drivers/media/pci/ngene                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | drivers/media/mmc/siano                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | drivers/media/mmc/siano                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | drivers/media/mmc/siano                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | drivers/media/mmc/siano                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | drivers/gpu/drm/amd/lib                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | drivers/gpu/drm/amd/lib                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | drivers/gpu/drm/amd/lib                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | drivers/gpu/drm/amd/lib                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | drivers/firmware/xilinx                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | drivers/firmware/xilinx                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | drivers/firmware/xilinx                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | drivers/firmware/xilinx                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | arch/x86/platform/geode                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | arch/x86/platform/geode                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | arch/x86/platform/geode                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | arch/x86/platform/geode                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | arch/x86/platform/intel                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | arch/x86/platform/intel                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | arch/x86/platform/intel                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | arch/x86/platform/intel                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +238 | arch/x86/kernel/kprobes                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +238 | arch/x86/kernel/kprobes                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -238 | arch/x86/kernel/kprobes                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -238 | arch/x86/kernel/kprobes                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | drivers/tty/ipwireless                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | drivers/tty/ipwireless                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | drivers/tty/ipwireless                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | drivers/tty/ipwireless                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | drivers/misc/lis3lv02d                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | drivers/misc/lis3lv02d                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | drivers/misc/lis3lv02d                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | drivers/misc/lis3lv02d                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | drivers/media/usb/b2c2                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | drivers/media/usb/b2c2                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | drivers/media/usb/b2c2                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | drivers/media/usb/b2c2                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | drivers/media/pci/b2c2                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | drivers/media/pci/b2c2                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | drivers/media/pci/b2c2                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | drivers/media/pci/b2c2                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | drivers/media/firewire                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | drivers/media/firewire                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | drivers/media/firewire                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | drivers/media/firewire                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | drivers/gpu/drm/tilcdc                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | drivers/gpu/drm/tilcdc                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | drivers/gpu/drm/tilcdc                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | drivers/gpu/drm/tilcdc                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | drivers/firmware/tegra                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | drivers/firmware/tegra                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | drivers/firmware/tegra                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | drivers/firmware/tegra                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | drivers/firmware/meson                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | drivers/firmware/meson                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | drivers/firmware/meson                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | drivers/firmware/meson                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | arch/x86/platform/olpc                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | arch/x86/platform/olpc                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | arch/x86/platform/olpc                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | arch/x86/platform/olpc                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | arch/x86/platform/iris                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | arch/x86/platform/iris                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | arch/x86/platform/iris                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | arch/x86/platform/iris                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +235 | arch/x86/platform/atom                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +235 | arch/x86/platform/atom                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -235 | arch/x86/platform/atom                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -235 | arch/x86/platform/atom                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +232 | drivers/media/pci/pt1                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +232 | drivers/media/pci/pt1                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -232 | drivers/media/pci/pt1                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -232 | drivers/media/pci/pt1                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +232 | drivers/media/pci/pt3                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +232 | drivers/media/pci/pt3                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -232 | drivers/media/pci/pt3                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -232 | drivers/media/pci/pt3                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +232 | drivers/gpu/drm/panel                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +232 | drivers/gpu/drm/panel                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -232 | drivers/gpu/drm/panel                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -232 | drivers/gpu/drm/panel                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +232 | arch/x86/platform/sfi                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +232 | arch/x86/platform/sfi                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -232 | arch/x86/platform/sfi                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -232 | arch/x86/platform/sfi                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +232 | arch/x86/platform/efi                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +232 | arch/x86/platform/efi                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -232 | arch/x86/platform/efi                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -232 | arch/x86/platform/efi                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +229 | drivers/soc/mediatek                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +229 | drivers/soc/mediatek                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -229 | drivers/soc/mediatek                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -229 | drivers/soc/mediatek                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +229 | drivers/platform/x86                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +229 | drivers/platform/x86                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -229 | drivers/platform/x86                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -229 | drivers/platform/x86                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +229 | drivers/misc/mic/bus                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +229 | drivers/misc/mic/bus                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -229 | drivers/misc/mic/bus                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -229 | drivers/misc/mic/bus                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +229 | drivers/media/tuners                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +229 | drivers/media/tuners                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -229 | drivers/media/tuners                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -229 | drivers/media/tuners                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +229 | drivers/firmware/imx                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +229 | drivers/firmware/imx                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -229 | drivers/firmware/imx                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -229 | drivers/firmware/imx                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +229 | drivers/clk/mediatek                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +229 | drivers/clk/mediatek                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -229 | drivers/clk/mediatek                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -229 | drivers/clk/mediatek                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +229 | arch/x86/platform/uv                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +229 | arch/x86/platform/uv                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -229 | arch/x86/platform/uv                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -229 | arch/x86/platform/uv                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +229 | arch/x86/kernel/acpi                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +229 | arch/x86/kernel/acpi                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -229 | arch/x86/kernel/acpi                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -229 | arch/x86/kernel/acpi                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +226 | drivers/soc/renesas                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +226 | drivers/soc/renesas                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -226 | drivers/soc/renesas                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -226 | drivers/soc/renesas                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +226 | drivers/nvme/target                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +226 | drivers/nvme/target                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -226 | drivers/nvme/target                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -226 | drivers/nvme/target                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +226 | drivers/misc/eeprom                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +226 | drivers/misc/eeprom                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -226 | drivers/misc/eeprom                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -226 | drivers/misc/eeprom                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +226 | drivers/gpu/drm/i2c                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +226 | drivers/gpu/drm/i2c                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -226 | drivers/gpu/drm/i2c                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -226 | drivers/gpu/drm/i2c                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +226 | drivers/clk/renesas                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +226 | drivers/clk/renesas                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -226 | drivers/clk/renesas                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -226 | drivers/clk/renesas                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +226 | drivers/clk/ingenic                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +226 | drivers/clk/ingenic                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -226 | drivers/clk/ingenic                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -226 | drivers/clk/ingenic                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +226 | drivers/clk/actions                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +226 | drivers/clk/actions                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -226 | drivers/clk/actions                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -226 | drivers/clk/actions                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +223 | drivers/soc/xilinx                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +223 | drivers/soc/xilinx                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -223 | drivers/soc/xilinx                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -223 | drivers/soc/xilinx                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +223 | drivers/tty/serial                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +223 | drivers/tty/serial                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -223 | drivers/tty/serial                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -223 | drivers/tty/serial                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +223 | drivers/pci/switch                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +223 | drivers/pci/switch                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -223 | drivers/pci/switch                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -223 | drivers/pci/switch                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +223 | drivers/misc/ti-st                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +223 | drivers/misc/ti-st                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -223 | drivers/misc/ti-st                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -223 | drivers/misc/ti-st                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +223 | drivers/misc/cb710                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +223 | drivers/misc/cb710                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -223 | drivers/misc/cb710                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -223 | drivers/misc/cb710                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +223 | drivers/i2c/busses                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +223 | drivers/i2c/busses                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -223 | drivers/i2c/busses                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -223 | drivers/i2c/busses                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +223 | drivers/clk/imgtec                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +223 | drivers/clk/imgtec                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -223 | drivers/clk/imgtec                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -223 | drivers/clk/imgtec                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +223 | drivers/base/power                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +223 | drivers/base/power                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -223 | drivers/base/power                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -223 | drivers/base/power                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +223 | drivers/auxdisplay                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +223 | drivers/auxdisplay                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -223 | drivers/auxdisplay                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -223 | drivers/auxdisplay                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +223 | fs/notify/fanotify                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +223 | fs/notify/fanotify                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -223 | fs/notify/fanotify                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -223 | fs/notify/fanotify                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | drivers/soc/sunxi                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | drivers/soc/sunxi                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | drivers/soc/sunxi                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | drivers/soc/sunxi                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | drivers/nvme/host                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | drivers/nvme/host                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | drivers/nvme/host                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | drivers/nvme/host                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | drivers/macintosh                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | drivers/macintosh                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | drivers/macintosh                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | drivers/macintosh                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | drivers/media/spi                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | drivers/media/spi                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | drivers/media/spi                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | drivers/media/spi                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | drivers/i2c/muxes                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | drivers/i2c/muxes                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | drivers/i2c/muxes                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | drivers/i2c/muxes                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | drivers/i2c/algos                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | drivers/i2c/algos                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | drivers/i2c/algos                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | drivers/i2c/algos                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | drivers/clk/mvebu                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | drivers/clk/mvebu                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | drivers/clk/mvebu                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | drivers/clk/mvebu                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | drivers/char/ipmi                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | drivers/char/ipmi                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | drivers/char/ipmi                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | drivers/char/ipmi                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | drivers/base/test                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | drivers/base/test                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | drivers/base/test                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | drivers/base/test                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | fs/notify/inotify                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | fs/notify/inotify                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | fs/notify/inotify                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | fs/notify/inotify                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | fs/notify/dnotify                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | fs/notify/dnotify                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | fs/notify/dnotify                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | fs/notify/dnotify                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +220 | include/config/arch/use                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +220 | include/config/arch/use                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -220 | include/config/arch/use                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -220 | include/config/arch/use                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +217 | drivers/soc/qcom                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +217 | drivers/soc/qcom                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -217 | drivers/soc/qcom                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -217 | drivers/soc/qcom                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +217 | drivers/firewire                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +217 | drivers/firewire                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -217 | drivers/firewire                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -217 | drivers/firewire                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +217 | drivers/char/agp                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +217 | drivers/char/agp                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -217 | drivers/char/agp                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -217 | drivers/char/agp                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +217 | kernel/livepatch                          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +217 | kernel/livepatch                          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -217 | kernel/livepatch                          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -217 | kernel/livepatch                          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +217 | include/generated/uapi                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +217 | include/generated/uapi                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -217 | include/generated/uapi                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -217 | include/generated/uapi                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +214 | drivers/usb/phy                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +214 | drivers/usb/phy                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -214 | drivers/usb/phy                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -214 | drivers/usb/phy                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +214 | drivers/soc/fsl                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +214 | drivers/soc/fsl                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -214 | drivers/soc/fsl                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -214 | drivers/soc/fsl                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +214 | drivers/soc/bcm                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +214 | drivers/soc/bcm                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -214 | drivers/soc/bcm                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -214 | drivers/soc/bcm                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +214 | drivers/net/phy                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +214 | drivers/net/phy                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -214 | drivers/net/phy                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -214 | drivers/net/phy                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +214 | drivers/irqchip                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +214 | drivers/irqchip                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -214 | drivers/irqchip                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -214 | drivers/irqchip                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +214 | drivers/gpu/vga                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +214 | drivers/gpu/vga                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -214 | drivers/gpu/vga                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -214 | drivers/gpu/vga                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +214 | drivers/clk/bcm                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +214 | drivers/clk/bcm                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -214 | drivers/clk/bcm                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -214 | drivers/clk/bcm                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +214 | arch/x86/crypto                           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +214 | arch/x86/crypto                           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -214 | arch/x86/crypto                           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -214 | arch/x86/crypto                           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +211 | drivers/tty/vt                            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +211 | drivers/tty/vt                            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -211 | drivers/tty/vt                            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -211 | drivers/tty/vt                            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +211 | drivers/clk/ti                            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +211 | drivers/clk/ti                            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -211 | drivers/clk/ti                            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -211 | drivers/clk/ti                            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +208 | drivers/power                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +208 | drivers/power                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -208 | drivers/power                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -208 | drivers/power                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +208 | drivers/cdrom                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +208 | drivers/cdrom                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -208 | drivers/cdrom                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -208 | drivers/cdrom                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +208 | drivers/block                             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +208 | drivers/block                             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -208 | drivers/block                             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -208 | drivers/block                             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +206 | arch/x86/events/amd/                      | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|      -206 | arch/x86/events/amd/                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -206 | arch/x86/events/amd/                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      +205 | drivers/scsi                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +205 | drivers/scsi                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -205 | drivers/scsi                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -205 | drivers/scsi                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +205 | drivers/perf                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +205 | drivers/perf                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -205 | drivers/perf                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -205 | drivers/perf                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +205 | drivers/idle                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +205 | drivers/idle                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -205 | drivers/idle                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -205 | drivers/idle                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +205 | drivers/amba                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +205 | drivers/amba                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -205 | drivers/amba                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -205 | drivers/amba                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +205 | arch/x86/net                              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +205 | arch/x86/net                              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -205 | arch/x86/net                              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -205 | arch/x86/net                              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +202 | drivers/i3c                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      -202 | drivers/i3c                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      +202 | drivers/pwm                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +202 | drivers/pwm                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -202 | drivers/pwm                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -202 | drivers/pwm                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +202 | drivers/ptp                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +202 | drivers/ptp                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -202 | drivers/ptp                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -202 | drivers/ptp                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +202 | drivers/nfc                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +202 | drivers/nfc                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -202 | drivers/nfc                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -202 | drivers/nfc                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +202 | drivers/mmc                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +202 | drivers/mmc                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -202 | drivers/mmc                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -202 | drivers/mmc                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +202 | drivers/mfd                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +202 | drivers/mfd                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -202 | drivers/mfd                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -202 | drivers/mfd                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +202 | drivers/bus                               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +202 | drivers/bus                               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -202 | drivers/bus                               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -202 | drivers/bus                               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +200 | include/config/panic                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +200 | include/config/panic                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -200 | include/config/panic                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -200 | include/config/panic                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +200 | include/config/clocksource                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +200 | include/config/clocksource                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -200 | include/config/clocksource                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -200 | include/config/clocksource                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +200 | include/config/io/delay                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +200 | include/config/io/delay                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -200 | include/config/io/delay                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -200 | include/config/io/delay                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +200 | include/config/arch/might                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +200 | include/config/arch/might                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -200 | include/config/arch/might                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -200 | include/config/arch/might                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +200 | include/config/arch/has/strict            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +200 | include/config/arch/has/strict            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -200 | include/config/arch/has/strict            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -200 | include/config/arch/has/strict            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +200 | include/config/have/dynamic               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +200 | include/config/have/dynamic               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -200 | include/config/have/dynamic               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -200 | include/config/have/dynamic               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +196 | fs/devpts                                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +196 | fs/devpts                                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -196 | fs/devpts                                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -196 | fs/devpts                                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +193 | generic_write_check_limits()              | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|      +193 | virt/lib                                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +193 | virt/lib                                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -193 | virt/lib                                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -193 | virt/lib                                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +193 | firmware                                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +193 | firmware                                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -193 | firmware                                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -193 | firmware                                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +193 | fs/quota                                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +193 | fs/quota                                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -193 | fs/quota                                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -193 | fs/quota                                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +193 | fs/exofs                                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +193 | fs/exofs                                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -193 | fs/exofs                                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -193 | fs/exofs                                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +192 | check_bugs()                              | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      +187 | crypto                                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +187 | crypto                                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -187 | crypto                                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -187 | crypto                                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +184 | sound                                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +184 | sound                                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -184 | sound                                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -184 | sound                                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +184 | block                                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +184 | block                                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -184 | block                                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -184 | block                                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +184 | certs                                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +184 | certs                                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -184 | certs                                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -184 | certs                                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +182 | altinstructions                           | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      +180 | include/config/flat                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/flat                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/flat                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/flat                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +180 | include/config/arm                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/arm                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/arm                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/arm                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +180 | include/config/thread                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/thread                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/thread                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/thread                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +180 | include/config/init                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/init                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/init                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/init                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +180 | include/config/arch/may                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/arch/may                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/arch/may                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/arch/may                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +180 | include/config/arch/wants                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/arch/wants                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/arch/wants                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/arch/wants                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +180 | include/config/arch/have                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/arch/have                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/arch/have                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/arch/have                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +180 | include/config/arch/want/batched          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/arch/want/batched          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/arch/want/batched          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/arch/want/batched          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +180 | include/config/arch/has/sync              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/arch/has/sync              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/arch/has/sync              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/arch/has/sync              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +180 | include/config/have/regs/and              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/have/regs/and              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/have/regs/and              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/have/regs/and              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +180 | include/config/have/setup                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +180 | include/config/have/setup                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -180 | include/config/have/setup                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -180 | include/config/have/setup                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +178 | net                                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +178 | net                                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -178 | net                                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -178 | net                                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +178 | ipc                                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +178 | ipc                                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -178 | ipc                                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -178 | ipc                                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +160 | include/config/has                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +160 | include/config/has                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -160 | include/config/has                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -160 | include/config/has                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +160 | include/config/nr/cpus                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +160 | include/config/nr/cpus                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -160 | include/config/nr/cpus                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -160 | include/config/nr/cpus                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +160 | include/config/generic/irq                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +160 | include/config/generic/irq                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -160 | include/config/generic/irq                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -160 | include/config/generic/irq                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +160 | include/config/have/kernel                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +160 | include/config/have/kernel                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -160 | include/config/have/kernel                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -160 | include/config/have/kernel                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +157 | include/generated/uapi/linux              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +157 | include/generated/uapi/linux              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -157 | include/generated/uapi/linux              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -157 | include/generated/uapi/linux              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +148 | init.text                                 | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      +145 | __switch_to_xtra()                        | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      +142 | arch/i386                                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +142 | arch/i386                                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -142 | arch/i386                                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -142 | arch/i386                                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/edac                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/edac                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/edac                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/edac                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/rtc                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/rtc                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/rtc                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/rtc                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/unwinder                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/unwinder                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/unwinder                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/unwinder                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/console                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/console                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/console                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/console                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/irq                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/irq                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/irq                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/irq                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/inline/read                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/inline/read                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/inline/read                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/inline/read                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/inline/write               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/inline/write               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/inline/write               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/inline/write               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/arch/might/have            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/arch/might/have            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/arch/might/have            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/arch/might/have            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/arch/mmap/rnd/compat       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/arch/mmap/rnd/compat       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/arch/mmap/rnd/compat       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/arch/mmap/rnd/compat       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/cc/optimize                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/cc/optimize                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/cc/optimize                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/cc/optimize                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/have/generic               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/have/generic               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/have/generic               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/have/generic               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +140 | include/config/have/arch/jump             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +140 | include/config/have/arch/jump             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -140 | include/config/have/arch/jump             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -140 | include/config/have/arch/jump             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +126 | altinstr_aux                              | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      +120 | include/config/message                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/message                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/message                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/message                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/dcache                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/dcache                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/dcache                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/dcache                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/sysctl                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/sysctl                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/sysctl                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/sysctl                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/flat/node                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/flat/node                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/flat/node                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/flat/node                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arm/gic                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arm/gic                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arm/gic                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arm/gic                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/thread/info                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/thread/info                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/thread/info                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/thread/info                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/dma                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/dma                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/dma                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/dma                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/isa                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/isa                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/isa                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/isa                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/oprofile                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/oprofile                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/oprofile                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/oprofile                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/lock                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/lock                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/lock                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/lock                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/pci                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/pci                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/pci                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/pci                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/buildtime                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/buildtime                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/buildtime                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/buildtime                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/panic/on                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/panic/on                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/panic/on                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/panic/on                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/illegal                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/illegal                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/illegal                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/illegal                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/tick                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/tick                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/tick                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/tick                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/virt                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/virt                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/virt                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/virt                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/user                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/user                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/user                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/user                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/broken                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/broken                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/broken                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/broken                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/clocksource/validate       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/clocksource/validate       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/clocksource/validate       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/clocksource/validate       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/trace                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/trace                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/trace                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/trace                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/rwsem                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/rwsem                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/rwsem                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/rwsem                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/select                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/select                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/select                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/select                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/split                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/split                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/split                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/split                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/strict                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/strict                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/strict                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/strict                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/init/env                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/init/env                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/init/env                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/init/env                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/io/delay/type              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/io/delay/type              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/io/delay/type              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/io/delay/type              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/modules/use                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/modules/use                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/modules/use                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/modules/use                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/default/io                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/default/io                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/default/io                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/default/io                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/default/mmap               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/default/mmap               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/default/mmap               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/default/mmap               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/generic/clockevents        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/generic/clockevents        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/generic/clockevents        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/generic/clockevents        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/generic/strncpy            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/generic/strncpy            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/generic/strncpy            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/generic/strncpy            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/generic/find               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/generic/find               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/generic/find               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/generic/find               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/generic/smp                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/generic/smp                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/generic/smp                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/generic/smp                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/usb/arch                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/usb/arch                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/usb/arch                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/usb/arch                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/usb/ohci                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/usb/ohci                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/usb/ohci                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/usb/ohci                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/inline/spin                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/inline/spin                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/inline/spin                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/inline/spin                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/x86/l1                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/x86/l1                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/x86/l1                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/x86/l1                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/x86/use                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/x86/use                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/x86/use                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/x86/use                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/x86/32                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/x86/32                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/x86/32                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/x86/32                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/x86/internode              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/x86/internode              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/x86/internode              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/x86/internode              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/x86/minimum                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/x86/minimum                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/x86/minimum                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/x86/minimum                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/fix                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/fix                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/fix                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/fix                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/may/have              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/may/have              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/may/have              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/may/have              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/enable                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/enable                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/enable                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/enable                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/wants/dynamic         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/wants/dynamic         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/wants/dynamic         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/wants/dynamic         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/select                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/select                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/select                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/select                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/have/nmi              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/have/nmi              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/have/nmi              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/have/nmi              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/want/huge             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/want/huge             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/want/huge             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/want/huge             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/want/batched/unmap    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/want/batched/unmap    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/want/batched/unmap    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/want/batched/unmap    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/want/ipc              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/want/ipc              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/want/ipc              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/want/ipc              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/has/gcov              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/has/gcov              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/has/gcov              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/has/gcov              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/has/cache             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/has/cache             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/has/cache             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/has/cache             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/has/sync/core         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/has/sync/core         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/has/sync/core         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/has/sync/core         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/has/membarrier        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/has/membarrier        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/has/membarrier        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/has/membarrier        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/has/ubsan             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/has/ubsan             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/has/ubsan             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/has/ubsan             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/arch/has/devmem            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/arch/has/devmem            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/arch/has/devmem            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/arch/has/devmem            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/need/sg                    | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/need/sg                    | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/need/sg                    | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/need/sg                    | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/need/per/cpu/page          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/need/per/cpu/page          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/need/per/cpu/page          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/need/per/cpu/page          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/need/per/cpu/embed         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/need/per/cpu/embed         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/need/per/cpu/embed         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/need/per/cpu/embed         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/cc/has/sancov              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/cc/has/sancov              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/cc/has/sancov              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/cc/has/sancov              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/efficient             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/efficient             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/efficient             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/efficient             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/mod                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/mod                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/mod                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/mod                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/mixed                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/mixed                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/mixed                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/mixed                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/aligned               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/aligned               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/aligned               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/aligned               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/user                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/user                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/user                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/user                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/ftrace                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/ftrace                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/ftrace                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/ftrace                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/hardened              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/hardened              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/hardened              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/hardened              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/hardlockup            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/hardlockup            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/hardlockup            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/hardlockup            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/unstable              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/unstable              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/unstable              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/unstable              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/memblock              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/memblock              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/memblock              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/memblock              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/perf/user             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/perf/user             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/perf/user             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/perf/user             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/regs/and/stack        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/regs/and/stack        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/regs/and/stack        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/regs/and/stack        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/dynamic/ftrace        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/dynamic/ftrace        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/dynamic/ftrace        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/dynamic/ftrace        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/kprobes               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/kprobes               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/kprobes               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/kprobes               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/setup/per             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/setup/per             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/setup/per             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/setup/per             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/function/arg          | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/function/arg          | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/function/arg          | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/function/arg          | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/irq                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/irq                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/irq                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/irq                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/copy                  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/copy                  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/copy                  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/copy                  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/arch/thread           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/arch/thread           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/arch/thread           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/arch/thread           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/arch/within           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/arch/within           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/arch/within           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/arch/within           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +120 | include/config/have/arch/mmap             | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|      +120 | include/config/have/arch/mmap             | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|      -120 | include/config/have/arch/mmap             | a2717eae73ac media: seco-cec: declare ops as static const                 |
|      -120 | include/config/have/arch/mmap             | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|      +115 | speculation_ctrl_update()                 | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      +112 | __xa_reserve()                            | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|       +87 | arch_prctl_spec_ctrl_get()                | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|       +87 | csum_and_copy_from_iter()                 | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|       +84 | v2_user_options()                         | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|       +82 | arch/i386/boot                            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +82 | arch/i386/boot                            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -82 | arch/i386/boot                            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -82 | arch/i386/boot                            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +81 | intel_pmu_bts_config()                    | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|       +80 | arch_prctl_spec_ctrl_set()                | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|       +80 | include/config/physical                   | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/physical                   | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/physical                   | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/physical                   | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/frame                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/frame                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/frame                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/frame                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/tiny                       | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/tiny                       | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/tiny                       | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/tiny                       | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/hz                         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/hz                         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/hz                         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/hz                         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/console/loglevel           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/console/loglevel           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/console/loglevel           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/console/loglevel           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/nr/cpus/range              | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/nr/cpus/range              | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/nr/cpus/range              | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/nr/cpus/range              | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/old                        | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/old                        | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/old                        | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/old                        | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/generic/cpu                | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/generic/cpu                | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/generic/cpu                | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/generic/cpu                | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/arch/might/have/pc         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/arch/might/have/pc         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/arch/might/have/pc         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/arch/might/have/pc         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/arch/use/queued            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/arch/use/queued            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/arch/use/queued            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/arch/use/queued            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/arch/clocksource           | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/arch/clocksource           | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/arch/clocksource           | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/arch/clocksource           | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/arch/mmap/rnd/bits         | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/arch/mmap/rnd/bits         | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/arch/mmap/rnd/bits         | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/arch/mmap/rnd/bits         | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/arch/mmap/rnd/compat/bits  | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/arch/mmap/rnd/compat/bits  | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/arch/mmap/rnd/compat/bits  | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/arch/mmap/rnd/compat/bits  | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/cc/optimize/for            | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/cc/optimize/for            | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/cc/optimize/for            | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/cc/optimize/for            | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/kernel                     | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/kernel                     | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/kernel                     | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/kernel                     | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/have/debug                 | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/have/debug                 | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/have/debug                 | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/have/debug                 | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +80 | include/config/have/cmpxchg               | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|       +80 | include/config/have/cmpxchg               | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|       -80 | include/config/have/cmpxchg               | a2717eae73ac media: seco-cec: declare ops as static const                 |
|       -80 | include/config/have/cmpxchg               | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|       +79 | vfs_dedupe_file_range_one()               | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|       +72 | mitigation_options()                      | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|       +67 | intel_pmu_has_bts()                       | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|       -72 | mitigation_options                        | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|       -73 | x86_verify_bootdata_version()             | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|       -76 | lib/                                      | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|    +55168 | lib/                                      | a2717eae73ac media: seco-cec: declare ops as static const                 |
|    +51916 | lib/                                      | dafb7f9aef2f v4l2-controls: add a missing include                         |
|    +40452 | lib/                                      | 811496c9679a media: uvcvideo: Refactor URB descriptors                    |
|    +37284 | lib/                                      | 5b79da06f74e media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE             |
|     +9952 | lib/                                      | b9bbbbfef991 media: vicodec: Change variable names                        |
|     -3168 | lib/                                      | c764da98a600 media: video-i2c: avoid accessing released memory area when  |
|     -3168 | lib/                                      | 9b90dc85c718 media: seco-cec: add missing header file to fix build        |
|    -37244 | lib/                                      | b50b769bcbc2 media: dm365_ipipeif: better annotate a fall though          |
|    -37284 | lib/                                      | b03c2fb97adc media: add SECO cec driver                                   |
|    -52000 | lib/                                      | 6748c1cfd253 media: venus: add support for USERPTR to queue               |
|       -95 | speculative_store_bypass_update()         | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|       -98 | x86_setup_perfctr()                       | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      -115 | xa_store()                                | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      -153 | xa_cmpxchg()                              | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      -154 | xa_reserve()                              | 14a4467a0a5e Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into |
|      -159 | generic_write_checks()                    | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|      -447 | vfs_dedupe_file_range_compare()           | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
|      -930 | vfs_clone_file_prep_inodes()              | b3491d8430dd..3c28b91380dd (ALL COMMITS)                                  |
+-----------+-------------------------------------------+---------------------------------------------------------------------------+

elapsed time: 757m

configs tested: 366

The following configs have been built successfully.
More configs may be tested in the coming days.

alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
arm                  colibri_pxa300_defconfig
powerpc                        fsp2_defconfig
m68k                        stmark2_defconfig
openrisc                         alldefconfig
arm                          simpad_defconfig
mips                          ath25_defconfig
powerpc                 mpc834x_itx_defconfig
powerpc                 mpc834x_mds_defconfig
arm64                               defconfig
powerpc                     ksi8560_defconfig
mips                malta_kvm_guest_defconfig
sparc                               defconfig
mips                        bcm63xx_defconfig
nios2                         10m50_defconfig
x86_64                 randconfig-a0-12060727
x86_64                 randconfig-a0-12061551
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
arm                              allyesconfig
xtensa                       common_defconfig
powerpc                          g5_defconfig
sh                   sh7724_generic_defconfig
i386                             allmodconfig
mips                        generic_defconfig
arm64                            allyesconfig
powerpc                      bamboo_defconfig
arm                          collie_defconfig
powerpc                 canyonlands_defconfig
arm                             mxs_defconfig
parisc                generic-32bit_defconfig
powerpc                 mpc832x_rdb_defconfig
i386                 randconfig-x010-12051023
i386                 randconfig-x011-12051023
i386                 randconfig-x012-12051023
i386                 randconfig-x013-12051023
i386                 randconfig-x014-12051023
i386                 randconfig-x015-12051023
i386                 randconfig-x016-12051023
i386                 randconfig-x017-12051023
i386                 randconfig-x018-12051023
i386                 randconfig-x019-12051023
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
x86_64               randconfig-x000-12051024
x86_64               randconfig-x001-12051024
x86_64               randconfig-x002-12051024
x86_64               randconfig-x003-12051024
x86_64               randconfig-x004-12051024
x86_64               randconfig-x005-12051024
x86_64               randconfig-x006-12051024
x86_64               randconfig-x007-12051024
x86_64               randconfig-x008-12051024
x86_64               randconfig-x009-12051024
ia64                             alldefconfig
ia64                              allnoconfig
ia64                                defconfig
nds32                             allnoconfig
nds32                               defconfig
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
s390                        default_defconfig
riscv                             allnoconfig
riscv                               defconfig
mips                          lasat_defconfig
mips                     loongson1c_defconfig
powerpc                       maple_defconfig
riscv                            allyesconfig
arm                         bcm2835_defconfig
mips                             alldefconfig
x86_64                 randconfig-g0-12060652
x86_64                 randconfig-g0-12060701
x86_64                 randconfig-g0-12060726
x86_64                 randconfig-g0-12060802
x86_64                 randconfig-g0-12061457
x86_64                 randconfig-g0-12061522
x86_64                 randconfig-g0-12061529
i386                   randconfig-x005-201848
i386                   randconfig-x006-201848
i386                   randconfig-x007-201848
i386                   randconfig-x000-201848
i386                   randconfig-x004-201848
i386                   randconfig-x002-201848
i386                   randconfig-x009-201848
i386                   randconfig-x001-201848
i386                   randconfig-x008-201848
i386                   randconfig-x003-201848
x86_64               randconfig-x010-12051027
x86_64               randconfig-x011-12051027
x86_64               randconfig-x012-12051027
x86_64               randconfig-x013-12051027
x86_64               randconfig-x014-12051027
x86_64               randconfig-x015-12051027
x86_64               randconfig-x016-12051027
x86_64               randconfig-x017-12051027
x86_64               randconfig-x018-12051027
x86_64               randconfig-x019-12051027
arm                              allmodconfig
arm                                      arm5
arm                                     arm67
arm                       imx_v6_v7_defconfig
arm                          ixp4xx_defconfig
arm                        mvebu_v7_defconfig
arm                       omap2plus_defconfig
arm                                    sa1100
arm                                   samsung
arm                                        sh
arm                           tegra_defconfig
arm64                            alldefconfig
arm64                            allmodconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
x86_64                 randconfig-s0-12060659
x86_64                 randconfig-s1-12060659
x86_64                 randconfig-s2-12060659
x86_64                 randconfig-s0-12060740
x86_64                 randconfig-s1-12060740
x86_64                 randconfig-s2-12060740
x86_64                 randconfig-s0-12060811
x86_64                 randconfig-s1-12060811
x86_64                 randconfig-s2-12060811
x86_64                 randconfig-s0-12061437
x86_64                 randconfig-s1-12061437
x86_64                 randconfig-s2-12061437
x86_64                 randconfig-s0-12061510
x86_64                 randconfig-s1-12061510
x86_64                 randconfig-s2-12061510
x86_64                 randconfig-s0-12061530
x86_64                 randconfig-s1-12061530
x86_64                 randconfig-s2-12061530
x86_64                 randconfig-s0-12061538
x86_64                 randconfig-s1-12061538
x86_64                 randconfig-s2-12061538
x86_64                 randconfig-s0-12061555
x86_64                 randconfig-s1-12061555
x86_64                 randconfig-s2-12061555
openrisc                    or1ksim_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
c6x                        evmc6678_defconfig
h8300                    h8300h-sim_defconfig
xtensa                          iss_defconfig
arm                            zeus_defconfig
sh                               allmodconfig
sh                      rts7751r2d1_defconfig
arm                       aspeed_g5_defconfig
arm                      footbridge_defconfig
powerpc                         ps3_defconfig
xtensa                              defconfig
arm                        keystone_defconfig
powerpc                mpc7448_hpc2_defconfig
powerpc                     pseries_defconfig
arm                        oxnas_v6_defconfig
sh                           se7712_defconfig
sparc                            allyesconfig
sparc                       sparc32_defconfig
arm                            pleb_defconfig
ia64                            zx1_defconfig
sh                          sdk7780_defconfig
arm                              alldefconfig
arm                         assabet_defconfig
powerpc                    adder875_defconfig
arm                            u300_defconfig
mips                          ath79_defconfig
sh                           se7780_defconfig
arm                           h3600_defconfig
m68k                          atari_defconfig
m68k                           sun3_defconfig
nds32                            allyesconfig
arm                     am200epdkit_defconfig
arm                           efm32_defconfig
sparc64                          allmodconfig
x86_64                              defconfig
mips                      pic32mzda_defconfig
powerpc                 mpc8560_ads_defconfig
m68k                              allnoconfig
mips                           gcw0_defconfig
sh                 kfr2r09-romimage_defconfig
xtensa                  audio_kc705_defconfig
x86_64               randconfig-x010-12051035
x86_64               randconfig-x011-12051035
x86_64               randconfig-x012-12051035
x86_64               randconfig-x013-12051035
x86_64               randconfig-x014-12051035
x86_64               randconfig-x015-12051035
x86_64               randconfig-x016-12051035
x86_64               randconfig-x017-12051035
x86_64               randconfig-x018-12051035
x86_64               randconfig-x019-12051035
i386                             alldefconfig
i386                              allnoconfig
i386                                defconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
i386                   randconfig-s0-12051035
i386                   randconfig-s1-12051035
i386                   randconfig-s2-12051035
i386                   randconfig-s3-12051035
x86_64                 randconfig-s3-12060658
x86_64                 randconfig-s4-12060658
x86_64                 randconfig-s5-12060658
x86_64                 randconfig-s3-12060732
x86_64                 randconfig-s4-12060732
x86_64                 randconfig-s5-12060732
x86_64                 randconfig-s3-12061457
x86_64                 randconfig-s4-12061457
x86_64                 randconfig-s5-12061457
x86_64                 randconfig-s3-12061537
x86_64                 randconfig-s4-12061537
x86_64                 randconfig-s5-12061537
parisc                generic-64bit_defconfig
powerpc               corenet_basic_defconfig
powerpc                      virtex_defconfig
x86_64                           allmodconfig
m68k                        mvme16x_defconfig
sparc                             allnoconfig
arm                       versatile_defconfig
mips                           mtx1_defconfig
powerpc                  storcenter_defconfig
mips                           32r2_defconfig
mips                         64r6el_defconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                   jz4740
mips                      malta_kvm_defconfig
mips                                     txx9
i386                   randconfig-b0-12060708
i386                   randconfig-b0-12061521
i386                   randconfig-b0-12061526
sparc64                           allnoconfig
sparc64                             defconfig
mips                           xway_defconfig
powerpc                 xes_mpc85xx_defconfig
sh                          polaris_defconfig
x86_64                 randconfig-b0-12060642
x86_64                 randconfig-b0-12060713
powerpc                     sbc8548_defconfig
arm                         mv78xx0_defconfig
sh                           se7724_defconfig
sh                         ap325rxa_defconfig
m68k                             allmodconfig
powerpc                     tqm5200_defconfig
powerpc                   lite5200b_defconfig
powerpc                     ppa8548_defconfig
powerpc                     tqm8548_defconfig
arm                       netwinder_defconfig
x86_64                 randconfig-u0-12060704
x86_64                 randconfig-u0-12060721
x86_64                 randconfig-u0-12060731
x86_64                 randconfig-u0-12060744
x86_64                 randconfig-u0-12061445
x86_64                 randconfig-u0-12061455
x86_64                 randconfig-u0-12061515
x86_64                 randconfig-u0-12061540
x86_64                 randconfig-u0-12061550
x86_64                           alldefconfig
arm                          iop32x_defconfig
powerpc                   currituck_defconfig
openrisc                 simple_smp_defconfig
i386                   randconfig-h0-12060706
i386                   randconfig-h1-12060706
i386                   randconfig-h0-12060738
i386                   randconfig-h1-12060738
m68k                        m5307c3_defconfig
powerpc                      ppc6xx_defconfig
mips                           jazz_defconfig
sh                           se7751_defconfig
arm                          nuc910_defconfig
m68k                          sun3x_defconfig
powerpc                       ep405_defconfig
arm                         orion5x_defconfig
powerpc                       ebony_defconfig
m68k                        m5272c3_defconfig
mips                          malta_defconfig
sh                        edosk7760_defconfig
powerpc                        icon_defconfig
sh                          kfr2r09_defconfig
powerpc                     mpc512x_defconfig
x86_64                randconfig-ne0-12060640
x86_64                randconfig-ne0-12060733
x86_64                randconfig-ne0-12061450
x86_64                randconfig-ne0-12061537
x86_64                randconfig-ne0-12061547
x86_64                randconfig-ne0-12061559
x86_64                randconfig-ne0-12061611
x86_64                 randconfig-h0-12061447
powerpc               mpc834x_itxgp_defconfig
mips                   sb1250_swarm_defconfig
alpha                            allmodconfig
powerpc                  iss476-smp_defconfig
alpha                            allyesconfig
i386                  randconfig-sb0-12060711
i386                  randconfig-sb0-12060715
i386                  randconfig-sb0-12060721
i386                  randconfig-sb0-12061437
i386                  randconfig-sb0-12061524
i386                  randconfig-sb0-12061530
i386                  randconfig-sb0-12061536
i386                  randconfig-sb0-12061557
x86_64               randconfig-x000-12051028
x86_64               randconfig-x001-12051028
x86_64               randconfig-x002-12051028
x86_64               randconfig-x003-12051028
x86_64               randconfig-x004-12051028
x86_64               randconfig-x005-12051028
x86_64               randconfig-x006-12051028
x86_64               randconfig-x007-12051028
x86_64               randconfig-x008-12051028
x86_64               randconfig-x009-12051028
powerpc                    klondike_defconfig
sh                        dreamcast_defconfig
arm                           u8500_defconfig
sh                           se7705_defconfig
powerpc                 mpc832x_mds_defconfig
powerpc                     tqm8541_defconfig
mips                         mpc30x_defconfig
powerpc                     skiroot_defconfig
arm                                 defconfig
x86_64                randconfig-ws0-12060711
x86_64                randconfig-ws0-12060807
x86_64                randconfig-ws0-12061535
mips                       markeins_defconfig
powerpc                      katmai_defconfig
x86_64                randconfig-ws0-12061508
powerpc                      ppc40x_defconfig
sh                          r7780mp_defconfig
powerpc                     powernv_defconfig
arm                        multi_v7_defconfig
csky                                defconfig
um                                allnoconfig
arm                            hisi_defconfig
parisc                          712_defconfig
arm                            dove_defconfig
x86_64                 randconfig-r0-12060719
x86_64                 randconfig-r0-12061444
x86_64                 randconfig-r0-12061510
i386                 randconfig-x070-12051027
i386                 randconfig-x071-12051027
i386                 randconfig-x072-12051027
i386                 randconfig-x073-12051027
i386                 randconfig-x074-12051027
i386                 randconfig-x075-12051027
i386                 randconfig-x076-12051027
i386                 randconfig-x077-12051027
i386                 randconfig-x078-12051027
i386                 randconfig-x079-12051027
arm                           h5000_defconfig
sh                ecovec24-romimage_defconfig
x86_64                            allnoconfig
arm                         em_x270_defconfig
parisc                         a500_defconfig
sh                     magicpanelr2_defconfig
arm                              zx_defconfig
i386                   randconfig-x0-12060644
i386                   randconfig-x0-12060719
i386                   randconfig-x0-12060806
i386                   randconfig-x0-12061518
i386                   randconfig-x0-12061536

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
