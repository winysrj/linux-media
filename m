Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42BGKGE023266
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 07:16:20 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m42BG8WZ029494
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 07:16:08 -0400
Date: Fri, 2 May 2008 13:16:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <481AF6CA.9030505@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0805021314510.4920@axis700.grange>
References: <48030F6F.1040007@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>
	<480477BD.5090900@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804151228370.5159@axis700.grange>
	<481ADED1.8050201@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021143250.4920@axis700.grange>
	<481AF6CA.9030505@hni.uni-paderborn.de>
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

On Fri, 2 May 2008, Stefan Herbrechtsmeier wrote:

> Guennadi Liakhovetski schrieb:
> > > 
> > > 3. Add x_skip_left to soc_camera_device
> > > The pxa_camera has to skip some pixel at the begin of each line if a HSYNC
> > > signal is used.
> > > (y_skip_top and x_skip_left can change with each format adjustment!)
> > >     
> > 
> > How and why shall they change?
> >   
> They shall change to support both signal types and to make the names and
> function clear. The OmniVision chips
> support both types and you can configure the VSYNC pin. At the moment I used
> SOCAM_HSYNC_*
> but configure the chip to use HREF to work without pixel skipping.

Sorry, I mean why y_skip_top and x_skip_left shall change?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
