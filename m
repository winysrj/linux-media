Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:64570 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753174AbdCXNWR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 09:22:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: atomisp: remove ifdef around HMM_BO_ION
Date: Fri, 24 Mar 2017 14:20:24 +0100
Message-Id: <20170324132127.3199892-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The revert reintroduced a build failure without CONFIG_ION:

media/atomisp/pci/atomisp2/hmm/hmm.c:52:2: error: excess elements in array initializer [-Werror]
media/atomisp/pci/atomisp2/hmm/hmm.c:52:2: note: (near initialization for 'hmm_bo_type_strings')

We should really be able to build in any configuration, so this tries a
different fix to make sure the symbol is defined.

Fixes: 9ca98bd07748 ("Revert "staging: media: atomisp: fill properly hmm_bo_type_strings when ION is disabled"")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h
index dffd6e9cf693..513d06dff043 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h
@@ -81,9 +81,7 @@ enum hmm_bo_type {
 	HMM_BO_PRIVATE,
 	HMM_BO_SHARE,
 	HMM_BO_USER,
-#ifdef CONFIG_ION
 	HMM_BO_ION,
-#endif
 	HMM_BO_LAST,
 };
 
-- 
2.9.0
