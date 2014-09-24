Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34122 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaIXW1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 10/18] [media] saa7146: remove return after BUG()
Date: Wed, 24 Sep 2014 19:27:10 -0300
Message-Id: <4fbed71f6d202e5e5fb1f9c21eeeefa446f4eba7.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/common/saa7146/saa7146_fops.c:314 fops_mmap() info: ignoring unreachable code.
	drivers/media/common/saa7146/saa7146_fops.c:402 fops_read() info: ignoring unreachable code.
	drivers/media/common/saa7146/saa7146_fops.c:426 fops_write() info: ignoring unreachable code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index 6c47f3fe9b0f..b7d63933dae6 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -311,7 +311,6 @@ static int fops_mmap(struct file *file, struct vm_area_struct * vma)
 		}
 	default:
 		BUG();
-		return 0;
 	}
 
 	if (mutex_lock_interruptible(vdev->lock))
@@ -399,7 +398,6 @@ static ssize_t fops_read(struct file *file, char __user *data, size_t count, lof
 		return -EINVAL;
 	default:
 		BUG();
-		return 0;
 	}
 }
 
@@ -423,7 +421,6 @@ static ssize_t fops_write(struct file *file, const char __user *data, size_t cou
 		return -EINVAL;
 	default:
 		BUG();
-		return -EINVAL;
 	}
 }
 
-- 
1.9.3

