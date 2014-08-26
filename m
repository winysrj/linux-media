Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44170 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 20/35] [media] fimc-is-param: get rid of warnings
Date: Tue, 26 Aug 2014 18:54:56 -0300
Message-Id: <1409090111-8290-21-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In file included from drivers/media/platform/exynos4-is/fimc-is-param.c:31:0:
drivers/media/platform/exynos4-is/fimc-is-errno.h:245:20: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const char * const fimc_is_strerr(unsigned int error);
                    ^
drivers/media/platform/exynos4-is/fimc-is-errno.h:246:20: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const char * const fimc_is_param_strerr(unsigned int error);
                    ^
drivers/media/platform/exynos4-is/fimc-is-param.c: In function 'fimc_is_set_initial_params':
drivers/media/platform/exynos4-is/fimc-is-param.c:670:23: warning: variable 'sensor' set but not used [-Wunused-but-set-variable]
  struct sensor_param *sensor;
                       ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-errno.c | 4 ++--
 drivers/media/platform/exynos4-is/fimc-is-errno.h | 4 ++--
 drivers/media/platform/exynos4-is/fimc-is-param.c | 2 --
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-errno.c b/drivers/media/platform/exynos4-is/fimc-is-errno.c
index e8519e151c1a..e050e63fe358 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-errno.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-errno.c
@@ -15,7 +15,7 @@
 
 #include "fimc-is-errno.h"
 
-const char * const fimc_is_param_strerr(unsigned int error)
+const char *fimc_is_param_strerr(unsigned int error)
 {
 	switch (error) {
 	case ERROR_COMMON_CMD:
@@ -146,7 +146,7 @@ const char * const fimc_is_param_strerr(unsigned int error)
 	}
 }
 
-const char * const fimc_is_strerr(unsigned int error)
+const char *fimc_is_strerr(unsigned int error)
 {
 	error &= ~IS_ERROR_TIME_OUT_FLAG;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is-errno.h b/drivers/media/platform/exynos4-is/fimc-is-errno.h
index 3de6f6da6f87..ef981e74513a 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-errno.h
+++ b/drivers/media/platform/exynos4-is/fimc-is-errno.h
@@ -242,7 +242,7 @@ enum fimc_is_error {
 	ERROR_SCALER_FLIP				= 521,
 };
 
-const char * const fimc_is_strerr(unsigned int error);
-const char * const fimc_is_param_strerr(unsigned int error);
+const char *fimc_is_strerr(unsigned int error);
+const char *fimc_is_param_strerr(unsigned int error);
 
 #endif /* FIMC_IS_ERR_H_ */
diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
index bf1465d1bf6d..72b9b436c5c0 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
@@ -667,7 +667,6 @@ void __is_set_fd_config_orientation_val(struct fimc_is *is, u32 val)
 void fimc_is_set_initial_params(struct fimc_is *is)
 {
 	struct global_param *global;
-	struct sensor_param *sensor;
 	struct isp_param *isp;
 	struct drc_param *drc;
 	struct fd_param *fd;
@@ -676,7 +675,6 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 
 	index = is->config_index;
 	global = &is->config[index].global;
-	sensor = &is->config[index].sensor;
 	isp = &is->config[index].isp;
 	drc = &is->config[index].drc;
 	fd = &is->config[index].fd;
-- 
1.9.3

