Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54717 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab0BVNrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 08:47:43 -0500
Received: by bwz1 with SMTP id 1so1612848bwz.21
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 05:47:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B828939.4040708@redhat.com>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	 <1266838852.3095.20.camel@palomino.walls.org>
	 <4B827548.10005@redhat.com>
	 <829197381002220510v64f6e948pfb73ebe4fcc180af@mail.gmail.com>
	 <4B828939.4040708@redhat.com>
Date: Mon, 22 Feb 2010 08:47:41 -0500
Message-ID: <829197381002220547n3468019bmdb17f401f7c5b6e1@mail.gmail.com>
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

On Mon, Feb 22, 2010 at 8:40 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> I think that the control you want is V4L2_CID_GAIN.

I would have guessed the CID_GAIN control would have been responsible
for *luma* gain.  I could be wrong about that of course (but that is
what I believe people typically think of when they think of "gain" in
general).

>> I believe there probably are cases where extended controls are required,
>> but I believe just a general user control based on
>> V4L2_CID_PRIVATE_BASE should probably be able to work even with the
>> generic VIDIOC_S_CTRL
>>
>> I'm just asking because it would mean in order for v4l2-dbg to work
>> with my solution i would have to add support for extended controls in
>> general to the saa7115 driver, which shouldn't be necessary.
>
> The end objective is to have everybody implementing extended controls and
> removing the old controls, letting the V4L2 ioctl2 to convert a call to a
> simple control into an extended control callback. So, I think it would
> be worthy to implement extended control on saa7115.

Ok then.  I'll add the 15-20 lines of code which add the extended
controls mechanism to the 7115, which just operates as a passthrough
for the older control interface.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
