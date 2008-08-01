Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m716PKeT007032
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 02:25:20 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m716P8Th000845
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 02:25:09 -0400
Date: Fri, 1 Aug 2008 08:25:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <4892A90B.7080309@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0808010820560.14927@axis700.grange>
References: <294f0a37c4feadf87bf8.1217484144@carolinen.hni.uni-paderborn.de>
	<48917CB5.6000304@teltonika.lt> <4892A90B.7080309@hni.uni-paderborn.de>
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

> Paulius Zaleckas schrieb:
> > Stefan Herbrechtsmeier wrote:
> > > Move .power (enable_camera, disable_camera) and .reset from soc_camera
> > > platform driver (pxa_camera_platform_data, sh_mobile_ceu_info) to sensor
> > > driver (soc_camera_link) and add .init and .release to request and free
> > > gpios.
> > > 
> > > Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
> > 
> > While I agree that it is good to move .power and .reset to
> > soc_camera_link... IMHO controlling of these should be left in
> > host driver.
> How should we deal with the register based version of this functions (soft
> reset)?
> At the moment we reset the sensors twice, if we use a hardware reset (.reset).

Paulius, can you give any specific reason why you think, calling those 
functions from the host driver would be better?

As for calling either platform-provided reset or internal one. Actually, 
whyt about making platform reset (and power too) return an error code, and 
if it failed call th internal one? And as a parameter wouldn't it make 
more sense to pass the soc_camera_link to the platform functions instead 
of the struct device from the i2c device?

I'll have a better look at your patch this WE, so, you don't have to be in 
a hurry with a new version:-) I probably will have some more comments. 
These are just a couple to think about.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
