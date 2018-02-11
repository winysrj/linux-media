Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39810 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753092AbeBKL05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Feb 2018 06:26:57 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 1/4] media: dmxdev: fix error code for invalid ioctls
Date: Sun, 11 Feb 2018 09:26:47 -0200
Message-Id: <c82c22ce1d7ab1b8fbae258a6527508ef049ab9a.1518347588.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1518347588.git.mchehab@s-opensource.com>
References: <cover.1518347588.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1518347588.git.mchehab@s-opensource.com>
References: <cover.1518347588.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Returning -EINVAL when an ioctl is not implemented is a very
bad idea, as it is hard to distinguish from other error
contitions that an ioctl could lead. Replace it by its
right error code: -ENOTTY.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dmxdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 51676c7ad118..15847b64698b 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1160,7 +1160,7 @@ static int dvb_demux_do_ioctl(struct file *file,
 		break;
 #endif
 	default:
-		ret = -EINVAL;
+		ret = -ENOTTY;
 		break;
 	}
 	mutex_unlock(&dmxdev->mutex);
-- 
2.14.3
