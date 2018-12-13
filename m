Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,T_MIXED_ES,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F51C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C822086D
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:19:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85C822086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=iki.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbeLMLTZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 06:19:25 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60094 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727590AbeLMLTY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 06:19:24 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id C8831634C7D
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 13:19:08 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gXP1I-0000g4-Pc
        for linux-media@vger.kernel.org; Thu, 13 Dec 2018 13:19:08 +0200
Date:   Thu, 13 Dec 2018 13:19:08 +0200
From:   sakari.ailus@iki.fi
To:     linux-media@vger.kernel.org
Subject: [GIT PULL v3 for 4.21] META_OUTPUT buffer type and the ipu3 staging
 driver
Message-ID: <20181213111908.kmdnv4hmm6xcah7f@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Here's the ipu3 staging driver plus the META_OUTPUT buffer type needed to
pass the parameters for the device. If you think this there's still time to
get this to 4.21, then please pull. The non-staging patches have been
around for more than half a year and they're relatively simple.

Note: DO NOT WORRY about the documentation build warnings, they'll be
adderessed by commit fdf8298f7ff167e4e7522465a3c6e6b908cdb2af from the
documentation tree (already in linux-next).

Since the v1 pull request, this contains the content of the v9
patchset (since v8):

- Addressed most of Laurent's comments on the driver documentation. Some
  have been postponed and added to TODO.

- Added a MAINTAINERS entry.

- Removed uAPI definitions (formats etc.) added by the patches originally
  not intended to be merged (documentation outside the staging tree).

- Added a patch to fix a few compiler warnings (false positives) plus
  fixed the firmware location.

- checkpatch.pl warnings remain; those need to be fixed as well.

since v2 pull request:

- Use correct tag.

Please pull.


The following changes since commit e159b6074c82fe31b79aad672e02fa204dbbc6d8:

  media: vimc: fix start stream when link is disabled (2018-12-07 13:08:41 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/ipu3-v8-4.20-3-sign

for you to fetch changes up to 48acf4640e698334bfd9dc41a94b17b568a97b31:

  staging/ipu3-imgu: Add MAINTAINERS entry (2018-12-13 13:04:00 +0200)

----------------------------------------------------------------
imgu staging driver v9

----------------------------------------------------------------
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
 drivers/staging/media/ipu3/TODO                    |   34 +
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
 39 files changed, 24659 insertions(+), 17 deletions(-)
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
Sakari Ailus
