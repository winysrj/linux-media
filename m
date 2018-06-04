Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:36723 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752453AbeFDMr6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 08:47:58 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.18] media/radio/Kconfig: add back RADIO_ISA
Message-ID: <dd581ad9-6dd2-a6a7-4c03-bfff17c2cfdf@xs4all.nl>
Date: Mon, 4 Jun 2018 14:47:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch 258c524bdaab inadvertently removed the 'select RADIO_ISA' line for
the RADIO_RTRACK.

Fixes: 258c524bdaab ("radio: allow building ISA drivers with COMPILE_TEST")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 8fa403c7149e..39b04ad924c0 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -257,6 +257,7 @@ config RADIO_RTRACK
 	tristate "AIMSlab RadioTrack (aka RadioReveal) support"
 	depends on ISA || COMPILE_TEST
 	depends on VIDEO_V4L2
+	select RADIO_ISA
 	---help---
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address below.
