Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64246 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0BVNKD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 08:10:03 -0500
Received: by bwz1 with SMTP id 1so1584408bwz.21
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 05:10:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B827548.10005@redhat.com>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	 <1266838852.3095.20.camel@palomino.walls.org>
	 <4B827548.10005@redhat.com>
Date: Mon, 22 Feb 2010 08:10:00 -0500
Message-ID: <829197381002220510v64f6e948pfb73ebe4fcc180af@mail.gmail.com>
Subject: Re: Chroma gain configuration
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@radix.net>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	hverkuil@xs4all.nl,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks everybody for the feedback.

On Mon, Feb 22, 2010 at 7:15 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The issue with cx88 chips is that, with some video input sources, the
> AGC over-saturates the color pattern. So, depending on the analog video
> standard and the quality of the source (TV or Composite/Svideo), it gives
> more reallistic colors with different AGC/saturation configuration.

I'm actually having the same issue with the saa7113.  I have a
specific input source where I am getting too much chroma gain via the
AGC, and need to disable it and manually turn it down a bit.

While I can use the V4L2_CID_CHROMA_AGC to disable the AGC, I still
need to then adjust the value of the gain.  I guess I *could* reuse
the saturation control, this time controlling the chroma gain register
instead of the saturation register, it would seem to make more sense
to have an explicit control, since the controls correspond to
different registers and in theory could be controlled independently.

I guess at this point, I have three options:

1.   Introduce a new user control

2.  Use a private control

3.  Reuse the saturation control (hacking the driver such that the
saturation control pokes different registers depending on whether the
AGC is enabled).

On a related note, has anyone noticed that the v4l2-dbg tool appears
to always insist on using the "extended controls ioctl" for any
attempts to set private controls?  This doesn't seem right to me.  I
believe there probably are cases where extended controls are required,
but I believe just a general user control based on
V4L2_CID_PRIVATE_BASE should probably be able to work even with the
generic VIDIOC_S_CTRL.

I'm just asking because it would mean in order for v4l2-dbg to work
with my solution i would have to add support for extended controls in
general to the saa7115 driver, which shouldn't be necessary.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
