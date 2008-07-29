Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6THEAoT027992
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 13:14:10 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6THDwK8010012
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 13:13:58 -0400
Date: Tue, 29 Jul 2008 19:14:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <481F0BFA.7010306@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0807291909510.17188@axis700.grange>
References: <48030F6F.1040007@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>
	<480477BD.5090900@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804151228370.5159@axis700.grange>
	<481ADED1.8050201@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021143250.4920@axis700.grange>
	<481AF6CA.9030505@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021314510.4920@axis700.grange>
	<481AFB30.5070508@hni.uni-paderborn.de>
	<481B3D2F.80203@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805022059090.31894@axis700.grange>
	<481F0BFA.7010306@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Some suggestions for the soc_camera interface
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

On Mon, 5 May 2008, Stefan Herbrechtsmeier wrote:

> Guennadi Liakhovetski schrieb:
> > 
> > So, I would say, patches 1 and 3 look useful to me. Please fix formatting
> > issues, add your Signed-off-by and submit in two separate emails.
> >   
> At the moment I update my system to the 2.6.25 kernel. When everything works
> fine, I submit the reworked
> patches the next days.

How is this going? Do you have your patches ready? We have a few patches 
brewing from sveral people, that touch the same code as yours, so, it 
would be good to have your "move .power, .reset to camera-link" patch 
applied, then we could move on with the others.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
