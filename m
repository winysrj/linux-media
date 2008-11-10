Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAKNLVB026433
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 15:23:22 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAAKMhLg030594
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 15:22:53 -0500
Date: Mon, 10 Nov 2008 21:22:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <874p2f9yv1.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811102116550.8315@axis700.grange>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
	<Pine.LNX.4.64.0811101335170.4248@axis700.grange>
	<30353c3d0811101009u195fb42du346ff3e0fb559b19@mail.gmail.com>
	<Pine.LNX.4.64.0811101942340.8315@axis700.grange>
	<874p2f9yv1.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [PATCH 5/5] pxa-camera: framework to handle camera-native and
 synthesized formats
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

On Mon, 10 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Indeed, a good idea, thanks, only I would do this like
> >
> > 	return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8);
> You're using it 2 times, and with a if (!depth_supported()), that's overkill.
> Wouldn't it be better for that function to return 0 for false, and "not 0" for
> true ? That's what was done for gpio API (check gpio_get_value()) ...
> 
> I would definitely drop the purely boolean part, I don't think it brings
> anything here (the function name is already very clear, isn't it ? :))

The idea behind "!!x" is, that the compiler should be smart enough to drop 
this and to just convert this to "x!=0", whereas "!!x" has the advantage 
of pointing out to treating "x" as boolean, and in "x!=0" it is compared 
against a number, or some such. In any case, I haven't invented it, I 
remember it being discussed on lkml and the opinion about it was pretty 
positive. So, if this hasn't changed since then, it should be fine:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
