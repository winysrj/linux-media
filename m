Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46147 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbeJLWVZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 18:21:25 -0400
From: Colin King <colin.king@canonical.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] exynos4-is: fix spelling mistake ACTURATOR -> ACTUATOR
Date: Fri, 12 Oct 2018 15:48:32 +0100
Message-Id: <20181012144832.20722-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in macro name and text string
ERROR_SENSOR_ACTURATOR_INIT_FAIL -> ERROR_SENSOR_ACTUATOR_INIT_FAIL

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/exynos4-is/fimc-is-errno.c | 4 ++--
 drivers/media/platform/exynos4-is/fimc-is-errno.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-errno.c b/drivers/media/platform/exynos4-is/fimc-is-errno.c
index e050e63fe358..bbb08576492e 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-errno.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-errno.c
@@ -90,8 +90,8 @@ const char *fimc_is_param_strerr(unsigned int error)
 		return "ERROR_SENSOR_INVALID_SIZE";
 	case ERROR_SENSOR_INVALID_SETTING:
 		return "ERROR_SENSOR_INVALID_SETTING";
-	case ERROR_SENSOR_ACTURATOR_INIT_FAIL:
-		return "ERROR_SENSOR_ACTURATOR_INIT_FAIL";
+	case ERROR_SENSOR_ACTUATOR_INIT_FAIL:
+		return "ERROR_SENSOR_ACTUATOR_INIT_FAIL";
 	case ERROR_SENSOR_INVALID_AF_POS:
 		return "ERROR_SENSOR_INVALID_AF_POS";
 	case ERROR_SENSOR_UNSUPPORT_FUNC:
diff --git a/drivers/media/platform/exynos4-is/fimc-is-errno.h b/drivers/media/platform/exynos4-is/fimc-is-errno.h
index ef981e74513a..77f4fc860be5 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-errno.h
+++ b/drivers/media/platform/exynos4-is/fimc-is-errno.h
@@ -189,7 +189,7 @@ enum fimc_is_error {
 	ERROR_SENSOR_INVALID_EXPOSURETIME,
 	ERROR_SENSOR_INVALID_SIZE,
 	ERROR_SENSOR_INVALID_SETTING,
-	ERROR_SENSOR_ACTURATOR_INIT_FAIL,
+	ERROR_SENSOR_ACTUATOR_INIT_FAIL,
 	ERROR_SENSOR_INVALID_AF_POS,
 	ERROR_SENSOR_UNSUPPORT_FUNC,
 	ERROR_SENSOR_UNSUPPORT_PERI,
-- 
2.17.1
