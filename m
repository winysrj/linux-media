Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_MIXED_ES,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF105C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DA1420645
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DA1420645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbeLMJvO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:51:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:38363 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbeLMJvO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:51:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 01:51:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="110044789"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga003.jf.intel.com with ESMTP; 13 Dec 2018 01:51:11 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id AF60B2029C;
        Thu, 13 Dec 2018 11:51:10 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXNe8-0003tG-8x; Thu, 13 Dec 2018 11:51:08 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, laurent.pinchart@ideasonboard.com,
        rajmohan.mani@intel.com
Subject: [PATCH v9 00/22] ImgU driver
Date:   Thu, 13 Dec 2018 11:50:45 +0200
Message-Id: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi folks,

This is effectively Yong's v8 patchset, with a few changes since:

- Addressed most of Laurent's comments on the driver documentation. Some
  have been postponed and added to TODO.

- Added a MAINTAINERS entry.

- Removed uAPI definitions (formats etc.) added by the patches originally
  not intended to be merged (documentation outside the staging tree).

- Added a patch to fix a few compiler warnings (false positives) plus
  fixed the firmware location.

- checkpatch.pl warnings remain; those need to be fixed as well.

Cao,Bing Bu (1):
  media: staging/intel-ipu3: Add dual pipe support

Rajmohan Mani (1):
  doc-rst: Add Intel IPU3 documentation

Sakari Ailus (6):
  v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
  docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface
  ipu3-imgu: Fix compiler warnings
  ipu3-imgu: Fix firmware binary location
  staging/ipu3-imgu: Address documentation comments
  staging/ipu3-imgu: Add MAINTAINERS entry

Tomasz Figa (2):
  media: staging/intel-ipu3: mmu: Implement driver
  media: staging/intel-ipu3: Implement DMA mapping functions

Yong Zhi (12):
  media: staging/intel-ipu3: abi: Add register definitions and enum
  media: staging/intel-ipu3: abi: Add structs
  media: staging/intel-ipu3: css: Add dma buff pool utility functions
  media: staging/intel-ipu3: css: Add support for firmware management
  media: staging/intel-ipu3: css: Add static settings for image pipeline
  media: staging/intel-ipu3: css: Compute and program ccs
  media: staging/intel-ipu3: css: Initialize css hardware
  media: staging/intel-ipu3: Add css pipeline programming
  media: staging/intel-ipu3: Add v4l2 driver based on media framework
  media: staging/intel-ipu3: Add imgu top level pci device driver
  media: staging/intel-ipu3: Add Intel IPU3 meta data uAPI
  media: v4l: Add Intel IPU3 meta buffer formats

 Documentation/media/uapi/v4l/buffer.rst            |    3 +
 Documentation/media/uapi/v4l/dev-meta.rst          |   33 +-
 Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
 .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |  178 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |    3 +
 Documentation/media/v4l-drivers/index.rst          |    1 +
 Documentation/media/v4l-drivers/ipu3.rst           |  369 +
 Documentation/media/videodev2.h.rst.exceptions     |    2 +
 MAINTAINERS                                        |    8 +
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |    1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |    2 +
 drivers/media/v4l2-core/v4l2-dev.c                 |   12 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   23 +
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/ipu3/Kconfig                 |   14 +
 drivers/staging/media/ipu3/Makefile                |   11 +
 drivers/staging/media/ipu3/TODO                    |   30 +
 drivers/staging/media/ipu3/include/intel-ipu3.h    | 2785 ++++++
 drivers/staging/media/ipu3/ipu3-abi.h              | 2011 ++++
 drivers/staging/media/ipu3/ipu3-css-fw.c           |  265 +
 drivers/staging/media/ipu3/ipu3-css-fw.h           |  188 +
 drivers/staging/media/ipu3/ipu3-css-params.c       | 2943 ++++++
 drivers/staging/media/ipu3/ipu3-css-params.h       |   28 +
 drivers/staging/media/ipu3/ipu3-css-pool.c         |  100 +
 drivers/staging/media/ipu3/ipu3-css-pool.h         |   55 +
 drivers/staging/media/ipu3/ipu3-css.c              | 2391 +++++
 drivers/staging/media/ipu3/ipu3-css.h              |  213 +
 drivers/staging/media/ipu3/ipu3-dmamap.c           |  270 +
 drivers/staging/media/ipu3/ipu3-dmamap.h           |   22 +
 drivers/staging/media/ipu3/ipu3-mmu.c              |  561 ++
 drivers/staging/media/ipu3/ipu3-mmu.h              |   35 +
 drivers/staging/media/ipu3/ipu3-tables.c           | 9609 ++++++++++++++++++++
 drivers/staging/media/ipu3/ipu3-tables.h           |   66 +
 drivers/staging/media/ipu3/ipu3-v4l2.c             | 1419 +++
 drivers/staging/media/ipu3/ipu3.c                  |  830 ++
 drivers/staging/media/ipu3/ipu3.h                  |  168 +
 include/media/v4l2-ioctl.h                         |   17 +
 include/uapi/linux/videodev2.h                     |    2 +
 39 files changed, 24655 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
 create mode 100644 Documentation/media/v4l-drivers/ipu3.rst
 create mode 100644 drivers/staging/media/ipu3/Kconfig
 create mode 100644 drivers/staging/media/ipu3/Makefile
 create mode 100644 drivers/staging/media/ipu3/TODO
 create mode 100644 drivers/staging/media/ipu3/include/intel-ipu3.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-abi.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-fw.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-fw.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-params.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-params.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-pool.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-pool.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-css.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-css.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-dmamap.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-dmamap.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-mmu.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-mmu.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-tables.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-tables.h
 create mode 100644 drivers/staging/media/ipu3/ipu3-v4l2.c
 create mode 100644 drivers/staging/media/ipu3/ipu3.c
 create mode 100644 drivers/staging/media/ipu3/ipu3.h

-- 
2.11.0

