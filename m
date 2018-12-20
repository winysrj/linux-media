Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02F8C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 842442176F
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545309957;
	bh=uClwdHzmDPlwOTrZPOtS9rsqi/e0rmGCI7EWbp8wtgA=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=en/g3W2AFBRNy+0esKmxMq4RcMZOGxLqSYvddR+VAw6Pjgg0jVuP2AsSGJWBPakrc
	 0JZycEK3ScA+084M8gXcYs5NhgK2be1l3bVVqR0oR9lg2PE6fqOEYOUxYmO+/8MVrL
	 8+Yr7wxnjTii3NLQdCF955Ai30URj9r6nLn0AROc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732124AbeLTMpv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:45:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:45672 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731179AbeLTMpv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 07:45:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cM8FkRJRJhIsZ2N6ZDprCBbuE6nIc8w5GQ+w0zKGuv0=; b=c82GQaELLmconH4fVleG37zfl6
        sNXdOe8AZtY27pTG45ObmcvIRZzTEgmdGvzfwrauMBZLXyYlSD6gWxCKKonRXxFxp82OHbrZcNgN/
        w/3rmtv0yB3vZz0r7MPO6PLIx2dO/rKopxnPPrRD8Uf6MOV+bcUb0ifWHI3o+01PAImB7Ay/KWQJE
        dWznzwprog1SXPFRqjjUke3jUm2AqVGz8mCd6Aj2VWHMYe028rvm0QJYkGFECTDqzqzSYf1EnpMqI
        wlTEc/PX4HkYUN0k5rEGFWGPTYi9RLAypCKl45wPAdA1fmOSAR7lrBTMwDYXFEHbDqt+zlHCE8DIY
        4kRj/sPg==;
Received: from [191.33.191.108] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZxi1-00089J-6k; Thu, 20 Dec 2018 12:45:49 +0000
Date:   Thu, 20 Dec 2018 10:45:44 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [GIT PULL for v4.21] second set of media patches: ipu3 driver
Message-ID: <20181220104544.72ee9203@coco.lan>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-7

For the Intel IPU3 camera driver. 

====
NOTE
====

Please apply this series *after* my first pull request, as it partially
contains the patches that are there.

Also, it would be good if you merge first the docs-next pull request from
Jon, as otherwise, you'll see some warnings when building documentation,
due to an issue at scripts/kernel-doc, whose fix is at documentation tree.

Thanks!
Mauro

The following changes since commit d2b4387f3bdf016e266d23cf657465f557721488:

  media: platform: Add Aspeed Video Engine driver (2018-12-12 12:05:12 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-7

for you to fetch changes up to 38b11beb73c52bd6fb3920775887fdd1004f2a68:

  media: staging/ipu3-imgu: Add MAINTAINERS entry (2018-12-17 15:03:53 -0500)

----------------------------------------------------------------
media fixes for v4.20-rc8

----------------------------------------------------------------
Bingbu Cao (1):
      media: staging/intel-ipu3: Add dual pipe support

Ondrej Jirman (1):
      media: v4l2-fwnode: Fix setting V4L2_MBUS_DATA_ACTIVE_HIGH/LOW flag

Rajmohan Mani (1):
      media: doc-rst: Add Intel IPU3 documentation

Sakari Ailus (6):
      media: v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
      media: docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface
      media: ipu3-imgu: Fix compiler warnings
      media: ipu3-imgu: Fix firmware binary location
      media: staging/ipu3-imgu: Address documentation comments
      media: staging/ipu3-imgu: Add MAINTAINERS entry

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
 drivers/media/v4l2-core/v4l2-fwnode.c              |    4 +-
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
 40 files changed, 24661 insertions(+), 19 deletions(-)
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

