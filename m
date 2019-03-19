Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28063C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 02:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBEB820700
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 02:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TFLM18uv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfCSCRh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 22:17:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37596 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfCSCRg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 22:17:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id q206so12735006pgq.4;
        Mon, 18 Mar 2019 19:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ybJ6FRmizCH+Ysla/KYM0KU4CJcaZTaDUg0Dc25IXgc=;
        b=TFLM18uvjK4LjZZrue8Bkuk/wUFod454FjOxaVkU6fvE8wKqIIyWS9uODPgL0b6/vX
         5tBh0Q/Xv8xN8YraSLbsAoX/qx9KBTuUWtlAiZCC9XFHCWq13RFni5tqM7iEkFUg5JQD
         7dxD9m/GNXj/wsPUBEDK9fUxTfOnTKg3AKutKQrbzjD+c/244ovKdJSnQf5qxs7N+xgQ
         +xQPNs1yG3Md8O/rSUGYjD7ppbTFVRex7asYga3WHKjxFSWKynOL6Is/7zNQAep6NJr8
         Lu6SV6uWaG9wLs2QQHz9r2GdPg+2XXKF6nLfc1jePY8hEXmInBOg/0Er7mP2SCb6/iYz
         E7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ybJ6FRmizCH+Ysla/KYM0KU4CJcaZTaDUg0Dc25IXgc=;
        b=jWRHAjV7YBVJA6vWDYkiTOL4j09ltQWD0krmPBYRg9aurMESXhJXFwVer1eU6CD3et
         SVcdJYpGpK6Lv8oJhv+mVdBabfu1BpSFjz0eLbYAyd0lUQzqL3dmoFW2H0yAeJ8Ng+v5
         gL80CIyLWMksp9CPZKDNta4uK1H7RdhwwnXSzqkyPlkXlX4gSmmCwY0Ia5TTiSHylZlw
         F1rcW2dsrm/Bt2/HSeeBG6WL+4GKfKD16Oe94+AhViiz7hvhaTCFdkKbFO17p9rbpohc
         MD6/qIQDKBOEKATCVendFk8UhoT0YhSwAmefJuL98nm8dPN4nYYxhenth0O01BW1bV5r
         WHHw==
X-Gm-Message-State: APjAAAVkZpgyNn2aafgnL8Uud18nymFb+jWaN2aCKgRcHC35357BAEeg
        E8hCZPUpWquGXSWtJV5Di+5s1uQ4
X-Google-Smtp-Source: APXvYqwDKhWRiy9D5bbmTHs3dACkLmoUcPuxvlF0bXWwoogDZxk/mizWJx+ooPXJSq6wCKPJbrPmBw==
X-Received: by 2002:a65:4608:: with SMTP id v8mr21025819pgq.9.1552961855318;
        Mon, 18 Mar 2019 19:17:35 -0700 (PDT)
Received: from jordon-HP-15-Notebook-PC ([106.51.22.39])
        by smtp.gmail.com with ESMTPSA id w68sm1506149pfb.176.2019.03.18.19.17.32
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 18 Mar 2019 19:17:33 -0700 (PDT)
Date:   Tue, 19 Mar 2019 07:52:08 +0530
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
Subject: [RESEND PATCH v4 0/9] mm: Use vm_map_pages() and vm_map_pages_zero()
 API
Message-ID: <cover.1552921225.git.jrdr.linux@gmail.com>
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

v3 -> v4:
        Fixed build warnings on patch [8/9] reported by kbuild test robot.

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
 drivers/xen/gntdev.c                               | 11 ++-
 drivers/xen/privcmd-buf.c                          |  8 +--
 include/linux/mm.h                                 |  4 ++
 mm/memory.c                                        | 81 ++++++++++++++++++++++
 mm/nommu.c                                         | 14 ++++
 13 files changed, 134 insertions(+), 103 deletions(-)

-- 
1.9.1

