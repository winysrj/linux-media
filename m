Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D1EC10F00
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 02:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5D62173C
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 02:19:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jm1r7D/r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfCSCTW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 22:19:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38058 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfCSCTW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 22:19:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id v1so8026216pgi.5;
        Mon, 18 Mar 2019 19:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QS3mWzK39q3lW8WqJHFL6wuRYacMcGaOmOmP8soCdrs=;
        b=jm1r7D/rts2BI9YcnuOGIHlHQpyxSGz4aZOvJE/yi+Xo4uNlBnfqja0VcY+FpX9fSD
         28+KDFT/SwkBAZZ1o4TLSIUGewjtegnrMoy3LszzvJ2CwtfqOtcuC7wJMFFFvVyHlntf
         uVBrnde4SmEejwST8D2NZ4eGXPi4DunUxkLIHtZ751AARCv/ODl5lir046VNuABgvsGw
         ZJyDyGnygvc719vLtey2Vx/RTxTJZUmAHCZjnD1cfEDxhYMw8LC/WDb1WQdzBkzOb/W1
         DSw3Z0nbuStKECnh1LO8ozlsCAfA6F5QmcQvncr/iEYxCA4scPRMbXzNynH1JZmbcdsw
         XsMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QS3mWzK39q3lW8WqJHFL6wuRYacMcGaOmOmP8soCdrs=;
        b=H9KMYd2wM2iVe7DFzDWsrZ2UKj2zb7T35qjkQcsAQN9sCdGvapLlwMwmVuhVACgX7O
         jXg+UVP8iw0DhEpBUe7jCnLNZwKNYlAJxplQa5ni4sUCMZc+JMEOkrd7c+Y+cSRRDPpl
         fpeohYFbEtlc2uXvC/nIR0A5NsitXyPhqOS5WDtNjHogBN6aPnw+2hDLO5YWRISeAVqe
         ST0YgQN8H/JuMW00cd3sZ22FvWwUddi+3r+fQVGKn5XN3jMEBd7WtTljnGQH25DqL4q1
         jwnAkcTcsC796tfkOB+Yp7IXOomxUzMDsyrvwGJuv+SJmtvnQ8iMJOxrhyq2o7Lyc7em
         ggBQ==
X-Gm-Message-State: APjAAAVsJ8DPrl54K3r0zoJm/ViAPP/0cTw9h16bCLoTLmlycHh3k69w
        uh4u3wy6pY+F3QnfQU5s3O+RRpDp
X-Google-Smtp-Source: APXvYqz9KjQMMuck4sjrn6Sq3LDJfmEoJ+bGuZkApQa2UhKviptEqmVda9dABsOdlmGAuvojp7es6Q==
X-Received: by 2002:a17:902:20e8:: with SMTP id v37mr2843228plg.168.1552961960808;
        Mon, 18 Mar 2019 19:19:20 -0700 (PDT)
Received: from jordon-HP-15-Notebook-PC ([106.51.22.39])
        by smtp.gmail.com with ESMTPSA id q18sm14908138pgv.9.2019.03.18.19.19.19
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 18 Mar 2019 19:19:20 -0700 (PDT)
Date:   Tue, 19 Mar 2019 07:53:54 +0530
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
Subject: [RESEND PATCH v4 1/9] mm: Introduce new vm_map_pages() and
 vm_map_pages_zero() API
Message-ID: <751cb8a0f4c3e67e95c58a3b072937617f338eea.1552921225.git.jrdr.linux@gmail.com>
References: <cover.1552921225.git.jrdr.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1552921225.git.jrdr.linux@gmail.com>
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

vm_map_pages() is the API which could be used to mapped
kernel memory/pages in drivers which has considered vm_pgoff

vm_map_pages_zero() is the API which could be used to map
range of kernel memory/pages in drivers which has not considered
vm_pgoff. vm_pgoff is passed default as 0 for those drivers.

We _could_ then at a later "fix" these drivers which are using
vm_map_pages_zero() to behave according to the normal vm_pgoff
offsetting simply by removing the _zero suffix on the function
name and if that causes regressions, it gives us an easy way to revert.

