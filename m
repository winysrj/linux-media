Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38543 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708Ab0EOQpk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 12:45:40 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <1273941831.2564.29.camel@localhost>
References: <1273941831.2564.29.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 15 May 2010 17:45:37 +0100
Message-ID: <1273941937.2564.31.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 2/4] V4L/DVB: budget: Select correct frontends
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the Kconfig selections to match the code.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/ttpci/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/ttpci/Kconfig b/drivers/media/dvb/ttpci/Kconfig
index d8d4214..32a7ec6 100644
--- a/drivers/media/dvb/ttpci/Kconfig
+++ b/drivers/media/dvb/ttpci/Kconfig
@@ -68,13 +68,14 @@ config DVB_BUDGET
 	select DVB_VES1820 if !DVB_FE_CUSTOMISE
 	select DVB_L64781 if !DVB_FE_CUSTOMISE
 	select DVB_TDA8083 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10021 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1420 if !DVB_FE_CUSTOMISE
 	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
 	select DVB_TDA826X if !DVB_FE_CUSTOMISE
 	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
 	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
+	select DVB_ISL6423 if !DVB_FE_CUSTOMISE
+	select DVB_STV090x if !DVB_FE_CUSTOMISE
+	select DVB_STV6110x if !DVB_FE_CUSTOMISE
 	help
 	  Support for simple SAA7146 based DVB cards (so called Budget-
 	  or Nova-PCI cards) without onboard MPEG2 decoder, and without
-- 
1.7.1



