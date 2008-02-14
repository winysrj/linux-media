Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1EAt7Ku019872
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 05:55:07 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1EAsjG2013289
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 05:54:46 -0500
Date: Thu, 14 Feb 2008 11:54:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: eric miao <eric.y.miao@gmail.com>
In-Reply-To: <f17812d70802140215p2582fdack595b9e2a2ad9c8b8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802141144430.5218@axis700.grange>
References: <Pine.LNX.4.64.0802051830360.5882@axis700.grange>
	<20080211114129.GA10482@flint.arm.linux.org.uk>
	<Pine.LNX.4.64.0802111440230.4440@axis700.grange>
	<f17812d70802122120r3f8f2c29qa70342d1bda75658@mail.gmail.com>
	<Pine.LNX.4.64.0802131346170.6252@axis700.grange>
	<f17812d70802131807o79dfa71r23f73f827fa49ea1@mail.gmail.com>
	<Pine.LNX.4.64.0802140826260.4016@axis700.grange>
	<f17812d70802140215p2582fdack595b9e2a2ad9c8b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/6] V4L2 soc_camera driver for PXA27x processors
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

On Thu, 14 Feb 2008, eric miao wrote:

> On Thu, Feb 14, 2008 at 3:43 PM, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> >
> >  But, I think, we'll have to do it differently. The two cameras you mention
> >  are two separate video-devices with my framework. So, the application will
> >  have to go to /dev/video1 from /dev/video0. And, perhaps, the camera
> >  driver (not the interface driver, like pxa-camera) will have to call back
> >  into the platform layer to activate the respective controller. How does
> >  this sound?
> 
> Yeah, I personally like the idea of having /dev/video0 and /dev/video1 for
> the two sensors, and the pxa_camera.c makes sure they will be opened
> exclusively.

In fact, it is _already_ implemented. Look at

struct pxacamera_platform_data {
	int (*init)(struct device *);
	int (*power)(struct device *, int);
	int (*reset)(struct device *, int);

	unsigned long flags;
	unsigned long mclk_10khz;
};

in include/asm-arm/arch-pxa/camera.h, but ->power() is called at probe and 
release times... Yeah, will have to change that, which will also require 
some changes to the soc-camera - camera-interface API...

Otherwise, I'll wait for your detailed comments to minimize the number of 
iterations:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
