Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3FBjMg0003767
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 07:45:22 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3FBjASm003461
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 07:45:10 -0400
Date: Tue, 15 Apr 2008 12:45:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <480477BD.5090900@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0804151228370.5159@axis700.grange>
References: <48030F6F.1040007@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>
	<480477BD.5090900@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: OmniVision OV9655 camera chip via soc-camera interface
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

On Tue, 15 Apr 2008, Stefan Herbrechtsmeier wrote:

> Guennadi Liakhovetski schrieb:
> > 
> > Look in pxa_camera.c, e.g., in pxa_camera_activate. There are function calls
> > like
> > 
> > pxa_camera_activate(struct pxa_camera_dev *pcdev)
> > {
> > 	struct pxacamera_platform_data *pdata = pcdev->pdata;
> > 
> > ...
> > 
> > 	pdata->power(pcdev->dev, 1);
> > 
> > ...
> > 
> > 	pdata->reset(pcdev->dev, 1);
> > 
> > in it, which should do exactly what you need. And they are supposed to be
> > implemented in the platform, so, you have all the required GPIO information
> > you need there. That is exactly the reason they are defined that way -
> > because they were thought to be platform-dependent. Let me know if there's
> > still anything missing. It is still a work in progress, so, we are flexible
> > and can add any (reasonable) APIs we find useful.
> >   
> Thanks, that exact what I search, but maybe this functions should be in the
> soc_camera_link. I think this functions belong to the camera chip and not to
> the capture interface. This allows more than one camera chip on one capture
> interface with separate enable and reset.

Well, in principle, yes, I think this is a good idea. But:

1. ATM these functions are called from the camera-host (pxa-camera) 
driver. And until now it knew nothing about soc_camera_link. Which is also 
good.

   a) If we want to keep calls to these functions in the camera-host 
driver, we'll either have to let it also handle soc_camera_link, or 
introduce some parameter to these functions to tell the platform which 
camera shall be resetted / powered on or off.

   b) Alternatively, we could call these functions from soc_camera_ops 
init() and release() methods. Actually, I think, this would be the best 
option.

2. Do you have a real-life example with several cameras on one interface? 
ATM pxa_camera is explicitely limited to handle only one camera on its 
quick capture interface. You would have to lift that restriction too.

So, I think, a patch implementing 1.b could be considered.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
