Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52471 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZKZACo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 19:02:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH/RFC v2] V4L core cleanups HG tree
Date: Thu, 26 Nov 2009 01:02:40 +0100
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@infradead.org, sakari.ailus@maxwell.research.nokia.com
References: <200911181354.06529.laurent.pinchart@ideasonboard.com> <829197380911251506g4af4d72v85c6dfb55cb88d0a@mail.gmail.com>
In-Reply-To: <829197380911251506g4af4d72v85c6dfb55cb88d0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911260102.40881.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Thursday 26 November 2009 00:06:40 Devin Heitmueller wrote:
> On Wed, Nov 18, 2009 at 7:54 AM, Laurent Pinchart
> 
> <laurent.pinchart@ideasonboard.com> wrote:
> > Hi everybody,
> >
> > the V4L cleanup patches are now available from
> >
> > http://linuxtv.org/hg/~pinchartl/v4l-dvb-cleanup
> >
> > The tree will be rebased if needed (or rather dropped and recreated as hg
> > doesn't provide a rebase operation), so please don't pull from it yet if
> > you don't want to have to throw the patches away manually later.
> >
> > I've incorporated the comments received so far and went through all the
> > patches to spot bugs that could have sneaked in.
> >
> > Please test the code against the driver(s) you maintain. The changes are
> > small, *should* not create any issue, but the usual bug can still sneak
> > in.
> >
> > I can't wait for an explicit ack from all maintainers (mostly because I
> > don't know you all), so I'll send a pull request in a week if there's no
> > blocking issue. I'd like this to get in 2.6.33 if possible.
> >
> > --
> > Regards,
> >
> > Laurent Pinchart
> 
> Hi Laurent,
> 
> Well, I don't know what is wrong yet, but the au0828 driver now hits
> an OOPS with this tree whenever the device is disconnected, whereas
> with last night's v4l-dvb tip it was working fine.
> 
> I'll dig into it now...

Thank you very much for the report. Could you please try with the following
patch applied on top of the v4l-dvb-cleanup tree ?

diff -r 98e3929a1a2d linux/drivers/media/video/au0828/au0828-video.c
--- a/linux/drivers/media/video/au0828/au0828-video.c	Wed Nov 25 12:55:47 2009 +0100
+++ b/linux/drivers/media/video/au0828/au0828-video.c	Thu Nov 26 01:02:15 2009 +0100
@@ -697,10 +697,8 @@
 	dprintk(1, "au0828_release_resources called\n");
 	mutex_lock(&au0828_sysfs_lock);
 
-	if (dev->vdev) {
-		list_del(&dev->au0828list);
+	if (dev->vdev)
 		video_unregister_device(dev->vdev);
-	}
 	if (dev->vbi_dev)
 		video_unregister_device(dev->vbi_dev);
 
@@ -1671,7 +1669,6 @@
 	if (retval != 0) {
 		dprintk(1, "unable to register video device (error = %d).\n",
 			retval);
-		list_del(&dev->au0828list);
 		video_device_release(dev->vdev);
 		return -ENODEV;
 	}
@@ -1683,7 +1680,6 @@
 	if (retval != 0) {
 		dprintk(1, "unable to register vbi device (error = %d).\n",
 			retval);
-		list_del(&dev->au0828list);
 		video_device_release(dev->vbi_dev);
 		video_device_release(dev->vdev);
 		return -ENODEV;
diff -r 98e3929a1a2d linux/drivers/media/video/au0828/au0828.h
--- a/linux/drivers/media/video/au0828/au0828.h	Wed Nov 25 12:55:47 2009 +0100
+++ b/linux/drivers/media/video/au0828/au0828.h	Thu Nov 26 01:02:15 2009 +0100
@@ -192,7 +192,6 @@
 	struct au0828_dvb		dvb;
 
 	/* Analog */
-	struct list_head au0828list;
 	struct v4l2_device v4l2_dev;
 	int users;
 	unsigned int stream_on:1;	/* Locks streams */

-- 
Regards,

Laurent Pinchart
