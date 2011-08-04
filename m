Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:33338 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab1HDTAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 15:00:54 -0400
Date: Thu, 4 Aug 2011 14:05:49 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Jean-Francois Moine <moinejf@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <20110804184020.6edb96d8@tele>
Message-ID: <alpine.LNX.2.00.1108041358050.17533@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108031418480.16384@banach.math.auburn.edu> <4E39B150.40108@redhat.com> <4E3A84F0.5050208@redhat.com> <4E3A9332.1060404@redhat.com> <20110804184020.6edb96d8@tele>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 4 Aug 2011, Jean-Francois Moine wrote:

> On Thu, 04 Aug 2011 09:40:18 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > > What we need for this is a simple API (new v4l ioctl's I guess) for the
> > > stillcam mode of these dual mode cameras (stillcam + webcam). So that the
> > > webcam drivers can grow code to also allow access to the stored pictures,
> > > which were taken in standalone (iow not connected to usb) stillcam mode.
> > > 
> > > This API does not need to be terribly complex. AFAIK all of the currently
> > > supported dual cam cameras don't have filenames only picture numbers,
> > > so the API could consist of a simple, get highest picture nr, is picture
> > > X present (some slots may contain deleted pictures), get picture X,
> > > delete picture X, delete all API.  
> > 
> > That sounds to work. I would map it on a way close to the controls API
> > (or like the DVB FE_[GET|SET]_PROPERTY API), as this would make easier to expand
> > it in the future, if we start to see webcams with file names or other things
> > like that.
> 
> I did not follow all the thread, but I was wondering about an other
> solution: what about offering both USB mass storage and webcam accesses?
> 
> When a dual-mode webcam is plugged in, the driver creates two devices,
> the video device /dev/videox and the volume /dev/sdx. When the webcam is
> opened, the volume cannot be mounted. When the volume is mounted, the
> webcam cannot be opened. There is no need for a specific API. As Mauro
> said:
> 
> > For those, we may eventually need some sort of locking between
> > the USB storage and V4L.
> 
> That's all. By where am I wrong?

Jean-Francois,

This idea seems to me basically on track. There is only one small problem 
with it, in the details:

As far as I know, /dev/sdx signifies a device which is accessible by 
something like the USB mass storage protocols, at the very least. So, if 
that fits the camera, fine. But most of the cameras in question are Class 
Proprietary. Thus, not in any way standard mass storage devices. Then it 
is probably better not to call the new device by that name unless that 
name really fits. Probably, it would be better to have /dev/cam or 
/dev/stillcam, or something like that.

Theodore Kilgore
