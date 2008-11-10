Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAIi3iK029613
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 13:44:03 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAAIhbZA031064
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 13:43:38 -0500
Date: Mon, 10 Nov 2008 19:43:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: David Ellingsworth <david@identd.dyndns.org>
In-Reply-To: <30353c3d0811101009u195fb42du346ff3e0fb559b19@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811101942340.8315@axis700.grange>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
	<Pine.LNX.4.64.0811101335170.4248@axis700.grange>
	<30353c3d0811101009u195fb42du346ff3e0fb559b19@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
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

On Mon, 10 Nov 2008, David Ellingsworth wrote:

> [snip]
> > +static bool depth_supported(struct soc_camera_device *icd, int i)
> > +{
> > +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +       struct pxa_camera_dev *pcdev = ici->priv;
> > +
> > +       switch (icd->formats[i].depth) {
> > +       case 8:
> > +               if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
> > +                       return true;
> > +               return false;
> I'm not sure what the linux kernel development docs might say about
> this, but the if statement here might be unnecessary. Couldn't you
> write the following instead?
> 
> return pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8;

Indeed, a good idea, thanks, only I would do this like

	return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8);

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
