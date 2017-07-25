Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:50450 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752332AbdGYPkT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 11:40:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Petr Cvek <petr.cvek@tul.cz>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: v4l: use WARN_ON(1) instead of __WARN()
Date: Tue, 25 Jul 2017 17:39:14 +0200
Message-Id: <20170725154001.294864-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

__WARN() cannot be used in portable code, since it is only
available on some architectures and configurations:

drivers/media/platform/pxa_camera.c: In function 'pxa_mbus_config_compatible':
drivers/media/platform/pxa_camera.c:642:3: error: implicit declaration of function '__WARN'; did you mean '__WALL'? [-Werror=implicit-function-declaration]

The common way to express an unconditional warning is WARN_ON(1),
so let's use that here.

Fixes: 97bbdf02d905 ("media: v4l: Add support for CSI-1 and CCP2 busses")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/pxa_camera.c              | 2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 3898a5cd8664..0d4af6d91ffc 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -639,7 +639,7 @@ static unsigned int pxa_mbus_config_compatible(const struct v4l2_mbus_config *cf
 					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
 		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
 	default:
-		__WARN();
+		WARN_ON(1);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index 43192d80beef..0ad4b28266e4 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -509,7 +509,7 @@ unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
 					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
 		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
 	default:
-		__WARN();
+		WARN_ON(1);
 		return -EINVAL;
 	}
 	return 0;
-- 
2.9.0
