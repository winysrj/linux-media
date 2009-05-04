Return-path: <linux-media-owner@vger.kernel.org>
Received: from cmpxchg.org ([85.214.51.133]:49972 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbZEDJ4R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2009 05:56:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Paul Mundt <lethal@linux-sh.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [patch 1/3] mm: introduce follow_pte()
Date: Mon,  4 May 2009 11:54:32 +0200
Message-Id: <1241430874-12667-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <20090501181449.GA8912@cmpxchg.org>
References: <20090501181449.GA8912@cmpxchg.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A generic readonly page table lookup helper to map an address space
and an address from it to a pte.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memory.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index cf6873e..a621319 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3009,6 +3009,43 @@ int in_gate_area_no_task(unsigned long addr)
 
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+static int follow_pte(struct mm_struct *mm, unsigned long address,
+		pte_t **ptepp, spinlock_t **ptlp)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep;
+
+	pgd = pgd_offset(mm, address);
+	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+		goto out;
+
+	pud = pud_offset(pgd, address);
+	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
+		goto out;
+
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+		goto out;
+
+	/* We cannot handle huge page PFN maps. Luckily they don't exist. */
+	if (pmd_huge(*pmd))
+		goto out;
+
+	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
+	if (!ptep)
+		goto out;
+	if (!pte_present(*ptep))
+		goto unlock;
+	*ptepp = ptep;
+	return 0;
+unlock:
+	pte_unmap_unlock(ptep, *ptlp);
+out:
+	return -EINVAL;
+}
+
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 int follow_phys(struct vm_area_struct *vma,
 		unsigned long address, unsigned int flags,
-- 
1.6.2.1.135.gde769

