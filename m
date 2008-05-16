Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4G9TN7Y026790
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 05:29:23 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4G9TBN9023270
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 05:29:12 -0400
Date: Fri, 16 May 2008 11:29:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <482D4BC7.7020409@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0805161117520.3714@axis700.grange>
References: <365592.144287319-sendEmail@carolinen>
	<Pine.LNX.4.64.0805061520250.5880@axis700.grange>
	<482D4BC7.7020409@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add x_skip_left to soc_camera_device
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

Hi Stefan,

On Fri, 16 May 2008, Stefan Herbrechtsmeier wrote:

> Sorry for the late answer, but I have to rework my driver.
> 
> Guennadi Liakhovetski schrieb:
> > I think, this is all we need for now - small and nice. Actually, it would
> > make even more sense to submit this when your new camera driver is ready,
> > but if you prefer, I'll accept it now. Just, please, resubmit it without the
> > above two hunks, and, maybe, add a sentence to the patch comment, saying
> > "will be used in xxx driver."
> >   
> Because of problems with the HSYNC support for different resolutions, I
> skipped it.
> I remove the HSYNC specific code (configuration of HSYNC or HREF) and
> only used HREF as signal. This makes this Patch obsolete for now.
> 
> Should I skip it or resubmit it for further use?

I think, reviewing and testing of patches is easier, if they either 1) fix 
bugs that can either be reproduced with currently supported 
configurations, or can be proven by studying the code; or 2) implement 
improvements, that can be verified with currently supported 
configurations; or 3) implement new features, that can be tested with 
currently or newly supported configurations. As you see, new features 
(x_skip_left support is a new feature), that cannot be tested are not in 
the above list:-)

So, I think, it would be easier for you and for reviewers, if you submit 
your new driver together with any necessary supporting modifications to 
the existing code, when you are reasonably happy with your results. 
Agree?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
