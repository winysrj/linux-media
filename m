Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36216 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751787AbdCWNMt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Mar 2017 09:12:49 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>, Varsha Rao <rvarsha016@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: atomisp: fix build error
Date: Thu, 23 Mar 2017 21:12:38 +0800
Message-Id: <328d0eb3da461aaaa6140b1409ee7550bcec87bb.1490261279.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following build error:

  CC      drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.o
drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c:52:2:
 error: excess elements in array initializer [-Werror]
  "i", /* ion */
  ^~~
drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c:52:2:
 note: (near initialization for ‘hmm_bo_type_strings’)
cc1: all warnings being treated as errors
scripts/Makefile.build:294: recipe for target
'drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.o' failed

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index a362b49..e78f02f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -49,7 +49,9 @@ const char *hmm_bo_type_strings[HMM_BO_LAST] = {
 	"p", /* private */
 	"s", /* shared */
 	"u", /* user */
+#ifdef CONFIG_ION
 	"i", /* ion */
+#endif
 };
 
 static ssize_t bo_show(struct device *dev, struct device_attribute *attr,
-- 
2.9.3
