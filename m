Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BB8C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 13:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A92F222C1
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 13:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wo+rn4+r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732845AbfBMN4U (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 08:56:20 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41619 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfBMN4U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 08:56:20 -0500
Received: by mail-pl1-f195.google.com with SMTP id k15so1195963pls.8;
        Wed, 13 Feb 2019 05:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=V2qFA0OcwjrK68risolzFdRV/D9+52UF5C3nMIQDVp4=;
        b=Wo+rn4+rpbWNXMXw8f961P6oxr28SV0R3AE2+Iuvqh7fxEkblbcFpBrThrdGUZASMo
         +obY5tWBT5FcDq1TCc2YALzjSj/RwS62oxijXHr27AMGgQQ5EAXv7KDXIR8qS+CriIzl
         v+ii3rGwru5TZogwAVIdxKFZ3HcsQXSMp2qyjqUotAp7B0lv2662QZR8uNlKx7/r97Wt
         Q1kF7Xrwhfuo0ODVWB5AEbZlo/SYZi2B7iswqgis9OVmaodYPCQ5gXnYca7KlKSYKhWN
         qJ16mA6TwoJHT3BVnzle1LT/35tmCVTvOSmsrJwpZE+NSxRv6QEEiAd7//aDbrQIA0zS
         /cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=V2qFA0OcwjrK68risolzFdRV/D9+52UF5C3nMIQDVp4=;
        b=JFaa37+XiYe9JPr0XfKQc6WYbIOCVkpCwXm7zuVN+cYFGNpKWC0FXEkzYAWXvP70zH
         TCFQE6EUXJslOoFeC5aKpjPiLZusO+G3OnSGvrWH2f+4n20iaSknYqXY+65AlFbiIriB
         4Sb9YyXXT1RGxK8QBAOT06/FHzQZ4I0zVPURxTo61sCaUJxOKhnpOuSjp4s3P0HPjN1F
         EPtRCnQV1KLXV48iPnl96GAfyQn/J9Rhyka+Ohe5/73MO1Diq7o3K5dYsAHWDchcBv0f
         u1BSBl1tBijpeGOSu+aXNFLWfmC+QmLEqCr9tb62OigW7sD/r8Mv35OcakN1GRN/uztj
         MIQQ==
X-Gm-Message-State: AHQUAuZKVOeEthb5q/kjmMlDvIPebsdCfzspheuG32yrRE89rOBmQ4As
        YF3hQRAUP3yWyVXN5PknYLISHdc3
X-Google-Smtp-Source: AHgI3IZ+SXZkfuwQeWGM2fq41k8bLY3tiDCzMWyTKTaAYfDA8NidP+PtWIWRFYBlC0duiJnXDlxZqA==
X-Received: by 2002:a17:902:161:: with SMTP id 88mr683223plb.306.1550066178456;
        Wed, 13 Feb 2019 05:56:18 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([49.207.48.54])
        by smtp.gmail.com with ESMTPSA id y20sm26266582pfd.161.2019.02.13.05.56.16
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Feb 2019 05:56:17 -0800 (PST)
Date:   Wed, 13 Feb 2019 19:30:35 +0530
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
Subject: [PATCH v3 0/9] mm: Use vm_map_pages() and vm_map_pages_zero() API
Message-ID: <20190213140035.GA21935@jordon-HP-15-Notebook-PC>
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

vm_map_pages() is the API which could be used to map
kernel memory/pages in drivers which has considered vm_pgoff.

vm_map_pages_zero() is the API which could be used to map
range of kernel memory/pages in drivers which has not considered
vm_pgoff. vm_pgoff is passed default as 0 for those drivers.

We _could_ then at a later "fix" these drivers which are using
vm_map_pages_zero() to behave according to the normal vm_pgoff
offsetting simply by removing the _zero suffix on the function
name and if that causes regressions, it gives us an easy way to revert.

Tested on Rockchip hardware and display is working fine, including talking
to Lima via prime.

v1 -> v2:
        Few Reviewed-by.

        Updated the change log in [8/9]

        In [7/9], vm_pgoff is treated in V4L2 API as a 'cookie'
        to select a buffer, not as a in-buffer offset by design
        and it always want to mmap a whole buffer from its beginning.
        Added additional changes after discussing with Marek and
        vm_map_pages() could be used instead of vm_map_pages_zero().

v2 -> v3:
        Corrected the documentation as per review comment.

        As suggested in v2, renaming the interfaces to -
        *vm_insert_range() -> vm_map_pages()* and
        *vm_insert_range_buggy() -> vm_map_pages_zero()*.
        As the interface is renamed, modified the code accordingly,
        updated the change logs and modified the subject lines to use the
        new interfaces. There is no other change apart from renaming and
        using the new interface.

	Patch[1/9] & [4/9], Tested on Rockchip hardware.

Souptick Joarder (9):
  mm: Introduce new vm_map_pages() and vm_map_pages_zero() API
  arm: mm: dma-mapping: Convert to use vm_map_pages()
  drivers/firewire/core-iso.c: Convert to use vm_map_pages_zero()
  drm/rockchip/rockchip_drm_gem.c: Convert to use vm_map_pages()
  drm/xen/xen_drm_front_gem.c: Convert to use vm_map_pages()
  iommu/dma-iommu.c: Convert to use vm_map_pages()
  videobuf2/videobuf2-dma-sg.c: Convert to use vm_map_pages()
  xen/gntdev.c: Convert to use vm_map_pages()
  xen/privcmd-buf.c: Convert to use vm_map_pages_zero()

 arch/arm/mm/dma-mapping.c                          | 22 ++----
 drivers/firewire/core-iso.c                        | 15 +---
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c        | 17 +----
 drivers/gpu/drm/xen/xen_drm_front_gem.c            | 18 ++---
 drivers/iommu/dma-iommu.c                          | 12 +---
 drivers/media/common/videobuf2/videobuf2-core.c    |  7 ++
 .../media/common/videobuf2/videobuf2-dma-contig.c  |  6 --
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  | 22 ++----
 drivers/xen/gntdev.c                               | 16 ++---
 drivers/xen/privcmd-buf.c                          |  8 +--
 include/linux/mm.h                                 |  4 ++
 mm/memory.c                                        | 81 ++++++++++++++++++++++
 mm/nommu.c                                         | 14 ++++
 13 files changed, 136 insertions(+), 106 deletions(-)

-- 
1.9.1

