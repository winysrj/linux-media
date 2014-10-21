Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([5.45.105.125]:54080 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbaJUPIG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 11:08:06 -0400
From: Sebastian Reichel <sre@kernel.org>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Sebastian Reichel <sre@kernel.org>
Subject: [RFCv2 8/8] [media] si4713: cleanup platform data
Date: Tue, 21 Oct 2014 17:07:07 +0200
Message-Id: <1413904027-16767-9-git-send-email-sre@kernel.org>
In-Reply-To: <1413904027-16767-1-git-send-email-sre@kernel.org>
References: <1413904027-16767-1-git-send-email-sre@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unreferenced members from the platform
data's structure.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 include/media/si4713.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/media/si4713.h b/include/media/si4713.h
index 343b8fb5..be4f58e 100644
--- a/include/media/si4713.h
+++ b/include/media/si4713.h
@@ -23,9 +23,6 @@
  * Platform dependent definition
  */
 struct si4713_platform_data {
-	const char * const *supply_names;
-	unsigned supplies;
-	int gpio_reset; /* < 0 if not used */
 	bool is_platform_device;
 };
 
-- 
2.1.1

