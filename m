Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARNDEU8020739
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 18:13:14 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mARNCxFV004716
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 18:12:59 -0500
Date: Fri, 28 Nov 2008 00:13:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87ljv4506r.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811280000250.8230@axis700.grange>
References: <Pine.LNX.4.64.0811202055210.8290@axis700.grange>
	<1227554928-25471-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811251914260.6290@axis700.grange>
	<87ljv4506r.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 1/2] soc_camera: add format translation structure
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

On Thu, 27 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Well, no. You cannot do this - not in this patch. In general, I guess, you 
> > want current_fmt to point to the xlate object for debugging, etc. But this 
> > has to be a separate patch, changing the define in the header, 
> > soc_camera.c and _all_ host-drivers, including SuperH, which you left 
> > broken with your two patches. So, please leave current_fmt at its old 
> > meaning for these two patches. We can convert it later - if we really want 
> > to.
> As you wish. I reverted that.

No, this is not just my wish, this is a requirement - we should not break 
compilation. If we change API we can either

1. change API and all users in one patch

or

2. add new API, in following patches slowly convert existing users, at 
last remove the old API.

> > A review to the pxa-patch will follow later...
> All right. I'm waiting for the second review to post both patches
> amended. Meanwhile, I'll always keep the 2 patches state here :
> http://belgarath.falguerolles.org/download/for_guennadi/
> 
> This is the place where the 2 patches are, in their newest form (the merged
> version from you and me). I took the liberty to cosign the patches, up to you to
> remove either mine, or yours, or rewrite a part of the patch, to your will.

In your 0001-soc-camera-pixel-format-negotiation-core-support.patch patch 
there one place doesn't look right:

+	icd->current_fmt = &icd->formats[0];

I think, we really want

+	icd->current_fmt = icd->user_formats[0].host_fmt;

icd->formats[0] might not be supported at all. As for Sobs - I anyway have 
to add mine as I pull them via the soc-camera tree. And as you submit them 
you'll use your "From:" line, right?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
