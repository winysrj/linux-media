Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BA1C64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43C7820892
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:36:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BS5vm9k9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43C7820892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbeLFSgC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 13:36:02 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35159 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbeLFSgB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 13:36:01 -0500
Received: by mail-pg1-f195.google.com with SMTP id s198so524753pgs.2;
        Thu, 06 Dec 2018 10:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Oa/SZo4NTYsdsBTx0P4ctAF7OtbSigl9buobaWrjyts=;
        b=BS5vm9k9bGLFTl+LX0bmmM9M5C7OG8qjleVkise2mkPltptK9svVJnzqEXXf1WBbb0
         ci1hZudApj6H10+lYEQQczak59IqsTKG/aJp5uqzclWSGzssJ3XjOiOHbRPFUit6aUdw
         awp6zYPxAzYDEiPUutQH3/PjWXgzkUVgPqHp9qZz98vIUReekHUtzxSlvagqtyAczrCS
         GXtspLXDM8OX0uBS37pCwnH6jSXou/OORX8gep9Ie9VRObA/sjwgoW41zGJMRAt9I8SZ
         mn0hCyr5xvp8Bvr9AWCf70gWDWAYR72a4erJSB4QEx6QQg9n+sxzLaqCscuzTD0RhN8l
         9s0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Oa/SZo4NTYsdsBTx0P4ctAF7OtbSigl9buobaWrjyts=;
        b=QwpjzzL8WkSjsjGwN5CzjwVk8PD54woKud4Pl4ihmtUzX8tg50T4e8aQvm1isObUuE
         /PmBNPt28iJEtRoPA+s+Ip43SuZj8xpHzjWu3s6XfafxyFhCU0OHFrOw1/9tBIooI6iP
         cbO5bxIJiWT10eu4Ouo11Wk4NsxOENPcVEJ07FT38rmGwf46IG1/2OWWM2eKsYbpWmDA
         3lVLAgcg2RQ/53z9nc6Q72ePQ2TUeTgWDN/Zr+LDjU9WF6eOM3ynnsxsIlfTZno5ft92
         khbX3l70n5AGG8ANwgs3/sMp5pVKF7rl3ZbmRAhwSbLHCezCsNOp52LSos8aOb5BoXoV
         uCug==
X-Gm-Message-State: AA+aEWZaTOwHEzqZFxc9FvFgInQ4b0gp9mUIhZAgBfN37zFRNLvaaccW
        61CRmu1EM77a550RMFxeHjGUkre3
X-Google-Smtp-Source: AFSGD/WuBSuNZ0j2eI+y3vMK44Xcj2c9zc75ftpku5KoTRQQsbR2V1G34l5r5WGKdNdcPvf31x0YxA==
X-Received: by 2002:a62:6ec8:: with SMTP id j191mr29584141pfc.198.1544121360370;
        Thu, 06 Dec 2018 10:36:00 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([103.227.99.39])
        by smtp.gmail.com with ESMTPSA id d129sm1525051pfc.31.2018.12.06.10.35.56
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 06 Dec 2018 10:35:59 -0800 (PST)
Date:   Fri, 7 Dec 2018 00:09:45 +0530
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
Subject: [PATCH v3 1/9] mm: Introduce new vm_insert_range API
Message-ID: <20181206183945.GA20932@jordon-HP-15-Notebook-PC>
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

This API is tested by Heiko for Rockchip drm driver, on rk3188,
rk3288, rk3328 and rk3399 with graphics.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 38 ++++++++++++++++++++++++++++++++++++++
 mm/nommu.c         |  7 +++++++
 3 files changed, 47 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fcf9cc9..2bc399f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2506,6 +2506,8 @@ unsigned long change_prot_numa(struct vm_area_struct *vma,
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
+int vm_insert_range(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long page_count);
 vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
diff --git a/mm/memory.c b/mm/memory.c
index 15c417e..84ea46c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1478,6 +1478,44 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 }
 
 /**
+ * vm_insert_range - insert range of kernel pages into user vma
+ * @vma: user vma to map to
+ * @addr: target user address of this page
+ * @pages: pointer to array of source kernel pages
+ * @page_count: number of pages need to insert into user vma
+ *
+ * This allows drivers to insert range of kernel pages they've allocated
+ * into a user vma. This is a generic function which drivers can use
+ * rather than using their own way of mapping range of kernel pages into
+ * user vma.
+ *
+ * If we fail to insert any page into the vma, the function will return
+ * immediately leaving any previously-inserted pages present.  Callers
+ * from the mmap handler may immediately return the error as their caller
+ * will destroy the vma, removing any successfully-inserted pages. Other
+ * callers should make their own arrangements for calling unmap_region().
+ *
+ * Context: Process context. Called by mmap handlers.
+ * Return: 0 on success and error code otherwise
+ */
+int vm_insert_range(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long page_count)
+{
+	unsigned long uaddr = addr;
+	int ret = 0, i;
+
+	for (i = 0; i < page_count; i++) {
+		ret = vm_insert_page(vma, uaddr, pages[i]);
+		if (ret < 0)
+			return ret;
+		uaddr += PAGE_SIZE;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(vm_insert_range);
+
+/**
  * vm_insert_page - insert single page into user vma
  * @vma: user vma to map to
  * @addr: target user address of this page
diff --git a/mm/nommu.c b/mm/nommu.c
index 749276b..d6ef5c7 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -473,6 +473,13 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_page);
 
+int vm_insert_range(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long page_count)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vm_insert_range);
+
 /*
  *  sys_brk() for the most part doesn't need the global kernel
  *  lock, except when an application is doing something nasty
-- 
1.9.1

