Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,
	T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2031C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90C1E20851
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544703554;
	bh=0TQhoreiVIR+cONZVbEmg61PFqELyTl6GGNoIxwtfNE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=DUt2r/VbRR3i7BQIDklhd6ajHhElTgLECOmWimVqih41WB7yiZUgK+qaZ4jISKNMq
	 p2+9//sBtnZPrv3WaYRBjdbhuUGPZKwMhuFmsBP/DcrxaUfsMRHzcPhijy9NB1G5V3
	 TacIHicXw2tAh94kfvMbK1CsahaspeOzKdBunyZQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90C1E20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbeLMMTN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 07:19:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:34636 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbeLMMTN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 07:19:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=A/wKXCquapqQ/xeeHgtPUl+e9Jkjb+gKV7hfx1tgS18=; b=JdKAFlmWQS4TBWhUkETR3Wj+uo
        0C8OkwUlrRKucb0xdPbEfXfl/mfUFZ1quRfPZsPx7CyB6Hy0IxXTXPuB8xE0yI1EIKZvXzzzT4cCQ
        YuRpxaYRIwBYXBXScYTZ0rIfeW3Wyw0/mj0KZok3Q7c68xWyTEKq5rFfdSIOtEFd/m7MMgpeTrz9U
        UETa4S3g/4kPwLw6At6k7byhX2wJ7BEhnBdXwMHt4WrjKiChU2xZlY6cs9E+GOJk8pSKNtscPxq6X
        uXKRHyDXXph+ghbwKtcn5RAAQnQGpf/eCZukFvLU4xIpiPpx5VvTCTevGpPOAoNYN+AjUVWmqKoMx
        AfJEcrPg==;
Received: from [177.159.254.7] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gXPxO-0006qH-BK; Thu, 13 Dec 2018 12:19:10 +0000
Date:   Thu, 13 Dec 2018 10:19:05 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     sakari.ailus@iki.fi
Cc:     linux-media@vger.kernel.org
Subject: Re: [GIT PULL v4 for 4.21] META_OUTPUT buffer type and the ipu3
 staging driver
Message-ID: <20181213101905.6ad7c481@coco.lan>
In-Reply-To: <20181213120340.2oakeelp2b5w7zzq@valkosipuli.retiisi.org.uk>
References: <20181213120340.2oakeelp2b5w7zzq@valkosipuli.retiisi.org.uk>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 13 Dec 2018 14:03:40 +0200
sakari.ailus@iki.fi escreveu:

> Hi Mauro,
> 
> Here's the ipu3 staging driver plus the META_OUTPUT buffer type needed to
> pass the parameters for the device. If you think this there's still time to
> get this to 4.21, then please pull. The non-staging patches have been
> around for more than half a year and they're relatively simple.
> 
> Note: DO NOT WORRY about the documentation build warnings, they'll be
> adderessed by commit fdf8298f7ff167e4e7522465a3c6e6b908cdb2af from the
> documentation tree (already in linux-next).

I'm assuming you're talking about this patch:

3d9bfb19bd70 ("scripts/kernel-doc: Fix struct and struct field attribute processing")

Ok, I'll remind about that when pulling from it.

