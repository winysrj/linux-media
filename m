Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930Ab2HONsZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:25 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FDmP20019196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 09:48:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/12] [media] mmc/Kconfig: Improve driver name for siano mmc/sdio driver
Date: Wed, 15 Aug 2012 10:48:16 -0300
Message-Id: <1345038500-28734-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345038500-28734-1-git-send-email-mchehab@redhat.com>
References: <502AC079.50902@gmail.com>
 <1345038500-28734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/mmc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/mmc/Kconfig b/drivers/media/mmc/Kconfig
index 0f2a957..8c30ada 100644
--- a/drivers/media/mmc/Kconfig
+++ b/drivers/media/mmc/Kconfig
@@ -1 +1,2 @@
+comment "Supported MMC/SDIO adapters"
 source "drivers/media/mmc/siano/Kconfig"
-- 
1.7.11.2

