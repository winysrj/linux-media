Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58270 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1ECMtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 08:49:45 -0400
Received: by eyx24 with SMTP id 24so9453eyx.19
        for <linux-media@vger.kernel.org>; Tue, 03 May 2011 05:49:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105022331.29142.hverkuil@xs4all.nl>
References: <E1QGwlS-0006ys-15@www.linuxtv.org>
	<201105022202.57946.hverkuil@xs4all.nl>
	<BANLkTinzrccpQHk1qrDyT6VbfTPVBCGKkQ@mail.gmail.com>
	<201105022331.29142.hverkuil@xs4all.nl>
Date: Tue, 3 May 2011 08:49:43 -0400
Message-ID: <BANLkTinjYo0zW56+vEMDciXkdk9gePOZnQ@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw
 YUV video capture
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, May 2, 2011 at 5:31 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> It's also a good idea if the author of a patch pings the list if there
> has been no feedback after one or two weeks. It's easy to forget patches,
> people can be on vacation, be sick, or in the case of Andy, have a family
> emergency.

In principle I agree with you, and I was actually surprised to hear it
was merged.  That said, what's done is done so we need to focus on
where to go from here.

>> Likewise, I know there have indeed been cases in the past where code
>> got upstream that caused regressions (in fact, you have personally
>> been responsible for some of these if I recall).
>>
>> Let's not throw the baby out with the bathwater.  If there are real
>> structural issues with the patch, then let's get them fixed.  But if
>> we're just talking about a few minor "unused variable" type of
>> aesthetic issues, then that shouldn't constitute reverting the commit.
>>  Do your review, and if an additional patch is needed with a half
>> dozen removals of dead/unused code, then so be it.
>
> Well, one structural thing I am not at all happy about (but it is Andy's
> call) is that it uses videobuf instead of vb2. Since this patch only deals
> with YUV it shouldn't be hard to use vb2. The problem with videobuf is that
> it violates the V4L2 spec in several places so I would prefer not to use
> videobuf in cx18. If only because converting cx18 to vb2 later will change
> the behavior of the stream I/O (VIDIOC_REQBUFS in particular), which is
> something I would like to avoid if possible.
>
> I know that Andy started work on vb2 in cx18 for all stream types (not just
> YUV). I have no idea of the current state of that work. But it might be a
> good starting point to use this patch and convert it to vb2. Later Andy can
> add vb2 support for the other stream types.

Sure Hans.  Let me just dig into my collection of 30+ products and
grab one that has already been converted to VB2 which I can use as a
reference for porting.  Should be simple enough...

cx88: nope
cx23885: nope
cx18: nope
ivtv: nope
em28xx: nope
au0828: nope
pvrusb2: nope
cx231xx: nope
saa7134: nope
saa7164: nope
tm6010: nope
dib0700: nope
bttv: nope

Oh wait, you mean that there aren't *any* non-embedded drivers that
currently implement VB2?  Vivi is the *only* example, and it's not
even real hardware so who knows what issues with the architecture we
might run into?

And exactly what real-world applications has VB2 been validated
against?  Any apps that aren't just a test harness or written by an
SOC vendor making it work against their one piece of embedded
hardware?  Any consumer apps?  Mplayer?  VLC?  Kaffeine?  tvtime?
XawTV?  MeTV?  MythTV?

VB2 may be the future of buffering models and it may actually be
better in the long-run, but if you want to see adoption outside of the
SOC space then you need to prove that it works against real hardware
that isn't an SOC, and demonstrate that it doesn't cause regressions
in real-world applications that people are using today.

Let's talk about what's going to happen in the real world:  the first
guy who actually ports one of the above drivers to VB2 is going to run
into bugs.  He's going to have to work with you to shake out those
bugs.  And it wouldn't surprise me if it exposes some bugs in some
existing applications, which are going to have to be fixed too.  In
the end we'll eventually end up in a better situation, but the cost
will be non-trivial and it will be incurred by people who don't really
give a damn about VB2 since it has little end-user visible benefit.

If you had ported any of the above drivers to the VB2 framework and
demonstrated that it works with existing applications without
modifications, then I think everybody here would breathe much easier.
But the current state today is "experimental, not implemented in any
consumer products or validated in any real-world usage outside of
SOC".

Asking us to be the "guinea pig" for this new framework just because
cx18 is the most recent driver to get a videobuf related patch just
isn't appropriate.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