> 
> Since the v1 pull request, this contains the content of the v9
> patchset (since v8):
> 
> - Addressed most of Laurent's comments on the driver documentation. Some
>   have been postponed and added to TODO.
> 
> - Added a MAINTAINERS entry.
> 
> - Removed uAPI definitions (formats etc.) added by the patches originally
>   not intended to be merged (documentation outside the staging tree).
> 
> - Added a patch to fix a few compiler warnings (false positives) plus
>   fixed the firmware location.
> 
> - checkpatch.pl warnings remain; those need to be fixed as well.
> 
> since v2 pull request:
> 
> - Use correct tag.
> 
> since v3 pull request:
> 
> - Remove extra Reviewed-by: tags.
> 
> Please pull.
> 
> 
> The following changes since commit e159b6074c82fe31b79aad672e02fa204dbbc6d8:
> 
>   media: vimc: fix start stream when link is disabled (2018-12-07 13:08:41 -0500)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git tags/ipu3-v8-4.20-3-sign
> 
> for you to fetch changes up to 48acf4640e698334bfd9dc41a94b17b568a97b31:
> 
>   staging/ipu3-imgu: Add MAINTAINERS entry (2018-12-13 13:04:00 +0200)
> 
> ----------------------------------------------------------------
> imgu staging driver v9
> 
> ----------------------------------------------------------------
> Cao,Bing Bu (1):
>       media: staging/intel-ipu3: Add dual pipe support
> 
> Rajmohan Mani (1):
>       doc-rst: Add Intel IPU3 documentation
> 
> Sakari Ailus (6):
>       v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
>       docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface
>       ipu3-imgu: Fix compiler warnings
>       ipu3-imgu: Fix firmware binary location
>       staging/ipu3-imgu: Address documentation comments
>       staging/ipu3-imgu: Add MAINTAINERS entry
> 
> Tomasz Figa (2):
>       media: staging/intel-ipu3: mmu: Implement driver
>       media: staging/intel-ipu3: Implement DMA mapping functions
> 
> Yong Zhi (12):
>       media: staging/intel-ipu3: abi: Add register definitions and enum
>       media: staging/intel-ipu3: abi: Add structs
>       media: staging/intel-ipu3: css: Add dma buff pool utility functions
>       media: staging/intel-ipu3: css: Add support for firmware management
>       media: staging/intel-ipu3: css: Add static settings for image pipeline
>       media: staging/intel-ipu3: css: Compute and program ccs
>       media: staging/intel-ipu3: css: Initialize css hardware
>       media: staging/intel-ipu3: Add css pipeline programming
>       media: staging/intel-ipu3: Add v4l2 driver based on media framework
>       media: staging/intel-ipu3: Add imgu top level pci device driver
>       media: staging/intel-ipu3: Add Intel IPU3 meta data uAPI
>       media: v4l: Add Intel IPU3 meta buffer formats
> 
>  Documentation/media/uapi/v4l/buffer.rst            |    3 +
>  Documentation/media/uapi/v4l/dev-meta.rst          |   33 +-
>  Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
>  .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |  178 +
>  Documentation/media/uapi/v4l/vidioc-querycap.rst   |    3 +
>  Documentation/media/v4l-drivers/index.rst          |    1 +
>  Documentation/media/v4l-drivers/ipu3.rst           |  369 +
>  Documentation/media/videodev2.h.rst.exceptions     |    2 +
>  MAINTAINERS                                        |    8 +
>  drivers/media/common/videobuf2/videobuf2-v4l2.c    |    1 +
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |    2 +
>  drivers/media/v4l2-core/v4l2-dev.c                 |   12 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |   23 +
>  drivers/staging/media/Kconfig                      |    2 +
>  drivers/staging/media/Makefile                     |    1 +
>  drivers/staging/media/ipu3/Kconfig                 |   14 +
>  drivers/staging/media/ipu3/Makefile                |   11 +
>  drivers/staging/media/ipu3/TODO                    |   34 +
>  drivers/staging/media/ipu3/include/intel-ipu3.h    | 2785 ++++++
>  drivers/staging/media/ipu3/ipu3-abi.h              | 2011 ++++
>  drivers/staging/media/ipu3/ipu3-css-fw.c           |  265 +
>  drivers/staging/media/ipu3/ipu3-css-fw.h           |  188 +
>  drivers/staging/media/ipu3/ipu3-css-params.c       | 2943 ++++++
>  drivers/staging/media/ipu3/ipu3-css-params.h       |   28 +
>  drivers/staging/media/ipu3/ipu3-css-pool.c         |  100 +
>  drivers/staging/media/ipu3/ipu3-css-pool.h         |   55 +
>  drivers/staging/media/ipu3/ipu3-css.c              | 2391 +++++
>  drivers/staging/media/ipu3/ipu3-css.h              |  213 +
>  drivers/staging/media/ipu3/ipu3-dmamap.c           |  270 +
>  drivers/staging/media/ipu3/ipu3-dmamap.h           |   22 +
>  drivers/staging/media/ipu3/ipu3-mmu.c              |  561 ++
>  drivers/staging/media/ipu3/ipu3-mmu.h              |   35 +
>  drivers/staging/media/ipu3/ipu3-tables.c           | 9609 ++++++++++++++++++++
>  drivers/staging/media/ipu3/ipu3-tables.h           |   66 +
>  drivers/staging/media/ipu3/ipu3-v4l2.c             | 1419 +++
>  drivers/staging/media/ipu3/ipu3.c                  |  830 ++
>  drivers/staging/media/ipu3/ipu3.h                  |  168 +
>  include/media/v4l2-ioctl.h                         |   17 +
>  include/uapi/linux/videodev2.h                     |    2 +
>  39 files changed, 24659 insertions(+), 17 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
>  create mode 100644 Documentation/media/v4l-drivers/ipu3.rst
>  create mode 100644 drivers/staging/media/ipu3/Kconfig
>  create mode 100644 drivers/staging/media/ipu3/Makefile
>  create mode 100644 drivers/staging/media/ipu3/TODO
>  create mode 100644 drivers/staging/media/ipu3/include/intel-ipu3.h
>  create mode 100644 drivers/staging/media/ipu3/ipu3-abi.h
>  create mode 100644 drivers/staging/media/ipu3/ipu3-css-fw.c
>  create mode 100644 drivers/staging/media/ipu3/ipu3-css-fw.h
>  create mode 100644 drivers/staging/media/ipu3/ipu3-css-params.c
>  create mode 100644 drivers/staging/media/ipu3/ipu3-css-params.h
>  create mode 100644 drivers/staging/media/ipu3/ipu3-css-pool.c
>  create mode 100644 drivers/staging/media/ipu3/ipu3-css-pool.h
>  create mode 100644 drivers/staging/media/ipu3/ipu3-css.c
>  create mode 100644 drivers/staging/media/ipu3/ipu3-css.h
>  create mode 100644 drivers/staging/media/ipu3/ipu3-dmamap.c
>  create mode 100644 drivers/staging/media/ipu3/ipu3-dmamap.h
>  create mode 100644 drivers/staging/media/ipu3/ipu3-mmu.c
>  create mode 100644 drivers/staging/media/ipu3/ipu3-mmu.h
>  create mode 100644 drivers/staging/media/ipu3/ipu3-tables.c
>  create mode 100644 drivers/staging/media/ipu3/ipu3-tables.h
>  create mode 100644 drivers/staging/media/ipu3/ipu3-v4l2.c
>  create mode 100644 drivers/staging/media/ipu3/ipu3.c
>  create mode 100644 drivers/staging/media/ipu3/ipu3.h
> 



Thanks,
Mauro
