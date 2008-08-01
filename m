Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m717jVi7008317
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 03:45:32 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m717jJIH007747
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 03:45:20 -0400
Date: Fri, 1 Aug 2008 09:45:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <4892BCD8.4010102@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0808010940400.14927@axis700.grange>
References: <294f0a37c4feadf87bf8.1217484144@carolinen.hni.uni-paderborn.de>
	<48917CB5.6000304@teltonika.lt> <4892A90B.7080309@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808010820560.14927@axis700.grange>
	<4892BCD8.4010102@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [PATCH] Move .power and .reset from soc_camera platform to
 sensor driver
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

On Fri, 1 Aug 2008, Stefan Herbrechtsmeier wrote:

> Guennadi Liakhovetski schrieb:
> > 
> > As for calling either platform-provided reset or internal one. Actually,
> > whyt about making platform reset (and power too) return an error code, and
> > if it failed call th internal one? 
> At the moment I assume that reset and power will work, if they are defined,
> but we can change it.

I'd rather preserve the possibility to use "soft" reset / poweroff also 
when a platform function is defined. In fact, it might be even better to 
do a soft power-off first and then call platform-provided one. Don't think 
it would make much sense for reset though.

> > And as a parameter wouldn't it make more sense to pass the soc_camera_link
> > to the platform functions instead of the struct device from the i2c device?
> >   
> I have simple make the function similar to other platform_data functions on my
> system.
> At the moment I use the parameter only for printing messages via dev_err.

You have to be able to trace which camera has to be resetted / powered on 
or off in your platform code, and the camera_link structure is the object 
that identifies a specific camera, ot, at least, it can be. Whereas the 
device pointer doesn't easily tell you which camera you want to operate 
upon.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
