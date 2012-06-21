Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49911 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab2FUTxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:53:35 -0400
Received: by yenl2 with SMTP id l2so879477yen.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:53:35 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	<linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 01/10] staging: solo6x10: Fix TODO file with proper maintainer
Date: Thu, 21 Jun 2012 16:52:03 -0300
Message-Id: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab is the current maintainer of staging/media.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/solo6x10/TODO |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/solo6x10/TODO b/drivers/staging/media/solo6x10/TODO
index 7e6c4fa..539f739 100644
--- a/drivers/staging/media/solo6x10/TODO
+++ b/drivers/staging/media/solo6x10/TODO
@@ -20,5 +20,5 @@ TODO (general):
 	  - implement loopback of external sound jack with incoming audio?
 	  - implement pause/resume
 
-Plase send patches to Greg Kroah-Hartman <greg@kroah.com> and Cc Ben Collins
+Plase send patches to Mauro Carvalho Chehab <mchehab@redhat.com> and Cc Ben Collins
 <bcollins@bluecherry.net>
-- 
1.7.4.4

