Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35715 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751652AbZDPM7S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 08:59:18 -0400
Date: Thu, 16 Apr 2009 14:59:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 5/5] soc-camera: Convert to a platform driver
In-Reply-To: <5e9665e10904160548y410dc680u175a50f96b5c4d7c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904161454300.4947@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
 <Pine.LNX.4.64.0904151403500.4729@axis700.grange>
 <5e9665e10904151919p50c695e2s35140402d2c7345c@mail.gmail.com>
 <Pine.LNX.4.64.0904161032050.4947@axis700.grange>
 <5e9665e10904160300k7e581910r73710d8ffe5230a8@mail.gmail.com>
 <Pine.LNX.4.64.0904161214200.4947@axis700.grange>
 <5e9665e10904160409n26ecec11n89569b33d4797c6c@mail.gmail.com>
 <Pine.LNX.4.64.0904161328420.4947@axis700.grange>
 <5e9665e10904160548y410dc680u175a50f96b5c4d7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 16 Apr 2009, Dongsoo, Nathaniel Kim wrote:

> Hello Guennadi,
> 
> On Thu, Apr 16, 2009 at 9:06 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > 3. you open videoX, one "default" camera gets activated immediately - not
> > all applications issue S_INPUT, so, there has to be a default.
> > 4. if an S_INPUT is issued, you have to verify, whether any camera is
> > currently active / capturing, if none - switch to the requested one, if
> > one is active - return -EBUSY.
> > 5. reference-counting and guaranteeing consistency is more difficult, as
> > well as handling camera driver loading / unloading.
> 
> Oops I forgot to say that we need to enforce legacy v4l2 applications
> to use VIDIOC_S_INPUT  after opening device.
> And every S_INPUT issuing should come after G_INPUT like every "set"
> API in v4l2.

Hm? Does the API require it? If not, I don't think we should inforce it. 
And what do you mean "legacy v4l2 applications" - which applications are 
not "legacy"?

> > So, I would say, your approach adds complexity and asymmetry. Can it be
> > that one camera client has several inputs itself? E.g., a decoder? In any
> > case, I wouldn't do this now, if we do decide in favour of your approach,
> > then only after the v4l2-device transition, please.
> >
> 
> Of course. I didn't mean to disturb your transition job. Please do
> your priority job first.
> 
> And about camera client with several inputs question, I will say that
> almost every 3G UMTS phone has dual camera on it. And we can consider
> every 3G UMTS smart phones have dual camera on it with soc camera
> solution.

No, sorry, this wasn't my question. By "client" I meant one camera or 
decoder or whatever chip connects to a camera host. I.e., if we have a 
single chip with several inputs, that should logically be handled with 
S_INPUT ioctl, this would further add to the confusion of using different 
inputs on one video device to switch between chips or inputs / functions 
on one chip.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
