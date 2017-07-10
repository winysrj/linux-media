Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33772 "EHLO
        mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753245AbdGJSmd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 14:42:33 -0400
From: Mark Brown <broonie@kernel.org>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: Mark Brown <broonie@kernel.org>, broonie@kernel.org,
        hverkuil@xs4all.nl, mattw@codeaurora.org, mitchelh@codeaurora.org,
        akpm@linux-foundation.org, yamada.masahiro@socionext.com,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, chris.paterson2@renesas.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20170613133348.48044-3-ramesh.shanmugasundaram@bp.renesas.com>
Message-Id: <E1dUddS-0000GS-Sk@debutante>
Date: Mon, 10 Jul 2017 19:42:18 +0100
Subject: Applied "regmap: Avoid namespace collision within macro & tidy up" to the regmap tree
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch

   regmap: Avoid namespace collision within macro & tidy up

has been applied to the regmap tree at

   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git 

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

>From 780b1350d316fda28d85fcae17854c778d89cbbe Mon Sep 17 00:00:00 2001
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Date: Mon, 3 Jul 2017 12:04:21 +0100
Subject: [PATCH] regmap: Avoid namespace collision within macro & tidy up

Renamed variable "timeout" to "__timeout" & "pollret" to "__ret" to
avoid namespace collision. Tidy up macro arguments with parentheses.

Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 include/linux/regmap.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e88649225a60..6e1df5e721a9 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -120,23 +120,24 @@ struct reg_sequence {
  */
 #define regmap_read_poll_timeout(map, addr, val, cond, sleep_us, timeout_us) \
 ({ \
-	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
-	int pollret; \
+	ktime_t __timeout = ktime_add_us(ktime_get(), timeout_us); \
+	int __ret; \
 	might_sleep_if(sleep_us); \
 	for (;;) { \
-		pollret = regmap_read((map), (addr), &(val)); \
-		if (pollret) \
+		__ret = regmap_read((map), (addr), &(val)); \
+		if (__ret) \
 			break; \
 		if (cond) \
 			break; \
-		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
-			pollret = regmap_read((map), (addr), &(val)); \
+		if ((timeout_us) && \
+		    ktime_compare(ktime_get(), __timeout) > 0) { \
+			__ret = regmap_read((map), (addr), &(val)); \
 			break; \
 		} \
 		if (sleep_us) \
-			usleep_range((sleep_us >> 2) + 1, sleep_us); \
+			usleep_range(((sleep_us) >> 2) + 1, sleep_us); \
 	} \
-	pollret ?: ((cond) ? 0 : -ETIMEDOUT); \
+	__ret ?: ((cond) ? 0 : -ETIMEDOUT); \
 })
 
 #ifdef CONFIG_REGMAP
-- 
2.13.2
