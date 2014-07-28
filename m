Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaG1SH2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 14:07:28 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] rc-main: allow raw protocol drivers to restrict the allowed protos
Date: Mon, 28 Jul 2014 15:07:20 -0300
Message-Id: <1406570842-26316-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406570842-26316-1-git-send-email-m.chehab@samsung.com>
References: <1406570842-26316-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some hardware (au0828/au8522), the hardware is broken with
regards to the initial pulse detection. So, the driver needs to
produce a fake start pulse. That limits the acceptable protocols,
as it is not possible to produce a fake pulse that would cover
all supported protocols.

So, allow the driver to explicitly set the allowed protocols.

If the driver doesn't specify, keep the old behavior.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/rc/rc-main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index dfceeb4e34a8..a7991c7d010a 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -859,10 +859,9 @@ static ssize_t show_protocols(struct device *device,
 
 	if (fattr->type == RC_FILTER_NORMAL) {
 		enabled = dev->enabled_protocols;
-		if (dev->raw)
+		allowed = dev->allowed_protocols;
+		if (dev->raw && !allowed)
 			allowed = ir_raw_get_allowed_protocols();
-		else
-			allowed = dev->allowed_protocols;
 	} else {
 		enabled = dev->enabled_wakeup_protocols;
 		allowed = dev->allowed_wakeup_protocols;
-- 
1.9.3

