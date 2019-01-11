Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F308C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F5D120874
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpzAMn/t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390284AbfAKPBo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:01:44 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40188 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389984AbfAKPBn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 10:01:43 -0500
Received: by mail-pf1-f196.google.com with SMTP id i12so7067378pfo.7;
        Fri, 11 Jan 2019 07:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=SrodQzZztcg8txHZaZFxducSgC9DqvYe1eV09xmVfQk=;
        b=RpzAMn/tFZO9w1bOsU0R3bl0Czqgh3vozKcpize0+4T5FcTI3eGHnL7a/siSocGNeS
         YpzDw/x5TPn/ZIK8D8rFRVnfSd+kRunfwlXMPBFnoy0agtIVT3l2o8n93yulfDdqPfpM
         02pnJKSJtBrMnNoIKfIXvp+dl7xWo/ZINl/06zWYmqtI8R6Rd1tzw33GJStW9BWNcyJd
         UTxrdHPrzQA7Dgo9vXmzvN7LPm0x/n5eENgEHExKf5wRU3L1BPvidyksamluwHiEMfNj
         jLP1Epne1X0o4Fs5YlsShABd8w6xov+ORe//hxIum1KwYBI45AwbqyCzizyY7CZsappy
         j23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=SrodQzZztcg8txHZaZFxducSgC9DqvYe1eV09xmVfQk=;
        b=d2+qG4mTCgeTXqDyk8Cxjf0tGyVMvmHwgMOVkgQLrdFIE3N4QuLcU+D+hjEmYYra8m
         h6Nm8pWE5ITOmLknREiAgSesue7h/kCEX5I1b6E/M/bz21clMv+18mfFk0FXMITFZf/b
         TvMv05TdKL1Qz/DKSFyoMsu4el/1dXqLtX5jAdKXc5OfID486OiojEDm36nbn3Bxky3G
         gQS+GalWXbXEb2WRiCLh8ZSxnWLsnpELC4ItaFIivfidt7cL5ICwy3SJ3wu49akoE8nq
         KhYrQtj/EgpZ8xYLfZY6LC3VcOHCqGWKaimlfgCSRYGTFdWq+LFCxlgcAU5cyGJDGsgP
         /1yA==
X-Gm-Message-State: AJcUukeD6H6zh7THqO3kLNuON1Qfnsg4HS8zw0l4iSTEasjXK3OCF+jT
        s05gNROLGhZNnGBnFpReV7D6bMw9
X-Google-Smtp-Source: ALg8bN63Mqumr33i923Eaojw1CNwJqGO3fUgNxuFX1Idnsn+2UvfCqyMDy2gA5SSe2/mxV+qUcpzvQ==
X-Received: by 2002:a63:f30d:: with SMTP id l13mr13690215pgh.399.1547218901644;
        Fri, 11 Jan 2019 07:01:41 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([49.207.52.190])
        by smtp.gmail.com with ESMTPSA id l70sm87429186pgd.20.2019.01.11.07.01.39
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 11 Jan 2019 07:01:40 -0800 (PST)
Date:   Fri, 11 Jan 2019 20:35:41 +0530
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
Subject: [PATCH 0/9] Use vm_insert_range and vm_insert_range_buggy
Message-ID: <20190111150541.GA2670@jordon-HP-15-Notebook-PC>
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
be generalized by creating new functions and use it across
the drivers.

vm_insert_range() is the API which could be used to mapped
kernel memory/pages in drivers which has considered vm_pgoff

vm_insert_range_buggy() is the API which could be used to map
range of kernel memory/pages in drivers which has not considered
vm_pgoff. vm_pgoff is passed default as 0 for those drivers.

We _could_ then at a later "fix" these drivers which are using
vm_insert_range_buggy() to behave according to the normal vm_pgoff
offsetting simply by removing the _buggy suffix on the function
name and if that causes regressions, it gives us an easy way to revert.

There is an existing bug in [7/9], where user passed length is not
verified against object_count. For any value of length > object_count
it will end up overrun page array which could lead to a potential bug.
This is fixed as part of these conversion.

Souptick Joarder (9):
  mm: Introduce new vm_insert_range and vm_insert_range_buggy API
  arch/arm/mm/dma-mapping.c: Convert to use vm_insert_range
  drivers/firewire/core-iso.c: Convert to use vm_insert_range_buggy
  drm/rockchip/rockchip_drm_gem.c: Convert to use vm_insert_range
  drm/xen/xen_drm_front_gem.c: Convert to use vm_insert_range
  iommu/dma-iommu.c: Convert to use vm_insert_range
  videobuf2/videobuf2-dma-sg.c: Convert to use vm_insert_range_buggy
  xen/gntdev.c: Convert to use vm_insert_range
  xen/privcmd-buf.c: Convert to use vm_insert_range_buggy

 arch/arm/mm/dma-mapping.c                         | 22 ++----
 drivers/firewire/core-iso.c                       | 15 +----
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c       | 17 +----
 drivers/gpu/drm/xen/xen_drm_front_gem.c           | 18 ++---
 drivers/iommu/dma-iommu.c                         | 12 +---
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 22 ++----
 drivers/xen/gntdev.c                              | 16 ++---
 drivers/xen/privcmd-buf.c                         |  8 +--
 include/linux/mm.h                                |  4 ++
 mm/memory.c                                       | 81 +++++++++++++++++++++++
 mm/nommu.c                                        | 14 ++++
 11 files changed, 129 insertions(+), 100 deletions(-)

-- 
1.9.1

