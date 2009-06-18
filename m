Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with SMTP id n5IGOZfR012180
	for <video4linux-list@redhat.com>; Thu, 18 Jun 2009 12:24:35 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n5IGOHXf027346
	for <video4linux-list@redhat.com>; Thu, 18 Jun 2009 12:24:17 -0400
Date: Thu, 18 Jun 2009 17:24:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ubpoxoelq.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0906181722460.7460@axis700.grange>
References: <ud49domlx.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0906091057120.4085@axis700.grange>
	<ubpoxoelq.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: [PATCH] soc-camera: fix missing clean up on error path
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

If soc_camera_init_user_formats() fails in soc_camera_probe(), we have to call
client's .remove() method to unregister the video device.

Reported-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
Hi Morimoto-san

On Tue, 9 Jun 2009, Kuninori Morimoto wrote:

> > > soc_camera_open use icd->current_fmt directly.
> > > It doesn't check if icd->current_fmt != NULL.
> > 
> > Which kernel version, resp., version of the soc-camera stack are you 
> > using? What you describe would be a bug, but it shouldn't be present 
> > neither in the soc-camera stack, converted to v4l2-subdev (see my last 
> > series of 10 patches), nor in a partially converted stack.
> 
> I use latest Paul's (for SH) git
> 
> > is present in the current mainline. There's a call to
> > 
> > 	if (icd->ops->remove)
> > 		icd->ops->remove(icd);
> > 
> > missing on the "goto eiufmt;" error path. You'd just have to insert the 
> > above call before the goto. Would you like to prepare a patch?
> 
> wow...
> why can I call soc_camera_open even if soc_camera_probe failed ?

Could you please verify that this patch fixed your problem?

 drivers/media/video/soc_camera.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 78010ab..6dc3d11 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -877,8 +877,11 @@ static int soc_camera_probe(struct device *dev)
 			(unsigned short)~0;
 
 		ret = soc_camera_init_user_formats(icd);
-		if (ret < 0)
+		if (ret < 0) {
+			if (icd->ops->remove)
+				icd->ops->remove(icd);
 			goto eiufmt;
+		}
 
 		icd->height	= DEFAULT_HEIGHT;
 		icd->width	= DEFAULT_WIDTH;
-- 
1.6.2.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
