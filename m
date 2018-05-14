Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:46671 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932270AbeENNNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 09:13:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] zoran: fix compiler warning
Date: Mon, 14 May 2018 15:13:41 +0200
Message-Id: <20180514131346.15795-3-hverkuil@xs4all.nl>
In-Reply-To: <20180514131346.15795-1-hverkuil@xs4all.nl>
References: <20180514131346.15795-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In file included from media-git/include/linux/bitmap.h:9,
                 from media-git/include/linux/cpumask.h:12,
                 from media-git/arch/x86/include/asm/cpumask.h:5,
                 from media-git/arch/x86/include/asm/msr.h:11,
                 from media-git/arch/x86/include/asm/processor.h:21,
                 from media-git/arch/x86/include/asm/cpufeature.h:5,
                 from media-git/arch/x86/include/asm/thread_info.h:53,
                 from media-git/include/linux/thread_info.h:38,
                 from media-git/arch/x86/include/asm/preempt.h:7,
                 from media-git/include/linux/preempt.h:81,
                 from media-git/include/linux/spinlock.h:51,
                 from media-git/include/linux/seqlock.h:36,
                 from media-git/include/linux/time.h:6,
                 from media-git/include/linux/stat.h:19,
                 from media-git/include/linux/module.h:10,
                 from media-git/drivers/staging/media/zoran/zoran_driver.c:44:
In function 'strncpy',
    inlined from 'zoran_querycap' at media-git/drivers/staging/media/zoran/zoran_driver.c:1512:2:
media-git/include/linux/string.h:246:9: warning: '__builtin_strncpy' output may be truncated copying 31 bytes from a string of length 31 [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/zoran/zoran_driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/zoran/zoran_driver.c b/drivers/staging/media/zoran/zoran_driver.c
index 14f9c0e26a1c..d2e13fffbc6b 100644
--- a/drivers/staging/media/zoran/zoran_driver.c
+++ b/drivers/staging/media/zoran/zoran_driver.c
@@ -1509,8 +1509,8 @@ static int zoran_querycap(struct file *file, void *__fh, struct v4l2_capability
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
 
-	strncpy(cap->card, ZR_DEVNAME(zr), sizeof(cap->card)-1);
-	strncpy(cap->driver, "zoran", sizeof(cap->driver)-1);
+	strlcpy(cap->card, ZR_DEVNAME(zr), sizeof(cap->card));
+	strlcpy(cap->driver, "zoran", sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(zr->pci_dev));
 	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE |
-- 
2.17.0
