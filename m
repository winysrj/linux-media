Return-path: <mchehab@gaivota>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48563 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab0KFVdt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Nov 2010 17:33:49 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michal Marek <mmarek@suse.cz>,
	Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 4/5] media/video: convert Kconfig to use the menu's `visible' keyword
Date: Sat,  6 Nov 2010 17:30:26 -0400
Message-Id: <1289079027-3037-5-git-send-email-lacombar@gmail.com>
In-Reply-To: <4CD300AC.3010708@redhat.com>
References: <4CD300AC.3010708@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 drivers/media/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ac16e81..6830d28 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -112,7 +112,7 @@ config VIDEO_IR_I2C
 #
 
 menu "Encoders/decoders and other helper chips"
-	depends on !VIDEO_HELPER_CHIPS_AUTO
+	visible if !VIDEO_HELPER_CHIPS_AUTO
 
 comment "Audio decoders"
 
-- 
1.7.2.30.gc37d7.dirty

