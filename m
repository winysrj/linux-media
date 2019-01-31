Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82ABC282D8
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 03:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 953AF218AF
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 03:02:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HLK1mCiE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfAaDCV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 22:02:21 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43852 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfAaDCV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 22:02:21 -0500
Received: by mail-pf1-f195.google.com with SMTP id w73so785057pfk.10;
        Wed, 30 Jan 2019 19:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=21JlOZW7w0wGlQ1y8Y5t+ZogP9kpInVIgyeEdo29DZ4=;
        b=HLK1mCiE4dJ18NQVGULIPA8PiIQBws4yp45iUs2ySQEmrEgnAA/9srUZ4RyfZUPVBB
         1cO4YvLYxzKXCmtPQoWx9SlL7yM0nsYjzuAK+jUZJ41cXH/n/cajKPwrrtNroCLCvT+L
         gTlfXkP3sBrFbRX37yKy7ueR/aRnJQrJqkNWKTBFaSSn2y8edx5+l4K0+qZdTPiYk6rD
         DvAjFufGk5qn1qxwiwg5doR0KJWOlGK5OKTVMAYnWPER++voTOoBPAEyvk2B8hiJrJvb
         LctK6KjtdAlhs8txfTflbU+KWxPwpg/vlLc3M5LbIRWqlzewm8SPIu8ueDJef3Mq4tGC
         zMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=21JlOZW7w0wGlQ1y8Y5t+ZogP9kpInVIgyeEdo29DZ4=;
        b=eLRRIgzWczMjxEPAxSBOW97oDWtqAqnmiMn5gnxyHR43VwHlnlfNer5jBHI6BIuV3t
         0zYSR/ZbiuWs6YkBx9fK4UFlg/5B6a0mYaZ7yQdllQQilWWGdb/cwbM3Ue3qanDNzmNh
         oc0zJ7cunrmt2dGhynP6WBqYwVewAW/c3BQKfc9Bl0iSH62Qu+0ZcyZNynpCL5wfU3NM
         dZR/bkmCmgrHKVDi4LcYiXDi2v5rXwLdAIkn98es5/2shYfsPioAfP5VzDe0GLpwYFEa
         J8AQsbfBYoIzHCTOGZYkApHhSy6gdH4DY/h2m99qJgiBn6wHB56ollf7XDC6LDGg9n6I
         GU2Q==
X-Gm-Message-State: AJcUukcBWQ2RMLYASOop1EcTar+br3TTwjJwkHujAmTT3EvZMpY9ECkE
        je4RuLGkd7U/KgLPf8mi2qygVkW5
X-Google-Smtp-Source: ALg8bN5clhF3QoFQslXO5sN+wDZpJqdy7zBe18sX7y+qjCHp8D9i5kDDQHTQn9V7rPsgCAs2+L0urQ==
X-Received: by 2002:a62:4181:: with SMTP id g1mr33008551pfd.45.1548903739568;
        Wed, 30 Jan 2019 19:02:19 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([106.51.20.103])
        by smtp.gmail.com with ESMTPSA id h128sm4118706pgc.15.2019.01.30.19.02.17
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 30 Jan 2019 19:02:18 -0800 (PST)
Date:   Thu, 31 Jan 2019 08:36:31 +0530
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
Subject: [PATCHv2 0/9] Use vm_insert_range and vm_insert_range_buggy
Message-ID: <20190131030631.GA1868@jordon-HP-15-Notebook-PC>
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

v1 -> v2:
	Few Reviewed-by.

        Updated the change log in [8/9]

	In [7/9], vm_pgoff is treated in V4L2 API as a 'cookie'
	to select a buffer, not as a in-buffer offset by design
	and it always want to mmap a whole buffer from its beginning.
	Added additional changes after discussing with Marek and
	vm_insert_range could be used instead of vm_insert_range_buggy.

Souptick Joarder (9):
  mm: Introduce new vm_insert_range and vm_insert_range_buggy API
  arch/arm/mm/dma-mapping.c: Convert to use vm_insert_range
  drivers/firewire/core-iso.c: Convert to use vm_insert_range_buggy
  drm/rockchip/rockchip_drm_gem.c: Convert to use vm_insert_range
  drm/xen/xen_drm_front_gem.c: Convert to use vm_insert_range
  iommu/dma-iommu.c: Convert to use vm_insert_range
  videobuf2/videobuf2-dma-sg.c: Convert to use vm_insert_range
  xen/gntdev.c: Convert to use vm_insert_range
  xen/privcmd-buf.c: Convert to use vm_insert_range_buggy

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

