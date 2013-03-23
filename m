Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3CWMfV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 08:35:21 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2NCZIHU028731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 08:35:18 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 3/4] [media] cx23885: use IS_ENABLED
Date: Sat, 23 Mar 2013 09:35:10 -0300
Message-Id: <1364042111-24708-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364042111-24708-1-git-send-email-mchehab@redhat.com>
References: <1364042111-24708-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking everywhere there for 3 symbols, use instead
IS_ENABLED macro.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx23885/altera-ci.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/altera-ci.h b/drivers/media/pci/cx23885/altera-ci.h
index 70e4fd6..4998c96 100644
--- a/drivers/media/pci/cx23885/altera-ci.h
+++ b/drivers/media/pci/cx23885/altera-ci.h
@@ -24,6 +24,8 @@
 #ifndef __ALTERA_CI_H
 #define __ALTERA_CI_H
 
+#include <linux/kconfig.h>
+
 #define ALT_DATA	0x000000ff
 #define ALT_TDI		0x00008000
 #define ALT_TDO		0x00004000
@@ -41,8 +43,7 @@ struct altera_ci_config {
 	int (*fpga_rw) (void *dev, int ad_rg, int val, int rw);
 };
 
-#if defined(CONFIG_MEDIA_ALTERA_CI) || (defined(CONFIG_MEDIA_ALTERA_CI_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_ALTERA_CI)
 
 extern int altera_ci_init(struct altera_ci_config *config, int ci_nr);
 extern void altera_ci_release(void *dev, int ci_nr);
-- 
1.8.1.4

