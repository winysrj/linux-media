Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab0BVNk2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 08:40:28 -0500
Message-ID: <4B828939.4040708@redhat.com>
Date: Mon, 22 Feb 2010 10:40:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andy Walls <awalls@radix.net>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	hverkuil@xs4all.nl,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Chroma gain configuration
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>	 <1266838852.3095.20.camel@palomino.walls.org>	 <4B827548.10005@redhat.com> <829197381002220510v64f6e948pfb73ebe4fcc180af@mail.gmail.com>
In-Reply-To: <829197381002220510v64f6e948pfb73ebe4fcc180af@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> Thanks everybody for the feedback.
> 
> On Mon, Feb 22, 2010 at 7:15 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> The issue with cx88 chips is that, with some video input sources, the
>> AGC over-saturates the color pattern. So, depending on the analog video
>> standard and the quality of the source (TV or Composite/Svideo), it gives
>> more reallistic colors with different AGC/saturation configuration.
> 
> I'm actually having the same issue with the saa7113.  I have a
> specific input source where I am getting too much chroma gain via the
> AGC, and need to disable it and manually turn it down a bit.
> 
> While I can use the V4L2_CID_CHROMA_AGC to disable the AGC, I still
> need to then adjust the value of the gain.  I guess I *could* reuse
> the saturation control, this time controlling the chroma gain register
> instead of the saturation register, it would seem to make more sense
> to have an explicit control, since the controls correspond to
> different registers and in theory could be controlled independently.
> 
> I guess at this point, I have three options:
> 
> 1.   Introduce a new user control
> 
> 2.  Use a private control
> 
> 3.  Reuse the saturation control (hacking the driver such that the
> saturation control pokes different registers depending on whether the
> AGC is enabled).

I don't like (2). 

That's said, we really need to take a closer look on those color gain
controls. We have already several controls that change color gain:

#define V4L2_CID_SATURATION             (V4L2_CID_BASE+2)
#define V4L2_CID_AUTOGAIN               (V4L2_CID_BASE+18)
#define V4L2_CID_GAIN                   (V4L2_CID_BASE+19)
#define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
#define V4L2_CID_AUTO_WHITE_BALANCE     (V4L2_CID_BASE+12)
#define V4L2_CID_DO_WHITE_BALANCE       (V4L2_CID_BASE+13)
#define V4L2_CID_RED_BALANCE            (V4L2_CID_BASE+14)
#define V4L2_CID_BLUE_BALANCE           (V4L2_CID_BASE+15)
#define V4L2_CID_WHITE_BALANCE_TEMPERATURE      (V4L2_CID_BASE+26)

The map of the above controls are not uniform along the drivers, and the API
is not clear enough about what is expected on each of the above controls.

For example, on some drivers (mostly webcam ones), the red/blue balance as used as 
"red/blue gain", and not as balance.

I remember we've started some discussions about this with some DaVinci patches,
but we never finished those discussions.

I think that the control you want is V4L2_CID_GAIN.
> 
> On a related note, has anyone noticed that the v4l2-dbg tool appears
> to always insist on using the "extended controls ioctl" for any
> attempts to set private controls?  This doesn't seem right to me.

I agree.

> I believe there probably are cases where extended controls are required,
> but I believe just a general user control based on
> V4L2_CID_PRIVATE_BASE should probably be able to work even with the
> generic VIDIOC_S_CTRL
> 
> I'm just asking because it would mean in order for v4l2-dbg to work
> with my solution i would have to add support for extended controls in
> general to the saa7115 driver, which shouldn't be necessary.

The end objective is to have everybody implementing extended controls and
removing the old controls, letting the V4L2 ioctl2 to convert a call to a
simple control into an extended control callback. So, I think it would
be worthy to implement extended control on saa7115.


Cheers,
Mauro
