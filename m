Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34171 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaIXW14 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:56 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 09/18] [media] cx88: remove return after BUG()
Date: Wed, 24 Sep 2014 19:27:09 -0300
Message-Id: <9558d5ca24c16761b267ac700661aeaa501f1b1e.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:

drivers/media/pci/cx88/cx88-video.c:699 get_queue() info: ignoring unreachable code.
drivers/media/pci/cx88/cx88-video.c:714 get_resource() info: ignoring unreachable code.
drivers/media/pci/cx88/cx88-video.c:815 video_read() info: ignoring unreachable code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index ed8cb9037b6f..ce27e6d4f16e 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -696,7 +696,6 @@ static struct videobuf_queue *get_queue(struct file *file)
 		return &fh->vbiq;
 	default:
 		BUG();
-		return NULL;
 	}
 }
 
@@ -711,7 +710,6 @@ static int get_resource(struct file *file)
 		return RESOURCE_VBI;
 	default:
 		BUG();
-		return 0;
 	}
 }
 
@@ -812,7 +810,6 @@ video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 					    file->f_flags & O_NONBLOCK);
 	default:
 		BUG();
-		return 0;
 	}
 }
 
-- 
1.9.3

