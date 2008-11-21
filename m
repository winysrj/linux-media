Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALK3JWr001544
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 15:03:19 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mALK36ew009034
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 15:03:06 -0500
Date: Fri, 21 Nov 2008 21:03:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <8763mg28bf.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811212051360.8956@axis700.grange>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<Pine.LNX.4.64.0811182010460.8628@axis700.grange>
	<87y6zf76aw.fsf@free.fr>
	<Pine.LNX.4.64.0811202055210.8290@axis700.grange>
	<8763mg28bf.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2 v3] pxa-camera: pixel format negotiation
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

Hi Robert,

On Fri, 21 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> >> If we're in pass-through mode, and depth is 16 (example: a today unknown RYB
> >> format), we return -EINVAL. Is that on purpose ?
> >
> > Yes, I do not know how to pass a 16-bit format in a pass-through mode, and 
> > I don't have a test-case for it. Do you?
> BYR2 I think (12bit Bayer in 16bit words), and Bxxx (10bit Bayer in 16bit
> words).
> 
> And I can test the 10bit Bayer on 16bit words on mt9m111, and will do.

Wait, don't understand. 10-bit Bayer should have depth = 10, so it will 
pass. 12-bit Bayer will have depth 12 and will not pass, and I do not know 
how we can accept it on PXA27x.

> > I know this code repeats, and it is not nice. But as I was writing it I 
> > didn't see another possibility. Or more precisely, I did see it, but I 
> > couldn't compare the two versions well without having at least one of them 
> > in code in front of my eyes:-) Now that I see it, I think, yes, there is a 
> > way to do this only once by using a translation struct similar to what you 
> > have proposed. Now _this_ would be a possibly important advantage, so it 
> > is useful not _only_ for debugging:-) But we would have to extend it with 
> > at least a buswidth. Like
> >
> > 	const struct soc_camera_data_format *cam_fmt;
> > 	const struct soc_camera_data_format *host_fmt;
> > 	unsigned char buswidth;
> >
> > Now this _seems_ to provide the complete information so far... In 
> > pxa_camera_get_formats() we would
> >
> > 1. compute camera- and host-formats and buswidth
> > 2. call pxa_camera_try_bus_param() to check bus-parameter compatibility
> >
> > and then in try_fmt() and set_fmt() just traverse the list of translation 
> > structs and adjust geometry?
> That sounds great. I'm on it.
> 
> >> All in all, I wonder why we need that many tests, and if we could reduce them at
> >> format generation (under hypothesis that platform_flags are constant and sensor
> >> flags are constant).
> >
> > Ok, I propose you make the next round:-) I would be pleased if you base 
> > your new patches on these my two, and just replace the user_formats with a 
> > translation list, and modify pxa try_fmt() and set_fmt() as discussed 
> > above. I would be quite happy if you mark them "From: <you>". Or if you do 
> > not want to - let me know, I'll do it. And please do not make 13 patches 
> > this time:-) I think, two should be enough.
> I'll be happy to make the next round.
> 
> Give me a couple of days, and I'll post the 2 patches, on top of your serie
> (serie which will end with your 2 patches). After review, you can either merge
> each one of them with yours, or take them apart.
> 
> Don't worry, I won't flood the list anymore :)

Good, I think, we can use the next week, as long as Linus is scuba 
diving, to finish this transition:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
