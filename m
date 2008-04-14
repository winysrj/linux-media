Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3EKUuEm015688
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 16:30:56 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3EKUiJr023407
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 16:30:44 -0400
Date: Mon, 14 Apr 2008 22:30:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <48030F6F.1040007@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0804142224570.5332@axis700.grange>
References: <48030F6F.1040007@hni.uni-paderborn.de>
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

On Mon, 14 Apr 2008, Stefan Herbrechtsmeier wrote:

> I'm writing a driver for the OmniVision OV9655 camera chip connected to a
> PXA270 processor. I based my work on the soc_camera interface, but I need some
> additional gpios for reset and power_enable. What is the best way to pass this
> information to the driver?

Look in pxa_camera.c, e.g., in pxa_camera_activate. There are function calls like

pxa_camera_activate(struct pxa_camera_dev *pcdev)
{
	struct pxacamera_platform_data *pdata = pcdev->pdata;

...

	pdata->power(pcdev->dev, 1);

...

	pdata->reset(pcdev->dev, 1);

in it, which should do exactly what you need. And they are supposed to be 
implemented in the platform, so, you have all the required GPIO 
information you need there. That is exactly the reason they are defined 
that way - because they were thought to be platform-dependent. Let me know 
if there's still anything missing. It is still a work in progress, so, we 
are flexible and can add any (reasonable) APIs we find useful.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
