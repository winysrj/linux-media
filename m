Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49896 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752390AbZFLG36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 02:29:58 -0400
Date: Fri, 12 Jun 2009 08:30:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 3/4] soc-camera: add support for camera-host controls
In-Reply-To: <5e9665e10906111853w1af3aec9wcf647a280d3635e7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0906120820450.4843@axis700.grange>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
 <Pine.LNX.4.64.0906101604420.4817@axis700.grange>
 <5e9665e10906110410w7893e016g6e35742c9a55889d@mail.gmail.com>
 <Pine.LNX.4.64.0906111413250.5625@axis700.grange>
 <5e9665e10906111853w1af3aec9wcf647a280d3635e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 12 Jun 2009, Dongsoo, Nathaniel Kim wrote:

> Hello Guennadi,
> 
> So let's assume that camera interface device can process
> V4L2_CID_SHARPNESS and even external camera device can process that,
> then according to your patch both of camera interface and external
> camera device can be issued to process V4L2_CID_SHARPNESS which I
> guess will make image sharpened twice. Am I getting the patch right?

Please, do not top-post!

I am sorry, is it really so difficult to understand

> >> > +               ret = ici->ops->set_ctrl(icd, ctrl);
> >> > +               if (ret != -ENOIOCTLCMD)
> >> > +                       return ret;

which means just one thing: the camera host (interface if you like) driver 
decides, whether it wants client's control to be called, in which case it 
has to return -ENOIOCTLCMD, or it returns any other code (0 or a negative 
error code), then the client will not be called.

> If I'm getting right, it might be better to give user make a choice
> through platform data or some sort of variable which can make a choice
> between camera interface and camera device to process the CID. It
> could be just in aspect of manufacturer mind, we do love to make a
> choice between same features in different devices in easy way. So
> never mind if my idea is not helpful making your driver elegant :-)

So far it seems too much to me. Let's wait until we get a case where it 
really makes sense for platform code to decide who processes certain 
controls. I think giving the host driver the power to decide should be ok 
for now.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
