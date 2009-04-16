Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60669 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752902AbZDPO4E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 10:56:04 -0400
Date: Thu, 16 Apr 2009 16:56:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dongsoo Kim <dongsoo.kim@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 5/5] soc-camera: Convert to a platform driver
In-Reply-To: <2D5C734C-80B1-4A19-881A-BAF02E1A5231@gmail.com>
Message-ID: <Pine.LNX.4.64.0904161650360.4947@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
 <Pine.LNX.4.64.0904151403500.4729@axis700.grange>
 <5e9665e10904151919p50c695e2s35140402d2c7345c@mail.gmail.com>
 <Pine.LNX.4.64.0904161032050.4947@axis700.grange>
 <5e9665e10904160300k7e581910r73710d8ffe5230a8@mail.gmail.com>
 <Pine.LNX.4.64.0904161214200.4947@axis700.grange>
 <5e9665e10904160409n26ecec11n89569b33d4797c6c@mail.gmail.com>
 <Pine.LNX.4.64.0904161328420.4947@axis700.grange>
 <5e9665e10904160548y410dc680u175a50f96b5c4d7c@mail.gmail.com>
 <Pine.LNX.4.64.0904161454300.4947@axis700.grange> <2D5C734C-80B1-4A19-881A-BAF02E1A5231@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 16 Apr 2009, Dongsoo Kim wrote:

> > > And about camera client with several inputs question, I will say that
> > > almost every 3G UMTS phone has dual camera on it. And we can consider
> > > every 3G UMTS smart phones have dual camera on it with soc camera
> > > solution.
> > 
> > No, sorry, this wasn't my question. By "client" I meant one camera or
> > decoder or whatever chip connects to a camera host. I.e., if we have a
> > single chip with several inputs, that should logically be handled with
> > S_INPUT ioctl, this would further add to the confusion of using different
> > inputs on one video device to switch between chips or inputs / functions
> > on one chip.
> 
> Yes exactly. It was  "single chip with several inputs." that I intended to
> tell. but still don't get what the confusion you mean. Sorry ;-()
> Cheers,

Wow, so, on those phone a "dual camera" is a single (CMOS) controller with 
two sensors / lenses / filters?... Cool, do you have an example of such a 
camera to look for on the net? Preferably with a datasheet available.

"Confusion" I meant that in this case switching between inputs sometimes 
switches you to another controller and sometimes to another function 
within the same controller...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
