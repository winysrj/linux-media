Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C71C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 21:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B4B62084D
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 21:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731020AbfCYV2K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:28:10 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:58641 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730260AbfCYV2J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 17:28:09 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 5752A1263;
        Mon, 25 Mar 2019 21:28:08 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: roof07_29aa51b2ce108
X-Filterd-Recvd-Size: 3826
Received: from joe-laptop.perches.com (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Mon, 25 Mar 2019 21:28:06 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Bad file pattern in MAINTAINERS section 'SOC-CAMERA V4L2 SUBSYSTEM'
Date:   Mon, 25 Mar 2019 14:28:04 -0700
Message-Id: <20190325212805.27813-1-joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
References: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A file pattern line in this section of the MAINTAINERS file in linux-next
does not have a match in the linux source files.

This could occur because a matching filename was never added, was deleted
or renamed in some other commit.

The commits that added and if found renamed or removed the file pattern
are shown below.

Please fix this defect appropriately.

1: ---------------------------------------------------------------------------

linux-next MAINTAINERS section:

	14342	SOC-CAMERA V4L2 SUBSYSTEM
	14343	L:	linux-media@vger.kernel.org
	14344	T:	git git://linuxtv.org/media_tree.git
	14345	S:	Orphan
	14346	F:	include/media/soc*
	14347	F:	drivers/media/i2c/soc_camera/
-->	14348	F:	drivers/media/platform/soc_camera/

2: ---------------------------------------------------------------------------

The most recent commit that added or modified file pattern 'drivers/media/platform/soc_camera/':

commit 90d72ac6e1c3c65233a13816770fb85c8831bff2
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Sat Sep 15 17:59:42 2012 -0300

    MAINTAINERS: fix the path for the media drivers that got renamed
    
    Due to the media tree path renaming, several drivers change their
    location. Update MAINTAINERS accordingly.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 MAINTAINERS | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

3: ---------------------------------------------------------------------------

The last commit with a real presence of file pattern 'drivers/media/platform/soc_camera/':

commit 82c5de0ab8dbd6035223ad69e76bd8a88a0a9399
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Dec 25 13:29:54 2018 +0100

    dma-mapping: remove the DMA_MEMORY_EXCLUSIVE flag
    
    All users of dma_declare_coherent want their allocations to be
    exclusive, so default to exclusive allocations.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

 Documentation/DMA-API.txt                          |  9 +-------
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        | 12 ++++-------
 arch/arm/mach-imx/mach-mx31moboard.c               |  3 +--
 arch/sh/boards/mach-ap325rxa/setup.c               |  5 ++---
 arch/sh/boards/mach-ecovec24/setup.c               |  6 ++----
 arch/sh/boards/mach-kfr2r09/setup.c                |  5 ++---
 arch/sh/boards/mach-migor/setup.c                  |  5 ++---
 arch/sh/boards/mach-se/7724/setup.c                |  6 ++----
 arch/sh/drivers/pci/fixups-dreamcast.c             |  3 +--
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  3 +--
 drivers/usb/host/ohci-sm501.c                      |  3 +--
 drivers/usb/host/ohci-tmio.c                       |  2 +-
 include/linux/dma-mapping.h                        |  7 ++----
 kernel/dma/coherent.c                              | 25 ++++++----------------
 14 files changed, 29 insertions(+), 65 deletions(-)
