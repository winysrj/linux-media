Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UMJhZR011927
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 18:19:43 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6UMJV9u019189
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 18:19:32 -0400
Date: Thu, 31 Jul 2008 00:19:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87iqun2ge3.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0807310008190.26534@axis700.grange>
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0807270155020.29126@axis700.grange>
	<878wvnkd8n.fsf@free.fr>
	<Pine.LNX.4.64.0807271337270.1604@axis700.grange>
	<87tze997uu.fsf@free.fr>
	<Pine.LNX.4.64.0807291902200.17188@axis700.grange>
	<87iqun2ge3.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
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

On Wed, 30 Jul 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> >> >> For the camera part, by now, I'm using standard suspend/resume functions of the
> >> >> platform driver (mt9m111.c). It does work, but it's not clean ATM. The chaining
> >> >> between the driver resume function and the availability of the I2C bus are not
> >> >> properly chained. I'm still working on it.
> >> >
> >> > Yes, we have to clarify this too.
> All right, I have my mind clarified, let's discuss now.
> 
> >>  - I cook up a clean suspend/resume (unless you did it first of course :)
> Well, let's expose what we're facing here :
>  - our video chip driver (ex: mt9m111) is an i2c driver
>   => its resume function is called when i2c bus is resumed, so all is fine here
> 
>  - our video chip needs an external clock to work
>   => example: mt9m111 needs a clock from pxa camera interface to have its i2c
>   unit enabled
>   => the mt9m111 driver resume function is unusable, as pxa_camera is resumed
>   _after_ mt9m111, and thus mt9m111's i2c unit is not available at that moment
> 
>  - a working suspend/resume restores fully the video chip state
>   => restores width/height/bpp
>   => restores autoexposure, brightness, etc ...
>   => all that insures userland is not impacted by suspend/resume
> 
> So, the only way I see to have suspend/resume working is :
>  - modify soc_camera_ops to add suspend and resume functions
>  - add suspend and resume functions in each chip driver (mt9m001, mt9m111, ...)
>  - modify soc_camera.c (or pxa_camera.c ?) to call icd->ops->suspend() and
>  icd->ops->resume()
>  - modify pxa_camera.c (the patch I sent before)
> 
> Would you find that acceptable, or is there a better way ?

Ok, you're suggesting to add suspend() and resume() to 
soc_camera_bus_type, right? But are we sure that its resume will be called 
after both camera (so far i2c) and host (so far platform, can also be PCI 
or USB...) busses are resumed? If not, we might have to do something 
similar to scan_add_host() / scan_add_device() - accept signals from the 
host and the camera and when both are ready actually resume them...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
