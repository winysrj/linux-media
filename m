Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45393 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118Ab0KQMO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 07:14:56 -0500
Received: by qwh6 with SMTP id 6so1695002qwh.19
        for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 04:14:56 -0800 (PST)
Subject: [PATCH]v4l: list entries no need to check
From: "Figo.zhang" <figo1802@gmail.com>
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: AChew@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 20:14:08 +0800
Message-ID: <1289996048.2730.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


list entries are not need to be inited, so it no need
for checking. 

Reported-by: Andrew Chew <AChew@nvidia.com>
Signed-off-by: Figo.zhang <figo1802@gmail.com>
---
 drivers/media/video/mx1_camera.c           |    3 ---
 drivers/media/video/pxa_camera.c           |    3 ---
 drivers/media/video/sh_mobile_ceu_camera.c |    3 ---
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 5c17f9e..cb2dd24 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -182,9 +182,6 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
-	/* Added list head initialization on alloc */
-	WARN_ON(!list_empty(&vb->queue));
-
 	BUG_ON(NULL == icd->current_fmt);
 
 	/*
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 9de7d59..421de10 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -444,9 +444,6 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
-	/* Added list head initialization on alloc */
-	WARN_ON(!list_empty(&vb->queue));
-
 #ifdef DEBUG
 	/*
 	 * This can be useful if you want to see if we actually fill
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 2b24bd0..b2bef3f 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -354,9 +354,6 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
-	/* Added list head initialization on alloc */
-	WARN_ON(!list_empty(&vb->queue));
-
 #ifdef DEBUG
 	/*
 	 * This can be useful if you want to see if we actually fill


