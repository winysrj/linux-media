Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D585C43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 20:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AFE221473
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 20:15:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fGyPRsWD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388976AbeLQUPy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 15:15:54 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46490 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388083AbeLQUPx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 15:15:53 -0500
Received: by mail-pl1-f193.google.com with SMTP id t13so6630102ply.13;
        Mon, 17 Dec 2018 12:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=3vyqNF2AY3a98If6IXFQYuTsTHWXYSwI0xNLA0HcJhQ=;
        b=fGyPRsWDJn6Kj0Fg0NK2CHb8lm2wpyJMPu69HAivJuYK13NTR/Fm7RG4BGWJRgANwN
         gqRaCCrlzg1HzxTnTO+mVE35R6zDT9HfArCP2PgcSIIpHCoVIQXu08QiSoaPOq4Kr/1H
         S4zhEkJ18wFGfdMipkVsQB9Q0iqB+paWWQ3FAQqCuZF4g9XpwJqNutc5OkaNi/21rzn7
         Z9h7IMPC7m2mUXOUlD5FxSEBkCRbYJfkPWwLwC7KVn+bOEBPWF47xpQVjstuw1u3EbnK
         4lUBPSqwiu4dYr91tYfWcSXSsKiowwIsgen2M8nfGYTCk8AN+KF9diFAXrSa0zOu7MON
         BkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=3vyqNF2AY3a98If6IXFQYuTsTHWXYSwI0xNLA0HcJhQ=;
        b=oayw9Q5qr3cvNJQ38g7cWGE23lHpgmm9NQyyam9yLEIjt2NcX9zKGRHtOajB19llZY
         Xt39+z92XfCLPO5dqnSsBVbuwrC3APnaxvuBAwQ2YRNKyL0zVN1E+9uEgIPIk9zZn/gu
         UOghd0hg7jok9Aa6g/tMXlvG413PqCZKkSyyvRAG5SCJ3EgujviG75NRolkeNN+wqPxH
         2RyGpyx4v5oamSz0i++TstoVuHRtjdOJcRRSslurDpbgkgWCrAnxaT0AxK1/bXOLhihX
         EydRn2tVfb9v019Vy7U9D6P/ew2G/cYlKDmW4AnObRE/BMpg9V9sLTXCtpq8PqyKdjbV
         Q24A==
X-Gm-Message-State: AA+aEWYz1TuMO5U3DnauhoWVtihgG9UcCMjPAr9+7AGWs3zvXOME8o5A
        Ghn3KrJvLM1zV6MOgfraQ1RvHx2r
X-Google-Smtp-Source: AFSGD/UwgNW1q7B1Tl/WOz2n048Sng10rkAssfluJ7vJAib6KbxfmhOWdEj5Pb0Em8FBTBItR70xVw==
X-Received: by 2002:a17:902:bd86:: with SMTP id q6mr13486898pls.16.1545077751326;
        Mon, 17 Dec 2018 12:15:51 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([103.227.98.208])
        by smtp.gmail.com with ESMTPSA id b68sm21569889pfg.160.2018.12.17.12.15.49
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Dec 2018 12:15:50 -0800 (PST)
Date:   Tue, 18 Dec 2018 01:49:42 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        kirill.shutemov@linux.intel.com, vbabka@suse.cz, riel@surriel.com,
        sfr@canb.auug.org.au, rppt@linux.vnet.ibm.com,
        peterz@infradead.org, linux@armlinux.org.uk, robin.murphy@arm.com,
        iamjoonsoo.kim@lge.com, treding@nvidia.com, keescook@chromium.org,
        m.szyprowski@samsung.com, stefanr@s5r6.in-berlin.de,
        hjc@rock-chips.com, heiko@sntech.de, airlied@linux.ie,
        oleksandr_andrushchenko@epam.com, joro@8bytes.org,
        pawel@osciak.com, kyungmin.park@samsung.com, mchehab@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org, xen-devel@lists.xen.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org
Subject: [PATCH v4 0/9] Use vm_insert_range
Message-ID: <20181217201942.GA31335@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Previouly drivers have their own way of mapping range of
kernel pages/memory into user vma and this was done by
invoking vm_insert_page() within a loop.

As this pattern is common across different drivers, it can
be generalized by creating a new function and use it across
the drivers.

vm_insert_range is the new API which will be used to map a
range of kernel memory/pages to user vma.

All the applicable places are converted to use new vm_insert_range
in this patch series.

v1 -> v2:
        Address review comment on mm/memory.c. Add EXPORT_SYMBOL
        for vm_insert_range and corrected the documentation part
        for this API.

        In drivers/gpu/drm/xen/xen_drm_front_gem.c, replace err
        with ret as suggested.

        In drivers/iommu/dma-iommu.c, handle the scenario of partial
        mmap() of large buffer by passing *pages + vma->vm_pgoff* to
        vm_insert_range().

v2 -> v3:
        Declaration of vm_insert_range() moved to include/linux/mm.h

v3 -> v4:
	Address review comments.
	
	In mm/memory.c. Added error check.

	In arch/arm/mm/dma-mapping.c, remove part of error check as the
	similar is checked inside vm_insert_range.

	In rockchip/rockchip_drm_gem.c, vma->vm_pgoff is respected as
	this might be passed as non zero value considering partial
	mapping of large buffer.

	In iommu/dma-iommu.c, count is modifed as (count - vma->vm_pgoff)
	to handle partial mapping scenario in v2.

Souptick Joarder (9):
  mm: Introduce new vm_insert_range API
  arch/arm/mm/dma-mapping.c: Convert to use vm_insert_range
  drivers/firewire/core-iso.c: Convert to use vm_insert_range
  drm/rockchip/rockchip_drm_gem.c: Convert to use vm_insert_range
  drm/xen/xen_drm_front_gem.c: Convert to use vm_insert_range
  iommu/dma-iommu.c: Convert to use vm_insert_range
  videobuf2/videobuf2-dma-sg.c: Convert to use vm_insert_range
  xen/gntdev.c: Convert to use vm_insert_range
  xen/privcmd-buf.c: Convert to use vm_insert_range

 arch/arm/mm/dma-mapping.c                         | 21 ++++--------
 drivers/firewire/core-iso.c                       | 15 ++-------
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c       | 19 ++---------
 drivers/gpu/drm/xen/xen_drm_front_gem.c           | 20 ++++-------
 drivers/iommu/dma-iommu.c                         | 13 ++-----
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 23 ++++---------
 drivers/xen/gntdev.c                              | 11 +++---
 drivers/xen/privcmd-buf.c                         |  8 ++---
 include/linux/mm.h                                |  2 ++
 mm/memory.c                                       | 41 +++++++++++++++++++++++
 mm/nommu.c                                        |  7 ++++
 11 files changed, 83 insertions(+), 97 deletions(-)

-- 
1.9.1

