Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56269 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752649AbZCYIhP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 04:37:15 -0400
Date: Wed, 25 Mar 2009 09:37:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] pxa-camera: simplify the .buf_queue path by merging two
 loops
In-Reply-To: <87hc1tdzv2.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0903250935090.5795@axis700.grange>
References: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-2-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-3-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-4-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903161153200.4409@axis700.grange> <87hc1tdzv2.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pxa_dma_update_sg_tail() is called only once, runs exactly the same loop as the
caller and has to recalculate the last element in an sg-list, that the caller
has already calculated. Eliminate redundancy by merging the two loops and
re-using the calculated pointer. This also saves a bit of performance which is
always good during video-capture.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

On Mon, 16 Mar 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > pxa_dma_update_sg_tail is called only here, why not inline it and also put 
> > inside one loop?
> As for the inline, I'm pretty sure you know it is automatically done by gcc.
> 
> As for moving it inside the loop, that would certainly improve performance. Yet
> I find it more readable/maintainable that way, and will leave it. But I won't be
> bothered at all if you retransform it back to your view, that's up to you.

Robert, this is what I'm going to apply on top of your patch-series. 
Please, object:-)

 drivers/media/video/pxa_camera.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index cfa113c..c639845 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -566,15 +566,6 @@ static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
 	}
 }
 
-static void pxa_dma_update_sg_tail(struct pxa_camera_dev *pcdev,
-				   struct pxa_buffer *buf)
-{
-	int i;
-
-	for (i = 0; i < pcdev->channels; i++)
-		pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
-}
-
 static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
 				 struct pxa_buffer *buf)
 {
@@ -585,12 +576,13 @@ static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
 		buf_last_desc = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
 		buf_last_desc->ddadr = DDADR_STOP;
 
-		if (!pcdev->sg_tail[i])
-			continue;
-		pcdev->sg_tail[i]->ddadr = buf->dmas[i].sg_dma;
-	}
+		if (pcdev->sg_tail[i])
+			/* Link the new buffer to the old tail */
+			pcdev->sg_tail[i]->ddadr = buf->dmas[i].sg_dma;
 
-	pxa_dma_update_sg_tail(pcdev, buf);
+		/* Update the channel tail */
+		pcdev->sg_tail[i] = buf_last_desc;
+	}
 }
 
 /**
-- 
1.5.4

