Return-path: <mchehab@pedra>
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:45240 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485Ab1ECJDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 05:03:51 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw YUV video capture
Date: Tue, 3 May 2011 10:03:39 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
References: <E1QGwlS-0006ys-15@www.linuxtv.org> <201105022111.40604.hverkuil@xs4all.nl> <4DBF0791.5070805@redhat.com>
In-Reply-To: <4DBF0791.5070805@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031003.40086.simon.farnsworth@onelan.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 2 May 2011, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em 02-05-2011 16:11, Hans Verkuil escreveu:
> > NACK.
> > 
> > For two reasons: first of all it is not signed off by Andy Walls, the
> > cx18 maintainer. I know he has had other things on his plate recently
> > which is probably why he hasn't had the chance to review this.
> > 
> > Secondly, while doing a quick scan myself I noticed that this code does a
> > conversion from UYVY format to YUYV *in the driver*. Format conversion is
> > not allowed in the kernel, we have libv4lconvert for that. So at the
> > minimum this conversion code must be removed first.
> 
> Patch is there at the ML since Apr, 6 and nobody acked/nacked it. If you or
> andy were against it, why none of you commented it there?
> 
> Now that the patch were committed, I won't revert it without a very good
> reason.
> 
> With respect to the "conversion from UYVY format to YUYV", a simple patch
> could fix it, instead of removing the entire patchset.
> 
> Steven/Simon,
> could you please work on such change?
> 
I received feedback, which I've been working on, and have converted to a new 
patch against the baseline tree without this patch applied. I can obviously 
rebase (thanks, git!) so that it applies on top of this patch. It massively 
cleans up the code, fixes a bug, and removes the in-kernel format conversion 
(we use libv4l here anyway, so it's not needed)

I have one more work item, requested by Andy and Hans, and that's to convert 
just the YUV capture from videobuf to vb2, so that when Andy's got spare time 
again, it'll be easier for him to convert the whole driver. I've been delayed 
on this by other work committments, but I do have this on my schedule.

How do you want me to proceed?
-- 
Simon Farnsworth
Software Engineer
ONELAN Limited
http://www.onelan.com/
