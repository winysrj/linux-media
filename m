Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:39067 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760488AbZEATcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2009 15:32:36 -0400
Subject: Re: Donating a mr97310 based elta-media 8212dc (0x093a:0x010e)
From: hermann pitton <hermann-pitton@arcor.de>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-media@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0905011224330.23299@banach.math.auburn.edu>
References: <20090430022847.GA15183@pengutronix.de>
	 <alpine.LNX.2.00.0904300953330.21567@banach.math.auburn.edu>
	 <20090501084729.GB6941@pengutronix.de>
	 <alpine.LNX.2.00.0905011224330.23299@banach.math.auburn.edu>
Content-Type: text/plain
Date: Fri, 01 May 2009 21:30:52 +0200
Message-Id: <1241206252.3717.36.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Am Freitag, den 01.05.2009, 12:40 -0500 schrieb Theodore Kilgore:
> 
> On Fri, 1 May 2009, Wolfram Sang wrote:
> 
> > Hi Theodore,
> >
> >> know where he lives) then perhaps to Thomas Kaiser, who lives a bit
> >> closer to you. I think that all three of us are equally interested but as
> >
> > Well, looks like I will send it to Thomas then. I'm glad that it can still be
> > useful.
> 
> I am glad that this is so easily resolved. As I said, I do not know where 
> Kyle lives. If he is somewhere like UK then it would have been possible to 
> get it to him easily, too. But if he is in the US, like me, then it seems 
> that sending the camera for such a distance would simply be impractical.
> 
> >
> >> Judging from the Vendor:Product number which you report, it is one of the
> >> small MR97310 cameras for which the OEM driver was called the "CIF"
> >> driver. Indeed, these cameras are not supported right now, so the matter
> >> is interesting.
> 
> I meant, not supported for streaming. The camera ought to be well 
> supported as a still camera.
> 
> >
> > I tried simply adding the usb-id to the list in mr97310a.c, but as that didn't
> > produce anything useful (green screen), I thought I'll leave it to the pros :)
> 
> Heh. No, that is not enough. Been there. Done that.
> 
> 
> <snip>
> 
> >> Finally, I would ask one question:
> >>
> >> In the libgphoto2 driver for these cameras, I have a listing for
> >>
> >> {"Elta Medi@ digi-cam", GP_DRIVER_STATUS_EXPERIMENTAL, 0x093a, 0x010e},
> >>
> >> Do you think this is the same camera, or a different one? Yours has a
> >
> > I am pretty sure this is the same camera. "elta medi@ digi-cam" is printed on
> > the front-side. The model number "8212DC" is just on a glued label on the
> > down-side which may not be present on all charges or may have been removed or
> > got lost somehow. I could make pictures of the cam if this helps.
> 
> I have the impression you sent another mail, now, with the picture. I have 
> not looked at the picture, actually. But the picture would probably not 
> help me at all, because I myself have never seen one of these cameras. 
> What I know about the camera is well summarized in the following entry 
> from libgphoto2/camlibs/mars/ChangeLog:
> 
> 2004-10-26  Theodore Kilgore <kilgota@auburn.edu>
>          * library.c: ID for Haimei HE-501A, reported by
>                       Scott MacKenzie <irrational@poboxes.com>
>                       ID for Elta Medi@ digicam, reported by
>                       Nils Naumann, <nau@gmx.net>
>                       Support patch submitted by Scott, tested by Nils.
>          * mars.c:    Scott's patch applied.
>          * protocol.txt: byte codes for new 352x288 and 176x144 resolution
>                          settings recorded; section "UPDATES and REVISIONS" 
> added.
> 
> This is the total extent of my knowledge. It does seem, judging from the 
> address of the person who sent me the information about it, and from 
> yours, that the Elta brand is probably local to Europe.

for elta GmbH,

they are originally located in Germany and have a quite good reputation
for fancy lifestyle products, many imported from Asia, these days mostly
China, but started with quality products from Japan.

One of the services they also offer is to create new brands of products
for customers, coordinated over elta Hong Kong, which includes proper
package design, two years warranty and a readable user manual ;)

I have an early appearance of the saa7134 chip as elta medi@ 8682 LV
LifeView FlyVideo 3000 with remote and maybe the first TCL tuner seen
here. Copyright and Trademark Notice in the user manual.
(C) 2001 by Animations Technologies Inc. for this one.

Can be found searching for Elta at the www.bttv-gallery.de.

You can find all contact information for elta here.

http://www.elta.de

> Finally, one of the main reasons why I pass this on is to point out that 
> especially in the cheap camera market there is lots of stuff out there 
> which just has a name painted on a case, or the case looks kind of weird 
> (shaped like a plastic dog, dragon, or squishy toy, attached to a pair of 
> sunglasses as a "spy camera" or whatever) and the electronics inside is 
> indistinguishable from 20 or 30 other devices, which do not come from the 
> same "manufacturer" and may not even have a similar appearance, at all. Do 
> I know all the Mars CIF cameras which have the USB ID of 0x093a:0x010e ?
>   Almost certainly, I do not. Unfortunately, without the cooperation of the 
> manufacturers of these devices that is practically impossible. Therefore 
> let us pray that this non-cooperation somehow will get changed.
> 
> Theodore Kilgore

Cheers,
Hermann


