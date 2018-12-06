Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD34C64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB4EF20892
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:33:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="davkmg1r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB4EF20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbeLFSdu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 13:33:50 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36055 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbeLFSdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 13:33:49 -0500
Received: by mail-pl1-f195.google.com with SMTP id g9so559775plo.3;
        Thu, 06 Dec 2018 10:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=//xM5ckHQpjH8DRY7QjxQr9OahBeTL/2OYhSA/2ZlVM=;
        b=davkmg1rht5+CKYgw8LgltjJ8cvgRpcvOtjPkNdysxNTmHbV7OvchtIoVQymYDgKTz
         ZQuAz513k8SnYKXR4Bd3jxCfrxiBLQFcHMpmTADwHEyZ5v3h6mKWIWpro9HOf/FhdhIO
         pq4A04jwaORyVvTOXpgO/5jxEBR/QNHfHJo38BYfiMw+CuQvRyUdois//LrihhvKbkUC
         IwbNje16unuPJk5Iy+JnYzEmgRIP3vzqLH+2EBbhZYK0rPgXANen8CrSLHkgl2GabRvE
         JWEntG18tba6aGPTFpcj4sfRCohVeAKRRalaqTEow7MOE778mEZF+co4fXCA/Ie1LAH4
         m62w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=//xM5ckHQpjH8DRY7QjxQr9OahBeTL/2OYhSA/2ZlVM=;
        b=j2Qp3kzQ0YAoXCaR/jrD7cOzQwfYI0v4NVG1wSf8ZCJ5xhK5mwYr7iD3wOZIoh5uQy
         ocuOXIblvxDVq/UDSRMkQo8YxzHDbG1EaMNdT0XDECq5OLl8bkkRQF4cFD5bWr4tfOD8
         uz6eI1Yndg0XT75JxlhFk3uPGbM7JKQsJm5NDcBOANPWiP3Uot4A2LMRipSk16MOnz3f
         NrfVL8eBnEBs2TJCf6uZcs6NcRfmIFPNgxiNk2ADhSfQh4CHpxbNzL302HPNyptnzAVm
         0WgemSnJHMHjeF4qaekzZVhGafrjozMTEQrKJTuv4M0xoCSlFAIIXjTeoIAECdPauULe
         zXxQ==
X-Gm-Message-State: AA+aEWYFUt+/eN1W2MQXlPkotWRsneVra0W1VcTSqhuRSBJCPPv9n3oB
        fz50C4igHmj8UNXAtG98d9R4b7Ms
X-Google-Smtp-Source: AFSGD/WNnGiapTEJ46Ed5/Z/wawNX1AN/JF1DLHSpN0c5ocfxsOQRaK395FOtJYxrGm5y2+oYNYISQ==
X-Received: by 2002:a17:902:e10a:: with SMTP id cc10mr14834670plb.165.1544121228581;
        Thu, 06 Dec 2018 10:33:48 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([103.227.99.39])
        by smtp.gmail.com with ESMTPSA id g65sm5281319pfa.63.2018.12.06.10.33.45
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 06 Dec 2018 10:33:46 -0800 (PST)
Date:   Fri, 7 Dec 2018 00:07:33 +0530
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
Subject: [PATCH v3 0/9] Use vm_insert_range
Message-ID: <20181206183733.GA17240@jordon-HP-15-Notebook-PC>
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

 arch/arm/mm/dma-mapping.c                         | 21 +++++--------
 drivers/firewire/core-iso.c                       | 15 ++-------
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c       | 20 ++----------
 drivers/gpu/drm/xen/xen_drm_front_gem.c           | 20 ++++--------
 drivers/iommu/dma-iommu.c                         | 13 ++------
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 23 +++++---------
 drivers/xen/gntdev.c                              | 11 +++----
 drivers/xen/privcmd-buf.c                         |  8 ++---
 include/linux/mm.h                                |  2 ++
 mm/memory.c                                       | 38 +++++++++++++++++++++++
 mm/nommu.c                                        |  7 +++++
 11 files changed, 80 insertions(+), 98 deletions(-)

-- 
1.9.1

