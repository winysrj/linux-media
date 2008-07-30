Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UAY6aS031892
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 06:34:06 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6UAXSBb027520
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 06:33:28 -0400
Date: Wed, 30 Jul 2008 12:33:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <4890357C.7050306@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0807301232080.26534@axis700.grange>
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
	<Pine.LNX.4.64.0807291909510.17188@axis700.grange>
	<48902011.7020609@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0807301005520.26534@axis700.grange>
	<48902CFF.9020204@teltonika.lt> <4890357C.7050306@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
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

On Wed, 30 Jul 2008, Stefan Herbrechtsmeier wrote:

> > > I think, yes, it would be useful to move .reset and .power now, as I said,
> > > I keep telling people "please keep in mind these fields are going to
> > > move", so, we shall really finally move them:-)
> > 
> > I am waiting for this also! Add me to the list :)
> > Currently I have mclk parameter for camera host driver... And I have to
> > set it frequently since I am playing with couple different sensors...
> My current version only touch the soc_camera files. Should I change the
> mt9m001 and mt9v022 sensor to use the new functions?

Yes, please. You also have to modify host camera drivers, don't you? There 
are 2 of them now: PXA and SH. Also, please, have a look if the 
platform camera driver also has to be changed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