Tested on Rockchip hardware and display is working, including talking
to Lima via prime.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Suggested-by: Russell King <linux@armlinux.org.uk>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>
---
 include/linux/mm.h |  4 +++
 mm/memory.c        | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/nommu.c         | 14 ++++++++++
 3 files changed, 99 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 80bb640..e0aaa73 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2565,6 +2565,10 @@ unsigned long change_prot_numa(struct vm_area_struct *vma,
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
+int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
+				unsigned long num);
+int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
+				unsigned long num);
 vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
diff --git a/mm/memory.c b/mm/memory.c
index e11ca9d..cad3e27 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1520,6 +1520,87 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_page);
 
+/*
+ * __vm_map_pages - maps range of kernel pages into user vma
+ * @vma: user vma to map to
+ * @pages: pointer to array of source kernel pages
+ * @num: number of pages in page array
+ * @offset: user's requested vm_pgoff
+ *
+ * This allows drivers to map range of kernel pages into a user vma.
+ *
+ * Return: 0 on success and error code otherwise.
+ */
+static int __vm_map_pages(struct vm_area_struct *vma, struct page **pages,
+				unsigned long num, unsigned long offset)
+{
+	unsigned long count = vma_pages(vma);
+	unsigned long uaddr = vma->vm_start;
+	int ret, i;
+
+	/* Fail if the user requested offset is beyond the end of the object */
+	if (offset > num)
+		return -ENXIO;
+
+	/* Fail if the user requested size exceeds available object size */
+	if (count > num - offset)
+		return -ENXIO;
+
+	for (i = 0; i < count; i++) {
+		ret = vm_insert_page(vma, uaddr, pages[offset + i]);
+		if (ret < 0)
+			return ret;
+		uaddr += PAGE_SIZE;
+	}
+
+	return 0;
+}
+
+/**
+ * vm_map_pages - maps range of kernel pages starts with non zero offset
+ * @vma: user vma to map to
+ * @pages: pointer to array of source kernel pages
+ * @num: number of pages in page array
+ *
+ * Maps an object consisting of @num pages, catering for the user's
+ * requested vm_pgoff
+ *
+ * If we fail to insert any page into the vma, the function will return
+ * immediately leaving any previously inserted pages present.  Callers
+ * from the mmap handler may immediately return the error as their caller
+ * will destroy the vma, removing any successfully inserted pages. Other
+ * callers should make their own arrangements for calling unmap_region().
+ *
+ * Context: Process context. Called by mmap handlers.
+ * Return: 0 on success and error code otherwise.
+ */
+int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
+				unsigned long num)
+{
+	return __vm_map_pages(vma, pages, num, vma->vm_pgoff);
+}
+EXPORT_SYMBOL(vm_map_pages);
+
+/**
+ * vm_map_pages_zero - map range of kernel pages starts with zero offset
+ * @vma: user vma to map to
+ * @pages: pointer to array of source kernel pages
+ * @num: number of pages in page array
+ *
+ * Similar to vm_map_pages(), except that it explicitly sets the offset
+ * to 0. This function is intended for the drivers that did not consider
+ * vm_pgoff.
+ *
+ * Context: Process context. Called by mmap handlers.
+ * Return: 0 on success and error code otherwise.
+ */
+int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
+				unsigned long num)
+{
+	return __vm_map_pages(vma, pages, num, 0);
+}
+EXPORT_SYMBOL(vm_map_pages_zero);
+
 static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			pfn_t pfn, pgprot_t prot, bool mkwrite)
 {
diff --git a/mm/nommu.c b/mm/nommu.c
index 749276b..b492fd1 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -473,6 +473,20 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_page);
 
+int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
+			unsigned long num)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vm_map_pages);
+
+int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
+				unsigned long num)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vm_map_pages_zero);
+
 /*
  *  sys_brk() for the most part doesn't need the global kernel
  *  lock, except when an application is doing something nasty
-- 
1.9.1

