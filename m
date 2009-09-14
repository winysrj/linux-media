Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50598 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933932AbZINUak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 16:30:40 -0400
Date: Mon, 14 Sep 2009 22:30:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Vasut <marek.vasut@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: V4L2: Add a v4l2-subdev (soc-camera) driver for OmniVision OV9640
 sensor
In-Reply-To: <200909142202.46154.marek.vasut@gmail.com>
Message-ID: <Pine.LNX.4.64.0909142211120.4359@axis700.grange>
References: <200908220850.07435.marek.vasut@gmail.com>
 <200909141829.55485.marek.vasut@gmail.com> <Pine.LNX.4.64.0909142128020.4359@axis700.grange>
 <200909142202.46154.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Sep 2009, Marek Vasut wrote:

> Dne Po 14. září 2009 21:29:26 Guennadi Liakhovetski napsal(a):
> > From: Marek Vasut <marek.vasut@gmail.com>
> > 
> > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > Marek, please confirm, that this version is ok. I'll push it upstream for
> > 2.6.32 then.
> 
> No, it's not OK. You removed the RGB part. Either enclose those parts into ifdef 
> OV9640_RGB_BUGGY or preserve it in some other way. Someone will certainly want 
> to re-add RGB parts later and will have to figure it out all over again.

Ok, make a proposal, how you would like to see it. But - I do not want 
commented out code, including "#ifdef MACRO_THAT_DOESNT_GET_DEFINED." I 
think, I described it in sufficient detail, so that re-adding that code 
should not take longer than 10 minutes for anyone sufficiently familiar 
with the code. Referencing another driver also has an advantage, that if 
we switch to imagebus or any other API, you don't get stale commented out 
code, but you look up updated code in a functional driver. But I am open 
to your ideas / but no commented out code, please.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
