Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:39287 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755739AbeFOG2F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 02:28:05 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH v4 1/9] xen/grant-table: Export gnttab_{alloc|free}_pages as GPL
Date: Fri, 15 Jun 2018 09:27:45 +0300
Message-Id: <20180615062753.9229-2-andr2000@gmail.com>
In-Reply-To: <20180615062753.9229-1-andr2000@gmail.com>
References: <20180615062753.9229-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Only gnttab_{alloc|free}_pages are exported as EXPORT_SYMBOL
while all the rest are exported as EXPORT_SYMBOL_GPL, thus
effectively making it not possible for non-GPL driver modules
to use grant table module. Export gnttab_{alloc|free}_pages as
EXPORT_SYMBOL_GPL so all the exports are aligned.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/grant-table.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 27be107d6480..ba36ff3e4903 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -799,7 +799,7 @@ int gnttab_alloc_pages(int nr_pages, struct page **pages)
 
 	return 0;
 }
-EXPORT_SYMBOL(gnttab_alloc_pages);
+EXPORT_SYMBOL_GPL(gnttab_alloc_pages);
 
 /**
  * gnttab_free_pages - free pages allocated by gnttab_alloc_pages()
@@ -820,7 +820,7 @@ void gnttab_free_pages(int nr_pages, struct page **pages)
 	}
 	free_xenballooned_pages(nr_pages, pages);
 }
-EXPORT_SYMBOL(gnttab_free_pages);
+EXPORT_SYMBOL_GPL(gnttab_free_pages);
 
 /* Handling of paged out grant targets (GNTST_eagain) */
 #define MAX_DELAY 256
-- 
2.17.1
