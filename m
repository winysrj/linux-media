Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CCDC43613
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 13:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385B721850
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 13:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d3Xd7Mol"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbeLXNOt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 08:14:49 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44638 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbeLXNOt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 08:14:49 -0500
Received: by mail-pf1-f193.google.com with SMTP id u6so5788877pfh.11;
        Mon, 24 Dec 2018 05:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=6TaUtlS7TeG92dcvMBbOIZkMmLyB09aVGWNeeSIZ3pY=;
        b=d3Xd7MolqeTIJQoUjbD+4dweIgr48eZCrq7SBO35pR2Fitu8erEje+Llq96kKgTaNn
         XPfL1CGWAPc7da/LB62zDpZpORWDHnIR2BjFHRYQyp/+KXF3M0iEvByaht2KpWbLTUSF
         V5VIWYbIwhP1dfjMui59FMP3G4zVM2NSpfC3wkJA8wA1dfEWXoaUbndmy158JAQbEGV7
         1LyOQUqQV9Fgk9ZJ2ZCooYItc9QCHKk8jFkB0A+5yNHmPj3XbGdD3KOM6XxI3ib20uxc
         huNf3L3JPnlFZI3UEuFbedEqb1+lenfo3/eTH4iLnBykOZCUZ8fzgmdmLqU+O3hztuVF
         QY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=6TaUtlS7TeG92dcvMBbOIZkMmLyB09aVGWNeeSIZ3pY=;
        b=t+Awcz06KBLHFtabLH2mR1xmgfHUJSu8EeKij9A3hs/o5PXsVxImL6dN1aBvY3XnC6
         l3jblfMStRaGmLYu0+8KerJL2Vd5+oyaowiGXRQ6auVMMfgzn+1XSyJyJ2xsecffXKo1
         evDt51ULAGkzF7H6v28zqz8Q899SrdsTOKFttXcxu4WlAFOw0l92zQI+QNpto1FFsB6d
         JE15oOGttZILtUEr2Wic86Bip3CzbXFPAQb2jxKLQI3mb/O5mhnP6Jb4ujvGDEr4BfiT
         0RMWLnVR8f+le8wVD2rhIEI/5MIKZH9ebXPLbH9K1E4F3pPTqO+jQiVLMgup7gZ0e2+v
         icWw==
X-Gm-Message-State: AJcUukcBh4/uYiC2URXcJ5v8I4/pKD2dcrao5ebTGeqjD7OWmxPu/V2i
        g5xKFMavSuk+WcRB1sb66d0Ww7TL
X-Google-Smtp-Source: ALg8bN7YE+bPCsEF6zRIwsShrpUAZIueHQ2KAFb4fOzxweLzlSCbHbZrB8/PRrputEX6DLtFQp2qqA==
X-Received: by 2002:a63:e40c:: with SMTP id a12mr12404213pgi.28.1545657287533;
        Mon, 24 Dec 2018 05:14:47 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([106.51.18.181])
        by smtp.gmail.com with ESMTPSA id q1sm49507262pgs.14.2018.12.24.05.14.44
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Dec 2018 05:14:46 -0800 (PST)
Date:   Mon, 24 Dec 2018 18:48:41 +0530
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
Subject: [PATCH v5 0/9] Use vm_insert_range
Message-ID: <20181224131841.GA22017@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

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

v4 -> v5:
	Address review comment on [2/9] and [4/9]

	In arch/arm/mm/dma-mapping.c, added the error check which was removed
	in v4, as without those error check we might end up overrun the page
	array.

	In rockchip/rockchip_drm_gem.c, added error check which was removed in
	v1, as without this it might overrun page array. Adjusted page_count
	parameter before passing it to vm_insert_range().

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

 arch/arm/mm/dma-mapping.c                         | 18 ++++------
 drivers/firewire/core-iso.c                       | 15 ++-------
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c       | 14 ++------
 drivers/gpu/drm/xen/xen_drm_front_gem.c           | 20 ++++-------
 drivers/iommu/dma-iommu.c                         | 13 ++-----
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 23 ++++---------
 drivers/xen/gntdev.c                              | 11 +++---
 drivers/xen/privcmd-buf.c                         |  8 ++---
 include/linux/mm.h                                |  2 ++
 mm/memory.c                                       | 41 +++++++++++++++++++++++
 mm/nommu.c                                        |  7 ++++
 11 files changed, 83 insertions(+), 89 deletions(-)

-- 
1.9.1

